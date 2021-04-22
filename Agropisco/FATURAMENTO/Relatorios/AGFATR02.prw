 #INCLUDE "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AGFATR02   ¦ Autor ¦ WERMESON GADELHA     ¦ Data ¦ 16/01/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ RELATORIOS DE COMISSOES MENSAIS 	                          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function AGFATR02()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "RELATÓRIO DE VENDAS/VENDEDORES"
Local cPict        := ""
Local titulo       := "RELATÓRIO DE VENDAS/VENDEDORES"

Local nLin         := 180

//                    0			1		  2			3		  4			5		  6			7		  8			9		  0			1         2         3		  4		    5         6         7         8         9         0         1         2         6
//					  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1       := "   PRODUTO                                                 QTDE      PREÇO UNIT.  VLR BRUTO    IPI        ICMS       PIS       COFINS     CSLL      INSS      DESCONTO   VLR. LÍQUIDO"  
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "G"
Private nomeprog   := "AGFATR02" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FATR02" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "FATR02"

Private cString := "SD2"                         

dbSelectArea("SD2")
//dbSetOrder(1)
U_MsSetOrder("SD2","D2_FILIAL+D2_COD+D2_LOCAL+D2_NUMSEQ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima

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


If mv_par03 < 1 .Or. mv_par03 > 12 .Or. mv_par04 < 1 .Or. mv_par04 > 12

  Alert("O Periodo escolhido nos parâmetros não é valido, favor digitar um mês e um ano válido")
  Return      
  
EndIf              //1         2         3
         //012345678901234567890123456789012345
Cabec1 := "Vendedor"+SPACE(8)+MontaCabec()   

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  02/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLinII)

Local nOrdem
Private nRegis	 := 0
//Private cAuxDoc  := ""
//pRIVATE cAuxSer  := ""

Private cAuxVend := "..."
Private nLin     := 180 //nLinII 
                       //  11  		1    	  2		3	  4	   5      6     7      8      9        10
Private aValPeca := {} // QTDE,PREÇO UNIT., BRUTO, IPI, ICMS, PIS, COFINS, CSLL, INSS, DESCONTO, LÍQUIDO
Private aValLoca := {} // QTDE,PREÇO UNIT., BRUTO, IPI, ICMS, PIS, COFINS, CSLL, INSS, DESCONTO, LÍQUIDO
Private aValServ := {} // QTDE,PREÇO UNIT., BRUTO, IPI, ICMS, PIS, COFINS, CSLL, INSS, DESCONTO, LÍQUIDO
//Private aValores := {}
//Private aTotVal  := {}

Private cCfPeca  := getmv("MV_CFPECA")
Private cCfServ  := getmv("MV_CFSERV")
Private cTesLoca := getmv("MV_TESLOCA")
Private nAuxLin
Private lImp 	 := .F.

Private nValBase := 0
Private nValCom1 := 0
Private nValCom2 := 0
Private nCol     := 0 
Private nValVend := 0
Private nMeta 	 := 0
Private nTotVend :=0

Private aTotais  :={}
Private aMetas   :={}

dbSelectArea(cString)
dbSetOrder(1)

for i:= 1 to 2                         
// aAdd(aValores,{0,0,0,0,0,0,0,0,0,0,0}) 
// aAdd(aTotVal, {0,0,0,0,0,0,0,0,0,0,0})
 aAdd(aTotais, {0,0,0,0,0,0,0,0,0,0,0,0})
 aAdd(aMetas , {0,0,0,0,0,0,0,0,0,0,0,0})
Next

 MontaQry()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(nRegis)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbGoTop()
While !XXX->(EOF())
    IncRegua()
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
     
	If !VerifSD1(XXX->D2_DOC,XXX->D2_SERIE,XXX->D2_ITEM)
//       cAuxDoc := XXX->D2_DOC
       //cAuxSer := XXX->D2_SERIE
//       cAuxTES := XXX->D2_CF
//       cTes1   := XXX->D2_TES
       cAuxVend:= XXX->F2_VEND1
       lImp   := .T.
	   XXX->(dbSkip())

	   LOOP 	  
	EndIf

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9 
      nAuxLin := 9
   Endif 
   
   If XXX->F2_VEND1 <> cAuxVend

//     @nLin,00 pSay XXX->F2_VEND1 +" - "+ SubStr(Posicione("SA3",1,xFilial("SA3")+XXX->F2_VEND1,"A3_NOME"),1,20)
     @nLin,00 pSay SubStr(Posicione("SA3",1,xFilial("SA3")+XXX->F2_VEND1,"A3_NOME"),1,10)
     
     nCol:= 11
//     nLin++
     For k:= mv_par03 to mv_par04
        
		nValVend:=QryVend(XXX->F2_VEND1,Alltrim(Str(mv_par13))+StrZero(k,2)+"01",Alltrim(Str(mv_par13))+StrZero(k,2)+"31")
	     
	    //SZA->(dbSetOrder(1))
	    U_MsSetOrder("SZA","ZA_FILIAL+ZA_VEND+ZA_ANO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
	    SZA->(dbSeek(xFilial("SZA")+XXX->F2_VEND1+allTrim(Str(mv_par13))))

	    if k == 1                                                
	        nMeta := SZA->ZA_META01
	      ElseIf k == 2
			nMeta := SZA->ZA_META02
	      ElseIf k == 3
			nMeta := SZA->ZA_META03
	      ElseIf k == 4           
			nMeta := SZA->ZA_META04
	      ElseIf k == 5
			nMeta := SZA->ZA_META05
	      ElseIf k == 6
			nMeta := SZA->ZA_META06
	      ElseIf k == 7
			nMeta := SZA->ZA_META07
	      ElseIf k == 8
			nMeta := SZA->ZA_META08
	      ElseIf k == 9
			nMeta := SZA->ZA_META09
	      ElseIf k == 10
			nMeta := SZA->ZA_META10
	      ElseIf k == 11
			nMeta := SZA->ZA_META11
	      ElseIf k == 12            
	        nMeta := SZA->ZA_META12  	         
	    EndIf                      
	    
	    //@nLin,nCol Psay TRANSFORM(nMeta ,"@E 999,999.99") 
	    //nCol += 13  
	    @nLin,nCol Psay TRANSFORM(nValVend ,"@E 9,999,999.99")// +SPACE(1)+ //TRANSFORM( (nValVend/nMeta)*100 ,"@E 999.99") + "%"
//	    @nLin,nCol Psay TRANSFORM( (nValVend/nMeta)*100 ,"@E 999.99") + "%"
	    	    
	    nTotVend += nValVend // total de vendas 
	    aTotais[1][k] += nValVend
	    aTotais[2][k] += nMeta
	    aMetas[1][k]  := nMeta
	    aMetas[2][k]  := nValVend
		nCol += 17
     
     Next
     nlin++   
     nCol:= 11
     For j:= mv_par03 to mv_par04
      @nLin,nCol Psay TRANSFORM( (aMetas[2][j]/aMetas[1][j])*100 ,"@E 9,999,999.99") + "%" 
      nCol += 17
     Next
     nLin++
   EndIf        

//   SF4->(dbSetOrder(1))
//   SF4->(dbSeek(xFilial("SF4")+XXX->D2_TES))
        
//   cAuxDoc:= XXX->D2_DOC
//   cAuxTES:= XXX->D2_CF
//   cTes1  := XXX->D2_TES
//   cAuxSer:= XXX->D2_SERIE                    
   cAuxVend:= XXX->F2_VEND1 
   
   XXX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   
EndDo     
  /*For j:=1 to 12
    aTotais
  Endif*/
  
  nLin++ 
  @ nLin, 000  PSay __PrtThinLine()                                            
  nlin++   
  nCol:= 11                                                   
  @nLin,0 PSAY "TOTAL"
  For j:= mv_par03 to mv_par04
    @nLin,nCol Psay TRANSFORM(aTotais[1][j],"@E 9,999,999.99")
    nCol += 17
  Next

  nLin++ 
  @ nLin, 000  PSay __PrtThinLine()                                            
  nlin++   
  nCol:= 11
  @nLin,0 PSAY "TOTAL (%)"

  For j:= mv_par03 to mv_par04
    @nLin,nCol Psay TRANSFORM( (aTotais[1][j]/aTotais[2][j])*100 ,"@E 9,999,999.99") + "%" 
    nCol += 17
  Next

  nLin++ 
  @ nLin, 000  PSay __PrtThinLine()                                            
  nlin++   
  
 // @nLin,030 pSay  TRANSFORM(nTotVend,"@E 999,999,999.99")

XXX->(dbCloseArea())

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


Static Function MontaQry()
        
Local cQuery := ""

 cQuery := " SELECT COUNT(*)SOMA "
 cQuery += "  FROM "+RetSQLName("SD2")+" SD2, "   
 cQuery +=           RetSQLName("SF2")+" SF2 "
 cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
 cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
 cQuery += " AND F2_DOC = D2_DOC " 
 cQuery += " AND F2_VEND1 <> '000016' "  
 cQuery += " AND F2_SERIE = D2_SERIE " 
 cQuery += " AND D2_PRCVEN <> 0    
 cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND D2_EMISSAO BETWEEN '"+Alltrim(Str(mv_par13))+StrZero(mv_par03,2)+"01"+"' AND '"+Alltrim(Str(mv_par13))+StrZero(mv_par04,2)+"31' "
 cQuery += " AND F2_EMISSAO BETWEEN '"+Alltrim(Str(mv_par13))+StrZero(mv_par03,2)+"01"+"' AND '"+Alltrim(Str(mv_par13))+StrZero(mv_par04,2)+"31' "
 cQuery += " AND D2_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
 cQuery += " AND D2_DOC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
 cQuery += " AND F2_DOC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "                 
 cQuery += " AND D2_SERIE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
 cQuery += " AND F2_SERIE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "                 
 cQuery += " AND F2_VEND1 BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' "  
 //cQuery += " OR F2_VEND2 BETWEEN '"+mv_par11+"' AND '"+mv_par12+"') "                     

 cQuery += " AND (D2_CF = '"+cCfPeca+"' "
 cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
 cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "

   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
   nRegis := SOMA
   dbCloseArea()

   cQuery := StrTran(cQuery,"COUNT(*)SOMA", "*")
   cQuery += " ORDER BY F2_VEND1, F2_DOC,D2_SERIE, D2_CF "
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
          		
Return	 

*********************************
Static Function ValidPerg(cPerg)
*********************************                                    

Local _sAlias := Alias()
Local aRegs :={}

DbSelectArea("SX1")
DbSetOrder(1)

aAdd(aRegs,{cPerg,"01","Da Filial      ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Filial   ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Do Mes         ?","","","mv_ch3","N",02,0,0,"G","","mv_par03","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate o Mes      ?","","","mv_ch4","N",02,0,0,"G","","mv_par04","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Do Cliente     ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","", "","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"06","Ate o Cliente  ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","", "","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cPerg,"07","Da Nota        ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","", "","","","","","","","","","","","","","","","","","","","","","SF2",""})
aAdd(aRegs,{cPerg,"08","Ate a Nota     ?","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","", "","","","","","","","","","","","","","","","","","","","","","SF2",""})
aAdd(aRegs,{cPerg,"09","Da Serie       ?","","","mv_ch9","C",03,0,0,"G","","mv_par09","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Ate a Serie    ?","","","mv_cha","C",03,0,0,"G","","mv_par10","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Do Vendedor    ?","","","mv_chb","C",06,0,0,"G","","mv_par11","","","", "","","","","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cPerg,"12","Ate o Vendedor ?","","","mv_chc","C",06,0,0,"G","","mv_par12","","","", "","","","","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cPerg,"13","Ano Base       ?","","","mv_chd","N",04,0,0,"G","","mv_par13","","","", "","","","","","","","","","","","","","","","","","","","","","",""})

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



Static Function VerifSD1(cDoc, cSerie, cItem)
        
Local cQuery := ""
Local lRet   := .F.

 cQuery := " SELECT D1_TIPO, D1_NFORI, D1_SERIORI,D1_ITEMORI "
 cQuery += " FROM "+RetSQLName("SD1")+" SD1 "   

 cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "
 cQuery += " AND D1_NFORI = '"+cDoc+"' " 
 cQuery += " AND D1_SERIORI = '"+cSerie+"' "
 cQuery += " AND D1_ITEMORI = '"+cItem+"' " 
 
                 
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
 lRet := YYY->(EOF())
 YYY->(dbCloseArea())

Return lRet    

Static Function MontaCabec()
 Local lCont  := .T.
 Local cAux   := ""
 local i
 

 For i:=mv_par03 to mv_par04 
  cAux += mesextenso(i) + space(17 - Len(mesextenso(i)) ) 
 Next
Return cAux

Static Function QryVend(cVend, cDataDe, cDataAte)
        
Local cQuery := ""
Local nSoma  := 0   
Local cAuxSer:=""
Local cAuxDoc:=""

 cQuery := " SELECT * "
 cQuery += "  FROM "+RetSQLName("SD2")+" SD2, "   
 cQuery +=           RetSQLName("SF2")+" SF2 "
 cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
 cQuery += " AND SF2.D_E_L_E_T_ <> '*' " 
 cQuery += " AND F2_VEND1 <> '000016' "  
 cQuery += " AND F2_DOC = D2_DOC " 
 cQuery += " AND F2_SERIE = D2_SERIE " 
 cQuery += " AND D2_PRCVEN <> 0    
 cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND D2_EMISSAO BETWEEN '"+cDataDe+"' AND '"+cDataAte+"' "
 cQuery += " AND F2_EMISSAO BETWEEN '"+cDataDe+"' AND '"+cDataAte+"' "
 cQuery += " AND D2_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
 cQuery += " AND D2_DOC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
 cQuery += " AND F2_DOC BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "                 
 cQuery += " AND D2_SERIE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
 cQuery += " AND F2_SERIE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "                 
 cQuery += " AND (F2_VEND1 = '"+cVend+"' "  
 IF !Empty(cVend)
   cQuery += " OR F2_VEND2 = '"+cVend+"') "                     
   Else
   cQuery += ") "
 EndIf
 cQuery += " AND (D2_CF = '"+cCfPeca+"' "
 cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
 cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
 cQuery += " ORDER BY F2_DOC,D2_SERIE, D2_CF "
   
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "QQQ", .T., .F. )

 While !QQQ->(Eof())
   	If !VerifSD1(QQQ->D2_DOC,QQQ->D2_SERIE,QQQ->D2_ITEM)
   	   cAuxSer:=QQQ->D2_SERIE
       cAuxDoc:=QQQ->D2_DOC
	   QQQ->(dbSkip())  	   
	   Loop
	EndIf
 //  IF cAuxSer <> QQQ->D2_SERIE .Or. cAuxDoc <> QQQ->D2_DOC
       //SA3->(dbSelectArea(1))
	   If Empty(QQQ->F2_VEND2)                                          	
	      nSoma += QQQ->D2_TOTAL  
	    Else 
	      nSoma += QQQ->D2_TOTAL/2  
	   EndIf
 //  EndIf           
   cAuxSer:=QQQ->D2_SERIE
   cAuxDoc:=QQQ->D2_DOC

   QQQ->(dbSkip()) 
 End
 QQQ->(dbCloseArea())
Return nSoma 