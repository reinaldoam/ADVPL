#INCLUDE "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  AGRO004   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 02/05/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Retorna o Status do Orçamento                                  ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
//MONTA O CÓDGIO DO PRODUTO
User Function AGRO004(cNumOrc)
//Salva a área do SX7
Local cStatus := "" 

cAlias := Alias()
dbSelectArea("AB4")
//dbSetOrder(1)      
//AB4_FILIAL, AB4_NUMORC, AB4_ITEM
U_MsSetOrder("AB4","AB4_FILIAL+AB4_NUMORC+AB4_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
AB4->(dbSeek(xFilial("AB4")+cNumOrc+"01"))

If AB4->AB4_XTIPO =="0"
	cStatus := "ENTRADA"
ElseIf AB4->AB4_XTIPO =="1"
	cStatus := "ORCAMENTO"
ElseIf AB4->AB4_XTIPO =="2"
	cStatus := "ORDEM SERV."
ElseIf AB4->AB4_XTIPO =="3"
	cStatus := "ENCERRADO"
EndIf

dbSelectArea(cAlias)

Return(cStatus)
