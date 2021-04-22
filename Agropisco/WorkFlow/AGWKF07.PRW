//#include "ap5mail.ch"
//#include "Protheus.ch"
#include "rwmake.ch"
#include  "TbiConn.ch"

User Function AGWKF07
  Local cUser := "", cPass := "", cSendSrv := ""
  Local cMsg := "", cMsgA := "", aData := ""
  Local nSendPort := 0, nSendSec := 3, nTimeout := 0
  Local xRet
  Local oServer, oMessage
  
  Private cTitulo:= "Comissão semanal de vendas" 
  Private cDtSemIni,cDtSemFim
  
  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
           
  aData:= QryPeriodo()
  
  cDtSemIni := aData[1,1]
  cDtSemFim := aData[1,2] 
     
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando corpo do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cHtml := '<html><head><title>Untitled Document</title>'
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
  cHtml += '</head><body><table width="100%" border="1" bordercolor="#66CCFF" bgcolor="#DFEFFF">'
  cHtml += '<tr><td><div align="center"><font size="4"><font color="#000000">'
  cHtml += 'COMISSAO DE VENDAS'
  cHtml += '</font></font></div></td></tr><tr><td><font color="#333333"><strong>'
  cHtml += 'COMISSAO DE ' + FormatData(cDtSemIni) + ' a ' + FormatData(cDtSemFim) + ' - Mes Ref. : ' + MesExt(Month(dDatabase))+"/"+Substr(Str(Year(dDatabase),4),3,2)
  cHtml += '</tr>
  cHtml += ' <th scope="col">Codigo</th>'
  cHtml += ' <th scope="col">Vendedor</th>'
  cHtml += ' <th scope="col">Venda dia</th>'
  cHtml += ' <th scope="col">Venda Ac. Semana</th>' 
  cHtml += ' <th scope="col">Venda Ac. Mes</th>' 
  cHtml += ' <th scope="col">Comissao semana</th>'
  cHtml += ' <th scope="col">%Meta30Mil</th>'  
  cHtml += ' <th scope="col">%Meta50Mil</th>' 
  cHtml += ' <th scope="col">%Meta500Mil</th>' 
  cHtml += ' </tr>'        
                     
  cHtml += CorpoEmail()
  
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando dados para envio do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cUser := "vendas1@agropisco.com.br" //define the e-mail account username
  cPass := "Agro@123" //define the e-mail account password
  cSendSrv := "smtp.office365.com" // define the send server
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

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando o envio do email  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  oMessage := TMailMessage():New()
  oMessage:Clear()
  oMessage:cDate := cValToChar( Date() )
  oMessage:cFrom := "vendas1@agropisco.com.br"
  oMessage:cTo := "reinaldo.magalhaes2014@gmail.com"
   
  oMessage:cBody := cHtml
  oMessage:MsgBodyType( "text/html" )
  oMessage:cSubject := cTitulo
  
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
  
  RESET ENVIRONMENT

return

////////////////////////////
Static function CorpoEmail()
  
  Local cMsg:="", nExpiraEm, nCountL
                
  Local nVlBVenSem  := 0    
  Local nVlBLstSem  := 0
  Local nVlCVenSem  := 0
  Local nVlBVenMes  := 0

  Local nVlTotCom   := 0

  Local nTotVndDia :=  0
  Local nTotVndSem :=  0
  Local nTotVndMes :=  0
  Local nTotComSem :=  0
  
  Local nRegis      := 0
  Local cAuxDoc     := ""
  Local cAuxSer     := ""
  Local cAuxVend    := ""
  Local nCalcCom1   := 0
  Local nCalcCom2   := 0
  Local nVBasDia    := 0       
  Local nVComDia    := 0
  Local nMeta30mil  := 0
  Local nMeta50mil  := 0
  Local nMeta500mil := 0
                       
  Local cMesCorIni  := Substr(Dtos(dDatabase),1,6)+"01" 
  Local cMesCorFim  := Substr(Dtos(dDatabase),1,6)+"31"
  
  Private cCfPeca  := Getmv("MV_CFPECA")
  Private cCfServ  := Getmv("MV_CFSERV")
  Private cTesLoca := Getmv("MV_TESLOCA")

  mv_par01 := "  "
  mv_par02 := "ZZ"
  mv_par03 := Getmv("MV_XCOMINI") // colocar na tabela de periodos de comissao
  mv_par04 := Getmv("MV_XCOMFIM") // colocar na tabela de periodos de comissao
  mv_par05 := "      "
  mv_par06 := "ZZZZZZ"
  mv_par07 := 4
  mv_par08 := "   "
  mv_par09 := "ZZZ"
  mv_par10 := "      "
  mv_par11 := "ZZZZZZ"
  
  dbSelectArea("SD2")
  U_MsSetOrder("SD2","D2_FILIAL+D2_COD+D2_LOCAL+D2_NUMSEQ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima

  MontaQry()

  dbGoTop()

  Do while !XXX->(EOF())
   
     If !VerifSD1()	   
        cAuxDoc := XXX->D2_DOC
        cAuxSer := XXX->D2_SERIE
        lImp    := .T.
	    XXX->(dbSkip())
	    Loop 	  
     EndIf
   
     If cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE
                     
        aVendaCom := QryVend(XXX->F2_DOC,XXX->F2_SERIE,XXX->F2_CLIENTE,XXX->F2_LOJA)  
         
        nBase     := aVendaCom[1][1]  
        nPrcLista := aVendaCom[1][2]
        
        nDesc     := IIF(nBase > nPrcLista, 0, (1-(nBase/nPrcLista))*100)  
        nAcre     := IIF(nBase > nPrcLista, ((nBase/nPrcLista)-1)*100,0)
      
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Regra para cálculo de percentual de comissão baseado em desconto  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If nDesc = 0
           nCalcCom1 := 1 // as vendas que não tiverem descontos  1% de comissão
        ElseIf nDesc > 0 .And. nDesc <= 3    
           nCalcCom1 := 0.7 // as vendas que  tiverem até 3% de desconto  0,7% de comissão
        ElseIf nDesc > 3 .And. nDesc <= 5
           nCalcCom1 := 0.5 // as vendas que  tiverem de 3,1% até 5% de desconto  0,5% de comissão
        ElseIf nDesc > 5    
           nCalcCom1 := 0.5 // as vendas que  tiverem mais de 5% de desconto  0,25% de comissão
        Endif
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Regra para cálculo de percentual de comissão baseado em acrescimo ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If nAcre > 5
           nCalcCom1 := 1.50
        Endif   
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Total de vendas dia     ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If XXX->D2_EMISSAO = Dtos(dDataBase)
           nVBasDia += nBase       
           nVComDia += (nCalcCom1 * nBase)/100
        Endif
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Total de vendas na semana  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If XXX->D2_EMISSAO >= cDtSemIni .And. XXX->D2_EMISSAO <= cDtSemFim    
           nVlBVenSem += nBase    
           nVlBLstSem += nPrcLista
           nVlCVenSem += (nCalcCom1 * nBase)/100 
        Endif
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Calculo da comissão mensal ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If XXX->D2_EMISSAO >= cMesCorIni .And. XXX->D2_EMISSAO <= cMesCorFim 
           nVlBVenMes += nBase  
        Endif     
     Endif        

     U_MsSetOrder("SF4","F4_FILIAL+F4_CODIGO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
   
     SF4->(dbSeek(xFilial("SF4")+XXX->D2_TES))
            
     cAuxDoc  := XXX->D2_DOC
     cAuxSer  := XXX->D2_SERIE                                       
     cAuxVend := XXX->F2_VEND1 
   
     XXX->(dbSkip()) // Avanca o ponteiro do registro no arquivo

     If cAuxVend <> XXX->F2_VEND1
      
        nValBDesc := (1-(nVlBVenSem/nVlBLstSem)) * 100
                                            
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Calculo de metas 30 mil e 50 mil  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        nMeta30mil  := (nVlBVenSem/30000) * 100
        nMeta50mil  := (nVlBVenSem/50000) * 100 
        nMeta500mil := (nVlBVenMes/500000) * 100

        nMeta30mil  := If(nMeta30mil > 100, 100, nMeta30mil)
        nMeta50mil  := If(nMeta50mil > 100, 100, nMeta50mil)
        nMeta500mil := If(nMeta500mil > 100, 100, nMeta500mil)
                                                 
        ++nCountL
        
        cMsg += ' <tr>'
    	cMsg += ' <td>' + cAuxVend + '</td>'
        cMsg += ' <td>' + Posicione("SA3",1,xFilial("SA3")+AllTrim(cAuxVend),"A3_NOME") + '</td>'
        cMsg += ' <td align="center">' + TRANSFORM(nVBasDia, "@E 999,999.99") + '</td>'    // Vendas dia
        cMsg += ' <td align="center">' + TRANSFORM(nVlBVenSem, "@E 999,999.99") + '</td>'  // Vendas acumulada semana
        cMsg += ' <td align="center">' + Transform(nVlBVenMes, "@E 999,999.99") + '</td>'  // Vendas acumulada mes 
        cMsg += ' <td align="center">' + TRANSFORM(nVlCVenSem, "@E 999,999.99") + '</td>'  // Comissao vendas acumuladas
        cMsg += ' <td align="center">' + Transform(nMeta30mil,"@E 999.99")+"%" + '</td>'
        cMsg += ' <td align="center">' + Transform(nMeta50mil,"@E 999.99")+"%" + '</td>'
        cMsg += ' <td align="center">' + Transform(nMeta500mil,"@E 999.99")+"%" + '</td>'
        cMsg += ' </tr>'
        
        nTotVndDia +=  nVBasDia    // Vendas dia
        nTotVndSem +=  nVlBVenSem  // Vendas acumulada semana
        nTotVndMes +=  nVlBVenMes   // Vendas acumulada mes 
        nTotComSem +=  nVlCVenSem   // Comissao vendas acumuladas
        
        nVlBVenSem := 0
        nVlCVenSem := 0
	    nVlBLstSem := 0 
        nVBasDia   := 0       
        nVComDia   := 0
        nVlBVenMes := 0
     EndIf
  Enddo

  XXX->(dbCloseArea())
  
  cMsg += ' <tr>'
  cMsg += ' <td>' + Space(6) + '</td>'
  cMsg += ' <td>' + Space(40) + '</td>'
  cMsg += ' <td align="center">' + Transform(nTotVndDia, "@E 999,999.99") + '</td>'  // Total de vendas dia
  cMsg += ' <td align="center">' + Transform(nTotVndSem, "@E 999,999.99") + '</td>'  // Total de vendas semana
  cMsg += ' <td align="center">' + Transform(nTotVndMes, "@E 999,999.99") + '</td>'  // Total de vendas mês 
  cMsg += ' <td align="center">' + Transform(nTotComSem, "@E 999,999.99") + '</td>'  // Total comissão semana
  cMsg += ' <td align="center">' + Space(7) + '</td>'
  cMsg += ' <td align="center">' + Space(7) + '</td>'
  cMsg += ' <td align="center">' + Space(7) + '</td>'
  cMsg += ' </tr>'
  
  //cMsg += ' </table>'
  //--- Fim da tabela                                         
  
  //cMsg += '<br /><b>Qtde de vendedores: ' + AllTrim(Str(nCountL)) +'</b>'
  
  //cMsg += Repli(' <br />',2)
Return cMsg

//////////////////////////
Static Function MontaQry()
        
 Local cQuery := ""

 cQuery := " SELECT COUNT(*)SOMA "
 cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
 cQuery +=          RetSQLName("SB1")+" SB1, "
 cQuery +=          RetSQLName("SF2")+" SF2 "
 cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "  
 cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
 cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
 cQuery += " AND F2_DOC = D2_DOC " 
 cQuery += " AND F2_SERIE = D2_SERIE "
 cQuery += " AND D2_COD = B1_COD "
 cQuery += " AND B1_X_COMIS IN(' ','S') "
 cQuery += " AND F2_VEND1 <> '000016' "  
 cQuery += " AND D2_PRCVEN <> 0    
 cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND D2_EMISSAO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " 
 cQuery += " AND F2_EMISSAO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " 
 cQuery += " AND D2_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
 cQuery += " AND F2_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "                 
 cQuery += " AND D2_SERIE BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
 cQuery += " AND F2_SERIE BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "                 
 cQuery += " AND (F2_VEND1 BETWEEN '"+mv_par10+"' AND '"+mv_par11+"' "  
 cQuery += " OR F2_VEND2 BETWEEN '"+mv_par10+"' AND '"+mv_par11+"') "  
                   
 If mv_par07 == 1 //PEÇA                     
     cQuery += " AND D2_CF IN('5102','6102','5108','6108','5404','6404','5405','6405')"  
     //cQuery += " AND( D2_CF = '"+cCfPeca+"'  
     //cQuery += " OR D2_CF = '6102' OR D2_CF = '6108')"
 Elseif mv_par07 == 2 //SERVIÇO
     cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"' "
     cQuery += " OR D2_CF = '6102')"
 Elseif mv_par07 == 3  //LOCAÇÃO
     cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"' "
     cQuery += " OR D2_CF = '6102')" 
     cQuery += " OR D2_CF = '6933')" 
 Elseif mv_par07 == 4  // Todos
     //cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
     //cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
     //cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
     //cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933')" 
     cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
     cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
     cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
     cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' "
     cQuery += " OR D2_CF = '6933' OR D2_CF = '5404' OR D2_CF = '6404' "
     cQuery += " OR D2_CF = '5405' OR D2_CF = '6405')"
 EndIf          
 
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
 nRegis := SOMA             
 dbCloseArea()

 //cQuery := StrTran(cQuery,"COUNT(*)SOMA", "*")
 cQuery := StrTran(cQuery,"COUNT(*)SOMA", "D2_EMISSAO,D2_DOC,D2_SERIE,D2_CF,D2_TES,D2_ITEM,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_VEND1")
 cQuery += " ORDER BY F2_VEND1,D2_DOC,D2_SERIE, D2_CF "
 
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
          		
Return	 

//////////////////////////
Static Function VerifSD1()
        
Local cQuery := ""
Local lRet   := .F.

 cQuery := " SELECT D1_TIPO, D1_NFORI, D1_SERIORI,D1_ITEMORI "
 cQuery += " FROM "+RetSQLName("SD1")+" SD1 "   
 cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' " 
 cQuery += " AND D1_FILIAL = '"+xFilial("SD1")+"' " 
 cQuery += " AND D1_NFORI = '"+XXX->D2_DOC+"' " 
 cQuery += " AND D1_SERIORI = '"+XXX->D2_SERIE+"' " 
 cQuery += " AND D1_ITEMORI = '"+XXX->D2_ITEM+"' " 
                  
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
 lRet := YYY->(EOF())
 YYY->(dbCloseArea())

Return lRet                       

///////////////////////////////////////////////////////
Static Function QryVend(cNota, cSerie, cCliente, cLoja)
 Local cQuery    := ""
 Local nPrcLista := 0.00
 Local aVendaCom := {}
 
 cQuery := " SELECT * "
 cQuery += " FROM "+RetSQLName("SD2")+" SD2 "
 cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "  
 cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"' "
 cQuery += " AND D2_DOC = '"+cNota+"' "                 
 cQuery += " AND D2_SERIE = '"+cSerie+"' "
 cQuery += " AND D2_CLIENTE = '"+cCliente+"' "
 cQuery += " AND D2_LOJA = '"+cLoja+"' "
 
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
                                            
 AAdd(aVendaCom, {0, 0})

 While !TMP->(Eof())
   	If !VerifSD1(TMP->D2_DOC,TMP->D2_SERIE,TMP->D2_ITEM)
	   TMP->(dbSkip())  	   
	   Loop
	EndIf 
	nPrcLista:= TMP->D2_XPRCTAB //Posicione("SB0",1,xFilial("SB0")+TMP->D2_COD,"B0_PRV1")  //VALOR ATUAL
    nPrcLista:= If(nPrcLista > 0, nPrcLista, Posicione("SB0",1,xFilial("SB0")+TMP->D2_COD,"B0_PRV1"))  
    
    aVendaCom[1][1] += TMP->D2_TOTAL
    aVendaCom[1][2] += TMP->D2_QUANT * nPrcLista //TMP->D2_PRUNIT 
    TMP->(dbSkip()) 
 Enddo
 TMP->(dbCloseArea())
Return aVendaCom

///////////////////////////
Static Function QryPeriodo
 Local cQuery   := ""
 Local aPeriodo := {}                                
 Local cHoje    := Dtos(dDatabase)
 
 cQuery := " SELECT * "
 cQuery += " FROM "+RetSQLName("SZB")+" SZB "
 cQuery += " WHERE SZB.D_E_L_E_T_ <> '*' "
 cQuery += " AND ZB_FILIAL = '"+xFilial("SZB")+"' "                 
 cQuery += " AND ZB_DATAINI <= '"+cHoje+"' "
 cQuery += " AND ZB_DATAFIM >= '"+cHoje+"' "
 
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
                                            
 AAdd(aPeriodo, {TMP->ZB_DATAINI, TMP->ZB_DATAFIM})

 TMP->(dbCloseArea())
                                                                                                     
Return aPeriodo

//////////////////////////////////
Static Function FormatData(cData)
  cDatac := Substr(cData,7,2) + "/"
  cDatac += Substr(cData,5,2) + "/"
  cDatac += Substr(cData,3,2)
Return cDatac
  
//////////////////////////////
Static Function MesExt( nMes )  
  Local aMes:= {}
  aMes:= AADD(aMes, {'JANEIRO','FEVEREIRO','MARCO','ABRIL','MAIO','JUNHO','JULHO','AGOSTO','SETEMBRO','OUTUBRO','NOVEMBRO','DEZEMBRO'} )
Return aMes[nMes]