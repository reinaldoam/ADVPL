#Include 'Protheus.ch'
#Include 'Topconn.ch'

//*************************************************
// Funcao para abertura do Caixa e                *
// Processamento do Fundo de troco                *
// o arquivo de Dialog chama-se NewDlg1() e esta  *
// na pasta de fontes.                            *
//*************************************************

User Function ABRCX1()

Private _cCaixa		:= Posicione("SA6",2,XFILIAL("SA6")+USRRETNAME(RETCODUSR()),'A6_COD')
Private _cNome		:= Posicione("SA6",1,XFILIAL("SA6")+_cCaixa,'A6_NOME')
Private nVtroco		:= 0
Private oDlg,oSay1,oGet3,oSay4,oGet5,oSay6,oGet7,oSBtn12,oSBtn13,oBmp14

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Abertura do Caixa"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 381
oDlg:nHeight := 295
oDlg:lShowHint := .F.
oDlg:lCentered := .T.

oSay1 := TSAY():Create(oDlg)
oSay1:cName := "oSay1"
oSay1:cCaption := "Caixa:"
oSay1:nLeft := 30
oSay1:nTop := 25
oSay1:nWidth := 65
oSay1:nHeight := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oGet3 := TGET():Create(oDlg)
oGet3:cName := "oGet3"
oGet3:cCaption := "oGet3"
oGet3:nLeft := 105
oGet3:nTop := 25
oGet3:nWidth := 121
oGet3:nHeight := 21
oGet3:lShowHint := .F.
oGet3:lReadOnly := .F.
oGet3:Align := 0
oGet3:cVariable := "_cCaixa"
oGet3:bSetGet := {|u| If(PCount()>0,_cCaixa:=u,_cCaixa) }
oGet3:lVisibleControl := .T.
oGet3:lPassword := .F.
oGet3:lHasButton := .F.
oGet3:bWhen := {|| .F. }

      
oSay4 := TSAY():Create(oDlg)
oSay4:cName := "oSay4"
oSay4:cCaption := "Nome:"
oSay4:nLeft := 32
oSay4:nTop := 60
oSay4:nWidth := 65
oSay4:nHeight := 17
oSay4:lShowHint := .F.
oSay4:lReadOnly := .F.
oSay4:Align := 0
oSay4:lVisibleControl := .T.
oSay4:lWordWrap := .F.
oSay4:lTransparent := .F.

oGet5 := TGET():Create(oDlg)
oGet5:cName := "oGet5"
oGet5:cCaption := "oGet5"
oGet5:nLeft := 104
oGet5:nTop := 56
oGet5:nWidth := 121
oGet5:nHeight := 21
oGet5:lShowHint := .F.
oGet5:lReadOnly := .F.
oGet5:Align := 0
oGet5:cVariable := "_cNome"
oGet5:bSetGet := {|u| If(PCount()>0,_cNome:=u,_cNome) }
oGet5:lVisibleControl := .T.
oGet5:lPassword := .F.
oGet5:lHasButton := .F.
oGet5:bWhen := {|| .F. }


oSay6 := TSAY():Create(oDlg)
oSay6:cName := "oSay6"
oSay6:cCaption := "Troco:"
oSay6:nLeft := 31
oSay6:nTop := 100
oSay6:nWidth := 65
oSay6:nHeight := 17
oSay6:lShowHint := .F.
oSay6:lReadOnly := .F.
oSay6:Align := 0
oSay6:lVisibleControl := .T.
oSay6:lWordWrap := .F.
oSay6:lTransparent := .F.

oGet7 := TGET():Create(oDlg)
oGet7:cName := "oGet7"
oGet7:cCaption := "oGet7"
oGet7:nLeft := 102
oGet7:nTop := 96
oGet7:nWidth := 121
oGet7:nHeight := 21
oGet7:lShowHint := .F.
oGet7:lReadOnly := .F.
oGet7:Align := 0
oGet7:cVariable := "nVtroco"
oGet7:bSetGet := {|u| If(PCount()>0,nVtroco:=u,nVtroco) }
oGet7:lVisibleControl := .T.
oGet7:lPassword := .F.
oGet7:Picture := "@E 999,999.99"
oGet7:lHasButton := .F.
oGet7:bValid := {|| Positivo() }

oSBtn12 := SBUTTON():Create(oDlg)
oSBtn12:cName := "oSBtn12"
oSBtn12:cCaption := "oSBtn12"
oSBtn12:nLeft := 75
oSBtn12:nTop := 144
oSBtn12:nWidth := 52
oSBtn12:nHeight := 22
oSBtn12:lShowHint := .F.
oSBtn12:lReadOnly := .F.
oSBtn12:Align := 0
oSBtn12:lVisibleControl := .T.
oSBtn12:nType := 1
oSBtn12:bAction := {|| Processa({|| Abertura()}) }

oSBtn13 := SBUTTON():Create(oDlg)
oSBtn13:cName := "oSBtn13"
oSBtn13:cCaption := "oSBtn13"
oSBtn13:nLeft := 172
oSBtn13:nTop := 144
oSBtn13:nWidth := 52
oSBtn13:nHeight := 22
oSBtn13:lShowHint := .F.
oSBtn13:lReadOnly := .F.
oSBtn13:Align := 0
oSBtn13:lVisibleControl := .T.
oSBtn13:nType := 2
oSBtn13:bAction := {|| oDlg:End() }

oBmp14 := TBITMAP():Create(oDlg)
oBmp14:cName := "oBmp14"
oBmp14:cCaption := "oBmp14"
oBmp14:nLeft := 36
oBmp14:nTop := 178
oBmp14:nWidth := 253
oBmp14:nHeight := 71
oBmp14:lShowHint := .F.
oBmp14:lReadOnly := .F.
oBmp14:Align := 0
oBmp14:lVisibleControl := .T.
oBmp14:cBmpFile := "lglr01.bmp"
oBmp14:lStretch := .F.
oBmp14:lAutoSize := .F.

oDlg:Activate()

Return

//************************************************
//    Funcao para abrir o caixa.                 *
//                                               *
//************************************************


Static Function Abertura()
  // Abrir tabela para alterar dados
  DbSelectArea('SA6')
  DbSetorder(1)
	
  //Posicionando no registro atraves dos parametros	
  If DbSeek(xFilial('SA6')+_cCaixa,.T.)
     Reclock ('SA6',.F.)
   	 Replace SA6->A6_DATAFCH with STOD('') 		//limpa campo data fechamento
	 Replace SA6->A6_HORAFCH with ''       		//limpa campo hora do fechamento
	 Replace SA6->A6_DATAABR with DDatabase		//atribui a data base ao registro corrente
	 Replace SA6->A6_HORAABR with Time()		// atribui o horario ao registro corrente
	 MsUnlock()
  Endif
  //DbSkip()
  Processa({||(ascMsgAbcx())})     
Return (.T.)
  
/////////////////////////////
Static Function ascMsgAbcx( )
Local bAcao := {|lFim| ascProc(@lFim) }
Local cTitulo := 'Atualizando Abertura de Caixa'
Local cMsg := 'Processando'
Local lAborta := .T.
Processa( bAcao, cTitulo, cMsg, lAborta )
Return

/////////////////////////////
Static Function ascProc(lFim)
  Local nI
  ProcRegua(10000)
  For nI := 1 To 10000
     If lFim
        Exit
	 EndIf
     INCPROC()
  Next nI
  Processa({||(ProcTroco())})     
Return

////////////////////////////
Static Function ProcTroco()

  Private cCxOrig		:= _cCaixa   // Substr(GetMv("MV_CXLOJA"),1,3)							// Origem do troco, caixa central
  Private cCxDest		:= _cCaixa   // Quem irá receber o troco
  Private	cAgOrig		:= Posicione ("SA6",1,xFilial("SA6")+cCxorig,'A6_AGENCIA')
  Private	cCtaOrig	:= Posicione ("SA6",1,xFilial("SA6")+cCxorig,'A6_NUMCON')
  Private	cAgDest		:= Posicione ("SA6",1,xFilial("SA6")+cCxDest,'A6_AGENCIA')
  Private	cCtaDest	:= Posicione ("SA6",1,xFilial("SA6")+cCxDest,'A6_NUMCON')

  DbSelectArea("SE5")        

/*
  //Processando Pagamento
  Reclock("SE5",.T.)
  E5_FILIAL	:=	xFilial("SE5")
  E5_DATA		:=	DDataBase
  E5_MOEDA	:= 	'TC'
  E5_VALOR	:=	nVTroco
  E5_NATUREZ	:= 	'TROCO     '
  E5_BANCO	:=	cCxOrig
  E5_AGENCIA	:=	cAgOrig
  E5_CONTA	:= 	cCtaOrig
  E5_RECPAG	:=	'P'
  E5_HISTOR	:=	'TROCO PARA O CAIXA' + ' ' + cCxDest
  E5_TIPODOC	:=	'TR'
  E5_DTDIGIT	:=	DDataBase
  E5_SEQ		:= '01'
  E5_DTDISPO	:=	DDataBase
  MsUnlock()
*/ 

  //Processando Recebimento
  Reclock("SE5",.T.)
  E5_FILIAL	:=	xFilial("SE5")
  E5_DATA		:=	DDataBase
  E5_MOEDA	:= 	'TC'
  E5_VALOR	:=	nVTroco
  E5_NATUREZ	:= 	'TROCO     '
  E5_BANCO	:=	cCxDest
  E5_AGENCIA	:=	cAgDest
  E5_CONTA	:= 	cCtaDest
  E5_RECPAG	:=	'R'
  E5_HISTOR	:=	'TROCO PARA O CAIXA' + ' ' + cCxDest
  E5_TIPODOC	:=	'TR'
  E5_DTDIGIT	:=	DDataBase
  E5_SEQ		:= '01'
  E5_DTDISPO	:=	DDataBase
	    
  MsUnlock()

  oDlg:End()
Return