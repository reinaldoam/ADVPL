#include "rwmake.ch"      

User Function ExeVerEst(pQuant)

// Mostra o Saldo em Estoque no Pedido de Venda.
cAlias := Alias()

DbSelectArea("SB2")
//DbSetOrder(1)
U_MsSetOrder("SB2","B2_FILIAL+B2_COD+B2_LOCAL")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

DbSelectArea("SL2")

DbSelectArea("SF4")
//DbSetOrder(1)
U_MsSetOrder("SF4","F4_FILIAL+F4_CODIGO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

pProduto  := Ascan(aHeader,{|x|x[2] == "AB5_CODPRO"})
pVlrUnit  := Ascan(aHeader,{|x|x[2] == "AB5_VUNIT"})
pTotal    := Ascan(aHeader,{|x|x[2] == "AB5_TOTAL"})
//pQuant    := Ascan(aHeader,{|x|x[2] == "AB5_QUANT"})
//pLocal  := Ascan(aHeader,{|x|x[2] == "C6_LOCAL"})
pTes      := "S" //Ascan(aHeader,{|x|x[2] == "C6_TES    "})
pDel      := Len(Acols[N])                              
iRet      := .T. 
cRotina   := FUNNAME()                                                        
//SF4->(DbSeek(xFilial()+Acols[N][pTes]))
                                                          	
If SB2->(DbSeek(xFilial("SB2")+Acols[N][pProduto]+"01"))
	If (SB2->B2_QAtu-(SB2->B2_QPedven+SB2->B2_QEMP+SB2->B2_RESERVA)) < pQuant
		Alert("Saldo disponivel para venda "+Transform(SB2->B2_QATU-(SB2->B2_QPEDVEN+SB2->B2_QEMP+SB2->B2_RESERVA),"@R 999,999,999.99"))
		If cRotina ="TECA400"
			iRet := .T.
		Else
			iRet := .F.
		EndIf
	EndIf
Else
	Alert("Saldo disponivel para venda "+Str(0))
	iRet      := .T.
EndIf
pQuant:=0
cProd := Acols[N][pProduto]
dbSelectArea(cAlias)
Return(iRet)