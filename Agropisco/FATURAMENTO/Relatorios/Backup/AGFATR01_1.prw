#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO3     � Autor � AP6 IDE            � Data �  02/01/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AGFATR01()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "RELAT�RIO DE FATURAMENTO"
Local cPict        := ""
Local titulo       := "RELAT�RIO DE FATURAMENTO"
Local nLin         := 135

Local Cabec1       := "CACEC 1 "
Local Cabec2       := "CABEC 2"
Local imprime      := .T.
Local aOrd := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "M"
Private nomeprog   := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "FATR01"

Private cString := "SD2"                         

dbSelectArea("SD2")
dbSetOrder(1)

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  02/01/08   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Private nRegis	 := 0
Private cAuxDoc  := ""
Private cTipos   := {"Pe�as","Servi�o","Loca��o"}
Private cAuxTES  := ""
Private cTes1	 := ""
Private nType    := 0

Private nPeca    := 0
Private nLocacao := 0
Private nServico := 0

Private aValPeca := {} // ipi, icms, prvunit, desconto 
Private aValLoca := {} // ipi, icms, prvunit, desconto
Private aValServ := {} // ipi, icms, prvunit, desconto

Private nTotPeca := 0
Private nTotLoca := 0
Private nTotServ := 0


dbSelectArea(cString)
dbSetOrder(1)
                        

MontaQry()

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(nRegis)

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

dbGoTop()
While !XXX->(EOF())
    IncRegua()
   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif 
   
   If cAuxDoc <> XXX->D2_DOC
     If nlin <> 9
      //nLin++
     // @ nLin, 000  PSay __PrtThinLine()                    
      nlin++
     EndIF           
       
     @nLin,00 pSay "Documento de Sa�da: " + XXX->D2_SERIE + " - " + XXX->D2_DOC
     nLin++
   EndIf        

   SF4->(dbSetOrder(1))
   SF4->(dbSeek(xFilial("SF4")+XXX->D2_TES))
   
   If XXX->F4_CF <> cAuxTES .Or. cAuxDoc <> XXX->D2_DOC
	 IF XXX->F4_CF = '5102'
	      @nLin,02 pSay cTipos[1]
	      nType := 1
	      nLin++
	     ElseIf XXX->F4_CF = '5933' .And. XXX->D2_TES <> '531'
	      @nLin,02 pSay cTipos[2]
	      nType := 2
	      nLin++
	     ElseIf XXX->F4_CF = '5933' .And. XXX->D2_TES = '531'
	      @nLin,02 pSay cTipos[3]
	      nType := 3
	      nLin++
	     Else     
	       cAuxDoc:= XXX->D2_DOC
           cAuxTES:= XXX->F4_CF
           cTes1  := XXX->D2_TES
 
	      XXX->(dbSkip())
	      LOOP 
	   EndIF
//	 @nLin,02 pSay XXX->D2_TES + " - "  + Posicione("SF4",1,xFilial("SF4")+XXX->D2_TES,"F4_TEXTO")
  // nLin++
   EndIf   

   @nLin,004 pSay SubStr(AllTrim(XXX->D2_COD) + " - " + Posicione("SB1",1,xFilial("SB1")+XXX->D2_COD,"B1_DESC"),1,54)
   @nLin,060 pSay XXX->D2_QUANT

   @nLin,065 pSay TRANSFORM(XXX->D2_PRUNIT,"@E 999,999.99")
   @nLin,077 pSay TRANSFORM(XXX->D2_TOTAL ,"@E 999,999.99")                                                          
   @nLin,089 pSay TRANSFORM(XXX->D2_VALIPI,"@E 99,999.99")
   @nLin,100 pSay TRANSFORM(XXX->D2_VALICM,"@E 99,999.99")
   @nLin,111 pSay TRANSFORM(XXX->D2_DESCON,"@E 99,999.99")
   @nLin,122 pSay TRANSFORM(XXX->D2_TOTAL ,"@E 999,999.99")  //MUDAR PRA VALOR LIQUIDO
   
   If nType == 1      
       nPeca += XXX->D2_TOTAL
     ElseIf nType == 2
       nServico += XXX->D2_TOTAL
	 ElseIf nType == 3       
       nLocacao += XXX->D2_TOTAL
   EndIf
   
   nLin := nLin + 1 // Avanca a linha de impressao
      
   cAuxDoc:= XXX->D2_DOC
   cAuxTES:= XXX->F4_CF
   cTes1  := XXX->D2_TES
 
   XXX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
   
   If XXX->F4_CF <> cAuxTES .Or. cAuxDoc <> XXX->D2_DOC
	 IF cAuxTES = '5102' //.And. nType == 1
          //nLin++
          @ nLin, 000  PSay __PrtThinLine()                    
          nlin++                            
          @nLin,05 pSay "Total de Pe�as"          
          @nLin,65 pSay TRANSFORM(nPeca,"@E 9,999,999.99")
          nPeca := 0
          nlin++
          @ nLin, 000  PSay __PrtThinLine()                    
          nlin++                            
	     ElseIf cAuxTES = '5933' .And. cTes1 <> '531' //.And. nType == 2
          //nLin++
          @ nLin, 000  PSay __PrtThinLine()                    
          nlin++                         
          @nLin,05 pSay "Total de Servi�os"          
          @nLin,65 pSay TRANSFORM(nServico,"@E 9,999,999.99")
          nServico := 0
          nlin++
          @ nLin, 000  PSay __PrtThinLine()                    
          nlin++                            
	     ElseIf cAuxTES = '5933' .And. cTes1 = '531' //.And. nType == 3
          //nLin++
          @ nLin, 000  PSay __PrtThinLine()                    
          nlin++                         
          @nLin,05 pSay "Total de Loca��o"
          @nLin,65 pSay TRANSFORM(nLocacao,"@E 9,999,999.99")          
          nLocacao := 0
          nlin++
          @ nLin, 000  PSay __PrtThinLine()                    
          nlin++                            
	   EndIF
   EndIf   

EndDo

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

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
 cQuery +=           RetSQLName("SF4")+" SF4  "	

 cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
 cQuery += " AND SF4.D_E_L_E_T_ <> '*' " 
 cQuery += " AND D2_TES = F4_CODIGO "
 cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND F4_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND D2_EMISSAO BETWEEN '"+dTos(mv_par03)+"' AND '"+dTos(mv_par04)+"' " 
 cQuery += " AND D2_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
 
 IF mv_par08 == 1 //PE�A    
	 cQuery += " AND F4_CF = '5102' "
   Elseif mv_par08 == 2 //SERVI�O
     cQuery += " AND F4_CF = '5933' AND D2_TES <> '531' "
   Elseif mv_par08 == 3  //LOCA��O
     cQuery += " AND F4_CF = '5933' AND D2_TES = '531' "
 EndIf                

// cQuery += " AND D2_TES BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "

 /*cQuery := ChangeQuery( cQuery )
 dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "XXX", .F., .F. )*/


   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
   nRegis := SOMA
   dbCloseArea()

   cQuery := StrTran(cQuery,"COUNT(*)SOMA", "*")
   cQuery += " ORDER BY D2_DOC, F4_CF "
//   cQuery += If( ValType(cOrder) == "C" , " ORDER BY "+cOrder,"")
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
          		
Return	 


*********************************
Static Function ValidPerg(cPerg)
*********************************                                    

Local _sAlias := Alias()
Local aRegs :={}

DbSelectArea("SX1")
DbSetOrder(1)

/* PutSx1(cPerg,"01","Da Filial          ?","","","mv_ch1","C",02,0,0,"G","","","","","mv_par01")
 PutSx1(cPerg,"02","Ate a Filial       ?","","","mv_ch2","C",02,0,0,"G","","","","","mv_par02")                                                                    //    lupinha
 PutSx1(cPerg,"03","Da Data            ?","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03")
 PutSx1(cPerg,"04","Ate a Data         ?","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04")
 PutSx1(cPerg,"05","Da Nota            ?","","","mv_ch5","C",06,0,0,"G","","SF2","","","mv_par05")
 PutSx1(cPerg,"06","Ate a nota         ?","","","mv_ch6","C",06,0,0,"G","","SF2","","","mv_par06")                              
 PutSx1(cPerg,"07","Tipo do Item       ?","","","mv_ch7","N",01,0,0,"C","","","","","mv_par07","Pe�a","","","","","Servi�o","","","","","Loca��o","","","","","Todos") 
 
 PutSx1(cPerg,"08","Tipo Relat�rio     ?","","","mv_ch8","N",01,0,0,"C","","","","","mv_par08","Sint�tico","","","","Anal�tico")

  */


aAdd(aRegs,{cPerg,"01","Da Filial      ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Filial   ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Da Data        ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Data     ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Da Nota        ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","", "","","","","","","","","","","","","","","","","","","","","","SF2",""})
aAdd(aRegs,{cPerg,"06","Ate a nota     ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","", "","","","","","","","","","","","","","","","","","","","","","SF2",""})

//aAdd(aRegs,{cPerg,"07","Do TES         ?","","","mv_ch7","C",03,0,0,"G","","mv_par07","","","", "","","","","","","","","","","","","","","","","","","","","","SF4",""})
//aAdd(aRegs,{cPerg,"08","Ate o TES      ?","","","mv_ch8","C",03,0,0,"G","","mv_par08","","","", "","","","","","","","","","","","","","","","","","","","","","SF4",""})

aAdd(aRegs,{cPerg,"07","Tipo Relat�rio ?","","","mv_ch7","N",01,0,0,"C","","mv_par09","Sint�tico","","", "","","Anal�tico","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Tipo do Item   ?","","","mv_ch8","N",01,0,0,"C","","mv_par10","Pe�a","","", "","","Servi�o","","","","","Loca��o","","","","","Todos","","","","","","","","","",""})

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