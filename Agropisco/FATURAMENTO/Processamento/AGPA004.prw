#Include "rwmake.ch"
#Include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AGPA004 ³ Autor ³ Reinaldo Magalhães     ³ Data ³ 28/11/17  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Geração de acumulados mensais para 03 anos                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AGPA004
  Local nOpcao  := 0
  Local aSay    := {}
  Local aButton := {}
  Local cDesc1  := OemToAnsi("Este programa irá preencher a classificação     ")
  Local cDesc2  := OemToAnsi("das operações de receitas em peças,equipamentos,")
  Local cDesc3  := OemToAnsi("serviços e locação.                             ")

  Local o       := Nil
  Local oWnd    := Nil
  Local cMsg    := ""

  Private Titulo := OemToAnsi("Geração de acumulados mês/ano")
  Private lEnd   := .F.
  Private cArq   := Space(50)
  Private nRadio := 1

  aAdd( aSay, cDesc1 )
  aAdd( aSay, cDesc2 )
  aAdd( aSay, Space(80))
  aAdd( aSay, Space(80))
  aAdd( aSay, Space(80))
  aAdd( aSay, cDesc3 )

  aAdd(aButton, { 5,.T.,{||  o:oWnd:End() } } )
  aAdd(aButton, { 1,.T.,{|o| nOpcao := 1,o:oWnd:End() } } )
  aAdd(aButton, { 2,.T.,{|o| o:oWnd:End() }} )

  FormBatch( Titulo, aSay, aButton )

  If nOpcao == 1
     Processa({|| AGPA004Proc() }, "Aguarde...", "Processando informações...", .T. )
  Endif
Return                    
              
////////////////////////////
Static Function AGPA004Proc 
  Private cDataIni,cDataFim,cQuery
  Private nRegis   := 0 
  Private cAuxDoc  := ""
  Private cAuxSer  := ""
  Private cCfPeca  := Getmv("MV_CFPECA")
  Private cCfServ  := Getmv("MV_CFSERV")
  Private cTesLoca := Getmv("MV_TESLOCA")
  
  Private dDtFech  := Getmv("MV_XDTFECH") //- Data da geração do arquivo.

  Private cAnoFech := StrZero(Year(dDtFech),4) 
  Private cMesFech := StrZero(Month(dDtFech),2) 
  
  Private nAnoAtu := Year(dDataBase) //- Ano atual
  Private nAnoAnt := nAnoAtu - 2  //- Anos anteriores

  mv_par01 := "01"
  mv_par02 := "02"
  
  If Empty(dDtFech)
     cDataIni:=  StrZero(nAnoAnt,4)+"0101"
  Else    
     cDataIni:= Dtos(dDtFech+1) 
  Endif   
  cDataFim := StrZero(nAnoAtu,4)+"1231"

  //- Vendedores
  dbSelectArea("SA3")
  U_MsSetOrder("SA3","A3_FILIAL+A3_COD")

  //- Acumulados mensais
  DbSelectArea("SZ6")
  DbSetOrder(1)
               
  CriaAnoMes() //- Popula tabela SZ6 com os último 03 anos e meses
  MontaQry()   //- Seleciona vendas nos 03 ultimos anos
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Processando vendas  ³           
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                           
  ProcRegua(nRegis)              
              
  XXX->(DbGotop())
                                            
  Do While !XXX->(Eof())
     IncProc()
     If cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE
        SA3->(DbSeek(xFilial("SA3")+XXX->F2_VEND1))
        GravaSZ6(XXX->D2_FILIAL,XXX->D2_DOC,XXX->D2_SERIE,XXX->D2_CLIENTE,XXX->D2_LOJA,SA3->A3_XSEGMEN)
     Endif
     cAuxDoc := XXX->D2_DOC
     cAuxSer := XXX->D2_SERIE                                       
     XXX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
  Enddo      
  XXX->(dbCloseArea())
  
  If MsgYesNo("Atualiza parâmetro de fechamento do mapa comparativo ?")                             
     PUTMV("MV_XDTFECH", dDataBase)
  Endif   
Return
                          
/////////////////////////
Static Function MontaQry 
  Local cQuery:=""
  cQuery := " SELECT COUNT(*)SOMA "
  cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
  cQuery +=          RetSQLName("SB1")+" SB1, "
  cQuery +=          RetSQLName("SF2")+" SF2 "
  cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' "
  cQuery += " AND F2_DOC = D2_DOC " 
  cQuery += " AND F2_SERIE = D2_SERIE "
  cQuery += " AND D2_COD = B1_COD "
  cQuery += " AND B1_X_COMIS IN(' ','S') "
  cQuery += " AND F2_VEND1 <> '000016' "  
  cQuery += " AND D2_PRCVEN <> 0 "
  cQuery += " AND B1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "  
  cQuery += " AND F2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "  
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
        
////////////////////////////////////////////////////////////////////
Static Function GravaSZ6(cFil, cNota, cSerie, cCliente, cLoja, cSeg)
  Local cQuery    := ""
  Local nPrcLista := 0.00

  cQuery := " SELECT D2_EMISSAO,D2_DOC,D2_SERIE,D2_COD,D2_ITEM,D2_XPRCTAB,D2_QUANT,D2_TOTAL,D2_CF,D2_TES,B1_XTPPROD "
  cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
  cQuery +=          RetSQLName("SB1")+" SB1 "
  cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
  cQuery += " AND SB1.D_E_L_E_T_ <> '*' "  
  cQuery += " AND B1_FILIAL = '"+cFil+"' "
  cQuery += " AND D2_FILIAL = '"+cFil+"' "
  cQuery += " AND D2_DOC = '"+cNota+"' "                 
  cQuery += " AND D2_SERIE = '"+cSerie+"' "
  cQuery += " AND D2_CLIENTE = '"+cCliente+"' "
  cQuery += " AND D2_LOJA = '"+cLoja+"' "
  cQuery += " AND D2_COD = B1_COD "
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )

  TcSetField("TMP", "D2_EMISSAO", "D", 8, 0)  // Formata para tipo Data
                                              
  DbGotop()

  Do While !TMP->(Eof())
     If !VerifSD1()
	    TMP->(dbSkip())  	   
	    Loop
 	 EndIf 
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Validar se é venda, serviço ou locação  ³           
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                           
     //SZ6->Z6_VLREQU  -> Vlr. Equipamento
     //SZ6->Z6_VLRPCBA -> Vlr. Peça balcão
     //SZ6->Z6_VLRPCSR -> Vlr. Peça serviço
     //SZ6->Z6_VLRSERV -> Vlr. Serviço
     //SZ6->Z6_VLRLOCA -> Vlr. Locação
     
     If SZ6->(DbSeek(xFilial("SZ6")+StrZero(Year(TMP->D2_EMISSAO),4)+StrZero(Month(TMP->D2_EMISSAO),2)))
        If cSeg == "S" //- Vendedor do Segmento de Serviços
           If Alltrim(TMP->D2_COD) == '11' .Or. Alltrim(TMP->D2_COD) == '001364'
              Reclock("SZ6",.F.)
              SZ6->Z6_VLRSERV += TMP->D2_TOTAL // Serviços 
              SZ6->(MsUnlock())
           Else 
              Reclock("SZ6",.F.)
              SZ6->Z6_VLRPCSR += TMP->D2_TOTAL // Peças de serviços
              SZ6->(MsUnlock())
           Endif   
        ElseIf cSeg = "L"  //- Vendedor do segmento de Locação	 
           Reclock("SZ6",.F.)
           SZ6->Z6_VLRLOCA += TMP->D2_TOTAL //- Vendedor do segmento de Locação
           SZ6->(MsUnlock())
        Else // vendedor do segmento de peças ou equipamentos    	 
	       If TMP->B1_XTPPROD = "P" 
              Reclock("SZ6",.F.)
              SZ6->Z6_VLRPCBA += TMP->D2_TOTAL //- Peças de balcão
              SZ6->(MsUnlock())
	       ElseIf TMP->B1_XTPPROD = "E"
              Reclock("SZ6",.F.)
              SZ6->Z6_VLREQU += TMP->D2_TOTAL //- Equipamento   
              SZ6->(MsUnlock())
	       Else
              If Alltrim(TMP->D2_COD) == '11' .Or. Alltrim(TMP->D2_COD) == '001364'
                 Reclock("SZ6",.F.)
                 SZ6->Z6_VLRSERV += TMP->D2_TOTAL // Serviços    
                 SZ6->(MsUnlock())
	          Else
                 Reclock("SZ6",.F.)
                 SZ6->Z6_VLRLOCA += TMP->D2_TOTAL //- Locação (Colocado pra ver a diferença no relorio) 
                 SZ6->(MsUnlock())
	          Endif   
	       Endif
	    Endif
	 Endif   
     TMP->(dbSkip()) 
  Enddo
  TMP->(dbCloseArea())
Return
                         
//////////////////////////
Static Function CriaAnoMes
  Local i,j
  For i := nAnoAnt to nAnoAtu
     For j:= 1 to 12
        If !SZ6->(DbSeek(xFilial("SZ6")+StrZero(i,4)+StrZero(j,2)))
           Reclock("SZ6",.T.)
           SZ6->Z6_FILIAL := xFilial("SZ6")
           SZ6->Z6_ANO    := StrZero(i,4)
           SZ6->Z6_MES    := StrZero(j,2)
           SZ6->Z6_MESEXT := MesExt(j)  
           SZ6->(MsUnlock())
        Else    
           //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           //³ Verifica se ano,mes processado é maior ou igual ao ultimo fechamento ³           
           //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                           
           If SZ6->Z6_ANO+SZ6->Z6_MES > cAnoFech+cMesFech
              Reclock("SZ6",.F.)
              SZ6->Z6_VLREQU  := 0
              SZ6->Z6_VLRPCBA := 0
              SZ6->Z6_VLRPCSR := 0
              SZ6->Z6_VLRSERV := 0
              SZ6->Z6_VLRLOCA := 0
              SZ6->(MsUnlock())
           Endif   
        Endif
     Next
  Next
Return

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

//////////////////////////////
Static Function MesExt( nMes )  
  Local aMes:= {}
  aMes:= AADD(aMes, {'JANEIRO','FEVEREIRO','MARCO','ABRIL','MAIO','JUNHO','JULHO','AGOSTO','SETEMBRO','OUTUBRO','NOVEMBRO','DEZEMBRO'} )
Return aMes[nMes]