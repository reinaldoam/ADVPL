#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAGWKF12   บ Autor ณ REINALDO MAGALHAES บ Data ณ  09/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ TOP 100 de vendas                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
 
User Function AGWKF05
  Local cUser := "", cPass := "", cSendSrv := ""
  Local cMsg := "", cMsgA := "", aData := ""
  Local nSendPort := 0, nSendSec := 2, nTimeout := 0, nPerc:= 0, nCountL:= 1
  Local xRet
  Local oServer, oMessage
  
  Private cDtSemIni,cDtSemFim
  Private nTotal:= 0 
 
  //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"

  conout( "AGWKF05 - Entrou em "+DtoC(Date())+ " as " + Time())
           
  aData:= QryPeriodo()

  cDtSemIni := aData[1,1]
  cDtSemFim := aData[1,2] 

  cTitulo:= "TOP 100 DE VENDAS DE " + FormatData(cDtSemIni) + ' a ' + FormatData(cDtSemFim)
  
  QryVenda()  
     
  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  //ณ Preparando corpo do email ณ
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  cHtml := '<html><head><title>Untitled Document</title>'
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
  cHtml += '</head><body><table width="100%" border="1" bordercolor="#66CCFF" bgcolor="#DFEFFF">'
  //cHtml += '<tr><td><div align="center"><font size="4"><font color="#000000">'
  //cHtml += 'TOP 100 DE VENDAS DE ' + FormatData(cDtSemIni) + ' a ' + FormatData(cDtSemFim)
  //cHtml += '</font></font></div></td></tr><tr><td><font color="#333333"><strong>'
  //cHtml += 'VENDAS DE ' + FormatData(cDtSemIni) + ' a ' + FormatData(cDtSemFim)
  //cHtml += '</tr>                                                              
  cHtml += ' <th scope="col">Item</th>'
  cHtml += ' <th scope="col">Codigo</th>'
  cHtml += ' <th scope="col">Referencia</th>'
  cHtml += ' <th scope="col">Descricao</th>'
  cHtml += ' <th scope="col">Local</th>'
  cHtml += ' <th scope="col">Marca</th>' 
  cHtml += ' <th scope="col">Quantidade</th>' 
  cHtml += ' <th scope="col">Total</th>'
  cHtml += ' <th scope="col">%</th>'
  cHtml += ' <th scope="col">Dt.Ult.Cmp</th>'
  cHtml += ' <th scope="col">Qt.Ult.Cmp</th>'
  
  cHtml += ' </tr>'        

  dbGoTop()

  Do While !XXX->(EOF())

     aUltCmp := UltCompra(XXX->D2_COD,XXX->B1_XCODFAB)
     dUltCmp := aUltCmp[1][1]
     nQtdCmp := aUltCmp[1][2]
     
     nPerc:= (XXX->D2_TOTAL/nTotal)*100
     
     cHtml += ' <tr>'
   	 cHtml += ' <td>' + Str(nCountL,3) + '</td>'
     cHtml += ' <td>' + XXX->D2_COD + '</td>'
     cHtml += ' <td>' + XXX->B1_XCODFAB + '</td>'      
     cHtml += ' <td>' + XXX->B1_DESC + '</td>'      
     cHtml += ' <td>' + XXX->B1_LOCAGRO + '</td>'   
     cHtml += ' <td>' + XXX->A2_NREDUZ + '</td>'   
     cHtml += ' <td align="center">' + TRANSFORM(XXX->D2_QUANT, "999999") + '</td>'  
     cHtml += ' <td align="center">' + TRANSFORM(XXX->D2_TOTAL,"@E 999,999.99") + '</td>' 
     cHtml += ' <td align="center">' + TRANSFORM(nPerc,"@E 999.99")+"%" + '</td>'
     cHtml += ' <td align="center">' + Dtoc(dUltCmp) + '</td>'   
     cHtml += ' <td align="center">' + TRANSFORM(nQtdCmp, "999999") + '</td>'  
     cHtml += ' </tr>' 
     nCountL++
     XXX->(dbSkip())
  Enddo   
  
  XXX->(dbCloseArea())
  
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  //ณ Preparando dados para envio do email ณ
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  cUser := Trim(GetMv("MV_RELACNT"))   //"workflow@dccomercio.com.br" //define the e-mail account username
  cPass := Trim(GetMv("MV_RELAPSW"))   //"casa98"                     //define the e-mail account password
  cSendSrv := "br484.hostgator.com.br" //"email-ssl.com.br"     //"smtp.office365.com"         // define the send server
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

  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  //ณ Preparando o envio do email  ณ
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  oMessage := TMailMessage():New()
  oMessage:Clear()
  oMessage:cDate := cValToChar( Date() )
  oMessage:cFrom := cUser 
  oMessage:cTo := Trim(GetMv("MV_EMAILV"))
   
  oMessage:cBody := cHtml
  oMessage:MsgBodyType( "text/html" )
  oMessage:cSubject := "05-"+cTitulo
  
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
    
  conout( "AGWKF05 - saiu em "+DtoC(Date())+ " as " + Time())

  //RESET ENVIRONMENT

return

/////////////////////////
Static Function QryVenda
  Local cQry:=""
  cQry :="SELECT DISTINCT A.D2_COD,B.B1_XCODFAB,B.B1_DESC,B.B1_LOCAGRO,C.A2_NREDUZ,D.D2_QUANT,D.D2_TOTAL "
  cQry += " FROM "+RetSQLName("SD2")+" A, "
  cQry +=          RetSQLName("SB1")+" B, "
  cQry +=          RetSQLName("SA2")+" C, "
  cQry+="("
  cQry+="  SELECT TOP 100 D2_COD,SUM(D2_QUANT)D2_QUANT,SUM(D2_TOTAL)D2_TOTAL "
  cQry+="  FROM "+RetSQLName("SD2")+" E,"
  cQry+=          RetSQLName("SB1")+" F,"
  cQry+=          RetSQLName("SA2")+" G "
  cQry+="  WHERE E.D_E_L_E_T_ <> '*' AND F.D_E_L_E_T_ <> '*' AND G.D_E_L_E_T_ <> '*'"
  cQry+="  AND D2_PRCVEN <> 0 "     
  cQry+="  AND D2_COD = B1_COD "
  cQry+="  AND B1_PROC = A2_COD "
  cQry+="  AND D2_FILIAL= '02' "  
  cQry+="  AND D2_EMISSAO BETWEEN '"+cDtSemIni+"' AND '"+cDtSemFim+"' " 
  cQry+="  AND D2_CF IN('5102','6102','5405','6405') "
  cQry+="  GROUP BY D2_COD "
  cQry+="  ORDER BY D2_TOTAL DESC "
  cQry+=")D "
  cQry+="WHERE A.D_E_L_E_T_ <> '*' "
  cQry+="AND B.D_E_L_E_T_ <> '*' "
  cQry+="AND C.D_E_L_E_T_ <> '*' "
  cQry+="AND A.D2_COD = D.D2_COD "
  cQry+="AND A.D2_COD = B.B1_COD "
  cQry+="AND B.B1_PROC = A2_COD " 
  cQry+="AND B1_FILIAL='02' "
  cQry+="AND A.D2_FILIAL='02' "
  cQry+="AND A.D2_EMISSAO BETWEEN '"+cDtSemIni+"' AND '"+cDtSemFim+"' "
  cQry+="AND A.D2_CF IN('5102','6102','5405','6405') "
  cQry+="ORDER BY D.D2_TOTAL DESC "
                        
  conout(cQry)

  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )

  dbGoTop()

  XXX->( dbEval( {|| nTotal += D2_TOTAL } ) )

Return	 

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

////////////////////////////////////
Static Function UltCompra(cCod,cRef)
  Local cQry :=""
  Local aRet := {}
  cQry := "SELECT TOP 1 D1_DTDIGIT,D1_QUANT " 
  cQry += "FROM "+RetSqlName("SD1")+" SD1 " 
  cQry += "WHERE D_E_L_E_T_ <> '*' "
  cQry += "AND D1_FILIAL = '02' "  
  cQry += "AND D1_CF IN('1101','2101','1102','2102') "  
  cQry += "AND D1_COD = '"+cCod+"' "  
  cQry += "ORDER BY D1_DTDIGIT DESC "
  
  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"SD1T",.T.,.T.)
                  
  If !SD1T->(Eof())
     TcSetField("SD1T", "D1_DTDIGIT", "D", 8, 0)  // Formata para tipo Data
     AAdd(aRet, {SD1T->D1_DTDIGIT, SD1T->D1_QUANT})
     SD1T->(dbCloseArea())
  Else                    
     SD1T->(dbCloseArea())
     cQry := "SELECT TOP 1 D1_DTDIGIT,D1_QUANT " 
     cQry += "FROM "+RetSqlName("SD1")+" SD1 " 
     cQry += "WHERE D_E_L_E_T_ <> '*' "
     cQry += "AND D1_FILIAL = '01' "  
     cQry += "AND D1_CF IN('1101','2101','1102','2102') "  
     cQry += "AND D1_COD = '"+cRef+"' "  
     cQry += "ORDER BY D1_DTDIGIT DESC "
     dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"SD1T",.T.,.T.)
     TcSetField("SD1T", "D1_DTDIGIT", "D", 8, 0)  // Formata para tipo Data
     AAdd(aRet, {SD1T->D1_DTDIGIT, SD1T->D1_QUANT})
     SD1T->(dbCloseArea())
  Endif
Return aRet  

/*
dbSelectArea(“SX5”)
 
dbSetOrder(1)
 
dbGotop()
 
While !Eof() .And. X5_FILIAL == xFilial("SX5") .And.; X5_TABELA <= mv_par02
 
nCnt++
 
dbSkip()
 
End
 
// O mesmo pode ser re-escrito com o uso da fun็ใo DBEVAL():
 
dbEval( {|x| nCnt++ },,{||X5_FILIAL==xFilial("SX5") .And. X5_TABELA<=mv_par02})
 
//Exemplo 02:
 
// Considerando o trecho de c๓digo abaixo:
 
dbSelectArea(“SX5”)
 
dbSetOrder(1)
 
dbGotop()
 
While !Eof() .And. X5_TABELA == cTabela
 
AADD(aTabela,{X5_CHAVE, Capital(X5_DESCRI)})
 
dbSkip()
 
End
 
// O mesmo pode ser re-escrito com o uso da fun็ใo DBEVAL():
 
dbEval({|| AADD(aTabela,{X5_CHAVE,Capital(X5_DESCRI)})},,{|| X5_TABELA==cTabela})
*/
