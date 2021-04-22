#Include "rwmake.ch"

User Function MostraOS()

// Mostra o Numero da OS
//SA1->(DbSetOrder(1))
U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
SA1->(DbSeek(xFilial()+AB3->AB3_CODCLI))

//AB4->(DbSetOrder(1))
U_MsSetOrder("AB4","AB4_FILIAL+AB4_NUMORC+AB4_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
AB4->(DbSeek(xFilial()+AB3->AB3_NUMORC))

	Alert("Numero da OS:"+Left(AB4->AB4_NUMOS,6))
// Atualiza o Nome do Cliente na OS
//AB6->(DbSetOrder(1))
U_MsSetOrder("AB6","AB6_FILIAL+AB6_NUMOS")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
AB6->(DbSeek(xFilial()+Left(AB4->AB4_NUMOS,6)))

RecLock("AB6") 
   AB6->AB6_NOMCLI:=SA1->A1_NOME
   AB6->AB6_OBS1   := AB3->AB3_OBS1
   AB6->AB6_OBS2   := AB3->AB3_OBS2
   AB6->AB6_OBS3   := AB3->AB3_OBS3
MsUnLock()

Return
