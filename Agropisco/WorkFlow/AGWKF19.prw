#include "Protheus.ch"
#include  "TbiConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AGWKF19   � Autor � REINALDO MAGALHAES � Data �  03/10/17   ���
�������������������������������������������������������������������������͹��
���Descricao � POS-Atendimento - Clientes que fizeram servi�os nos ultimos���
���          � 15 dias.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AGWKF19
  Local cUser := "", cPass := "", cSendSrv := ""
  Local cMsg := "", cMsgA := "", aData := ""
  Local nSendPort := 0, nSendSec:= 2, nTimeout := 0, nPerc:= 0, nCountL:= 1
  Local xRet
  Local oServer, oMessage
  
  Private cDataIni := Dtos(Date()-15)
  Private cDataFim := Dtos(Date())
  
  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"

  cTitulo:= "CLIENTES QUE FIZERAM SERVI�OS NOS ULTIMOS 15 DIAS "
  
  QryServico()  
     
  //����������������������������Ŀ
  //� Preparando corpo do email �
  //������������������������������
  cHtml := '<html><head><title>Untitled Document</title>'
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
  cHtml += '</head><body><table width="100%" border="1" bordercolor="#66CCFF" bgcolor="#DFEFFF">'
  //cHtml += '<tr><td><div align="center"><font size="4"><font color="#000000">'
  //cHtml += 'TOP 100 DE VENDAS DE ' + FormatData(cDtSemIni) + ' a ' + FormatData(cDtSemFim)
  //cHtml += '</font></font></div></td></tr><tr><td><font color="#333333"><strong>'
  //cHtml += 'VENDAS DE ' + FormatData(cDtSemIni) + ' a ' + FormatData(cDtSemFim)
  //cHtml += '</tr> 
  
  cHtml += ' <th scope="col">Cliente</th>' 
  cHtml += ' <th scope="col">Nome</th>' 
  cHtml += ' <th scope="col">Contato</th>'
  cHtml += ' <th scope="col">Telefone</th>'
  cHtml += ' <th scope="col">Celular</th>'
  cHtml += ' <th scope="col">E-mail 01</th>'
  cHtml += ' <th scope="col">E-mail 02</th>'
  cHtml += ' <th scope="col">Nota</th>'
  cHtml += ' <th scope="col">Serie</th>'
  cHtml += ' <th scope="col">Nro.OS</th>'  
  cHtml += ' <th scope="col">Dt.Emissao</th>'
  cHtml += ' <th scope="col">Valor Total</th>'
  cHtml += ' <th scope="col">Atendente</th>'  
  cHtml += ' </tr>'        

  dbGoTop()

  cQuebra:=""
  Do while !XXX->(EOF())
     cHtml += ' <tr>'
     If XXX->A1_COD <> cQuebra
        cHtml += ' <td>' + XXX->A1_COD + '</td>'
        cHtml += ' <td>' + XXX->A1_NOME + '</td>'
        cHtml += ' <td>' + XXX->A1_CONTATO + '</td>'
        cHtml += ' <td>' + XXX->A1_TEL + '</td>'
        cHtml += ' <td>' + XXX->A1_TELEX + '</td>'
        cHtml += ' <td>' + XXX->A1_EMAIL + '</td>'
        cHtml += ' <td>' + XXX->A1_XEMAIL + '</td>'
        cQuebra := XXX->A1_COD
     Else 
        cHtml += ' <td>' + Space(6) + '</td>'   
        cHtml += ' <td>' + Space(60) + '</td>'   
        cHtml += ' <td>' + Space(15) + '</td>'   
        cHtml += ' <td>' + Space(15) + '</td>'   
        cHtml += ' <td>' + Space(10) + '</td>'   
        cHtml += ' <td>' + Space(60) + '</td>'   
        cHtml += ' <td>' + Space(60) + '</td>'   
     Endif   
     cHtml += ' <td>' + XXX->F2_DOC + '</td>'
     cHtml += ' <td>' + XXX->F2_SERIE + '</td>'
     cHtml += ' <td>' + XXX->C6_NUMOS + '</td>'
     cHtml += ' <td>' + Dtoc(XXX->F2_EMISSAO) + '</td>'
     cHtml += ' <td align="center">' + TRANSFORM(XXX->D2_TOTAL, "@E 999,999.99") + '</td>' 
     cHtml += ' <td>' + XXX->A3_NREDUZ + '</td>'     
     cHtml += ' </tr>' 
     nCountL++
     XXX->(dbSkip())
  Enddo   
  
  XXX->(dbCloseArea())
  
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //���������������������������������������Ŀ
  //� Preparando dados para envio do email �
  //�����������������������������������������
  cUser    := Trim(GetMv("MV_RELACNT")) // workflow.amtec@arrodriguez.com.br    
  cPass    := Trim(GetMv("MV_RELPSW"))  // amtec2015@@
  cSendSrv := "br484.hostgator.com.br"//"email-ssl.com.br"
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
  oMessage:cTo := Trim(GetMv("MV_EMAILS")) //"reinaldo.magalhaes2014@gmail.com"
   
  oMessage:cBody := cHtml
  oMessage:MsgBodyType( "text/html" )
  oMessage:cSubject := "19-"+cTitulo
  
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
    
  RESET ENVIRONMENT

Return

///////////////////////////
Static Function QryServico
  Local cQry:=""                          
  Local cCliPad := Getmv("MV_CLIPAD")
  
  cQry += "SELECT DISTINCT F2_DOC,F2_SERIE,ISNULL(SUBSTRING(C6_NUMOS,1,6),L1_XNUMOS)C6_NUMOS,F2_EMISSAO,E.D2_TOTAL,A1_COD,A1_NOME,A1_CONTATO,A1_TEL,A1_TELEX,A1_XEMAIL,A1_EMAIL,A3_NREDUZ "
  cQry += "FROM "+RetSQLName("SF2")+" A "
  cQry += "INNER JOIN "+RetSQLName("SA1")+" B ON A.F2_CLIENTE = B.A1_COD AND A.F2_LOJA = B.A1_LOJA "
  cQry += "INNER JOIN "+RetSQLName("SA3")+" C ON A.F2_VEND1 = A3_COD "
  cQry += "LEFT JOIN "+RetSQLName("SC6")+" F ON A.F2_DOC = F.C6_NOTA AND A.F2_SERIE=F.C6_SERIE "
  cQry += "LEFT JOIN "+RetSQLName("SL1")+" G ON A.F2_DOC = G.L1_DOC "
  cQry += "INNER JOIN " 
  cQry += "(" 
  cQry += "  SELECT D2_DOC,D2_SERIE,SUM(D2_TOTAL)D2_TOTAL "
  cQry += "  FROM "+RetSQLName("SD2")+" D "
  cQry += "  WHERE D.D_E_L_E_T_ <> '*' "
  cQry += "  AND D2_FILIAL='02' "
  cQry += "  AND D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " 
  cQry += "  AND D2_CF IN('5933','6933') "
  cQry += "  AND D2_SERIE<>'LOC' "
  cQry += "  GROUP BY D2_DOC,D2_SERIE "
  cQry += ") E ON A.F2_DOC=E.D2_DOC AND A.F2_SERIE=E.D2_SERIE "
  cQry += "WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND C.D_E_L_E_T_ <> '*' AND G.D_E_L_E_T_<>'*' "
  cQry += "ORDER BY A1_NOME,F2_EMISSAO "

  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )

  TcSetField("XXX", "F2_EMISSAO", "D", 8, 0)  // Formata para tipo Data

  dbGoTop()

Return	 