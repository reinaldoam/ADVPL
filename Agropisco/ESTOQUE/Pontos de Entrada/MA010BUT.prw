#include "Rwmake.ch"
/*_______________________________________________________________________________
���������������������������������������������������������������������������������
��+-----------+------------+-------+----------------------+------+------------+��
��� Fun��o    � MA010BUT   � Autor � Reinaldo M 		  � Data � 22/09/2015 ���
��+-----------+------------+-------+----------------------+------+------------+��
��� Descri��o � Ponto de entrada usado para pesquisar ultimas compras do      ���
|||           | produto          										      ���
��+-----------+---------------------------------------------------------------+��
���������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
User Function MA010BUT()
  Local aButtons := {} // bot�es a adicionar
	  AAdd(aButtons,{'Ver Notas',{| |  U_AGESTE01() }, 'Ver notas fiscais','Vernota' } )
Return (aButtons)