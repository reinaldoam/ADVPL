#INCLUDE "RwMake.Ch"

//
// Filtra Pedidos de vendas por vendedor
//

User Function MT410BRW()
  Local cCodUsu    := RetCodUsr()                             //- Codigo do usuario logado
  Local cNomUsu    := ALLTRIM(Upper(SubStr(cUsuario, 7, 15))) //- Nome do usuário
  Local cAutCom    := ALLTRIM(GetMv("MV_XLSTCOM"))            //- Usuario que podem visualizar todos os PV's
  Local cCodVend   := ""
  Local cSetFilter := ""
  
  cCodVend := Posicione("SA3",7,xFilial("SA3")+cCodUsu,"A3_COD")
  
  If !Empty(cCodVend) //!(cNomUsu $ cAutCom)     
     cSetFilter := "ALLTRIM(SC5->C5_VEND1) == '"+cCodVend+"'"
     SC5->(dbSetFilter( {|| &cSetFilter }, cSetFilter ))
  EndIf
Return Nil