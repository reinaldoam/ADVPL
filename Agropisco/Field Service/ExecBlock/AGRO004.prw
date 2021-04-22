#INCLUDE "rwmake.ch"
/*_______________________________________________________________________________
���������������������������������������������������������������������������������
��+-----------+------------+-------+----------------------+------+------------+��
��� Programa  �  AGRO004   � Autor � Williams Messa       � Data � 02/05/2007 ���
��+-----------+------------+-------+----------------------+------+------------+��
��� Descri��o � Retorna o Status do Or�amento                                  ��
��+-----------+---------------------------------------------------------------+��
���������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
//MONTA O C�DGIO DO PRODUTO
User Function AGRO004(cNumOrc)
//Salva a �rea do SX7
Local cStatus := "" 

cAlias := Alias()
dbSelectArea("AB4")
//dbSetOrder(1)      
//AB4_FILIAL, AB4_NUMORC, AB4_ITEM
U_MsSetOrder("AB4","AB4_FILIAL+AB4_NUMORC+AB4_ITEM")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima                   
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
