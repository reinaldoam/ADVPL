#INCLUDE "RwMake.Ch"

//
// Filtra Orçamento de vendas por vendedor
//

User Function MT415BRW()
  Local cCodUsu    := RetCodUsr() //- Codigo do usuario logado
  Local cCodVend   := ""
  Local cSetFilter := ""
  
  cCodVend := Posicione("SA3",7,xFilial("SA3")+cCodUsu,"A3_COD")
  
  If !Empty(cCodVend)
     cSetFilter := "ALLTRIM(SCJ->CJ_VEND1) = '"+cCodVend+"'"
  EndIf
Return cSetFilter