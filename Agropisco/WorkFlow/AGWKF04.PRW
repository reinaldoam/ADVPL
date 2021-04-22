#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"
 
User Function AGWKF04

  Local _aArea:= GetArea()

  If Day(ddatabase) = GetMV("MV_XDIACOM") //Primeiro dia do mês

     PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

     _aArea := GetArea()

     lContinua:= .T.  

     If lContinua
        SendEMail()
     EndIf

     RestArea(_aArea)

     RESET ENVIRONMENT
  Endif
Return .T.
                                    
//////////////////////////////
Static Function SendEmail()
  Local cMsgA      := ""
  Local cAccount   := "workflow@potencial.inf.br"   
  Local cServer    := "mail.potencial.inf.br:587"   
  Local cPass      := "workflow007"                 
  Local cEmailV    := Trim(GetMv("MV_EMAILV")) 
  Local lRet       := .T.
  Local lResult    := .T.
  Private cSubject := "Comissão mensal de vendas" //assunto do email

  cMsgA := InicioMsg()
  cMsgA += fRodape()

  LjMsgRun("Conectando com o servidor SMTP: " + cServer)

  CONNECT SMTP SERVER cServer ;
          ACCOUNT cAccount ;
          PASSWORD cPass ; 
          RESULT lResult
                                    
  //Se a conexao com o SMPT esta ok
  If lResult .And. GetMv("MV_RELAUTH")
      //Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
	  lResult := MailAuth(cAccount, AllTrim(cPass))
	  //Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
	  If !lResult
	      nAt 	:= At("@",cAccount)
		  cUser 	:= If(nAt>0,Subs(cAccount,1,nAt-1),cAccount)
		  lResult := MailAuth(cUser, AllTrim(cPass))
	  Endif
  Endif
  If lResult
      SEND MAIL FROM cAccount TO ;
	               cEmailV ;
	               SUBJECT cSubject ;
	               BODY cMsgA ;
	               RESULT lResult
	
	  If !lResult
	      GET MAIL ERROR CERROR
	  Else
	      //Alert("E-mail enviado para " + cEmailV)	
	  EndIf
	 DISCONNECT SMTP SERVER
  Else
	 GET MAIL ERROR CERROR
  EndIf
Return lRet

/////////////////////////
Static Function fRodape()
  Local cMsg  := " "
  cMsg += ' <br />'
  cMsg += ' </body>'
  cMsg += ' </html>'
Return cMsg

///////////////////////////
Static Function InicioMsg()
  Local cMsg,nExpiraEm,nCountL,cAA,cMM
                 
  Local nVlBVenMes := 0
  Local nVlCVenMes := 0
  
  Local nRegis      := 0
  Local cAuxDoc     := ""
  Local cAuxSer     := ""
  Local cAuxVend    := ""
  Local nCalcCom1   := 0
  Local nMeta500mil := 0
  
  Private cCfPeca  := Getmv("MV_CFPECA")
  Private cCfServ  := Getmv("MV_CFSERV")
  Private cTesLoca := Getmv("MV_TESLOCA")

  If Month(ddatabase) = 1
     cMM:= "12"
     cAA:= Strzero(Year(ddatabase)-1,4)
  Else                   
     cMM:= Strzero(Month(ddatabase),2)
     cAA:= Strzero(Year(ddatabase),4)
  Endif 
              
  mv_par01 := "  "
  mv_par02 := "ZZ"
  mv_par03 := cAA+cMM+"01" 
  mv_par04 := cAA+cMM+"31" 
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

  //-- Inicio de envio do email
  cMsg := ' <html> '
  cMsg += ' <head> '
  cMsg += ' <title>' + cSubject + '</title> '
  cMsg += ' </head>'
  cMsg += ' <body> ' 
	
  nCountL := 0                                                 
  
  cMsg += ' <b>Comissao de vendas mês </b><br /> '
  cMsg += ' <b>Mês Referência : </b>' + MesExt(Val(cMM))+"/"+Substr(cAA,3,2) + ' <br /> '  
		
  //--- Inicio da tabela
  cMsg += ' <table width="100%" border="1" cellspacing="0" cellpadding="5">'
  cMsg += ' <caption><h2>' + cSubject + '</h2></caption>'
  cMsg += ' <tr>'    
  cMsg += ' <th scope="col">Codigo</th>'
  cMsg += ' <th scope="col">Vendedor</th>'
  cMsg += ' <th scope="col">Venda mes</th>'
  cMsg += ' <th scope="col">Comissao mes</th>'
  cMsg += ' <th scope="col">%Meta500Mil</th>' 
  cMsg += ' </tr>'

  dbGoTop()

  Do while !XXX->(EOF())
   
     //IncRegua()
   
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
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Calculo da comissão mensal ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
        nVlCVenMes += (nCalcCom1 * nBase)/100
        nVlBVenMes += nBase  
     Endif        

     U_MsSetOrder("SF4","F4_FILIAL+F4_CODIGO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
   
     SF4->(dbSeek(xFilial("SF4")+XXX->D2_TES))
            
     cAuxDoc  := XXX->D2_DOC
     cAuxSer  := XXX->D2_SERIE                                       
     cAuxVend := XXX->F2_VEND1 
   
     XXX->(dbSkip()) // Avanca o ponteiro do registro no arquivo

     If cAuxVend <> XXX->F2_VEND1
                                            
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Calculo de metas 30 mil e 50 mil  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        nMeta500mil := If((nVlBVenMes/500000) * 100 > 100, 100, (nVlBVenMes/500000) * 100)
                                                 
        ++nCountL
        
        cMsg += ' <tr>'
    	cMsg += ' <td>' + cAuxVend + '</td>'
        cMsg += ' <td>' + Posicione("SA3",1,xFilial("SA3")+AllTrim(cAuxVend),"A3_NOME") + '</td>'
        cMsg += ' <td align="center">' + Transform(nVlBVenMes, "@E 999,999.99") + '</td>'  // Vendas acumulada mes  
        cMsg += ' <td align="center">' + Transform(nVlCVenMes, "@E 999,999.99") + '</td>'  // Comissao vendas mes 
        cMsg += ' <td align="center">' + Transform(nMeta500mil,"@E 999.99")+"%" + '</td>'
        cMsg += ' </tr>'

        nVlBVenMes := 0 
        nVlCVenMes := 0
     EndIf
  Enddo

  XXX->(dbCloseArea())

  cMsg += ' </table>'
  //--- Fim da tabela  
  cMsg += '<br /><b>Total de vendedores: ' + AllTrim(Str(nCountL)) +'</b>'
  cMsg += Repli(' <br />',2)
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
 Elseif mv_par07 == 2 //SERVIÇO
     cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"' "
     cQuery += " OR D2_CF = '6102')"
 Elseif mv_par07 == 3  //LOCAÇÃO
     cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"' "
     cQuery += " OR D2_CF = '6102')" 
     cQuery += " OR D2_CF = '6933')" 
 Elseif mv_par07 == 4  // Todos
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

 Do while !TMP->(Eof())
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

//////////////////////////////
Static Function MesExt( nMes )  
  Local aMes:= {}
  aMes:= AADD(aMes, {'JANEIRO','FEVEREIRO','MARCO','ABRIL','MAIO','JUNHO','JULHO','AGOSTO','SETEMBRO','OUTUBRO','NOVEMBRO','DEZEMBRO'} )
Return aMes[nMes]