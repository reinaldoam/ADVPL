#include "Protheus.ch"
/*
   Desenvolvedor: 
   Data.........: 
   Objetivo.....: Cria codigo sequencial
   *************************************************************************************************************************************
   ** Alterações * Favor Adicionar Todas as Alteração Realizadas ***********************************************************************
   *************************************************************************************************************************************
   |Data			 | Programador				| Alteração
	*************************************************************************************************************************************
   |                |                          |
   ************************************************************************************************************************************
*/
USER Function A010TOK
  If inclui 
     M->B1_COD:= TABTMP(SUBSTR(M->B1_COD,1,8))
  Endif
Return .t.

***************************************************************************************************************************************

Static Function TABTMP(c_Codigo)
  Local cQuery, cMaxItem := ""
  Local c_Area:= Alias() 
	 
  cQuery:= "SELECT MAX(B1_COD) ITEM FROM "+RetSQLName("SB1")+" WHERE D_E_L_E_T_<>'*' "
  cQuery+= "AND SUBSTRING(B1_COD,1,8) = '" + c_Codigo + "'"
     
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
    
  If EMPTY(TMP->ITEM)
     cMaxItem := c_Codigo + "0001"
  Else
     cMaxItem := StrZero(Val(TMP->ITEM)+1,12)
  Endif
  TMP->(dbCloseArea())
  
  DbSelectArea(c_Area)
  
return cMaxItem
