#INCLUDE "RWMAKE.CH"
//#include "report.ch"

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RAGRO008  ³ Autor ³ Ulisses Junior        ³ Data ³ 10.07.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Orcamento                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±³                                                                       ³±±
±±³05/03/2008³Diego Rafael   ³Bops 98346: Atualização da impressão de     ³±±
±±³                          ³somente Agropisco para a empresa que estiver³±±
±±³                          ³sendo Usada no momento                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RAGRO008(cOrcamento)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Titulo  := "Impressao do Orcamento"
Local cDesc1  := "     Este programa ira emitir os Orcamentos conforme os parametros"
Local cDesc2  := "solicitados."
Local cDesc3  := " "
Local cString := "AB3"  // Alias utilizado na Filtragem
Local lDic    := .F.    // Habilita/Desabilita Dicionario
Local lComp   := .T.    // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .T.    // Habilita/Desabilita o Filtro
Local wnrel   := "RAGRO008"    // Nome do Arquivo utilizado no Spool
Local nomeprog:= "RAGRO008"    // nome do programa

Private Tamanho := "P" // P/M/G
Private Limite  := 132 // 80/132/220
Private aOrdem  := {}  // Ordem do Relatorio
Private cPerg   := "RAGRO8"  // Pergunta do Relatorio
Private aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

ValidPerg()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MV_PAR01               Orcamento                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif
#IFDEF WINDOWS
	RptStatus({|lEnd| ImpDet(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)
#ELSE
	ImpDet(.F.,wnrel,cString,nomeprog,Titulo)
#ENDIF

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ ImpDet   ³ Autor ³ Ulisses Junior        ³ Data ³10.07.2207³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Orçamento                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpDet(	lEnd,	wnrel,	cString,	nomeprog,;
						Titulo)

Local li      	:= 100 										// Contador de Linhas
Local nFolha 	:= 01										// Nr. da folha	
Local cbCont  	:= 0  										// Numero de Registros Processados
Local aTotal  	:= { 0 , 0 }								// Array de totais do relatorio

//dbSelectArea(cString)
SetRegua(AB3->(LastRec()))
AB3->(dbSetOrder(1))
AB3->(dbSeek(xFilial("AB3")+mv_par01,.T.))//MsSeek(xFilial("AB3")+mv_par01,.T.)

aLay  := RetLayOut()								// Array contendo o layout do relatorio

While !AB3->(Eof()) .And. xFilial("AB3") = AB3->AB3_FILIAL .And. mv_par01 = AB3->AB3_NUMORC 
	nFolha := 01
	#IFNDEF WINDOWS
		If LastKey() = 286
			lEnd := .T.
		EndIf
	#ENDIF
	If lEnd
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	
	Li := Rt400Cabec(@nFolha)
	AB4->(dbSetOrder(1))
	AB4->(dbSeek(xFilial("AB4")+AB3->AB3_NUMORC))//MsSeek(xFilial("AB4")+AB3->AB3_NUMORC)

	While !AB4->(Eof()) .And. xFilial("AB4") = AB4->AB4_FILIAL .And. AB3->AB3_NUMORC = AB4->AB4_NUMORC

		If ( Li > 54 )
			nFolha++
			Li := Rt400Cabec(@nFolha) //Cabeçalho
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona Registros                                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AAG->(dbSetOrder(1))
		AAG->(dbSeek(xFilial("AAG")+AB4->AB4_CODPRB))//MsSeek(xFilial("AAG")+AB4->AB4_CODPRB)

		FmtLin({ AB4->AB4_CODPRO,;
				Substr(Posicione("SB1",1,XFILIAL("SB1")+AB4->AB4_CODPRO,"B1_DESC"),1,25),;
				AB4->AB4_NUMSER,Left(AAG->AAG_DESCRI,40)},aLay[14],,,@Li)

		AB4->(dbSkip())
	End
/////////////////////////////////////////////////////////
	
	FmtLin({},aLay[15],,,@Li)
	FmtLin({Left(AB3->AB3_OBS1,50)},aLay[16],,,@Li)
	FmtLin({},aLay[17],,,@Li)
	FmtLin({},aLay[18],,,@Li)
	FmtLin({},aLay[19],,,@Li)
	
	AB5->(dbSetOrder(1))
	AB5->(dbSeek(xFilial("AB5")+AB3->AB3_NUMORC))
		
	While !AB5->(Eof()) .And. xFilial("AB5") = AB5->AB5_FILIAL .And. AB3->AB3_NUMORC = AB5->AB5_NUMORC

		If ( Li > 54 )
			nFolha++
			Li := Rt400Cabec(@nFolha)
		EndIf
			
		SB1->(dbSeek(xFilial("SB1")+AB5->AB5_CODPRO))
			
		FmtLin({ 	Left(SB1->B1_COD,15),;
					Left(SB1->B1_DESC,45),;
					Left(SB1->B1_UM,10),;
					PadL(TransForm(AB5->AB5_QUANT, PesqPict("AB5","AB5_QUANT")),14),;
					PadL(TransForm(AB5->AB5_VUNIT, PesqPict("AB5","AB5_VUNIT")),14),;
					PadL(TransForm(AB5->AB5_TOTAL, PesqPict("AB5","AB5_TOTAL")),19)},;
					aLay[20],,,@Li)
	
		If Alltrim(SB1->B1_TIPO) = "MO"  // Mao de Obra
			aTotal[02] += AB5->AB5_TOTAL
		Else                          // Substituicao de Pecas
			aTotal[01] += AB5->AB5_TOTAL
		EndIf

		AB5->(dbSkip())
	End
	cData := diaextenso(ddatabase)+" , "+alltrim(str(day(ddatabase)))+"/"+mesextenso(ddatabase)+"/"+alltrim(str(year(ddatabase)))+"   "+time()
	FmtLin({},aLay[21],,,@Li)
//////////////////////////////////////////////////////////
	FmtLin({ TransForm(aTotal[01],PesqPict("AB5","AB5_TOTAL"))},aLay[22],,,@Li)
	FmtLin({ TransForm(aTotal[02],PesqPict("AB5","AB5_TOTAL"))},aLay[23],,,@Li)
	FmtLin({ TransForm(aTotal[01]+aTotal[02],PesqPict("AB5","AB5_TOTAL"))},aLay[24],,,@Li)
	FmtLin({},aLay[25],,,@Li)
	FmtLin({},aLay[26],,,@Li)
	FmtLin({},aLay[27],,,@Li)
	FmtLin({},aLay[28],,,@Li)
	FmtLin({},aLay[29],,,@Li)
	FmtLin({dtoc(AB3->AB3_EMISSA),Time()},aLay[30],,,@Li)
	FmtLin({},aLay[31],,,@Li)
	FmtLin({Posicione("SE4",1,xFilial("SE4")+AB3->AB3_CONPAG,"E4_DESCRI")},aLay[32],,,@Li)
	FmtLin({dtoc(AB3->AB3_DTVAL)},aLay[33],,,@Li)
	FmtLin({AB3->AB3_ATEND},aLay[34],,,@Li)
  	FmtLin({},aLay[35],,,@Li)
	FmtLin({},aLay[36],,,@Li)
  	FmtLin({},aLay[37],,,@Li)
  	FmtLin({},aLay[38],,,@Li)
  	FmtLin({},aLay[39],,,@Li)
	FmtLin({},aLay[40],,,@Li)
	FmtLin({},aLay[41],,,@Li)
	FmtLin({},aLay[42],,,@Li)
	FmtLin({},aLay[43],,,@Li)
	FmtLin({},aLay[44],,,@Li)
	FmtLin({cData},aLay[45],,,@Li)
	
    aTotal[01] := 0
    aTotal[02] := 0

	AB3->(dbSkip())
	cbCont++
	IncRegua()
End
dbSelectArea(cString)
dbClearFilter()
Set Device To Screen
Set Printer To
If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return(.T.)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RetLayOut ³ Autor ³ Eduardo Riera         ³ Data ³ 06.10.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o LayOut a ser impresso                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Array com o LayOut                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RetLayOut()

Local aLay := Array(64)
Local cEmail,cEmpresa,cEnd
Local nTamRua
//
//                     1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890


  SM0->(DbSelectArea("SM0"))
  SM0->(DbGoTop())
  While (!SM0->(EOF()))
    if SM0->M0_CODIGO == cEmpAnt
       If cEmpAnt == "03"
          cEmail := "E-mail:acompressores@hotmail.com "
          cEmpresa := "| AMAZON COMPRESSORES COMERCIO E SERVICOS DE EQUIPAMENTOS " 
          ElseIf cEmpAnt == "01"
              cEmail := "E-mail:agropisco@agropisco.com.br - www.agropisco.com.br"
              cEmpresa := "| AGROPISCO COMERCIO E SERVICOS DE EQUIPAMENTOS LTDA  "
       EndIf
       Exit
    End 
    SM0->(DbSkip())
  End
  
  nTamRua := TamToV(SM0->M0_ENDCOB,Len(SM0->M0_ENDCOB))
  
  cEnd := Trim(SUBSTR(SM0->M0_ENDCOB,0,nTamRua)) + "  No." + ;
                           AllTrim(SubStr(SM0->M0_ENDCOB,nTamRua+1,Len(SM0->M0_ENDCOB))) + ;
                           " - " + Trim(SM0->M0_BAIRCOB) + " - Cep: " + Trim(SubStr(SM0->M0_CEPCOB,0,5)) +;
                           "-" + Trim(SubStr(SM0->M0_CEPCOB,6,8)) + " " +;
                           Trim(SM0->M0_CIDCOB) + "-" + Trim(SM0->M0_ESTCOB)

aLay[01] := "+--------------------------------------------------------------------------------------------------------------------------------------+"
aLay[02] := cEmpresa + "|  O  R  C  A  M  E  N  T  O  :  ######                       | Folha: ######|"
aLay[03] := PadR(cEnd,136) + " |"
aLay[04] := "| "+Trim(SM0->M0_TEL) + " | "+ cEmail + " | "
aLay[05] := "+--------------------------------------------------------------------------------------------------------------------------------------+"
aLay[06] := "| Cliente  : ######/## - ########################################                                                                      |"
aLay[07] := "| Endereco : ########################################                                                                                  |"
aLay[08] := "| Bairro   : ######################### - #########                                                                                     |"
aLay[09] := "| CGC/CPF  : ####################      I.E.: ############                                                                              |"
aLay[10] := "| Telefone : ### - #################   Fax : ############                             Contato: ##################                      |"
aLay[11] := "+--------------------------------------------------------------------------------------------------------------------------------------+"
aLay[12] := "|Codigo          |Produto                                      |      Nr.Serie      |                   Defeito                        |"
aLay[13] := "+--------------------------------------------------------------------------------------------------------------------------------------+"
aLay[14] := "|############### |#############################################|####################|##################################################|"
aLay[15] := "+-------------------------------------------------------------------------------------------------------------------------------------+"
aLay[16] := "|Obs.: ##################################################                                                                              |"
aLay[17] := "+--------------------------------------------------------------------------------------------------------------------------------------+"
aLay[18] := "|Codigo          |Produto                                      |  Unidade   |  Quantidade  |  Valor Unitario   |     Total R$          |"
aLay[19] := "+--------------------------------------------------------------------------------------------------------------------------------------+"
aLay[20] := "|################|#############################################|############|##############|################## |##################     |"
aLay[21] := "+--------------------------------------------------------------------------------------------------------------------------------------+"
aLay[22] := "|Precos sujeitos a alteracao sem aviso previo                                                Pecas      :        ######################|"
aLay[23] := "|                                                                                            Mao de Obra:        ######################|"
aLay[24] := "|                                                                                            Total      :        ######################|"
aLay[25] := "|                                                                                                                                      |"
aLay[26] := "+--------------------------------------------------------------------------------------------------------------------------------------+"
aLay[27] := "|                                        NAO E DOCUMENTO FISCAL - EXIJA SEU CUPOM FISCAL                                               |"
aLay[28] := "+--------------------------------------------------------------------------------------------------------------------------------------+"
aLay[29] := "                                                                                                                                        "
aLay[30] := "Data : ########### - Hora : ########                                                                                                    " 
aLay[31] := "                                                                                                                                        "
aLay[32] := "Forma de Pagamento : ##########                                                                                                         "
aLay[33] := "Validade da Proposta : ##########                                                                                                       "
aLay[34] := "Atendente: ##########                                                                                                                   "
aLay[35] := "                                                                                                                                        "
aLay[36] := "                                                                                                                                        "
aLay[37] := "Eu _____________________________________,  portador  do  RG n._____________________,  declaro  estar  ciente e de acordo que a nao	     " 
aLay[38] := "retirada do equipamento acima mencionado no  prazo  maximo  de  90 dias,  independente  de qualquer  notificacao judicial,  tem  o      "
aLay[39] := "equipamento em questao executado e seus  valores  revestidos  em favor da  AGROPISCO  COMERCIO E  SERVICOS  DE  EQUIPAMENTOS  LTDA      "
aLay[40] := "para cobrir eventuais despesas com pecas, mao de obra e locacao e tambem de armazenagem.                                                "
aLay[41] := "                                                                                                                                        "
aLay[42] := "                      PARA CADA ORÇAMENTO NÃO APROVADO, SERÁ COBRADO O VALOR DE R$ 20,00 NO ATO DA ENTREGA.                             "
aLay[43] := "                                                                                                                                        "
aLay[44] := "                                                                                                                                        " 
aLay[45] := "Data de Impressao : ##############################                                                                                      " 


Return(aLay)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Rt400Cabec³ Autor ³ Eduardo Riera         ³ Data ³ 06.10.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cabecalho do Relatorio                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpN1 : Numero da Linha                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 : Numero da Folha                                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Rt400Cabec(nFolha)
Local cMask
Local Li := 0
Local aLay := RetLayOut()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona Registros                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial("SA1")+AB3->AB3_CODCLI+AB3->AB3_LOJA)
dbSelectArea("SE4")
dbSetOrder(1)
MsSeek(xFilial("SE4")+AB3->AB3_CONPAG)

If SA1->A1_PESSOA == "J"
   cMask := "@R 99.999.999/9999-99"
Else
   cMask := "@R 999.999.999-99"
EndIf     


Li := 0
@ Li,000 PSAY AvalImp(Limite)
FmtLin({},aLay[01],,,@Li)
FmtLin({AB3->AB3_NUMORC,StrZero(nFolha,5)},aLay[02],,,@Li)
FmtLin({},aLay[03],,,@Li)
FmtLin({},aLay[04],,,@Li)
FmtLin({},aLay[05],,,@Li)
FmtLin({AB3->AB3_CODCLI,AB3->AB3_LOJA,SA1->A1_NOME},aLay[06],,,@Li)
FmtLin({SA1->A1_END},aLay[07],,,@Li)
FmtLin({SA1->A1_BAIRRO,Transform(Alltrim(SA1->A1_CEP),PesqPict("SA1","A1_CEP"))},aLay[08],,,@Li)
FmtLin({Transform(SA1->A1_CGC,cMask),SA1->A1_INSCR},aLay[09],,,@Li)
FmtLin({SA1->A1_DDD,Transform(Alltrim(SA1->A1_TEL),"@R 9999-9999"),;
		Transform(Alltrim(SA1->A1_TEL),"@R 9999-9999"),;
		AllTrim(AB3->AB3_CONTAT)},aLay[10],,,@Li)
FmtLin({},aLay[11],,,@Li)
FmtLin({},aLay[12],,,@Li)
FmtLin({},aLay[13],,,@Li)

Return(Li)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Ulisses Junior      º Data ³  10/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria perguntas                                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RAGRO008                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg()                    

PutSX1(cPerg, "01", "Orcamento  ?","","","mv_ch1", "C",06, 0, 0, "G", "", "", "", "", "mv_par01",;
"","","","","","","","","","","","","","","","","","","","")	

Return
                              
Static Function TamToV(cPalavra,nTotal)
     Local nTam := 0
      For i := 1 To nTotal
       If(SubStr(cPalavra,i,1) == ",") 
        nTam:=i       
       EndIf
      Next
Return nTam