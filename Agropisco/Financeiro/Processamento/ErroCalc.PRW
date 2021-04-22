#Include "Protheus.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ErroCalc   ¦ Autor ¦ Reinaldo Magalhães   ¦ Data ¦ 17/06/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Lançamentos de Erro de Calculo                                ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦                                                                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
 ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function ErroCalc(lExibe)
   Local cVar, oDlg, oLbx, x, i, j
   Local nOpcA     := 0
   Local nValParc  := 0
   Local nValBase  := 0
   Local nDel      := Len(aCols[1])
   Local nPTot     := Ascan(aHeader,{|x| Trim(x[2]) == "C6_VALOR" })
   Local nMoedaCor := 1
   Local nParcelas := 0
   Local nResto    := 0
   Local cSimbCheq := AllTrim(MVCHEQUE)
   Local cForma    := GetMv("MV_FORMPAD")
   Local cForma1   := " "
   Local cForma2   := " " 
   Local aPgto     := {}
   Local aParcelas := {}
   Local nLimSuper := 0
   Local nLimInfer := 0
   Local nPVen     := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_VENCTO"  })
   Local nPVal     := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_VALOR"   })
   Local nPFor     := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_FORMAPG" })
   Local nPDes     := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_DESCFOR" })
   Local nPRat     := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_RATFOR"  })
   
   Private aHeader 	:= {}
   Private aCols   	:= {}
   Private vCampos   := { "L2_ITEM", "L2_PRODUTO", "L2_DESCRI", "L2_QUANT", "L2_XCONFER"}
  
   // Monta os aCols
   MontaaCols()




   If Type("a_Cols") == "U"  // Caso a variável não exista, cria a mesma
      Public a_Cols := {}
   Endif

   If Len(a_Cols) > 0 .And. a_Cols[1,5] <> M->C5_CONDPAG  // Se mudou a condição de pagamento, zera vetor
      a_Cols := {}
   Endif

   lExibe := If( lExibe == Nil , .T., lExibe)  // Define se exibe a tela de alteração

   //SE4->(dbSetOrder(1))
   U_MsSetOrder("SE4","E4_FILIAL+E4_CODIGO")//Incluido por Ulisses Jr em 24/04/08 em substituição as linhas acima
   SE4->(dbSeek(XFILIAL("SE4")+M->C5_CONDPAG))

   aEval( aCols  , {|x| nValBase += If( (!Inclui .And. !Altera) .Or. !x[nDel] , x[nPTot], 0) })
   aEval( a_Cols , {|x| nValParc += x[2] })

   If nValBase <> nValParc  // Caso o valor esteja diferente do anterior, refaz parcelas
      aPgto := Condicao(nValBase,M->C5_CONDPAG,0,M->C5_EMISSAO)
   Else
      // Preenche o vetor de parcelas caso nada tenha sido alterado
      For x:=1 To Len(a_Cols)
         AAdd( aParcelas , { a_Cols[x,1], a_Cols[x,2], a_Cols[x,3], a_Cols[x,4]})
      Next
   Endif

   If Len(aPgto) > 0 .Or. Len(aParcelas) > 0
      If Len(aPgto) > 0
         nLimSuper := SE4->E4_SUPER
         nLimInfer := SE4->E4_INFER
         If nValBase > nLimSuper .And. nLimSuper <> 0
            Help(" ","1","LJLIMSUPER")
            Return
         ElseIf nValBase < nLimInfer .And. nLimInfer <> 0
            Help(" ","1","LJLIMINFER")
            Return
         Endif

         cForma1 := cForma
         If Empty(SE4->E4_FORMA)
            If nMoedaCor > 1 .And. IsMoney(cForma1)
               cForma1 := SuperGetMv("MV_SIMB"+Str(nMoedaCor,1))
            Endif
            If IsMoney(cForma)
              cForma2 := cSimbCheq
            Else
               cForma2 := cForma
            Endif
         Else
            cForma1 := AllTrim(SE4->E4_FORMA)

            SAE->(dbGoTop())
            While !SAE->(Eof())
               If AllTrim(SAE->AE_TIPO) == SubStr(AllTrim(SE4->E4_FORMA),1,2)
                  cForma1 := SubStr(AllTrim(SE4->E4_FORMA),1,2)
                  Exit
               Endif
               SAE->(dbSkip())
            Enddo
            cForma2 := cForma1
         Endif
         cForma := cForma1

         For x:=1 To Len(aPgto)
            AAdd( aParcelas , { aPgto[x,1], aPgto[x,2], If(x==1,cForma1,cForma2), nMoedaCor})
         Next

         If Empty(SE4->E4_FORMA) .And. Len(aPgto) > 1
            Help(" ","1","LJSEMFORMA")
            Return
         Endif

         For x:=1 To Len(aParcelas)
            If aParcelas[x,1] > dDataBase
               If IsMoney(aParcelas[x,3])
                  aParcelas[x,3] := If( Empty(SE4->E4_FORMA) , cSimbCheq, AllTrim(SE4->E4_FORMA))
               ElseIf Empty(SE4->E4_FORMA) .Or. IsMoney(SE4->E4_FORMA)
                  aParcelas[x,3] := cSimbCheq
               Else
                  aParcelas[x,3] := SE4->E4_FORMA
               Endif
            ElseIf aParcelas[x,3] == "FI"
               aParcelas[x,3] := AllTrim(SuperGetMv("MV_SIMB1"))
            Endif
         Next
      Endif

      //+-------------------------------------------------+
      //| Monta a tela para o usuario visualizar consulta |
      //+-------------------------------------------------+
      If lExibe
         DEFINE MSDIALOG oDlg TITLE "Parcelas" FROM 8,0 TO 250,500 PIXEL
         oDlg:nStyle := nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_VISIBLE )

         @ 020,010 LISTBOX oLbx VAR cVar FIELDS HEADER "Data",;
                                                       "Valor",;
                                                       "Form.Pgto.",;
                                                       "Moeda" SIZE 230,088 OF oDlg PIXEL ;
                   ON dblClick( MudaParc(oLbx:nAt,@aParcelas,cSimbCheq),oLbx:Refresh(.F.) )
         oLbx:SetArray( aParcelas )
         oLbx:bLine := {|| { aParcelas[oLbx:nAt,1],;
                             Transform(aParcelas[oLbx:nAt,2],"@E 999,999,999.99"),;
                             aParcelas[oLbx:nAt,3],;
                             aParcelas[oLbx:nAt,4]}}

         ACTIVATE MSDIALOG oDlg CENTERED ON INIT;
                                EnchoiceBar(oDlg,{|| nOpcA:=1,oDlg:End() }, {||oDlg:End()} )
      Else
         nOpcA := 1   // Se não exibir, finaliza rotina como confirmado
      Endif

      If nOpcA == 1   // Caso tenha sido confirmado a inclusao
         a_Cols   := {}
         aColsFor := {}
         For x:=1 To Len(aParcelas)
            AAdd( a_Cols , {aParcelas[x,1], aParcelas[x,2], aParcelas[x,3], aParcelas[x,4], M->C5_CONDPAG})

            AAdd( aColsFor , Array(Len(aHeadFor)+1) )
            nTam := Len(aColsFor)
            aColsFor[nTam,nPVen] := aParcelas[x,1]
            aColsFor[nTam,nPVal] := aParcelas[x,2]
            aColsFor[nTam,nPFor] := aParcelas[x,3]
            aColsFor[nTam,nPDes] := Posicione("SX5",1,XFILIAL("SX5")+"24"+aParcelas[x,3],"X5_DESCRI")
            aColsFor[nTam,nPRat] := 0
            aColsFor[nTam,Len(aHeadFor)+1] := .F.
         Next
      Endif
   Else
      Help(" ",1,"RECNO")
   Endif

Return

Static Function MudaParc(nPos,aParcelas,cSimbCheq)
   Local oPar, oValor, oCombo, oFont, oCheck, nLin
   Local dData   := aParcelas[nPos,1]
   Local nValor  := aParcelas[nPos,2]
   Local lCheck  := AllTrim(aParcelas[nPos,3]) $ SuperGetMv("MV_PRXPARC")
   Local cCombo  := Space(20)
   Local aItens  := {}
   Local aMatriz := {}
   Local nOpc    := 0
   Local cFilSX5 := XFILIAL("SX5")
   Local cFilSAE := XFILIAL("SAE")

   SX5->(dbSetOrder(1))
   SX5->(dbSeek(cFilSX5+"24",.T.))
   While !SX5->(Eof()) .And. cFilSX5+"24" == SX5->(X5_FILIAL+X5_TABELA)
      //SAE->(dbSetOrder(1))
      U_MsSetOrder("SAE","AE_FILIAL+AE_COD")//Incluido por Ulisses Jr em 24/04/08 em substituição as linhas acima
      SAE->(dbSeek(cFilSAE,.T.))
      If AllTrim(SX5->X5_CHAVE) == GetMv("MV_SIMB1") .Or. AllTrim(SX5->X5_CHAVE) == cSimbCheq
         AAdd( aItens , { Capital(AllTrim(X5Descri())), AllTrim(SX5->X5_CHAVE)})
      Else
         While SAE->(!Eof()) .And. cFilSAE == SAE->AE_FILIAL
            If AllTrim(SX5->X5_CHAVE) == AllTrim(SAE->AE_TIPO)
               AAdd( aItens , { Capital(AllTrim(X5Descri())), AllTrim(SX5->X5_CHAVE)})
               Exit
            Endif
            SAE->(dbSkip())
         Enddo
      Endif
      SX5->(dbSkip())
   Enddo

   aEval( aItens , {|x| AAdd( aMatriz , x[1] ) } )
   
   If (nLin := Ascan(aItens,{|x| x[2] == Trim(aParcelas[nPos,3]) })) > 0
      cCombo := aItens[nLin,1]
   Endif

   DEFINE MSDIALOG oPar FROM 12,20 TO 25,61 TITLE "Forma de Pagamento"
   oPar:nStyle := nOr(DS_MODALFRAME, WS_DLGFRAME)

   DEFINE FONT oFont NAME "Arial" SIZE 5,15
   @ 0.3,1 TO 7,18.9 OF oPar

   @ 2.0,2.0 SAY "Data"
   @ 2.0,7.5 MSGET dData RIGHT Picture "99/99/99" SIZE 55,08 Valid dData >= dDataBase

   @ 3.0,2.0 SAY "Valor"
   @ 3.0,7.5 MSGET oValor VAR nValor RIGHT SIZE 55,08 Picture "@E 999,999,999.99" READONLY

   @ 4.0,2.0 SAY "Forma"
   @ 4.0,7.5 MSCOMBOBOX oCombo VAR cCombo ITEMS aMatriz /*ON CHANGE*/ OF oPar SIZE 75,55

   @ 64,16 CHECKBOX oCheck VAR lCheck PROMPT "&Utiliza nas próximas parcelas" SIZE 100,8 FONT oFont OF oPar

   DEFINE SBUTTON FROM 076,090.0 TYPE 1 ACTION (nOpc:=1,oPar:End()) ENABLE OF oPar
   DEFINE SBUTTON FROM 076,119.1 TYPE 2 ACTION (nOpc:=0,oPar:End()) ENABLE OF oPar

   ACTIVATE MSDIALOG oPar CENTERED

   If nOpc == 1
      nLin := Ascan(aItens,{|x| Trim(x[1]) == Trim(cCombo) })

      aParcelas[nPos,1] := dData
      aParcelas[nPos,3] := aItens[nLin,2]

      If lCheck
         For x:=nPos+1 To Len(aParcelas)
            aParcelas[x,3] := aItens[nLin,2]
         Next
      Endif
   Endif

Return

//////////////////////////
Static Function MontaaCols
  Local nCols, nUsado, nX

  //Monta o aHeader
  CriaHeader()

  // Monta o aCols com os dados referentes a tabela de comissão
  nCols  := 0
  nUsado := Len(aHeader)

  If !lNovo
	dbSelectArea(cAlias2)
	If cAlias2 == "SL2"
		//L2_FILIAL + L2_NUM
		dbSetOrder(1)
		dbSeek(SL1->(L1_FILIAL+L1_NUM))
		
		
		While !(cAlias2)->(Eof()) .and. SL2->(L2_FILIAL+L2_NUM) == SL1->(L1_FILIAL+L1_NUM)
			
			aAdd(aCols,Array(nUsado+1))
			nCols ++
			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V")
					aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
				Else
					aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
				Endif
			Next nX
			aCols[nCols][nUsado+1] := .F.
			
			AAdd( aAltera , Recno() )
			(cAlias2)->(dbSkip())
		Enddo
	Else
		//PA1_FILIAL + PA1_NUM
		dbSetOrder(1)
		dbSeek(PA0->(PA0_FILIAL+PA0_NUM))
		
		
		While !(cAlias2)->(Eof()) .and. PA1->(PA1_FILIAL+PA1_NUM) == PA0->(PA0_FILIAL+PA0_NUM)
			
			aAdd(aCols,Array(nUsado+1))
			nCols ++
			For nX := 1 To nUsado
				If ( aHeader[nX][10] != "V")
					aCols[nCols][nX] := FieldGet(FieldPos(aHeader[nX][2]))
				Else
					aCols[nCols][nX] := CriaVar(aHeader[nX][2],.T.)
				Endif
			Next nX
			aCols[nCols][nUsado+1] := .F.
			
			AAdd( aAltera , Recno() )
			(cAlias2)->(dbSkip())
		Enddo	
	EndIf	
EndIf
  
////////////////////////////
Static Function CriaHeader()
  SX3->(dbSetOrder(2))

  For x:=1 To Len(vCampos)
     If SX3->(dbSeek(vCampos[x]))
		If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			
			aAdd(aHeader,{ Trim(X3Titulo()), ;
			SX3->X3_CAMPO   , ;
			SX3->X3_PICTURE , ;
			SX3->X3_TAMANHO , ;
			SX3->X3_DECIMAL , ;
			SX3->X3_VALID	, ;
			SX3->X3_USADO   , ;
			SX3->X3_TIPO    , ;
			SX3->X3_ARQUIVO , ;
			SX3->X3_CONTEXT } )
		Endif
	Endif
Next
Return
