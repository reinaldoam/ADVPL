#include "rwmake.ch"

User Function SD1100E()
/*
Local cSql := ""
Local cValor := Str(Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_PRV1"),15,4)

SB0->(dbSetOrder(1))
SB1->(dbSetOrder(1))
SZ3->(dbSetOrder(1))

If !SZ3->(dbSeek(xFilial("SZ3")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+SD1->D1_ITEM))
	Return
EndIf


If Type("lPerg") # "L"
	Public lPerg := MsgYesNo("Deseja atualizar item a item?")
EndIf

If !lPerg .or. MsgYesNo("Deseja atualizar preco do produto "+SD1->D1_COD+" R$ "+cValor+" ?")
	cSql := "SELECT D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD FROM "+RetSqlName("SD1")+" WHERE D_E_L_E_T_ <> '*' AND "
	cSql += "D1_COD = '"+SD1->D1_COD+"' ORDER BY D1_EMISSAO DESC"
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cSql)), "Wrk", .T., .F. )
	Wrk->(dbGoTop())
	
	If Wrk->D1_DOC # SD1->D1_DOC .or. Wrk->D1_SERIE # SD1->D1_SERIE .or. Wrk->D1_FORNECE # SD1->D1_FORNECE .or. Wrk->D1_LOJA # SD1->D1_LOJA
		MsgBox("O preco do produto "+SD1->D1_COD+", R$"+cValor+" nao pode ser atualizado, pois esta nao e a ultima nota para o mesmo!")
		Wrk->(dbCloseArea())
		Return
	EndIf

	Wrk->(dbCloseArea())

	SB0->(dbSeek(xFilial("SB0")+SD1->D1_COD))
	SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
	
	If SZ3->Z3_COD = SB0->B0_COD
		RecLock("SB0",.F.)
		SB0->B0_PRV1 := SZ3->Z3_VATU
		SB0->(MsUnlock())
	EndIf
	
	If SZ3->Z3_COD = SB1->B1_COD
		RecLock("SB1",.F.)
		SB1->B1_PRV1 := SZ3->Z3_VATU
		SB1->(MsUnlock())
	EndIf
	
    
EndIf
  */
Return