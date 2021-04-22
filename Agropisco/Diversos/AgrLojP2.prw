#Include "rwmake.ch"
#Include "topconn.ch"

//+-------------------------------------------------------------------------------------------------
//| Programa..: AgrLojP2
//+-------------------------------------------------------------------------------------------------
//| Autor.....: Reinaldo Magalhaes
//+-------------------------------------------------------------------------------------------------
//| Data......: 02/10/12
//+-------------------------------------------------------------------------------------------------
//| Descricao.: Este programa irá realizar a leitura do arquivo SB0 
//|             e gravar no arquivo DA1 os itens não encontrados.
//+-------------------------------------------------------------------------------------------------

User Function AgrLojP2()
//+-------------------------------------------------------------------------------
//| Declaracoes de variaveis
//+-------------------------------------------------------------------------------
Local nOpcao  := 0
Local aSay    := {}
Local aButton := {}
Local cDesc1  := OemToAnsi("Este programa irá realizar a gravacao do preço de vendas do ")
Local cDesc2  := OemToAnsi("faturamento a partir do preço de vendas do controle de loja ")

Local cDesc3  := OemToAnsi("Confirma execucao?")
Local o       := Nil
Local oWnd    := Nil
Local cMsg    := ""

Private Titulo    := OemToAnsi("Geracao de Lista de Preços")
Private lEnd      := .F.
Private NomeProg  := "AgrLojP2"
Private lCopia    := .F.
Private cArq := Space(50)

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, Space(80))
aAdd( aSay, Space(80))
aAdd( aSay, Space(80))
aAdd( aSay, cDesc3 )

aAdd(aButton, { 1,.T.,{|o| nOpcao := 1,o:oWnd:End() } } )
aAdd(aButton, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( Titulo, aSay, aButton )

If nOpcao == 1
	Processa({|| AgrLoj2A() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return                    

Static Function AgrLoj2A()  
Local cItem     
    
dbSelectArea("SB0")

U_MsSetOrder("SB0","B0_FILIAL+B0_COD") 

ProcRegua(SB0->(LastRec()))

While !SB0->(Eof())
  
  IncProc()
                                    
  U_MsSetOrder("DA1","DA1_FILIAL+DA1_CODPRO+DA1_CODTAB+DA1_ITEM")
 
  If DA1->(dbSeek(xFilial("DA1")+SB0->B0_COD))
     RecLock("DA1",.F.)
	 DA1->DA1_PRCVEN := SB0->B0_PRV1
 	 DA1->(MsUnLock())
  Else 
     cItem := VerUltimo("DA1_ITEM","DA1")
	 cItem := Soma1(cItem,4) 
  	 
  	 RecLock("DA1",.T.)
	 DA1->DA1_FILIAL  := xFilial("DA1")
	 DA1->DA1_ITEM    := cItem
	 DA1->DA1_CODTAB  := "001"
	 DA1->DA1_CODPRO  := SB0->B0_COD
	 DA1->DA1_PRCVEN  := SB0->B0_PRV1
	 DA1->DA1_ATIVO   := "1"
	 DA1->DA1_TPOPER  := "4"
	 DA1->DA1_QTDLOT  := 999999.99
	 DA1->DA1_MOEDA   := 1
	 DA1->(MsUnLock())
  Endif
  dbselectArea("SB0")
  dbSkip()
Enddo
RETURN

//////////////////////////////////////////
Static Function VerUltimo(cCampo,cTabela)
  Local cSql := "", cValor := ""
	
  cSql := "SELECT MAX("+cCampo+") as CAMPO FROM "+RetSqlName(cTabela)+" WHERE D_E_L_E_T_ <> '*'"
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cSql)), "Wrk", .T., .F. )

  cValor := Wrk->CAMPO
  Wrk->(dbCloseArea())

Return cValor