#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 06/04/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function RAGRO001()        // incluido pelo assistente de conversao do AP5 IDE em 06/04/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CNATUREZA,CRESP")
SetPrvt("NOMEPROG,CSTRING,CVIATRANSP,ARETURN,NLASTKEY,CPERG")
SetPrvt("WNREL,LI,PAG,NTOTGERAL,CCLIENTE,LIMPRIME")
SetPrvt("NTOTCLI,LCONTINUA,_SALIAS,AREGS,I,J")

#IFNDEF WINDOWS
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ OS       ³ Autor ³ GIAN GIOVANNI         ³ Data ³ 25.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ORDEM DE SERVICO - ASSITENCIA TECNICA                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := PADC("ORDEM DE SERVICO",74)
cDesc1    := PADC("Este programa ir  emitir uma Ordem de Servico ",74)
cDesc2    := PADC("",74)
cDesc3    := ""
cNatureza := ""
cResp     := "N"
nomeprog  := "OS    "
cString   := "AB6"
cViaTransp:= ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey  := 0
cPerg     := "OS    "
wnrel     := "OS    "
li        := 60
pag       := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da NFPARV ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg508()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,,"P")
If nLastKey == 27
	Set Filter To
	Return
Endif
SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Corpo do Programa                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("AB6") // Cab. Ordens de Servico
DbSetOrder(1)

DbSelectArea("AB7") // Itens das Ordens de Servico
DbSetOrder(1)

DbSelectArea("AB8") // Sub-Itens das Ordens de Servico
DbSetOrder(1)

DbSelectArea("AB9") // Atendimento da Ordens de Servico
DbSetOrder(1)

DbSelectArea("ABB") // Agenda Tecnica
DbSetOrder(3)

DbSelectArea("SA1") // Cad. de Clientes
DbSetOrder(1)

DbSelectArea("AA1") // Cad. de Tecnicos
DbSetOrder(1)

DbSelectArea("AA3") // Amarracao de Clientes X Equipamentos
DbSetOrder(1)

DbSelectArea("AA5") // Cad. Servicos
DbSetOrder(1)

DbSelectArea("AAG") // Cad. Ocorrencias
DbSetOrder(1)

DbSelectArea("SB1") // Cad. de Produtos
DbSetOrder(1)

lTecnico := .F.

If AB6->(DbSeek(xFilial()+mv_par01))
	
	Do While !AB6->(Eof()) .And. AB6->AB6_NumOs <= mv_par02  // Cab. OS
		
		For G:=1 to Mv_Par03
			
			If SA1->(DbSeek(xFilial()+AB6->AB6_CodCli+AB6->AB6_Loja))  // Cliente
				
				//If ABB->(DbSeek(xFilial()+AB6->AB6_NumOs)) // Agenda
					
					lTecnico := .T.
					
//			If AA1->(DbSeek(xFilial()+AB9->AB9_NUMOS+AB9->AB9_CODTEC)) // Cad. Tecnicos
						
						li   := 00
						nPag := 00
						Cabec()  // Cabecalho
						
						If AB7->(DbSeek(xFilial()+AB6->AB6_NumOs)) // Itens OS
							
							Conta    := 00
							nItem    := 01
							vServico := {}
							vOcorr   := {}
							
							Do While !AB7->(Eof()) .And. AB6->AB6_NumOs == AB7->AB7_NumOs
								
								If SB1->(DbSeek(xFilial()+AB7->AB7_CODPRO))
									// Clientes x Equipamentos
									If AA3->(DbSeek(xFilial()+AB7->AB7_CODCLI+AB7->AB7_LOJA+AB7->AB7_CODPRO+AB7->AB7_NUMSER))
										
										If AAG->(DbSeek(xFilial()+AB7->AB7_CODPRB)) // Ocorrencias
											@ li,00 PSAY nItem
											@ li,02 PSAY SB1->B1_DESC
											@ li,52 PSAY AllTrim(AB7->AB7_NUMSER)
											//@ li,75 PSAY Iif(AA3->AA3_DTGAR >= dDataBase,"Sim","Nao")
											 li++
											
											// Armazena Ocorrencias
											AADD(VOcorr,{nItem,AAG->AAG_DESCRI})
											
											// Conta o numero de itens por pagina
											Conta++
											nItem++
											If Conta >= 10
												Cabec2() // Rodape
												Conta := 0
												Cabec() // Cabecalho
											EndIf
											
										EndIf
										
									EndIf
									
								EndIf
								
								AB7->(DbSkip())
								
							EndDo
							
							If AB8->(DbSeek(xFilial()+AB6->AB6_NumOs)) // Sub-Itens da OS
								
								Do While !AB8->(Eof()) .And. AB6->AB6_NumOs == AB8->AB8_NumOs
									
									SB1->(DbSeek(xFilial()+AB8->AB8_CodPro))
									// Armazena os Servicos e Pecas
									If AllTrim(SB1->B1_TIPO) <> "MO"
										AADD(vServico,{AB8->AB8_DESPRO,AB8->AB8_QUANT,SB1->B1_LOCAGRO,AB8->AB8_CODPRO})
									EndIf
									
									AB8->(DbSkip())
									
								EndDo
								
							EndIf
							
						EndIf
				  //	EndIf
					
				//EndIf
				
			EndIf

			If lTecnico
				Cabec2()
			Else
				Alert("AGENDE UM TECNICO PARA A O.S.!!!")
			EndIf
			
		Next 
		
		AB6->(DbSkip())
		
	EndDo
	
EndIf

Set Device to Screen

If aReturn[5] == 1
	Set Printer TO
	DbcommitAll()
	Ourspool(wnrel)
Endif

MS_FLUSH()

Return



Static Function Cabec()
// Este cabecalho contem 16 linhas
nPag ++
@ li,00 PSAY PADC("AGROPISCO COM. & SERVICOS DE EQUIPAMENTOS LTDA",80); li++
@ li,00 PSAY PADC("ASSITENCIA TECNICA",80); li++
@ li,00 PSAY PADC("RUA VINCA Nro. 238 - CRESPO",80); li++
@ li,00 PSAY PADC("FONE : (92)2121-4650",80); li++
@ li,00 PSAY "EMISSAO :" +DTOC(dDataBase)
@ li,35 PSAY "PAG : " + StrZero(nPag,3)
@ li,70 PSAY TIME();li++
@ li,00 PSAY Repl("-",80); li++
@ li,00 PSAY "NUM. OS : " + AB6->AB6_NUMOS; li++
@ li,00 PSAY "CLIENTE : " + SA1->A1_COD +" - " +SA1->A1_NOME; li++
//@ li,00 PSAY "ENDERECO: " + SA1->A1_END +" - " + SA1->A1_BAIRRO ; li++
//@ li,00 PSAY "CIDADE  : " + SA1->A1_MUN
///@ li,30 PSAY "FONE    : " + SA1->A1_TEL; li++
//@ li,00 PSAY "AGENDADO: " + DTOC(ABB->ABB_DTINI)
//@ li,30 PSAY "HORA    : " + ABB->ABB_HRINI;li++
//@ li,48 PSAY "SERVICO : INTERNO( ) EXTERNO( )"; li++
//@ li,00 PSAY "TECNICO : " + AA1->AA1_CODTEC + " - " + AA1->AA1_NOMTEC; li := li + 1
//@ li,00 PSAY "CONTATO   : " +AB6->AB6	 ;li++
//@ li,00 PSAY "SERVICO AUTORIZADO POR : _____________________________________" ; li++
@ li,00 PSAY Repl("-",80); li++
//			            1         2         3         4         5         6         7         8         9        10
//            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
@ li,00 PSAY "EQUIPAMENTOS                                        SERIE                       " ; li++

Return

Static Function Cabec2()


//li++
//@ li,00 PSAY PADC("I N S T A L A C A O" ,80); li := li + 2
//@ li,00 PSAY "Instalacao realizada : Sim ( ) Nao ( ) "; li++
//@ li,00 PSAY "Motivo : ____________________________________________________________" ; li := li + 2
//@ li,00 PSAY " ____________________________________________________________________" ; li := li + 2

/*@ li,00 PSAY PADC("O C O R R E N C I A (S)" ,80); li := li + 2
For I:=1 To Len(vOcorr)
	@ li,00 PSAY vOcorr[I][1]
	@ li,03 PSAY vOcorr[I][2] ;li++
Next

@ li,00 PSAY "OBSERVACAO : ________________________________________________________"; li := li + 2
@ li,00 PSAY "_____________________________________________________________________"; li := li + 2
@ li,00 PSAY "_____________________________________________________________________"; li++*/

li++
nTotPc := 0
@ li,00 PSAY "SERVICO(S)/PECA(S)                     QUANT.     LOCALIZACAO     SEPARA?" ; li++

For I:= 1 to Len(vServico)
	//    	  	      1         2         3         4         5         6         7         8         9        10
	//       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	@ li,00 PSAY Alltrim(vServico[I][4])+"-"+Left(vServico[I][1],22) // Servico ou Pecas
	@ li,35 PSAY Transform(VServico[I][2],"@R 99,999.99")
	@ li,50 PSAY VServico[I][3]
	@ li,63 PSAY "______________"
	//@ li,67 PSAY "Sim( )Nao( )"
	 li++
//	nTotPc := nTotPc + vServico[i][4]
	
Next
//li++

//			            1         2         3         4         5         6         7         8         9        10
//            0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//@ li,00 PSAY "O servico ora executado tera a garantia de 90 dias, a partir da entrega do equipamento. A nao retirada"; li++
//@ li,00 PSAY "do equipamento acima mencionado no prazo, independente de qualquer notificacao judicial, implicara na "; li++
//@ li,00 PSAY "execucao do equipamento mencionado e seus valores revestidos em favor da Agropisco para cobrir eventuais";li++
//@ li,00 PSAY "despesas com pecas, mao-de-obra e locacao de espaco fisico"; li++
@ li,00 PSAY ""; li := li + 2

@ li,00 PSAY "Data da Entrega : ____/____/______"; li:=li+2
@ li,00 PSAY "Recebido por    : __________________________________"; li := li + 1

Return


Static Function ValidPerg508()
_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg :="OS    "
aRegs :={}
aAdd(aRegs,{cPerg,"01","Da OS                   ?", "" , "", "mv_ch1","C" ,06, 0 , 0 ,"G", "" , "MV_PAR01", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","AB6",""})
aAdd(aRegs,{cPerg,"02","Ate a OS                ?", "" , "", "mv_ch2","C" ,06, 0 , 0 ,"G", "" , "MV_PAR02", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","AB6",""})
aAdd(aRegs,{cPerg,"03","Num. de Vias            ?", "" , "", "mv_ch3","N" ,02, 0 , 0 ,"G", "" , "MV_PAR03", "",  "", "", "","","","","","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return
