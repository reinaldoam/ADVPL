///////////////////////////////////////////////////////
// Rotina criada por Junior em 31/08/05 para buscar, //
// através da chave, o indice correspondente no SIX  //
// e ordenar a tabela utilizada.                     //
///////////////////////////////////////////////////////

User Function MSSETORDER(cAlias, cChave)

Local nTam, nOrdem := 0

cChave := Alltrim(cChave)
nTam := Len(cChave)

SIX->(dbSetOrder(1))
SIX->(dbSeek(cAlias))

While !SIX->(Eof()) .And. SIX->Indice == cAlias
	
	If cChave == Left(SIX->Chave, nTam)
		nOrdem := If (Asc(SIX->Ordem) > 64, Asc(SIX->Ordem)-55, Val(SIX->Ordem))
		Exit        //Utiliza a tabela Asc caso ordem acima de 9
	EndIf
	
	SIX->(dbSkip())
	
End

(cAlias)->(dbSetOrder(nOrdem))

Return nOrdem
