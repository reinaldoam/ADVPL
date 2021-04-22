#INCLUDE "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  AGRO005   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 02/05/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Retorna o Status do Ordem de Serviço                           ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
//MONTA O CÓDGIO DO PRODUTO
User Function AGRO005(cNumOrc)
//Salva a área do SX7
Local cStatus := "" 

cAlias := Alias()
dbSelectArea("AB7")
//dbSetOrder(1)      
//AB4_FILIAL, AB4_NUMORC, AB4_ITEM
U_MsSetOrder("AB7","AB7_FILIAL+AB7_NUMOS+AB7_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
AB7->(dbSeek(xFilial("AB7")+cNumOrc+"01"))

If AB7->AB7_TIPO =="1"
	cStatus := "ORDEM SERV."
ElseIf AB7->AB7_TIPO =="2"
	cStatus := "Pedido Gerado"
ElseIf AB7->AB7_TIPO =="3"
	cStatus := "Em Atendimento"
ElseIf AB7->AB7_TIPO =="4"
	cStatus := "Atendido"
ElseIf AB7->AB7_TIPO =="5"
	cStatus := "Encerrado"
EndIf

dbSelectArea(cAlias)

Return(cStatus)
