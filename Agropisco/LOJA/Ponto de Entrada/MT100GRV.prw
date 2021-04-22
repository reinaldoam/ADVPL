#Include "rwmake.ch"

/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ Função    ¦ MT100GRV    ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 03/07/2007    ¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ Descriçäo ¦ Formação de preço - Ponto de entrada criado para realizae a      ¦¦¦
¦¦¦           ¦ manutenção do preço na exclusão da nota caso seja necessário.    ¦¦¦
¦¦+-----------+------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MT100GRV()

Local lPerg, cSql := ""
Local cValor := ""

If !Inclui .and. !Altera
	If !MsgYesNo("Ajusta valor dos produtos?")
		Return
	EndIf
	
	If SF1->F1_TIPO = "C" .and. SF1->F1_ORIGLAN = "F"
		SF8->(dbSetOrder(3))
		SF8->(dbSeek(xFilial("SF8")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	
		mDoc   := SF8->F8_NFORIG
		mSerie := SF8->F8_SERORIG
		mForn  := SF8->F8_FORNECE
		mLoja  := SF8->F8_LOJA

    Else

		mDoc   := SF1->F1_DOC
		mSerie := SF1->F1_SERIE
		mForn  := SF1->F1_FORNECE
		mLoja  := SF1->F1_LOJA

    EndIf
    
    //DA1->(dbSetOrder(2))
	//SB0->(dbSetOrder(1))
	//SB1->(dbSetOrder(1))
	//SD1->(dbSetOrder(1))
	//SZ3->(dbSetOrder(1))
	U_MsSetOrder("DA1","DA1_FILIAL+DA1_CODPRO+DA1_CODTAB+DA1_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
    U_MsSetOrder("SB0","B0_FILIAL+B0_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
    U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
    U_MsSetOrder("SD1","D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
    U_MsSetOrder("SZ3","Z3_FILIAL+Z3_DOC+Z3_SERIE+Z3_FORNECE+Z3_LOJA+Z3_COD+Z3_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima

	If !SZ3->(dbSeek(xFilial("SZ3")+mDoc+mSerie+mForn+mLoja))
		Return
	EndIf


	lPerg := MsgYesNo("Deseja visualizar atualizacao item a item?")
	
	SD1->(dbSeek(xFilial("SD1")+mDoc+mSerie+mForn+mLoja))
                                                          
    While !SD1->(Eof()) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) = xFilial("SD1")+mDoc+mSerie+mForn+mLoja
	
	    cValor := Str(Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_PRV1"),15,4)
	
		If !lPerg .or. MsgYesNo("Deseja atualizar preco do produto "+Alltrim(SD1->D1_COD)+" R$ "+Alltrim(cValor)+" ?")

			cSql := "SELECT D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_EMISSAO FROM "+RetSqlName("SD1")+" WHERE D_E_L_E_T_ <> '*' AND "
			cSql += "D1_COD = '"+SD1->D1_COD+"' AND D1_TIPO = 'N' ORDER BY D1_EMISSAO DESC"
			dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cSql)), "Wrk", .T., .F. )
			Wrk->(dbGoTop())
	
			If Wrk->D1_DOC # SD1->D1_DOC .or. Wrk->D1_SERIE # SD1->D1_SERIE .or. Wrk->D1_FORNECE # SD1->D1_FORNECE .or. Wrk->D1_LOJA # SD1->D1_LOJA
				MsgBox("O preco do produto "+Alltrim(SD1->D1_COD)+", R$"+Alltrim(cValor)+" nao pode ser atualizado, pois esta nao e a ultima nota para o mesmo!")
				Wrk->(dbCloseArea())
				SD1->(dbSkip())
				Loop
			EndIf

			Wrk->(dbCloseArea())
                                                 
			SZ3->(dbSeek(xFilial("SZ3")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEM))
			DA1->(dbSeek(xFilial("DA1")+SD1->D1_COD))
			SB0->(dbSeek(xFilial("SB0")+SD1->D1_COD))
			SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
	
			If SZ3->Z3_COD = SB0->B0_COD
				RecLock("SB0",.F.)
				SB0->B0_PRV1 := SZ3->Z3_VATU
				SB0->B0_PRV2 := SZ3->Z3_VATU * 1.10 //- Reinaldo em 22.08.18
				SB0->B0_PRV3 := SZ3->Z3_VATU * 1.20 //- Reinaldo em 22.08.18
				SB0->B0_PRV4 := SZ3->Z3_VATU * 1.30 //- Reinaldo em 22.08.18
				SB0->(MsUnlock())
			EndIf
	
			If SZ3->Z3_COD = SB1->B1_COD
				RecLock("SB1",.F.)
				SB1->B1_PRV1 := SZ3->Z3_VATU
				SB1->(MsUnlock())
			EndIf
	
			If SZ3->Z3_COD = DA1->DA1_CODPRO
				RecLock("DA1",.F.)
				DA1->DA1_PRCVEN := SZ3->Z3_VATU
				DA1->(MsUnlock())
			EndIf

		    RecLock("SZ3",.F.)
		    SZ3->(dbDelete())
		    SZ3->(MsUnlock())
		EndIf
    
    	SD1->(dbSkip())
    End
EndIf

Return