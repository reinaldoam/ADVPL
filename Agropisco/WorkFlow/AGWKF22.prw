#INCLUDE "Protheus.ch"
#INCLUDE "TbiConn.ch"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGWKF22   º Autor ³ REINALDO MAGALHAES º Data ³  04/11/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Workflow para envio automatico de vendas semanal.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AGWKF22
  Local cUser := "", cPass := "", cSendSrv := ""
  Local cMsg := "", cMsgA := "", aData := ""
  Local nSendPort := 0, nSendSec:= 2, nTimeout := 0 //nSendSec := 1
  Local xRet
  Local oServer, oMessage
  
  Private cTitulo,cDtSemIni,cDtSemFim,cCfPeca,cCfServ,cTesLoca
  Private mv_par01 := "02" 
  Private mv_par02 := "02" 
  Private mv_par03 := " " 
  Private mv_par04 := " " 
  Private mv_par05 := "      "
  Private mv_par06 := "ZZZZZZ"
  Private mv_par07 := 4
  Private mv_par08 := "   "
  Private mv_par09 := "ZZZ"
  Private mv_par10 := "      "
  Private mv_par11 := "ZZZZZZ"

  PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02"

  cCfPeca  := getmv("MV_CFPECA")
  cCfServ  := getmv("MV_CFSERV")
  cTesLoca := getmv("MV_TESLOCA")
  mv_par03 := Getmv("MV_XCOMINI") // colocar na tabela de periodos de comissao
  mv_par04 := Getmv("MV_XCOMFIM") // colocar na tabela de periodos de comissao
                  
  conout("AGWKF22 - entrou em "+DtoC(Date())+ " as " + Time())
           
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

  //- Vendedor
  cHtml += ' <th scope="col">Codigo</th>'
  cHtml += ' <th scope="col">Vendedor</th>'

  //- Vendas no dia
  cHtml += ' <th scope="col">Vl.PC.Balcão (Dia)</th>'
  cHtml += ' <th scope="col">Vl.PC.Serv. (Dia)</th>'  
  cHtml += ' <th scope="col">Vl.Equip.(Dia)</th>'
  cHtml += ' <th scope="col">Vl.Serv. (Dia)</th>'
  cHtml += ' <th scope="col">Vl.Loc. (Dia)</th>'
  cHtml += ' <th BGCOLOR=BLUE scope="col" >Venda dia</th>'

  //- Vendas na semana                                 
  cHtml += ' <th scope="col">Vl.PC.Balcão (Sem)</th>'
  cHtml += ' <th scope="col">Vl.PC.Serv. (Sem)</th>'  
  cHtml += ' <th scope="col">Vl.Equip.(Sem)</th>'
  cHtml += ' <th scope="col">Vl.Serv. (Sem)</th>'
  cHtml += ' <th scope="col">Vl.Loc. (Sem)</th>'
  cHtml += ' <th BGCOLOR=BLUE scope="col">Venda Semana</th>' 
  
  //- Vendas no mês
  cHtml += ' <th scope="col">Vl.PC.Balcão (Mes)</th>'
  cHtml += ' <th scope="col">Vl.PC.Serv. (Mes)</th>'  
  cHtml += ' <th scope="col">Vl.Equip.(Mes)</th>'
  cHtml += ' <th scope="col">Vl.Serv. (Mes)</th>'
  cHtml += ' <th scope="col">Vl.Loc. (Mes)</th>'
  cHtml += ' <th BGCOLOR=BLUE scope="col">Venda Mes</th>' 
                     
  cHtml += CorpoEmail()
  
  cHtml += '</strong></font></td></tr></table></body></html>'
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Preparando dados para envio do email ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cUser := Trim(GetMv("MV_RELACNT")) 
  cPass := Trim(GetMv("MV_RELAPSW")) 
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
   
  oMessage:cBody := cHtml
  oMessage:MsgBodyType( "text/html" )
  oMessage:cSubject := "22-"+cTitulo
  
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
  Local cMsg:="", nCountL
                  
  Local aVenDia := {} 
  Local aVenSem := {}
  Local aVenMes := {}
  Local aTotDia := {}
  Local aTotSem := {}
  Local aTotMes := {}
  
  Local cAuxDoc     := ""
  Local cAuxSer     := ""
  Local cAuxVend    := ""
                       
  Local cMesCorIni  := Substr(Dtos(Date()),1,6)+"01" 
  Local cMesCorFim  := Substr(Dtos(Date()),1,6)+"31"
           
  dbSelectArea("SA3")
  U_MsSetOrder("SA3","A3_FILIAL+A3_COD")
  
  dbSelectArea("SD2")
  U_MsSetOrder("SD2","D2_FILIAL+D2_COD+D2_LOCAL+D2_NUMSEQ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima

  //- Valores diarios
  AADD(aVenDia, {0, 0, 0, 0, 0, 0})
  AADD(aVenSem, {0, 0, 0, 0, 0, 0})
  AADD(aVenMes, {0, 0, 0, 0, 0, 0})
             
  //- Valores acumulados
  AADD(aTotDia, {0, 0, 0, 0, 0, 0})
  AADD(aTotSem, {0, 0, 0, 0, 0, 0})
  AADD(aTotMes, {0, 0, 0, 0, 0, 0})
  
  MontaQry()

  dbGoTop()

  Do While !XXX->(EOF())
   
     If cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE
                            
        SA3->(DbSeek(xFilial("SA3")+XXX->F2_VEND1))
                                                                                   
        aVendaCom := QryVend(XXX->F2_DOC,XXX->F2_SERIE,XXX->F2_CLIENTE,XXX->F2_LOJA,SA3->A3_XSEGMEN)  
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Total de vendas dia     ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If XXX->D2_EMISSAO = Dtos(Date())
           aVenDia[1][1]+= aVendaCom[1][1] //- Peça balcão
           aVenDia[1][2]+= aVendaCom[1][2] //- Peça serviço
           aVenDia[1][3]+= aVendaCom[1][3] //- Equipamento
           aVenDia[1][4]+= aVendaCom[1][4] //- Serviço
           aVenDia[1][5]+= aVendaCom[1][5] //- Locação
           aVenDia[1][6]+= aVendaCom[1][6] //- Total
        Endif
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Total de vendas na semana  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If XXX->D2_EMISSAO >= cDtSemIni .And. XXX->D2_EMISSAO <= cDtSemFim    
           aVenSem[1][1]+= aVendaCom[1][1] //- Peça balcão
           aVenSem[1][2]+= aVendaCom[1][2] //- Peça serviço
           aVenSem[1][3]+= aVendaCom[1][3] //- Equipamento
           aVenSem[1][4]+= aVendaCom[1][4] //- Serviço
           aVenSem[1][5]+= aVendaCom[1][5] //- Locação
           aVenSem[1][6]+= aVendaCom[1][6] //- Total
        Endif
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Total Venda Mes            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If XXX->D2_EMISSAO >= cMesCorIni .And. XXX->D2_EMISSAO <= cMesCorFim 
           aVenMes[1][1]+= aVendaCom[1][1] //- Peça balcão
           aVenMes[1][2]+= aVendaCom[1][2] //- Peça serviço
           aVenMes[1][3]+= aVendaCom[1][3] //- Equipamento
           aVenMes[1][4]+= aVendaCom[1][4] //- Serviço
           aVenMes[1][5]+= aVendaCom[1][5] //- Locação
           aVenMes[1][6]+= aVendaCom[1][6] //- Total
        Endif     
     Endif        
            
     cAuxDoc  := XXX->D2_DOC
     cAuxSer  := XXX->D2_SERIE                                       
     cAuxVend := XXX->F2_VEND1 
   
     XXX->(dbSkip()) // Avanca o ponteiro do registro no arquivo

     If cAuxVend <> XXX->F2_VEND1
      
        ++nCountL
        
        cMsg += ' <tr>'
    	cMsg += ' <td>' + cAuxVend + '</td>'
        cMsg += ' <td>' + Posicione("SA3",1,xFilial("SA3")+AllTrim(cAuxVend),"A3_NOME") + '</td>'
                                                             
        //- Vendas no dias                                              
        cMsg += ' <td align="center">' + TRANSFORM(aVenDia[1][1], "@E 999,999.99") + '</td>'              //- Vendas dia peças balcao
        cMsg += ' <td align="center">' + TRANSFORM(aVenDia[1][2], "@E 999,999.99") + '</td>'              //- Vendas dia peças serviço
        cMsg += ' <td align="center">' + TRANSFORM(aVenDia[1][3], "@E 999,999.99") + '</td>'              //- Vendas dia Equipamento
        cMsg += ' <td align="center">' + TRANSFORM(aVenDia[1][4], "@E 999,999.99") + '</td>'              //- Vendas dia Serviço
        cMsg += ' <td align="center">' + TRANSFORM(aVenDia[1][5], "@E 999,999.99") + '</td>'              //- Vendas dia Locação        
        cMsg += ' <td BGCOLOR=BLUE align="center">' + TRANSFORM(aVenDia[1][6], "@E 999,999.99") + '</td>' //- Vendas dia total
        
        //- Vendas na semana
        cMsg += ' <td align="center">' + TRANSFORM(aVenSem[1][1], "@E 999,999.99") + '</td>'              //- Vendas semana peças balcão
        cMsg += ' <td align="center">' + TRANSFORM(aVenSem[1][2], "@E 999,999.99") + '</td>'              //- Vendas semana peças serviço
        cMsg += ' <td align="center">' + TRANSFORM(aVenSem[1][3], "@E 999,999.99") + '</td>'              //- Vendas semana equipamento
        cMsg += ' <td align="center">' + TRANSFORM(aVenSem[1][4], "@E 999,999.99") + '</td>'              //- Vendas semana serviço
        cMsg += ' <td align="center">' + TRANSFORM(aVenSem[1][5], "@E 999,999.99") + '</td>'              //- Vendas semana locação
        cMsg += ' <td BGCOLOR=BLUE align="center">' + TRANSFORM(aVenSem[1][6], "@E 999,999.99") + '</td>' //- Vendas acumulada semana
        
        //- Vendas no mês
        cMsg += ' <td align="center">' + Transform(aVenMes[1][1], "@E 999,999.99") + '</td>'              //- Vendas acumulada mes peças balcão
        cMsg += ' <td align="center">' + Transform(aVenMes[1][2], "@E 999,999.99") + '</td>'              //- Vendas acumulada mes peças serviços
        cMsg += ' <td align="center">' + Transform(aVenMes[1][3], "@E 999,999.99") + '</td>'              //- Vendas acumulada mes Equipamentos
        cMsg += ' <td align="center">' + Transform(aVenMes[1][4], "@E 999,999.99") + '</td>'              //- Vendas acumulada mes Serviço
        cMsg += ' <td align="center">' + Transform(aVenMes[1][5], "@E 999,999.99") + '</td>'              //- Vendas acumulada mes Locação
        cMsg += ' <td BGCOLOR=BLUE align="center">' + Transform(aVenMes[1][6], "@E 999,999.99") + '</td>' //- Vendas acumulada mes 

        //- Acumulando totais e zerandos valores diarios                
        For i:= 1 to 6
           aTotDia[1][i] += aVenDia[1][i]
           aTotSem[1][i] += aVenSem[1][i]
           aTotMes[1][i] += aVenMes[1][i]
           aVenDia[1][i]:= 0
           aVenSem[1][i]:= 0
           aVenMes[1][i]:= 0
        Next   
     EndIf
  Enddo

  XXX->(dbCloseArea())    
  
  cMsg += ' <tr><font color="#333333"><strong>'
  cMsg += ' <td>' + Space(6) + '</td>'
  cMsg += ' <td>' + Space(40) + '</td>'
  
  //- Acumulados venda dia
  cMsg += ' <td align="center">' + Transform(aTotDia[1][1], "@E 999,999.99") + '</td>'               //- Peças balcão
  cMsg += ' <td align="center">' + Transform(aTotDia[1][2], "@E 999,999.99") + '</td>'               //- Peças serviço
  cMsg += ' <td align="center">' + Transform(aTotDia[1][3], "@E 999,999.99") + '</td>'               //- Equipamento
  cMsg += ' <td align="center">' + Transform(aTotDia[1][4], "@E 999,999.99") + '</td>'               //- Serviço
  cMsg += ' <td align="center">' + Transform(aTotDia[1][5], "@E 999,999.99") + '</td>'               //- Locação
  cMsg += ' <td BGCOLOR=BLUE align="center">' + Transform(aTotDia[1][6], "@E 999,999.99") + '</td>'  //- Total
  
  //- Acumulado vendas semana
  cMsg += ' <td align="center">' + Transform(aTotSem[1][1], "@E 999,999.99") + '</td>'               //- Peças balcão
  cMsg += ' <td align="center">' + Transform(aTotSem[1][2], "@E 999,999.99") + '</td>'               //- Peças serviço
  cMsg += ' <td align="center">' + Transform(aTotSem[1][3], "@E 999,999.99") + '</td>'               //- Equipamento
  cMsg += ' <td align="center">' + Transform(aTotSem[1][4], "@E 999,999.99") + '</td>'               //- Serviço
  cMsg += ' <td align="center">' + Transform(aTotSem[1][5], "@E 999,999.99") + '</td>'               //- Locação
  cMsg += ' <td BGCOLOR=BLUE align="center">' + Transform(aTotSem[1][6], "@E 999,999.99") + '</td>'  //- Total
  
  //- Acumulado vendas mês
  cMsg += ' <td align="center">' + Transform(aTotMes[1][1], "@E 999,999.99") + '</td>'               //- Peças balcão
  cMsg += ' <td align="center">' + Transform(aTotMes[1][2], "@E 999,999.99") + '</td>'               //- Peças serviço
  cMsg += ' <td align="center">' + Transform(aTotMes[1][3], "@E 999,999.99") + '</td>'               //- Equipamento
  cMsg += ' <td align="center">' + Transform(aTotMes[1][4], "@E 999,999.99") + '</td>'               //- Serviço
  cMsg += ' <td align="center">' + Transform(aTotMes[1][5], "@E 999,999.99") + '</td>'               //- Locação
  cMsg += ' <td BGCOLOR=BLUE align="center">' + Transform(aTotMes[1][6], "@E 999,999.99") + '</td>'  //- Total 
  
  //cMsg += ' <td align="center">' + Space(7) + '</td>'
  //cMsg += ' <td align="center">' + Space(7) + '</td>'
  //cMsg += ' <td align="center">' + Space(7) + '</td>'
  cMsg += ' </tr>'
  
  //cMsg += ' </table>'
  //--- Fim da tabela                                         
  
  //cMsg += '<br /><b>Qtde de vendedores: ' + AllTrim(Str(nCountL)) +'</b>'
  
  //cMsg += Repli(' <br />',2)
Return cMsg      

//////////////////////////
Static Function MontaQry()
  Local cQuery := ""
  
  cQuery := " SELECT COUNT(*)SOMA "
  cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
  cQuery +=          RetSQLName("SB1")+" SB1, "
  cQuery +=          RetSQLName("SF2")+" SF2, "
  cQuery +=          RetSQLName("SA3")+" SA3 "  
  cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "  
  cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
  cQuery += " AND SF2.D_E_L_E_T_ <> '*' "  
  cQuery += " AND SA3.D_E_L_E_T_ <> '*' "  
  cQuery += " AND F2_DOC = D2_DOC " 
  cQuery += " AND F2_SERIE = D2_SERIE "
  cQuery += " AND D2_COD = B1_COD "
  cQuery += " AND B1_X_COMIS IN(' ','S') "
  cQuery += " AND F2_VEND1 <> '000016' "  
  cQuery += " AND F2_VEND1 = A3_COD "  
  cQuery += " AND D2_PRCVEN <> 0    
  cQuery += " AND B1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D2_EMISSAO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "  
  cQuery += " AND F2_EMISSAO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "  
  cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
  cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
  cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
  cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933' OR D2_CF = '5404' OR D2_CF = '6404' OR D2_CF = '5405' OR D2_CF = '6405' OR D2_CF = '5119' OR D2_CF = '6119')"
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
  nRegis := SOMA             
  dbCloseArea()

  cQuery := StrTran(cQuery,"COUNT(*)SOMA", "*")
  cQuery += " ORDER BY A3_XSEGMEN,F2_VEND1,D2_DOC,D2_SERIE,D2_CF "
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
          		
Return	 

////////////////////////////////////////////////////////////
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
                                            
  // aVendaCom[1][1] //- Peças Balcão
  // aVendaCom[1][2] //- Peças Serviço
  // aVendaCom[1][3] //- Equipamentos
  // aVendaCom[1][4] //- Serviços
  // aVendaCom[1][5] //- Locação                
  // aVendaCom[1][6] //- Total                

  AADD(aVendaCom, {0, 0, 0, 0, 0, 0})

  Do While !TMP->(Eof())
     If !VerifSD1()
	    TMP->(dbSkip())  	   
	    Loop
 	 EndIf 
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Validar se é venda, serviço ou locação  ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     If cSeg = "S" //- Vendedor do Segmento de Serviços
        If Alltrim(TMP->D2_COD) == '11' .Or. Alltrim(TMP->D2_COD) == '001364'
           aVendaCom[1][4] += TMP->D2_TOTAL // Serviços
        Else 
           aVendaCom[1][2] += TMP->D2_TOTAL // Peças de serviços
        Endif   
     ElseIf cSeg = "L"  //- Vendedor do segmento de locação	 
        aVendaCom[1][5] += TMP->D2_TOTAL
     Else // vendedor do segmento de peças ou equipamentos    	 
	    If TMP->B1_XTPPROD = "P" 
	       aVendaCom[1][1] += TMP->D2_TOTAL //- Peças de balcão
	    ElseIf TMP->B1_XTPPROD = "E"
	       aVendaCom[1][3] += TMP->D2_TOTAL
	    Else
           If Alltrim(TMP->D2_COD) == '11' .Or. Alltrim(TMP->D2_COD) == '001364'
              aVendaCom[1][4] += TMP->D2_TOTAL // Serviços
	       Else
	          aVendaCom[1][5] += TMP->D2_TOTAL // Locação (Colocado pra ver a diferença no relorio) 
	       Endif   
	    Endif
	 Endif
     aVendaCom[1][6] += TMP->D2_TOTAL
     TMP->(dbSkip()) 
  Enddo
  TMP->(dbCloseArea())
Return aVendaCom 

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

///////////////////////
Static Function VerifSD1
        
  Local cQuery := ""
  Local lRet   := .F.

  cQuery := " SELECT D1_TIPO, D1_NFORI, D1_SERIORI,D1_ITEMORI "
  cQuery += " FROM "+RetSQLName("SD1")+" SD1 "   
  cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "
  cQuery += " AND D1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D1_NFORI = '"+TMP->D2_DOC+"' " 
  cQuery += " AND D1_SERIORI = '"+TMP->D2_SERIE+"' " 
  cQuery += " AND D1_ITEMORI = '"+TMP->D2_ITEM+"' "
  cQuery += " AND D1_TES <> '232' "
                  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
  lRet := YYY->(EOF())
  YYY->(dbCloseArea())

Return lRet                       

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