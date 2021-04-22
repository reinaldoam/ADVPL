#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AGRO007  � Autor � Ener Fredes/LEANDRO� Data �  24/07/07    ���
�������������������������������������������������������������������������͹��
���Descricao � Motagem do codigo inteligente                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AGROPISCO                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AGRO0007

  Local cFiltro,cArqTMP
  Local cQry                
  Local cDesc,cSeq                                                 
  Local cCodigo := SUBSTR(M->B1_COD,1,2)

  If  cCodigo = "EQ"

	  cSeq      := ""
	  _cSB1 := RetSQLName("SB1")
	  cQry := "SELECT ISNULL(MAX(SUBSTRING(B1_COD,3,6)),'000000') SEQUEN "
	  cQry := cQry + "FROM " + _cSB1 +"  WHERE "
	  cQry := cQry + "D_E_L_E_T_<>'*' AND SUBSTRING(B1_COD,1,2) = '"+cCodigo+"'"
	  TCQUERY cQry NEW ALIAS "TMP"                                                    
	  dbSelectArea("TMP")  
	  cSeq:= StrZero(Val(TMP->SEQUEN)+1,6)
	  cCodigo+=cSeq  

	  DbselectArea("TMP")
	  dbCloseArea("TMP")
	  DbselectArea("SX7")           
	  
   EndIf
Return (cCodigo)