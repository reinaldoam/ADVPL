#Include "rwmake.ch"

User Function AT400ROT()

// Cria Botao no Orcamento
Local aRet := {}
  aAdd(aRet,{'Num. OS','U_MostraOS', 0 , 2})
  aAdd(aRet,{'Imp. Orcam.','U_RAGRO007(AB3->(RECNO()))', 0 , 2})
  aAdd(aRet,{'Orcamento Matricial','U_RAGRO008(AB3->(RECNO()))', 0 , 2})
  aAdd(aRet,{'Orc.Imp.Nao Fisc','U_SCRTECA(.F.)', 0 , 2})
Return aRet