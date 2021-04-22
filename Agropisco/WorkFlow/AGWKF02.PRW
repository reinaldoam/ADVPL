#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGWKF02   º Autor ³ REINALDO MAGALHAES º Data ³  09/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Workflow para envio automatico de vendas semanal.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AGWKF02
  Local cUser := "", cPass := "", cSendSrv := ""
  Local cMsg := "", cMsgA := "", aData := ""
  Local nSendPort := 0, nSendSec:= 2, nTimeout := 0
  Local xRet
  Local oServer, oMessage
  
  Private cTitulo,cDtSemIni,cDtSemFim
  
  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"
                  
  conout("AGWKF02 - entrou em "+DtoC(Date())+ " as " + Time())
           
  aData:= QryPeriodo()
  
  cDtSemIni := aData[1,1]
  cDtSemFim := aData[1,2]                        
  
  cTitulo:= "COMISSAO SEMANAL DE " + FormatData(cDtSemIni) + ' a ' + FormatData(cDtSemFim) + ' - Mes Ref. : ' + MesExt(Month(Date()))+"/"+Substr(Str(Year(Date()),4),3,2) 
     
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando corpo do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cHtml := '<html><head><title>Untitled Document</title>'
  cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
  cHtml += '</head><body><table width="100%" border="1" bordercolor="#66CCFF" bgcolor="#DFEFFF">'
  cHtml += ' <th scope="col">Codigo</th>'
  cHtml += ' <th scope="col">Vendedor</th>'

  //- Vendas no dia
  cHtml += ' <th scope="col">Vl.PC.Balcão (dia)</th>'
  cHtml += ' <th scope="col">Vl.PC.Serv. (dia)</th>'  
  cHtml += ' <th scope="col">Vl.Equip.(dia)</th>'
  cHtml += ' <th scope="col">Vl.Outros(dia)</th>'
  cHtml += ' <th BGCOLOR=BLUE scope="col" >Venda dia</th>'

  //- Vendas na semana                                 
  cHtml += ' <th scope="col">Vl.Ac.PC.Balcão (Sem)</th>' 
  cHtml += ' <th scope="col">Vl.Ac.PC.Serv. (Sem)</th>'   
  cHtml += ' <th scope="col">Vl.Ac.Equip.(Sem)</th>' 
  cHtml += ' <th scope="col">Vl.Ac.Outros(Sem)</th>' 
  cHtml += ' <th BGCOLOR=BLUE scope="col">Venda Semana</th>' 
  
  //- Vendas no mês
  cHtml += ' <th scope="col">Vl.Ac.PC.Balcão(Mes)</th>' 
  cHtml += ' <th scope="col">Vl.Ac.PC.Serv. (Mes)</th>'   
  cHtml += ' <th scope="col">Vl.Ac.Equip.(Mes)</th>' 
  cHtml += ' <th scope="col">Vl.Ac.Outros(Mes)</th>' 
  cHtml += ' <th BGCOLOR=BLUE scope="col">Venda Mes</th>' 

  //- Comissão
  cHtml += ' <th scope="col">Comissao Semana</th>'
  cHtml += ' <th scope="col">%Meta30Mil</th>'  
  cHtml += ' <th scope="col">%Meta50Mil</th>' 
  cHtml += ' <th scope="col">%Meta500Mil</th>' 
  cHtml += ' </tr>'        
                     
  cHtml += CorpoEmail()
  
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando dados para envio do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cUser := Trim(GetMv("MV_RELACNT"))   //"workflow@arrodriguez.com.br"
  cPass := Trim(GetMv("MV_RELAPSW"))   //"arrm41l@2016"
  cSendSrv := "br484.hostgator.com.br" //email-ssl.com.br
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
  
  conout("AGWKF02 - saiu em "+DtoC(Date())+ " as " + Time())

  RESET ENVIRONMENT
  
return

//////////////////////////
Static Function CorpoEmail
  Local cMsg:="", nExpiraEm, nCountL
                
  Local nVlBVenSem  := 0    
  Local nVlBLstSem  := 0
  Local nVlCVenSem  := 0
  Local nVlBVenMes  := 0

  Local nVlTotCom   := 0
  Local nTotPcaDia  := 0
  Local nTotEquiDia := 0
  Local nTotOutrDia := 0
  Local nTotVndDia  := 0

  Local nTotPcaSem  :=  0
  Local nTotEquiSem :=  0
  Local nTotOutrSem :=  0
  Local nTotVndSem  :=  0
  
  Local nTotPcaMes  :=  0
  Local nTotEquiMes :=  0
  Local nTotOutrMes :=  0
  Local nTotVndMes  :=  0
  Local nTotComSem  :=  0

  Local nBasePca  := 0 //- Peças 
  Local nBaseEqui := 0 //- Equipamentos
  Local nBaseOutr := 0 //- Outros (Serviço ou Locaçao)
  
  Local nRegis      := 0
  Local cAuxDoc     := ""
  Local cAuxSer     := ""
  Local cAuxVend    := ""
  Local nCalcCom1   := 0
  Local nCalcCom2   := 0
  Local nVBasDia    := 0       
  Local nVComDia    := 0
  Local nMeta30mil  := 0
  Local nMeta50mil  := 0
  Local nMeta500mil := 0
                
  Local nVlDiaPca   := 0
  Local nVlDiaEqui  := 0
  Local nVlDiaOutr  := 0               
                 
  Local nVlSemPca   := 0
  Local nVlSemEqui  := 0
  Local nVlSemOutr  := 0               
                 
  Local nVlMesPca   := 0
  Local nVlMesEqui  := 0
  Local nVlMesOutr  := 0               
                       
  Local cMesCorIni  := Substr(Dtos(Date()),1,6)+"01" 
  Local cMesCorFim  := Substr(Dtos(Date()),1,6)+"31"
  
  Private cCfPeca  := Getmv("MV_CFPECA")
  Private cCfServ  := Getmv("MV_CFSERV")
  Private cTesLoca := Getmv("MV_TESLOCA")

  mv_par01 := xFilial("SD2")
  mv_par02 := xFilial("SD2")
  mv_par03 := Getmv("MV_XCOMINI") // colocar na tabela de periodos de comissao
  mv_par04 := Getmv("MV_XCOMFIM") // colocar na tabela de periodos de comissao
  mv_par05 := "      "
  mv_par06 := "ZZZZZZ"
  mv_par07 := 4
  mv_par08 := "   "
  mv_par09 := "ZZZ"
  mv_par10 := "      "
  mv_par11 := "ZZZZZZ"
           
  dbSelectArea("SA3")
  U_MsSetOrder("SA3","A3_FILIAL+A3_COD")
  
  dbSelectArea("SD2")
  U_MsSetOrder("SD2","D2_FILIAL+D2_COD+D2_LOCAL+D2_NUMSEQ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima

  MontaQry()

  dbGoTop()

  Do While !XXX->(EOF())
   
     If !VerifSD1()	   
        cAuxDoc := XXX->D2_DOC
        cAuxSer := XXX->D2_SERIE
        lImp    := .T.
	    XXX->(dbSkip())
	    Loop 	  
     EndIf
   
     If cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE
                            
        SA3->(DbSeek(xFilial("SA3")+XXX->F2_VEND1))
                                                                                   
        aVendaCom := QryVend(XXX->F2_DOC,XXX->F2_SERIE,XXX->F2_CLIENTE,XXX->F2_LOJA,SA3->A3_XSEGMEN)  
         
        nBase     := aVendaCom[1][1]  
        nPrcLista := aVendaCom[1][2]
        
        nBasePca  := aVendaCom[1][3] //- Peças 
        nBaseEqui := aVendaCom[1][4] //- Equipamentos
        nBaseOutr := aVendaCom[1][5] //- Outros (Serviço ou Locaçao)
        
        nDesc     := IIF(nBase > nPrcLista, 0, (1-(nBase/nPrcLista))*100)  
        nAcre     := IIF(nBase > nPrcLista, ((nBase/nPrcLista)-1)*100,0)
      
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Regra para cálculo de percentual de comissão baseado em desconto  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If nDesc = 0
           nCalcCom1 := 1 // as vendas que não tiverem descontos  1% de comissão
        ElseIf nDesc > 0 .And. nDesc <= 3    
           nCalcCom1 := 0.7 // as vendas que  tiverem até 3% de desconto  0,7% de comissão
        ElseIf nDesc > 3 .And. nDesc <= 5
           nCalcCom1 := 0.5 // as vendas que  tiverem de 3,1% até 5% de desconto  0,5% de comissão
        ElseIf nDesc > 5    
           nCalcCom1 := 0.5 // as vendas que  tiverem mais de 5% de desconto  0,25% de comissão
        Endif
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Regra para cálculo de percentual de comissão baseado em acrescimo ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If nAcre > 5
           nCalcCom1 := 1.50
        Endif   
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Total de vendas dia     ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If XXX->D2_EMISSAO = Dtos(Date())
           nVBasDia += nBase       
           nVComDia += (nCalcCom1 * nBase)/100
           nVlDiaPca  += nBasePca  //- Vendas dia Peças  
           nVlDiaEqui += nBaseEqui //- Vendas dia Equipamentos
           nVlDiaOutr += nBaseOutr //- Vendas dia Outros (Serviço ou Locaçao)
        Endif
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Total de vendas na semana  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If XXX->D2_EMISSAO >= cDtSemIni .And. XXX->D2_EMISSAO <= cDtSemFim    
           nVlBVenSem += nBase    
           nVlBLstSem += nPrcLista
           nVlCVenSem += (nCalcCom1 * nBase)/100 
           nVlSemPca  += nBasePca  //- Vendas semana Peças  
           nVlSemEqui += nBaseEqui //- Vendas semana Equipamentos
           nVlSemOutr += nBaseOutr //- Vendas semana Outros  (Serviço ou Locaçao)
        Endif
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Calculo da comissão mensal ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If XXX->D2_EMISSAO >= cMesCorIni .And. XXX->D2_EMISSAO <= cMesCorFim 
           nVlBVenMes += nBase  
           nVlMesPca  += nBasePca  //- Vendas mês Peças
           nVlMesEqui += nBaseEqui //- Vendas mês Equipamentos
           nVlMesOutr += nBaseOutr //- Vendas mês Outros  (Serviço ou Locaçao)
        Endif     
     Endif        

     U_MsSetOrder("SF4","F4_FILIAL+F4_CODIGO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
   
     SF4->(dbSeek(xFilial("SF4")+XXX->D2_TES))
            
     cAuxDoc  := XXX->D2_DOC
     cAuxSer  := XXX->D2_SERIE                                       
     cAuxVend := XXX->F2_VEND1 
   
     XXX->(dbSkip()) // Avanca o ponteiro do registro no arquivo

     If cAuxVend <> XXX->F2_VEND1
      
        nValBDesc := (1-(nVlBVenSem/nVlBLstSem)) * 100
                                            
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Calculo de metas 30 mil e 50 mil  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        nMeta30mil  := (nVlBVenSem/30000) * 100
        nMeta50mil  := (nVlBVenSem/50000) * 100 
        nMeta500mil := (nVlBVenMes/500000) * 100

        nMeta30mil  := If(nMeta30mil > 100, 100, nMeta30mil)
        nMeta50mil  := If(nMeta50mil > 100, 100, nMeta50mil)
        nMeta500mil := If(nMeta500mil > 100, 100, nMeta500mil)
                                                 
        ++nCountL
        
        cMsg += ' <tr>'
    	cMsg += ' <td>' + cAuxVend + '</td>'
        cMsg += ' <td>' + Posicione("SA3",1,xFilial("SA3")+AllTrim(cAuxVend),"A3_NOME") + '</td>'
                                                             
        //- Vendas no dias                                                                                                        
        cMsg += ' <td align="center">' + TRANSFORM(nVlDiaPca , "@E 999,999.99") + '</td>'            // Vendas dia peças
        cMsg += ' <td align="center">' + TRANSFORM(nVlDiaEqui, "@E 999,999.99") + '</td>'            // Vendas dia equipamentos
        cMsg += ' <td align="center">' + TRANSFORM(nVlDiaOutr, "@E 999,999.99") + '</td>'            // Vendas dia outros
        cMsg += ' <td BGCOLOR=BLUE align="center">' + TRANSFORM(nVBasDia, "@E 999,999.99") + '</td>' // Vendas dia total
        
        //- Vendas na semana
        cMsg += ' <td align="center">' + TRANSFORM(nVlSemPca , "@E 999,999.99") + '</td>'   // Vendas acumulada semana peças
        cMsg += ' <td align="center">' + TRANSFORM(nVlSemEqui, "@E 999,999.99") + '</td>'   // Vendas acumulada semana equipamento
        cMsg += ' <td align="center">' + TRANSFORM(nVlSemOutr, "@E 999,999.99") + '</td>'   // Vendas acumulada semana outros
        cMsg += ' <td BGCOLOR=BLUE align="center">' + TRANSFORM(nVlBVenSem, "@E 999,999.99") + '</td>'   // Vendas acumulada semana
        
        //- Vendas no mês
        cMsg += ' <td align="center">' + Transform(nVlMesPca , "@E 999,999.99") + '</td>'   // Vendas acumulada mes peças
        cMsg += ' <td align="center">' + Transform(nVlMesEqui, "@E 999,999.99") + '</td>'   // Vendas acumulada mes equipamentos
        cMsg += ' <td align="center">' + Transform(nVlMesOutr, "@E 999,999.99") + '</td>'   // Vendas acumulada mes outros
        cMsg += ' <td BGCOLOR=BLUE align="center">' + Transform(nVlBVenMes, "@E 999,999.99") + '</td>'   // Vendas acumulada mes 
        
        //- Comissão
        cMsg += ' <td align="center">' + TRANSFORM(nVlCVenSem, "@E 999,999.99") + '</td>'   // Comissao vendas acumuladas
        cMsg += ' <td align="center">' + Transform(nMeta30mil,"@E 999.99")+"%" + '</td>'
        cMsg += ' <td align="center">' + Transform(nMeta50mil,"@E 999.99")+"%" + '</td>'
        cMsg += ' <td align="center">' + Transform(nMeta500mil,"@E 999.99")+"%" + '</td>'
        cMsg += ' </tr>'

        //- Vendas Dia
        nTotPcaDia  += nVlDiaPca  //- Peças
        nTotEquiDia += nVlDiaEqui //- Equipamentos
        nTotOutrDia += nVlDiaOutr //- Outros
        nTotVndDia  += nVBasDia   //- Total

        //- Vendas Semana
        nTotPcaSem  += nVlSemPca   //- Peças
        nTotEquiSem += nVlSemEqui  //- Equipamento
        nTotOutrSem += nVlSemOutr  //- Outros
        nTotVndSem  += nVlBVenSem  //- Total

        //- Vendas mês        
        nTotPcaMes  += nVlMesPca   //- Peças
        nTotEquiMes += nVlMesEqui  //- Equipamentos
        nTotOutrMes += nVlMesOutr  //- Outros
        nTotVndMes  += nVlBVenMes  //- Total 
        
        nTotComSem  += nVlCVenSem  //- Comissao vendas acumuladas

        nVlSemPca  := 0
        nVlSemEqui := 0
        nVlSemOutr := 0
        nVlBVenSem := 0
        nVlCVenSem := 0
	    nVlBLstSem := 0       
        nVlDiaPca  := 0
        nVlDiaEqui := 0
        nVlDiaOutr := 0
        nVBasDia   := 0       
        nVComDia   := 0
        nVlMesPca  := 0 
        nVlMesEqui := 0 
        nVlMesOutr := 0
        nVlBVenMes := 0
     EndIf
  Enddo

  XXX->(dbCloseArea())    
  
  cMsg += ' <tr><font color="#333333"><strong>'
  cMsg += ' <td>' + Space(6) + '</td>'
  cMsg += ' <td>' + Space(40) + '</td>'
  
  //- Acumulados venda dia
  cMsg += ' <td align="center">' + Transform(nTotPcaDia, "@E 999,999.99") + '</td>'  //- Pecas
  cMsg += ' <td align="center">' + Transform(nTotEquiDia, "@E 999,999.99") + '</td>' //- Equipamento
  cMsg += ' <td align="center">' + Transform(nTotOutrDia, "@E 999,999.99") + '</td>' //- Outros
  cMsg += ' <td BGCOLOR=BLUE align="center">' + Transform(nTotVndDia, "@E 999,999.99") + '</td>'  //- Total
  
  //- Acumulado vendas semana
  cMsg += ' <td align="center">' + Transform(nTotPcaSem, "@E 999,999.99") + '</td>'  //- Peças
  cMsg += ' <td align="center">' + Transform(nTotEquiSem, "@E 999,999.99") + '</td>' //- Equipamentos
  cMsg += ' <td align="center">' + Transform(nTotOutrSem, "@E 999,999.99") + '</td>' //- Outros
  cMsg += ' <td BGCOLOR=BLUE align="center">' + Transform(nTotVndSem, "@E 999,999.99") + '</td>'  //- Total
  
  //- Acumulado vendas mês
  cMsg += ' <td align="center">' + Transform(nTotPcaMes, "@E 999,999.99") + '</td>'  //- Peças
  cMsg += ' <td align="center">' + Transform(nTotEquiMes, "@E 999,999.99") + '</td>' //- Equipamentos
  cMsg += ' <td align="center">' + Transform(nTotOutrMes, "@E 999,999.99") + '</td>' //- Outros
  cMsg += ' <td BGCOLOR=BLUE align="center">' + Transform(nTotVndMes, "@E 999,999.99") + '</td>'  //- Total 
  
  cMsg += ' <td align="center">' + Transform(nTotComSem, "@E 999,999.99") + '</td>'  //- Total comissão semana
  
  cMsg += ' <td align="center">' + Space(7) + '</td>'
  cMsg += ' <td align="center">' + Space(7) + '</td>'
  cMsg += ' <td align="center">' + Space(7) + '</td>'
  cMsg += ' </tr>'
  
  //cMsg += ' </table>'
  //--- Fim da tabela                                         
  
  //cMsg += '<br /><b>Qtde de vendedores: ' + AllTrim(Str(nCountL)) +'</b>'
  
  //cMsg += Repli(' <br />',2)
Return cMsg
                 
//////////////////////////
Static Function MontaQry()
  Local aVet:={}
  Local cQuery := ""
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Gera matriz com todos os vendedores ativos ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  SA3->(DbGotop())
  Do while !SA3->(Eof())
     If SA3->A3_MSBLQL <> "1"               
        //1=VEND*2=NOME*3=FAT.PECAS*4=FAT.EQUIP*5=FAT.SERVICOS*6=FAT.LOCACAO*7=TOTAL FATURADO*8=COMISSAO PECAS*9=(%)*10=COMISSAO EQUIPAMENTO*11=(%)*12=COMISSAO SERVICO*13=(%)*14=COMISSAO LOCACAO*15=(%)*16=VALOR EXTRA*17=COMISSAO EXTRA*18=SEGMENTO
        AADD(aVet, {SA3->A3_COD,SA3->A3_NREDUZ, 0.00, 0.00, 0.00,	0.00, 0.00,	0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, SA3->A3_XSEGMEN })
     Endif
     SA3->(DbSkip())
  Enddo   
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Gera matriz com todos os vendedores ativos ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cQuery := " SELECT COUNT(*)SOMA "
  cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
  cQuery +=          RetSQLName("SB1")+" SB1, "
  cQuery +=          RetSQLName("SF2")+" SF2 "
  cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "  
  cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
  cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
  cQuery += " AND F2_DOC = D2_DOC " 
  cQuery += " AND F2_SERIE = D2_SERIE "
  cQuery += " AND D2_COD = B1_COD "
  cQuery += " AND B1_X_COMIS IN(' ','S') "
  cQuery += " AND F2_VEND1 <> '000016' "  
  cQuery += " AND D2_PRCVEN <> 0    
  cQuery += " AND B1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D2_EMISSAO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "  
  cQuery += " AND F2_EMISSAO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " 
  cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
  cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
  cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
  cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933' OR D2_CF = '5404' OR D2_CF = '6404' OR D2_CF = '5405' OR D2_CF = '6405')"
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
  nRegis := SOMA             
  dbCloseArea()

  cQuery := StrTran(cQuery,"COUNT(*)SOMA", "*")
  cQuery += " ORDER BY F2_VEND1,D2_DOC,D2_SERIE, D2_CF "
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
          		
Return	 
                        
//////////////////////////
Static Function VerifSD1()
        
  Local cQuery := ""
  Local lRet   := .F.

  cQuery := " SELECT D1_TIPO, D1_NFORI, D1_SERIORI,D1_ITEMORI "
  cQuery += " FROM "+RetSQLName("SD1")+" SD1 "   
  cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "
  cQuery += " AND D1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D1_NFORI = '"+XXX->D2_DOC+"' " 
  cQuery += " AND D1_SERIORI = '"+XXX->D2_SERIE+"' " 
  cQuery += " AND D1_ITEMORI = '"+XXX->D2_ITEM+"' "
  cQuery += " AND D1_TES <> '232' "
                  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
  lRet := YYY->(EOF())
  YYY->(dbCloseArea())

Return lRet                       

///////////////////////////
Static Function QryPeriodo
 Local cQuery   := ""
 Local aPeriodo := {}                                
 Local cHoje    := Dtos(Date())
 
 cQuery := " SELECT * "
 cQuery += " FROM "+RetSQLName("SZB")+" SZB "
 cQuery += " WHERE SZB.D_E_L_E_T_ <> '*' "
 cQuery += " AND ZB_FILIAL = '"+xFilial("SZB")+"' "                 
 cQuery += " AND ZB_DATAINI <= '"+cHoje+"' "
 cQuery += " AND ZB_DATAFIM >= '"+cHoje+"' "
 
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
                                            
 AAdd(aPeriodo, {TMP->ZB_DATAINI, TMP->ZB_DATAFIM})

 TMP->(dbCloseArea())
                                                                                                     
Return aPeriodo             

/////////////////////////////////////////////////////////////
Static Function QryVend(cNota, cSerie, cCliente, cLoja, cSeg)
  Local cQuery    := ""
  Local nPrcLista := 0.00
  Local aVendaCom := {}
                                                       
  //- Criar campo B1_XTIPO C(1) onde 1=Peça/ 2=Equipamento/ 3=Outros
  cQuery := " SELECT D2_DOC,D2_SERIE,D2_COD,D2_ITEM,D2_XPRCTAB,D2_QUANT,D2_TOTAL,D2_CF,D2_TES,B1_XTPPROD "
  cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
  cQuery +=          RetSQLName("SB1")+" SB1 "
  cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
  cQuery += " AND SB1.D_E_L_E_T_ <> '*' "  
  cQuery += " AND B1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D2_DOC = '"+cNota+"' "                 
  cQuery += " AND D2_SERIE = '"+cSerie+"' "
  cQuery += " AND D2_CLIENTE = '"+cCliente+"' "
  cQuery += " AND D2_LOJA = '"+cLoja+"' "
  cQuery += " AND D2_COD = B1_COD "
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
                                            
  // aVendaCom[1][1] //- Peças
  // aVendaCom[1][2] //- Equipamentos
  // aVendaCom[1][3] //- Serviços
  // aVendaCom[1][4] //- Locação                
  // aVendaCom[1][5] //- Total                

  AADD(aVendaCom, {0, 0, 0, 0, 0})

  Do while !TMP->(Eof())
     If !VerifSD1()
	    TMP->(dbSkip())  	   
	    Loop
 	 EndIf 
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Validar se é venda, serviço ou locação  ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     If cSeg = "S"      //- Vendedor do segmento de serviços
        //If TMP->D2_SERIE = "SR1" .Or. TMP->D2_SERIE = 'RPS'
        If Alltrim(TMP->D2_COD) == '11' .Or. Alltrim(TMP->D2_COD) == '001364'
           aVendaCom[1][3] += TMP->D2_TOTAL // Serviços
        Else 
           aVendaCom[1][1] += TMP->D2_TOTAL // Peças
        Endif   
     ElseIf cSeg = "L"  //- Vendedor do segmento de locação	 
        aVendaCom[1][4] += TMP->D2_TOTAL
     Else // vendedor do segmento de peças ou equipamentos    	 
	    If TMP->B1_XTPPROD = "P" 
	       aVendaCom[1][1] += TMP->D2_TOTAL
	    ElseIf TMP->B1_XTPPROD = "E"
	       aVendaCom[1][2] += TMP->D2_TOTAL
	    Else
           //If TMP->D2_SERIE = "SR1" .Or. TMP->D2_SERIE = 'RPS'
           If Alltrim(TMP->D2_COD) == '11' .Or. Alltrim(TMP->D2_COD) == '001364'
              aVendaCom[1][3] += TMP->D2_TOTAL // Serviços
	       Else
	          aVendaCom[1][4] += TMP->D2_TOTAL // Colocado pra ver a diferença no relorio 
	       Endif   
	    Endif
	 Endif
     aVendaCom[1][5] += TMP->D2_TOTAL
     TMP->(dbSkip()) 
  Enddo
  TMP->(dbCloseArea())
Return aVendaCom 

//////////////////////////////////
Static Function FormatData(cData)
  cDatac := Substr(cData,7,2) + "/"
  cDatac += Substr(cData,5,2) + "/"
  cDatac += Substr(cData,3,2)
Return cDatac
  
//////////////////////////////
Static Function MesExt( nMes )  
  Local aMes:= {}
  aMes:= AADD(aMes, {'JANEIRO','FEVEREIRO','MARCO','ABRIL','MAIO','JUNHO','JULHO','AGOSTO','SETEMBRO','OUTUBRO','NOVEMBRO','DEZEMBRO'} )
Return aMes[nMes]