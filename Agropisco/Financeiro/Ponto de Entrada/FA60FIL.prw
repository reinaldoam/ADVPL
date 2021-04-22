#include "rwmake.ch"

//
// P.E para filtrar os titulos por natureza financeira no momento da geracao do bordero.
//

User Function FA60FIL 
  
  Local cNat1:= Space(10),cNat2:= Space(10),lExec:= .F.,cFiltro:= ".t."              

  DEFINE MSDIALOG oDlg TITLE "Filtro por Natureza" FROM 45,00 TO 220,300 PIXEL
    
     @ 30,001 SAY "Da Natureza:"
     @ 30,040 GET cNat1 SIZE 50,20 PICTURE "@!" OBJECT oNat1 F3 "SED"

     @ 45,001 SAY "Ate Natureza:"
     @ 45,040 GET cNat2 SIZE 50,20 PICTURE "@!" OBJECT oNat2 F3 "SED"

     DEFINE SBUTTON oBtn1 FROM 65,65 TYPE 1 ACTION (lExec := .T.,oDlg:End()) ENABLE

  ACTIVATE MSDIALOG oDlg CENTERED

  If lExec                     
     If !Empty(cNat1) .Or. !Empty(cNat2)                               
        cFiltro:= "SE1->E1_NATUREZ >= '"+cNat1+"' .AND. "  
        cFiltro+= "SE1->E1_NATUREZ <= '"+cNat2+"'"
     Endif
  Endif

Return cFiltro