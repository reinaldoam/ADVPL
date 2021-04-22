#include "Protheus.ch"
#include "TbiConn.ch"
 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ AMWKF25  ³ Autor ³ Reinaldo Magalhães    ³ Data ³ 15/10/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio de email para clientes que não compraram nos ultimos ³±±
±±³          ³ 06 meses                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AGROPISCO                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function AGWKF25
  Local cDataIni := Dtos(Date()-180) //- 06 meses
  Local cDataFim := Dtos(Date())       
  Local aVendas  := {}
  Local cEmail   :=""
  Local cQuebra  := ""
 
  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"
  ConOut("ENTROU!")  

  MontaQry(cDataIni,cDataFim)
     
  dbGoTop()
  
  Do While !XXX->(Eof())           
     cQuebra:= XXX->CJ_VEND1
     aVendas:= {}
     
     Do While !XXX->(Eof()) .And. XXX->CJ_VEND1 == cQuebra
        AADD(aVendas,{ XXX->DIAS, ;
                       XXX->CK_VALOR, ;
	                   XXX->CJ_CLIENTE,;
                       Posicione("SA1",1,xFilial("SA1")+CJ_CLIENTE+XXX->CJ_LOJA,"A1_NOME"),;
                       XXX->CJ_NUM,;
                       Transform(XXX->CK_VALOR,"@E 999,999.99"),;
                       Posicione("SA3",1,xFilial("SA3")+XXX->CJ_VEND1,"A3_NREDUZ"),;
                       Dtoc(XXX->CJ_EMISSAO),;
                       Posicione("SX5",1,xFilial("SX5")+"Z4"+XXX->CJ_XSTORC,"X5_DESCRI") })
        XXX->(DbSkip())           
     Enddo            
     Asort(aVendas,,, {|x,y| x[8] < y[8]})

     cEmail := Posicione("SA3",1,xFilial("SA3")+cQuebra,"A3_EMAIL")
     EnvEmail(aVendas, cEmail) //- Envia o email
  Enddo
  XXX->(dbCloseArea())
  ConOut("SAIU!")
  RESET ENVIRONMENT
Return
                        
/////////////////////////////////////////
Static Function EnvEmail(aVendas,cEmail)
  Local cUser := "", cPass := "", cSendSrv := "", cMsg := ""
  Local nSendPort := 0, nSendSec := 2, nTimeout := 0
  Local xRet
  Local oServer, oMessage
  Local cHtml   := ""
  Local nConta  := 0 
  Local nTotal  := 0 
  Local nAtraso := 0 
  Local cTitulo := "Relacao de Orçamentos de Vendas em Aberto até o Dia " + DTOC(Date())
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
  cHtml += ' <th scope="col">Valor</th>'
  cHtml += ' <th scope="col">Vendedor</th>'
  cHtml += ' <th scope="col">Emissão</th>'
  cHtml += ' <th scope="col">Status</th>'  
  cHtml += ' </tr>'        
     
  //[1] XXX->DIAS
  //[2] XXX->CK_VALOR
  //[3]	XXX->CJ_CLIENTE
  //[4] Posicione("SA1",1,xFilial("SA1")+CJ_CLIENTE+XXX->CJ_LOJA,"A1_NOME")
  //[5] XXX->CJ_NUM
  //[6] Transform(XXX->CK_VALOR,"@E 999,999.99")
  //[7] Posicione("SA3",1,xFilial("SA3")+XXX->CJ_VEND1,"A3_NREDUZ")
  //[8] Dtoc(XXX->CJ_EMISSAO)
  //[9] Posicione("SX5",1,xFilial("SX5")+"Z4"+XXX->CJ_XSTORC,"X5_DESCRI")

  For i:= 1 to Len(aVendas)
     nAtraso := aVendas[i][1] 
     nTotal += aVendas[i][2] 
     nConta++
     cHtml += ' <tr>'
     cHtml += ' <td>' + Str(nConta,4) + '</td>'
	 cHtml += ' <td>' + aVendas[i][3] + '</td>'
     cHtml += ' <td>' + aVendas[i][4] + '</td>' 
     cHtml += ' <td>' + aVendas[i][5] + '</td>'       
     cHtml += ' <td>' + aVendas[i][6] + '</td>'            
     cHtml += ' <td>' + aVendas[i][7] + '</td>'       
     cHtml += ' <td>' + aVendas[i][8] + '</td>'  
     cHtml += ' <td>' + aVendas[i][9] + '</td>'       
     cHtml += ' </tr>' 
  Next
  cHtml += ' <tr>'
  cHtml += ' <td>' + Space(4) + '</td>'
  cHtml += ' <td>' + Space(6) + '</td>'
  cHtml += ' <td>' + Space(60) + '</td>'  
  cHtml += ' <td>' + Space(6) + '</td>'       
  cHtml += ' <td>' + Transform(nTotal,"@E 999,999.99") + '</td>'            
  cHtml += ' <td>' + Space(15) + '</td>'       
  cHtml += ' <td>' + Space(8) + '</td>'  
  cHtml += ' </tr>' 
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando dados para envio do email webmail: https://webmail-seguro.com.br/arrodriguez.com.br/ ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cUser    := Trim(GetMv("MV_RELACNT"))  
  cPass    := Trim(GetMv("MV_RELPSW"))
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
  oMessage:cTo := cEmail
  oMessage:cCC := Trim(GetMv("MV_EMAILV")) //"reinaldo.magalhaes2014@gmail.com"
   
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
return

////////////////////////////////////////////
Static Function MontaQry(cDataIni,cDataFim)
  Local cQry:=""
  cQry := "SELECT DISTINCT D.F2_CLIENTE,D.F2_LOJA,E.A1_NOME,G.D2_COD,G.D2_XCODFAB,H.B1_DESC,E.A1_EMAIL,E.A1_XEMAIL,D.F2_EMISSAO "
  cQry += "FROM "
  cQry += "("
  cQry += "SELECT F2_FILIAL,F2_CLIENTE,F2_LOJA,MAX(F2_EMISSAO)F2_EMISSAO "
  cQry += "FROM SD2010 A "
  cQry += "INNER JOIN SB1010 B ON B1_FILIAL = D2_FILIAL AND D2_COD = B1_COD "
  cQry += "INNER JOIN SF2010 C ON F2_FILIAL = D2_FILIAL "
  cQry += "WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND C.D_E_L_E_T_ <> '*' " 
  cQry += "AND F2_VEND1 <> '000001' "
  cQry += "AND F2_DOC = D2_DOC "  
  cQry += "AND F2_SERIE = D2_SERIE "
  cQry += "AND D2_PRCVEN <> 0 "                      
  cQry += "AND D2_FILIAL = '02' "
  cQry += "AND F2_FILIAL = D2_FILIAL "
  cQry += "AND D2_CF IN ('5102','6102','5404','6404','5405','6405') "
  cQry += "GROUP BY F2_FILIAL,F2_CLIENTE,F2_LOJA "
  cQry += ")D "
  cQry += "INNER JOIN SA1010 E ON A1_COD = D.F2_CLIENTE AND A1_LOJA = D.F2_LOJA "
  cQry += "INNER JOIN SD2010 G ON D2_FILIAL = D.F2_FILIAL AND D2_CLIENTE = D.F2_CLIENTE AND D2_LOJA = D.F2_LOJA AND D2_EMISSAO = D.F2_EMISSAO "
  cQry += "INNER JOIN SB1010 H ON B1_FILIAL = D.F2_FILIAL AND B1_COD = G.D2_COD "
  cQry += "WHERE E.D_E_L_E_T_ <> '*' "
  cQry += "AND (E.A1_EMAIL LIKE '%@%' OR E.A1_XEMAIL LIKE '%@%') "
  cQry += "AND F2_EMISSAO < '20180409' " 
  cQry += "ORDER BY F2_CLIENTE,F2_LOJA "
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )

  TcSetField("XXX","F2_EMISSAO","D",8,0)

Return
