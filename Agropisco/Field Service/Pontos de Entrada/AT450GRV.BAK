#Include "rwmake.ch"

User Function AT450GRV()

// Mostra o Numero do PV
cNome := FunName()
If Alltrim(cNome) == "TECA450"
	
	If !Empty(AB8->AB8_NUMPV)
    	// INCLUIDO POR WERMESON EM 25/02/2008 
    	  u_fTelaVen()
    	// FIM WERMESON                     
    	
    	//- Grava local no pedido de venda  
    	LocalPV()

	    AB3->(DbSetOrder(1))
	    If AB3->(DbSeek(xFilial("AB3")+Left(AB6->AB6_NUMORC,6)))
   	       //-- Gravando status como A ara permitir alterar a OS
	       Reclock("AB3",.F.)
	       AB3->AB3_STATUS:='E'
           AB3->(MsUnlock())
        Endif
    	
		Alert("Numero do PV:"+SC5->C5_NUM)  
		
	Endif
	
	AB3->(DbSetOrder(1))
	AB3->(DbSeek(xFilial()+Left(AB6->AB6_NUMORC,6)))
	
//	RecLock("AB6")
//		AB6->AB6_NOMCLI:=SA1->A1_NOME
	AB6->AB6_OBS1   := AB3->AB3_OBS1
	AB6->AB6_OBS2   := AB3->AB3_OBS2
	AB6->AB6_OBS3   := AB3->AB3_OBS3
  //	MsUnLock()
	
EndIf

Return
          

User fUNCTION fTelaVen() //mt120ok()

   Local cAlias   := Alias()
   Local nOpcA    := 0
   Local oDlg     := Nil
   Local oMainWnd := Nil
   Local oFontCou := TFont():New("Courier New",9,15,.T.,.F.,5,.T.,5,.F.,.F.)
  
   Private cVend1 := space(06)
   Private cVend2 := space(06)
   
   Private oVend1 := nil
   Private oVend2 := nil 
   
   
   Private cNVend1 := space(06)
   Private cNVend2 := space(06)
   
   Private oNVend1 := nil
   Private oNVend2 := nil
   
   Private cChave    := "" 
   Private cNum      := SC5->C5_NUM     
   
   if INCLUI
      cVend2 := space(06)
      cVend1 := space(06)
    Elseif ALTERA
      cVend1 := SC5->C5_VEND1
      cVend2 := SC5->C5_VEND2          

   Endif

   DEFINE MSDIALOG oDlg TITLE "Complemento do Pedido de Vendas - " + Alltrim(SC5->C5_NUM) From 9,0 TO 25,68 OF oMainWnd
   oDlg:lEscClose := .F.

    //     @ 040,006 SAY "Vendedor 1: "   PIXEL OF oDlg 
      //   @ 040,056 GET oVend1       VAR cVend1  f3 SA3 Valid f_ValVend SIZE 200,10 PIXEL OF oDlg   //MEMO //WHEN !(cOpc $ "VE")
	
         //@ 060,006 SAY "Vendedor 2:"    PIXEL OF oDlg
         //@ 060,056 GET oVend2        VAR cVend2 f3 SA3  Valid f_ValVend SIZE 200,10 PIXEL OF oDlg //MEMO //WHEN !(cOpc $ "VE")
         @ 40,001 SAY "vendedor 1:"
         @ 40,040 GET cVend1 SIZE 50,20 PICTURE "@!" OBJECT oVend1 F3 "SA3" valid valVend(1)

         @ 40,120 SAY "Nome:"
         @ 40,150 GET cNVend1 SIZE 100,20 PICTURE "@!" OBJECT oNVend1 when .F.

         @ 60,001 SAY "vendedor 2:"
         @ 60,040 GET cVend2 SIZE 50,20 PICTURE "@!" OBJECT oVend2 F3 "SA3" valid valVend(2)

         @ 60,120 SAY "Nome:"
         @ 60,150 GET cNVend2 SIZE 100,20 PICTURE "@!" OBJECT oNVend2 when .F.

//	oRequisi:oFont := oFontCou
  //   oTranpor:oFont := oFontCou

   //      @ 060,002 To 204,318 PROMPT "Descricao Detalhada" PIXEL OF oDlg

        // oJustific:oFont := oFontCou
                       
  	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(FunctionOK(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})CENTERED
  // ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,;
  //                                         {|| nOpcA := If( IN030VldOk(cOpc) ,1,0), If( nOpcA==1 ,oDlg:End(),)},;
  //                                         {|| nOpcA := 0, If( IN030VldOk(cOpc) , oDlg:End(), 0)})
    //        Gravacao(cOpc)     
    
   dbSelectArea(cAlias)
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FunctionOK ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 01/02/2008 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Grava os dados de objetivo 1, obgetivo 2, requisitante e      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Descriçäo ¦ transportadora na tabela SC7 pedido de vendas                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function FunctionOK()
  Local lRet := .F.
  
  dbSelectArea("SA3")
  dbSetOrder(1)         
  
  If SA3->(dbSeek(xFilial("SA3")+cVend1))
	 dbSelectArea("SC5")
	 dbSetOrder(1)       
     SC5->(dbSeek(xFilial("SC5")+cNum))
  
	    RecLock("SC5",.F.)
	        SC5->C5_VEND1   := cVend1  
	        IF !(SA3->(dbSeek(xFilial("SA3")+cVend2)))
	            SC5->C5_COMIS1  := 0.5  //cComis1
	          Else 
	            SC5->C5_COMIS1  := 0.25  //cComis1
	            SC5->C5_VEND2   := cVend2   
	            SC5->C5_COMIS2  := 0.25
	        EndIf  
	        
	   MsUnLock()
	Else
	  msgStop("Vendedor não Cadastrado!!!")   
  EndIf
Return .T.                                                                                 


Static FuncTion valVend(nTipo)

dbSelectArea("SA3")
dbSetOrder(1)         

If nTipo == 1
  
    If !SA3->(dbSeek(xFilial("SA3")+cVend1))
      msgStop("Vendedor não cadastrado!")
      cNVend1 := ""
      Return .F.
    EndIf  
    cNVend1 := SA3->A3_NOME
  Else

    If !SA3->(dbSeek(xFilial("SA3")+cVend2)) .And. !Empty(cVend2)
      msgStop("Vendedor não cadastrado!")
      cNVend2 := ""
      Return  .F.
    EndIf
    If !Empty(cVend2)
      cNVend2 := SA3->A3_NOME
    EndIf  
EndIf
Return .T.
     
***********************
Static Function LocalPV
***********************
Local cQry := ""
Local cLocal := GetMV("MX_XLOCTEC") // '02'

cQry := " UPDATE "+RetSqlName("SC6")+" SET C6_LOCAL = '"+cLocal+"' "
cQry += " WHERE D_E_L_E_T_ <> '*' AND C6_FILIAL = '"+xFilial("SC6")+"' AND "
cQry += " C6_NUM = '"+SC5->C5_NUM+"'"
TCSQLExec(cQry)

Return .T.