#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"
 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AGWKF23   � Autor � REINALDO MAGALHAES � Data �  21/11/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Resumo Caixa.                                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AGWKF23
  Local cUser := "", cPass := "", cSendSrv := ""
  Local cEmail := "", cMsgA := "", aData := ""
  Local nSendPort := 0, nSendSec:= 2, nTimeout := 0 //nSendSec := 1
  Local xRet
  Local oServer, oMessage

  Local nPos, nTotNotas, cQry,cRecISS,nValISS,nValTot,cBusca, cNomeCli, nTroco
  Local cCfPeca,cCfServ,cTesLoca,cCliPad,cDetDev,nPosAt
  
  Private aEntrada := {}
  Private aSaida   := {}
  Private aOutrNf  := {}
  Private aCancAut := {}
  
  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"
  ConOut("ENTROU!")  

  cCfPeca  := getmv("MV_CFPECA")
  cCfServ  := getmv("MV_CFSERV")
  cTesLoca := getmv("MV_TESLOCA")
  cCliPad  := getmv("MV_CLIPAD")

  mv_par01:= Date() //- Do Fechamento    ?
  mv_par02:= Date() //- Ate o Fechamento ?
  mv_par03:= "C08"  //- Do Caixa         ?
  mv_par04:= "C08"  //- Ate o Caixa      ?

  //��������������������������������Ŀ
  //� Vendas Agropisco via ECF      �
  //���������������������������������
  dbSelectArea("SL1")
  
  // SL1->(dbSetOrder(4))  // Filial + Data ECF + PDV + Operado
  U_MsSetOrder("SL1","L1_FILIAL+DtoS(L1_EMISSAO)")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima
  SL1->(dbSeek(xFilial()+Dtos(mv_par01)))
  
  Do While !SL1->(Eof()) .And. SL1->L1_FILIAL == xFilial("SL1") .And. SL1->L1_EMISSAO <= mv_par02
     If SL1->L1_OPERADO < mv_par03 .Or. SL1->L1_OPERADO > mv_par04 .Or. Empty(SL1->L1_DOC)     
        SL1->(dbSkip())
        Loop
     Endif                                                                                    
     //              1     2      3       4      5     6     7      8     9      10        11      12    13  14
     //           Cliente/Prf/Dinheiro/Cheque/Debito/Amex/Redecard/Visa/Boleto/Dep.CC/Funcionario/Total/Historico
     AADD(aEntrada,{"","",0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 , 0.00, 0.00, 0.00, "", "" })
     
     nPos:= Len(aEntrada)
     
     If SL1->L1_CLIENTE == cCliPad // Se for cliente padrao. 
        If Empty(SL1->L1_CGCCLI)                                
           aEntrada[nPos,1] := Padr("CONSUMIDOR S/ CPF",20) 
        Else   
           aEntrada[nPos,1] := Padr("CPF:"+Substr(SL1->L1_CGCCLI,1,14),20)
        Endif   
     Else
        aEntrada[nPos,1] := Padr(Posicione("SA1",1,xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA,"A1_NREDUZ"),20)
     Endif   
     aEntrada[nPos,2] := SL1->L1_SERIE+" "+SL1->L1_DOC 
     aEntrada[nPos,12]:= SL1->L1_VLRTOT 
     aEntrada[nPos,14]:= Padr(Posicione("SF2",1,xFilial("SF2")+SL1->(L1_DOC+L1_SERIE),"F2_NFCUPOM"),12)

     //- Recebimentos
     RecLoja(nPos)

     dbSelectArea("SL1")
     SL1->(dbSkip())
  Enddo      

  //������������������������������������������������Ŀ
  //� Verificando as vendas feitas pelo faturamento �
  //������������������������������������������������� 
  cQry := "SELECT COUNT(*)TOTAL "
  cQry += "FROM "+RetSQLName("SD2")+" SD2 "
  cQry += "WHERE D2_FILIAL = '"+XFILIAL("SD2")+"' AND " 
  cQry += "D2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' AND " 
  cQry += "D2_TIPO ='N' AND D2_PEDIDO <> ' ' AND SD2.D_E_L_E_T_ <> '*' "
  cQry += "AND ((D2_CF = '"+cCfPeca+"' "
  cQry += "OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
  cQry += "OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
  cQry += "OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933' OR D2_CF = '5404' OR D2_CF = '6404' OR D2_CF = '5405' OR D2_CF = '6405' OR D2_CF = '5119' OR D2_CF = '6119')"
  cQry += "GROUP BY D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA"
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )  
  nTotNotas := TRB->TOTAL
  TRB->(dbCloseArea())
  
  cQry := "SELECT DISTINCT D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_PEDIDO "
  cQry += "FROM "+RetSQLName("SD2")+" SD2 "                               
  cQry += "WHERE D2_FILIAL = '"+XFILIAL("SD2")+"' AND " 
  cQry += "D2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' AND " 
  cQry += "D2_TIPO ='N' AND D2_PEDIDO <> ' ' AND SD2.D_E_L_E_T_ <> '*' "
  cQry += "AND ((D2_CF = '"+cCfPeca+"' "
  cQry += "OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
  cQry += "OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
  cQry += "OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933' OR D2_CF = '5404' OR D2_CF = '6404' OR D2_CF = '5405' OR D2_CF = '6405' OR D2_CF = '5119' OR D2_CF = '6119')"
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )  
                             
  TRB->(Dbgotop())
  
  Do While !TRB->(Eof())
     
     //    1      2     3      4      5     6     7       8     9     10         11      12    13  14
     // Cliente/Prf/Dinheiro/Cheque/Debito/Amex/Redecard/Visa/Boleto/Dep.CC/Funcionario/Total/Historico
     AADD(aEntrada,{"","",0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 , 0.00, 0.00, 0.00, "", "" })
     
     nPos:= Len(aEntrada)
                                                      
     cRecISS:= Posicione("SA1",1,xFilial("SA1")+TRB->(D2_CLIENTE+D2_LOJA),"A1_RECISS")
     nValTot:= Posicione("SF2",1,xFilial("SF2")+TRB->(D2_DOC+D2_SERIE),"F2_VALBRUT")
     nValISS:= Posicione("SF2",1,xFilial("SF2")+TRB->(D2_DOC+D2_SERIE),"F2_VALISS") 
     
     aEntrada[nPos,1] := Padr(Posicione("SA1",1,xFilial("SA1")+TRB->(D2_CLIENTE+D2_LOJA),"A1_NREDUZ"),20)
     aEntrada[nPos,2] := TRB->D2_SERIE+" "+TRB->D2_DOC 
     aEntrada[nPos,12]:= If(cRecISS="1",nValTot - nValISS, nValTot)  
     aEntrada[nPos,14]:= "PV"+TRB->D2_PEDIDO

     //- Recebimentos
     RecFatura(nPos)

     dbSelectArea("TRB")
     
     TRB->(dbSkip()) 
     
  Enddo      
  dbSelectArea("TRB")
  TRB->(dbCloseArea())
  
  If Len(aEntrada)=0 
     //             1   2  3     4     5     6     7     8     9      10    11    12   13  14
     AADD(aEntrada,{"","",0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 , 0.00, 0.00, 0.00, "", "" })
  Endif
  
  //����������������������������������������Ŀ
  //� Recebimento de outros valores em caixa �
  //�����������������������������������������
  nTroco:= 0.00
  
  dbSelectArea("SE5")
  
  //SE5->(dbSetOrder(1)) // Filial + Data + Banco
  U_MsSetOrder("SE5","E5_FILIAL+DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima    
  SE5->(dbSeek(xFilial()+Dtos(mv_par01)))
  
  Do While !SE5->(Eof()) .and. SE5->E5_FILIAL == xFilial("SE5") .and. SE5->E5_DATA <= mv_par02
     If SE5->E5_BANCO < mv_par03 .or. SE5->E5_BANCO > mv_par04 .or. SE5->E5_SITUACA $ "C#X#E"
        SE5->(dbSkip())
        Loop
     Endif                                                                
     If Trim(SE5->E5_NATUREZ) $ "TROCO" .And. SE5->E5_RECPAG = "R"
        nTroco += SE5->E5_VALOR
     Endif
       
     If Trim(SE5->E5_NATUREZ) $ "SANGRIA#TROCO" .Or. SE5->E5_RECPAG <> "R" .Or. !(SE5->E5_TIPODOC$"VL") // .Or. !(SE5->E5_TIPODOC$"VL#MT#JR")
        SE5->(dbSkip())
        Loop
     Endif
     
     //����������������������������������������������������Ŀ
     //� Verificando se a baixa foi no mesmo dia da venda. �
     //�����������������������������������������������������
     cBusca:= SE5->(E5_CLIFOR+E5_LOJA+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) 
     
     //SE1->(DbSetOrder(2)) //- Filial+Loja+Prefixo+Numero+Parcela+Tipo
     U_MsSetOrder("SE1","E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima            
     SE1->(DbSeek(xFilial("SE1")+cBusca))

     If SE5->E5_DATA == SE1->E1_EMISSAO   
        SE5->(dbSkip())
        Loop
     Endif
  
     nPos:= Ascan(aEntrada,{|x| x[2] == Padr(SE5->E5_DOCUMEN,10) })
     If nPos = 0     
        //    1     2     3       4       5     6       7       8    9      10        11       12     13
        // Cliente/Prf/Dinheiro/Cheque/Debito/Dinner/Redecard/Visa/Boleto/Dep.CC/Funcionario/Total/Historico
        AADD(aEntrada,{"", "", 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 , 0.00, 0.00, 0.00, "", "" })
        nPos:= Len(aEntrada)
     Endif   
     aEntrada[nPos,1] := Padr(SE5->E5_BENEF,20)
     aEntrada[nPos,2] := Iif (Empty(Padr(SE5->E5_DOCUMEN,10)), SE5->E5_PREFIXO+" "+SE5->E5_NUMERO, Padr(SE5->E5_DOCUMEN,10))
     aEntrada[nPos,13]:= SE5->E5_HISTOR
     aEntrada[nPos,12] += SE5->E5_VALOR

     If SE5->E5_MOEDA == "R$"     //- Dinheiro
        aEntrada[nPos,3]:= SE5->E5_VALOR
        
     Elseif SE5->E5_MOEDA == "CH" //- Cheque
        aEntrada[nPos,4]:= SE5->E5_VALOR
        
     Elseif SE5->E5_MOEDA == "CD" //- Cartao Debito
        aEntrada[nPos,5]:= SE5->E5_VALOR
        
     //Elseif SE5->E5_MOEDA == "D2" //- Amex
     //   aEntrada[nPos,6]:= SE5->E5_VALOR

     //Elseif SE5->E5_MOEDA == "D1" //- Credicard
     //   aEntrada[nPos,7]:= SE5->E5_VALOR

     //Elseif SE5->E5_MOEDA == "D3" //- Visa
     //   aEntrada[nPos,8]:= SE5->E5_VALOR

     Elseif SE5->E5_MOEDA == "FI" //- Boleto
        aEntrada[nPos,9]:= SE5->E5_VALOR
     
     Endif                                          
     SE5->(dbSkip())
  Enddo   
  If Len(aEntrada) > 0
     //    1     2     3       4      5      6     7      8     9     10        11        12      13
     // Cliente/Prf/Dinheiro/Cheque/Debito/Amex/Redecard/Visa/Boleto/Dep.CC/Funcionario/Total/Historico
     //AADD(aEntrada,{PADR("TOTAL",20),Space(10),0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 , 0.00, 0.00, 0.00, "", "" })
     AADD(aEntrada,{PADR("TOTAL",20),"ZZZZZZZZZZ",0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 , 0.00, 0.00, 0.00, "", "" })
  Endif   

  //������������������������������������������������������Ŀ
  //� Saidas no periodo - debitos / pagamentos / sangrias �
  //��������������������������������������������������������
  dbSelectArea("SE5")
  
  //SE5->(dbSetOrder(1)) // Filial + Data + Banco
  U_MsSetOrder("SE5","E5_FILIAL+DTOS(E5_DATA)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima    
  SE5->(dbSeek(xFilial()+Dtos(mv_par01)))
  
  Do While !SE5->(Eof()) .and. SE5->E5_FILIAL == xFilial() .and. SE5->E5_DATA <= mv_par02
     If SE5->E5_BANCO < mv_par03 .or. SE5->E5_BANCO > mv_par04 .or. SE5->E5_SITUACA == "C" // SE5->E5_SITUACA $ "C#X#E"
        SE5->(dbSkip())
        Loop
     Endif         

     cNat:= Trim(SE5->E5_NATUREZ) 

     If SE5->E5_RECPAG <> "P" .Or. Trim(cNat) $ "TROCO"
        SE5->(dbSkip())
        Loop
     Endif                                                                  
                                                
     If Trim(cNat) $ "SANGRIA"  
        AADD(aSaida,{SE5->E5_NUMCHEQ, PADR(SE5->E5_HISTOR,20), SE5->E5_VALOR, SE5->E5_MOEDA, cNat }) 
     Else
        AADD(aSaida,{SE5->E5_NUMERO, PADR(SE5->E5_BENEF,20), SE5->E5_VALOR, SE5->E5_MOEDA, cNat }) 
     Endif   
     SE5->(dbSkip())
  Enddo   

  //������������������������������Ŀ
  //� Outras opera��es de saidas  �
  //������������������������������� 
  cQry := "SELECT DISTINCT D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_PEDIDO "
  cQry += "FROM "+RetSQLName("SD2")+" SD2 "                               
  cQry += "WHERE D2_FILIAL = '"+XFILIAL("SD2")+"' AND " 
  cQry += "D2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' AND " 
  cQry += "D2_TIPO ='N' AND D2_PEDIDO <> ' ' AND SD2.D_E_L_E_T_ <> '*' "
  cQry += "AND D2_CF IN ('5949','6949','5910','6910','5916','6916') "
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )  
  
  Do While !TRB->(Eof())

     cNomeCli := Padr(Posicione("SA1",1,xFilial("SA1")+TRB->(D2_CLIENTE+D2_LOJA),"A1_NREDUZ"),20)
     nValTot  := Posicione("SF2",1,xFilial("SF2")+TRB->(D2_DOC+D2_SERIE),"F2_VALBRUT")
     
     AADD(aOutrNf,{TRB->D2_DOC, cNomeCli, nValTot, "01", "OUTR.SAIDA" })
  
     dbSelectArea("TRB")
     TRB->(dbSkip()) 
  Enddo      
  dbSelectArea("TRB")
  TRB->(dbCloseArea())

  //�����������������������������������Ŀ
  //� Cancelamentos automaticos SISTEMA �
  //�������������������������������������        
  cQry := "SELECT L1_DOC,L1_CLIENTE,L1_LOJA,L1_VLRTOT  "
  cQry += "FROM "+RetSQLName("SL1")+" SL1 "                               
  cQry += "WHERE D_E_L_E_T_ <> '*' AND L1_TIPO='V' "
  cQry += "AND L1_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' " 
  cQry += "AND L1_TIPO='V' "
  cQry += "AND L1_OPERADO=' ' "
 
  //cQry := "SELECT F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_VALBRUT "
  //cQry += "FROM "+RetSQLName("SF2")+" SF2 "                               
  //cQry += "WHERE F2_FILIAL = '"+XFILIAL("SF2")+"' AND " 
  //cQry += "F2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' AND " 
  //cQry += "F2_ESPECIE ='NFCE' AND SF2.D_E_L_E_T_ = '*' "
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )  
  
  Do While !TRB->(Eof())
     cNomeCli := Padr(Posicione("SA1",1,xFilial("SA1")+TRB->(L1_CLIENTE+L1_LOJA),"A1_NREDUZ"),20)
     nValTot  := TRB->L1_VLRTOT
     
     AADD(aCancAut,{TRB->L1_DOC, cNomeCli, nValTot, "01", "CANC.AUTOM" })
  
     dbSelectArea("TRB")
     TRB->(dbSkip()) 
  Enddo      
  dbSelectArea("TRB")
  dbCloseArea()

  //����������������������������������Ŀ
  //� Outras operacoes de entradas     �
  //������������������������������������ 
  DbSelectArea("SD1")                                                                                                                                                    
  
  U_MsSetOrder("SD1","D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima

  cQry := "SELECT F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_VALBRUT "
  cQry += "FROM "+RetSQLName("SF1")
  cQry += "WHERE D_E_L_E_T_=' ' AND "
  cQry += "F1_FILIAL = '"+XFILIAL("SF1")+"' AND "
  cQry += "F1_TIPO='D' AND "
  cQry += "F1_DTDIGIT BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' " 
		
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
		
  dbSelectArea("TRB")
  
  TRB->(dbGoTop())
                         
  cDetDev:="REF. "
  
  Do While !TRB->(EOF())
     
     cNomeCli:= Padr(Posicione("SA1",1,xFilial("SA1")+TRB->(F1_FORNECE+F1_LOJA),"A1_NREDUZ"),20)
     
     //������������������������������Ŀ
     //� Detalha itens da devolu��o  �
     //�������������������������������� 
     SD1->(dbSeek(xFilial("SD1")+TRB->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))  
     
     Do While !SD1->(Eof()) .And. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) = TRB->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
        nPosAt:= At(SD1->D1_NFORI, cDetDev) 
        If nPosAt = 0              
           cDetDev += SD1->D1_NFORI+"/"
        Endif
        SD1->(DbSkip())
     Enddo   
     
     DbSelectArea("TRB")
     
     AADD(aOutrNf,{TRB->F1_DOC, cNomeCli, TRB->F1_VALBRUT, "01", cDetDev }) 

	 TRB->(dbSkip())
  Enddo
  TRB->(dbCloseArea())
  
  cHtml := MontaEmail(nTroco) //- Fun��o de envio de email
  
  //���������������������������������������Ŀ
  //� Preparando dados para envio do email �
  //�����������������������������������������
  cUser := Trim(GetMv("MV_RELACNT")) 
  cPass := Trim(GetMv("MV_RELAPSW")) 
  cSendSrv := "br484.hostgator.com.br" //"email-ssl.com.br" 
  nTimeout := 60 // define the timout to 60 seconds
   
  oServer := TMailManager():New()
   
  oServer:SetUseSSL( .F. )
  oServer:SetUseTLS( .F. )
   
  If nSendSec == 0
    nSendPort := 25 //default port for SMTP protocol
  ElseIf nSendSec == 1
    nSendPort := 465 //default port for SMTP protocol with SSL
    oServer:SetUseSSL( .T. )
  Else
    nSendPort := 587 //default port for SMTPS protocol with TLS
    oServer:SetUseTLS( .T. )
  Endif
   
  // once it will only send messages, the receiver server will be passed as ""
  // and the receive port number won't be passed, once it is optional
  xRet := oServer:Init( "", cSendSrv, cUser, cPass, , nSendPort )
  If xRet != 0
     cMsg := "Could not initialize SMTP server: " + oServer:GetErrorString( xRet )
     conout( cMsg )
     Return
  Endif
   
  // the method set the timout for the SMTP server
  xRet := oServer:SetSMTPTimeout( nTimeout )
  If xRet != 0
    cMsg := "Could not set " + cProtocol + " timeout to " + cValToChar( nTimeout )
    conout( cMsg )
  Endif
   
  // estabilish the connection with the SMTP server
  xRet := oServer:SMTPConnect()
  If xRet <> 0
    cMsg := "Could not connect on SMTP server: " + oServer:GetErrorString( xRet )
    conout( cMsg )
    Return
  Endif
   
  // authenticate on the SMTP server (if needed)
  xRet := oServer:SmtpAuth( cUser, cPass )
  If xRet <> 0
    cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
    conout( cMsg )
    oServer:SMTPDisconnect()
    Return
  Endif

  //������������������������������Ŀ
  //� Preparando o envio do email  �
  //��������������������������������
  oMessage := TMailMessage():New()
  oMessage:Clear()
  oMessage:cDate := cValToChar( Date() )
  oMessage:cFrom := cUser 
  oMessage:cTo := Trim(GetMv("MV_EMAILCX")) //"reinaldo.magalhaes2014@gmail.com"
   
  oMessage:cBody := cHtml
  oMessage:MsgBodyType( "text/html" )
  oMessage:cSubject := "23-Resumo do Caixa C08 do dia: " + Dtoc(Date()) + " MOVIMENTO DAS "+Substr(Time(),1,5)+" hs"
  
  xRet := oMessage:Send( oServer )
  if xRet <> 0
    cMsg := "Could not send message: " + oServer:GetErrorString( xRet )
    conout( cMsg )
  endif
   
  xRet := oServer:SMTPDisconnect()
  if xRet <> 0
    cMsg := "Could not disconnect from SMTP server: " + oServer:GetErrorString( xRet )
    conout( cMsg )
  endif
 
  ConOut("SAIU!")
  RESET ENVIRONMENT

Return

//////////////////////////////
Static Function RecLoja(nPos)

  Local cCodCartao

  //SL4->(DbSetOrder(1))
  U_MsSetOrder("SL4","L4_FILIAL+L4_NUM+L4_ORIGEM")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima    
  SL4->(DbSeek(xFilial("SL4")+SL1->L1_NUM))
  
  Do While !SL4->(Eof()) .and. SL4->(L4_FILIAL+L4_NUM) == xFilial("SL4")+SL1->L1_NUM

     //- Dinheiro
     If AllTrim(SL4->L4_FORMA) $ "R$" 
        aEntrada[nPos,3] += IIF(!Empty(SL1->L1_PDV),SL4->L4_VALOR,SL4->L4_VALOR) //-SL4->L4_TROCO
                                          //Inibido por Marcel R. Grosselli data 27/03/09  
                                          //pois foi alterado o parametro que grava 
                                          //o Financeiro para que seja gravado o valor liquido da venda //- Dinheiro
     Endif       

     //- Cheque
     If AllTrim(SL4->L4_FORMA) $ "CH"
        aEntrada[nPos,4] += SL4->L4_VALOR  //- Cheque
     Endif   
  
     //- Boleto
     If AllTrim(SL4->L4_FORMA) $ "BO#FI"
        aEntrada[nPos,9] += SL4->L4_VALOR  //- Boleto
     Endif   

     //- Deposito C/C
     If AllTrim(SL4->L4_FORMA) $ "DP"
        aEntrada[nPos,10] += SL4->L4_VALOR //- Vales
     Endif   

     //- Cartao de credito/debito
     If AllTrim(SL4->L4_FORMA) $ "CC#CD"
        cCodCartao:= Substr(SL4->L4_ADMINIS,1,3)
        If cCodCartao $ "001#002"  //- Credicard
           aEntrada[nPos,7] += SL4->L4_VALOR
        ElseIf cCodCartao $ "003#004" //- RedeShop/ Visa Eletron
           aEntrada[nPos,5] += SL4->L4_VALOR
        ElseIf cCodCartao $ "005#009" //- Visa
           aEntrada[nPos,8] += SL4->L4_VALOR
        ElseIf cCodCartao $ "013#014" //- Elo
           aEntrada[nPos,6] += SL4->L4_VALOR
        ElseIf cCodCartao $ "011#012" //- Amex
           aEntrada[nPos,11] += SL4->L4_VALOR
        Endif                           
     Endif
     SL4->(DbSkip())
  Enddo   
Return   

////////////////////////////////
Static Function RecFatura(nPos)
  Local cCodCartao,cBusca,n_Valor,cBusca,cRecISS
  
  cRecISS:= Posicione("SA1",1,xFilial("SA1")+TRB->(D2_CLIENTE+D2_LOJA),"A1_RECISS")
  
  cBusca:= TRB->(D2_CLIENTE+D2_LOJA+D2_SERIE+D2_DOC)
     
  //SE1->(DbSetOrder(2))
  U_MsSetOrder("SE1","E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima       
  SE1->(DbSeek(xFilial("SE1")+cBusca))
 
  Do While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+cBusca
                                           
     n_Valor:= SE1->E1_VALOR - If(cRecISS="1",SE1->E1_ISS, 0)
     
     //- Dinheiro
     If TRIM(SE1->E1_NATUREZA) $ GetMv("MV_NATDINH")
        aEntrada[nPos,3] += n_Valor //- Dinheiro
     Endif   

     //- Cheque
     If TRIM(SE1->E1_NATUREZA) $ GetMv("MV_NATCHEQ")
        aEntrada[nPos,4] += n_Valor  //- Cheque
     Endif   
  
     //- Boleto
     If TRIM(SE1->E1_NATUREZA) $ "31101001#31101002"
        aEntrada[nPos,9] += n_Valor  //- Boleto
     Endif   

     //- Deposito C/C
     If TRIM(SE1->E1_NATUREZA) $ GetMv("MV_NATDEPO")
        aEntrada[nPos,10] += n_Valor  //- Deposito C/C
     Endif   
     
     //- Cartao de credito/debito  
     cNat:= Substr(SE1->E1_NATUREZ,1,4)
     
     If cNat $ "CRED#REDE#VISA#DINE#AMERICAN"
        cCodCartao:= TRIM(SE1->E1_NATUREZ)
        If cCodCartao $ "CREDICAVIS#CREDICAPRZ"  //- Credicard
           aEntrada[nPos,7] += SE1->E1_VLRREAL - If(cRecISS="1",SE1->E1_ISS, 0)
        ElseIf cCodCartao $ "REDESHOP#VISAELECTR" //- RedeShop/ Visa Eletron
           aEntrada[nPos,5] += SE1->E1_VLRREAL - If(cRecISS="1",SE1->E1_ISS, 0)
        ElseIf cCodCartao $ "VISAAPRZ#VISAAVISTA" //- Visa
           aEntrada[nPos,8] += SE1->E1_VLRREAL - If(cRecISS="1",SE1->E1_ISS, 0)
        ElseIf cCodCartao $ "ELOAVISTA#ELOAPRZ" //- Elo
           aEntrada[nPos,6] += SE1->E1_VLRREAL - If(cRecISS="1",SE1->E1_ISS, 0)
        ElseIf cCodCartao $ "AMERICAN#AMERICA PA" //- Amex
           aEntrada[nPos,11] += SE1->E1_VLRREAL - If(cRecISS="1",SE1->E1_ISS, 0)
        Endif      
     Endif
     SE1->(DbSkip())
  Enddo
Return

///////////////////////////////////
Static Function MontaEmail(nTroco)
  Local cMsg,nDinheiro,nSaldo,nDevoluc,nLen
  Local nDevoluc:= 0.00
  Local nCancAut:= 0.00         
  Local nSangria:= 0.00
  
  //����������������������������Ŀ
  //� Preparando corpo do email �
  //������������������������������
  cMsg := '<html><head><title>Resumo de Caixa</title>'
  cMsg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"></head><body>'
  //������������������������������������������������������Ŀ
  //� Tabela 01 - Entradas no periodo - Creditos / Vendas �
  //�������������������������������������������������������                        
  cMsg += '<table width="100%" bgcolor="#f5f5f5">'
  cMsg += ' <tr>'
  cMsg += ' <th colspan="13">Entradas no periodo - Creditos / Vendas</th>
  cMsg += ' </tr><tr></tr>'                   
  cMsg += '</table>'

  cMsg += '<table width="100%" frame="hsides">
  cMsg += ' <tr>'
  cMsg += ' <th scope="col">Cliente</th>'
  cMsg += ' <th scope="col">Prefixo</th>'          
  cMsg += ' <th scope="col">Dinheiro</th>'          
  cMsg += ' <th scope="col">Cheque</th>'          
  cMsg += ' <th scope="col">Debito</th>'           
  cMsg += ' <th scope="col">Elo</th>'          
  cMsg += ' <th scope="col">Redecard</th>'            
  cMsg += ' <th scope="col">Visa</th>'          
  cMsg += ' <th scope="col">Boleto</th>'         
  cMsg += ' <th scope="col">Dep.C/C</th>'           
  cMsg += ' <th scope="col">Amex</th>'            
  cMsg += ' <th scope="col">Total</th>'  
  cMsg += ' <th scope="col">Nota Fisc</th>'
  cMsg += ' </tr>'        

  aSort(aEntrada,,, {|x,y| x[2] < y[2]})

  nLen:= Len(aEntrada)

  For i:= 1 to nLen-1
     If aEntrada[i,12] = 0
        Loop
     Endif   
     cMsg += ' <tr>'
     cMsg += ' <td>' + aEntrada[i,1] + '</td>'
     cMsg += ' <td>' + aEntrada[i,2] + '</td>'
     cMsg += ' <td>' + Transform(aEntrada[i,3],"@E 999,999,999.99") + '</td>' 
     cMsg += ' <td>' + Transform(aEntrada[i,4],"@E 999,999,999.99") + '</td>' 
     cMsg += ' <td>' + Transform(aEntrada[i,5],"@E 999,999,999.99") + '</td>'    
     cMsg += ' <td>' + Transform(aEntrada[i,6],"@E 999,999,999.99") + '</td>'    
     cMsg += ' <td>' + Transform(aEntrada[i,7],"@E 999,999,999.99") + '</td>'         
     cMsg += ' <td>' + Transform(aEntrada[i,8],"@E 999,999,999.99") + '</td>'         
     cMsg += ' <td>' + Transform(aEntrada[i,9],"@E 999,999,999.99") + '</td>'         
     cMsg += ' <td>' + Transform(aEntrada[i,10],"@E 999,999,999.99") + '</td>'         
     cMsg += ' <td>' + Transform(aEntrada[i,11],"@E 999,999,999.99") + '</td>'         
     cMsg += ' <td>' + Transform(aEntrada[i,12],"@E 999,999,999.99") + '</td>'         
     cMsg += ' <td>' + aEntrada[i,13] + '</td>' 
     cMsg += ' <td>' + aEntrada[i,14] + '</td>' 
     cMsg += ' </tr>' 
   
     //- Somando valores por modalidade de pagamento
     aEntrada[nLen,3]  += aEntrada[i,3]
     aEntrada[nLen,4]  += aEntrada[i,4]
     aEntrada[nLen,5]  += aEntrada[i,5]
     aEntrada[nLen,6]  += aEntrada[i,6]
     aEntrada[nLen,7]  += aEntrada[i,7]
     aEntrada[nLen,8]  += aEntrada[i,8]
     aEntrada[nLen,9]  += aEntrada[i,9]
     aEntrada[nLen,10] += aEntrada[i,10]
     aEntrada[nLen,11] += aEntrada[i,11]
     aEntrada[nLen,12] += aEntrada[i,12]
  Next
  nDinheiro:= aEntrada[nLen,3]
  
  cMsg += ' <tr><font color="#333333"><strong>'
  cMsg += ' <td>' + aEntrada[nLen,1] + '</td>' 
  cMsg += ' <td>' + aEntrada[nLen,2] + '</td>' 
  cMsg += ' <td>' + Transform(aEntrada[nLen,3],"@E 999,999,999.99") + '</td>'    
  cMsg += ' <td>' + Transform(aEntrada[nLen,4],"@E 999,999,999.99") + '</td>'    
  cMsg += ' <td>' + Transform(aEntrada[nLen,5],"@E 999,999,999.99") + '</td>'    
  cMsg += ' <td>' + Transform(aEntrada[nLen,6],"@E 999,999,999.99") + '</td>'    
  cMsg += ' <td>' + Transform(aEntrada[nLen,7],"@E 999,999,999.99") + '</td>'    
  cMsg += ' <td>' + Transform(aEntrada[nLen,8],"@E 999,999,999.99") + '</td>'    
  cMsg += ' <td>' + Transform(aEntrada[nLen,9],"@E 999,999,999.99") + '</td>'    
  cMsg += ' <td>' + Transform(aEntrada[nLen,10],"@E 999,999,999.99") + '</td>'    
  cMsg += ' <td>' + Transform(aEntrada[nLen,11],"@E 999,999,999.99") + '</td>'    
  cMsg += ' <td>' + Transform(aEntrada[nLen,12],"@E 999,999,999.99") + '</td>'    
  cMsg += '</strong></font></td></tr></table>'
  
  //��������������������������������������������������������Ŀ
  //� Tabela 02 - OUTRAS NOTAS - DEVOLUCOES/REMESSA/RETORNO �
  //����������������������������������������������������������
  cMsg += '<table width="100%" bgcolor="#f5f5f5">'
  cMsg += ' <tr>'
  cMsg += ' <th colspan="13">OUTRAS NOTAS - DEVOLUCOES/REMESSA/RETORNO</th>
  cMsg += ' </tr><tr></tr>'                   
  cMsg += '</table>'

  cMsg += '<table width="100%" frame="hsides">
  cMsg += ' <tr>'
  cMsg += ' <th scope="col">Nome</th>'
  cMsg += ' <th scope="col">Documento</th>'          
  cMsg += ' <th scope="col">Natureza</th>'          
  cMsg += ' <th scope="col">Valor</th>'          
  cMsg += ' </tr>'        
  
  For i:= 1 to Len(aOutrNf)
     cMsg += ' <tr>'
     cMsg += ' <td>' + aOutrNf[i,2] + '</td>'
     cMsg += ' <td>' + aOutrNf[i,1] + '</td>'
     cMsg += ' <td>' + aOutrNf[i,5] + '</td>'
     cMsg += ' <td>' + Transform(aOutrNf[i,3],"@E 999,999,999.99")+ '</td>'
     cMsg += ' </tr>' 
     nDevoluc += aOutrNf[i,3]
  Next
  cMsg += ' <tr>'
  cMsg += ' <td>' + Space(10) + '</td>'
  cMsg += ' <td>' + Space(9) + '</td>'
  cMsg += ' <td>' + Space(10) + '</td>'
  cMsg += ' <td>' + Transform(nDevoluc,"@E 999,999,999.99")+ '</td>'
  cMsg += ' </tr>' 
  cMsg += '</strong></font></td></tr></table></body></html>'
  
  //��������������������������������������������������Ŀ
  //� Tabela 03 - Cancelamentos automaticos - SISTEMA �
  //���������������������������������������������������
  cMsg += '<table width="100%" bgcolor="#f5f5f5">'
  cMsg += ' <tr>'
  cMsg += ' <th colspan="13">Cancelamentos automaticos - SISTEMA</th>
  cMsg += ' </tr><tr></tr>'                   
  cMsg += '</table>'

  cMsg += '<table width="100%" frame="hsides">
  cMsg += ' <tr>'
  cMsg += ' <th scope="col">Nome</th>'
  cMsg += ' <th scope="col">Documento</th>'          
  cMsg += ' <th scope="col">Natureza</th>'          
  cMsg += ' <th scope="col">Valor</th>'          
  cMsg += ' </tr>'        
  
  For i:= 1 to Len(aCancAut)
     cMsg += ' <tr>'
     cMsg += ' <td>' + aCancAut[i,2] + '</td>'
     cMsg += ' <td>' + aCancAut[i,1] + '</td>'
     cMsg += ' <td>' + aCancAut[i,5] + '</td>'
     cMsg += ' <td>' + Transform(aCancAut[i,3],"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
     nCancAut += aCancAut[i,3]
  Next
  cMsg += ' <tr>'
  cMsg += ' <td>' + Space(10) + '</td>'
  cMsg += ' <td>' + Space(9) + '</td>'
  cMsg += ' <td>' + Space(10) + '</td>'
  cMsg += ' <td>' + Transform(nCancAut,"@E 999,999,999.99")+ '</td>'
  cMsg += ' </tr>' 
  cMsg += '</strong></font></td></tr></table></body></html>'
  
  //��������������������������������������������������������������Ŀ
  //� Tabela 04 Saidas no periodo - Debitos/ Pagamentos/ Sangrias �
  //���������������������������������������������������������������
  cMsg += '<table width="100%" bgcolor="#f5f5f5">'
  cMsg += ' <tr>'
  cMsg += ' <th colspan="13">Saidas no periodo - Debitos/ Pagamentos/ Sangrias</th>
  cMsg += ' </tr><tr></tr>'                   
  cMsg += '</table>'

  cMsg += '<table width="100%" frame="hsides">
  cMsg += ' <tr>'
  cMsg += ' <th scope="col">Historico</th>'
  cMsg += ' <th scope="col">Documento</th>'          
  cMsg += ' <th scope="col">Valor</th>'          
  cMsg += ' </tr>'        
  
  For i:= 1 to Len(aSaida)
     cMsg += ' <tr>'
     cMsg += ' <td>' + aSaida[i,2] + '</td>'
     cMsg += ' <td>' + aSaida[i,1] + '</td>'
     cMsg += ' <td>' + Transform(aSaida[i,3],"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'             
     nSangria += aSaida[i,3]
  Next
  cMsg += ' <tr>'
  cMsg += ' <td>' + Space(10) + '</td>'
  cMsg += ' <td>' + Space(9) + '</td>'
  cMsg += ' <td>' + Transform(nSangria,"@E 999,999,999.99")+ '</td>'
  cMsg += ' </tr>' 
  cMsg += '</strong></font></td></tr></table></body></html>'

  //���������������������������������Ŀ
  //� Tabela 05 - Resumo de caixa  �
  //���������������������������������� 
  nSaldo:= ( nTroco + nDinheiro ) - nSangria

  cMsg += '<table width="100%" bgcolor="#f5f5f5">'
  cMsg += ' <tr>'
  cMsg += ' <th colspan="13">Resumo do Caixa</th>
  cMsg += ' </tr><tr></tr>'                   
  cMsg += '</table>'

  cMsg += '<table width="100%" border="1" bordercolor=""#f5f5f5"" bgcolor=""#f5f5f5">'
  cMsg += ' <tr>'
  cMsg += ' <th scope="col">Fundo de Caixa</th>'
  cMsg += ' <th scope="col">Saldo em Dinheiro</th>'          
  cMsg += ' <th scope="col">Saida em Dinheiro</th>'          
  cMsg += ' <th scope="col">Saldo Liquido em Dinheiro</th>'          
  cMsg += ' </tr>'        
  
  cMsg += ' <tr>'
  cMsg += ' <td>' + Transform(nTroco,"@E 999,999,999.99") + '</td>'
  cMsg += ' <td>' + Transform(nDinheiro,"@E 999,999,999.99") + '</td>'
  cMsg += ' <td>' + Transform(nSangria,"@E 999,999,999.99") + '</td>'
  cMsg += ' <td>' + Transform(nSaldo,"@E 999,999,999.99") + '</td>'
  cMsg += ' </tr>' 
  cMsg += '</strong></font></td></tr></table></body></html>'
Return cMsg