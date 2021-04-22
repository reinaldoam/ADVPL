#INCLUDE "rwmake.ch"

User Function AGFATR04
  Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
  Local cDesc2         := "de acordo com os parametros informados pelo usuario."
  Local cDesc3         := "Relatorio de Vendas de Produtos - 06 meses"
  Local cPict          := ""
  Local titulo         := "Relatorio de Produtos mais vendidos - 06 Meses"
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
  Private nomeprog     := "AGFATR04" // Coloque aqui o nome do programa para impressao no cabecalho
  Private nTipo        := 18
  Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
  Private nLastKey     := 0
  Private cPerg        := "AGFT04"
  Private cbtxt        := Space(10)
  Private cbcont       := 00
  Private CONTFL       := 01
  Private m_pag        := 01
  Private wnrel        := "AGFATR04" // Coloque aqui o nome do arquivo usado para impressao em disco

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
  
  Local nTotalGeral, cNCM, cTES, aProduto:= {}, nPosLin, nPosCol, aTotalAno := {}, nIcmsNo, nIcmsSt  
  Local nAno, nMes, cAnoIni, cAnoFim, cMesIni, cMesFim, cDataIni, cDataFim
  
  nAno:= Year(dDataBase)
  nMes:= Month(dDataBase)
  
  If nMes < 6                 
     cAnoIni := StrZero(nAno-1,4)
     cAnoFim := StrZero(nAno,4)
     cMesIni := StrZero(nMes+7,2)
     cMesFim := StrZero(nMes,2)
  Else
     cAnoIni := StrZero(nAno,4)
     cAnoFim := StrZero(nAno,4)
     cMesIni := StrZero(nMes-5,2)
     cMesFim := StrZero(nMes,2)
  Endif
  cDataIni := cAnoIni+cMesIni+"01"
  cDataFim := cAnoFim+cMesFim+"31" 

  aCabMes := CabMes(Val(cMesIni))

  Titulo += "  TES: " + Alltrim(MV_PAR01)

  Cabec1 := "Codigo          Descricao            TES" 
  
  For i:= 1 to Len(aCabMes)
     Cabec1 += "    " + MesExt(Val(aCabMes[i])) 
  Next

  Cabec1 += "     TOTAL"
  
  TabTmp(cDataIni, cDataFim )
  
  AAdd(aTotalAno, {"TOTAL", 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 })

  While !TMP->(EOF())
     
     cNcm:= SUBSTR(Posicione("SB1",1, xFilial("SB1")+TMP->B1_COD,"B1_POSIPI"),1,8)
     cTes:= Posicione("SB1",1, xFilial("SB1")+TMP->B1_COD,"B1_TS")
     
     //                  1                2                    3    4     5     6     7     8     9     10 
     AAdd(aProduto, {TMP->B1_COD, Substr(TMP->B1_DESC,1,20), cTES, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 })
     
     nPosLin := Len(aProduto)                                 
     nPosCol := aScan(aCabMes, Substr(TMP->ANOMES,5,2))+3
     
     //nPosCol:= Val(Substr(TMP->ANOMES,5,2))+3
     
     aProduto[nPosLin, nPosCol] += TMP->D2_TOTAL
     aProduto[nPosLin, 10]+= TMP->D2_TOTAL
     TMP->(dbSkip())
  Enddo       
  ASORT(aProduto,,, {|x,y| x[10] > y[10]})

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Inicio da impressao do orcamento   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  SetRegua(mv_par04)
  
  nIcmsNo := 0.00
  nIcmsSt := 0.00

  For i:= 1 to mv_par04 // Len(aProduto)  
     
     IncRegua()
     
     If lAbortPrint
        @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
        Exit
     Endif

     If nLin > 55
        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
        nLin := 8
     Endif
     
     @nLin, 000  PSAY aProduto[i,01]                         // Codigo
     @nLin, 016  PSAY aProduto[i,02]                         // Descricao
     @nLin, 037  PSAY aProduto[i,03]                         // TES
     @nLin, 041  PSAY aProduto[i,04] Picture "@E 999,999.99" // MES-01
     @nLin, 053  PSAY aProduto[i,05] Picture "@E 999,999.99" // MES-02
     @nLin, 065  PSAY aProduto[i,06] Picture "@E 999,999.99" // MES-03
     @nLin, 077  PSAY aProduto[i,07] Picture "@E 999,999.99" // MES-04
     @nLin, 089  PSAY aProduto[i,08] Picture "@E 999,999.99" // MES-05
     @nLin, 101  PSAY aProduto[i,09] Picture "@E 999,999.99" // MES-06
     @nLin, 113  PSAY aProduto[i,10] Picture "@E 999,999.99" // TOTAL
     nLin += 1 
     
     nIcmsNo += If(aProduto[i,03] == "501", aProduto[i,10], 0.00)
     nIcmsSt += If(aProduto[i,03] == "525", aProduto[i,10], 0.00)
     
     For k:= 1 to 6
        aTotalAno[1,k+1] += aProduto[i,k+3]
     Next   
  Next
  @nLin, 041  PSAY "----------"
  @nLin, 053  PSAY "----------"
  @nLin, 065  PSAY "----------"
  @nLin, 077  PSAY "----------"
  @nLin, 089  PSAY "----------"
  @nLin, 101  PSAY "----------"
  @nLin, 113  PSAY "----------"
  nLin += 1 

  @nLin, 000  PSAY aTotalAno[1,01]
  @nLin, 041  PSAY aTotalAno[1,02] Picture "@E 999,999.99"
  @nLin, 053  PSAY aTotalAno[1,03] Picture "@E 999,999.99"
  @nLin, 065  PSAY aTotalAno[1,04] Picture "@E 999,999.99"
  @nLin, 077  PSAY aTotalAno[1,05] Picture "@E 999,999.99"
  @nLin, 089  PSAY aTotalAno[1,06] Picture "@E 999,999.99"
  @nLin, 101  PSAY aTotalAno[1,07] Picture "@E 999,999.99"
                                                                                
  For i:= 1 to 6  
     aTotalAno[1,8] += aTotalAno[1,i+1]
  Next
                        
  @nLin, 113  PSAY aTotalAno[1,8] Picture "@E 999,999,999.99"
  nLin += 2
    
  @nLin, 000  PSAY  "ICMS NORMAL : " 
  @nLin, 014  PSAY  nIcmsNo Picture "@E 999,999,999.99"
  nLin++
  
  @nLin, 000  PSAY  "ICMS ST     : "  
  @nLin, 014  PSAY  nIcmsSt Picture "@E 999,999,999.99"
  nLin++
  
  TMP->(dbCloseArea())

  SET DEVICE TO SCREEN

  If aReturn[5]==1
     dbCommitAll()
     SET PRINTER TO
     OurSpool(wnrel)
  Endif

  MS_FLUSH()

Return

///////////////////////////////////////////
Static Function TabTmp(cDataIni, cDataFim)
  Local cQry
  Local cTES := StrTran(ALLTRIM(MV_PAR01),",","','")   

  If MV_PAR05 = 1
     cQry := " SELECT B1_COD, B1_DESC, SUBSTRING(D2_EMISSAO,1,6) ANOMES, SUM(D2_TOTAL)D2_TOTAL"
  Else 
     cQry := " SELECT B1_COD, B1_DESC, SUBSTRING(D2_EMISSAO,1,6) ANOMES, SUM(D2_QUANT)D2_TOTAL"  
  Endif   
  cQry += " FROM " 
  cQry += RetSQLName("SD2")+" SD2, "
  cQry += RetSQLName("SB1")+" SB1  "
  cQry += " WHERE SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' "
  cQry += " AND D2_FILIAL='"+xFilial("SD2")+"'"
  cQry += " AND D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " 
  cQry += " AND D2_COD = B1_COD "
  cQry += " AND D2_TES IN ('"+ cTES +"') "
  cQry += " AND B1_COD BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "  
  cQry += " GROUP BY B1_COD, B1_DESC, SUBSTRING(D2_EMISSAO,1,6) "
  cQry += " ORDER BY B1_COD, ANOMES"

  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
  dbSelectArea("TMP")  
Return

/////////////////////////////////
Static Function ValidPerg(cPerg)
  _sAlias := Alias()  
  cPerg   := Padr(cPerg,10)
  DbSelectArea("SX1")
  DbSetOrder(1)
  aRegs :={}

  aAdd(aRegs,{cPerg,"01","Informa TES de venda    ?", "" , "", "mv_ch1","C" ,20, 0 , 0 ,"G", "" , "MV_PAR01", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg,"02","Do Produto              ?", "" , "", "mv_ch2","C" ,15, 0 , 0 ,"G", "" , "MV_PAR02", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SB1",""})
  aAdd(aRegs,{cPerg,"03","Ate o Produto           ?", "" , "", "mv_ch3","C" ,15, 0 , 0 ,"G", "" , "MV_PAR03", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SB1",""})
  aAdd(aRegs,{cPerg,"04","No. de Produtos         ?", "" , "", "mv_ch4","N" ,06, 0 , 0 ,"G", "" , "MV_PAR04", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg,"05","Critério                ?", "" , "", "mv_ch5","N" ,01 ,0 , 0 ,"C", "" , "MV_PAR05", "Valor","","", "","","Quantidade","","","","","","","","","","","","","","","","","","","",""})

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
             
///////////////////////////////
Static Function CabMes(nMes)   
Local aCabMes:= {}
Do Case
Case nMes = 01                                           
   aCabMes:= AADD(aCabMes, {'01','02','03','04','05','06' })
Case nMes = 02
   aCabMes:= AADD(aCabMes, {'02','03','04','05','06','07' })
Case nMes = 03
   aCabMes:= AADD(aCabMes, {'03','04','05','06','07','08' })
Case nMes = 04
   aCabMes:= AADD(aCabMes, {'04','05','06','07','08','09' })
Case nMes = 05
   aCabMes:= AADD(aCabMes, {'05','06','07','08','09','10' })
Case nMes = 06
   aCabMes:= AADD(aCabMes, {'06','01','02','03','04','05' })
Case nMes = 07
   aCabMes:= AADD(aCabMes, {'07','08','09','10','11','12' })
Case nMes = 08
   aCabMes:= AADD(aCabMes, {'08','09','10','11','12','01' })
Case nMes = 09
   aCabMes:= AADD(aCabMes, {'09','10','11','12','01','02' })
Case nMes = 10
   aCabMes:= AADD(aCabMes, {'10','11','12','01','02','03' })
Case nMes = 11
   aCabMes:= AADD(aCabMes, {'11','12','01','02','03','04' })
Case nMes = 12
   aCabMes:= AADD(aCabMes, {'12','01','02','03','04','05' })
Endcase   
Return aCabMes
                              
//////////////////////////////
Static Function MesExt( nMes )  
  Local aMes:= {}
  aMes:= AADD(aMes, {'JANEIRO','FEVEREIRO','MARCO','ABRIL','MAIO','JUNHO','JULHO','AGOSTO','SETEMBRO','OUTUBRO','NOVEMBRO','DEZEMBRO'} )
Return aMes[nMes]

/*
Mark-up = (Lucro unitário)/(Custo Variável unitário) = (Preço – Custo Variável unitário)/(Custo Variável unitário) = (50-25)/25 = 1 ou 100%.

Margem Bruta = (Receita Líquida – Custos Operacionais)/Receita Líquida = 200.000 – 150.000/200.000 = 50.000 / 200.000 = 0,25 ou 25%

Margem Líquida = (Receita Líquida – Custos+Despesas)/Receita Líquida = 200.000 – 170.000 / 200.000 = 30.000 / 200.000 = 0,15 ou 15%
*/               
 