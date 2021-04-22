#Include "rwmake.ch"

User Function MostraPV()

// Mostra o Numero do PV
AB8->(DbSetOrder(1))
AB8->(DbSeek(xFilial()+AB6->AB6_NUMOS))

Alert("Numero do PV:"+Left(AB6->AB6_NUMPV,6))

Return
