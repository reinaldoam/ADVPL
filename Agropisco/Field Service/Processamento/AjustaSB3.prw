#Include "rwmake.ch"

User Function AjustaSB3()
  Processa({|| RunProc() },"Processando...")
Return()

/////////////////////////
Static Function RunProc()

  DbSelectArea("AB3")
  DbSetOrder(1)

  DbSelectArea("AB8")
  DbSetOrder(1)
  
  DbSelectArea("AB6")
  DbSetOrder(1)

  ProcRegua(RecCount())

  AB6->(DBGOTOP())
  
  Do While !AB6->(Eof())
     IncProc()
     If AB8->(DbSeek(xFilial()+AB6->AB6_NumOs)) // Sub-Itens da OS
	    Do While !AB8->(Eof()) .And. AB6->AB6_NumOs == AB8->AB8_NumOs
	       
	       AB8->(DbSkip())
	    Enddo   
	 Endif  
	 AB6->(DbSkip())
  Enddo	 
Return