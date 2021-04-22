#include "rwmake.ch"

//
// Ponto de entrada para validar a alteracao de orcamentos encerrados
//

USER FUNCTION AT400ALT
  Local lret:= IIF(Alltrim(AB3->AB3_STATUS) == "E", .F., .T.)
RETURN lret
