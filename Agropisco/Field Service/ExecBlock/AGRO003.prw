#INCLUDE "rwmake.ch"
/*_______________________________________________________________________________
���������������������������������������������������������������������������������
��+-----------+------------+-------+----------------------+------+------------+��
��� Programa  �  AGROFLD003� Autor � Williams Messa       � Data � 26/04/2007 ���
��+-----------+------------+-------+----------------------+------+------------+��
��� Descri��o � Valida Pre�o de venda na tela de Or�amento.                    ��
��+-----------+---------------------------------------------------------------+��
���������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
//MONTA O C�DGIO DO PRODUTO
User Function AGRO003()
//Salva a �rea do SX7
Local lRet := .T. 

cAlias := Alias()
dbSelectArea("SB1")
//dbSetOrder(1)
U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima                   

SB1->(dbSeek(xFilial("SB1")+aCols[N][2]+"01"))

If M->AB5_VUNIT < SB1->B1_PRV1
	lRet := .F.
	Alert("N�o � permitido um valor menor do que pre�o de venda!")
Else
	lRet := .T.
EndIf

dbSelectArea(cAlias)

Return(lRet)