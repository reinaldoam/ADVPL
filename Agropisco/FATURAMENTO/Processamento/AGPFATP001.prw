#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
//Teste para formação de preço
//Criado por Ulisses Junior em 24/04/07
//
User Function AGPFATP001()
Local nOpcA     := 0
Local bOk       := {|| nOpc:=1 , Processa({||AGPDIVP01A()},"Processando...")}
Local bCancel   := {|| nOpc:=0 , oDlg1:End()}

Private oDlg1      := Nil
Private oGet1      := Nil

Private nPerComis := 0
Private nPerTrans := 0
Private nPerEncFin:= 0
Private nPerIcms  := 0
Private nPerIr    := 0
Private nPerLucro := 0
Private nTotal    := 0
Private nMarkup   := 0
Private oPerComis ,oPerTrans ,oPerEncFin,oPerIcms,oPerIr,oPerLucro,oTotal    
//Tela de coleta de informações das taxas a serem utilizadas na formação de preços

If !SF1->F1_TIPO $ "N/C"
   Return
EndIf

If SF1->F1_TIPO = "C" .and. SD1->D1_ORIGLAN # "FR"
   Return
EndIf

DEFINE MSDIALOG oDlg1 TITLE "Formacao de Preco" From 10,40 To 30,90 //OF oMainWnd

@ 15, 16 TO 140,180 LABEL "Informacoes de Venda (%)" PIXEL OF oDlg1
                  	
@ 025, 020 SAY "Comissao        :" SIZE 70,7 PIXEL OF oDlg1
@ 040, 020 SAY "Transporte      :" SIZE 70,7 PIXEL OF oDlg1
@ 055, 020 SAY "Enc. Financeiros:" SIZE 70,7 PIXEL OF oDlg1
@ 070, 020 SAY "ICMS s/ Vendas  :" SIZE 70,7 PIXEL OF oDlg1
@ 085, 020 SAY "IR              :" SIZE 70,7 PIXEL OF oDlg1
@ 100, 020 SAY "Margem de Lucro :" SIZE 70,7 PIXEL OF oDlg1

@ 025, 070 MSGET oPerComis  Var nPerComis  PICTURE "@E 999.99" Valid Atualiza() SIZE 60,7 PIXEL OF oDlg1
@ 040, 070 MSGET oPerTrans  Var nPerTrans  PICTURE "@E 999.99" Valid Atualiza() SIZE 60,7 PIXEL OF oDlg1
@ 055, 070 MSGET oPerEncFin Var nPerEncFin PICTURE "@E 999.99" Valid Atualiza() SIZE 60,7 PIXEL OF oDlg1
@ 070, 070 MSGET oPerIcms   Var nPerIcms   PICTURE "@E 999.99" Valid Atualiza() SIZE 60,7 PIXEL OF oDlg1
@ 085, 070 MSGET oPerIr     Var nPerIr     PICTURE "@E 999.99" Valid Atualiza() SIZE 60,7 PIXEL OF oDlg1
@ 100, 070 MSGET oPerLucro  Var nPerLucro  PICTURE "@E 999.99" Valid Atualiza() SIZE 60,7 PIXEL OF oDlg1
@ 120, 020 SAY "TOTAL           : " SIZE 70,7 PIXEL OF oDlg1
@ 120, 070 MSGET oTotal     Var nTotal     PICTURE "@E 999.99"  SIZE 60,7 PIXEL OF oDlg1 WHEN .F.
/*
DEFINE SBUTTON FROM 040,140 TYPE 1 ACTION (nopc := 1,Processa({||AGPDIVP01A()},"Processando...")) ENABLE OF oDlg
DEFINE SBUTTON FROM 060,140 TYPE 2 ACTION (nopc := 0,oDlg:End()) ENABLE OF oDlg 
  */	 
ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,bOk,bCancel)

Return

****************************
Static Function Atualiza()
****************************

 nTotal := nPerComis+nPerTrans+nPerEncFin+nPerIcms+nPerIr+nPerLucro
 oTotal:Refresh()

Return

****************************
Static Function AtuBrowse()
****************************

 cProduto := M->Z3_COD
 cDesc    := Posicione("SB1",1,xFilial("SB1")+M->Z3_COD,"B1_DESC")
 nPVend   := M->Z3_VCALC
 nMargem  := ((M->Z3_VCALC+SZ3->Z3_CREDICM)-(M->Z3_VCALC*(nTotal-nPerLucro))-100)*100

 oProduto:Refresh()
 oDesc:Refresh()
 oPVend:Refresh()
 oMargem:Refresh()

Return

*******************************
Static Function AGPDIVP01A()
*******************************
Private cProd	 := SD1->D1_COD
Private cDesc	 := POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD,"B1_DESC")
Private nValVend := 0 //Preço calculado
Private nSuframa := 0 //Valor Suframa
Private nValFrete:= 0 //Valor do Frete
Private nCusto   := 0 //Abatido ICMS e despesas
Private nCrdIcm  := 0 //Crédito de Icms
Private nPisCof  := 0 //Valor de Pis e Cofins

Private aCampos  := {"Z3_ITEM","Z3_COD","Z3_UM"      ,"Z3_VUNIT"      ,"Z3_UCOMP" ,"Z3_VCALC"}
Private aCabec	 := {"Item"   ,"Codigo","Unid.Medida","Valor Unitario","Ult.Preco","Valor Venda"}
Private aAltera  := {}
Private aHeader  := {}
Private aCols	 := {}
Private aRegs	 := {}
Private nUsado	 := 0

oDlg1:End()
CalcPreco()

Return .T.

/*_______________________________________________________________________________
¦ Função    ¦ CriaHeader ¦ Autor ¦ Ulisses Junior           ¦ Data ¦ 02/05/2007 ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Montagem da Matriz aHeader - Cabeçalho do Browse                  ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
***************************************
Static Function CriaHeader()
***************************************
Local nIndVet

SX3->(dbSetOrder(2))

For nIndVet := 1 To Len(aCampos)
	
	SX3->(dbSeek(aCampos[nIndVet]))
	
	If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
		nUsado++
		AADD(aHeader,{ aCabec[nIndVet],;
						SX3->X3_CAMPO    ,;
						SX3->X3_PICTURE  ,;
						SX3->X3_TAMANHO  ,;
						SX3->X3_DECIMAL  ,;
						SX3->X3_VALID    ,;
						SX3->X3_USADO    ,;
						SX3->X3_TIPO     ,;
						SX3->X3_ARQUIVO  ,;
						SX3->X3_CONTEXT  })
	Endif
	
Next nIndVet

Return Nil
            
/*_______________________________________________________________________________
¦ Função    ¦ CriaCols    ¦ Autor ¦ Ulisses Junior          ¦ Data ¦ 02/05/2007 ¦
+-----------+-------------+-------+-------------------------+------+------------+
¦ Descriçäo ¦ Montagem da Matriz aCols - Linhas do Browse                       ¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
***************************************
Static Function CriaCols()
***************************************
Local nCnt     := 0
Local cVarTemp := ""

 SZ3->(dbSetOrder(1))
 SZ3->(dbSeek(xFilial("SD1")+mDoc+mSerie+mForn+mLoja))
              
 nCnt  := 0
 While !SZ3->(EOF()) .and. SZ3->(Z3_FILIAL+Z3_DOC+Z3_SERIE+Z3_FORNECE+Z3_LOJA) = SZ3->(xFilial("SZ3"))+mDoc+mSerie+mForn+mLoja

    aAdd(aRegs,SZ3->(Recno()))
	aAdd(aCols,Array(Len(aHeader)+1))

    nCnt++
	nUsado:= 0

	SX3->(dbSetOrder(2))
	
	For x:=1 To Len(aCampos)
		
		SX3->(dbSeek(aCampos[x]))
		
		If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			
			nUsado++
/*			
			If 		SX3->X3_TIPO == "C";	aCols[1][nUsado] := Space(SX3->X3_TAMANHO)
			ElseIf	SX3->X3_TIPO == "N";	aCols[1][nUsado] := 0
			ElseIf	SX3->X3_TIPO == "D";	aCols[1][nUsado] := stod("")//dDataBase
			ElseIf	SX3->X3_TIPO == "M";	aCols[1][nUsado] := CriaVar(AllTrim(SX3->X3_CAMPO))
			Else;			   				aCols[1][nUsado] := .F.
			EndIf
  			
			If SX3->X3_CONTEXT == "V"
				aCols[1][nUsado] := CriaVar(AllTrim(SX3->X3_CAMPO))
			Endif
  */			
        cVarTemp := SZ3->(SX3->X3_CAMPO)
        aCols[cCnt][nUsado] := &cVarTemp
		Endif

	Next
	
	aCols[1][nUsado+1] := .F.
 End	

Return Nil

*****************************
Static Function GravaInf()
*****************************
Private lGera := .T.

SZ3->(dbSetOrder(1))

If lGera
   If SZ3->(dbSeek(xFilial("SZ3")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEM))
      Reclock("SZ3",.F.)
   Else
      Reclock("SZ3",.T.)
   EndIf   

   SZ3->Z3_FILIAL  := xFilial("SZ3")                  //FILIAL
   SZ3->Z3_DOC     := SD1->D1_DOC                     //DOCUMENTO
   SZ3->Z3_SERIE   := SD1->D1_SERIE                   //SERIE
   SZ3->Z3_FORNECE := SD1->D1_FORNECE                 //FORNECEDOR
   SZ3->Z3_LOJA    := SD1->D1_LOJA                    //LOJA
   SZ3->Z3_ITEM    := SD1->D1_ITEM                    //ITEM DA NF
   SZ3->Z3_COD     := SD1->D1_COD                     //PRODUTO
   SZ3->Z3_QUANT   := SD1->D1_QUANT                   //QUANTIDADE
   SZ3->Z3_UM      := SD1->D1_UM                      //UNIDADE DE MEDIDA
   SZ3->Z3_VUNIT   := SD1->D1_VUNIT                   //VALOR UNITÁRIO
   SZ3->Z3_VATU    := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_PRV1")  //VALOR ATUAL
   SZ3->Z3_UCOMP   := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_UVLRC") //VALOR DA ULTIMA COMPRA
   SZ3->Z3_VCALC   := nValVend                        //VALOR CALCULADO
   SZ3->Z3_DTCALC  := ddatabase                       //DATA DO CALCULO
   SZ3->Z3_PERCOM  := nPerComis                       // % DE COMISSAO
   SZ3->Z3_PERTRAN := nPertrans                       // % TRANSPORTE (VENDA)
   SZ3->Z3_PERFIN  := nPerEncFin                      // % ENC FINANCEIROS
   SZ3->Z3_PERICM  := nPerIcms                        // % ICMS (VENDA)
   SZ3->Z3_PERIR   := nPerIr                          // % IR
   SZ3->Z3_MLUCRO  := nPerlucro                       // % MARGEM DE LUCRO
   SZ3->Z3_CREDICM := nCrdIcm                         //CREDITO DE ICMS
   SZ3->Z3_SUFRAMA := nSuframa                        //VALOR SUFRAMA
   SZ3->Z3_FRETE   := nValFrete                       //FRETE UNITÁRIO(COMPRA)
   SZ3->Z3_PISCOF  := nPisCof                         //PIS E COFINS
   
   SZ3->(MsUnLock())

   CriaHeader() 	// Montagem do aHeader (Cabeçalho do Browse)
   CriaCols()		// Montagem do aCols   (Linhas do Browse)
   GeraTela()	    // Montagem da tela com o browse
EndIf

Return

******************************
Static Function CalcPreco()
******************************
Local nRecno
Private mDoc, mSerie, mForn, mLoja

mDoc   := SF1->F1_DOC
mSerie := SF1->F1_SERIE
mForn  := SF1->F1_FORNECE
mLoja  := SF1->F1_LOJA

nMarkup   := (100-nTotal)/100

SD1->(dbSetOrder(1))

If SF1->F1_TIPO = "N"

  SD1->(dbSeek(xFilial("SD1")+mDoc+mSerie+mForn+mLoja))
  
  While !SD1->(EOF()) .and. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) = mDoc+mSerie+mForn+mLoja
  
    If SD1->D1_ORIGLAN # "FR"
       If SD1->D1_VALFRE = 0 .and. !MsgYesNo("Valor do frete zerado,Deseja realmente Continuar","Confirmação")
          lGera := .F.
          Return
       Endif
    Endif

    nCrdIcm   := If(Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_CREDICM") = "S",SD1->D1_VALICM,0)/SD1->D1_QUANT
    nCusto    := SD1->D1_CUSTO/SD1->D1_QUANT //Descontado ICMS e Despesas
    nPisCof   := (SD1->D1_VALIMP5+SD1->D1_VALIMP6)/SD1->D1_QUANT
    nValFrete := SD1->D1_VALFRE/SD1->D1_QUANT

    nSuframa  := SD1->D1_VUNIT-(nCusto+nCrdIcm)
    
    nValVend := SD1->D1_VUNIT-(nCusto+nValFrete+nPisCof)
    nValVend := nValVend/nMarkUp
      
    GravaInf()
    
    SD1->(dbSkip())
  End
ElseIf SF1->F1_TIPO = "C"

  SD1->(dbSeek(xFilial("SD1")+mDoc+mSerie+mForn+mLoja))                                        
  
  While !SD1->(EOF()) .and. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) = mDoc+mSerie+mForn+mLoja
    
    If SD1->D1_ORIGLAN # "FR"
       lGera := .F.
       Return
    Endif

    nRecno := SD1->(Recno())

    nValFrete := SD1->D1_VUNIT
    
    SF8->(dbSetOrder(1))
    SF8->(dbSeek(xFilial("SF8")+mDoc+mSerie+mForn+mLoja))
   
    xDoc   := SF8->F8_NFORIG
    xSerie := SF8->F8_SERORIG
    xForn  := SF8->F8_FORNECE
    xLoja  := SF8->F8_LOJA
    xItem  := SD1->D1_ITEM
    xProd  := SD1->D1_COD

    SD1->(dbSeek(xFilial("SD1")+xDoc+xSerie+xForn+xLoja+xCod+xItem))                                            

    nCrdIcm   += If(Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_CREDICM") = "S",SD1->D1_VALICM,0)
    nCusto    := SD1->CUSTO
    nPisCof   := (SD1->D1_VALIMP5+SD1->D1_VALIMP6)
    nValFrete += SD1->D1_VALFRE

    nCrdIcm   := nCrdIcm/SD1->D1_QUANT    
    nSuframa  := nSuframa/SD1->D1_QUANT
    nCusto    := nCusto/SD1->D1_QUANT
    nValFrete := nValFrete/SD1->D1_QUANT
    nPisCof   := nPisCof/SD1->D1_QUANT

    nSuframa  := SD1->D1_VUNIT - (nCusto+nCrdIcm)

    nValVend := SD1->D1_VUNIT-(nCusto+nValFrete+nPisCof)
    nValVend := nValVend/nMarkUp
      
    GravaInf()
    
    SD1->(dbGoTo(nRecno))
    SD1->(dbSkip())
  End

Endif

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+------------+¦¦
¦¦¦ Função    ¦ GeraTela    ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 04/05/2007 ¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Montagem da Tela de Dados da Tabela                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
***************************************
Static Function GeraTela()
***************************************
Local nOpcA := 0, nOpcx := 3

Private aRotina := {}
Private cProduto := SZ3->Z3_COD
Private cDesc    := Posicione("SB1",1,xFilial("SB1")+SZ3->Z3_COD,"B1_DESC")
Private nPVend   := SZ3->Z3_VCALC
Private nMargem  := nPerLucro
Private oProduto, oDesc, oPVend, oMargem
Private oDlg2  := Nil
Private oGet2  := Nil

aAdd( aRotina, {"Atualiza",	"U_AtuPreco",     0,1})

DEFINE MSDIALOG oDlg2 TITLE "Formacao de Preco" From 8,25 To 35,105 OF oMainWnd

@ 15, 2 TO 110,315 LABEL "Formacao de Preco " OF oDlg2 PIXEL

@ 25, 020 SAY "Produto   "       SIZE 170,7 PIXEL OF oDlg2
@ 40, 020 SAY "Descricao "       SIZE 170,7 PIXEL OF oDlg2
@ 55, 020 SAY "Preco de Venda "	 SIZE 170,7 PIXEL OF oDlg2
@ 70, 020 SAY "Margem de Lucro " SIZE 170,7 PIXEL OF oDlg2

@ 25, 070 MSGET	oProduto Var cProduto	PICTURE "@!"            Valid AtuBrowse() SIZE 025,07 PIXEL OF oDlg2 WHEN .F.
@ 40, 070 MSGET	oDesc    Var cDesc  	PICTURE "@!"            Valid AtuBrowse() SIZE 025,07 PIXEL OF oDlg2 WHEN .F.
@ 55, 070 MSGET	oPVend   Var nPVend   	PICTURE "@E 999,999.99" Valid AtuBrowse() SIZE 025,07 PIXEL OF oDlg2 WHEN .F.
@ 70, 070 MSGET	oMargem  Var nMargem  	PICTURE "@E 999.99"     Valid AtuBrowse() SIZE 025,07 PIXEL OF oDlg2 WHEN .F.

oGet2	:= MSGetDados():New(110,2,200,315,1,"U_SZ3LOk","U_SZ3TudOk",,.T.,,,,700,,,,)

ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||nOpcA:=1,Iif(U_SZ4TudOk(),oDlg2:End(),nOpcA:=0)},{||oDlg2:End()})

If nOpcA == 1

	Begin Transaction
	   AtuPreco()
	End Transaction

EndIf

Return Nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+------------+¦¦
¦¦¦ Função    ¦ SZ3LOk      ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 04/05/2007 ¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validação da Linha do Browse                                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
***************************************
User Function SZ3LOk()
***************************************
Local nIndVet

If aCols[n][nUsado+1]									// Deletado
	Return .T.
EndIf

If aCols[n][06] = 0
   IW_MsgBox("O valor de venda nao pode ser zero","Erro!!!", "STOP")
   Return .F.
EndIf

SD1->(dbSetOrder(1))
SD1->(dbSeek(xFilial("SD1")+SZ3->Z3_DOC+SZ3->Z3_SERIE+SZ3->Z3_FORNECE+SZ3->Z3_LOJA+SZ3->Z3_COD+SZ3->Z3_ITEM))

If aCols[n][06] < (SD1->D1_CUSTO/SD1->D1_QUANT)
   IW_MsgBox("O valor de venda nao pode ser menor que o custo","Erro!!!", "STOP")
   Return .F.
EndIf

 oGet2:Refresh()
 oDlg2:Refresh()

 AtuBrowse()

Return .T.


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+------------+¦¦
¦¦¦ Função    ¦ SZ3TudOk    ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 04/05/2007 ¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Validação na confirmação do Browse                            ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
***************************************
User Function SZ3TudOk()               
***************************************
Private n

For n := 1 to Len(aCols)
    lResp:= U_SZ3Lok()
    If !lResp
       Return lResp
    EndIf
Next n

Return .T.

******************************
Static Function AtuPreco()    
******************************

SB0->(dbSetOrder(1))

For nX := 1 to Len(aCols)

  If !aCols[nX][nUsado+1] 
   If SB0->(dbSeek(xFilial(xFilial("SB0")+aCols[nX][2])))
      RecLock("SB0",.F.)
        SB0->B0_PRV1 := aCols[nX][6]	// Preço Formado pela rotina
      SB0->(MsUnLock())
   Else
      RecLock("SB0",.T.)
        SB0->B0_FILIAL  := xFilial("SB0")
        SB0->B0_COD     := aCols[nX][2]  // Código do Produto
        SB0->B0_PRV1    := aCols[nX][6]  // Preço Formado pela rotina
        SB0->B0_PRV2    := 0
        SB0->B0_PRV3    := 0
        SB0->B0_PRV4    := 0
        SB0->B0_PRV5    := 0
        SB0->B0_PRV6    := 0
        SB0->B0_PRV7    := 0
        SB0->B0_PRV8    := 0
        SB0->B0_PRV9    := 0
        SB0->B0_DATA1   := AVCTOD("//")
        SB0->B0_DATA2   := AVCTOD("//")
        SB0->B0_DATA3   := AVCTOD("//")
        SB0->B0_DATA4   := AVCTOD("//")
        SB0->B0_DATA5   := AVCTOD("//")
        SB0->B0_DATA6   := AVCTOD("//")
        SB0->B0_DATA7   := AVCTOD("//")
        SB0->B0_DATA8   := AVCTOD("//")
        SB0->B0_DATA9   := AVCTOD("//")        
        SB0->B0_ALIQRED := AVCTOD("//")
      SB0->(MsUnLock())
   EndIf
  EndIf 
Next

Return