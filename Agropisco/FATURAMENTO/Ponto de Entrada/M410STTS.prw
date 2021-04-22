#Include "protheus.ch"

/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ P.E.      ¦ M410STTS    ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 16/10/2007    ¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada executado após a confirmação do pedido de venda ¦¦¦
¦¦¦           ¦ para ajustar o código da administradora na tabela SCV.           ¦¦¦
¦¦+-----------+------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
***************************
User Function M410STTS()
***************************
Local aTipos := {},aAdmin := {}
Local lCheck  := AllTrim(aColsFor[1,1]) $ SuperGetMv("MV_PRXPARC")
Local nRecnoSCV := SCV->(Recno())
Local nOrderSCV := SCV->(IndexOrd())
Local cCartao := Space(19), nOpc := 0

If Inclui .or. Altera
//	SAE->(dbSetOrder(1))
    U_MsSetOrder("SAE","AE_FILIAL+AE_COD")//Incluido por Ulisses Jr em 24/04/08 em substituição as linhas acima
	For nX:= 1 to Len(aColsFor)
		If Alltrim(aColsFor[nX][1]) $ "CC,CD"
			SAE->(dbGoTop())
			While !SAE->(Eof())
				If Alltrim(SAE->AE_TIPO) = Alltrim(aColsFor[nX][1])
					If (nPos := Ascan(aTipos,{|x| x[2] = SAE->AE_COD})) = 0
						aadd(aTipos,{Capital(Alltrim(SAE->AE_DESC)),SAE->AE_COD})
					EndIf
				EndIf
				SAE->(dbSkip())				
			End
		
			aEval( aTipos , {|x| AAdd( aAdmin , x[1] ) } )
			cCombo := aTipos[1][1]
		   
			DEFINE MSDIALOG oPar FROM 12,20 TO 28,61 TITLE "Forma de Pagamento"
			oPar:nStyle := nOr(DS_MODALFRAME, WS_DLGFRAME)

			DEFINE FONT oFont  NAME "Arial" SIZE 5,15
			DEFINE FONT oFont1 NAME "Arial" SIZE 7,13 Bold 
			
			@ 0.3,1 TO 6,18.9 OF oPar

			@ 1.0,2.0 SAY "Valor do Titulo: "+str(aColsFor[nX][4],15,2) FONT oFont1 OF oPar
			@ 2.0,2.0 SAY "Data : "+dtoc(M->C5_EMISSAO) 				FONT oFont1 OF oPar
			@ 2.0,8.0 SAY "Parcelas : "+StrZero(Len(aColsFor),2)		FONT oFont1 OF oPar
			
			@ 3.0,2.0 SAY "Numero : "
			@ 3.0,7.5 MSGET oCartao VAR cCartao RIGHT SIZE 75,08 Picture "@!" Valid !Empty(cCartao)

			@ 4.0,2.0 SAY "Administradora"
			@ 4.0,7.5 MSCOMBOBOX oCombo VAR cCombo ITEMS aAdmin /*ON CHANGE*/ OF oPar SIZE 75,55

			@ 64,16 CHECKBOX oCheck VAR lCheck PROMPT "&Utiliza nas próximas parcelas" SIZE 100,8 FONT oFont OF oPar

			DEFINE SBUTTON FROM 095,090.0 TYPE 1 ACTION (nOpc:=1,oPar:End()) ENABLE OF oPar
			DEFINE SBUTTON FROM 095,119.1 TYPE 2 ACTION (nOpc:=0,oPar:End()) ENABLE OF oPar

			ACTIVATE MSDIALOG oPar CENTERED

			If nOpc = 1
				//SCV->(dbSetOrder(1))
				U_MsSetOrder("SCV","CV_FILIAL+CV_PEDIDO+CV_FORMAPG")//Incluido por Ulisses Jr em 24/04/08 em substituição as linhas acima
				SCV->(dbSeek(xFilial("SCV")+M->C5_NUM))
				
				While !SCV->(Eof()) .and. SCV->CV_PEDIDO = M->C5_NUM
		        	If Alltrim(SCV->CV_FORMAPG) = Alltrim(aColsFor[nX][1]) .and. If(!lCheck,dtos(aColsFor[nX][3]) = dtos(SCV->CV_VENCTO),dtos(aColsFor[nX][3]) <= dtos(SCV->CV_VENCTO))
                        nPos := Ascan(aTipos,{|x| x[1] = cCombo})
						RecLock("SCV",.f.)
						SCV->CV_CODADM := aTipos[nPos][2]
						SCV->CV_NUMCART := cCartao
						SCV->(MsUnlock())
		        	EndIf
		        	SCV->(dbSkip())
		        End

		        SCV->(dbSetOrder(nOrderSCV))
		        SCV->(dbGoTo(nRecnoSCV))

			EndIf
		
		EndIf
		aTipos := {}
		aAdmin := {}
	    cCartao := Space(19)
	Next
EndIf
Return