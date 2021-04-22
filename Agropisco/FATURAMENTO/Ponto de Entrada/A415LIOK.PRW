#include "Rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ A415LIOK   ¦ Autor ¦ Reinaldo M 		  ¦ Data ¦ 01/08/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada usado para validação do Itens do Orçamento de¦¦¦
|||           | Venda.          										      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function A415LIOK()
  Local nDesc    := 0.00 
  Local lRet     := .T.
  Local mUsuario := ALLTRIM(Upper(SubStr(cUsuario, 7, 15))) 
  Local nDescMax := GetMv("MV_DESCORC")
  Local cNivel1  := ALLTRIM(GetMv("MV_DESCUS1")) // Desconto gerente
  Local cNivel2  := ALLTRIM(GetMv("MV_DESCUS2")) // Desconto diretoria    
     
  nDesc := TMP1->CK_DESCONT   
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verifica se o desconto está acima do permitido  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
  If nDesc > 0 
     If !UsrAltDesc(nDesc, nDescMax, mUsuario, cNivel1, cNivel2) 
        Alert("Usuario não autorizado a conceder descontos!")
        lRet := .F.
     Endif 
  Endif   
Return lRet
////////////////////////////////////////////////////////////////////////
Static Function UsrAltDesc(nDescV, nDescMax, mUsuario, cNivel1, cNivel2) 
  Local lret := IIF(nDescV > nDescMax .And. mUsuario $ cNivel2, .T., IIF(nDescV <= nDescMax .And. mUsuario $ cNivel1, .T., .F.))
Return lret 