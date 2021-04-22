#include "Protheus.ch"
#include  "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAGWKF13   บ Autor ณ REINALDO MAGALHAES บ Data ณ  15/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Curva ABC de vendas                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function AGWKF13
  Local cUser := "", cPass := "", cSendSrv := ""
  Local cMsg := "", cMsgA := "", aData := ""
  Local nSendPort := 0, nSendSec := 3, nTimeout := 0, nPerc:= 0, nCountL:= 1
  Local xRet
  Local oServer, oMessage
  
  Private cDtSemIni,cDtSemFim,cAno,cMes
  Private nTotal:= 0 
 
  //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
          
  If Month(Date()) = 1 // Janeiro
     cMes := '12'
     cAno := StrZero(Year(Date())-1,4)
     cDtSemIni := cAno+cMes+"01"    
  Else        
    cMes := StrZero(Month(Date())-1,2)           
    cAno := StrZero(Year(Date()),4) 
    cDtSemIni := cAno+cMes+"01"
  Endif
  cDtSemFim := cAno+cMes+"31"    
                                        
  cDtSemIni := '20151101'
  cDtSemFim := '20151130'

  cTitulo:= "CURVA ABC DE VENDAS DE " + FormatData(cDtSemIni) + ' a ' + FormatData(cDtSemFim)
  
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
  cHtml += ' <th scope="col">Descricao</th>'
  cHtml += ' <th scope="col">Local</th>'
  cHtml += ' <th scope="col">Marca</th>' 
  cHtml += ' <th scope="col">Quantidade</th>' 
  cHtml += ' <th scope="col">Total</th>'
  cHtml += ' </tr>'        

  dbGoTop()

  Do while !XXX->(EOF())
     
     nPerc:= (XXX->D2_TOTAL/nTotal)*100
     
     cHtml += ' <tr>'
   	 cHtml += ' <td>' + Str(nCountL,3) + '</td>'
     cHtml += ' <td>' + XXX->D2_COD + '</td>'
     cHtml += ' <td>' + XXX->B1_DESC + '</td>'      
     cHtml += ' <td>' + XXX->B1_LOCAGRO + '</td>'   
     cHtml += ' <td>' + XXX->A2_NREDUZ + '</td>'   
     cHtml += ' <td align="center">' + TRANSFORM(XXX->D2_QUANT, "999999") + '</td>'  
     cHtml += ' <td align="center">' + TRANSFORM(XXX->D2_TOTAL,"@E 999,999.99") + '</td>' 
     cHtml += ' <td align="center">' + TRANSFORM(nPerc,"@E 999.99")+"%" + '</td>'
     
     cHtml += ' </tr>' 
     nCountL++
     XXX->(dbSkip())
  Enddo   
  
  XXX->(dbCloseArea())
  
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  //ณ Preparando dados para envio do email ณ
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
  cUser := "workflow@dccomercio.com.br" //"vendas1@agropisco.com.br" //define the e-mail account username
  cPass := "casa98"                     //"Agro@123" //define the e-mail account password
  cSendSrv := "smtp.dccomercio.com.br" //"smtp.office365.com" // define the send server
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
  oMessage:cFrom := "workflow@dccomercio.com.br" //"vendas1@agropisco.com.br"
  oMessage:cTo := Trim(GetMv("MV_EMAILV")) //"reinaldo.magalhaes2014@gmail.com"
   
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
    
  //RESET ENVIRONMENT

return

/////////////////////////
Static Function QryVenda
  Local cQry:=""
  cQry :="SELECT DISTINCT A.D2_COD,B.B1_DESC,B.B1_LOCAGRO,C.A2_NREDUZ,D.D2_QUANT,D.D2_TOTAL "
  cQry += " FROM "+RetSQLName("SD2")+" A, "
  cQry +=          RetSQLName("SB1")+" B, "
  cQry +=          RetSQLName("SA2")+" C, "
  cQry +="("
  cQry +="  SELECT D2_COD,SUM(D2_QUANT)D2_QUANT,SUM(D2_TOTAL)D2_TOTAL "
  cQry +="  FROM "+RetSQLName("SD2")+" E,"
  cQry +=          RetSQLName("SB1")+" F,"
  cQry +=          RetSQLName("SA2")+" G "
  cQry +="  WHERE E.D_E_L_E_T_ <> '*' AND F.D_E_L_E_T_ <> '*' AND G.D_E_L_E_T_ <> '*'"
  cQry +="  AND D2_PRCVEN <> 0 "     
  cQry +="  AND D2_COD = B1_COD "
  cQry +="  AND B1_PROC = A2_COD "
  cQry +="  AND D2_FILIAL= '"+xFilial("SD2")+"' "  
  cQry +="  AND D2_EMISSAO BETWEEN '"+cDtSemIni+"' AND '"+cDtSemFim+"' " 
  cQry +="  AND D2_CF IN('5102','6102','5405','6405') "
  cQry +="  AND NOT EXISTS "
  cQry +="  (SELECT * FROM "+RetSQLName("SD1")+" SD1 "
  cQry +="  WHERE D_E_L_E_T_ <> '*' " 
  cQry +="  AND D1_FILIAL = '"+xFilial("SD1")+"' "  
  cQry +="  AND D1_NFORI = E.D2_DOC "
  cQry +="  AND D1_SERIORI = E.D2_SERIE "
  cQry +="  AND D1_ITEMORI = E.D2_ITEM) "
  cQry +="  GROUP BY D2_COD "
  cQry +=")D "
  cQry +=" WHERE A.D_E_L_E_T_ <> '*' "
  cQry +=" AND B.D_E_L_E_T_ <> '*' "
  cQry +=" AND C.D_E_L_E_T_ <> '*' "
  cQry +=" AND A.D2_COD = D.D2_COD "
  cQry +=" AND A.D2_COD = B.B1_COD "
  cQry +=" AND B.B1_PROC = A2_COD " 
  cQry +=" AND B1_FILIAL='01'
  cQry +=" AND A.D2_FILIAL='01'  
  cQry +=" AND A.D2_EMISSAO BETWEEN '"+cDtSemIni+"' AND '"+cDtSemFim+"' "
  cQry +=" AND A.D2_CF IN('5102','6102','5405','6405') "
  cQry +=" ORDER BY D.D2_TOTAL DESC "

  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )

  dbGoTop()

  XXX->( dbEval( {|| nTotal += D2_TOTAL } ) )

Return	 


//////////////////////////////////
Static Function FormatData(cData)
  cDatac := Substr(cData,7,2) + "/"
  cDatac += Substr(cData,5,2) + "/"
  cDatac += Substr(cData,3,2)
Return cDatac