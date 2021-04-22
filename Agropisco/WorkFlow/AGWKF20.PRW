#include "Protheus.ch"
#include  "TbiConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGWKF20   º Autor ³ REINALDO MAGALHAES º Data ³  30/10/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Orcamentos convertidos em vendas                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AGWKF20
  Local cQuebra := ""
  Local aVendas := {}
  Local cDataIni,cDataFim,nMes,nAno,cMes,cAno,cNota
  Local nCtaOrcT,nCtaOrcF,nVlrOrcT, nVlrOrcF

  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"
  
  nMes := Month(Date()) //- mês corrente
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

  //- Itens do orçamento
  DbSelectArea("SCK")
  U_MsSetOrder("SCK","CK_FILIAL+CK_NUM+CK_ITEM+CK_PRODUTO")

  //- Pedido de vendas
  DbSelectArea("SC5")
  U_MsSetOrder("SC5","C5_FILIAL+C5_NUM")

  MontaQry(cDataIni,cDataFim)
  
  dbGoTop()
  
  Do While !XXX->(Eof())           
     nCtaOrcT := 0
     nCtaOrcF := 0
     nVlrOrcT := 0
     nVlrOrcF := 0
     aVendas  := {}

     cQuebra:= XXX->CJ_VEND1
     
     Do While !XXX->(Eof()) .And. XXX->CJ_VEND1 == cQuebra
        nCtaOrcT++
        nVlrOrcT := nVlrOrcT + XXX->CK_VALOR 
        cNota:=""
        
        If SCK->(dbSeek(xFilial("SCK")+XXX->CJ_NUM))
	       If SC5->(DbSeek(xFilial("SC5")+SCK->CK_NUMPV))
	          If !Empty(SC5->C5_NOTA)
	             nCtaOrcF++
                 nVlrOrcF:= nVlrOrcF + XXX->CK_VALOR
                 cNota:= SC5->C5_NOTA
              Endif
           Endif   
        Endif
        AADD(aVendas,{ XXX->DIAS, ;
                       XXX->CK_VALOR, ;
	                   XXX->CJ_CLIENTE,;
                       Posicione("SA1",1,xFilial("SA1")+CJ_CLIENTE+XXX->CJ_LOJA,"A1_NOME"),;
                       XXX->CJ_NUM,;
                       Transform(XXX->CK_VALOR,"@E 999,999.99"),;
                       Posicione("SA3",1,xFilial("SA3")+XXX->CJ_VEND1,"A3_NREDUZ"),;
                       Dtoc(XXX->CJ_EMISSAO),;
                       cNota })
        XXX->(DbSkip())           
     Enddo            
     cEmail := Posicione("SA3",1,xFilial("SA3")+cQuebra,"A3_EMAIL")
     EnvEmail(aVendas,cEmail,nCtaOrcT,nCtaOrcF,nVlrOrcT,nVlrOrcF,cMes,cAno) //- Envia o email
  Enddo
  XXX->(dbCloseArea())
  ConOut("SAIU!")
  RESET ENVIRONMENT
Return
                        
//////////////////////////////////////////////////////////////////////////////////////
Static Function EnvEmail(aVendas,cEmail,nCtaOrcT,nCtaOrcF,nVlrOrcT,nVlrOrcF,cMes,cAno)
  Local cUser := "", cPass := "", cSendSrv := "", cMsg := ""
  Local nSendPort := 0, nSendSec := 2, nTimeout := 0
  Local xRet
  Local oServer, oMessage
  Local cHtml   := ""
  Local nConta  := 0 
  Local nTotal  := 0 
  Local nAtraso := 0 
  Local cTitulo := "Orcamentos Convertidos em Venda Ref: " + MesExt(Val(cMes))+"/"+Substr(cAno,3,2)
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando corpo do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cHtml := '<html><head><title>Orçamentos Convertidos em Venda</title>'
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
  cHtml += ' <th scope="col">Nota</th>'
  cHtml += ' </tr>'        
  
  Asort(aVendas,,, {|x,y| x[8] < y[8]})

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
  nPerc := (nCtaOrcF / nCtaOrcT) * 100
  
  cHtml += ' <tr>'
  cHtml += ' <td> Valor Orcamento</td>'
  cHtml += ' <td> R$' + Transform(nVlrOrcT,"@E 999,999,999.99") + '</td>'
  cHtml += ' </tr>' 
  
  cHtml += ' <td> Valor Realizado</td>'
  cHtml += ' <td> R$' + Transform(nVlrOrcF,"@E 999,999,999.99") + '</td>'
  cHtml += ' </tr>' 
  
  cHtml += ' <td> Percentual</td>'  
  cHtml += ' <td>' + Transform(nPerc,"@E 999.99") + '%</td>'
  cHtml += ' </tr>' 
  
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando dados para envio do email webmail: https://webmail-seguro.com.br/arrodriguez.com.br/ ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando o envio do email  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  oMessage := TMailMessage():New()
  oMessage:Clear()
  oMessage:cDate := cValToChar( Date() )
  oMessage:cFrom := cUser
  oMessage:cTo := Trim(GetMv("MV_EMAILV")) //"reinaldo.magalhaes2014@gmail.com"
  //oMessage:cCC := "reinaldo.magalhaes2014@gmail.com" //Trim(GetMv("MV_EMAILV"))
   
  oMessage:cBody := cHtml
  oMessage:MsgBodyType( "text/html" )
  oMessage:cSubject := "20-"+cTitulo
  
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
  cQry += "AND CJ_NUM=C.CK_NUM "
  cQry += "ORDER BY CJ_VEND1 "
  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )

  TcSetField("XXX","CJ_EMISSAO","D",8,0)

Return

//////////////////////////////
Static Function MesExt( nMes )  
  Local aMes:= {}
  aMes:= AADD(aMes, {'JANEIRO','FEVEREIRO','MARCO','ABRIL','MAIO','JUNHO','JULHO','AGOSTO','SETEMBRO','OUTUBRO','NOVEMBRO','DEZEMBRO'} )
Return aMes[nMes]