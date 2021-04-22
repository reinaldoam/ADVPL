#include "rwmake.ch"       

User Function AGPE010
  Local cDesc:=""
  Local cCampo := ReadVar()    
  Local cUsr := Upper(GetMv("MV_XALTORC"))
            
  If !(UPPER(Trim(SubStr(cUsuario,7,15))) $ cUsr)
     If altera
        Do Case
        Case ("AB4_MEMO2" $ cCampo)  
           cDescAnt:= Alltrim(MSMM(AB4->AB4_MEMO))  
           cDescAtu:= Acols[n,7]
           If !Alltrim(Acols[n,7]) $ cDescAnt
              cDesc:= Alltrim(cDescAnt + " " + cDescAtu)
           Else
              cDesc:= cDescAnt
           Endif   
        Case ("AB4_XINFCL" $ cCampo)
           cDescAnt:= Alltrim(AB4->AB4_XINFCL)
           cDescAtu:= Acols[n,8]             
           If !Alltrim(Acols[n,8]) $ cDescAnt
              cDesc:= Alltrim(cDescAnt + " " + cDescAtu)
           Else
              cDesc:= cDescAnt
           Endif   
        EndCase                                         
     Endif   
  Else
     Do Case
     Case ("AB4_MEMO2" $ cCampo)  
        cDesc:= Acols[n,7]
     Case ("AB4_XINFCL" $ cCampo)
        cDesc:= Acols[n,8]
     EndCase                                         
  Endif   
Return(cDesc)