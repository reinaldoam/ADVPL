#INCLUDE "AvPrint.ch"    
#INCLUDE "Font.ch"
#include "Protheus.ch"
#include "RwMake.ch"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RAGRO009 ³ Autor ³ Reinaldo Magalhães     ³ Data ³ 09.04.18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de separação de peças em impressora não fiscal TH ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RAGRO009
  Local oReport

  Private cPerg:= "OS    "
 
  //ValidPerg508()
  Pergunte(cPerg,.T.)

  Processa({ || xPrintRel(),OemToAnsi('Gerando o relatório.')}, OemToAnsi('Aguarde...'))
Return  
    
///////////////////////// 
Static Function xPrintRel 
  Local cAlias := Alias()
  Local aForma := {}
  Local nX 	   := 0
  Local nQtdPag:= 0  
  Local nPos   := 0  
  Local nLarg:=300,nAlt:=200,nColIni:=160
  Local nTxJuros,nPreco,nVlrUnit
       
  Private oPrint          
  Private oFont06  := TFont():New('Arial',,06,,.F.,,,,.F.,.F.)
  Private oFont06n := TFont():New('Arial',,06,,.T.,,,,.F.,.F.)
  Private oFont08  := TFont():New('Arial',,08,,.F.,,,,.F.,.F.)
  Private oFont08n := TFont():New('Arial',,08,,.T.,,,,.F.,.F.)
  Private oFont10  := TFont():New('Arial',,10,,.F.,,,,.F.,.F.)
  Private oFont10n := TFont():New('Arial',,10,,.T.,,,,.F.,.F.)
  Private oFont12  := TFont():New('Arial',,12,,.F.,,,,.F.,.F.)
  Private oFont12n := TFont():New('Arial',,12,,.T.,,,,.F.,.F.)
  Private oFont14  := TFont():New('Arial',,14,,.F.,,,,.F.,.F.)
  Private oFont14n := TFont():New('Arial',,14,,.T.,,,,.F.,.F.)
  Private oFont26  := TFont():New('Arial',,26,,.F.,,,,.F.,.F.)
  Private oFont26n := TFont():New('Arial',,26,,.T.,,,,.F.,.F.)
  Private oFtA12   := TFont():New("Arial",,12,,.f.,,,,,.f.  )

  Private li		:= 0
  Private nCol		:= 0
  Private nTotal    := 0 
  Private nDifDesc  := 0 

  oPrint := TMSPrinter():New(OemToAnsi('Comprovante de Vendas'))
  oPrint:SetPortrait()
  oPrint:Setup() 
   
  //DbSelectArea("AB6") // Cab. Ordens de Servico
  //DbSetOrder(1)
  U_MsSetOrder("AB6","AB6_FILIAL+AB6_NUMOS")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

  //DbSelectArea("AB7") // Itens das Ordens de Servico
  //DbSetOrder(1)
  U_MsSetOrder("AB7","AB7_FILIAL+AB7_NUMOS+AB7_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

  //DbSelectArea("AB8") // Sub-Itens das Ordens de Servico
  //DbSetOrder(1)
  U_MsSetOrder("AB8","AB8_FILIAL+AB8_NUMOS+AB8_ITEM+AB8_SUBITE")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

  //DbSelectArea("AB9") // Atendimento da Ordens de Servico
  //DbSetOrder(1)
  U_MsSetOrder("AB9","AB9_FILIAL+AB9_NUMOS+AB9_CODTEC+AB9_SEQ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

  //DbSelectArea("ABB") // Agenda Tecnica
  //DbSetOrder(3)
  U_MsSetOrder("ABB","ABB_FILIAL+ABB_CODTEC+DTOS(ABB_DTINI)+ABB_HRINI+DTOS(ABB_DTFIM)+ABB_HRFIM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

  //DbSelectArea("SA1") // Cad. de Clientes
  //DbSetOrder(1)
  U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

  //DbSelectArea("AA1") // Cad. de Tecnicos
  //DbSetOrder(1)
  U_MsSetOrder("AA1","AA1_FILIAL+AA1_CODTEC")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

  //DbSelectArea("AA3") // Amarracao de Clientes X Equipamentos
  //DbSetOrder(1)
  U_MsSetOrder("AA3","AA3_FILIAL+AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

  //DbSelectArea("AA5") // Cad. Servicos
  //DbSetOrder(1)
  U_MsSetOrder("AA5","AA5_FILIAL+AA5_CODSER")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

  //DbSelectArea("AAG") // Cad. Ocorrencias
  //DbSetOrder(1)
  U_MsSetOrder("AAG","AAG_FILIAL+AAG_CODPRB")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

  //DbSelectArea("SB1") // Cad. de Produtos
  //DbSetOrder(1)
  U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Inicio da impressão	³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  oPrint:StartPage()  

  lTecnico := .F.

  If AB6->(DbSeek(xFilial()+mv_par01))
     
     Do While !AB6->(Eof()) .And. AB6->AB6_NumOs <= mv_par02  //- Cab. OS
		
		For G:= 1 to Mv_Par03
		   
		   If SA1->(DbSeek(xFilial()+AB6->AB6_CodCli+AB6->AB6_Loja))  //- Cliente
 		      lTecnico := .T.
			  li := IIF(G = 1, 00, li)
			  nPag := 00
			  Cabec(G)  //- Cabecalho
			  
			  If AB7->(DbSeek(xFilial()+AB6->AB6_NumOs)) //- Itens OS
			     Conta    := 00
				 nItem    := 01
				 vServico := {}
				 vOcorr   := {}  
							
				 Do While !AB7->(Eof()) .And. AB6->AB6_NumOs == AB7->AB7_NumOs
				    If SB1->(DbSeek(xFilial()+AB7->AB7_CODPRO))
					   If AA3->(DbSeek(xFilial()+AB7->AB7_CODCLI+AB7->AB7_LOJA+AB7->AB7_CODPRO+AB7->AB7_NUMSER))
		 			      If AAG->(DbSeek(xFilial()+AB7->AB7_CODPRB)) //- Ocorrencias
						     oPrint:Say(li, 0010, Transform(nItem,"999"), oFont08n,,,,0)
							 oPrint:Say(li, 0200, SUBSTR(SB1->B1_DESC,1,45), oFont08n,,,,0)
							 oPrint:Say(li, 0600, AllTrim(AB7->AB7_NUMSER), oFont08n,,,,0);li+=50
 							 
 							 //- Armazena Ocorrencias
							 AADD(VOcorr,{nItem,AAG->AAG_DESCRI})
											
							 //- Conta o numero de itens por pagina
							 Conta++
							 nItem++
					      EndIf
					   EndIf
					EndIf
					AB7->(DbSkip())
				 Enddo
				                                           
				 //- Sub-Itens da OS
				 If AB8->(DbSeek(xFilial()+AB6->AB6_NumOs))
				    Do While !AB8->(Eof()) .And. AB6->AB6_NumOs == AB8->AB8_NumOs
					   SB1->(DbSeek(xFilial()+AB8->AB8_CodPro))
					   //- Armazena os Servicos e Pecas
					   If AllTrim(SB1->B1_TIPO) <> "MO"                                                                       
					      //                      1              2               3                4              5             6
						  AADD(vServico,{AB8->AB8_DESPRO,AB8->AB8_QUANT,SB1->B1_LOCAGRO,AB8->AB8_CODPRO,AB8->AB8_SEPARA,SB1->B1_XCODFAB})
					   EndIf
					   AB8->(DbSkip())
					Enddo
		         EndIf
		      EndIf
		   EndIf
		   If lTecnico
		      Cabec2(G)
		   Else
		      Alert("AGENDE UM TECNICO PARA A O.S.!!!")
		   EndIf
		Next 
		AB6->(DbSkip())
	 Enddo
  EndIf
  oPrint:EndPage()
  oPrint:Preview()                                                             
  oPrint:end()
Return
  
////////////////////////
Static Function Cabec(G)
  oPrint:Say(li, 0010, "AGROPISCO COM. E SERV. DE EQUIP. EIRELI", oFont10n,,,,0); li += 50  
  oPrint:Say(li, 0010, "ASSISTENCIA TECNICA", oFont10n,,,,0); li += 50  
  oPrint:Say(li, 0010, "AV. IVANETE MACHADO No. 755 - PARQUE 10", oFont10n,,,,0); li += 50  
  oPrint:Say(li, 0010, "FONE: (92) 2121-4650", oFont10n,,,,0); li += 50  
  oPrint:Say(li, 0010, "EMISSAO :" +DTOC(dDataBase), oFont10n,,,,0); li += 50  
  oPrint:Say(li, 0010, TIME(), oFont10n,,,,0); li += 50  

  oPrint:Say(li,0010,REPLICATE(".",100),oFont08,,,,0); li += 30
                                                           
  oPrint:Say(li, 0010, "NUM. OS : " + AB6->AB6_NUMOS, oFont10n,,,,0); li += 50  
  oPrint:Say(li, 0010, "NUM. ORC : " + AB6->AB6_NUMORC, oFont10n,,,,0); li += 50  
  oPrint:Say(li, 0010, "CLIENTE : " + SA1->A1_COD +" - " +SA1->A1_NOME, oFont10n,,,,0); li += 50  
  
  oPrint:Say(li,0010,REPLICATE(".",100),oFont08,,,,0); li += 30
  
  oPrint:Say(li, 0010, "EQUIPAMENTOS", oFont08n,,,,0)
  oPrint:Say(li, 0600, "SERIE", oFont08n,,,,0); li += 50
Return

/////////////////////////
Static Function Cabec2(G)
  oPrint:Say(li, 0010, "SERVICO(S)/PECA(S)", oFont08n,,,,0); li += 50
  oPrint:Say(li, 0250, "REFER", oFont08n,,,,0)
  oPrint:Say(li, 0450, "QUANT", oFont08n,,,,0)
  oPrint:Say(li, 0600, "LOC.", oFont08n,,,,0)
  oPrint:Say(li, 0700, "SEPARA?", oFont08n,,,,0); li += 50  
  
  For I:= 1 to Len(vServico)
     //    	  	        1         2         3         4         5         6         7         8         9        10
	 //        0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	 oPrint:Say(li, 0010, Alltrim(vServico[I][4])+"-"+Left(vServico[I][1],22), oFont08n,,,,0);li += 30 // Servico ou Pecas
	 oPrint:Say(li, 0250, vServico[I][6], oFont08n,,,,0)
	 oPrint:Say(li, 0450, Transform(VServico[I][2],"@R 99,999.99"), oFont08n,,,,0)
	 oPrint:Say(li, 0600, Alltrim(VServico[I][3]), oFont08n,,,,0) //Local
	 
	 If VServico[I][5] = "1"        
	    oPrint:Say(li, 0700, "Sim(X)Nao( ) ", oFont08n,,,,0); li += 30
	 Else
	    oPrint:Say(li, 0700, "Sim( )Nao(X) ", oFont08n,,,,0); li += 30
	 Endif   
  Next                                                        
  li += 70
  oPrint:Say(li, 0010, "Data da Entrega : ____/____/______", oFont10n,,,,0); li += 50
  oPrint:Say(li, 0010, "Recebido por    : __________________________________", oFont10n,,,,0);li += 200
Return