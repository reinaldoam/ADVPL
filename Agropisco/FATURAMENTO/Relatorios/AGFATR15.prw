#INCLUDE "rwmake.ch"

User Function AGFATR15
  Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
  Local cDesc2         := "de acordo com os parametros informados pelo usuario."
  Local cDesc3         := "Poder de Terceiros"
  Local cPict          := ""
  Local titulo         := "Poder de Terceiros"
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
  Private nomeprog     := "AGFATR15" // Coloque aqui o nome do programa para impressao no cabecalho
  Private nTipo        := 18
  Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
  Private nLastKey     := 0
  Private cPerg        := "AGFT15"       
  Private m_pag        := 01
  Private cbtxt        := Space(10)
  Private cbcont       := 00
  Private wnrel        := "AGFATR15" // Coloque aqui o nome do arquivo usado para impressao em disco
  Private cString      := "SB6"

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
                                                      
  Local cQuebra:= "ZZZZZZ"

  Titulo += " De " + Dtoc(MV_PAR01) + " a " + Dtoc(MV_PAR01) 
  
  Cabec1 := "Codigo           Descricao                                                     N.Fiscal     Emissao     Quant"
//           xxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxx/x  99/99/99  999,999.99
//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789023456789023456789023456789012
//           0         1         2         3         4         5         6         7         8         9        10      11       12
  TabTmp()
  
  SetRegua(RecCount())
     
  TMP->(DbGotop())
  
  While !TMP->(EOF())
     
     If lAbortPrint
        @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
        Exit
     Endif

   	 //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	 //� Inicio da impressao do relatorio    �
	 //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
     If nLin > 55
        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
        nLin := 8
     Endif

     If cQuebra <> TMP->A1_COD                       
        @nLin, 000  PSAY TMP->A1_COD + " - " + TMP->A1_NREDUZ
        nLin+=2                
        cQuebra:= TMP->A1_COD
     Endif   
  
     @nLin, 000  PSAY TMP->B6_PRODUTO                
     @nLin, 017  PSAY TMP->B1_DESC                
     @nLin, 079  PSAY TMP->B6_DOC+"/"+TMP->B6_SERIE
     @nLin, 092  PSAY TMP->B6_EMISSAO
     @nLin, 102  PSAY TMP->B6_QUANT Picture "@E 999,999.99"
     nLin += 1
     TMP->(DbSkip())
  Enddo          
      
  TMP->(dbCloseArea())

  //SET DEVICE TO SCREEN

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

  cQry := " SELECT A1_COD,A1_NREDUZ,B6_DOC,B6_SERIE,B6_EMISSAO,B6_PRODUTO,B1_DESC,B6_QUANT,B6_TES "
  cQry += " FROM " 
  cQry += RetSQLName("SB6")+" A, "
  cQry += RetSQLName("SA1")+" B, "
  cQry += RetSQLName("SB1")+" C "
  cQry += " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_<>'*' AND C.D_E_L_E_T_<>'*' "
  cQry += " AND B6_CLIFOR=A1_COD "
  cQry += " AND B6_LOJA=A1_LOJA "
  cQry += " AND B6_PRODUTO=B1_COD "
  cQry += " AND B6_TIPO='D' "
  cQry += " AND B6_EMISSAO BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " 
  cQry += " ORDER BY A1_COD "

  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.T.,.T.)
 
  TcSetField("TMP" , "B6_EMISSAO", "D", 8, 0)  // Formata para tipo Data

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
  aAdd(aRegs,{cPerg, "02", "Periodo at�             ?", "" , "", "mv_ch2", "D" ,08, 0 , 0 ,"G", "" , "MV_PAR02", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})

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
