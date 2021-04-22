#Include "rwmake.ch"

User Function AjustaAB3()
  Processa({|| RunProc() },"Processando...")
Return()

/////////////////////////
Static Function RunProc()

  //- Orçamentos
  DbSelectArea("AB3")
  DbSetOrder(1)
                
  //- Apontamentos
  DbSelectArea("AB8")
  DbSetOrder(1)
                  
  //- OS
  DbSelectArea("AB6")
  DbSetOrder(1)

  ProcRegua(RecCount())

  AB6->(DBGOTOP())
  
  Do While !AB6->(Eof())
     
     IncProc()
     
     If AB8->(DbSeek(xFilial("AB8")+AB6->AB6_NumOs)) // Sub-Itens da OS
	 
	    Do While !AB8->(Eof()) .And. AB6->AB6_NumOs == AB8->AB8_NumOs      
	       
	       If !Empty(AB8->AB8_NUMPV)
	          
	          If AB3->(DbSeek(xFilial("AB3")+Left(AB6->AB6_NUMORC,6)))
   	             //-- Gravando status como A ara permitir alterar a OS
	             Reclock("AB3",.F.)
	             AB3->AB3_STATUS:='E'
                 AB3->(MsUnlock())
              Endif
	       Endif
	       AB8->(DbSkip())
	    Enddo   
	 Endif  
	 AB6->(DbSkip())
  Enddo	 
Return