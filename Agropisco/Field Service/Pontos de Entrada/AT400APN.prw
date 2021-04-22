#include "rwmake.ch"       

//- Valida apontamento
User Function AT400APN          
  Local lret := .f.
  Local cUsr := Upper(GetMv("MV_XALTORC"))
  Local nUsado:= Len(aHeaderAB5)
  If altera .And. !(UPPER(Trim(SubStr(cUsuario,7,15))) $ cUsr)
     lRet:= MSGYESNO( "Todos os itens do apontamento serão excluidos. Deseja continuar?", "Pergunta" )
     If lRet
        For i:= 1 to Len(aCols)
           aCols[i][nUsado+1]:= .T.  
        Next   
     Endif   
  Endif
Return