#Include "rwmake.ch"

User Function AT400COR
  Local aCores := PARAMIXB
  aAdd(aCores, { "AB3->SRVGRT='1'", "BR_AZUL" })
Return aCores