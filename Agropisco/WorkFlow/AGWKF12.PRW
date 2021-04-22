#include "Protheus.ch"
#include  "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGWKF12   º Autor ³ REINALDO MAGALHAES º Data ³  09/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Workflow de contas a receber                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AGWKF12 
  Local _aArea 

  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"         

  _aArea := GetArea()
                     
  ContasReceber()

  RestArea(_aArea)
                     
  //ConOut("SAIU!")
  
  RESET ENVIRONMENT
 
Return .T.
                
/////////////////////////////
Static Function ContasReceber 
  Local cUser := "", cPass := "", cSendSrv := "", cHtml:= "", cMsg := ""
  Local nSendPort := 0, nSendSec := 3, nTimeout := 0
  Local xRet,oServer, oMessage

  Local cAccount := "workflow@dccomercio.com.br"  
  Local cServer  := "smtp.dccomercio.com.br"  
  Local cPass    := "casa98"  
  Local cEmailV  := Trim(GetMv("MV_EMAILG"))
  Local lRet     := .T.
  Local lResult  := .T.
  Local aOrd     := {}
  
  Private cSubject := "Relação de Títulos em Atraso - REF.:" + Dtoc(Date()) 

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando corpo do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cHtml := '<html><head><title>Untitled Document</title>'
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
  cHtml += '</head><body><table width="100%" border="1" bordercolor="#66CCFF" bgcolor="#DFEFFF">'
  
  cHtml += ' <tr>'
  cHtml += ' <th scope="col">Cliente</th>'
  cHtml += ' <th scope="col">Saldo Devedor</th>'
  cHtml += ' <th scope="col">Atraso em dias</th>'
  cHtml += ' </tr>'        
  
  cHtml += CorpoEmail()
  
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando dados para envio do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cUser    := cAccount // define the e-mail account username
  cPass    := cPass    // define the e-mail account password
  cSendSrv := cServer  // define the send server
  nTimeout := 60       // define the timout to 60 seconds
   
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
  oMessage:cFrom := cAccount
  oMessage:cTo := Trim(GetMv("MV_EMAILG")) // "reinaldo.magalhaes2014@gmail.com"      
  oMessage:cCC := "karina@agropisco.com.br" 
   
  oMessage:cBody := cHtml
  oMessage:MsgBodyType( "text/html" )
  oMessage:cSubject := cSubject
  
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

Return

///////////////////////////
Static Function CorpoEmail
  Local cQry   := "", cMsg:=""
  Local nTotal := 0, dVenc, nAtr
  
  cQry := "SELECT A1_NREDUZ,B.E1_SALDO,E1_VENCREA FROM "+RetSQLName("SA1")+" A, "
  cQry += "("
  cQry += " SELECT E1_CLIENTE,E1_LOJA,SUM(E1_SALDO)E1_SALDO,MIN(E1_VENCREA)E1_VENCREA FROM "+RetSQLName("SE1")
  cQry += " WHERE D_E_L_E_T_ <> '*' "
  cQry += " AND E1_SALDO > 0 "
  cQry += " AND E1_VENCREA < '"+dTos(Date())+"' " 
  cQry += " AND E1_TIPO IN('NF ','BO ','FT ','DP ') "
  cQry += " AND E1_NATUREZ NOT IN('VISAAPRZ','CREDICAVIS','AMERICAN','CHEQUE','VISAAPRZ','AMERICA PA','REDESHOP','DINHEIRO','DEPOSITO', "
  cQry += " 'CREDICAVIS','VISAELECTR','AMERICAN','CREDICAPRZ','VISAAVISTA','DINERAVIST') "
  cQry += " AND E1_NOMCLI NOT LIKE 'AGROPISCO%' "
  cQry += " GROUP BY E1_CLIENTE,E1_LOJA "
  cQry += ")B "
  cQry += "WHERE A.D_E_L_E_T_<> '*' "
  cQry += "AND A1_COD=B.E1_CLIENTE "
  cQry += "AND A1_LOJA=B.E1_LOJA "
  cQry += "ORDER BY E1_SALDO DESC "
  		
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
  TRB->(Dbgotop())		

  Do While !TRB->(Eof())
     
     dVenc := CTOD(Substr(TRB->E1_VENCREA,7,2)+'/'+Substr(TRB->E1_VENCREA,5,2)+'/'+Substr(TRB->E1_VENCREA,1,4))
     nAtr  := Date() - dVenc

     cMsg += ' <tr>'                                       
     cMsg += ' <td>' + TRB->A1_NREDUZ + '</td>'
     cMsg += ' <td>' + Transform(TRB->E1_SALDO,"@E 99,999,999.99") + '</td>'
     cMsg += ' <td>' + Transform(nAtr,"@E 999999") + '</td>'
     cMsg += ' </tr>'               
     
     nTotal += TRB->E1_SALDO
     TRB->(DbSkip())
     
  Enddo   

  cMsg += ' <tr>'    
  For i:= 1 to 2                                   
     cMsg += ' <td>' + " " + '</td>'
  Next       
  cMsg += '<td BGCOLOR="#FFFF00">' + Transform(nTotal,"@E 99,999,999.99")+ '</td>'
  cMsg += ' </tr>'

  TRB->(dbCloseArea())
Return cMsg