#INCLUDE "rwmake.ch"

User Function AGFATR05
  Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
  Local cDesc2         := "de acordo com os parametros informados pelo usuario."
  Local cDesc3         := "Relatorio de Vendas por Fabrica x Produto"
  Local cPict          := ""
  Local titulo         := "Relatorio de Vendas por Fabrica x Produto"
  Local nLin           := 80
  Local Cabec1         := ""
  Local Cabec2         := ""
  Local imprime        := .T.
  Private aOrd         := {} //{"Ordem 01","Ordem 02"}
  Private lEnd         := .F.
  Private lAbortPrint  := .F.
  Private CbTxt        := ""
  Private limite       := 132
  Private tamanho      := "M"
  Private nomeprog     := "AGFATR05" // Coloque aqui o nome do programa para impressao no cabecalho
  Private nTipo        := 18
  Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
  Private nLastKey     := 0
  Private cPerg        := "AGFT05"       
  Private m_pag        := 01
  Private cbtxt        := Space(10)
  Private cbcont       := 00
  Private wnrel        := "AGFATR05" // Coloque aqui o nome do arquivo usado para impressao em disco
  Private cString      := "SD2"

  ValidPerg(cPerg)

  Pergunte(cPerg,.F.)

  wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,"",.F.)
  
  If nLastKey == 27
     Return
  Endif

  SetDefault(aReturn,cString)

  If nLastKey == 27
     Return
  Endif

  nTipo := If(aReturn[4]==1,15,18)

  RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/////////////////////////////////////////////////////
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
                                                      
  Local nTotalGeral:= 0

  Titulo += " Da " + Posicione("SA2", 1, xFilial("SA2")+MV_PAR03, "A2_NREDUZ")
  Titulo += " De " + Dtoc(MV_PAR01) + " a " + Dtoc(MV_PAR02) + "  TES: " + Alltrim(MV_PAR04)
  
  Cabec1 := "Codigo           Descricao                                                     N.Fiscal     Emissao     Valor     Vendedor"
//           xxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxx/x  99/99/99  999,999.99  999999
//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789023456789023456789023456789012
//           0         1         2         3         4         5         6         7         8         9        10      11       12
  TabTmp()
  
  SetRegua(RecCount())
  
  While !TMP->(EOF())
     
     If lAbortPrint
        @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
        Exit
     Endif

     If nLin > 55
        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
        nLin := 8
     Endif

   	 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	 //³ Inicio da impressao do relatorio    ³
	 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     @nLin, 000  PSAY TMP->D2_COD                
     @nLin, 017  PSAY TMP->B1_DESC                
     @nLin, 079  PSAY TMP->D2_DOC+"/"+TMP->D2_SERIE
     @nLin, 092  PSAY TMP->D2_EMISSAO
     @nLin, 102  PSAY TMP->D2_TOTAL Picture "@E 999,999.99"
     @nLin, 117  PSAY TMP->F2_VEND1      
     
     nTotalGeral += TMP->D2_TOTAL
     
     TMP->(DbSkip())
     nLin += 1
  Enddo          
  nLin += 2
  
  @nLin, 102  PSAY nTotalGeral Picture "@E 999,999.99"
      
  TMP->(dbCloseArea())

  SET DEVICE TO SCREEN

  If aReturn[5]==1
     dbCommitAll()
     SET PRINTER TO
     OurSpool(wnrel)
  Endif

  MS_FLUSH()

Return

/////////////////////////
Static Function TabTmp()

  Local cQry := ""
  Local cTES := StrTran(ALLTRIM(MV_PAR04),",","','")   
  
  Local cDataIni := Dtos(MV_PAR01)
  Local cDataFim := Dtos(MV_PAR02)

  cQry := " SELECT D2_COD, B1_DESC, D2_DOC, D2_SERIE, F2_VEND1, D2_EMISSAO, D2_QUANT, D2_TOTAL"
  cQry += " FROM " 
  cQry += RetSQLName("SD2")+" SD2, "
  cQry += RetSQLName("SB1")+" SB1, "
  cQry += RetSQLName("SA2")+" SA2, "
  cQry += RetSQLName("SF2")+" SF2 "
  cQry += " WHERE SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' "
  cQry += " AND D2_FILIAL='"+xFilial("SD2")+"'"
  cQry += " AND F2_FILIAL='"+xFilial("SF2")+"'"
  cQry += " AND D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " 
  cQry += " AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE "
  cQry += " AND D2_COD = B1_COD "
  cQry += " AND B1_PROC = A2_COD AND B1_LOJPROC = A2_LOJA"
  cQry += " AND D2_TES IN ('"+ cTES +"') "
  cQry += " AND B1_PROC='"+MV_PAR03+"' "  
  cQry += " AND B1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' " 
  cQry += " AND F2_VEND1 BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "  
  cQry += " ORDER BY D2_DOC, D2_SERIE "                                                                  

  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
 
  TcSetField("TMP" , "D2_EMISSAO", "D", 8, 0)  // Formata para tipo Data

  dbSelectArea("TMP")  

Return


/////////////////////////////////
Static Function ValidPerg(cPerg)
  _sAlias := Alias()  
  cPerg   := Padr(cPerg,10)
  DbSelectArea("SX1")
  DbSetOrder(1)
  aRegs :={}

  aAdd(aRegs,{cPerg, "01", "Periodo de              ?", "" , "", "mv_ch1", "D" ,08, 0 , 0 ,"G", "" , "MV_PAR01", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg, "02", "Periodo até             ?", "" , "", "mv_ch2", "D" ,08, 0 , 0 ,"G", "" , "MV_PAR02", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg, "03", "Da Fabrica              ?", "" , "", "mv_ch3", "C" ,06, 0 , 0 ,"G", "" , "MV_PAR03", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SA2",""})
  aAdd(aRegs,{cPerg, "04", "Informa TES de venda    ?", "" , "", "mv_ch4", "C" ,20, 0 , 0 ,"G", "" , "MV_PAR04", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg, "05", "Do Produto              ?", "" , "", "mv_ch5", "C" ,15, 0 , 0 ,"G", "" , "MV_PAR05", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SB1",""})
  aAdd(aRegs,{cPerg, "06", "Ate o Produto           ?", "" , "", "mv_ch6", "C" ,15, 0 , 0 ,"G", "" , "MV_PAR06", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SB1",""})
  aAdd(aRegs,{cPerg, "07", "Do Vendedor             ?", "" , "", "mv_ch7", "C" ,06, 0 , 0 ,"G", "" , "MV_PAR07", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SA3",""})
  aAdd(aRegs,{cPerg, "08", "Ate o Vendedor          ?", "" , "", "mv_ch8", "C" ,06, 0 , 0 ,"G", "" , "MV_PAR08", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SA3",""})

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
  dbSelectArea(_sAlias)
Return

/*
Mark-up = (Lucro unitário)/(Custo Variável unitário) = (Preço – Custo Variável unitário)/(Custo Variável unitário) = (50-25)/25 = 1 ou 100%.

Margem Bruta = (Receita Líquida – Custos Operacionais)/Receita Líquida = 200.000 – 150.000/200.000 = 50.000 / 200.000 = 0,25 ou 25%

Margem Líquida = (Receita Líquida – Custos+Despesas)/Receita Líquida = 200.000 – 170.000 / 200.000 = 30.000 / 200.000 = 0,15 ou 15%
*/