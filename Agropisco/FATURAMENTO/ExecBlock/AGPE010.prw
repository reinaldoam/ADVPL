#include "rwmake.ch"

//
// ExecBlock para validar os dados do cliente.
//

User Function AGPE010(xCodCli)
  Local lRet:= .T.   
  Local cCliPad := getmv("MV_CLIPAD")
                 
  If xCodCli <> cCliPad
     If Len(Alltrim(SA1->A1_TEL)) < 8   
        MsgInfo("O telefone deve ter no minimo 8 caracteres.","Aten��o")
        lRet:= .F.
     Endif
     If Len(Alltrim(SA1->A1_TELEX)) < 8
        MsgInfo("O celular deve ter no minimo 9 caracteres.","Aten��o")
        lRet:= .F.
     Endif
     If Len(Alltrim(SA1->A1_CONTATO)) < 8
        MsgInfo("O contato deve ter no minimo 8 caracteres.","Aten��o")                     
        lRet:= .F.
     Endif
     If Len(Alltrim(SA1->A1_EMAIL)) < 10
        MsgInfo("O email deve ter no minimo 10 caracteres.","Aten��o")
        lRet:= .F.
     Endif
  Endif
  If !lRet            
     xCodCli:= Space(6)
  Endif
Return xCodCli