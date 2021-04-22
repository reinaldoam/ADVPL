#include "Protheus.ch"
#include  "TbiConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AGWKF21   � Autor � REINALDO MAGALHAES � Data �  06/11/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Representatividade dos clientes novos no faturamento.       ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AGWKF21
  Local cUser := "", cPass := "", cSendSrv := ""
  Local cMsg := "", cMsgA := "", aData := ""
  Local nSendPort := 0, nSendSec:= 2, nTimeout := 0, nPerc:= 0, nCountL:= 1
  Local xRet
  Local oServer, oMessage  
  
  Local nMes,nAno,cMes,cAno,nPos,nValNovo
  Local nPerc1:=0
  Local nPerc2:=0  
  Local aVendCli:= {}
     
  Private cDataIni,cDataFim
  Private nValAnt:=0
  
  //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"

  cTitulo:= "VENDAS PARA CLIENTES NOVOS PF E PJ"   
  
  nMes := Month(Date()) //- m�s corrente
  nAno := Year(Date())  //- ano corrente
  
  If nMes = 01 //- Janeiro
     nMes := 12 
     nAno := nAno - 1
  Else   
     nMes:= nMes - 1
  Endif   
  cMes := StrZero(nMes,2)
  cAno := StrZero(nAno,4)
     
  cDataIni := cAno + cMes + '01' //- Data inicial
  cDataFim := cAno + cMes + '31' //- Data final
                
  QryVenda()  
           
  nValNovo:=0
  Do While !XXX->(EOF())
     If Dtos(XXX->A1_PRICOM) >= cDataIni .And. Dtos(XXX->A1_PRICOM) <= cDataFim
        nPos:= aScan(aVendCli,{|x| x[1] = XXX->A1_PESSOA })
        If nPos=0
           AADD(aVendCli,{XXX->A1_PESSOA, 0.00 })
           nPos:= Len(aVendCli)
        Endif  
        aVendCli[nPos][2] += XXX->D2_TOTAL
        nValNovo += XXX->D2_TOTAL
     Endif   
     XXX->(DbSkip())
  Enddo   
  XXX->(dbCloseArea())
     
  //����������������������������Ŀ
  //� Preparando corpo do email �
  //������������������������������
  cHtml := '<html><head><title>Untitled Document</title>'
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
  cHtml += '</head><body><table width="100%" border="1" bordercolor="#66CCFF" bgcolor="#DFEFFF">'
  cHtml += ' <th scope="col">Pessoa</th>' 
  cHtml += ' <th scope="col">Valor Total</th>'
  cHtml += ' <th scope="col">Porcentagem</th>'
  cHtml += ' </tr>'        

  For i:= 1 to Len(aVendCli)
     nPerc1 := Round((aVendCli[i][2] / nValAnt) * 100,2)
     nPerc2 += nPerc1
     cHtml += ' <tr>'
     cHtml += ' <td>' + IIF(aVendCli[i][1]="F","Fisica",IIF(aVendCli[i][1]="J","Juridica","Outras")) + '</td>'
     cHtml += ' <td align="center">R$ ' + Transform(aVendCli[i][2],"@E 999,999.99") + '</td>'  
     cHtml += ' <td align="center">' + Transform(nPerc1,"@E 999.99")+'%</td>'       
     cHtml += ' </tr>' 
     nCountL++
  Next
  cHtml += ' <tr>'
  cHtml += ' <td>Vendas Clientes Novos</td>'
  cHtml += ' <td> R$' + Transform(nValNovo,"@E 999,999,999.99") + '</td>'
  cHtml += ' </tr>' 
  
  cHtml += ' <td>Vendas Totais</td>'
  cHtml += ' <td> R$' + Transform(nValAnt,"@E 999,999,999.99") + '</td>'
  cHtml += ' </tr>' 
  
  cHtml += ' <td> Percentual</td>'  
  cHtml += ' <td>' + Transform(nPerc2,"@E 999.99") + '%</td>'
  cHtml += ' </tr>' 
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //���������������������������������������Ŀ
  //� Preparando dados para envio do email �
  //�����������������������������������������
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
  oMessage:cTo := "reinaldo.magalhaes2014@gmail.com" //Trim(GetMv("MV_EMAILV")) 
   
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

Return

/////////////////////////
Static Function QryVenda
  Local cQry:=""
  
  cQry += "SELECT SUM(D2_TOTAL)SOMA "
  cQry += "FROM "+RetSQLName("SD2")+" SD2 "
  cQry += "INNER JOIN "+RetSQLName("SF2")+" SF2 ON F2_FILIAL = D2_FILIAL AND F2_SERIE = D2_SERIE AND F2_DOC = D2_DOC "
  cQry += "INNER JOIN "+RetSQLName("SA3")+" SA3 ON A3_COD = F2_VEND1 "
  cQry += "INNER JOIN "+RetSQLName("SA1")+" SA1 ON A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA "
  cQry += "WHERE SD2.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' "
  cQry += "AND F2_FILIAL = '02' "
  cQry += "AND D2_FILIAL = '02' "
  cQry += "AND D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " 
  cQry += "AND ((D2_CF = '5102' OR (D2_CF = '5933' AND D2_TES <> '531') OR (D2_CF = '5933' AND D2_TES = '531')) "
  cQry += "OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' "
  cQry += "OR D2_CF = '6933' OR D2_CF = '5404' OR D2_CF = '6404' "
  cQry += "OR D2_CF = '5405' OR D2_CF = '6405' OR D2_CF = '5119' OR D2_CF = '6119') "
  cQry += "AND D2_FILIAL+D2_DOC+D2_SERIE+D2_ITEM NOT IN "
  cQry += "( "
  cQry += "  SELECT D2_FILIAL+D2_DOC+D2_SERIE+D2_ITEM "
  cQry += "  FROM "+RetSQLName("SD2")+" SD2 "
  cQry += "  INNER JOIN "+RetSQLName("SD1")+" SD1 ON D1_FILIAL = D2_FILIAL AND D1_NFORI = D2_DOC AND D1_SERIORI = D2_SERIE AND D1_ITEMORI = D2_ITEM "
  cQry += "  WHERE SD2.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' "
  cQry += "  AND D2_FILIAL = '02' "
  cQry += "  AND D1_FILIAL = '02' "
  cQry += "  AND D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " 
  cQry += "  AND ((D2_CF = '5102' OR (D2_CF = '5933' AND D2_TES <> '531') "
  cQry += "  OR (D2_CF = '5933' AND D2_TES = '531')) " 
  cQry += "  OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' "
  cQry += "  OR D2_CF = '6933' OR D2_CF = '5404' OR D2_CF = '6404' "
  cQry += "  OR D2_CF = '5405' OR D2_CF = '6405' OR D2_CF = '5119' OR D2_CF = '6119')"
  cQry += ") "

  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )
  nValAnt := SOMA             
  dbCloseArea()

  cQry := StrTran(cQry,"SUM(D2_TOTAL)SOMA", "D2_EMISSAO,D2_CLIENTE,D2_LOJA,A1_NOME,A1_PESSOA,A1_PRICOM,D2_TOTAL")

  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )

  TcSetField("XXX","A1_PRICOM","D",8,0)

  dbGoTop()

Return