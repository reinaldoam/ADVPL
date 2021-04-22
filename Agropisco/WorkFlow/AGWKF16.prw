#include "Protheus.ch"
#include "TbiConn.ch"
 
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � AMWKF16  � Autor � Reinaldo Magalh�es    � Data � 19/09/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Or�amentos de vendas em aberto acumulado                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � AGROPISCO                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function AGWKF16
  Local cDataIni := '20170717' //- Data de abertura da loja Parque 10
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
  Local cTitulo := "Relacao de Or�amentos de Vendas em Aberto at� o Dia " + DTOC(Date())
  //����������������������������Ŀ
  //� Preparando corpo do email �
  //������������������������������
  cHtml := '<html><head><title>Untitled Document</title>'
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
  cHtml += '</head><body><table width="100%" border="1" bordercolor="#66CCFF" bgcolor="#DFEFFF">'
  cHtml += ' <tr>'
  cHtml += ' <th scope="col">Item</th>'
  cHtml += ' <th scope="col">Cliente</th>'
  cHtml += ' <th scope="col">Nome</th>'
  cHtml += ' <th scope="col">No.Or�amento</th>'     
  cHtml += ' <th scope="col">Valor</th>'
  cHtml += ' <th scope="col">Vendedor</th>'
  cHtml += ' <th scope="col">Emiss�o</th>'
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
  
  //��������������������������������������������������������������������������������������������������Ŀ
  //� Preparando dados para envio do email webmail: https://webmail-seguro.com.br/arrodriguez.com.br/ �
  //����������������������������������������������������������������������������������������������������
  cUser    := Trim(GetMv("MV_RELACNT"))  
  cPass    := Trim(GetMv("MV_RELPSW"))
  cSendSrv := "br484.hostgator.com.br" //"email-ssl.com.br"
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

  //������������������������������Ŀ
  //� Preparando o envio do email  �
  //��������������������������������
  oMessage := TMailMessage():New()
  oMessage:Clear()
  oMessage:cDate := cValToChar( Date() )
  oMessage:cFrom := cUser
  oMessage:cTo := cEmail
  oMessage:cCC := Trim(GetMv("MV_EMAILV")) //"reinaldo.magalhaes2014@gmail.com"
   
  oMessage:cBody := cHtml
  oMessage:MsgBodyType( "text/html" )
  oMessage:cSubject := "16-"+cTitulo
  
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
  cQry += "AND CJ_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "
  cQry += "AND CJ_STATUS='A' " 
  cQry += "AND CJ_NUM=C.CK_NUM "
  cQry += "AND CJ_XSTORC IN('001','004') "    
  cQry += "ORDER BY CJ_VEND1 "
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )

  TcSetField("XXX","CJ_EMISSAO","D",8,0)

Return