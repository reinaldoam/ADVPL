#include "Protheus.ch"
#include  "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGWKF11   º Autor ³ REINALDO MAGALHAES º Data ³  09/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Workflow orcamentos em aberto (Field Services)             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
 
User Function AGWKF11 
  Local _aArea := GetArea()
  Local cUser := "", cPass := "", cSendSrv := "", cHtml:= "", cMsg := ""
  Local nSendPort := 0, nSendSec := 3, nTimeout := 0
  Local xRet,oServer, oMessage

  Local cAccount := "workflow@dccomercio.com.br"  
  Local cServer  := "smtp.dccomercio.com.br"  
  Local cPass    := "casa98"  
  Local lRet     := .T.
  Local lResult  := .T.
  Local aOrd     := {}        
  
  Local dDataIni := Date()-90 // 03 meses
  Local dDataFim := Date()-1 

  Private cSubject := "OS aberto de: " + Dtoc(dDataIni) + " A  " + Dtoc(dDataFim) //assunto do email

  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"         
    
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando corpo do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cHtml := '<html><head><title>Untitled Document</title>'
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
  cHtml += '</head><body><table width="100%" border="1" bordercolor="#66CCFF" bgcolor="#DFEFFF">'
  
  cHtml += ' <tr>'
  cHtml += ' <th scope="col">Atend.</th>'
  cHtml += ' <th scope="col">Cliente</th>'
  cHtml += ' <th scope="col">Orcamen.</th>'
  cHtml += ' <th scope="col">Emissao</th>'
  cHtml += ' <th scope="col">Num.OS</th>'
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
  oMessage:cTo := Trim(GetMv("MV_EMAILG"))
  //oMessage:cCC := Trim(GetMv("MV_EMAILG")) 
  
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

  RestArea(_aArea)
                     
  ConOut("SAIU!")
  
  RESET ENVIRONMENT
 
Return .T.
                
/////////////////////////////////////////////
Static Function CorpoEmail(dDataIni,dDataFim) 
  Local cQry   := "", cQuebra:= "", cMsg:=""
  Local nTotal := 0 
      
  cQry := "SELECT AB3_ATEND,AB3_NOMCLI,AB3_NUMORC,AB3_EMISSA,AB4_NUMOS,AB8_TOTAL "
  cQry += "FROM " +RetSQLName("AB4")+" A, "+RetSQLName("AB3")+" B, "
  cQry += "( "
  cQry += "SELECT AB8_NUMOS,SUM(AB8_TOTAL)AB8_TOTAL "
  cQry += "FROM " +RetSQLName("AB8")
  cQry += " WHERE D_E_L_E_T_ <> '*' AND AB8_NUMPV='' "
  cQry += "GROUP BY AB8_NUMOS "
  cQry += ")C "
  cQry += "WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' "
  cQry += "AND AB3_NUMORC = AB4_NUMORC "
  cQry += "AND AB3_STATUS='A' "
  cQry += "AND AB3_EMISSA BETWEEN '"+dTos(dDataIni)+"' AND '"+dTos(dDataFim)+"' "
  cQry += "AND AB8_NUMOS = SUBSTRING(A.AB4_NUMOS,1,6) " 
  cQry += "ORDER BY AB3_ATEND "
  		
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
  TRB->(Dbgotop())		

  Do while !TRB->(Eof())
     cMsg += ' <tr>'                                       
     cMsg += ' <td>' + TRB->AB3_ATEND + '</td>'
     cMsg += ' <td>' + TRB->AB3_NOMCLI + '</td>'  
     cMsg += ' <td>' + TRB->AB3_NUMORC + '</td>'  
     cMsg += ' <td>' + FormatData(AB3_EMISSA) + '</td>'
     cMsg += ' <td>' + TRB->AB4_NUMOS + '</td>'
     cMsg += ' <td>' + Transform(TRB->AB8_TOTAL,"@E 99,999,999.99") + '</td>'
     cMsg += ' </tr>'               
     nTotal += TRB->AB8_TOTAL       
     TRB->(DbSkip())
  Enddo
  cMsg += ' <tr>'    
  For i:= 1 to 5
     cMsg += ' <td>' + " " + '</td>'
  Next       
  cMsg += '<td BGCOLOR="#FFFF00">' + Transform(nTotal,"@E 99,999,999.99")+ '</td>'
  cMsg += ' </tr>'
  TRB->(dbCloseArea())
Return cMsg

//////////////////////////////////
Static Function FormatData(cData)
  cDatac := Substr(cData,7,2) + "/"
  cDatac += Substr(cData,5,2) + "/"
  cDatac += Substr(cData,3,2)
Return cDatac