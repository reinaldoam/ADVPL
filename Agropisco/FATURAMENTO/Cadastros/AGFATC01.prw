#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AGFATC01  � Autor � WERMESON GADELHA   � Data �  16/01/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de meta dos vendedores                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 8.11 agropisco                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AGFATC01()


Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZA"

dbSelectArea("SZA")
//dbSetOrder(1)
U_MsSetOrder("SZA","ZA_FILIAL+ZA_VEND+ZA_ANO")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima

AxCadastro(cString,"Cadastro de Metas dos Vendedores",cVldAlt,cVldExc)
Return
