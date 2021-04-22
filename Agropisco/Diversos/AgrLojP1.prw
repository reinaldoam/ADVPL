#Include "rwmake.ch"
#Include "topconn.ch"
//+-------------------------------------------------------------------------------------------------
//| Programa..: AgrLojP1
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 05/07/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Este programa irá realizar a leitura do arquivo referente 
//|             aos dados a serem imputados nas tabelas SB1, SB2, SB9 e SBM
//+-------------------------------------------------------------------------------------------------


User Function AgrLojP1()
//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------
Local nOpcao  := 0
Local aSay    := {}
Local aButton := {}
Local cDesc1  := OemToAnsi("Este programa irá realizar a leitura do arquivo referente ")
Local cDesc2  := OemToAnsi("aos dados a serem imputados nas tabelas SB1, SB2, SB9 e SBM")

Local cDesc3  := OemToAnsi("Confirma execucao?")
Local o       := Nil
Local oWnd    := Nil
Local cMsg    := ""

Private Titulo    := OemToAnsi("Geracao de registro de compras")
Private lEnd      := .F.
Private NomeProg  := "AgrLojP1"
Private lCopia    := .F.
//Private cPerg     := "FOX006"
Private cArq := Space(50)
Private nRadio := 1

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, Space(80))
aAdd( aSay, Space(80))
aAdd( aSay, Space(80))
aAdd( aSay, cDesc3 )

aAdd(aButton, { 5,.T.,{||  cArq := ValidPerg() } } )
aAdd(aButton, { 1,.T.,{|o| nOpcao := 1,o:oWnd:End() } } )
aAdd(aButton, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( Titulo, aSay, aButton )

If nOpcao == 1
	Processa({|| AgrLoj1A() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return                    

//+-------------------------------------------------------------------------------------------------
//| Programa..: AgrLoj1A()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 05/07/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Leitura da tabela de dados para abastecimento da base
//+-------------------------------------------------------------------------------------------------
*--------------------------*
Static Function AgrLoj1A()  
*--------------------------*
Local cTexto, lGravou := .F.
Local nAscii := 65

Use (cArq) alias Ext New
cInd:= CriaTrab(Nil,.F.)
IndRegua("Ext",cInd,"B1_FILIAL+B1_COD",,,"Selecionando registros...")
/*
SB1->(dbSetOrder(1))
SA2->(dbSetOrder(1))
SB2->(dbSetOrder(1))
SB9->(dbSetOrder(1))
*/
U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
U_MsSetOrder("SA2","A2_FILIAL+A2_COD+A2_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
U_MsSetOrder("SB2","B2_FILIAL+B2_COD+B2_LOCAL")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
U_MsSetOrder("SB9","B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
//SBM->(dbSetOrder(1))

ProcRegua(Ext->(LastRec()))

If nRadio = 1

	nItem := 0
	nControle  := 0
	While !Ext->(Eof())
		IncProc("Incluindo Produto: "+Ext->B1_COD)
	
		If !SB1->(dbSeek(Ext->B1_FILIAL+Ext->B1_COD))
			RecLock("SB1",.T.)
			SB1->B1_FILIAL  := Ext->B1_FILIAL
			SB1->B1_COD     := Ext->B1_COD
			SB1->B1_DESC    := Ext->B1_DESC
	//		SB1->B1_TIPO    := Ext->B1_TIPO
			SB1->B1_UM      := Ext->B1_UM
			SB1->B1_LOCPAD  := "01"
	//		SB1->B1_GRUPO   := Ext->B1_GRUPO
			SB1->B1_LOCAGRO := Ext->B1_LOCAGRO
	//		SB1->B1_CODBAR  := Ext->B1_CODBAR
			SB1->B1_PROC    := Ext->B1_PROC
			SB1->B1_LOJPROC := Ext->B1_LOJPROC
			SB1->B1_REFRAGR := Ext->B1_REFRAGR
			SB1->B1_REFEREN := Ext->B1_REFEREN
			SB1->B1_ESTSEG  := Ext->B1_ESTSEG
			SB1->B1_UPRC    := Ext->B1_UPRC
			SB1->B1_UCOM    := Ext->B1_UCOM
			SB1->B1_PRVFAT  := Ext->VENDFAT
			SB1->B1_LOCALIZ := "S"
			SB1->B1_FIELD   := "N"
			SB1->(MsUnlock())

			If !SA2->(dbSeek(xFilial("SA2")+Ext->B1_PROC+Ext->B1_LOJPROC))
				cTexto := "Fornecedor "+Ext->B1_PROC+" Loja "+Ext->B1_LOJPROC+" não cadastrado!"
				Grava(cTexto,,"Log")
				lGravou := .T.
			EndIf

		EndIf

		If !SB0->(dbSeek(Ext->B1_FILIAL+Ext->B1_COD))
			RecLock("SB0",.T.)
			SB0->B0_FILIAL  := Ext->B1_FILIAL
			SB0->B0_COD     := Ext->B1_COD
			SB0->B0_PRV1    := Ext->VENDFAT
			SB0->(MsUnlock())
		EndIf
	                                    
		If !DA0->(dbSeek(xFilial("DA0")+"001"))
			RecLock("DA0",.T.)
			DA0->DA0_FILIAL  := xFilial("DA0")
			DA0->DA0_CODTAB  := "001"
			DA0->DA0_DESCRI  := "TABELA001"
			DA0->DA0_DATDE   := ddatabase
			DA0->DA0_HORADE  := "00:00"
			DA0->DA0_HORATE  := "23:59"
			DA0->DA0_TPHORA  := "1"
			DA0->DA0_ATIVO   := "1"
			DA0->(MsUnlock())
		EndIf

		If !DA1->(dbSeek(xFilial("DA1")+"001"+Ext->B1_COD))

			If nItem < 9999
				cNumero := Strzero(nItem,4)
				nItem++
			Else
	      		cNumero := Chr(nAscii)+StrZero(nControle,3)

				nControle++
		
				If nControle > 999
					nAscii++
					nControle:=0
				Endif

	    	EndIf


			RecLock("DA1",.T.)
			DA1->DA1_FILIAL  := xFilial("DA1")
			DA1->DA1_ITEM    := cNumero
			DA1->DA1_CODTAB  := "001"
			DA1->DA1_CODPRO  := Ext->B1_COD
			DA1->DA1_PRCVEN  := Ext->VENDFAT
			DA1->DA1_ATIVO   := "1"
			DA1->DA1_TPOPER  := "4"
			DA1->DA1_QTDLOT  := 999999.99
	//		DA1->DA1_INDLOT  := "000000000999999.99"
			DA1->DA1_MOEDA   := 1
			DA1->(MsUnlock())

		EndIf

		nValor := (Ext->SALDO*Ext->CUSTO)
	
		If !SB2->(dbSeek(Ext->B1_FILIAL+Ext->B1_COD))
			RecLock("SB2",.T.)
			SB2->B2_FILIAL  := Ext->B1_FILIAL
			SB2->B2_COD     := Ext->B1_COD
			SB2->B2_LOCAL   := "01"
			SB2->B2_QATU    := If(Ext->SALDO < 0, 0, Ext->SALDO)
			SB2->B2_CM1     := If(Ext->CUSTO < 0, 0, Ext->CUSTO)
			SB2->B2_VATU1   := If(nValor < 0, 0, nValor)
			SB2->B2_USAI    := Ext->UVENDA
			SB2->(MsUnlock())
		EndIf

		If !SB9->(dbSeek(Ext->B1_FILIAL+Ext->B1_COD))
			RecLock("SB9",.T.)
			SB9->B9_FILIAL  := Ext->B1_FILIAL
			SB9->B9_COD     := Ext->B1_COD
			SB9->B9_LOCAL   := "01"
			SB9->B9_QINI    := If(Ext->SALDO < 0, 0, Ext->SALDO)
			SB9->B9_VINI1   := If(nValor < 0, 0, nValor)
			SB9->(MsUnlock())
		EndIf
		Ext->(dbSkip())
    
	End
Else
	While !Ext->(Eof())
		IncProc("Atualizando Produto: "+Ext->B1_COD)
		
		If SB1->(dbSeek(Ext->B1_FILIAL+Ext->B1_COD))
			Reclock("SB1",.F.)
			SB1->B1_CODBAR := Ext->B1_CODBAR
			SB1->(MsUnlock())
		EndIf
		Ext->(dbSkip())
	End
EndIf

Ferase(cInd)
Ext->(dbCloseArea())

If lGravou
	Grava(cTexto,lGravou,"Log")
EndIf

Return
 
//+-------------------------------------------------------------------------------------------------
//| Programa..: ValidPerg()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 05/07/06
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Criação de tela para realizar coleta de informação do arquivo a ser lido
//+-------------------------------------------------------------------------------------------------

***********************************
Static Function ValidPerg()
***********************************
 Local cExt := "Arquivos DBF | *.DBF"
 Local aRadio := {"Cadastros","Cod. Barras"}
 Local cAux := ""


@ 000, 000 To 310,300 Dialog oTela Title OemToAnsi("Parametros de Compras") 

 @ 010, 010 To 120,140 Title "Arquivo"
 @ 025, 025 Radio aRadio Var nRadio
 @ 100, 015 Say "Arquivo : "
 @ 100, 040 Get cArq Size 80,010 Picture "@!"
 @ 100, 120 Button "..." Size 10,10 ;
         Action If(Empty(cAux:=AllTrim(cGetFile(cExt,cExt,,,.T.,1))),;
                Nil, cArq:=Left(cAux+Space(50),50))


 @ 130, 020 BmpButton Type 01 Action If(ValidaArq(@cArq),(nOpc := 1,oTela:End()),)
 @ 130, 050 BmpButton Type 02 Action oTela:End()

 Activate Dialog oTela Centered                                                       
 
/*
@ 000, 000 To 330,350 Dialog oTela Title OemToAnsi("Parametros de Compras") 

	@ 010, 015 Say "Arquivo        : "

	@ 010, 060 Get cArq       Size 80,010 Picture "@!"
	@ 010, 140 Button "..."   Size 10,10 ;
					Action If(Empty(cAux:=AllTrim(cGetFile(cExt,cExt,,,.T.,1))),;
									Nil, cArq:=Left(cAux+Space(50),50))


	@ 030, 020 BmpButton Type 01 Action If(ValidaArq(@cArq),(nOpc := 1,oTela:End()),)
	@ 030, 060 BmpButton Type 02 Action oTela:End()

Activate Dialog oTela Centered         
 */
Return cArq

*-------------------------------*
Static Function ValidaArq(cArq)  
*-------------------------------*
   Local cAux := cArq
   Local lTem := .T.
   
	If !Empty(cAux)
	   cAux := Upper(AllTrim(cAux))
	   If !("." $ cAux)
	      cAux += ".TXT"
	      If !(lTem := File(cAux))
	           cAux := StrTran(cAux,".TXT",".DBF")
	           lTem := File(cAux)
	      Endif
	   Else
	      lTem := File(cAux)
	   Endif

	   If !lTem
	      Alert("Arquivo de Origem não existe !")
	      Return .F.
	   Endif

	   cArq := cAux
   Endif
Return .T.

	
//+-------------------------------------------------------------------------------------------------
//| Programa..: Grava()
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Ulisses Junior
//+-------------------------------------------------------------------------------------------------
//| Data......: 05/07/07
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Grava log de cadastro em arquivo texto
//+-------------------------------------------------------------------------------------------------

****************************************
Static Function Grava(cTxt,lFecha,cArq)
****************************************
Local cFileName, cTmpFile, cPath, cString := cTxt
	
cPath := "c:\"
cFileName := cPath +cArq+".txt"
cTmpFile  := cPath +cArq+".tmp"

	
If lFecha == NIL .Or. lFecha == .F.
	If !File(cTmpFile)
		fHandle:=FCREATE(cTmpFile)
	Else
		fHandle := FOPEN(cTmpFile,2)
	Endif
	cString := cTxt+CHR(13)+CHR(10)
	FSEEK(fHandle,0,2)
	FWRITE(fHandle,cString)
	FCLOSE(fHandle)
Else
	If File(cFileName)
		FErase(cFileName)
	Endif
	FRename(cTmpFile, cFileName)
	If lCopia
       MsgInfo("Foi gerado arquivo de Compras, arquivo: "+cFileName,"Informacao")
	   //MsgInfo("Processo finalizado com sucesso!","Final")
	Else
       MsgInfo("Nao ha dados a gerar para os parametros informados!","Final")
	EndIf   

Endif

Return

