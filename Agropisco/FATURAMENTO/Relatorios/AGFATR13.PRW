#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGFATR13  º Autor ³ REINALDO MAGALHAES º Data ³  25/09/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ MAPA COMPRATIVO DE VENDAS                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AGFATR13
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Declaracao de Variaveis                                             ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
  Local cDesc2     := "de acordo com os parametros informados pelo usuario."
  Local cDesc3     := "MAPA COMPARATIVO DE VENDAS 03 ANOS"
  Local cPict      := ""
  Local Titulo     := ""
  Local nLin       := 180
  Local Cabec1     := ""  
  Local Cabec2     := ""
  Local imprime    := .T.
  Local aOrd       := {}
  Local aVendaCom  := {}

  Private lEnd       := .F.
  Private lAbortPrint:= .F.
  Private CbTxt      := ""
  Private limite     := 80
  Private tamanho    := "G"
  Private nomeprog   := "AGFATR13" // Coloque aqui o nome do programa para impressao no cabecalho
  Private nTipo      := 18
  Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
  Private nLastKey   := 0
  Private cbtxt      := Space(10)
  Private cbcont     := 00
  Private CONTFL     := 01
  Private m_pag      := 01
  Private wnrel      := "AGFATR13" // Coloque aqui o nome do arquivo usado para impressao em disco
  Private cPerg      := "FATR13" 

  Private cString   := "SD2"                         

  //ValidPerg(cPerg)

  Pergunte(cPerg,.F.)  
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Monta a interface padrao com o usuario...                           ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
  If nLastKey == 27
     Return                               
  Endif
  SetDefault(aReturn,cString)

  Titulo:= "MAPA COMPARATIVO ANUAL 03 ULTIMOS ANOS REF: " + StrZero(mv_par01,4)

  Cabec1 := "RECEITA   ---"+StrZero(mv_par01-2,4)+"(A)---   ---"+StrZero(mv_par01-1,4)+"(B)---   ---"+StrZero(mv_par01,4)+"(C)---   VARIACAO (B-A)   VARIACAO (C-B)"
  //         LOCACAO   99,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99   99,999,999.99
  //         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
  //         0         1         2         3         4         5         6         7         8

  If nLastKey == 27
     Return
  Endif

  nTipo := If(aReturn[4]==1,15,18)

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

//////////////////////////////////////////////////////
Static Function RunReport(Cabec1,Cabec2,Titulo,nLinII)
  Local nVar1  := 0
  Local nVar2  := 0
  Local nX     := 0
  Local nY     := 0
  Local nTAno1 := 0
  Local nTAno2 := 0
  Local nTAno3 := 0
  Local nGAno1 := 0
  Local nGAno2 := 0
  Local nGAno3 := 0
  Local cQuebra:=" "

  Private nRegis   := 0
  Private cAuxDoc  := ""
  Private cAuxSer  := ""
  Private cAuxFil  := ""
  Private nType    := 0
  Private nLin     := 180 
  Private cCfPeca  := getmv("MV_CFPECA")
  Private cCfServ  := getmv("MV_CFSERV")
  Private cTesLoca := getmv("MV_TESLOCA")
  Private aReceita := {}

  //- Vendedores
  dbSelectArea("SA3")
  U_MsSetOrder("SA3","A3_FILIAL+A3_COD")

  dbSelectArea(cString)
  dbSetOrder(1)
                     
  //- Preechendo matriz com 12 meses
  For i:= 1 to 12
     AADD(aReceita, {StrZero(i,2), "V", 0, 0, 0 })
     AADD(aReceita, {StrZero(i,2), "S", 0, 0, 0 })
     AADD(aReceita, {StrZero(i,2), "L", 0, 0, 0 })
  Next   

  Filtro()

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ SETREGUA -> Indica quantos registros serao processados para a regua ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  SetRegua(XXX->(Lastrec()))
  dbGoTop()

  Do While !XXX->(EOF())
     IncRegua()    
     If cAuxFil <> XXX->D2_FILIAL .Or. cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE
        SA3->(DbSeek(xFilial("SA3")+XXX->F2_VEND1))
        QryVend(XXX->D2_FILIAL,XXX->D2_DOC,XXX->D2_SERIE,XXX->F2_CLIENTE,XXX->F2_LOJA,SA3->A3_XSEGMEN)  
     Endif
     cAuxFil := XXX->D2_FILIAL
     cAuxDoc := XXX->D2_DOC
     cAuxSer := XXX->D2_SERIE                                       
     XXX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
  Enddo
  XXX->(dbCloseArea())
  
  //Asort(aReceita,,, {|x,y| x[1] < y[1]})

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Inicio da impressão ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  SetRegua(Len(aReceita))
                                       
  For i:= 1 to Len(aReceita)
     IncRegua()    
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Verifica o cancelamento pelo usuario...                             ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     If lAbortPrint
        @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
        Exit
     Endif
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Impressao do cabecalho do relatorio. . .                            ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     If nLin > 65
        nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)+1
     Endif                        
     If aReceita[i][1] <> cQuebra 
        If nTAno1+nTAno2+nTAno3 > 0
           @nLin, 00 PSay "TOTAL MES"
           @nLin, 10 PSay nTAno1 Picture "@E 99,999,999.99" //- 2015
           @nLin, 26 PSay nTAno2 Picture "@E 99,999,999.99" //- 2016
           @nLin, 42 PSay nTAno3 Picture "@E 99,999,999.99" //- 2017
           nLin++                         
           @ nLin, 000 PSay __PrtThinLine()
           nLin++                         
           nTAno1:=0
           nTAno2:=0
           nTAno3:=0
        Endif
        //@ nLin, 000 PSay __PrtThinLine()
        //nLin++
        @nLin, 00 PSay MesExt(Val(aReceita[i][1]))
        nLin++
        @ nLin, 000 PSay __PrtThinLine()
        nLin++
        cQuebra:= aReceita[i][1]  
     Endif
     nVar1 := aReceita[i][4] - aReceita[i][3]
     nVar2 := aReceita[i][5] - aReceita[i][4]
     
     nTAno1 += aReceita[i][3]
     nTAno2 += aReceita[i][4]
     nTAno3 += aReceita[i][5]
     nGAno1 += aReceita[i][3]
     nGAno2 += aReceita[i][4]
     nGAno3 += aReceita[i][5]
     
     @nLin, 00 PSay IIF(aReceita[i][2]="V","VENDA",IIF(aReceita[i][2]="S","SERVICO","LOCACAO"))
     @nLin, 10 PSay aReceita[i][3] Picture "@E 99,999,999.99" //- 2015
     @nLin, 26 PSay aReceita[i][4] Picture "@E 99,999,999.99" //- 2016
     @nLin, 42 PSay aReceita[i][5] Picture "@E 99,999,999.99" //- 2017
     @nLin, 58 PSay nVar1          Picture "@E 99,999,999.99" //- Variação (B-A)
     @nLin, 74 PSay nVar2          Picture "@E 99,999,999.99" //- Variação (C-B)
     nLin++
  Next
  @ nLin, 000 PSay __PrtThinLine()                    
  nlin++                            
  @nLin, 00 PSay "TOTAL GERAL"
  @nLin, 10 PSay nGAno1 Picture "@E 99,999,999.99" //- 2015
  @nLin, 26 PSay nGAno2 Picture "@E 99,999,999.99" //- 2016
  @nLin, 42 PSay nGAno3 Picture "@E 99,999,999.99" //- 2017
  nLin++
  @ nLin, 000 PSay __PrtThinLine()                    
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Finaliza a execucao do relatorio...                                 ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  SET DEVICE TO SCREEN
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Se impressao em disco, chama o gerenciador de impressao...          ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If aReturn[5]==1
     dbCommitAll()
     SET PRINTER TO
     OurSpool(wnrel)
  Endif
  MS_FLUSH()
Return

//////////////////////////
Static Function Filtro()
  Local cQuery := ""
  Local cDataIni := StrZero(mv_par01-2,4)+'0101' 
  Local cDataFim := StrZero(mv_par01,4)+'1231'

  cQuery := "SELECT SD2.D2_FILIAL,SD2.D2_DOC,SD2.D2_SERIE,SD2.D2_ITEM,SD2.D2_EMISSAO,SF2.F2_VEND1,SD2.D2_COD,SB1.B1_XTPPROD,SD2.D2_TOTAL, "
  cQuery += " SF2.F2_CLIENTE,SF2.F2_LOJA "
  cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
  cQuery +=          RetSQLName("SB1")+" SB1, "
  cQuery +=          RetSQLName("SF2")+" SF2 "
  cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "  
  cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
  cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
  cQuery += " AND F2_FILIAL = D2_FILIAL " 
  cQuery += " AND F2_DOC = D2_DOC " 
  cQuery += " AND F2_SERIE = D2_SERIE "
  cQuery += " AND D2_COD = B1_COD "
  cQuery += " AND B1_X_COMIS IN(' ','S') "
  cQuery += " AND F2_VEND1 <> '000016' "  
  cQuery += " AND D2_PRCVEN <> 0    
  cQuery += " AND B1_FILIAL BETWEEN '01' AND '02' "
  cQuery += " AND D2_FILIAL BETWEEN '01' AND '02' "
  cQuery += " AND F2_FILIAL BETWEEN '01' AND '02' "
  cQuery += " AND D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "  
  cQuery += " AND F2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' "  
  cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
  cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
  cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
  cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933' OR D2_CF = '5404' OR D2_CF = '6404' OR D2_CF = '5405' OR D2_CF = '6405')"
  cQuery += " ORDER BY D2_FILIAL,D2_DOC,D2_SERIE "

  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )

  TcSetField("XXX", "D2_EMISSAO", "D", 8, 0)  // Formata para tipo Data

Return

///////////////////////////////////////////////////////////////////
Static Function QryVend(cFil, cNota, cSerie, cCliente, cLoja, cSeg)
  Local cQuery:= ""
  //- Criar campo B1_XTIPO C(1) onde 1=Peça/ 2=Equipamento/ 3=Outros
  cQuery := " SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_EMISSAO,D2_COD,D2_ITEM,D2_XPRCTAB,D2_QUANT,D2_TOTAL,D2_CF,D2_TES,B1_XTPPROD "
  cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
  cQuery +=          RetSQLName("SB1")+" SB1 "
  cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
  cQuery += " AND SB1.D_E_L_E_T_ <> '*' "                    
  cQuery += " AND D2_FILIAL = '"+cFil+"' "                     
  cQuery += " AND B1_FILIAL = '"+cFil+"' "                   
  cQuery += " AND D2_FILIAL = B1_FILIAL "                     
  cQuery += " AND D2_DOC = '"+cNota+"' "                 
  cQuery += " AND D2_SERIE = '"+cSerie+"' "
  cQuery += " AND D2_CLIENTE = '"+cCliente+"' "
  cQuery += " AND D2_LOJA = '"+cLoja+"' "
  cQuery += " AND D2_COD = B1_COD "
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
                       
  TcSetField("TMP", "D2_EMISSAO", "D", 8, 0)  // Formata para tipo Data

  Do While !TMP->(Eof())
     If !VerifSD1()
	    TMP->(dbSkip())  	   
	    Loop
 	 EndIf 
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Posiciona no ano dentro do array aReceita  ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	 If Year(TMP->D2_EMISSAO) = mv_par01
 	    nY := 5  //- Ano corrente
 	 ElseIf Year(TMP->D2_EMISSAO) = mv_par01-1
 	    nY := 4  //- Penultimo ano
 	 Else        
 	    nY := 3  //- Antepenultimo
 	 Endif   
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Validar se é venda, serviço ou locação  ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     If cSeg = "S"      //- Vendedor do segmento de serviços
        //If TMP->D2_SERIE = "SR1" .Or. TMP->D2_SERIE = 'RPS'
        If Alltrim(TMP->D2_COD) == '11' .Or. Alltrim(TMP->D2_COD) == '001364'
           //- Serviços
           nX:= aScan(aReceita,{|x| x[1]+x[2] = StrZero(Month(TMP->D2_EMISSAO),2)+"S" })
           aReceita[nX,nY] += TMP->D2_TOTAL
        Else 
           //- Vendas
           nX:= aScan(aReceita,{|x| x[1]+x[2] = StrZero(Month(TMP->D2_EMISSAO),2)+"V" })
           aReceita[nX,nY] += TMP->D2_TOTAL
        Endif   
     ElseIf cSeg = "L"  //- Vendedor do segmento de locação	 
        //- Locação
        nX:= aScan(aReceita,{|x| x[1]+x[2] = StrZero(Month(TMP->D2_EMISSAO),2)+"L" })
        aReceita[nX,nY] += TMP->D2_TOTAL
     Else // vendedor do segmento de peças ou equipamentos    	 
	    If TMP->B1_XTPPROD = "P" 
	       //- Vendas 
           nX:= aScan(aReceita,{|x| x[1]+x[2] = StrZero(Month(TMP->D2_EMISSAO),2)+"V" })
           aReceita[nX,nY] += TMP->D2_TOTAL
	    ElseIf TMP->B1_XTPPROD = "E"
	       //- Vendas  
           nX:= aScan(aReceita,{|x| x[1]+x[2] = StrZero(Month(TMP->D2_EMISSAO),2)+"V" })
           aReceita[nX,nY] += TMP->D2_TOTAL
	    Else
           //If TMP->D2_SERIE = "SR1" .Or. TMP->D2_SERIE = 'RPS'
           If Alltrim(TMP->D2_COD) == '11' .Or. Alltrim(TMP->D2_COD) == '001364'
              //- Serviços 
              nX:= aScan(aReceita,{|x| x[1]+x[2] = StrZero(Month(TMP->D2_EMISSAO),2)+"S" })
              aReceita[nX,nY] += TMP->D2_TOTAL
	       Else
	          //- Locação
              nX:= aScan(aReceita,{|x| x[1]+x[2] = StrZero(Month(TMP->D2_EMISSAO),2)+"L" })
              aReceita[nX,nY] += TMP->D2_TOTAL
	       Endif   
	    Endif
	 Endif
     TMP->(dbSkip()) 
  Enddo
  TMP->(dbCloseArea())
Return

//////////////////////////
Static Function VerifSD1()
  Local cQuery := ""
  Local lRet   := .F.

  cQuery := " SELECT D1_TIPO, D1_NFORI, D1_SERIORI,D1_ITEMORI "
  cQuery += " FROM "+RetSQLName("SD1")+" SD1 "   
  cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "
  cQuery += " AND D1_FILIAL = '"+TMP->D2_FILIAL+"' " 
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

////////////////////////////////                              
Static Function ValidPerg(cPerg)
  Local _sAlias := Alias()
  Local aRegs :={}

  DbSelectArea("SX1")
  DbSetOrder(1)

  aAdd(aRegs,{cPerg,"01","Ano Referência ?","","","mv_ch1","N",04,0,0,"G","","mv_par01","","","", "","","","","","","","","","","","","","","","","","","","","","",""})

  For i:=1 to Len(aRegs)
     If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
			   FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	 Endif
  Next
Return