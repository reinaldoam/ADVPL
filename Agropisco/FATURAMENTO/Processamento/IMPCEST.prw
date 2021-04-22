#Include "rwmake.ch"
                     
//
// Esta rotina tem por objetivo popular as tabelas F0G e SYP 
//

User Function IMPCEST()
  Processa({|| RunProc() },"Processando...")
Return

/////////////////////////
Static Function RunProc()
  Local nChave := 72449
  Local nSeq   := 0

  //- Tabela CEST
  DbSelectArea("F0G")
  DbSetOrder(1)

  //- Campos MEMO
  DbSelectArea("SYP")
  DbSetOrder(1)

  DBUseArea( .T.,"dbfcdxads", "\data\CEST_MEMO","TMP",.T., .F. )

  ProcRegua(RecCount())

  TMP->(DBGOTOP())

  Do while !TMP->(Eof())
   
     If !F0G->(DbSeek(xFilial("F0G")+TMP->N1))
        nChave++
        RecLock("F0G",.T.)
        F0G_FILIAL := xFilial("F0G")
        F0G_CEST   := Alltrim(TMP->N1)
        F0G_DESCRI := TMP->N2
        F0G_DESCR2 := Strzero(nChave,6)
        MsUnlock()
               
        nSeq:= 0
      
        // Texto memo parte 01
        If !Empty(TMP->N2)   
           nSeq++
           RecLock("SYP",.T.)
           YP_FILIAL:= xFilial("SYP")
		   YP_CHAVE := Strzero(nChave,6)
           YP_SEQ   := StrZero(nSeq,3)
           YP_TEXTO := TMP->N2
           YP_CAMPO := 'F0G_DESCR2'
           MsUnlock()      
        Endif

        // Texto memo parte 02
        If !Empty(TMP->N3)   
           nSeq++
           RecLock("SYP",.T.)
           YP_FILIAL:= xFilial("SYP")
		   YP_CHAVE := Strzero(nChave,6)
           YP_SEQ   := StrZero(nSeq,3)
           YP_TEXTO := TMP->N3
           YP_CAMPO := 'F0G_DESCR2'
           MsUnlock()      
        Endif

        // texto memo parte 03
        If !Empty(TMP->N4)   
           nSeq++
           RecLock("SYP",.T.)
           YP_FILIAL:= xFilial("SYP")
		   YP_CHAVE := Strzero(nChave,6)
           YP_SEQ   := StrZero(nSeq,3)
           YP_TEXTO := TMP->N4
           YP_CAMPO := 'F0G_DESCR2'
           MsUnlock()      
        Endif
                       
        // texto memo parte 04
        If !Empty(TMP->N5)   
           nSeq++
           RecLock("SYP",.T.)
           YP_FILIAL:= xFilial("SYP")
		   YP_CHAVE := Strzero(nChave,6)
           YP_SEQ   := StrZero(nSeq,3)
           YP_TEXTO := TMP->N5
           YP_CAMPO := 'F0G_DESCR2'
           MsUnlock()      
        Endif
                            
        // texto memo parte 05
        If !Empty(TMP->N6)   
           nSeq++
           RecLock("SYP",.T.)
           YP_FILIAL:= xFilial("SYP")
		   YP_CHAVE := Strzero(nChave,6)
           YP_SEQ   := StrZero(nSeq,3)
           YP_TEXTO := TMP->N6
           YP_CAMPO := 'F0G_DESCR2'
           MsUnlock()      
        Endif

        // texto memo parte 06
        If !Empty(TMP->N7)   
           nSeq++
           RecLock("SYP",.T.)
           YP_FILIAL:= xFilial("SYP")
		   YP_CHAVE := Strzero(nChave,6)
           YP_SEQ   := StrZero(nSeq,3)
           YP_TEXTO := TMP->N7
           YP_CAMPO := 'F0G_DESCR2'
           MsUnlock()      
        Endif

        // texto memo parte 07
        If !Empty(TMP->N8)   
           nSeq++
           RecLock("SYP",.T.)
           YP_FILIAL:= xFilial("SYP")
		   YP_CHAVE := Strzero(nChave,6)
           YP_SEQ   := StrZero(nSeq,3)
           YP_TEXTO := TMP->N8
           YP_CAMPO := 'F0G_DESCR2'
           MsUnlock()      
        Endif                 
     Endif   
     TMP->(DbSkip())
  Enddo   
  TMP->(DbCloseArea())
Return