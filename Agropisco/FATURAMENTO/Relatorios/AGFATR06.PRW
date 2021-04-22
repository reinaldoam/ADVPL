#INCLUDE "rwmake.ch"

User Function AGFATR06
  Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
  Local cDesc2         := "de acordo com os parametros informados pelo usuario."
  Local cDesc3         := "Relatorio de Itens sem Venda no Periodo"
  Local cPict          := ""
  Local titulo         := "Relatorio de Itens sem Venda no Periodo"
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
  Private nomeprog     := "AGFATR06" // Coloque aqui o nome do programa para impressao no cabecalho
  Private nTipo        := 18
  Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
  Private nLastKey     := 0
  Private cPerg        := "AGFT06"       
  Private m_pag        := 01
  Private cbtxt        := Space(10)
  Private cbcont       := 00
  Private wnrel        := "AGFATR06" // Coloque aqui o nome do arquivo usado para impressao em disco
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

  Titulo += "  TES: " + Alltrim(MV_PAR02)
                                        
  Cabec1 := "CODIGO  LJ  NOME                            CONTATO               TELEFONE      CELULAR       EMAIL                           CNPJ                ULT.COMP"
  //         XXXXX   XX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX  XX-XXXX-XXXX  XX-XXXX-XXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99.999.999/9999-99  99/99/99 
  //         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
  //         0         1         2         3         4         5         6         7         8         9        10        11        12        13         14       15
  
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
     @nLin, 000  PSAY TMP->A1_COD
     @nLin, 008  PSAY TMP->A1_LOJA
     @nLin, 012  PSAY SUBSTR(TMP->A1_NREDUZ,1,30)
     @nLin, 044  PSAY SUBSTR(TMP->A1_CONTATO,1,20)
     @nLin, 066  PSAY SUBSTR(TMP->A1_TEL,1,14)
     @nLin, 080  PSAY TMP->A1_TELEX
     @nLin, 094  PSAY SUBSTR(TMP->A1_EMAIL,1,30)
     @nLin, 126  PSAY TMP->A1_CGC
     @nLin, 146  PSAY TMP->D2_EMISSAO
     TMP->(DbSkip())
     nLin += 1
  Enddo          
      
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
  Local cTES := StrTran(ALLTRIM(MV_PAR02),",","','")   
                                        
  /*
  Local cDataIni := Dtos(MV_PAR01)
  Local cDataFim := Dtos(MV_PAR02)

  cQry := " SELECT D2_COD, B1_DESC, D2_DOC, D2_SERIE, D2_EMISSAO, D2_QUANT,D2_TOTAL"
  cQry += " FROM " 
  cQry += RetSQLName("SD2")+" SD2, "
  cQry += RetSQLName("SB1")+" SB1, "
  cQry += RetSQLName("SA2")+" SA2  "
  cQry += " WHERE SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' "
  cQry += " AND D2_FILIAL='"+xFilial("SD2")+"'"
  cQry += " AND D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " 
  cQry += " AND D2_COD = B1_COD "
  cQry += " AND B1_PROC = A2_COD AND B1_LOJPROC = A2_LOJA"
  cQry += " AND D2_TES IN ('"+ cTES +"') "
  cQry += " AND B1_PROC='"+MV_PAR03+"' "  
  cQry += " AND B1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "  
  cQry += " ORDER BY D2_DOC, D2_SERIE "                                                                  
  */                                           

  cQry := " SELECT A1_COD,A1_LOJA,A1_NREDUZ,A1_CONTATO,A1_TEL,A1_TELEX,A1_EMAIL,A1_CGC,D2_EMISSAO"
  cQry += " FROM "                  
  cQry += RetSQLName("SA1")+" A,"
  cQry += " (SELECT D2_CLIENTE,D2_LOJA,MAX(D2_EMISSAO)D2_EMISSAO"  
  cQry += " FROM "
  cQry += RetSQLName("SD2")+" B "
  cQry += " WHERE B.D_E_L_E_T_ <> '*' "
  cQry += " AND D2_TES IN ('"+ cTES +"') "
  cQry += " AND D2_EMISSAO >= '20120101' "
  cQry += " AND D2_FILIAL='"+xFilial("SD2")+"'"
  cQry += " GROUP BY D2_CLIENTE,D2_LOJA )C"
  cQry += " WHERE A.D_E_L_E_T_ <> '*' "
  cQry += " AND A.A1_PESSOA='J'" 
  cQry += " AND C.D2_CLIENTE = A.A1_COD"
  cQry += " AND C.D2_LOJA = A.A1_LOJA"  
  cQry += " AND C.D2_EMISSAO<='"+Dtos(MV_PAR01)+"' " 

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

  aAdd(aRegs,{cPerg, "01", "Data de Referencia      ?", "" , "", "mv_ch1", "D" ,08, 0 , 0 ,"G", "" , "MV_PAR01", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg, "02", "Informa TES de venda    ?", "" , "", "mv_ch2", "C" ,20, 0 , 0 ,"G", "" , "MV_PAR02", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})

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