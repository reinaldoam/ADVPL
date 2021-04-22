#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#include "topconn.ch"

/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ Função    ¦ AGPLOJP001  ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 24/04/2007    ¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ Descriçäo ¦ Formação de preço - Criada para ser executada na entrada da nota ¦¦¦
¦¦¦           ¦ fiscal de compra via pontos de entrada GQREENTR e MT116ACGR.     ¦¦¦
¦¦+-----------+------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
/*
OBS.: SE ALGUM INFELIZ RESOLVER ALTERAR ESSE FONTE DE NOVO, FAVOR FAZER BACKUP ANTES
E COMENTAR AO LADO O MOTIVO DA ALTERAÇÃO E O NOME DO CIDADÃO QUE ESTÁ ALTERANDO, 
PORQUE EU NÃO TENHO BOLA DE CRISTAL E CANSEI DE SER PATOLOGISTA!!!
*/

********************************
User Function AGPLOJP001(xTp)
********************************
Local nOpc      := 1
Local bOk       := {|| nOpc:=1 , AGPLOJP01A()}
Local bCancel   := {|| nOpc:=0 , oDlg1:End()}

Private oDlg1     := Nil
Private oGet1     := Nil
Private xTipo     := xTp
Private nPerComis := GetMv("MV_FPCOMIS")
Private nPerTrans := GetMv("MV_FPTRANS")
Private nPerEncFin:= GetMv("MV_FPENFIN")
Private nPerIcms  := GetMv("MV_ICMPAD")
Private nPerIr    := GetMv("MV_FPPERIR")
Private nPerLucro := GetMv("MV_FPMLUCR")
Private nTotal    := nPerComis+nPerTrans+nPerEncFin+nPerIcms+nPerIr+nPerLucro
Private nMarkup   := 0
Private oPerComis ,oPerTrans ,oPerEncFin,oPerIcms,oPerIr,oPerLucro,oTotal
Private lRet := .T.
//Tela de coleta de informações das taxas a serem utilizadas na formação de preços


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

If nOpc = 0//Criado por Ulisses Jr em 30/04/08 para avaliar se o preço foi formado ou não
	lRet := .F.
EndIf

Return lRet

****************************
Static Function Atualiza()
****************************
Local lReturn := .T.

nTotal := nPerComis+nPerTrans+nPerEncFin+nPerIcms+nPerIr+nPerLucro
oTotal:Refresh()

If nTotal > 100
	MsgBox("Total não pode ser maior do que 100%","Atencao !")
	lReturn := .F.
EndIf

Return lReturn

*******************************
Static Function AGPLOJP01A()
*******************************
Private cProd	 := SD1->D1_COD
Private cDesc	 := POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD,"B1_DESC")
Private nValVend := 0 //Preço calculado
Private nSuframa := 0 //Valor Suframa
Private nValFrete:= 0 //Valor do Frete
Private nCusto   := 0 //Abatido ICMS e despesas
Private nCrdIcm  := 0 //Crédito de Icms                                                                         8
Private nPisCof  := 0 //Valor de Pis e Cofins           4               5          6               7            9
                    //   1         2         3          5               6          7               8            14             9
Private aCampos  := {"Z3_ITEM","Z3_COD","Z3_XCODFAB","Z3_DESCRI","Z3_VUNIT"      ,"Z3_UCOMP" ,"Z3_VATU"    ,"Z3_VCALC"   , "Z3_MLUCRO","Z3_DOC"   ,"Z3_SERIE","Z3_FORNECE","Z3_LOJA"}
Private aCabec	 := {"Item"   ,"Codigo","Ref.Fabrica","Descricao","Valor Unitario","Ult.Preco","Valor Atual","Valor Venda", "Margem de Lucro(%)"}
                    //   1         2         3         4               5               6          7               8             9                  10           11          12         13           14
//Private aCampos  := {"Z3_ITEM","Z3_COD","Z3_DESCRI","Z3_UM"      ,"Z3_VUNIT"      ,"Z3_UCOMP" ,"Z3_VATU"    ,"Z3_VCALC"   ,"Z3_MLUCRO"         ,"Z3_DOC"   ,"Z3_SERIE","Z3_FORNECE","Z3_LOJA", "Z3_PRCFIL"}
//Private aCabec	 := {"Item"   ,"Codigo","Descricao","Unid.Medida","Valor Unitario","Ult.Preco","Valor Atual","Valor Venda","Margem de Lucro(%)","Documento","Serie"   ,"Fornecedor","Loja", "Preco Filial"}
Private aAltera  := {}
Private aHeader  := {}
Private aCols	 := {}
Private aRegs	 := {}
Private nUsado	 := 0

oDlg1:End()

Processa({|| CalcPreco(),"Processando..."})

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

//For nIndVet := 1 To Len(aCampos)
For nIndVet := 1 To Len(aCabec) //9 campos
	
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

nUsado := Len(aCampos) //13 campos

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


//U_MsSetOrder("SZ3","Z3_FILIAL+Z3_DOC+Z3_SERIE+Z3_FORNECE+Z3_LOJA+Z3_COD+Z3_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

nCnt  := 0

For y:=1 to Len(aDoc)
DBSELECTAREA("SZ3")
SZ3->(dbSetOrder(1))   //ATIVADO CLAYSON 09/05/10
dbSeek(xFilial("SZ3")+aDoc[y][1]+aDoc[y][2]+aDoc[y][3]+aDoc[y][4],.t.)

	While !SZ3->(EOF()) .and. SZ3->(Z3_FILIAL+ALLTRIM(Z3_DOC)+ALLTRIM(Z3_SERIE)+ALLTRIM(Z3_FORNECE)+ALLTRIM(Z3_LOJA)) == xFilial("SZ3")+ALLTRIM(aDoc[y][1])+ALLTRIM(aDoc[y][2])+ALLTRIM(aDoc[y][3])+ALLTRIM(aDoc[y][4])
		
		aAdd(aRegs,SZ3->(Recno()))
		//aAdd(aCols,Array(Len(aHeader)+1))
		aAdd(aCols,Array(Len(aCampos)+1))
		nCnt++
		nUsado:= 0
		
		SX3->(dbSetOrder(2))
		
		For x:=1 To Len(aCampos)
		//For x:=1 To Len(aCabec)
			
			SX3->(dbSeek(aCampos[x]))
			
			If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
				
				nUsado++
				cVarTemp := SZ3->(SX3->X3_CAMPO)
				aCols[nCnt][nUsado] := &cVarTemp
			Endif
			
  		Next
  		//nUsado := len(aCampos)
		aCols[nCnt][nUsado+1] := .F.
		SZ3->(dbSkip())
	End
Next

//n := 1
Return Nil

*********************************
Static Function GravaInf(lPrcMtz)
*********************************
Local nDescIcms:= 0, nPrecoAtu:= 0, cRefFab:= '', nPrecoFil:= 0
                    
If lPrcMtz                  
   cRefFab   := Posicione("SB1",11,xFilial("SB1")+SD1->D1_COD,"B1_X_REFPR")  // Ref. Fabricante
   nPrecoAtu := Prc_Fil010(cRefFab)
Else        
   nPrecoAtu := Posicione("SB0",1,xFilial("SB0")+SD1->D1_COD,"B0_PRV1")  //VALOR ATUAL
Endif

If Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_AGREG") = 'D'
	nDescIcms := (SD1->D1_PICM/100)*SD1->D1_VUNIT
Else
	nDescIcms := 0
EndIf

If SM0->M0_CODIGO == "02"
   nPrecoFil:= Posicione("SB0",1,xFilial("SB0")+SD1->D1_COD,"B0_PRV1")
Else 
   nPrecoFil:= Prc_Fil020(SD1->D1_COD)
Endif   

DBSELECTAREA("SZ3")
SZ3->(dbSetOrder(1))
//U_MsSetOrder("SZ3","Z3_FILIAL+Z3_DOC+Z3_SERIE+Z3_FORNECE+Z3_LOJA+Z3_COD+Z3_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
//dbSeek(xFilial("SZ3")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEM)
//removido por clayson 09/05/2010
If dbSeek(xFilial("SZ3")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEM)
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
SZ3->Z3_XCODFAB := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_XCODFAB")  //REFERENCIA FABRICANTE
SZ3->Z3_DESCRI  := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC")  //DESCRICAO DO PRODUTO
SZ3->Z3_QUANT   := SD1->D1_QUANT                   //QUANTIDADE
SZ3->Z3_UM      := SD1->D1_UM                      //UNIDADE DE MEDIDA
SZ3->Z3_VUNIT   := SD1->D1_VUNIT-nDescIcms           //VALOR UNITÁRIO --> Alterado por Ulisses Jr em 19/03/08 para ter o valor liquido da compra
SZ3->Z3_VATU    := nPrecoAtu // Posicione("SB0",1,xFilial("SB0")+SD1->D1_COD,"B0_PRV1")  //VALOR ATUAL
SZ3->Z3_UCOMP   := SD1->D1_VUNIT-nDescIcms //Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_UPRC") //VALOR DA ULTIMA COMPRA
//Linha acima alterada a pedido da Michelle por Ulisses Jr em 19/03/08
SZ3->Z3_VCALC   := nValVend                        //VALOR CALCULADO
SZ3->Z3_CUSTO   := nCusto                          // CUSTO UNITÁRIO
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
SZ3->Z3_MARKUP  := nMarkup*100                     //Markup calculado
SZ3->Z3_DATAGER := ddatabase
SZ3->Z3_HORAGER := Time()
SZ3->Z3_PRCFIL  := nPrecoFil   	  	               //Preco q sera buscado na empresa 020 filial 01.
SZ3->(MsUnLock())

Return

******************************
Static Function CalcPreco()
******************************
Local nRecno, nQuant := 0, nPrc := 0
Private mDoc, mSerie, mForn, mLoja, mProd, mItem, lPrcMtz:= .F.
Private aDoc := {}
                         
// Colocar pergunta caso seja a filial
If SM0->M0_CODIGO == "02"                         
   lPrcMtz:= MsgYesNo("Deseja utilizar o Preco de Venda da Matriz ?")
Endif

If xTipo = "N"
	mDoc   := SF1->F1_DOC
	mSerie := SF1->F1_SERIE
	mForn  := SF1->F1_FORNECE
	mLoja  := SF1->F1_LOJA
	AADD(aDoc,{SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA})
Else
	mDoc   := SF8->F8_NFDIFRE
	mSerie := SF8->F8_SEDIFRE
	mForn  := SF8->F8_TRANSP
	mLoja  := SF8->F8_LOJTRAN
	nOrder := IndexOrd()
	nRecNo := SF8->(RecNo())
	//SF8->(DbSetOrder(3))
	U_MsSetOrder("SF8","F8_FILIAL+F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
	SF8->(DbSeek(xFilial("SF8")+mDoc+mSerie+mForn+mLoja))
	Do While !SF8->(Eof()) .And. xFilial("SF8")+mDoc+mSerie+mForn+mLoja == SF8->(F8_FILIAL+F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN)
		
		AADD(aDoc,{SF8->F8_NFORIG, SF8->F8_SERORIG, SF8->F8_FORNECE, SF8->F8_LOJA})
		SF8->(DbSkip())
		
	EndDo
	
	SF8->(DbSetOrder(nOrder))
	SF8->(DbGoto(nRecNo))
	
End

nMarkup   := (100-nTotal)/100

SD1->(dbSetOrder(1))
//U_MsSetOrder("SD1","D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

ProcRegua(SD1->(RecCount()))

If xTipo = "N"
	
	For j:=1 to Len(aDoc)
		
		SD1->(dbSeek(xFilial("SD1")+aDoc[j][1]+aDoc[j][2]+aDoc[j][3]+aDoc[j][4],.t.))
		
		While !SD1->(EOF()) .and. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) = aDoc[j][1]+aDoc[j][2]+aDoc[j][3]+aDoc[j][4]
			//Comentado a Pedido da Michele
			/*If SD1->D1_ORIGLAN # "FR"
				If SD1->D1_VALFRE = 0 .and. !MsgYesNo("Valor do frete zerado,Deseja realmente Continuar","Confirmação")
					Return
				Endif
			Endif
			*/
			IncProc()
			
			nCrdIcm   := If(Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_CREDICM") = "S",SD1->D1_VALICM,0)/SD1->D1_QUANT
			nCusto    := SD1->D1_CUSTO/SD1->D1_QUANT //Descontado ICMS e Despesas
			nPisCof   := (SD1->D1_VALIMP5+SD1->D1_VALIMP6)/SD1->D1_QUANT
			nValFrete := SD1->D1_VALFRE/SD1->D1_QUANT
			
			nSuframa  := 0//SD1->D1_VUNIT-(nCusto+nCrdIcm)
			
			nValVend := nCusto+nSuframa+nValFrete//SD1->D1_VUNIT-(nCusto+nValFrete+nPisCof)
			nValVend := nValVend/nMarkUp
			
			GravaInf(lPrcMtz)
			
			SD1->(dbSkip())
		End
	Next
ElseIf xTipo = "F"
	
	For i:=1 to Len(aDoc)
		
		SD1->(dbSeek(xFilial("SD1")+aDoc[i][1]+aDoc[i][2]+aDoc[i][3]+aDoc[i][4],.t.))
		
		While !SD1->(EOF()) .and. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) = aDoc[i][1]+aDoc[i][2]+aDoc[i][3]+aDoc[i][4]
			
			IncProc()
			
			nRecno := SD1->(Recno())
			
			nCrdIcm   := If(Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_CREDICM") = "S",SD1->D1_VALICM,0)
			nCusto    := SD1->D1_CUSTO
			nPisCof   :=(SD1->D1_VALIMP5+SD1->D1_VALIMP6)
			nValFrete := SD1->D1_VALFRE
			nQuant    := SD1->D1_QUANT
			nPrc      := SD1->D1_VUNIT
			
			mProd := SD1->D1_COD
			mItem := SD1->D1_ITEM
			
			SD1->(dbSeek(xFilial("SD1")+mDoc+mSerie+mForn+mLoja+mProd+mItem))
			
			nValFrete += SD1->D1_VUNIT
			
			nCrdIcm   := nCrdIcm/nQuant
			nSuframa  := 0//nSuframa/nQuant
			nCusto    := nCusto/nQuant
			nValFrete := nValFrete/nQuant
			nPisCof   := nPisCof/nQuant
			
			//    nSuframa  := nPrc - (nCusto+nCrdIcm)
			
			nValVend := nCusto+nSuframa+nValFrete//(nPrc++nValFrete)-nPisCof
			nValVend := nValVend/nMarkUp
			
			SD1->(dbGoTo(nRecno))
			
			GravaInf(lPrcMtz)
			
			DBSELECTAREA("SD1")
			SD1->(dbSkip())
		End
	Next
Endif

CriaHeader() 	// Montagem do aHeader (Cabeçalho do Browse)
CriaCols()		// Montagem do aCols   (Linhas do Browse)
GeraTela()	    // Montagem da tela com o browse

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
Local nOpcA := 0
Local bOk2       := {||nOpcA:=1,If(U_SZ3TudOk(),oDlg2:End(),nOpcA:=0)}
Local bCancel2   := {||nOpcA:=0,If(Cancela(),oDlg2:End(),oDlg2:End())}
Private aRotina := {}
Private cProduto := cProd    //clayson 03-04-10 //aCols[n][2]
Private cDesc    := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC")
Private nPVend   := aCols[1][8] // aCols[1][7] -> Reinaldo em 28.07.17
Private nPVendFil:= aCols[1][8]
Private nMargem  := nPerLucro
Private oProduto, oDesc, oPVend, oMargem, oPVendFil
Private oDoc    , oSerie,oForn , oLoja
Private oDlg2  := Nil
Private oGet2  := Nil

aAdd( aRotina, {"Pesquisar" ,"AxPesqui"  ,     0,1})
aAdd( aRotina, {"Visualizar","AxVisual"  ,     0,2})
aAdd( aRotina, {"AxInclui"  ,"AxInclui"  ,     0,3})
aAdd( aRotina, {"Atualiza"  ,"U_AtuPreco",     0,4})


DEFINE MSDIALOG oDlg2 TITLE "Formacao de Preco" From 8,2 To 35,105+23 OF oMainWnd
//DEFINE MSDIALOG oDlg2 TITLE "Formacao de Preco" From 8,25 To 35,105+90 OF oMainWnd

@ 15, 2 TO 110,315+90 LABEL "Formacao de Preco " OF oDlg2 PIXEL

@ 25, 020 SAY "Documento "       SIZE 100,7 PIXEL OF oDlg2
@ 40, 020 SAY "Serie "           SIZE 100,7 PIXEL OF oDlg2
@ 55, 020 SAY "Fornecedor "	     SIZE 100,7 PIXEL OF oDlg2
@ 70, 020 SAY "Loja "            SIZE 100,7 PIXEL OF oDlg2

@ 25, 120 SAY "Produto   "       SIZE 100,7 PIXEL OF oDlg2
@ 40, 120 SAY "Descricao "       SIZE 100,7 PIXEL OF oDlg2
@ 55, 120 SAY "Preco de Venda "	 SIZE 100,7 PIXEL OF oDlg2
//@ 70, 120 SAY "Margem de Lucro " SIZE 100,7 PIXEL OF oDlg2
@ 70, 120 SAY "Prc. Venda Filial " SIZE 100,7 PIXEL OF oDlg2

@ 25, 050 MSGET	oDoc     Var mDoc    	PICTURE "@!"            SIZE 050,07 PIXEL OF oDlg2 WHEN .F.
@ 40, 050 MSGET	oSerie   Var mSerie 	PICTURE "@!"            SIZE 050,07 PIXEL OF oDlg2 WHEN .F.
@ 55, 050 MSGET	oForn    Var mForn    	PICTURE "@!"            SIZE 050,07 PIXEL OF oDlg2 WHEN .F.
@ 70, 050 MSGET	oLoja    Var mLoja    	PICTURE "@!"            SIZE 050,07 PIXEL OF oDlg2 WHEN .F.

@ 25, 170 MSGET	oProduto Var cProduto	PICTURE "@!"            SIZE 070,07 PIXEL OF oDlg2 WHEN .F.
@ 40, 170 MSGET	oDesc    Var cDesc  	PICTURE "@!"            SIZE 120,07 PIXEL OF oDlg2 WHEN .F.
@ 55, 170 MSGET	oPVend   Var nPVend   	PICTURE "@E 999,999.99" SIZE 070,07 PIXEL OF oDlg2 WHEN .F.
//@ 70, 170 MSGET	oMargem  Var nMargem  	PICTURE "@E 999.99"     SIZE 070,07 PIXEL OF oDlg2 WHEN .F.
@ 70, 170 MSGET	oPVendFil  Var nPVendFil 	PICTURE "@E 999,999.99" SIZE 070,07 PIXEL OF oDlg2 WHEN .F.

oGet2 := MSGetDados():New(110,2,200,315+175,4,"U_SZ3LOk()","U_SZ3TudOk()",,.T.,,,,Len(aCols),,,,,oDlg2)
//oGet2 := MSGetDados():New(110,2,200,315+350,4,"U_SZ3LOk()","U_SZ3TudOk()",,.T.,,,,Len(aCols),,,,,oDlg2)

oGet2:oBrowse:bChange := {|| AtuBrowse(oGet2:oBrowse) }
oGet2:oBrowse:bSetGet := {|| AtuBrowse(oGet2:oBrowse) }

AtuBrowse(oGet2:oBrowse)

ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,bOk2,bCancel2)

If nOpcA == 1
	
	Begin Transaction
	AtuPreco()
	End Transaction
Else
	lRet := .F.	
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

//If aCols[n][7] = 0 -> Reinaldo em 28.07.17
If aCols[n][8] = 0
	IW_MsgBox("O valor de venda nao pode ser zero","Erro!!!", "STOP")
	Return .F.
EndIf

//SZ3->(dbSetOrder(1))
U_MsSetOrder("SZ3","Z3_FILIAL+Z3_DOC+Z3_SERIE+Z3_FORNECE+Z3_LOJA+Z3_COD+Z3_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
SZ3->(dbSeek(xFilial("SZ3")+mDoc+mSerie+mForn+mLoja+aCols[n][2]+aCols[n][1]))

//SD1->(dbSetOrder(1))
U_MsSetOrder("SD1","D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
SD1->(dbSeek(xFilial("SD1")+SZ3->Z3_DOC+SZ3->Z3_SERIE+SZ3->Z3_FORNECE+SZ3->Z3_LOJA+SZ3->Z3_COD+SZ3->Z3_ITEM))

//If aCols[n][7] < (SD1->D1_CUSTO/SD1->D1_QUANT) -> Reinaldo em 28.07.17
If aCols[n][8] < (SD1->D1_CUSTO/SD1->D1_QUANT)
	IW_MsgBox("O valor de venda nao pode ser menor que o custo","Erro!!!", "STOP")
	Return .F.
EndIf

// oGet2:Refresh()
// oDlg2:Refresh()

// AtuBrowse()

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
Local lAtuFil

//SB0->(dbSetOrder(1)) // Tabela de Preço do Loja
//DA1->(dbSetOrder(2)) // Tabela de Preço do Faturamento
//SB1->(dbSetOrder(1))
U_MsSetOrder("SB0","B0_FILIAL+B0_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
U_MsSetOrder("DA1","DA1_FILIAL+DA1_CODPRO+DA1_CODTAB+DA1_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

For nX := 1 to Len(aCols)
	If !aCols[nX][nUsado+1]
		// Preço do Sigaloja
		If SB0->(dbSeek(xFilial("SB0")+aCols[nX][2]))
			RecLock("SB0",.F.)
			SB0->B0_PRV1 := aCols[nX][8] //aCols[nX][7]	// Preço Formado pela rotina -> Reinaldo em 28.07.17
			SB0->(MsUnLock())
		Else
			RecLock("SB0",.T.)
			SB0->B0_FILIAL  := xFilial("SB0")
			SB0->B0_COD     := aCols[nX][2] // Código do Produto
			SB0->B0_PRV1    := aCols[nX][8] //aCols[nX][7]  // Preço Formado pela rotina -> Reinaldo em 28.07.17
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
			SB0->B0_ALIQRED := 0
			SB0->(MsUnLock())
		EndIf
		// Preço do Faturamento
		If DA1->(dbSeek(xFilial("DA1")+aCols[nX][2]))
			RecLock("DA1",.F.)
			DA1->DA1_PRCVEN := aCols[nX][8] //aCols[nX][7]	Preço Formado pela rotina -> Reinaldo em 28.07.17
			DA1->(MsUnLock())
		Else
			cItem := VerUltimo("DA1_ITEM","DA1")
			/*
			If Asc(Left(cItem,1)) >= 48 .and. Asc(Left(cItem,1)) <= 57
				If Val(cItem) < 9999
					cItem := strzero(Val(cItem)+1,4)
				EndIf
			Else
				nAscii := Asc(Left(cItem,1))
				If (Val(substr(cItem,2,len(cItem)))+1) > 999
					nAscii++
					cItem := chr(nAscii)+"000"
				Else
					cItem := chr(nAscii)+StrZero((Val(substr(cItem,2,len(cItem)))+1),3)
				EndIf
			EndIf
			  */
			cItem := Soma1(cItem,4)//Utilizado por Ulisses Jr em 30/04/08 em substituíção ao trecho comentado acima
			
			RecLock("DA1",.T.)
			DA1->DA1_FILIAL  := xFilial("DA1")
			DA1->DA1_ITEM    := cItem
			DA1->DA1_CODTAB  := "001"
			DA1->DA1_CODPRO  := aCols[nX][2]  // Código do Produto
			DA1->DA1_PRCVEN  := aCols[nX][8] // aCols[nX][7]  // Preço Formado pela rotina -> Reinaldo
			DA1->DA1_ATIVO   := "1"
			DA1->DA1_TPOPER  := "4"
			DA1->DA1_QTDLOT  := 999999.99
			DA1->DA1_MOEDA   := 1
			DA1->(MsUnLock())
		EndIf
		
		If SB1->(dbSeek(xFilial("SB1")+aCols[nX][2]))
			RecLock("SB1",.F.)
			SB1->B1_PRV1 := aCols[nX][8] //aCols[nX][7] -> Reinaldo
			SB1->(MsUnLock())
		EndIf
	Else
		nRecno := Recno()
		SZ3->(dbSeek(xFilial("SZ3")+mDoc+mSerie+mForn+mLoja+aCols[nX][2]+aCols[nX][1]))
		RecLock("SZ3")
		SZ3->(dbDelete())
		SZ3->(MsUnlock())
		SZ3->(dbGoTo(nRecno))
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve atualizar tambem a filial  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lAtuFil:= MsgYesNo("Deseja atualizar o preço da filial ?")
SB1->(dbCloseArea())
SB0->(dbCloseArea())
DA1->(dbCloseArea())
                    
dbSelectArea("SB1")
dbSelectArea("SB0")
dbSelectArea("DA1")

If lAtuFil 
   For nX := 1 to Len(aCols)
      If !aCols[nX][nUsado+1]        
         Grv_PrcFilial(aCols[nX][2])
      Endif
   Next
Endif
Return

***********************************
Static Function AtuBrowse(oGet2)
***********************************
Local vVar   := {}

cProduto := aCols[oGet2:nAt][2]
cDesc    := Posicione("SB1",1,xFilial("SB1")+aCols[oGet2:nAt][2],"B1_DESC")
//nPVend   := aCols[oGet2:nAt][7] -> Reinaldo
//nPVendFil:= aCols[oGet2:nAt][8] -> Reinaldo
nPVend   := aCols[oGet2:nAt][8]
nPVendFil:= aCols[oGet2:nAt][8]

//nMargem  := aCols[oGet2:nAt][8]

oProduto:Refresh()
oDesc:Refresh()
oPVend:Refresh()
oPVendFil:Refresh()
//oMargem:Refresh()

AAdd( vVar , "Z3_VCALC" )
AAdd( vVar , "Z3_MLUCRO" )
oGet2:aAlter := vVar
oGet2:oMother:aAlter := vVar
Return

***********************************
Static Function Cancela()
***********************************
Local cSql := ""

cSql := "UPDATE "+RetSqlName("SZ3")+" SET D_E_L_E_T_ = '*' WHERE Z3_FILIAL = '"+xFilial("SZ3")+"' AND "
cSql += "Z3_DOC = '"+mDoc+"' AND Z3_SERIE = '"+mSerie+"' AND "
cSql += "Z3_FORNECE = '"+mForn+"' AND Z3_LOJA = '"+mLoja+"'"

TcSqlExec(cSql)

Return .T.

******************************************
Static Function VerUltimo(cCampo,cTabela)
******************************************
Local cSql := "", cValor := ""

cSql := "SELECT MAX("+cCampo+") as CAMPO FROM "+RetSqlName(cTabela)+" WHERE D_E_L_E_T_ <> '*'"
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cSql)), "Wrk", .T., .F. )

cValor := Wrk->CAMPO
Wrk->(dbCloseArea())

Return cValor


/////////////////////////////////////
Static Function Grv_PrcFilial(cRefer)
  Local cQry    := ""
  Local cCodigo := "" 
  Local nPreco  := 0.00
  
  Local cArea := getArea()
  Local lAchou:= .F. 
  
  cQry := "SELECT * FROM SB1020 WHERE D_E_L_E_T_=' ' AND B1_FILIAL = '"+xFilial("SB1")+"' AND "     
  cQry += "B1_X_REFPR = '"+cRefer+"' " 
  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"XXX",.T.,.T.)
  dbSelectArea("XXX")

  If !XXX->(Eof())
     cCodigo:= XXX->B1_COD //- Recupera o codigo interno do produto
  Endif                
  XXX->(dbCloseArea())
  
  If !Empty(cCodigo)
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Atualiza preco do controle de lojas  ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                         
     
     cQry := " UPDATE SB1020 SET B1_PRV1 = A.B1_PRV1 "
	    cQry += " FROM SB1010 A, SB1020 B "
	    cQry += " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' "
	    cQry += " AND A.B1_COD = B.B1_X_REFPR "
	    cQry += " AND B.B1_COD = '"+ALLTRIM(cCodigo)+"' "
	 TCSQLExec(cQry)
	    
     cQry := " SELECT * FROM SB0020 WHERE D_E_L_E_T_ <> '*' AND B0_COD = '"+ALLTRIM(cCodigo)+"' "		
			
     dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
     dbSelectArea("TRAB")
     If !TRAB->(EOF())
        lAchou := .T. 
     Endif
     TRAB->(dbCloseArea())

     If lAchou 
     	cQry := " UPDATE SB0020 SET B0_PRV1 = C.B0_PRV1 "
	    cQry += " FROM SB1010 A, SB1020 B, SB0010 C, SB0020 D "
	    cQry += " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND C.D_E_L_E_T_ <> '*' AND D.D_E_L_E_T_ <> '*' "
	    cQry += " AND A.B1_COD = C.B0_COD "
	    cQry += " AND B.B1_COD = D.B0_COD "
	    cQry += " AND A.B1_COD = B.B1_X_REFPR "
	    cQry += " AND B.B1_COD = '"+ALLTRIM(cCodigo)+"' "
     Else 
     	cQry := " INSERT INTO SB0020 (B0_FILIAL, B0_COD, B0_PRV1, R_E_C_N_O_)  "
	    cQry += " SELECT C.B0_FILIAL, B.B1_COD, C.B0_PRV1, (SELECT MAX(R_E_C_N_O_)+1 NREC FROM SB0020) R_E_C_N_O_   "
	    cQry += " FROM SB1010 A, SB1020 B, SB0010 C "
	    cQry += " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND C.D_E_L_E_T_ <> '*' "
	    cQry += " AND A.B1_COD = C.B0_COD "
	    cQry += " AND A.B1_COD = B.B1_X_REFPR "
	    cQry += " AND B.B0_COD = '"+ALLTRIM(cCodigo)+"' "
     Endif	
     TCSQLExec(cQry)

     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Atualiza preco do faturamento ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     lAchou:= .F.
     
     cQry := " SELECT * FROM DA1020 WHERE D_E_L_E_T_ <> '*' "		
     cQry += " AND DA1_CODPRO = '"+ALLTRIM(cCodigo)+"' "		
			
     dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
     dbSelectArea("TRAB")
     If !TRAB->(EOF())
        lAchou := .T. 
     Endif
     TRAB->(dbCloseArea())
		
     If lAchou 
     	cQry := " UPDATE DA1020 SET DA1_PRCVEN = C.DA1_PRCVEN "
	    cQry += " FROM SB1010 A, SB1020 B, DA1010 C, DA1020 D "
	    cQry += " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND C.D_E_L_E_T_ <> '*' AND D.D_E_L_E_T_ <> '*' "
	    cQry += " AND A.B1_COD = C.DA1_CODPRO "
	    cQry += " AND B.B1_COD = D.DA1_CODPRO "
	    cQry += " AND A.B1_COD = B.B1_X_REFPR "
	    cQry += " AND B.B1_COD = '"+ALLTRIM(cCodigo)+"' "
     Else
 	    cQry := " INSERT INTO DA1020 (DA1_FILIAL, DA1_CODPRO, DA1_PRCVEN, DA1_CODTAB, DA1_ATIVO, DA1_TPOPER, DA1_QTDLOT, DA1_MOEDA, R_E_C_N_O_, DA1_ITEM )  "
 	    cQry += " SELECT C.DA1_FILIAL, B.B1_COD, C.DA1_PRCVEN,'001' DA1_CODTAB, '1' DA1_ATIVO,'4' DA1_TPOPER,999999.99 DA1_QTDLOT,'1' DA1_MOEDA, "
 	    cQry += " (SELECT MAX(R_E_C_N_O_)+1 NREC FROM DA1020) R_E_C_N_O_, (SELECT MAX(R_E_C_N_O_)+1 NREC FROM DA1020) DA1_ITEM "
 	    cQry += " FROM SB1010 A, SB1020 B, DA1010 C "
 	    cQry += " WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND C.D_E_L_E_T_ <> '*' "
 	    cQry += " AND A.B1_COD = C.DA1_CODPRO "
 	    cQry += " AND A.B1_COD = B.B1_X_REFPR "
	    cQry += " AND B.B1_COD = '"+ALLTRIM(cCodigo)+"' "		
     Endif	
     TCSQLExec(cQry)
  Endif  	
  RestArea(cArea)
Return

*********************************************************************************************************************************************

Static Function Prc_Fil020(CodProd)
  Local lRet := 0
  Local cQry    := ""
   
  Local cArea := getArea()
  Local lAchou:= .F. 
  
  cQry := " SELECT B1_COD, B0_PRV1 " 
  cQry += " FROM SB1020 A, SB0020 B " 
  cQry += " WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_=' '
  cQry += " AND B1_FILIAL = B0_FILIAL "     
  cQry += " AND B1_COD = B0_COD "     
  cQry += " AND B1_FILIAL = '01'"     
  cQry += " AND B1_X_REFPR = '"+CodProd+"' " 
  
  dbUseArea (.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMPX",.T.,.T.)
  dbSelectArea("TMPX")

  If !TMPX->(Eof())
     lRet := TMPX->B0_PRV1//- Recupera o codigo interno do produto
  Endif                
  TMPX->(dbCloseArea())
  
  RestArea(cArea)

return lRet
                      
////////////////////////////////////
Static Function Prc_Fil010(CodProd)
  Local lRet := 0
  Local cQry    := ""
   
  Local cArea := getArea()
  Local lAchou:= .F. 
  
  cQry := " SELECT B1_COD, B0_PRV1 " 
  cQry += " FROM SB1010 A, SB0010 B " 
  cQry += " WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_=' '
  cQry += " AND B1_FILIAL = B0_FILIAL "     
  cQry += " AND B1_COD = B0_COD "     
  cQry += " AND B1_FILIAL = '01'"     
  cQry += " AND B1_COD = '"+CodProd+"' " 
  
  dbUseArea (.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMPX",.T.,.T.)
  dbSelectArea("TMPX")

  If !TMPX->(Eof())
     lRet := TMPX->B0_PRV1//- Recupera o codigo interno do produto
  Endif                
  TMPX->(dbCloseArea())
  
  RestArea(cArea)

return lRet