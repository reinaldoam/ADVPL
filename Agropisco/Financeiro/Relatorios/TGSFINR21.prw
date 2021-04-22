#include "Protheus.CH"
#include "font.CH"
#include "RwMake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ TGSFINR11  ¦ Autor ¦ Tecnise              ¦ Data ¦ 12/11/15   ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Fluxo de caixa realizado                                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function TGSFINR21
  Local aSay    := {}
  Local aButton := {}
  Local nOpc    := 0
  Local cPerg   := "TGSF11"
  Local cTitulo := "Impressão de Fluxo de Caixa Realizado"
  Local cDesc1  := "Este programa efetuará a impressão da movimentação de entarada e saida"
  Local cDesc2  := "nos bancos.                                                           "

  Private dDtIni,dDtFim

  ValidPerg(cPerg)

  Pergunte(cPerg,.F.)

  aAdd( aSay, cDesc1 )
  aAdd( aSay, cDesc2 )

  aAdd( aButton, { 5, .T., {|| Pergunte( cPerg, .T. ) }} )
  aAdd( aButton, { 1, .T., {|x| nOpc := 1, FechaBatch() }} )
  aAdd( aButton, { 2, .T., {|x| nOpc := 2, FechaBatch() }} )

  FormBatch( cTitulo, aSay, aButton )

  If nOpc == 1
     Processa({|| RReport(),"Processando Dados"})  
  Endif
  
Return Nil
                
///////////////////////
Static Function RReport
  Local nCol,nLin,nPosR,nPosP,nTotLinha,nTotSaldo:= 0
  
  Local aFluxoR := {}
  Local aFluxoP := {}
  Local aSaldoAt:= {}
  
  Private nRegis:=0

  oPrint:= TMSPrinter():New( "Fluxo de Caixa Realizado" )
  oPrint:SetPortrait() // ou SetLandscape()
  
  ProcRegua(nRegis)
  
  //Parâmetros de TFont.New()
  //1.Nome da Fonte (Windows)
  //3.Tamanho em Pixels
  //5.Bold (T/F)                             
  
  //cFonte:= "Times New Roman"
  cFonte:= "Arial"
  //cFonte:= "Courier New"
  
  oFont8  := TFont():New(cFonte,9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
  oFont9  := TFont():New(cFonte,9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
  oFont9n := TFont():New(cFonte,9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
  oFont10 := TFont():New(cFonte,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
  oFont12 := TFont():New(cFonte,9,12,.T.,.T.,5,.T.,5,.T.,.F.)
  oFont14 := TFont():New(cFonte,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
  oFont16 := TFont():New(cFonte,9,16,.T.,.T.,5,.T.,5,.T.,.F.)
  oFont16n:= TFont():New(cFonte,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
  oFont18 := TFont():New(cFonte,9,18,.T.,.T.,5,.T.,5,.T.,.F.)
  oFont20 := TFont():New(cFonte,9,20,.T.,.T.,5,.T.,5,.T.,.F.)
  oFont24 := TFont():New(cFonte,9,24,.T.,.T.,5,.T.,5,.T.,.F.)
  //oBrush := TBrush():New("",4)
  oBrush := TBrush():NEW("",CLR_HGRAY) //Cinza
                    
  //341=Itau/ 001=BB/ 104=CEF/ 237=Bradesco/ 003=BASA/ 033=Santander

  aFluxoR := FluxoCx() // Entradas
  aFluxoP := FluxoCx() // Saidas

  MontaQry()

  XXX->(dbGotop())
  
  Do While !XXX->(EOF())
     
     IncProc()
     
     nPosR:= aScan(aFluxoR,{|x| x[1] = E5_DTDISPO })
     nPosP:= aScan(aFluxoP,{|x| x[1] = E5_DTDISPO })
     
     Do Case 
        Case XXX->E5_BANCO == "341" //--- Itau
           If XXX->E5_RECPAG == "R"
              aFluxoR[nPosR][2]+= XXX->E5_VALOR
           Else
              aFluxoP[nPosP][2]+= XXX->E5_VALOR
           Endif
        Case XXX->E5_BANCO == "001" //--- BB
           If XXX->E5_RECPAG == "R"
              aFluxoR[nPosR][3]+= XXX->E5_VALOR
           Else
              aFluxoP[nPosP][3]+= XXX->E5_VALOR
           Endif
        Case XXX->E5_BANCO == "104" //--- CEF
           If XXX->E5_RECPAG == "R"
              aFluxoR[nPosR][4]+= XXX->E5_VALOR
           Else
              aFluxoP[nPosP][4]+= XXX->E5_VALOR
           Endif
        Case XXX->E5_BANCO == "237" //--- Bradesco
           If XXX->E5_RECPAG == "R"
              aFluxoR[nPosR][5]+= XXX->E5_VALOR
           Else
              aFluxoP[nPosP][5]+= XXX->E5_VALOR
           Endif
        Case XXX->E5_BANCO == "003" //--- BASA
            If XXX->E5_RECPAG == "R"
              aFluxoR[nPosR][6]+= XXX->E5_VALOR
           Else
              aFluxoP[nPosP][6]+= XXX->E5_VALOR
           Endif
        Case XXX->E5_BANCO == "033" //--- Santander
           If XXX->E5_RECPAG == "R"
              aFluxoR[nPosR][7]+= XXX->E5_VALOR
           Else
              aFluxoP[nPosP][7]+= XXX->E5_VALOR
           Endif
     EndCase                                
     XXX->(DbSkip())
  Enddo   
  XXX->(dbCloseArea())

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ INICIO DA IMPRESSAO               ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nLinIni1 := 105
  nColIni1 := 30
  nLin1    := nLinIni1

  nCol11 := nColIni1+30
  nCol12 := nCol11+200
  nCol13 := nCol12+200
  nCol14 := nCol13+200 
  nCol15 := nCol14+200 
  nCol16 := nCol15+200 
  nCol17 := nCol16+200 
  nCol18 := nCol17+200              
       
  nColFim:= nCol18+250
  
  oPrint:StartPage()
  
  oPrint:Say(nLin1-35,nCol12+70, "ENTRADAS NO PERIODO DE " + Dtoc(mv_par01) + " a " + Dtoc(mv_par02),oFont9)

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Imprimindo nome dos bancos       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  oPrint:Say(nLin1,nCol12+70, "ITAU",oFont9) 
  oPrint:Say(nLin1,nCol13+50, "BRASIL",oFont9) 
  oPrint:Say(nLin1,nCol14+70, "CAIXA",oFont9) 
  oPrint:Say(nLin1,nCol15+20, "BRADESCO",oFont9) 
  oPrint:Say(nLin1,nCol16+70, "BASA",oFont9) 
  oPrint:Say(nLin1,nCol17+20, "SANTANDER",oFont9) 
  oPrint:Say(nLin1,nCol18+70, "TOTAL",oFont9)
  nLin1 += 50                 
  oPrint:Line(nLin1,nColIni1,nLin1,nColFim)
  nLin1 += 30 
 
  aSaldo:= BuscaSaldo() 
                                                                       
  aEval( aSaldo, {|x| nTotSaldo += x[2] })  // Totaliza saldos iniciais

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Imprimindo Saldos iniciais       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  oPrint:Say(nLin1,nCol11, "SALDO INICIAL",oFont9 ) 
  oPrint:Say(nLin1,nCol12, Transform(aSaldo[1,2],"@E 999,999,999.99"),oFont9) 
  oPrint:Say(nLin1,nCol13, Transform(aSaldo[2,2],"@E 999,999,999.99"),oFont9) 
  oPrint:Say(nLin1,nCol14, Transform(aSaldo[3,2],"@E 999,999,999.99"),oFont9) 
  oPrint:Say(nLin1,nCol15, Transform(aSaldo[4,2],"@E 999,999,999.99"),oFont9) 
  oPrint:Say(nLin1,nCol16, Transform(aSaldo[5,2],"@E 999,999,999.99"),oFont9) 
  oPrint:Say(nLin1,nCol17, Transform(aSaldo[6,2],"@E 999,999,999.99"),oFont9) 
  oPrint:Say(nLin1,nCol18, Transform(nTotSaldo,"@E 999,999,999.99"),oFont9)
  nLin1 += 30                 
  oPrint:Line(nLin1,nColIni1,nLin1,nColFim)
  nLin1 += 25 
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ IMPRIMINDO ENTRADAS NO BANCO     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  aFluxoR := aSort(aFluxoR,,, { |x, y| x[1] < y[1] })

  nPos := Len(aFluxoR)   

  For i:= 1 to Len(aFluxoR)
     For j:= 2 to 7
        aFluxoR[nPos][j] += aFluxoR[i][j]
     Next
  Next

  For i:= 1 to Len(aFluxoR)
     nTotLinha:= aFluxoR[i][2]+aFluxoR[i][3]+aFluxoR[i][4]+aFluxoR[i][5]+aFluxoR[i][6]+aFluxoR[i][7]
     If nTotLinha > 0 //.Or. aFluxoR[i][1] == "ZZZZZZ" 
        If aFluxoR[i][1] == "ZZZZZZ"
           oPrint:Say(nLin1,nCol11, "TOTAL",oFont9) 
        Else                                                           
           oPrint:Say(nLin1,nCol11, FormatData(aFluxoR[i][1]),oFont9 ) 
        Endif   
        oPrint:Say(nLin1,nCol12, Transform(aFluxoR[i][2],"@E 999,999,999.99"),oFont9 ) // 341=Itau
        oPrint:Say(nLin1,nCol13, Transform(aFluxoR[i][3],"@E 999,999,999.99"),oFont9 ) // 001=BB
        oPrint:Say(nLin1,nCol14, Transform(aFluxoR[i][4],"@E 999,999,999.99"),oFont9 ) // 104=CEF
        oPrint:Say(nLin1,nCol15, Transform(aFluxoR[i][5],"@E 999,999,999.99"),oFont9 ) // 237=Bradesco 
        oPrint:Say(nLin1,nCol16, Transform(aFluxoR[i][6],"@E 999,999,999.99"),oFont9 ) // 003=BASA
        oPrint:Say(nLin1,nCol17, Transform(aFluxoR[i][7],"@E 999,999,999.99"),oFont9 ) // 033=Santander
        oPrint:Say(nLin1,nCol18, Transform(nTotLinha,"@E 999,999,999.99"),oFont9 )
        nLin1 += 35                 
        If aFluxoR[i][1] <> "ZZZZZZ"                              
           oPrint:Line(nLin1,nColIni1,nLin1,nColFim)
           nLin1 += 20 
        Endif   
     Endif   
  Next                                       

   // Box da principal
  oPrint:Box(nLinIni1,nColIni1,nLin1,nColFim)
  
  //Linhas verticais  
  oPrint:Line(nLinIni1,nCol11+200,nLin1,nCol11+200)
  oPrint:Line(nLinIni1,nCol12+200,nLin1,nCol12+200)
  oPrint:Line(nLinIni1,nCol13+200,nLin1,nCol13+200)
  oPrint:Line(nLinIni1,nCol14+200,nLin1,nCol14+200)
  oPrint:Line(nLinIni1,nCol15+200,nLin1,nCol15+200)
  oPrint:Line(nLinIni1,nCol16+200,nLin1,nCol16+200)
  oPrint:Line(nLinIni1,nCol17+200,nLin1,nCol17+200)

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ IMPRIMINDO SAIDAS NOS BANCOS      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nLinIni2:= nLin1+100
  nLin2   := nLinIni2

  aFluxoP := aSort(aFluxoP,,, { |x, y| x[1] < y[1] })

  nPos := Len(aFluxoP)   

  For i:= 1 to Len(aFluxoP)
     For j:= 2 to 7
        aFluxoP[nPos][j] += aFluxoP[i][j]
     Next
  Next

  oPrint:Say(nLin2-35,nCol12+70, "SAIDAS NO PERIODO DE " + Dtoc(mv_par01) + " a " + Dtoc(mv_par02),oFont9)

  For i:= 1 to Len(aFluxoP)
     nTotLinha:= aFluxoP[i][2]+aFluxoP[i][3]+aFluxoP[i][4]+aFluxoP[i][5]+aFluxoP[i][6]+aFluxoP[i][7]
     If nTotLinha > 0 //.Or. aFluxoP[i][1] == "ZZZZZZ"  
        If aFluxoP[i][1] == "ZZZZZZ"
           oPrint:Say(nLin2,nCol11, "TOTAL",oFont9) 
        Else                                                           
           oPrint:Say(nLin2,nCol11, FormatData(aFluxoP[i][1]),oFont9 ) 
        Endif   
        oPrint:Say(nLin2,nCol12, Transform(aFluxoP[i][2],"@E 999,999,999.99"),oFont9 ) // 341=Itau
        oPrint:Say(nLin2,nCol13, Transform(aFluxoP[i][3],"@E 999,999,999.99"),oFont9 ) // 001=BB
        oPrint:Say(nLin2,nCol14, Transform(aFluxoP[i][4],"@E 999,999,999.99"),oFont9 ) // 104=CEF
        oPrint:Say(nLin2,nCol15, Transform(aFluxoP[i][5],"@E 999,999,999.99"),oFont9 ) // 237=Bradesco 
        oPrint:Say(nLin2,nCol16, Transform(aFluxoP[i][6],"@E 999,999,999.99"),oFont9 ) // 003=BASA
        oPrint:Say(nLin2,nCol17, Transform(aFluxoP[i][7],"@E 999,999,999.99"),oFont9 ) // 033=Santander
        oPrint:Say(nLin2,nCol18, Transform(nTotLinha,"@E 999,999,999.99"),oFont9 )
        nLin2 += 35                 
        If aFluxoP[i][1] <> "ZZZZZZ"                              
           oPrint:Line(nLin2,nColIni1,nLin2,nColFim)
           nLin2 += 20 
        Endif   
     Endif   
  Next                                       

  // Box da principal
  oPrint:Box(nLinIni2,nColIni1,nLin2,nColFim)
  
  //Linhas verticais  
  oPrint:Line(nLinIni2,nCol11+200,nLin2,nCol11+200)
  oPrint:Line(nLinIni2,nCol12+200,nLin2,nCol12+200)
  oPrint:Line(nLinIni2,nCol13+200,nLin2,nCol13+200)
  oPrint:Line(nLinIni2,nCol14+200,nLin2,nCol14+200)
  oPrint:Line(nLinIni2,nCol15+200,nLin2,nCol15+200)
  oPrint:Line(nLinIni2,nCol16+200,nLin2,nCol16+200)
  oPrint:Line(nLinIni2,nCol17+200,nLin2,nCol17+200)
  nLinIni2+= 35
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ IMPRIMINDO SALDO ATUAL           ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nPosR := Len(aFluxoR)
  nPosP := Len(aFluxoP)
      
  AADD(aSaldoAt,{0.00, 0.00, 0.00, 0.00, 0.00, 0.00})  
 
  For i:= 1 to Len(aSaldoAt)*6
     aSaldoAt[1][i] := aSaldo[i,2] + aFluxoR[nPosR][i+1] - aFluxoP[nPosP][i+1]
  Next   

  oPrint:Say(nLin2,nCol11, "SALDO ATUAL",oFont9 ) 
  oPrint:Say(nLin2,nCol12, Transform(aSaldoAt[1,1],"@E 999,999,999.99"),oFont9) 
  oPrint:Say(nLin2,nCol13, Transform(aSaldoAt[1,2],"@E 999,999,999.99"),oFont9) 
  oPrint:Say(nLin2,nCol14, Transform(aSaldoAt[1,3],"@E 999,999,999.99"),oFont9) 
  oPrint:Say(nLin2,nCol15, Transform(aSaldoAt[1,4],"@E 999,999,999.99"),oFont9) 
  oPrint:Say(nLin2,nCol16, Transform(aSaldoAt[1,5],"@E 999,999,999.99"),oFont9) 
  oPrint:Say(nLin2,nCol17, Transform(aSaldoAt[1,6],"@E 999,999,999.99"),oFont9) 
  //oPrint:Say(nLin2,nCol18, Transform(nTotSaldo,"@E 999,999,999.99"),oFont9)
  
  // Box da principal
  oPrint:Box(nLin2,nColIni1,nLin2+35,nColFim)
  //oPrint:FillRect({nLin2-35,nColIni1+1,nLin2+34,nColFim},oBrush)

  //Linhas verticais  
  oPrint:Line(nLin2,nCol11+200,nLin2+35,nCol11+200)
  oPrint:Line(nLin2,nCol12+200,nLin2+35,nCol12+200)
  oPrint:Line(nLin2,nCol13+200,nLin2+35,nCol13+200)
  oPrint:Line(nLin2,nCol14+200,nLin2+35,nCol14+200)
  oPrint:Line(nLin2,nCol15+200,nLin2+35,nCol15+200)
  oPrint:Line(nLin2,nCol16+200,nLin2+35,nCol16+200)
  oPrint:Line(nLin2,nCol17+200,nLin2+35,nCol17+200)
  nLin2 += 35                 

  oPrint:Line(nLin2,nColIni1,nLin2,nColFim)

  oPrint:EndPage()     // Finaliza a página
  oPrint:Preview()     // Visualiza antes de imprimir

Return

//////////////////////////
Static Function MontaQry()
  Local cQuery := ""

  cQuery := " SELECT COUNT(*)SOMA "
  cQuery += " FROM "+RetSQLName("SE5")+" A "
  cQuery += " WHERE A.D_E_L_E_T_ <> '*' "  
  cQuery += " AND E5_DTDISPO BETWEEN '"+dTos(mv_par01)+"' AND '"+dTos(mv_par02)+"' " 
  cQuery += " AND E5_RECONC='x'"

  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
  nRegis := SOMA             
  dbCloseArea()

  //cQuery := " SELECT SUBSTRING(E5_DTDISPO,7,2)+'/'+SUBSTRING(E5_DTDISPO,5,2)+'/'+SUBSTRING(E5_DTDISPO,3,2) AS DATACONC,"
  cQuery := " SELECT E5_DTDISPO,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_HISTOR,E5_DOCUMEN,E5_PREFIXO,E5_NUMERO,E5_RECPAG,E5_VALOR, "
  cQuery += " ENTRADA = CASE  WHEN E5_TIPODOC <> 'TR' AND E5_RECPAG = 'R' THEN E5_VALOR ELSE 0 END, "
  cQuery += " SAIDA   = CASE  WHEN E5_TIPODOC <> 'TR' AND E5_RECPAG = 'P' THEN E5_VALOR ELSE 0 END, "
  cQuery += " ENT_TF  = CASE  WHEN E5_TIPODOC = 'TR' AND E5_RECPAG = 'R' THEN E5_VALOR ELSE 0 END, "
  cQuery += " SAI_TF  = CASE  WHEN E5_TIPODOC = 'TR' AND E5_RECPAG = 'P' THEN E5_VALOR ELSE 0 END, "
  cQuery += " E5_TIPO,E5_TIPODOC "
  cQuery += " FROM "+RetSQLName("SE5")+" A "
  cQuery += " WHERE A.D_E_L_E_T_ <> '*' "  
  cQuery += " AND E5_DTDISPO BETWEEN '"+dTos(mv_par01)+"' AND '"+dTos(mv_par02)+"' " 
  cQuery += " AND E5_RECONC='x'"
  cQuery += " ORDER BY E5_DATA "
        
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
          		
Return	 
                       
////////////////////////                
Static Function FluxoCX 
  Local aFluxo   := {}
  Local dDataIni := mv_par01
  Local dDataFim := mv_par02
  
  While dDataIni <= dDataFim         
     //            Data/ 341=Itau/ 001=BB/ 104=CEF/ 237=Bradesco/ 003=BASA/ 033=Santander
     AADD(aFluxo,{ Dtos(dDataIni), 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, ""})  
     dDataIni++
  Enddo
  AADD(aFluxo,{"ZZZZZZ", 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 })                 
Return aFluxo

////////////////////////////////
Static Function ValidPerg(cPerg)
  PutSx1(cPerg, "01", "Data De                ?","","","mv_ch1","D", 8,0,0,"G","","","","","mv_par01")
  PutSx1(cPerg, "02", "Data Ate               ?","","","mv_ch2","D", 8,0,0,"G","","","","","mv_par02")
  putSx1(cPerg, "03", "Conciliação            ?","","","mv_ch3","C", 1,0,0,"C","","","","","mv_par03","Conciliados","","","","Todos","","","","Não Conciliados","","","","","")
Return

//////////////////////////////////
Static Function FormatData(cData)
Return (Substr(cData,7,2)+"/"+Substr(cData,5,2)+"/"+Substr(cData,3,2))

///////////////////////////
Static Function BuscaSaldo 
  Local nPos:=0         
  Local aSaldo:= LerSaldo()
  Local aSaldoBco:= {}
  
  AADD(aSaldoBco, {"341", 0.00} ) // Banco Itaú            
  AADD(aSaldoBco, {"001", 0.00} ) // Banco do Brasil           
  AADD(aSaldoBco, {"104", 0.00} ) // Caixa           
  AADD(aSaldoBco, {"237", 0.00} ) // Bradesco           
  AADD(aSaldoBco, {"003", 0.00} ) // Basa           
  AADD(aSaldoBco, {"033", 0.00} ) // Santader          
  
  For i:= 1 to Len(aSaldoBco)
     nPos:= aScan(aSaldo,{|x| x[1] = aSaldoBco[i,1]})
     aSaldoBco[i,2] := IIF(nPos > 0, aSaldo[nPos,2], 0) 
  Next
Return aSaldoBco 
  
/////////////////////////
Static function LerSaldo
  Local nSaldoAtu := 0
  Local nSaldoIni := 0
  Local aSdoBco   := {}   
  
  dbSelectArea("SA6")
  dbSetOrder(1)	   
  
  Do While !SA6->(Eof())
    
     If SA6->A6_FLUXCAI == "S"

        dbSelectArea("SE8")
        dbSetOrder(1)			
  
        dbSeek( xFilial("SE8")+SA6->(A6_COD+A6_AGENCIA+A6_NUMCON)+Dtos(mv_par01),.T.)
        dbSkip(-1)
	
        If E8_FILIAL != xFilial("SE8") .Or. E8_BANCO!=SA6->A6_COD .or. E8_AGENCIA!=SA6->A6_AGENCIA .or. E8_CONTA!=SA6->A6_NUMCON .or. BOF() .or. EOF()
           nSaldoAtu:=0
	       nSaldoIni:=0
        Else                     
           If mv_par03 == 1  //Todos       
              nSaldoAtu:=Round(xMoeda(E8_SALATUA,1,1,SE8->E8_DTSALAT),2)
			  nSaldoIni:=Round(xMoeda(E8_SALATUA,1,1,SE8->E8_DTSALAT),2)
   		   ElseIf mv_par03 == 2 //Conciliados
			  nSaldoAtu:=Round(xMoeda(E8_SALRECO,1,1,SE8->E8_DTSALAT),2)
			  nSaldoIni:=Round(xMoeda(E8_SALRECO,1,1,SE8->E8_DTSALAT),2)
		   ElseIf mv_par03 == 3	//Nao Conciliados
			  nSaldoAtu:=Round(xMoeda(E8_SALATUA-E8_SALRECO,1,1,SE8->E8_DTSALAT),2)
			  nSaldoIni:=Round(xMoeda(E8_SALATUA-E8_SALRECO,1,1,SE8->E8_DTSALAT),2)
		   Endif	
        Endif
        nPos:= aScan(aSdoBco,{|x| x[1] = SA6->A6_COD })
        
        If nPos = 0    
           //             Banco/Saldo inicial/Saldo Anterior  
           AADD(aSdoBco,{ SA6->A6_COD, 0.00, 0.00 })  
           nPos:= Len(aSdoBco)
        Endif
        aSdoBco[nPos][2] += nSaldoIni
        aSdoBco[nPos][3] += nSaldoAtu
     Endif
     dbSelectArea("SA6")
     DbSkip()
  Enddo    		
Return aSdoBco                                                                   
