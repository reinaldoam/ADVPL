#Include "rwmake.ch"

User Function IniEnd()

//DbSelectArea("SBF")
//DbSetOrder(1)
U_MsSetOrder("SBF","BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

Processa({|| RunProc() },"Processando...")

Return()

Static Function RunProc()

//DbSelectArea("SBE")
//DbSetOrder(1)
U_MsSetOrder("SBE","BE_FILIAL+BE_LOCAL+BE_LOCALIZ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

//DbSelectArea("SB1")
//DbSetOrder(1)
U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

//DbSelectArea("SB2")
//DbSetOrder(1)
U_MsSetOrder("SB2","B2_FILIAL+B2_COD+B2_LOCAL")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

ProcRegua(RecCount())

cNumSeq:=ProxNum()

SB2->(DBGOTOP())//Percorre os saldos em estoques!!!
Do While !SB2->(Eof())
	
		//Posiciona no Cadastro de Produtos
		SB1->(DbSeek(xFilial()+SB2->B2_COD))
		//Verifica se o produto possui localização
		If SB1->B1_LOCALIZ == "S" .And. !Empty(SB1->B1_LOCAGRO)
			If SB2->B2_QATU > 0
		 		If !SBE->(DbSeek(xFilial()+SB2->B2_LOCAL+SB1->B1_LOCAGRO))		
				    RecLock("SBE",.T.)
				      BE_FILIAL  := XFILIAL()
				      BE_LOCAL   := SB2->B2_LOCAL
				      BE_LOCALIZ := SB1->B1_LOCAGRO
				    MsUnlock()
				 EndIf   
					RecLock("SDB",.T.)
					Replace DB_FILIAL   With xFilial()
					Replace DB_PRODUTO  With SB2->B2_COD
					Replace DB_LOCAL    With SB2->B2_LOCAL
					Replace DB_LOCALIZ  With SB1->B1_LOCAGRO //LOCAL AGROPISCO
					Replace DB_QUANT    With SB2->B2_QATU
					Replace DB_ORIGEM   With "SIN"
					Replace DB_DOC      With "000001"
					Replace DB_DATA     With dDataBase
					Replace DB_NUMSEQ   With cNumSeq
					Replace DB_TM       With "499"
					Replace DB_SERIE    With "SIN"
					Replace DB_SERVIC   With "499"
					Replace DB_ATIVID   With "ZZZ"
					Replace DB_HRINI    With Time()
					Replace DB_ATUEST   With "S"
					Replace DB_STATUS   With "M"
					Replace DB_ORDATIV  With "ZZ"
					Replace DB_IDOPERA  With "0000000003" 
					MsUnlock()
     				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Soma saldo em estoque por localizacao fisica (SBF)            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				    GravaSBF("SDB")
					
				EndIf
			
		EndIf
		
	
	SB2->(DbSkip())
	SB2->(IncProc())
	
EndDo

Return()
