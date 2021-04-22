#include "Protheus.CH"

/*_______________________________________________________________________________
���������������������������������������������������������������������������������
��+-----------+------------+-------+----------------------+------+------------+��
��� Fun��o    � A410CONS   � Autor � Ronilton O. Barros   � Data � 09/06/2006 ���
��+-----------+------------+-------+----------------------+------+------------+��
��� Descri��o � Ponto de Entrada de inclus�o de bot�es adicionais no pedido   ���
��+-----------+---------------------------------------------------------------+��
��� Fonte incluido neste projeto por Ulisses Jr em 09/10/07 para manuten��o   ���
��� das formas de pagamento pelo faturamento.                                 ���
��+-----------+---------------------------------------------------------------+��
 ���������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
User Function A410CONS()
   Local aButtons := {}
   
   AAdd( aButtons , {"LBTIK"  ,{|| u_AGFATR07(M->C5_NUM,.T.) },"Imp.Requisicao","Imp.Requisicao"} )
   //AAdd( aButtons , {"LJPRECO",{|| u_ParcFat()             },"Forma Pgto","Forma Pgto2"} )

Return(aButtons)