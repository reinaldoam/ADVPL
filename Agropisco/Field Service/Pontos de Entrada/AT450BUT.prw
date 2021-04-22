#Include "rwmake.ch"

User Function AT450BU2()

aBotao := {} 
AAdd( aBotao, { "Num. PV", { || u_MostraPV() }, "Mostra PV" } ) 

Return( aBotao )