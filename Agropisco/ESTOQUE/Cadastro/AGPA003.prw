#include "Protheus.CH"
#include "rwmake.ch"
#include "TopConn.ch"
                                                                                                                                      /*          
  Desenvolvedor: Reinaldo Magalhaes
  Data.........: 11/08/08
  Objetivo.....: Subgrupos
  *************************************************************************************************************************************
  ** Altera��es * Favor Adicionar Todas as Altera��o Realizadas ***********************************************************************
  *************************************************************************************************************************************
  |Data		 | Desenvolvedor		| Altera��o
  *************************************************************************************************************************************
  |            |                      | 

  *************************************************************************************************************************************/

User Function AGPA003

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "ZA3"

dbSelectArea("ZA3")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Subgrupos",,"u_AtuSubGrp()")

Return

****************************************************************************************

User Function AtuSubGrp()
Local cQry := ""
Local _SB1 := RetSqlName("SB1")

if ALTERA
  Begin Transaction 
	//cQry := " UPDATE "+_SB1+" SET B1_DESC = '"+ALLTRIM(M->ZA3_DESCRI)+"'+' - '+ B1_X_APLIC, B1_X_DSUBG = '"+M->ZA3_DESCRI+"' "
	//cQry += " WHERE D_E_L_E_T_ <> '*' "
	//cQry += " AND SUBSTRING(B1_COD,1,8) = '"+M->ZA3_GRUPO+M->ZA3_SUBGRP+"' "
	//TCSQLExec(cQry)
  End Transaction
Endif

Return .T.
