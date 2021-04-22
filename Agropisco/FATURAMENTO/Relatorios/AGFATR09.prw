#INCLUDE "rwmake.ch"

User Function AGFATR09
  Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
  Local cDesc2         := "de acordo com os parametros informados pelo usuario."
  Local cDesc3         := "Relatorio de Itens sem Venda no Periodo"
  Local cPict          := ""
  Local Titulo         := "Relatorio de Vendas por F�brica"
  Local nLin           := 80
  Local Cabec1         := ""
  Local Cabec2         := ""
  Local imprime        := .T.
  Private aOrd         := {} //{"Ordem 01","Ordem 02"}
  Private lEnd         := .F.
  Private lAbortPrint  := .F.
  Private CbTxt        := ""
  Private limite       := 132
  Private Tamanho      := "M"
  Private nomeprog     := "AGFATR09" // Coloque aqui o nome do programa para impressao no cabecalho
  Private nTipo        := 18
  Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
  Private nLastKey     := 0
  Private cPerg        := "AGFT09"       
  Private m_pag        := 01
  Private cbtxt        := Space(10)
  Private cbcont       := 00
  Private wnrel        := "AGFATR09" // Coloque aqui o nome do arquivo usado para impressao em disco
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
  Local aCmp := {}

  Titulo:= Alltrim(Titulo) + " - " + Posicione("SA2",1,xFilial("SA2")+Alltrim(MV_PAR03),"A2_NREDUZ")+ " DE " + Dtoc(MV_PAR01) + " A " + Dtoc(MV_PAR02)
                                        
  Cabec1 := "C�digo	Descri��o                                          Refer�ncia	   Endere�o        Qtde Vend. Dt.Ult.Cmp Qt.Ult.Cmp"
  //         XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX 999,999.99 99/99/9999 999,999.99
  //         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901 
  //         0         1         2         3         4         5         6         7         8         9        10        11        12  
  
  QryVenda()
  
  SetRegua(RecCount())
  
  Do While !XXX->(EOF())
     
     If lAbortPrint
        @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
        Exit
     Endif

     If nLin > 55
        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
        nLin := 8
     Endif
   	 //�������������������������������������Ŀ
	 //� Inicio da impressao do relatorio    �
	 //��������������������������������������
     //C�digo Descri��o                                          Refer�ncia	     Endere�o        Qtde Vend. Dt.Ult.Cmp Qt.Ult.Cmp"
     //XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX 999,999.99 99/99/9999 999,999.99
     //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901 
     //0         1         2         3         4         5         6         7         8         9        10        11        12  
	                                                         
	 aCmp := UltEntrada(XXX->B1_COD,XXX->B1_XCODFAB)
	 
     @nLin, 000  PSAY Substr(XXX->B1_COD,1,6)   Picture "@!"
     @nLin, 007  PSAY Substr(XXX->B1_DESC,1,50) Picture "@!" 
     @nLin, 058  PSAY XXX->B1_XCODFAB           Picture "@!" 
     @nLin, 074  PSAY XXX->B1_LOCAGRO           Picture "@!"
     @nLin, 090  PSAY XXX->D2_QUANT             Picture "@E 999,999.99"
     @nLin, 101  PSAY aCmp[1][1]                 
     @nLin, 112  PSAY aCmp[1][2]                Picture "@E 999,999.99"
     nLin++
     XXX->(DbSkip())
  Enddo          
      
  XXX->(dbCloseArea())

  SET DEVICE TO SCREEN

  If aReturn[5]==1
     dbCommitAll()
     SET PRINTER TO
     OurSpool(wnrel)
  Endif

  MS_FLUSH()

Return

/////////////////////////
Static Function QryVenda
  Local cQry:=""                                                                

  cQry := "SELECT SB1.B1_COD,SB1.B1_XCODFAB,SB1.B1_DESC,SB1.B1_LOCAGRO,SA2.A2_NREDUZ,SD2.D2_QUANT " 
  cQry += "FROM "+RetSQLName("SB1")+" SB1 "
  cQry += "INNER JOIN SA2010 SA2 ON B1_PROC = A2_COD "  
  cQry += "INNER JOIN "
  cQry += "("  
  cQry += "SELECT D2_COD,SUM(D2_QUANT)D2_QUANT "   
  cQry += "FROM " +RetSQLName("SD2")+" E "  
  cQry += "INNER JOIN SB1010 F ON B1_COD = D2_COD "
  cQry += "INNER JOIN SA2010 G ON A2_COD = B1_PROC "     
  cQry += "WHERE E.D_E_L_E_T_ <> '*' " 
  cQry += "AND F.D_E_L_E_T_ <> '*' " 
  cQry += "AND G.D_E_L_E_T_ <> '*' "  
  cQry += "AND B1_PROC = '"+mv_par03+"' "  
  cQry += "AND D2_FILIAL= '"+xFilial("SD2")+"' "  
  cQry += "AND D2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
  cQry += "AND D2_CF IN('5102','6102','5405','6405') "   
  cQry += "AND NOT EXISTS "  
  cQry += "(" 
  cQry += "SELECT * FROM " +RetSQLName("SD1")+" SD1 "  
  cQry += "WHERE D_E_L_E_T_ <> '*' " 
  cQry += "AND D1_FILIAL= '"+xFilial("SD1")+"' "    
  cQry += "AND D1_NFORI = E.D2_DOC " 
  cQry += "AND D1_SERIORI = E.D2_SERIE " 
  cQry += "AND D1_ITEMORI = E.D2_ITEM "
  cQry += ")"   
  cQry += "GROUP BY D2_COD "
  cQry += ") SD2 ON SB1.B1_COD = SD2.D2_COD "  
  cQry += "WHERE SB1.D_E_L_E_T_ <> '*' "  
  cQry += "AND B1_FILIAL= '"+xFilial("SB1")+"' "    
  cQry += "AND B1_MSBLQL<>'1' "
  cQry += "AND SA2.D_E_L_E_T_ <> '*' "  
  cQry += "ORDER BY SD2.D2_QUANT DESC"

  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )

  dbGoTop()

Return

///////////////////////////////////////
Static Function UltEntrada(c_Cod,c_Ref)
  Local aRet:={}
  Local cQry:=""     
  Local cData:=""
  Local cQuant:=""
  Local cAlias:= Alias()
  
  AADD(aRet,{"",0.00 })

  cQry := "SELECT TOP 1 D1_DTDIGIT,D1_QUANT " 
  cQry += "FROM "+RetSqlName("SD1")+" SD1 " 
  cQry += "WHERE D_E_L_E_T_ <> '*' "
  cQry += "AND D1_CF IN('1101','2101','1102','2102') "  
     
  If SM0->M0_CODFIL == "02"                         
     cQry += "AND (D1_FILIAL='02' AND D1_COD = '"+c_Cod+"' OR D1_FILIAL='01' AND D1_COD = '"+c_Ref+"') "
  Else 
     cQry += "AND D1_FILIAL = '"+xFilial("SD1")+"'
     cQry += "AND D1_COD = '"+c_Cod+"' "  
  Endif
  cQry += "ORDER BY D1_DTDIGIT DESC "
  
  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"YYY",.T.,.T.)
  
  TcSetField("YYY", "D1_DTDIGIT", "D", 8, 0)  // Formata para tipo Data

  dbSelectArea("YYY")		
    
  If !YYY->(EOF())         
     aRet[1][1] := Dtoc(YYY->D1_DTDIGIT)
     aRet[1][2] := YYY->D1_QUANT 
  Endif   
  YYY->(dbCloseArea())
  dbSelectArea(cAlias)
Return aRet

/////////////////////////////////
Static Function ValidPerg(cPerg)
  _sAlias := Alias()  
  cPerg   := Padr(cPerg,10)
  DbSelectArea("SX1")
  DbSetOrder(1)
  aRegs :={}

  aAdd(aRegs,{cPerg, "01", "Da data    ?", "" , "", "mv_ch1", "D" ,08, 0 , 0 ,"G", "" , "MV_PAR01", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg, "02", "At� a data ?", "" , "", "mv_ch2", "D" ,08, 0 , 0 ,"G", "" , "MV_PAR02", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg, "03", "Fabricante ?", "" , "", "mv_ch3", "C" ,06, 0 , 0 ,"G", "" , "MV_PAR03","","","", "","","","","","","","","","","","","","","","","","","","","","SA2",""})  

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