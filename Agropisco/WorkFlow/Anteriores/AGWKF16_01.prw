#include "Protheus.ch"
#include "TbiConn.ch"
 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ AMWKF16  ³ Autor ³ Reinaldo Magalhães    ³ Data ³ 19/09/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Orçamentos de vendas em aberto acumulado                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AGROPISCO                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AGWKF16
  Local cDataIni := '20170717' //- Data de abertura da loja Parque 10
  Local cDataFim := Dtos(Date())       
  Local cTitulo   := "Relacao de Orçamentos de Vendas em Aberto até o Dia " + DTOC(Date())

  Local cUser := "", cPass := "", cSendSrv := "", cMsg := ""
  Local nSendPort := 0, nSendSec := 2, nTimeout := 0
  Local xRet
  Local oServer, oMessage
  Local nVlrOrc := 0
  Local cQuebra := ""
  
  Private nConta  := 0 
  Private nTotal  := 0 
  Private nSubTot := 0
 
  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"
  ConOut("ENTROU!")  

  MontaQry(cDataIni,cDataFim)
     
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando corpo do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cHtml := '<html><head><title>Untitled Document</title>'
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
  cHtml += '</head><body><table width="100%" border="1" bordercolor="#66CCFF" bgcolor="#DFEFFF">'
  cHtml += ' <tr>'
  cHtml += ' <th scope="col">Item</th>'
  cHtml += ' <th scope="col">Cliente</th>'
  cHtml += ' <th scope="col">Nome</th>'
  cHtml += ' <th scope="col">No.Orçamento</th>'     
  cHtml += ' <th scope="col">Vendedor</th>'
  cHtml += ' <th scope="col">Valor</th>'
  cHtml += ' <th scope="col">Acumulado</th>'
  cHtml += ' <th scope="col">Emissão</th>'
  cHtml += ' <th scope="col">Dias Atr.</th>'  
  cHtml += ' <th scope="col">Status</th>'  
  cHtml += ' </tr>'        

  dbGoTop()
  
  Do While !XXX->(EOF())           
     nAtraso := XXX->DIAS   
     cQuebra := XXX->CJ_VEND1
     nTotal  += XXX->CK_VALOR
     nSubTot += XXX->CK_VALOR
     nConta++
     cHtml += ' <tr>'
     cHtml += ' <td>' + Str(nConta,4) + '</td>'
	 cHtml += ' <td>' + XXX->CJ_CLIENTE + '</td>'
     cHtml += ' <td>' + Posicione("SA1",1,xFilial("SA1")+CJ_CLIENTE+XXX->CJ_LOJA,"A1_NOME") + '</td>' 
     cHtml += ' <td>' + XXX->CJ_NUM + '</td>'       
     cHtml += ' <td>' + Posicione("SA3",1,xFilial("SA3")+XXX->CJ_VEND1,"A3_NREDUZ") + '</td>'       
     cHtml += ' <td>' + Transform(XXX->CK_VALOR,"@E 999,999.99") + '</td>'
     cHtml += ' <td>' + Transform(nSubTot,"@E 999,999.99") + '</td>'
     cHtml += ' <td>' + Dtoc(XXX->CJ_EMISSAO) + '</td>'  
     cHtml += ' <td>' + Str(nAtraso,6) + '</td>'
     cHtml += ' <td>' + Posicione("SX5",1,xFilial("SX5")+"Z4"+XXX->CJ_XSTORC,"X5_DESCRI") + '</td>'            
     cHtml += ' </tr>' 
     XXX->(dbSkip())
     If XXX->CJ_VEND1 <> cQuebra
        nSubTot:= 0
     Endif
  Enddo   
  XXX->(dbCloseArea())
  cHtml += ' <tr>'
  cHtml += ' <td>' + Space(4) + '</td>'
  cHtml += ' <td>' + Space(6) + '</td>'
  cHtml += ' <td>' + Space(60) + '</td>'  
  cHtml += ' <td>' + Space(6) + '</td>'       
  cHtml += ' <td>' + Space(15) + '</td>'       
  cHtml += ' <td>' + Transform(nTotal,"@E 999,999.99") + '</td>'
  cHtml += ' <td>' + Space(10) + '</td>'
  cHtml += ' <td>' + Space(8) + '</td>'  
  cHtml += ' <td>' + Space(6) + '</td>'
  cHtml += ' </tr>' 
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando dados para envio do email webmail: https://webmail-seguro.com.br/arrodriguez.com.br/ ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cUser    := Trim(GetMv("MV_RELACNT")) // workflow.amtec@arrodriguez.com.br    
  cPass    := Trim(GetMv("MV_RELPSW"))  // amtec2015@@
  cSendSrv := "email-ssl.com.br"
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
  oMessage:cTo := Trim(GetMv("MV_EMAILV")) //"reinaldo.magalhaes2014@gmail.com"
  
  //If Day(Date()) = 1  
  //   oMessage:cCC := Trim(GetMv("MV_XEMAILD")) // envia email com copia para a diretoria somente dia 01 de cada mës.
  //Endif   
   
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
  ConOut("SAIU!")
  RESET ENVIRONMENT
return

////////////////////////////////////////////
Static Function MontaQry(dDataIni,dDataFim)
  Local cQry:=""
  cQry := "SELECT CJ_VEND1,CJ_NUM,CJ_CLIENTE,CJ_LOJA,A1_NREDUZ,CJ_EMISSAO,CJ_XSTORC,C.CK_VALOR,DATEDIFF(day,CJ_EMISSAO,GETDATE())AS DIAS "
  cQry += "FROM "+RetSQLName("SCJ")+" A,"+RetSQLName("SA1")+" B, "
  cQry += "("
  cQry += "  SELECT CK_NUM,SUM((CK_PRUNIT*CK_QTDVEN)-CK_VALDESC)CK_VALOR FROM "+RetSQLName("SCK")
  cQry += "  WHERE D_E_L_E_T_ <> '*' "
  cQry += "  AND CK_FILIAL='02' "  
  cQry += "  GROUP BY CK_NUM "
  cQry += ")C "
  cQry += "WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' " 
  cQry += "AND CJ_FILIAL='02' "  
  cQry += "AND CJ_CLIENTE=A1_COD AND CJ_LOJA=A1_LOJA "
  cQry += "AND CJ_EMISSAO BETWEEN '"+dDataIni+"' AND '"+dDataFim+"' "
  cQry += "AND CJ_STATUS='A' " 
  cQry += "AND CJ_NUM=C.CK_NUM "
  cQry += "AND CJ_XSTORC IN('001','004') "  
  cQry += "ORDER BY CJ_VEND1 "
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )

  TcSetField("XXX","CJ_EMISSAO","D",8,0)

Return