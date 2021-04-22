#INCLUDE "rwmake.ch"

User Function AGFATR03
  Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
  Local cDesc2         := "de acordo com os parametros informados pelo usuario."
  Local cDesc3         := "Relatorio de Vendas por Fabrica - 12 MESES"
  Local cPict          := ""
  Local titulo         := "Relatorio de Vendas por Fabrica - 12 MESES"
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
  Private nomeprog     := "AGFATR03" // Coloque aqui o nome do programa para impressao no cabecalho
  Private nTipo        := 18
  Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
  Private nLastKey     := 0
  Private cPerg        := "AGFT03"
  Private cbtxt        := Space(10)
  Private cbcont       := 00
  Private CONTFL       := 01
  Private m_pag        := 01
  Private wnrel        := "AGFATR03" // Coloque aqui o nome do arquivo usado para impressao em disco

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
                                                      
  Local nTotalGeral, cProduto, cDescric, aProduto, nPosLin, nPosCol, aTotalAno := {}, cFabrica

  Titulo += "  ANO: " + MV_PAR01 + "  TES: " + Alltrim(MV_PAR04)
                                                                                                                                
  If MV_PAR08 = 1 //- Por quantidade
     Cabec1  := "Codigo          Descricao            -Jan- -Fev- -Mar- -Abr- -Mai- -Jun- -Jul- -Ago- -Set- -Out- -Nov- -Dez- -Total-"
     limite  := 132
     tamanho := "M"
  Else            //- Por valor
     Cabec1 := "Codigo          Descricao            ---Jan----  ---Fev---- ---Mar---- ---Abr---- ---Mai---- ---Jun---- ---Jul---- ---Ago---- ---Set---- ---Out---- ---Nov---- ---Dez---- ---TOT----"
     limite  := 220
     tamanho := "G"
  Endif   

  TabTmp()
  
  AAdd(aTotalAno, {"TOTAL", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 })
  
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

     cFabrica := TMP->A2_NREDUZ
     
     @nLin, 000  PSAY cFabrica
     nLin += 2

     aProduto:= {}

     While !TMP->(EOF()) .And. cFabrica == TMP->A2_NREDUZ 

        cProduto := TMP->B1_COD
        cDescric := Substr(TMP->B1_DESC,1,20)
     
        AAdd(aProduto, {cProduto, cDescric, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 })
     
        nPosLin := Len(aProduto)                                 
     
        While !TMP->(EOF()) .And. cFabrica == TMP->A2_NREDUZ .And. cProduto == TMP->B1_COD 
           
           nPosCol:= Val(Substr(TMP->ANOMES,5,2))+2
           
           If MV_PAR08 = 1 //- Por quantidade
              aProduto[nPosLin, nPosCol] += TMP->QUANT
              aProduto[nPosLin, 15]+= TMP->QUANT
           Else            //- Por valor
              aProduto[nPosLin, nPosCol] += TMP->VALOR
              aProduto[nPosLin, 15]+= TMP->VALOR
           Endif   
           TMP->(dbSkip())
        Enddo
     Enddo       
   	 
   	 Asort(aProduto,,, {|x,y| x[15] > y[15]})

   	 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	 //³ Inicio da impressao do orcamento   ³
	 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     For i:= 1 to Len(aProduto)  
        If lAbortPrint
           @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
           Exit
        Endif

        If nLin > 55
           Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
           nLin := 8
        Endif

        //          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15                  16
        //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        //Codigo          Descricao            -Jan- -Fev- -Mar- -Abr- -Mai- -Jun- -Jul- -Ago- -Set- -Out- -Nov- -Dez- -Total-"
        //xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx 9999  9999  9999  9999  9999  9999  9999  9999  9999  9999  9999  9999   99999
        
        //          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17
        //012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
        //Codigo          Descricao            ---Jan---- ---Fev---- ---Mar---- ---Abr---- ---Mai---- ---Jun---- ---Jul---- ---Ago---- ---Set---- ---Out---- ---Nov---- ---Dez---- ---TOT----"
        //xxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99
     
        @nLin, 000  PSAY aProduto[i,01]                
        @nLin, 016  PSAY aProduto[i,02]                
        
        If MV_PAR08 = 1 //- Por quantidade
           @nLin, 037  PSAY aProduto[i,03] Picture "@E 9999"
           @nLin, 043  PSAY aProduto[i,04] Picture "@E 9999"
           @nLin, 049  PSAY aProduto[i,05] Picture "@E 9999"
           @nLin, 055  PSAY aProduto[i,06] Picture "@E 9999"
           @nLin, 061  PSAY aProduto[i,07] Picture "@E 9999"
           @nLin, 067  PSAY aProduto[i,08] Picture "@E 9999"
           @nLin, 073  PSAY aProduto[i,09] Picture "@E 9999"
           @nLin, 079  PSAY aProduto[i,10] Picture "@E 9999"
           @nLin, 085  PSAY aProduto[i,11] Picture "@E 9999"
           @nLin, 091  PSAY aProduto[i,12] Picture "@E 9999"
           @nLin, 097  PSAY aProduto[i,13] Picture "@E 9999"
           @nLin, 103  PSAY aProduto[i,14] Picture "@E 9999"
           @nLin, 109  PSAY aProduto[i,15] Picture "@E 9999"
        Else            //- Por valor                                         
           @nLin, 037  PSAY aProduto[i,03] Picture "@E 999,999.99"
           @nLin, 048  PSAY aProduto[i,04] Picture "@E 999,999.99"
           @nLin, 059  PSAY aProduto[i,05] Picture "@E 999,999.99"
           @nLin, 070  PSAY aProduto[i,06] Picture "@E 999,999.99"
           @nLin, 081  PSAY aProduto[i,07] Picture "@E 999,999.99"
           @nLin, 092  PSAY aProduto[i,08] Picture "@E 999,999.99"
           @nLin, 103  PSAY aProduto[i,09] Picture "@E 999,999.99"
           @nLin, 114  PSAY aProduto[i,10] Picture "@E 999,999.99"
           @nLin, 125  PSAY aProduto[i,11] Picture "@E 999,999.99"
           @nLin, 136  PSAY aProduto[i,12] Picture "@E 999,999.99"
           @nLin, 147  PSAY aProduto[i,13] Picture "@E 999,999.99"
           @nLin, 158  PSAY aProduto[i,14] Picture "@E 999,999.99"
           @nLin, 169  PSAY aProduto[i,15] Picture "@E 999,999.99"
        Endif
        nLin += 1 
     
        For k:= 2 to 13
           aTotalAno[1,k] += aProduto[i,k+1]
        Next   
     Next
     If !Empty(aTotalAno[1,01])

        aTotalAno[1,14]:= 0
        
        If MV_PAR08 = 1
           @nLin, 037  PSAY "-----"
           @nLin, 043  PSAY "-----"
           @nLin, 049  PSAY "-----"
           @nLin, 055  PSAY "-----"
           @nLin, 061  PSAY "-----"
           @nLin, 067  PSAY "-----"
           @nLin, 073  PSAY "-----"
           @nLin, 079  PSAY "-----"
           @nLin, 085  PSAY "-----"
           @nLin, 091  PSAY "-----"
           @nLin, 097  PSAY "-----"
           @nLin, 103  PSAY "-----"
           @nLin, 109  PSAY "-----"
           nLin += 1 

           For k:= 2 to 13
              aTotalAno[1,14] += aTotalAno[1,k]
           Next   
           @nLin, 000  PSAY aTotalAno[1,01]
           @nLin, 037  PSAY aTotalAno[1,02] Picture "@E 9999"
           @nLin, 043  PSAY aTotalAno[1,03] Picture "@E 9999"
           @nLin, 049  PSAY aTotalAno[1,04] Picture "@E 9999"
           @nLin, 055  PSAY aTotalAno[1,05] Picture "@E 9999"
           @nLin, 061  PSAY aTotalAno[1,06] Picture "@E 9999"
           @nLin, 067  PSAY aTotalAno[1,07] Picture "@E 9999"
           @nLin, 073  PSAY aTotalAno[1,08] Picture "@E 9999"
           @nLin, 079  PSAY aTotalAno[1,09] Picture "@E 9999"
           @nLin, 085  PSAY aTotalAno[1,10] Picture "@E 9999"
           @nLin, 091  PSAY aTotalAno[1,11] Picture "@E 9999"
           @nLin, 097  PSAY aTotalAno[1,12] Picture "@E 9999"
           @nLin, 103  PSAY aTotalAno[1,13] Picture "@E 9999"
           @nLin, 109 PSAY aTotalAno[1,14] Picture "@E 9999"
           nLin += 2
        Else 
           @nLin, 037  PSAY "----------"
           @nLin, 048  PSAY "----------"
           @nLin, 059  PSAY "----------"
           @nLin, 070  PSAY "----------"
           @nLin, 081  PSAY "----------"
           @nLin, 092  PSAY "----------"
           @nLin, 103  PSAY "----------"
           @nLin, 114  PSAY "----------"
           @nLin, 125  PSAY "----------"
           @nLin, 136  PSAY "----------"
           @nLin, 147  PSAY "----------"
           @nLin, 158  PSAY "----------"
           @nLin, 169  PSAY "----------"
           nLin += 1 
           
           For k:= 2 to 13
              aTotalAno[1,14] += aTotalAno[1,k]
           Next   
           @nLin, 000  PSAY aTotalAno[1,01]
           @nLin, 037  PSAY aTotalAno[1,02] Picture "@E 999,999.99"
           @nLin, 048  PSAY aTotalAno[1,03] Picture "@E 999,999.99"
           @nLin, 059  PSAY aTotalAno[1,04] Picture "@E 999,999.99"
           @nLin, 070  PSAY aTotalAno[1,05] Picture "@E 999,999.99"
           @nLin, 081  PSAY aTotalAno[1,06] Picture "@E 999,999.99"
           @nLin, 092  PSAY aTotalAno[1,07] Picture "@E 999,999.99"
           @nLin, 103  PSAY aTotalAno[1,08] Picture "@E 999,999.99"
           @nLin, 114  PSAY aTotalAno[1,09] Picture "@E 999,999.99"
           @nLin, 125  PSAY aTotalAno[1,10] Picture "@E 999,999.99"
           @nLin, 136  PSAY aTotalAno[1,11] Picture "@E 999,999.99"
           @nLin, 147  PSAY aTotalAno[1,12] Picture "@E 999,999.99"
           @nLin, 158  PSAY aTotalAno[1,13] Picture "@E 999,999.99"
           @nLin, 169  PSAY aTotalAno[1,14] Picture "@E 999,999.99"
           nLin += 2
        Endif                                                                                 
        For k:= 2 to 13
           aTotalAno[1,k] := 0.00 //- Zerando totais
        Next   
     Endif
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
  Local cTES := StrTran(ALLTRIM(MV_PAR04),",","','")   
  
  Local cDataIni := MV_PAR01+"0101"
  Local cDataFim := MV_PAR01+"1231"

  cQry := " SELECT * FROM "
  
  If MV_PAR08 = 1
     cQry += " ( SELECT A2_NREDUZ, B1_COD, B1_DESC, SUBSTRING(D2_EMISSAO,1,6) ANOMES, SUM(D2_QUANT-D2_QTDEDEV)QUANT"
  Else 
     cQry += " ( SELECT A2_NREDUZ, B1_COD, B1_DESC, SUBSTRING(D2_EMISSAO,1,6) ANOMES, SUM(D2_TOTAL-D2_VALDEV)VALOR"  
  Endif
  
  cQry += " FROM " 
  cQry += RetSQLName("SD2")+" SD2, "
  cQry += RetSQLName("SB1")+" SB1, "
  cQry += RetSQLName("SA2")+" SA2  "
  cQry += " WHERE SD2.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' "
  cQry += " AND D2_FILIAL='"+xFilial("SD2")+"'"
  cQry += " AND B1_FILIAL='"+xFilial("SB1")+"'"
  cQry += " AND D2_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " 
  cQry += " AND D2_COD = B1_COD "
  cQry += " AND B1_PROC = A2_COD AND B1_LOJPROC = A2_LOJA"
  cQry += " AND D2_TES IN ('"+ cTES +"') "
  cQry += " AND B1_PROC  BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "  
  cQry += " AND B1_COD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "  
  
  If MV_PAR07 = 1 //- Peças
     cQry += " AND B1_XTPPROD = 'P' "  
  Elseif MV_PAR07 = 2  //- Equipamentos
     cQry += " AND B1_XTPPROD = 'E' "  
  Endif
  
  cQry += " GROUP BY A2_NREDUZ, B1_COD, B1_DESC, SUBSTRING(D2_EMISSAO,1,6) ) A "
  cQry += " ORDER BY A2_NREDUZ, B1_COD, ANOMES"

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

  aAdd(aRegs,{cPerg,"01","Ano de referencia       ?", "" , "", "mv_ch1","C" ,04, 0 , 0 ,"G", "" , "MV_PAR01", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg,"02","Da Fabrica              ?", "" , "", "mv_ch2","C" ,06, 0 , 0 ,"G", "" , "MV_PAR02", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SA2",""})
  aAdd(aRegs,{cPerg,"03","Ate a Fabrica           ?", "" , "", "mv_ch3","C" ,06, 0 , 0 ,"G", "" , "MV_PAR03", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SA2",""})
  aAdd(aRegs,{cPerg,"04","Informa TES de venda    ?", "" , "", "mv_ch4","C" ,20, 0 , 0 ,"G", "" , "MV_PAR04", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg,"05","Do Produto              ?", "" , "", "mv_ch5","C" ,15, 0 , 0 ,"G", "" , "MV_PAR05", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SB1",""})
  aAdd(aRegs,{cPerg,"06","Ate o Produto           ?", "" , "", "mv_ch6","C" ,15, 0 , 0 ,"G", "" , "MV_PAR06", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","SB1",""})
  aAdd(aRegs,{cPerg,"07","Tipo do Item            ?", "" , "", "mv_ch7","N" ,01, 0 , 0 ,"C", "" , "MV_PAR07","Peça","","", "","","Equipamento","","","","","Ambos","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg,"08","Ordem                   ?", "" , "", "mv_ch8","N" ,01, 0 , 0 ,"C", "" , "MV_PAR08","Quantidade","","", "","","Valor","","","","","","","","","","","","","","","","","","","",""})

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