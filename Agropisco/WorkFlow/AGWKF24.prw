#include "Protheus.ch"
#include "TbiConn.ch"
 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ AMWKF24  ³ Autor ³ Reinaldo Magalhães    ³ Data ³ 15/01/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Orçamentos de serviço em aberto                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AGROPISCO                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AGWKF24
  Local cDtMesIni := '20170717' //- Data de abertura da loja Parque 10
  Local cDtMesFim := Dtos(Date())       
  Local cTitulo   := "Orçamentos de garantia até o dia " + DTOC(Date())

  Local cUser := "", cPass := "", cSendSrv := "", cMsg := ""
  Local nSendPort := 0, nSendSec := 2, nTimeout := 0
  Local xRet
  Local oServer, oMessage
  Local nVlrOrc:=0
  
  Private nConta := 0 
  Private nTotal := 0 
 
  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"
  ConOut("ENTROU - AGWKF24")  

  MontaQry(cDtMesIni,cDtMesFim)  
     
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando corpo do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cHtml := '<html><head><title>Untitled Document</title>'
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
  cHtml += '</head><body><table width="100%" border="1" bordercolor="#66CCFF" bgcolor="#DFEFFF">'
  cHtml += ' <tr>'
  cHtml += ' <th scope="col">Item</th>'
  cHtml += ' <th scope="col">Nome</th>'
  cHtml += ' <th scope="col">No.Orçamento</th>'     
  cHtml += ' <th scope="col">Atendente</th>'     
  cHtml += ' <th scope="col">Descrição</th>'       
  cHtml += ' <th scope="col">Valor</th>'
  cHtml += ' <th scope="col">Cód.Status</th>'
  cHtml += ' <th scope="col">Status</th>'
  cHtml += ' <th scope="col">Dt.Entrada</th>'
  cHtml += ' <th scope="col">Dias Atr.</th>'
  cHtml += ' <th scope="col">Contato</th>'
  cHtml += ' </tr>'        

  dbGoTop()
  
  Do While !XXX->(EOF())           
     nAtraso := XXX->DIAS //Date() - XXX->AB3_EMISSA
     nVlrOrc := VlrOrcamento(XXX->AB3_NUMORC)
     nTotal += nVlrOrc
     nConta++
     cHtml += ' <tr>'
     cHtml += ' <td>' + Str(nConta,4) + '</td>'
     cHtml += ' <td>' + Posicione("SA1",1,xFilial("SA1")+XXX->AB3_CODCLI+XXX->AB3_LOJA,"A1_NOME") + '</td>'  
     cHtml += ' <td>' + XXX->AB3_NUMORC + '</td>'       
     cHtml += ' <td>' + XXX->AB3_ATEND + '</td>'            
     cHtml += ' <td>' + XXX->AB3_OBS1 + '</td>'
     cHtml += ' <td>' + Transform(nVlrOrc,"@E 999,999.99") + '</td>'            
     cHtml += ' <td>' + XXX->AB3_XSTORC + '</td>'       
     cHtml += ' <td>' + Posicione("SX5",1,xFilial("SX5")+"Z2"+XXX->AB3_XSTORC,"X5_DESCRI") + '</td>'  
     cHtml += ' <td>' + Dtoc(XXX->AB3_EMISSA) + '</td>'  
     cHtml += ' <td>' + Str(nAtraso,6) + '</td>'
     cHtml += ' <td>' + XXX->AB3_CONTAT + '</td>'
     cHtml += ' </tr>' 
     XXX->(dbSkip())
  Enddo   
  XXX->(dbCloseArea())
  cHtml += ' <tr>'
  cHtml += ' <td>' + Space(4)  + '</td>'
  cHtml += ' <td>' + Space(60) + '</td>'  
  cHtml += ' <td>' + Space(6) + '</td>' 
  cHtml += ' <td>' + Space(15) + '</td>'   
  cHtml += ' <td>' + Padr("TOTAL",50) + '</td>'
  cHtml += ' <td>' + Transform(nTotal,"@E 999,999.99") + '</td>'            
  cHtml += ' <td>' + Space(6) + '</td>'       
  cHtml += ' <td>' + Space(40) + '</td>'  
  cHtml += ' <td>' + Space(8) + '</td>'  
  cHtml += ' <td>' + Space(6) + '</td>'
  cHtml += ' <td>' + Space(20) + '</td>'
  cHtml += ' </tr>' 
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando dados para envio do email webmail: https://webmail-seguro.com.br/arrodriguez.com.br/ ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cUser    := Trim(GetMv("MV_RELACNT")) // workflow.amtec@arrodriguez.com.br    
  cPass    := Trim(GetMv("MV_RELPSW"))  // amtec2015@@
  cSendSrv := "br484.hostgator.com.br"  //"email-ssl.com.br"
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
  oMessage:cFrom := cUser
  oMessage:cTo :=  Trim(GetMv("MV_EMAILGR"))// "reinaldo.magalhaes2014@gmail.com"
  
  oMessage:cBody := cHtml
  oMessage:MsgBodyType( "text/html" )
  oMessage:cSubject := "24-"+cTitulo
  
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
  //RESET ENVIRONMENT

Return

//////////////////////////////////////////////
Static Function MontaQry(cDtMesIni,cDtMesFim)
  Local cQry:=""
  
  cQry :="SELECT AB3_CODCLI,AB3_CONTAT,AB3_LOJA,AB3_NUMORC,AB3_ATEND,AB3_SRVGRT,AB3_XSTORC,AB3_EMISSA,AB3_OBS1,DATEDIFF(day,AB3_EMISSA,GETDATE())AS DIAS "
  cQry +=" FROM "+RetSQLName("AB3")+" A "
  cQry += "WHERE A.D_E_L_E_T_ <> '*' "
  cQry += "AND AB3_FILIAL = '" + xFilial("AB3") + "' " 
  cQry += "AND AB3_EMISSA BETWEEN '"+cDtMesIni+"' AND '"+cDtMesFim+"' " 
  cQry += "AND AB3_STATUS='A' "
  cQry += "AND AB3_SRVGRT='2' "     
  cQry += "AND AB3_XNOTA = '' "
  cQry += "ORDER BY AB3_SRVGRT,DIAS DESC"
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )

  TcSetField("XXX","AB3_EMISSA","D",8,0)

Return

////////////////////////////////////
Static Function VlrOrcamento(cOrcam)
  Local cQry:=""
  Local nVlrOrc:=0
  
  cQry :="SELECT SUM(AB5_TOTAL)AB5_TOTAL "
  cQry +=" FROM "+RetSQLName("AB5")+" A "
  cQry += "WHERE A.D_E_L_E_T_ <> '*' "
  cQry += "AND AB5_FILIAL = '" + xFilial("AB5") + "' " 
  cQry += "AND AB5_NUMORC = '"+cOrcam+"' " 
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "YYY", .T., .F. )
  
  If !YYY->(EOF())
     nVlrOrc:= YYY->AB5_TOTAL
  Endif   
  YYY->(dbCloseArea())
Return nVlrOrc