#include "Protheus.ch"
/*
   Desenvolvedor: Márcio Macedo
   Data.........: 21/07/10
   Objetivo.....: Verifica a existência de referencias duplicadas (B1_XCODFAB)
   *************************************************************************************************************************************
   ** Alterações * Favor Adicionar Todas as Alteração Realizadas ***********************************************************************
   *************************************************************************************************************************************
   |Data			 | Programador				| Alteração
	*************************************************************************************************************************************
   |                |                          |
   ************************************************************************************************************************************
*/
USER Function A010TOK
  Local lRet:= .T.    
  Local nRecno,nOrdem
  nRecno := SB1->(Recno())
  nOrd   := SB1->(IndexOrd())
  
  //- Cadastro de Produtos
  //SB1->(DbSetOrder(9))
  U_MsSetOrder("SB1","B1_FILIAL+B1_XCODFAB+B1_PROC")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
  
  //If SB1->(DbSeek(xFilial("SB1")+M->B1_XCODFAB+M->B1_PROC)) .And. inclui  => Retirado validação da marca conforme solicitado pela Michelle em 17.07.17
  If SB1->(DbSeek(xFilial("SB1")+M->B1_XCODFAB)) .And. inclui
     Msginfo("Referência já cadastrada.", "Aviso")     
     lRet:= .F.
  Endif       
  If BscReferencia() > 0 .And. Altera
     Msginfo("Referência já cadastrada.", "Aviso")     
     lRet:= .F.
  Endif
  SB1->(DbGoto(nRecno))
  SB1->(DbSetOrder(nOrd))
Return lRet
               
/////////////////////////////
Static Function BscReferencia
  Local cQuery,nConta:=0
  Local c_Area:= Alias() 
	 
  cQuery := "SELECT COUNT(*) CONTA FROM "+RetSQLName("SB1")
  cQuery += " WHERE D_E_L_E_T_<>'*' AND "
  cQuery += "B1_FILIAL='" + xFilial("SB1") + "' AND "
  cQuery += "B1_XCODFAB='" + M->B1_XCODFAB + "' AND "
  cQuery += "B1_COD <> '" + M->B1_COD + "'"
     
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
    
  nConta:= TMP->CONTA

  TMP->(dbCloseArea())
  
  DbSelectArea(c_Area)
  
return nConta
  
///////////////////////
User Function NextProd
  Local cQuery 
  Local c_Area:= Alias() 
	 
  cQuery:= "SELECT MAX(B1_COD) ITEM FROM "+RetSQLName("SB1")+" WHERE D_E_L_E_T_<>'*' AND "
  cQuery+= "B1_FILIAL='" + xFilial("SB1") + "'"
     
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
    
  If EMPTY(TMP->ITEM)
     cMaxItem := "000001"
  Else
     cMaxItem := StrZero(Val(TMP->ITEM)+1,6)
  Endif
  TMP->(dbCloseArea())
  
  DbSelectArea(c_Area)
  
return cMaxItem