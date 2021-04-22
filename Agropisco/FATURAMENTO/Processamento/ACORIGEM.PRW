
User Function AcOrigem

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

aAdd(aButton, { 1,.T.,{|o| nOpcao := 1,o:oWnd:End() } } )
aAdd(aButton, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( Titulo, aSay, aButton )

If nOpcao == 1
   Processa({|| Acertar() }, "Aguarde...", "Processando informações...", .T. )
Endif

Return                    

/////////////////////////
Static Function Acertar
  Local lSigaTec := .F.  
  Local cBusca   := SF2->F2_DOC+SF2->F2_SERIE 
  Local cForma   := GetMV("MV_OUTFORM")

  SF2->(DbSetOrder(1))
  
  SD2->(DbGotop())
  
  While !SD2->(Eof())
                          
     If SD2->D2_TP <> "MO"
        SD2->(DbSkip())
        Loop
     Endif                              
  
     cBusca:= SD2->(D2_DOC+D2_SERIE)
   
     If SF2->(DbSeek(xFilial("SF2")+cBusca)) 
        
        If !(SF2->F2_COND $ cForma)      
           Reclock("SF2",.F.)
           SF2->F2_ORIGEM:= "TEC" //- Field Service
           MsUnlock()
        Endif
           
     Endif
     SD2->(dbSkip()) 
  Enddo   
RETURN