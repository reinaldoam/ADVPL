#include "rwmake.ch" 

User Function AT400LGD
  Local aCores := PARAMIXB
  aAdd(aCores, {'BR_AMARELO',"B4_XTIPO='0'"})
  aAdd(aCores, {'BR_VERDE',"B4_XTIPO='1'"})
  aAdd(aCores, {'BR_CINZA',"B4_XTIPO='2'"})
  aAdd(aCores, {'BR_AZUL',"B4_XTIPO='3'"})
Return aCores