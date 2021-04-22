#include "Protheus.ch"
#include  "TbiConn.ch"
 
User Function AGWKF09 
  Local _aArea 

  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"         

  _aArea := GetArea()
                     
  ContasPagar()

  RestArea(_aArea)
                     
  //ConOut("SAIU!")
  
  RESET ENVIRONMENT
 
Return .T.
                
/////////////////////////////
Static Function ContasPagar 
  Local cUser := "", cPass := "", cSendSrv := "", cHtml:= "", cMsg := ""
  Local nSendPort := 0, nSendSec := 3, nTimeout := 0
  Local xRet,oServer, oMessage

  Local cAccount := Trim(GetMv("MV_RELACNT")) //"vendas1@agropisco.com.br" 
  Local cServer  := "smtp.office365.com"  //Trim(GetMv("MV_RELSERV")) //"smtp.office365.com" 
  Local cPass    := Trim(GetMv("MV_RELAPSW")) //"Agro@123" 
  Local cEmailV  := Trim(GetMv("MV_EMAILG"))  //
  Local lRet     := .T.
  Local lResult  := .T.
  Local aOrd     := {}
  Local dDataIni := dDatabase + 1
  Local dDataFim := dDatabase + 7
  
  Private cSubject := "Contas a Pagar de: " + Dtoc(dDataIni) + " A  " + Dtoc(dDataFim) //assunto do email

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando corpo do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cHtml := '<html><head><title>Untitled Document</title>'
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
  cHtml += '</head><body><table width="100%" border="1" bordercolor="#66CCFF" bgcolor="#DFEFFF">'
  //cHtml += '<tr><td><div align="center"><font size="4"><font color="#000000">'
  //cHtml += 'CONTAS A PAGAR'
  //cHtml += '</font></font></div></td></tr><tr><td><font color="#333333"><strong>'
  //cHtml += cSubject
  //cHtml += '</tr>
  
  cHtml += ' <tr>'
  cHtml += ' <th scope="col">Vencimento</th>'
  cHtml += ' <th scope="col">Prefixo</th>'
  cHtml += ' <th scope="col">Número</th>'
  cHtml += ' <th scope="col">Parcela</th>'
  cHtml += ' <th scope="col">TP</th>' 
  cHtml += ' <th scope="col">Fornecedor</th>'
  cHtml += ' <th scope="col">Valor</th>'
  cHtml += ' </tr>'        
  
  cHtml += CorpoEmail(dDataIni,dDataFim)
  
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
  xRet:= oServer:SmtpAuth( cUser, cPass )
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
  oMessage:cTo := Trim(GetMv("MV_EMAILG"))
   
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

//////////////////////////////////////////////
Static Function CorpoEmail(dDataIni,dDataFim) 
  Local cQry   := "", cQuebra:= "", cMsg:=""
  Local nTotal := 0 
 
  cQry := "SELECT E2_VENCREA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_NOMFOR, E2_SALDO FROM "+RetSQLName("SE2")+" WHERE "
  cQry += "D_E_L_E_T_ <> '*' AND "                                                     
  cQry += "E2_TIPO NOT IN " + FormatIn(MVPAGANT,"/") + " AND "
  cQry += "E2_SALDO > 0 AND " 
  cQry += "E2_VENCREA BETWEEN '"+dTos(dDataIni)+"' AND '"+dTos(dDataFim)+"' "
  //cQry += "(E2_EMIS1 <= '"+Dtos(dDataBase) +"' OR E2_TIPO IN " + FormatIn(MVPAGANT,"/")+") " 
  cQry += "ORDER BY E2_VENCREA" 		
  		
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
  TRB->(Dbgotop())		

  Do while !TRB->(Eof())
     If cQuebra <> TRB->E2_VENCREA
        cQuebra := TRB->E2_VENCREA
     Endif   
     cMsg += ' <tr>'                                       
     cMsg += ' <td>' + FormatData(TRB->E2_VENCREA) + '</td>'
     cMsg += ' <td>' + TRB->E2_PREFIXO + '</td>'
     cMsg += ' <td>' + TRB->E2_NUM + '</td>'
     cMsg += ' <td>' + TRB->E2_PARCELA + '</td>'
     cMsg += ' <td>' + TRB->E2_TIPO + '</td>'
     cMsg += ' <td>' + TRB->E2_NOMFOR + '</td>'
     cMsg += ' <td>' + Transform(TRB->E2_SALDO,"@E 99,999,999.99") + '</td>'
     cMsg += ' </tr>'               
     
     nTotal += TRB->E2_SALDO
     TRB->(DbSkip())
     
     If cQuebra <> TRB->E2_VENCREA
        cMsg += ' <tr>'    
        For i:= 1 to 6                                   
           cMsg += ' <td>' + " " + '</td>'
        Next       
        cMsg += '<td BGCOLOR="#FFFF00">' + Transform(nTotal,"@E 99,999,999.99")+ '</td>'
        cMsg += ' </tr>'
        nTotal := 0
     Endif
  Enddo   
  TRB->(dbCloseArea())
Return cMsg

//////////////////////////////////
Static Function FormatData(cData)
  cDatac := Substr(cData,7,2) + "/"
  cDatac += Substr(cData,5,2) + "/"
  cDatac += Substr(cData,3,2)
Return cDatac