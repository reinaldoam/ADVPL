#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AGFATR01  � Autor � WERMESON  GADELHA  � Data �  02/01/08   ���
�������������������������������������������������������������������������͹��
���Descricao � RELATORIO DE FATURAMENTO PO PECA, SERVI�O E LOCA��O        ���
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
Local nLin         := 180

//                    0			1		  2			3		  4			5		  6			7		  8			9		  0			1         2         3		  4		    5         6         7         8         9         0         1         2         6
//					  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec1       := "   PRODUTO                                                 QTDE      PRE�O UNIT.  VLR BRUTO    IPI        ICMS       PIS       COFINS     CSLL      INSS      DESCONTO   VLR. L�QUIDO"  
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "G"
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
private lweb       := IsBlind()


Private cString := "SD2"                         

dbSelectArea("SD2")
//dbSetOrder(1)
U_MsSetOrder("SD2","D2_FILIAL+D2_COD+D2_LOCAL+D2_NUMSEQ")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima

If lWeb  
   mv_par01 := "  "
   mv_par02 := "ZZ"
   mv_par03 := dTos(date())
   mv_par04 := dTos(date())
   mv_par05 := "      "
   mv_par06 := "ZZZZZZ"
   mv_par07 := 2
   mv_par08 := 4
   mv_par09 := "   "
   mv_par10 := "ZZZ"
   mv_par11 := "      "
   mv_par12 := "ZZZZZZ"
   __AIMPRESS[1]:=1 
Else
   //	ValidPerg(cPerg)
   Pergunte(cPerg,.F.)
   //���������������������������������������������������������������������Ŀ
   //� Monta a interface padrao com o usuario...                           �
   //�����������������������������������������������������������������������
   wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
   If nLastKey == 27
      Return
   Endif
   SetDefault(aReturn,cString)
EndIf   

If mv_par07 == 1                                                                                               // 1                                                                                                  2
//           0	       1		 2		   3		 4		   5		 6		   7		 8		   9	     0  	   1         2         3		 4		   5         6         7         8         9         0         1         2         
//			 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
 Cabec1  := "NOTA FISCAL      CLIENTE                                      VALOR BASE     VENDEDOR1                  %      COMISS�O1   VENDEDOR2                   %       COMISS�O2    COND. PAG.           PE�A     SERVI�O    LOCA��O" 
 Cabec2  := ""
EndIf
Cabec2  := SPACE(91)+"PERIODO DE " + SubStr(dTos(mv_par03),7,2) + "/"+ SubStr(dTos(mv_par03),5,2)+ "/" +SubStr(dTos(mv_par03),1,4) +; 
		   " ATE " + SubStr(dTos(mv_par04),7,2) + "/"+ SubStr(dTos(mv_par04),5,2)+ "/" + SubStr(dTos(mv_par04),1,4) 
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

Static Function RunReport(Cabec1,Cabec2,Titulo,nLinII)

Local nOrdem
Private nRegis	 := 0
Private cAuxDoc  := ""
pRIVATE cAuxSer  := ""
Private cTipos   := {"Pe�as","Servi�o","Loca��o"}
Private cAuxTES  := ""
Private cTes1	 := ""
Private cAuxVend := ""
Private nType    := 0
Private nPeca    := 0
Private nLocacao := 0
Private nServico := 0
Private nLin     := 180 //nLinII 
                       //  11  		1    	  2		3	  4	   5      6     7      8      9        10
Private aValPeca := {} // QTDE,PRE�O UNIT., BRUTO, IPI, ICMS, PIS, COFINS, CSLL, INSS, DESCONTO, L�QUIDO
Private aValLoca := {} // QTDE,PRE�O UNIT., BRUTO, IPI, ICMS, PIS, COFINS, CSLL, INSS, DESCONTO, L�QUIDO
Private aValServ := {} // QTDE,PRE�O UNIT., BRUTO, IPI, ICMS, PIS, COFINS, CSLL, INSS, DESCONTO, L�QUIDO
Private aValores := {}
Private aValVend := {}

Private aTotVal  := {}
Private nTotPeca := 0
Private nTotLoca := 0
Private nTotServ := 0
Private cCfPeca  := getmv("MV_CFPECA")
Private cCfServ  := getmv("MV_CFSERV")
Private cTesLoca := getmv("MV_TESLOCA")
Private nAuxLin  := nLin
Private lImp 	 := .F.
                     
Private nValBase := 0
Private nValBVen := 0
Private nValCom1 := 0
Private nValCom2 := 0

Private nValCVe1 := 0
Private nValCVe2 := 0

Private nBase    := 0

dbSelectArea(cString)
dbSetOrder(1)

for i:= 1 to 3                         
 aAdd(aValores,{0,0,0,0,0,0,0,0,0,0,0,0}) 
 aAdd(aValVend,{0,0,0,0,0,0,0,0,0,0,0,0})      
 aAdd(aTotVal, {0,0,0,0,0,0,0,0,0,0,0,0})
Next

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
   //����������������������������������Ŀ
   //� Verifica se a NF tem devolucao  �
   //������������������������������������
   If !VerifSD1()	
       cAuxDoc:= XXX->D2_DOC
       cAuxSer:= XXX->D2_SERIE
       cAuxTES:= XXX->D2_CF
       cTes1  := XXX->D2_TES
       lImp   := .T.
	   XXX->(dbSkip())
       //If (XXX->D2_CF <> cAuxTES .Or. cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE)
    	  // MostraSoma()
       //EndIf   
	   LOOP 	  
   EndIf

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������
   If nLin > 55  
      if (mv_par07 == 1 .And. nAuxLin > 55) .or. mv_par07 == 2 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin := 9 
       nAuxLin := 9 
      EndIf
   Endif 
   
   If cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE
      If nlin <> 9 .And. mv_par07 == 2
         //nLin++
         // @ nLin, 000  PSay __PrtThinLine()                    
         nlin++
      Endif           
      nBase := QryVend(XXX->F2_DOC,XXX->F2_SERIE)  
      @nLin,00 pSay iif(mv_par07==2,"Nota Fiscal: ","")+XXX->D2_SERIE+" - "+XXX->D2_DOC+SPACE(5)+ iif(mv_par07==2,"Cliente: ","")+SubStr(XXX->D2_CLIENTE+" - "+Posicione("SA1",1,xFilial("SA1")+XXX->D2_CLIENTE,"A1_NOME"),1,40)+;
                    Space(5)+iif(mv_par07==2,"Valor Base: ","")+Transform(nBase,"@E 999,999.99")+;
                    Space(5)+iif(mv_par07==2,"Vendedor1: ","")+SubStr(Posicione("SA3",1,xFilial("SA3")+XXX->F2_VEND1,"A3_NOME"),1,20) +;
                    Space(5)+iif(mv_par07==2,"Comiss�o1: ","")+Transform(XXX->D2_COMIS1,"@E 999.99")+"%"+;
                    Space(5)+iif(mv_par07==2,"Valor Comiss�o1: ","")+Transform((XXX->D2_COMIS1 * nBase)/100,"@E 999.99")+;
                    Space(5)+iif(mv_par07==2,"Vendedor2: ","")+SubStr(Posicione("SA3",1,xFilial("SA3")+XXX->F2_VEND2,"A3_NOME"),1,20) +;
                    Space(5)+iif(mv_par07==2,"Comiss�o2: ","")+Transform(XXX->D2_COMIS2,"@E 999.99")+"%"+;
                    Space(5)+iif(mv_par07==2,"Valor Comiss�o2: ","")+Transform((XXX->D2_COMIS2 * nBase)/100,"@E 9,999.99")+;
                    SPACE(5)+iif(mv_par07==2,"Cond. Pag.: ","") +Iif (XXX->F2_COND = "CN", "CONDICAO NEGOCIADA", Posicione("SE4",1,xFilial("SE4")+XXX->F2_COND,"E4_DESCRI"))
      nAuxLin:= nLin
      nValBase +=  nBase
      nValBVen +=  nBase
     
      nValCom1 += (XXX->D2_COMIS1 * nBase)/100
      nValCom2 += (XXX->D2_COMIS2 * nBase)/100
     
      nValCVe1 += (XXX->D2_COMIS1 * nBase)/100
      nValCVe2 += (XXX->D2_COMIS2 * nBase)/100
     
      nLin++
   EndIf        

//   SF4->(dbSetOrder(1))
   U_MsSetOrder("SF4","F4_FILIAL+F4_CODIGO")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima
   SF4->(dbSeek(xFilial("SF4")+XXX->D2_TES))
   ntype := 1   
   If (XXX->D2_CF <> cAuxTES .Or. cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE)
      IF XXX->D2_CF = cCfPeca .Or. XXX->D2_CF = "6102" .Or. XXX->D2_CF="6929" .Or. XXX->D2_CF="6108"
	      IF mv_par07 == 2
	        @nLin,02 pSay cTipos[1]
	      EndIf  
	      nType := 1
	      nLin++
	   ElseIf XXX->D2_CF = cCfServ .And. XXX->D2_TES <> cTesLoca
	      IF mv_par07 == 2
	        @nLin,02 pSay cTipos[2]
	      EndIf  
	      nType := 2
	      nLin++
	   ElseIf XXX->D2_CF = cCfServ .And. XXX->D2_TES = cTesLoca
	      IF mv_par07 == 2
	        @nLin,02 pSay cTipos[3]
	      EndIf  
	      nType := 3
	      nLin++
	     Else     
	       cAuxDoc:= XXX->D2_DOC
           cAuxTES:= XXX->D2_CF
           cTes1  := XXX->D2_TES
           lImp   := .T.
           cAuxSer:= XXX->D2_SERIE
	      XXX->(dbSkip())
	      If (XXX->D2_CF <> cAuxTES .Or. cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE)
	        MostraSoma()
	      EndIf  
	      LOOP 
	   EndIF
   EndIf          
   
   If mv_par07 == 2
	   @nLin,004 pSay SubStr(AllTrim(XXX->D2_COD) + " - " + Posicione("SB1",1,xFilial("SB1")+XXX->D2_COD,"B1_DESC"),1,54) // PRODUTO E DESCRI��O
	   @nLin,060 pSay XXX->D2_QUANT 							  // QUANTIDADE	
	   @nLin,065 pSay TRANSFORM(XXX->D2_PRUNIT ,"@E 999,999.99")  // PRECO UNITARIO
	   @nLin,077 pSay TRANSFORM(XXX->D2_PRCVEN + XXX->D2_DESCON,"@E 999,999.99")  // VALOR BRUTO
	   @nLin,089 pSay TRANSFORM(XXX->D2_VALIPI ,"@E 99,999.99")   // IPI
	   @nLin,100 pSay TRANSFORM(XXX->D2_VALICM ,"@E 99,999.99")   // ICMS
	   @nLin,111 pSay TRANSFORM(XXX->F2_VALPIS ,"@E 99,999.99")   // PIS
	   @nLin,122 pSay TRANSFORM(XXX->F2_VALCOFI,"@E 99,999.99")   // COFINS
	   @nLin,133 pSay TRANSFORM(XXX->F2_VALCSLL,"@E 99,999.99")   // CSLL   
	   @nLin,144 pSay TRANSFORM(XXX->D2_VALINS ,"@E 99,999.99")   // INSS      
	   @nLin,155 pSay TRANSFORM(XXX->D2_DESCON ,"@E 99,999.99")   // DESCONTO   
	   @nLin,166 pSay TRANSFORM(XXX->D2_TOTAL  ,"@E 999,999.99")  // VALOR LIQUIDO
   EndIf	   
   If nType == 1
       nPeca += XXX->D2_TOTAL
     ElseIf nType == 2
       nServico += XXX->D2_TOTAL
	 ElseIf nType == 3
       nLocacao += XXX->D2_TOTAL
   EndIf
         
   aValores[nType][1]  += XXX->D2_PRUNIT
   aValores[nType][2]  += XXX->D2_PRCVEN + XXX->D2_DESCON
   aValores[nType][3]  += XXX->D2_VALIPI
   aValores[nType][4]  += XXX->D2_VALICM
   aValores[nType][5]  += XXX->F2_VALPIS
   aValores[nType][6]  += XXX->F2_VALCOFI
   aValores[nType][7]  += XXX->F2_VALCSLL
   aValores[nType][8]  += XXX->D2_VALINS
   aValores[nType][9]  += XXX->D2_DESCON
   aValores[nType][10] += XXX->D2_TOTAL
   aValores[nType][11] += XXX->D2_QUANT

   aTotVal[nType][1]  += XXX->D2_PRUNIT
   aTotVal[nType][2]  += XXX->D2_PRCVEN + XXX->D2_DESCON
   aTotVal[nType][3]  += XXX->D2_VALIPI
   aTotVal[nType][4]  += XXX->D2_VALICM
   aTotVal[nType][5]  += XXX->F2_VALPIS
   aTotVal[nType][6]  += XXX->F2_VALCOFI
   aTotVal[nType][7]  += XXX->F2_VALCSLL
   aTotVal[nType][8]  += XXX->D2_VALINS
   aTotVal[nType][9]  += XXX->D2_DESCON
   aTotVal[nType][10] += XXX->D2_TOTAL
   aTotVal[nType][11] += XXX->D2_QUANT   
      
   aValVend[nType][1]  += XXX->D2_PRUNIT
   aValVend[nType][2]  += XXX->D2_PRCVEN + XXX->D2_DESCON
   aValVend[nType][3]  += XXX->D2_VALIPI
   aValVend[nType][4]  += XXX->D2_VALICM
   aValVend[nType][5]  += XXX->F2_VALPIS
   aValVend[nType][6]  += XXX->F2_VALCOFI
   aValVend[nType][7]  += XXX->F2_VALCSLL
   aValVend[nType][8]  += XXX->D2_VALINS
   aValVend[nType][9]  += XXX->D2_DESCON
   aValVend[nType][10] += XXX->D2_TOTAL
   aValVend[nType][11] += XXX->D2_QUANT
   
   If mv_par07 == 2   
      nLin := nLin + 1 // Avanca a linha de impressao
   Else
      nLin := nAuxLin + 1
   EndIf  
      
   cAuxDoc  := XXX->D2_DOC
   cAuxTES  := XXX->D2_CF
   cTes1    := XXX->D2_TES
   cAuxSer  := XXX->D2_SERIE                                       
   cAuxVend := XXX->F2_VEND1 
   XXX->(dbSkip()) // Avanca o ponteiro do registro no arquivo

   If (XXX->D2_CF <> cAuxTES .Or. cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE)
      MostraSoma()	   	   
   EndIf   
   
   If cAuxVend <> XXX->F2_VEND1 .And. mv_par07 == 1
      nLin++
      @ nLin, 000  PSay __PrtThinLine()
      nLin++
      @nLin,002 pSay "TOTAL VENDEDOR: " + Posicione("SA3",1,xFilial("SA3")+AllTrim(cAuxVend),"A3_NOME")         

      @nLin,062 pSay TRANSFORM(nValBVen ,"@E 999,999.99")   // INSS      
      @nLin,108 pSay TRANSFORM(nValCVe1 ,"@E 999,999.99")   // DESCONTO   
      @nLin,157 pSay TRANSFORM(nValCVe2 ,"@E 999,999.99")    // VALOR LIQUIDO
    
      /*    
      @nLin,188 pSay TRANSFORM(aValVend[1][10] ,"@E 999,999.99")   // INSS      
      @nLin,199 pSay TRANSFORM(aValVend[2][10] ,"@E 999,999.99")   // DESCONTO   
      @nLin,210 pSay TRANSFORM(aValVend[3][10] ,"@E 999,999.99")    // VALOR LIQUIDO
      */                             
      nValBVen  := 0
      nValCVe1  := 0
      nValCVe2  := 0
	 
	  aValVend[1][10] := 0
	  aValVend[2][10] := 0
	  aValVend[3][10] := 0
	 
	  nAuxLin:= nLin   
	  if !(XXX->(Eof()))
	     nLin++
	     @ nLin, 000  PSay __PrtThinLine()
	     nLin++
	     nAuxLin:= nLin
      EndIf
   EndIf
Enddo
                                       
If nRegis > 0 .And. mv_par07 == 2
  nLin++
  //@ nLin, 000  PSay __PrtThinLine()                    
  nlin++                            
  
  @nLin,05 pSay "TOTAL GERAL DE PE�AS: "                             
         
  @nLin,060 pSay aTotVal[1][11] 			     			 // QUANTIDADE	
 // @nLin,065 pSay TRANSFORM(aTotVal[1][1] ,"@E 999,999.99")  // PRECO UNITARIO
  @nLin,077 pSay TRANSFORM(aTotVal[1][2] ,"@E 999,999.99")  // VALOR BRUTO
  @nLin,089 pSay TRANSFORM(aTotVal[1][3] ,"@E 99,999.99")   // IPI
  @nLin,100 pSay TRANSFORM(aTotVal[1][4] ,"@E 99,999.99")   // ICMS
  @nLin,111 pSay TRANSFORM(aTotVal[1][5] ,"@E 99,999.99")   // PIS
  @nLin,122 pSay TRANSFORM(aTotVal[1][6] ,"@E 99,999.99")   // COFINS
  @nLin,133 pSay TRANSFORM(aTotVal[1][7] ,"@E 99,999.99")   // CSLL   
  @nLin,144 pSay TRANSFORM(aTotVal[1][8] ,"@E 99,999.99")   // INSS      
  @nLin,155 pSay TRANSFORM(aTotVal[1][9] ,"@E 99,999.99")   // DESCONTO   
  @nLin,166 pSay TRANSFORM(aTotVal[1][10],"@E 999,999.99")  // VALOR LIQUIDO

            
  nLin++
 // @ nLin, 000  PSay __PrtThinLine()                    
  nlin++                         
  @nLin,05 pSay "TOTAL GERAL DE SERVI�OS: "
      
            
  @nLin,060 pSay aTotVal[2][11] 			     			 // QUANTIDADE	
 // @nLin,065 pSay TRANSFORM(aTotVal[2][1] ,"@E 999,999.99")  // PRECO UNITARIO
  @nLin,077 pSay TRANSFORM(aTotVal[2][2] ,"@E 999,999.99")  // VALOR BRUTO
  @nLin,089 pSay TRANSFORM(aTotVal[2][3] ,"@E 99,999.99")   // IPI
  @nLin,100 pSay TRANSFORM(aTotVal[2][4] ,"@E 99,999.99")   // ICMS
  @nLin,111 pSay TRANSFORM(aTotVal[2][5] ,"@E 99,999.99")   // PIS
  @nLin,122 pSay TRANSFORM(aTotVal[2][6] ,"@E 99,999.99")   // COFINS
  @nLin,133 pSay TRANSFORM(aTotVal[2][7] ,"@E 99,999.99")   // CSLL   
  @nLin,144 pSay TRANSFORM(aTotVal[2][8] ,"@E 99,999.99")   // INSS      
  @nLin,155 pSay TRANSFORM(aTotVal[2][9] ,"@E 99,999.99")   // DESCONTO   
  @nLin,166 pSay TRANSFORM(aTotVal[2][10],"@E 999,999.99")  // VALOR LIQUIDO

  nlin++
  nlin++                            
 // @ nLin, 000  PSay __PrtThinLine()                    
 // nlin++                         
  @nLin,05 pSay "TOTAL GERAL DE LOCA��O: "
                   
  @nLin,060 pSay aTotVal[3][11] 			     			 // QUANTIDADE	
 // @nLin,065 pSay TRANSFORM(aTotVal[3][1] ,"@E 999,999.99")  // PRECO UNITARIO
  @nLin,077 pSay TRANSFORM(aTotVal[3][2] ,"@E 999,999.99")  // VALOR BRUTO
  @nLin,089 pSay TRANSFORM(aTotVal[3][3] ,"@E 99,999.99")   // IPI
  @nLin,100 pSay TRANSFORM(aTotVal[3][4] ,"@E 99,999.99")   // ICMS
  @nLin,111 pSay TRANSFORM(aTotVal[3][5] ,"@E 99,999.99")   // PIS
  @nLin,122 pSay TRANSFORM(aTotVal[3][6] ,"@E 99,999.99")   // COFINS
  @nLin,133 pSay TRANSFORM(aTotVal[3][7] ,"@E 99,999.99")   // CSLL   
  @nLin,144 pSay TRANSFORM(aTotVal[3][8] ,"@E 99,999.99")   // INSS      
  @nLin,155 pSay TRANSFORM(aTotVal[3][9] ,"@E 99,999.99")   // DESCONTO   
  @nLin,166 pSay TRANSFORM(aTotVal[3][10],"@E 999,999.99")  // VALOR LIQUIDO
                   
  nlin++
 // @ nLin, 000  PSay __PrtThinLine()                    
  nlin++                            
  
  @nLin,05 pSay "TOTAL GERAL "
                   
  @nLin,060 pSay aTotVal[3][11] +aTotVal[2][11]+aTotVal[1][11] 			     			 // QUANTIDADE	
 // @nLin,065 pSay TRANSFORM(aTotVal[3][1] ,"@E 999,999.99")  // PRECO UNITARIO
  @nLin,077 pSay TRANSFORM(aTotVal[3][2]+aTotVal[2][2]+aTotVal[1][2] ,"@E 999,999.99")  // VALOR BRUTO
  @nLin,089 pSay TRANSFORM(aTotVal[3][3]+aTotVal[2][3]+aTotVal[1][3] ,"@E 99,999.99")   // IPI
  @nLin,100 pSay TRANSFORM(aTotVal[3][4]+aTotVal[2][4]+aTotVal[1][4] ,"@E 99,999.99")   // ICMS
  @nLin,111 pSay TRANSFORM(aTotVal[3][5]+aTotVal[2][5]+aTotVal[1][5] ,"@E 99,999.99")   // PIS
  @nLin,122 pSay TRANSFORM(aTotVal[3][6]+aTotVal[2][6]+aTotVal[1][6] ,"@E 99,999.99")   // COFINS
  @nLin,133 pSay TRANSFORM(aTotVal[3][7]+aTotVal[2][7]+aTotVal[1][7] ,"@E 99,999.99")   // CSLL   
  @nLin,144 pSay TRANSFORM(aTotVal[3][8]+aTotVal[2][8]+aTotVal[1][8] ,"@E 99,999.99")   // INSS      
  @nLin,155 pSay TRANSFORM(aTotVal[3][9]+aTotVal[2][9]+aTotVal[1][9] ,"@E 99,999.99")   // DESCONTO   
  @nLin,166 pSay TRANSFORM(aTotVal[3][10]+aTotVal[2][10]+aTotVal[1][10],"@E 999,999.99")  // VALOR LIQUIDO
  
 ElseIf nRegis > 0 .And. mv_par07 == 1 
   nlin++
   @ nLin, 000  PSay __PrtThinLine()                    
   nlin++                            
                          
   @nLin,05 pSay "TOTAL: "
 
   @nLin,062 pSay TRANSFORM(nValBase ,"@E 999,999.99")   // INSS      
   @nLin,108 pSay TRANSFORM(nValCom1 ,"@E 999,999.99")   // DESCONTO   
   @nLin,157 pSay TRANSFORM(nValCom2 ,"@E 999,999.99")    // VALOR LIQUIDO
 
   
   @nLin,188 pSay TRANSFORM(aTotVal[1][10] ,"@E 999,999.99")   // INSS      
   @nLin,199 pSay TRANSFORM(aTotVal[2][10] ,"@E 999,999.99")   // DESCONTO   
   @nLin,210 pSay TRANSFORM(aTotVal[3][10] ,"@E 999,999.99")   // VALOR LIQUIDO
   
   nlin++
   @ nLin, 000  PSay __PrtThinLine()                    
   nlin++                            
   
   @nLin,05 pSay "TOTAL (PE�AS, SERVI�OS, LOCA��ES): "+TRANSFORM(aTotVal[3][10]+aTotVal[2][10]+aTotVal[1][10] ,"@E 9,999,999.99")    // VALOR LIQUIDO

   nlin++
   @ nLin, 000  PSay __PrtThinLine()                     
EndIf      

XXX->(dbCloseArea())

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


//////////////////////////
Static Function MontaQry()
        
 Local cQuery := ""

 cQuery := " SELECT COUNT(*)SOMA "
 cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
 cQuery +=          RetSQLName("SB1")+" SB1, "
 cQuery +=          RetSQLName("SF2")+" SF2 "
 cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "  
 cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
 cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
 cQuery += " AND F2_DOC = D2_DOC " 
 cQuery += " AND F2_SERIE = D2_SERIE "
 cQuery += " AND D2_COD = B1_COD "
 cQuery += " AND B1_X_COMIS IN(' ','S') "

 cQuery += " AND F2_VEND1 <> '000016' "  

 cQuery += " AND D2_PRCVEN <> 0    
 cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND D2_EMISSAO BETWEEN '"+dTos(mv_par03)+"' AND '"+dTos(mv_par04)+"' " 
 cQuery += " AND F2_EMISSAO BETWEEN '"+dTos(mv_par03)+"' AND '"+dTos(mv_par04)+"' " 
 cQuery += " AND D2_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
 cQuery += " AND F2_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "                 
 cQuery += " AND D2_SERIE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
 cQuery += " AND F2_SERIE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "                 
 cQuery += " AND (F2_VEND1 BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' "  
 cQuery += " OR F2_VEND2 BETWEEN '"+mv_par11+"' AND '"+mv_par12+"') "  
                   
 IF mv_par08 == 1 //PE�A    
     cQuery += " AND( D2_CF = '"+cCfPeca+"' "                        
     cQuery += " OR D2_CF = '6102'"
     cQuery += " OR D2_CF = '6108')"
   Elseif mv_par08 == 2 //SERVI�O
     cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"' "
     cQuery += " OR D2_CF = '6102')"
   Elseif mv_par08 == 3  //LOCA��O
     cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"' "
     cQuery += " OR D2_CF = '6102')" 
     cQuery += " OR D2_CF = '6933')" 
   Elseif mv_par08 == 4  // Todos
     cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
     cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
     cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
     cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933')"
 EndIf                

 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
 nRegis := SOMA             
 dbCloseArea()

 cQuery := StrTran(cQuery,"COUNT(*)SOMA", "*")
 cQuery += " ORDER BY F2_VEND1,D2_DOC,D2_SERIE, D2_CF "
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
aAdd(aRegs,{cPerg,"03","Da Data        ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Data     ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Da Nota        ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","", "","","","","","","","","","","","","","","","","","","","","","SF2",""})
aAdd(aRegs,{cPerg,"06","Ate a nota     ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","", "","","","","","","","","","","","","","","","","","","","","","SF2",""})
aAdd(aRegs,{cPerg,"07","Tipo Relat�rio ?","","","mv_ch7","N",01,0,0,"C","","mv_par07","Sint�tico","","", "","","Anal�tico","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Tipo do Item   ?","","","mv_ch8","N",01,0,0,"C","","mv_par08","Pe�a","","", "","","Servi�o","","","","","Loca��o","","","","","Todos","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Da Serie       ?","","","mv_ch9","C",03,0,0,"G","","mv_par09","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Ate a Serie    ?","","","mv_cha","C",03,0,0,"G","","mv_par10","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Do Vendedor    ?","","","mv_chb","C",06,0,0,"G","","mv_par11","","","", "","","","","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cPerg,"12","Ate o Vendedor ?","","","mv_chc","C",06,0,0,"G","","mv_par12","","","", "","","","","","","","","","","","","","","","","","","","","","SA3",""})

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

STATIC FUNCTION MostraSoma()
      
	 IF cAuxTES = cCfPeca .Or. AllTrim(cAuxTes) = "6102" .Or. AllTrim(cAuxTes) = "6108" //.And. nType == 1
                    
          If mv_par07 == 2
	          @ nLin, 000  PSay __PrtThinLine()
	          nlin++                            
	          @nLin,05 pSay "TOTAL DE PE�AS: "          
	          //@nLin,65 pSay TRANSFORM(nPeca,"@E 9,999,999.99")	         	            
	          @nLin,060 pSay aValores[1][11] 			     			 // QUANTIDADE	
			  @nLin,065 pSay TRANSFORM(aValores[1][1] ,"@E 999,999.99")  // PRECO UNITARIO
			  @nLin,077 pSay TRANSFORM(aValores[1][2] ,"@E 999,999.99")  // VALOR BRUTO
			  @nLin,089 pSay TRANSFORM(aValores[1][3] ,"@E 99,999.99")   // IPI
			  @nLin,100 pSay TRANSFORM(aValores[1][4] ,"@E 99,999.99")   // ICMS
			  @nLin,111 pSay TRANSFORM(aValores[1][5] ,"@E 99,999.99")   // PIS
			  @nLin,122 pSay TRANSFORM(aValores[1][6] ,"@E 99,999.99")   // COFINS
			  @nLin,133 pSay TRANSFORM(aValores[1][7] ,"@E 99,999.99")   // CSLL   
			  @nLin,144 pSay TRANSFORM(aValores[1][8] ,"@E 99,999.99")   // INSS      
			  @nLin,155 pSay TRANSFORM(aValores[1][9] ,"@E 99,999.99")   // DESCONTO   
			  @nLin,166 pSay TRANSFORM(aValores[1][10],"@E 999,999.99")  // VALOR LIQUIDO
	          aValores[1][1] := 0
	          aValores[1][2] := 0
	          aValores[1][3] := 0
	          aValores[1][4] := 0
	          aValores[1][5] := 0
	          aValores[1][6] := 0
	          aValores[1][7] := 0
	          aValores[1][8] := 0
	          aValores[1][9] := 0
	          aValores[1][10]:= 0
	          aValores[1][11]:= 0
			  nlin++
              @ nLin, 000  PSay __PrtThinLine()                    
              nlin++                            	  	  
		  EndIf	                            
         ElseIf cAuxTES = cCfServ .And. cTes1 <> cTesLoca
          //nLin++
          If mv_par07 == 2
	          @ nLin, 000  PSay __PrtThinLine()                    
	          nlin++                         
	          @nLin,05 pSay "TOTAL DE SERVI�OS: "	      	            
	          @nLin,060 pSay aValores[2][11] 			     			 // QUANTIDADE	
			  @nLin,065 pSay TRANSFORM(aValores[2][1] ,"@E 999,999.99")  // PRECO UNITARIO
			  @nLin,077 pSay TRANSFORM(aValores[2][2] ,"@E 999,999.99")  // VALOR BRUTO
			  @nLin,089 pSay TRANSFORM(aValores[2][3] ,"@E 99,999.99")   // IPI
			  @nLin,100 pSay TRANSFORM(aValores[2][4] ,"@E 99,999.99")   // ICMS
			  @nLin,111 pSay TRANSFORM(aValores[2][5] ,"@E 99,999.99")   // PIS
			  @nLin,122 pSay TRANSFORM(aValores[2][6] ,"@E 99,999.99")   // COFINS
			  @nLin,133 pSay TRANSFORM(aValores[2][7] ,"@E 99,999.99")   // CSLL   
			  @nLin,144 pSay TRANSFORM(aValores[2][8] ,"@E 99,999.99")   // INSS      
			  @nLin,155 pSay TRANSFORM(aValores[2][9] ,"@E 99,999.99")   // DESCONTO   
			  @nLin,166 pSay TRANSFORM(aValores[2][10],"@E 999,999.99")  // VALOR LIQUIDO				  
	          aValores[2][1] := 0
	          aValores[2][2] := 0
	          aValores[2][3] := 0
	          aValores[2][4] := 0
	          aValores[2][5] := 0
	          aValores[2][6] := 0
	          aValores[2][7] := 0
	          aValores[2][8] := 0
	          aValores[2][9] := 0
	          aValores[2][10]:= 0
	          aValores[2][11]:= 0
	          nlin++
	          @ nLin, 000  PSay __PrtThinLine()                    
	          nlin++                            
		  EndIf	    
          
	     ElseIf cAuxTES = cCfServ .And. cTes1 = cTesLoca
          If mv_par07 == 2
	          @ nLin, 000  PSay __PrtThinLine()                    
	          nlin++                         
	          @nLin,05 pSay "TOTAL DE LOCA��O: "	          
	          @nLin,060 pSay aValores[3][11] 			     			 // QUANTIDADE	
			  @nLin,065 pSay TRANSFORM(aValores[3][1] ,"@E 999,999.99")  // PRECO UNITARIO
			  @nLin,077 pSay TRANSFORM(aValores[3][2] ,"@E 999,999.99")  // VALOR BRUTO
			  @nLin,089 pSay TRANSFORM(aValores[3][3] ,"@E 99,999.99")   // IPI
			  @nLin,100 pSay TRANSFORM(aValores[3][4] ,"@E 99,999.99")   // ICMS
			  @nLin,111 pSay TRANSFORM(aValores[3][5] ,"@E 99,999.99")   // PIS
			  @nLin,122 pSay TRANSFORM(aValores[3][6] ,"@E 99,999.99")   // COFINS
			  @nLin,133 pSay TRANSFORM(aValores[3][7] ,"@E 99,999.99")   // CSLL   
			  @nLin,144 pSay TRANSFORM(aValores[3][8] ,"@E 99,999.99")   // INSS      
			  @nLin,155 pSay TRANSFORM(aValores[3][9] ,"@E 99,999.99")   // DESCONTO   
			  @nLin,166 pSay TRANSFORM(aValores[3][10],"@E 999,999.99")  // VALOR LIQUIDO
              aValores[3][1] := 0
	          aValores[3][2] := 0
	          aValores[3][3] := 0
	          aValores[3][4] := 0
	          aValores[3][5] := 0
	          aValores[3][6] := 0
	          aValores[3][7] := 0
	          aValores[3][8] := 0
	          aValores[3][9] := 0
	          aValores[3][10]:= 0
			  aValores[3][11]:= 0					  	          
	          nlin++
	          @ nLin, 000  PSay __PrtThinLine()                    
	          nlin++    
		  EndIf	
                                            
	   EndIF
	   
	   If mv_par07 == 1 .And. (cAuxSer <> XXX->D2_SERIE .Or. cAuxDoc <> XXX->D2_DOC .oR. XXX->(EOF())) //.Or. lImp)
	      @nAuxLin,188 pSay TRANSFORM(aValores[1][10],"@E 999,999.99")  // PE�A      
		  @nAuxLin,199 pSay TRANSFORM(aValores[2][10],"@E 999,999.99")  // SERVI�OO   
		  @nAuxLin,210 pSay TRANSFORM(aValores[3][10],"@E 999,999.99")  // LOCA��O  
		  nLin := nAuxLin + 1
		  lImp:= .F.
		  aValores[1][1] := 0
          aValores[1][2] := 0
          aValores[1][3] := 0
          aValores[1][4] := 0
          aValores[1][5] := 0
          aValores[1][6] := 0
          aValores[1][7] := 0
          aValores[1][8] := 0
          aValores[1][9] := 0
          aValores[1][10]:= 0
          aValores[1][11]:= 0
          
          aValores[2][1] := 0
          aValores[2][2] := 0
          aValores[2][3] := 0
          aValores[2][4] := 0
          aValores[2][5] := 0
          aValores[2][6] := 0
          aValores[2][7] := 0
          aValores[2][8] := 0
          aValores[2][9] := 0
          aValores[2][10]:= 0
          aValores[2][11]:= 0
          
          aValores[3][1] := 0
          aValores[3][2] := 0
          aValores[3][3] := 0
          aValores[3][4] := 0
          aValores[3][5] := 0
          aValores[3][6] := 0
          aValores[3][7] := 0
          aValores[3][8] := 0
          aValores[3][9] := 0
          aValores[3][10]:= 0
          aValores[3][11]:= 0
	          
	   EndIf 
RETURN

//////////////////////////
Static Function VerifSD1()
        
Local cQuery := ""
Local lRet   := .F.

 cQuery := " SELECT D1_TIPO, D1_NFORI, D1_SERIORI,D1_ITEMORI "
 cQuery += " FROM "+RetSQLName("SD1")+" SD1 "   

 cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "
 cQuery += " AND D1_NFORI = '"+XXX->D2_DOC+"' " 
 cQuery += " AND D1_SERIORI = '"+XXX->D2_SERIE+"' " 
 cQuery += " AND D1_ITEMORI = '"+XXX->D2_ITEM+"' " 
                  
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
 lRet := YYY->(EOF())
 YYY->(dbCloseArea())

Return lRet                       

///////////////////////////////////////
Static Function QryVend(cNota, cSerie)
        
 Local cQuery := ""
 Local nSoma  := 0   
 Local cAuxSer:=""
 Local cAuxDoc:=""

 cQuery := " SELECT * "
 cQuery += "  FROM "+RetSQLName("SD2")+" SD2, "
 cQuery +=           RetSQLName("SB1")+" SB1, " 
 cQuery +=           RetSQLName("SF2")+" SF2 "
 cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "  
 cQuery += " AND SB1.D_E_L_E_T_ <> '*' " 
 cQuery += " AND SF2.D_E_L_E_T_ <> '*' " 
 cQuery += " AND F2_VEND1 <> '000016' "  
 cQuery += " AND F2_DOC = D2_DOC " 
 cQuery += " AND F2_SERIE = D2_SERIE "
 cQuery += " AND D2_COD = B1_COD "
 cQuery += " AND B1_X_COMIS IN(' ','S') "
  
 cQuery += " AND D2_PRCVEN <> 0                      
 cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 //cQuery += " AND D2_EMISSAO BETWEEN '"+dTos(mv_par03)+"' AND '"+dTos(mv_par04)+"' " 
 //cQuery += " AND F2_EMISSAO BETWEEN '"+dTos(mv_par03)+"' AND '"+dTos(mv_par04)+"' " 
 // cQuery += " AND D2_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
 cQuery += " AND F2_DOC = '"+cNota+"' "                 
 // cQuery += " AND D2_SERIE BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
 cQuery += " AND F2_SERIE = '"+cSerie+"' "
 
 // cQuery += " AND (F2_VEND1 BETWEEN '"+mv_par11+"' AND '"+mv_par12+"' "  
 // cQuery += " OR F2_VEND2 BETWEEN '"+mv_par11+"' AND '"+mv_par12+"') "  

 /* cQuery += " AND (F2_VEND1 = '"+cVend+"' "  
 IF !Empty(cVend)
   cQuery += " OR F2_VEND2 = '"+cVend+"') "                     
   Else
   cQuery += ") "
 EndIf
  */ 
/*  IF mv_par08 == 1 //PE�A    
     cQuery += " AND D2_CF = '"+cCfPeca+"' "
    Elseif mv_par08 == 2 //SERVI�O
     cQuery += " AND D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"' "
    Elseif mv_par08 == 3  //LOCA��O
     cQuery += " AND D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"' "
    Elseif mv_par08 == 4  // Todos
     cQuery += " AND (D2_CF = '"+cCfPeca+"' "
     cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
     cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "    
  EndIf               */

 IF mv_par08 == 1 //PE�A    
     cQuery += " AND( D2_CF = '"+cCfPeca+"' "                        
     cQuery += " OR D2_CF = '6102')"
     cQuery += " OR D2_CF = '6108')"
   Elseif mv_par08 == 2 //SERVI�O
     cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"' "
     cQuery += " OR D2_CF = '6102')"
   Elseif mv_par08 == 3  //LOCA��O
     cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"' "
     cQuery += " OR D2_CF = '6102' )"                                
     cQuery += " OR D2_CF = '6933' )"                                
   Elseif mv_par08 == 4  // Todos
     cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
     cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
     cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
     cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933')"
 EndIf                
   
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "QQQ", .T., .F. )

 While !QQQ->(Eof())
   	If !VerifSD1(QQQ->D2_DOC,QQQ->D2_SERIE,QQQ->D2_ITEM)
   	//   cAuxSer:=QQQ->D2_SERIE
      // cAuxDoc:=QQQ->D2_DOC
	   QQQ->(dbSkip())  	   
	   Loop
	EndIf
//   IF cAuxSer <> QQQ->D2_SERIE .Or. cAuxDoc <> QQQ->D2_DOC
 
 //	   If Empty(QQQ->F2_VEND2)
//	      nSoma += QQQ->D2_TOTAL  
 //	    Else 
	      nSoma += QQQ->D2_TOTAL  
 //	   EndIf
  // EndIf           
  // cAuxSer:=QQQ->D2_SERIE
  // cAuxDoc:=QQQ->D2_DOC

   QQQ->(dbSkip()) 
 End
 QQQ->(dbCloseArea())
Return nSoma 