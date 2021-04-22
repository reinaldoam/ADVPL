#include "protheus.ch"
#include "rwmake.ch"

User Function FA100ROT
  Local aRotina := aClone(PARAMIXB[1]) //- Adiciona Rotina Customizada a EnchoiceBara
  AADD( aRotina, {'Comprovante Sangria' ,'U_FA100PAG', 0 , 7 })
Return aRotina