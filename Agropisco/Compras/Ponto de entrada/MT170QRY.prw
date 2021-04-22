#include "rwmake.ch"
 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT170QRY ³ Autor ³ Reinaldo Magalhães    ³ Data ³ 14/09/17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE para gerar SC por fornecedor                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ AGROPISCO                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MT170QRY                               
  Local cQuery:= PARAMIXB[1]
  Local cFor1:= Space(6),cFor2:= Space(6),lExec:= .F.

  DEFINE MSDIALOG oDlg TITLE "Filtro por Fornecedor" FROM 45,00 TO 220,300 PIXEL
    
     @ 30,001 SAY "Do Fornecedor:"
     @ 30,040 GET cFor1 SIZE 50,20 PICTURE "@!" OBJECT oNat1 F3 "SA2"

     @ 45,001 SAY "Ate Fornecedor:"
     @ 45,040 GET cFor2 SIZE 50,20 PICTURE "@!" OBJECT oNat2 F3 "SA2"

     DEFINE SBUTTON oBtn1 FROM 65,65 TYPE 1 ACTION (lExec := .T.,oDlg:End()) ENABLE

  ACTIVATE MSDIALOG oDlg CENTERED

  If lExec                     
     If !Empty(cFor1) .And. !Empty(cFor2)
        cQuery += "AND SB1.B1_PROC >='" + cFor1 + "' AND SB1.B1_PROC <= '"+cFor2+"' "
     Endif
  Endif
Return cQuery   