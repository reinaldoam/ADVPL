#INCLUDE 'MATR280.CH'
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ UMTR280  ³ Autor ³ Ricardo Berti         ³ Data ³20.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Listagem do pre'-inventario                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAEST                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function UMTR280()

Local oReport
Private cAliasSB1 := "SB1"
Private cAliasSB2 := "SB2"

If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MATR280R3()
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Ricardo Berti 		³ Data ³20.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatorio                                  ³±±
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
Static Function ReportDef()

Local aOrdem	:= {}
Local cPerg		:= "MTR280"
Local oReport
Local oCell
Local oSection1
Local oSection2

If !__lPyme
	aOrdem := {STR0005,STR0006,STR0007,STR0008,STR0017}   //' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '###' Por Endereco     '
Else
	aOrdem := {STR0005,STR0006,STR0007,STR0008}   //' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '
EndIf	
                
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("MATR280",STR0001,cPerg, {|oReport| ReportPrint(oReport)},STR0002+" "+STR0003+" "+STR0004) // 'Listagem para Inventario'##'Este programa emite um relatorio que facilita a digitacao'##'das quantidades inventariadas.'##"Ele e' emitido de acordo com os parametros informados."
oReport:SetLandScape()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta Grupo de Perguntas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Almox. de                                    ³
//³ mv_par02     // Almox. ate                                   ³
//³ mv_par03     // Produto de                                   ³
//³ mv_par04     // Produto ate                                  ³
//³ mv_par05     // tipo de                                      ³
//³ mv_par06     // tipo ate                                     ³
//³ mv_par07     // grupo de                                     ³
//³ mv_par08     // grupo ate                                    ³
//³ mv_par09     // descricao de                                 ³
//³ mv_par10     // descricao ate                                ³
//³ mv_par11     // data Selecao de                              ³
//³ mv_par12     // data Selecao ate                             ³
//³ mv_par13     // Imprime Lote/Sub-Lote e N£mero de S‚rie ?    ³
//³ mv_par14     // Lista Prod. C/ Sld Zerado ? (Sim/Nao)        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao das celulas da secao do relatorio                               ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection1 := TRSection():New(oReport,STR0024,{"SB1","SB2"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/) // "Produtos"

TRCell():New(oSection1,"B1_COD","SB1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_TIPO","SB1")
TRCell():New(oSection1,"B1_GRUPO","SB1")
TRCell():New(oSection1,"B1_DESC","SB1")
TRCell():New(oSection1,"B1_UM","SB1")
TRCell():New(oSection1,"B2_LOCAL","SB2")
TRCell():New(oSection1,"B2_LOCALIZ","SB2")

oCell := TRCell():New(oSection1,"LOCALIZ","")
oCell:GetFieldInfo("BF_LOCALIZ")
oCell := TRCell():New(oSection1,"LOTECTL","")
oCell:GetFieldInfo("BF_LOTECTL")
oCell := TRCell():New(oSection1,"NUMLOTE","")
oCell:GetFieldInfo("BF_NUMLOTE")
oCell := TRCell():New(oSection1,"NUMSERI","")
oCell:GetFieldInfo("BF_NUMSERI")
oCell:SetSize(14)
TRCell():New(oSection1,"QTD1","",STR0018+CRLF+STR0019,,11,,{|| "[         ]" }) //" _______1a."###"Quantidade"
TRCell():New(oSection1,"ETQ1","",STR0020+CRLF+STR0021,, 8,,{|| "[      ]" }) //"Contagem"###"Etiqueta"
TRCell():New(oSection1,"QTD2","",STR0022+CRLF+STR0019,,11,,{|| "[         ]" }) //" _______2a."###"Quantidade"
TRCell():New(oSection1,"ETQ2","",STR0020+CRLF+STR0021,, 8,,{|| "[      ]" }) //"Contagem"###"Etiqueta"
TRCell():New(oSection1,"QTD3","",STR0023+CRLF+STR0019,,11,,{|| "[         ]" }) //" _______3a."###"Quantidade"
TRCell():New(oSection1,"ETQ3","",STR0020+CRLF+STR0021,, 8,,{|| "[      ]" }) //"Contagem"###"Etiqueta"

// Secao para a ordem por ENDERECO (muda o arq.base)
oSection2 := TRSection():New(oReport,STR0025,{"SBE","SB1","SB2"}) //"Saldos por Endereço"

oCell:=TRCell():New(oSection2,"B1COD","SB1",,,,,{|| (cAliasSB1)->B1_COD})
oCell:GetFieldInfo("B1_COD")
oCell:=TRCell():New(oSection2,"B1TIPO","SB1",,,,,{|| (cAliasSB1)->B1_TIPO})
oCell:GetFieldInfo("B1_TIPO")
oCell:=TRCell():New(oSection2,"B1GRUPO","SB1",,,,,{|| (cAliasSB1)->B1_GRUPO})
oCell:GetFieldInfo("B1_GRUPO")
oCell:=TRCell():New(oSection2,"B1DESC","SB1",,,,,{|| (cAliasSB1)->B1_DESC})
oCell:GetFieldInfo("B1_DESC")
oCell:=TRCell():New(oSection2,"B1UM","SB1",,,,,{|| (cAliasSB1)->B1_UM})
oCell:GetFieldInfo("B1_UM")
oCell:=TRCell():New(oSection2,"B2LOCAL","SB2",,,,,{|| (cAliasSB2)->B2_LOCAL})
oCell:GetFieldInfo("B2_LOCAL")
oCell:=TRCell():New(oSection2,"B2LOCALIZ","SB2",,,,,{|| (cAliasSB2)->B2_LOCALIZ})
oCell:GetFieldInfo("B2_LOCALIZ")

oCell := TRCell():New(oSection2,"LOCALIZ2","")
oCell:GetFieldInfo("BF_LOCALIZ")
oCell := TRCell():New(oSection2,"LOTECTL2","")
oCell:GetFieldInfo("BF_LOTECTL")
oCell := TRCell():New(oSection2,"NUMLOTE2","")
oCell:GetFieldInfo("BF_NUMLOTE")
oCell := TRCell():New(oSection2,"NUMSERI2","")
oCell:GetFieldInfo("BF_NUMSERI")
oCell:SetSize(14)
TRCell():New(oSection2,"QTD1_2","",STR0018+CRLF+STR0019,,11,,{|| "[         ]" }) //" _______1a."###"Quantidade"
TRCell():New(oSection2,"ETQ1_2","",STR0020+CRLF+STR0021,, 8,,{|| "[      ]" }) //"Contagem"###"Etiqueta"
TRCell():New(oSection2,"QTD2_2","",STR0022+CRLF+STR0019,,11,,{|| "[         ]" }) //" _______2a."###"Quantidade"
TRCell():New(oSection2,"ETQ2_2","",STR0020+CRLF+STR0021,, 8,,{|| "[      ]" }) //"Contagem"###"Etiqueta"
TRCell():New(oSection2,"QTD3_2","",STR0023+CRLF+STR0019,,11,,{|| "[         ]" }) //" _______3a."###"Quantidade"
TRCell():New(oSection2,"ETQ3_2","",STR0020+CRLF+STR0021,, 8,,{|| "[      ]" }) //"Contagem"###"Etiqueta"

Return(oReport)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Ricardo Berti         ³ Data ³20.06.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local cAliasQRY := ""
Local cAliasSBF := 'SBF'
Local cCondicao1:= "" 
Local cLoteAnt	:= "" 
Local cOrdem    := ""
Local cProduto  := ""
Local cWhile	:= ""
Local lQuery	:= .F.
Local lImpLote	:= If(mv_par13==1,.T.,.F.)
Local nOrdem    := oReport:Section(1):GetOrder()
Local lFirst	:= .T.
Local lRastro	:= .F.
Local lRastroS	:= .F.
Local lCLocal	:= .F.
Local oSection1	:= oReport:Section(1)
Local oSection2	:= oReport:Section(2)
#IFNDEF TOP
	Local cCondicao := ""
#ELSE
  	Local cOrderBy  := ""
	Local cWhere    :=  ''
#ENDIF

If nOrdem == 1
	cOrdem := STR0005
ElseIf nOrdem == 2
	cOrdem := STR0006
ElseIf nOrdem == 3
	cOrdem := STR0007
ElseIf nOrdem == 4
	cOrdem := STR0008
ElseIf nOrdem == 5
	cOrdem := STR0017
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os Arquivos e Ordens a serem utilizados           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 5
	oSection2:SetHeaderPage()
	//dbSelectArea("SBE")
	//dbSetOrder(1)
	U_MsSetOrder("SBE","BE_FILIAL+BE_LOCAL+BE_LOCALIZ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
Else
	oSection1:SetHeaderPage()
EndIf
oReport:SetTitle(oReport:Title()+" ("+AllTrim(cOrdem)+")" )

//dbSelectArea('SB2')
//dbSetOrder(1)
U_MsSetOrder("SB2","B2_FILIAL+B2_COD+B2_LOCAL")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

//dbSelectArea('SB8')
//dbSetOrder(3)
U_MsSetOrder("SB8","B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                     

//dbSelectArea('SBF')
//dbSetOrder(2)
U_MsSetOrder("SBF","BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

dbSelectArea('SB1')
dbSetOrder(nOrdem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatorio                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatorio da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lQuery := .T.
	cAliasQRY := GetNextAlias()
	cAliasSB1 := cAliasQRY
	cAliasSB2 := cAliasQRY

	cWhere := "%"
	If mv_par14 == 2
		cWhere += " AND B2_QATU <> 0 "
	EndIf
	cWhere += "%"

	If !__lPyme .And. nOrdem == 5

		cAliasSBF := cAliasQRY
		
		oSection2:BeginQuery()
		
		BeginSql Alias cAliasQRY
		SELECT	BE_FILIAL,BE_LOCAL,BE_LOCALIZ,BF_FILIAL,
				BF_PRODUTO,BF_LOCAL,BF_LOCALIZ,BF_LOTECTL,BF_NUMLOTE,BF_NUMSERI,
				B1_FILIAL,B1_COD,B1_TIPO,B1_GRUPO,B1_DESC,B1_UM,B1_PERINV,
				B2_FILIAL,B2_COD,B2_LOCAL,B2_LOCALIZ,B2_DINVENT

		FROM %table:SB1% SB1, %table:SB2% SB2, %table:SBE% SBE
		  JOIN %table:SBF% SBF
		  ON	SBF.BF_FILIAL  = %xFilial:SBF% AND
		  		SBF.BF_LOCAL   = SBE.BE_LOCAL AND
		  		SBF.BF_LOCALIZ = SBE.BE_LOCALIZ AND
				SBF.BF_PRODUTO >= %Exp:mv_par03% AND 
				SBF.BF_PRODUTO <= %Exp:mv_par04% AND 
				SBF.%NotDel%
	 	  WHERE	SBE.BE_FILIAL  = %xFilial:SBE% AND
				SBE.BE_LOCAL  >= %Exp:mv_par01% AND 
				SBE.BE_LOCAL  <= %Exp:mv_par02% AND 
	 	       	SB1.B1_FILIAL  = %xFilial:SB1% AND
				SB1.B1_COD     = SBF.BF_PRODUTO AND
				SB1.B1_TIPO   >= %Exp:mv_par05% AND 
				SB1.B1_TIPO   <= %Exp:mv_par06% AND 
				SB1.B1_GRUPO  >= %Exp:mv_par07% AND 
				SB1.B1_GRUPO  <= %Exp:mv_par08% AND 
				SB1.B1_DESC   >= %Exp:mv_par09% AND 
				SB1.B1_DESC   <= %Exp:mv_par10% AND 
	 	       	SB2.B2_FILIAL  = %xFilial:SB2% AND
				SB2.B2_COD     = SBF.BF_PRODUTO AND
				SB2.B2_LOCAL   = SBF.BF_LOCAL AND
				SB1.%NotDel% AND
				SB2.%NotDel% AND
 				SBE.%NotDel%
				%Exp:cWhere%           
			
		ORDER BY %Order:SBE% 
				
		EndSql 
		oSection2:EndQuery(/*Array com os parametros do tipo Range*/)

	Else
		oSection1:BeginQuery()	
	
		BeginSql Alias cAliasQRY
		SELECT B1_FILIAL,B1_COD,B1_TIPO,B1_GRUPO,B1_DESC,B1_UM,B1_PERINV,B2_FILIAL,B2_COD,B2_LOCAL,B2_LOCALIZ,B2_DINVENT
	
		FROM %table:SB1% SB1
		  JOIN %table:SB2% SB2
		  ON	B2_FILIAL  = %xFilial:SB2% AND
				B2_COD     = B1_COD AND
				B2_LOCAL  >= %Exp:mv_par01% AND 
				B2_LOCAL  <= %Exp:mv_par02% AND 
				SB2.%NotDel%
	 	  WHERE	B1_FILIAL  = %xFilial:SB1% AND
				B1_COD    >= %Exp:mv_par03% AND 
				B1_COD    <= %Exp:mv_par04% AND 
				B1_TIPO   >= %Exp:mv_par05% AND 
				B1_TIPO   <= %Exp:mv_par06% AND 
				B1_GRUPO  >= %Exp:mv_par07% AND 
				B1_GRUPO  <= %Exp:mv_par08% AND 
				B1_DESC   >= %Exp:mv_par09% AND 
				B1_DESC   <= %Exp:mv_par10% AND 
				SB1.%NotDel%
				%Exp:cWhere%           
			
		ORDER BY %Order:SB1% 
				
		EndSql 
		oSection1:EndQuery(/*Array com os parametros do tipo Range*/)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#ELSE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao ADVPL                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr(oReport:uParam)

	If !__lPyme .And. nOrdem == 5
		cCondicao := 'BE_FILIAL == "'+xFilial("SBE")+'".And.' 
		cCondicao += 'BE_LOCAL  >= "'+mv_par01+'".And. BE_LOCAL <="'+mv_par02+'"'
//		SB1->(dbSetOrder(1))	
		U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
//		SBF->(dbSetOrder(1))	
		U_MsSetOrder("SBF","BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
		dbSelectArea('SBE')
		cAliasQRY := "SBE"
		oSection2:SetFilter(cCondicao)
	Else 
		cCondicao := 'B1_FILIAL == "'+xFilial("SB1")+'".And.' 
		cCondicao += 'B1_COD    >= "'+mv_par03+'".And.B1_COD   <="'+mv_par04+'".And.'
		cCondicao += 'B1_TIPO   >= "'+mv_par05+'".And.B1_TIPO  <="'+mv_par06+'".And.'
		cCondicao += 'B1_GRUPO  >= "'+mv_par07+'".And.B1_GRUPO <="'+mv_par08+'".And.'
		cCondicao += 'B1_DESC   >= "'+mv_par09+'".And.B1_DESC  <="'+mv_par10+'"'
		dbSelectArea('SB1')
		cAliasQRY := "SB1"
		oSection1:SetFilter(cCondicao)
	EndIf	

#ENDIF		

//oReport:Section(2):SetParentQuery()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do relatorio		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAliasQRY)

If ! lImpLote
	If nOrdem == 5
		oSection2:Cell("LOCALIZ2"):Disable()
		oSection2:Cell("LOTECTL2"):Disable()
		oSection2:Cell("NUMLOTE2"):Disable()
		oSection2:Cell("NUMSERI2"):Disable()
	Else
		oSection1:Cell("LOCALIZ"):Disable()
		oSection1:Cell("LOTECTL"):Disable()
		oSection1:Cell("NUMLOTE"):Disable()
		oSection1:Cell("NUMSERI"):Disable()
 	EndIf
Else
	If nOrdem == 5
		oSection2:Cell("LOCALIZ2"):Enable()
		oSection2:Cell("LOTECTL2"):Enable()
		oSection2:Cell("NUMLOTE2"):Enable()
		oSection2:Cell("NUMSERI2"):Enable()
	Else
		oSection1:Cell("LOCALIZ"):Enable()
		oSection1:Cell("LOTECTL"):Enable()
		oSection1:Cell("NUMLOTE"):Enable()
		oSection1:Cell("NUMSERI"):Enable()
	EndIf
EndIf

If !__lPyme .And. nOrdem == 5
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ordem por ENDERECO                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter(SBE->(LastRec()))
	oSection2:Init()

	If lQuery
		cWhile := '!Eof()'
	Else
		dbSeek(xFilial("SBE") + AllTrim(mv_par01), .T.)
		cWhile := cCondicao
	EndIf
	Do While !oReport:Cancel() .And. &(cWhile)
		If oReport:Cancel()
			Exit
		EndIf
		oReport:IncMeter()

		If !lQuery
			(cAliasSBF)->(dbSeek(xFilial('SBF')+(cAliasQRY)->BE_LOCAL+(cAliasQRY)->BE_LOCALIZ,.F.))
		EndIf
		Do While !oReport:Cancel() .And. !(cAliasSBF)->(Eof()) .And. ;
			xFilial('SBF')+(cAliasQRY)->BE_LOCAL+(cAliasQRY)->BE_LOCALIZ == ;
			(cAliasSBF)->BF_FILIAL+(cAliasSBF)->BF_LOCAL+(cAliasSBF)->BF_LOCALIZ

			If !lQuery
				If (cAliasSBF)->BF_PRODUTO < mv_par03 .Or. (cAliasSBF)->BF_PRODUTO > mv_par04
					(cAliasSBF)->(dbSkip())
					Loop
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se o saldo esta' zerado (mv_par14 == 2 (Nao))       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par14 == 2 .And. (cAliasSBF)->BF_QUANT == 0
					(cAliasSBF)->(dbSkip())
					Loop
				EndIf
				SB1->(dbSeek(xFilial('SB1')+(cAliasSBF)->BF_PRODUTO,.F.))
				If 	(SB1->B1_TIPO  < mv_par05) .Or. (SB1->B1_TIPO  > mv_par06) .Or. ;
 					(SB1->B1_DESC  < mv_par09) .Or. (SB1->B1_DESC  > mv_par10) .Or. ;
					(SB1->B1_GRUPO < mv_par07) .Or. (SB1->B1_GRUPO > mv_par08)
					(cAliasSBF)->(dbSkip())
					Loop
				EndIf
				SB2->(dbSeek(xFilial('SB2')+(cAliasSBF)->BF_PRODUTO+(cAliasSBF)->BF_LOCAL,.F.))
			EndIf

			If (!Empty((cAliasSB2)->B2_DINVENT) .And. ;
				((((cAliasSB2)->B2_DINVENT + (cAliasSB1)->B1_PERINV) < mv_par11) .Or. ;
				(((cAliasSB2)->B2_DINVENT + (cAliasSB1)->B1_PERINV) > mv_par12)))
				(cAliasSBF)->(dbSkip())
				Loop
			EndIf

			lRastro	  := Rastro((cAliasSB1)->B1_COD)
			lRastroS  := Rastro((cAliasSB1)->B1_COD, 'S')
			lCLocal	  := Localiza((cAliasSB1)->B1_COD)
			lFirst := .T.

			If lCLocal .And. lImpLote
			    If lFirst
					oSection2:Cell("B1COD"):Show()
					oSection2:Cell("B1TIPO"):Show()
					oSection2:Cell("B1GRUPO"):Show()
					oSection2:Cell("B1DESC"):Show()
					oSection2:Cell("B1UM"):Show()
					oSection2:Cell("B2LOCAL"):Show()
					oSection2:Cell("B2LOCALIZ"):Show()
					lFirst := .F.
			    Else
					oSection2:Cell("B1COD"):Hide()
					oSection2:Cell("B1TIPO"):Hide()
					oSection2:Cell("B1GRUPO"):Hide()
					oSection2:Cell("B1DESC"):Hide()
					oSection2:Cell("B1UM"):Hide()
					oSection2:Cell("B2LOCAL"):Hide()
					oSection2:Cell("B2LOCALIZ"):Hide()
			    EndIf   
				oSection2:Cell("LOCALIZ2"):SetValue((cAliasSBF)->BF_LOCALIZ)
				oSection2:Cell("LOTECTL2"):SetValue((cAliasSBF)->BF_LOTECTL)
				oSection2:Cell("NUMLOTE2"):SetValue((cAliasSBF)->BF_NUMLOTE)
				oSection2:Cell("NUMSERI2"):SetValue((cAliasSBF)->BF_NUMSERI)
			   	oSection2:PrintLine()	
			ElseIf lRastro .And. lImpLote .And.;
				SB8->(dbSeek(xFilial('SB8') + (cAliasSB1)->B1_COD + (cAliasSBF)->BF_LOCAL, .F.))
				cCondicao1 := 'SB8->B8_FILIAL + SB8->B8_PRODUTO + SB8->B8_LOCAL + SB8->B8_LOTECTL ' + If(lRastroS,'+ SB8->B8_NUMLOTE','')
				Do While !oReport:Cancel() .And. !SB8->(Eof()) .And. ;
					xFilial('SB8') + (cAliasSB1)->B1_COD + (cAliasSBF)->BF_LOCAL + SB8->B8_LOTECTL + If(lRastroS,SB8->B8_NUMLOTE,'') == &(cCondicao1)
				    If lFirst
						oSection2:Cell("B1COD"):Show()
						oSection2:Cell("B1TIPO"):Show()
						oSection2:Cell("B1GRUPO"):Show()
						oSection2:Cell("B1DESC"):Show()
						oSection2:Cell("B1UM"):Show()
						oSection2:Cell("B2LOCAL"):Show()
						oSection2:Cell("B2LOCALIZ"):Show()
						lFirst := .F.
				    Else
						oSection2:Cell("B1COD"):Hide()
						oSection2:Cell("B1TIPO"):Hide()
						oSection2:Cell("B1GRUPO"):Hide()
						oSection2:Cell("B1DESC"):Hide()
						oSection2:Cell("B1UM"):Hide()
						oSection2:Cell("B2LOCAL"):Hide()
						oSection2:Cell("B2LOCALIZ"):Hide()
				    EndIf   
					oSection2:Cell("LOCALIZ2"):SetValue("")
					oSection2:Cell("LOTECTL2"):SetValue(SB8->B8_LOTECTL)
					oSection2:Cell("NUMLOTE2"):SetValue(If(lRastroS,SB8->B8_NUMLOTE,""))
					oSection2:Cell("NUMSERI2"):SetValue("")
				   	oSection2:PrintLine()
					SB8->(dbSkip())
				EndDo
			Else
				oSection2:Cell("B1COD"):Show()
				oSection2:Cell("B1TIPO"):Show()
				oSection2:Cell("B1GRUPO"):Show()
				oSection2:Cell("B1DESC"):Show()
				oSection2:Cell("B1UM"):Show()
				oSection2:Cell("B2LOCAL"):Show()
				oSection2:Cell("B2LOCALIZ"):Show()
				oSection2:Cell("LOCALIZ2"):SetValue("")
				oSection2:Cell("LOTECTL2"):SetValue("")
				oSection2:Cell("NUMLOTE2"):SetValue("")
				oSection2:Cell("NUMSERI2"):SetValue("")
			   	oSection2:PrintLine()	
			EndIf
			(cAliasSBF)->(dbSkip())
		EndDo
		
		If !lQuery
			(cAliasQRY)->(dbSkip())
		EndIf
		
	EndDo
	oSection2:Finish()

Else

	oReport:SetMeter(SB1->(LastRec()))
	If lQuery
		cWhile := '!Eof()'
	Else
		If nOrdem == 4
			dbSeek(xFilial("SB1") + mv_par07, .T.)
			cWhile := '!Eof() .And. '+cAliasQRY+'->B1_GRUPO <= mv_par08 .And. '+cAliasQRY+'->B1_FILIAL == "'+xFilial("SB1")+'"'
		ElseIf nOrdem == 3
			dbSeek(xFilial("SB1") + mv_par09, .T.)
			cWhile := '!Eof() .And. '+cAliasQRY+'->B1_DESC <= mv_par10 .And. '+cAliasQRY+'->B1_FILIAL == "'+xFilial("SB1")+'"'
		ElseIf nOrdem == 2
			dbSeek(xFilial("SB1") + mv_par05, .T.)
			cWhile := '!Eof() .And. '+cAliasQRY+'->B1_TIPO <= mv_par06 .And. '+cAliasQRY+'->B1_FILIAL == "'+xFilial("SB1")+'"'
		Else
			dbSeek(xFilial("SB1") + mv_par03, .T.)
			cWhile := '!Eof() .And. '+cAliasQRY+'->B1_COD <= mv_par04 .And. '+cAliasQRY+'->B1_FILIAL == "'+xFilial("SB1")+'"'
		Endif
	Endif
	oSection1:Init()

	Do While !oReport:Cancel() .And. &(cWhile)
		If oReport:Cancel()
			Exit
		EndIf
		oReport:IncMeter()

		If !lQuery .And. !(cAliasSB2)->(dbSeek(xFilial('SB2') + (cAliasQRY)->B1_COD, .F.))
			(cAliasQRY)->(dbSkip())
			Loop
		EndIf
		
		Do While  !oReport:Cancel() .And. !(cAliasSB2)->(Eof()) .And. ;
			(cAliasSB2)->B2_FILIAL + (cAliasSB2)->B2_COD == xFilial('SB2') + (cAliasQRY)->B1_COD
			
			If (!Empty((cAliasSB2)->B2_DINVENT) .And. ;
				((((cAliasSB2)->B2_DINVENT + (cAliasQRY)->B1_PERINV) < mv_par11) .Or. ;
				(((cAliasSB2)->B2_DINVENT + (cAliasQRY)->B1_PERINV) > mv_par12)))
				(cAliasSB2)->(dbSkip())
				Loop
			EndIf
			
			If !lQuery
				If ((cAliasSB2)->B2_LOCAL < mv_par01) .Or. ((cAliasSB2)->B2_LOCAL > mv_par02)
					(cAliasSB2)->(dbSkip())
					Loop
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se o saldo esta' zerado (mv_par14 == 2 (Nao))       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par14 == 2 .And. (cAliasSB2)->B2_QATU == 0
					(cAliasSB2)->(dbSkip())
					Loop
				EndIf
			EndIf
					
			lRastro	  := Rastro((cAliasQRY)->B1_COD)
			lRastroS  := Rastro((cAliasQRY)->B1_COD, 'S')
			lCLocal	  := Localiza((cAliasQRY)->B1_COD)
			lFirst := .T.
			
			If lCLocal .And. lImpLote .And.;
				SBF->(dbSeek(xFilial('SBF') + (cAliasQRY)->B1_COD + (cAliasSB2)->B2_LOCAL, .F.))
				Do While !oReport:Cancel() .And. !SBF->(Eof()) .And. ;
					xFilial('SBF') + (cAliasQRY)->B1_COD + (cAliasSB2)->B2_LOCAL == SBF->BF_FILIAL + SBF->BF_PRODUTO + SBF->BF_LOCAL

				    If lFirst
						oSection1:Cell("B1_COD"):Show()
						oSection1:Cell("B1_TIPO"):Show()
						oSection1:Cell("B1_GRUPO"):Show()
						oSection1:Cell("B1_DESC"):Show()
						oSection1:Cell("B1_UM"):Show()
						oSection1:Cell("B2_LOCAL"):Show()
						oSection1:Cell("B2_LOCALIZ"):Show()
						lFirst := .F.
				    Else
						oSection1:Cell("B1_COD"):Hide()
						oSection1:Cell("B1_TIPO"):Hide()
						oSection1:Cell("B1_GRUPO"):Hide()
						oSection1:Cell("B1_DESC"):Hide()
						oSection1:Cell("B1_UM"):Hide()
						oSection1:Cell("B2_LOCAL"):Hide()
						oSection1:Cell("B2_LOCALIZ"):Hide()
				    EndIf   
					oSection1:Cell("LOCALIZ"):SetValue(SBF->BF_LOCALIZ)
					oSection1:Cell("LOTECTL"):SetValue(SBF->BF_LOTECTL)
					oSection1:Cell("NUMLOTE"):SetValue(SBF->BF_NUMLOTE)
					oSection1:Cell("NUMSERI"):SetValue(SBF->BF_NUMSERI)
				   	oSection1:PrintLine()	
					SBF->(dbSkip())
				EndDo
			ElseIf lRastro .And. lImpLote .And.;
				SB8->(dbSeek(xFilial('SB8') + (cAliasQRY)->B1_COD + (cAliasSB2)->B2_LOCAL, .F.))
				cLoteAnt   := ""
				cCondicao1 := 'SB8->B8_FILIAL + SB8->B8_PRODUTO + SB8->B8_LOCAL + SB8->B8_LOTECTL ' + If(lRastroS,'+ SB8->B8_NUMLOTE','')
				Do While !oReport:Cancel() .And. !SB8->(Eof()) .And. ;
					xFilial('SB8') + (cAliasQRY)->B1_COD + (cAliasSB2)->B2_LOCAL + SB8->B8_LOTECTL + If(lRastroS,SB8->B8_NUMLOTE,'') == &(cCondicao1)
                    If !(cLoteAnt==SB8->B8_LOTECTL) .Or. lRastroS
					    If lFirst
							oSection1:Cell("B1_COD"):Show()
							oSection1:Cell("B1_TIPO"):Show()
							oSection1:Cell("B1_GRUPO"):Show()
							oSection1:Cell("B1_DESC"):Show()
							oSection1:Cell("B1_UM"):Show()
							oSection1:Cell("B2_LOCAL"):Show()
							oSection1:Cell("B2_LOCALIZ"):Show()
							lFirst := .F.
					    Else
							oSection1:Cell("B1_COD"):Hide()
							oSection1:Cell("B1_TIPO"):Hide()
							oSection1:Cell("B1_GRUPO"):Hide()
							oSection1:Cell("B1_DESC"):Hide()
							oSection1:Cell("B1_UM"):Hide()
							oSection1:Cell("B2_LOCAL"):Hide()
							oSection1:Cell("B2_LOCALIZ"):Hide()
					    EndIf   
						oSection1:Cell("LOCALIZ"):SetValue("")
						oSection1:Cell("LOTECTL"):SetValue(SB8->B8_LOTECTL)
						oSection1:Cell("NUMLOTE"):SetValue(If(lRastroS,SB8->B8_NUMLOTE,""))
						oSection1:Cell("NUMSERI"):SetValue("")
						cLoteAnt := SB8->B8_LOTECTL
					   	oSection1:PrintLine()	
					Endif	
					SB8->(dbSkip())
				EndDo
			Else
				oSection1:Cell("B1_COD"):Show()
				oSection1:Cell("B1_TIPO"):Show()
				oSection1:Cell("B1_GRUPO"):Show()
				oSection1:Cell("B1_DESC"):Show()
				oSection1:Cell("B1_UM"):Show()
				oSection1:Cell("B2_LOCAL"):Show()
				oSection1:Cell("B2_LOCALIZ"):Show()
				oSection1:Cell("LOCALIZ"):SetValue("")
				oSection1:Cell("LOTECTL"):SetValue("")
				oSection1:Cell("NUMLOTE"):SetValue("")
				oSection1:Cell("NUMSERI"):SetValue("")
			   	oSection1:PrintLine()	
			EndIf
			
			(cAliasSB2)->(dbSkip())
		EndDo
		
		If !lQuery
			(cAliasQRY)->(dbSkip())
		EndIf
		
	EndDo
	oSection1:Finish()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lQuery
	dbSelectArea(cAliasQRY)
	dbSetOrder(1)
	dbClearFilter()
EndIf	
//SB1->(dbSetOrder(1))
U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
//SB2->(dbSetOrder(1))
U_MsSetOrder("SB2","B2_FILIAL+B2_COD+B2_LOCAL")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
//SB8->(dbSetOrder(1))
U_MsSetOrder("SB8","B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
//SBF->(dbSetOrder(1))
U_MsSetOrder("SBF","BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

Return NIL



/*           
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ AjustaSX1 ³ Autor ³ Ricardo Berti      ³ Data ³ 20/06/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Cria perguntas no SX1 para o grupo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AjustaSX1(ExpC1)		             	                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Grupo do pergunte 		                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATR280                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui pergunta no SX1                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutSX1(cPerg,"19","Lista Saldo em Estoque ?","","","mv_chk","N",1,0,0,"C","","","","","mv_par19","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",{"Lista saldo dos produtos na relacao","de itens para inventario."},{"",""},{"",""})
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MATR280R3³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Listagem do pre'-inventario                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fernando J. ³23/09/98³06744A³Incluir informa‡”oes de LOTE, SUB-LOTE e  ³±±
±±³            ³        ³      ³NUMERO DE SERIE.                          ³±±
±±³Rodrigo Sart³14/10/98³06744A³Correcao alteracao anterior               ³±±
±±³Fernando J. ³07/12/98³18726 ³Incluir Perguta Impr.Lote/S.Lote e N.Serie³±±
±±³Cesar       ³30/03/99³XXXXXX³Manutencao na SetPrint()                  ³±±
±±³Fernando J. ³28/05/99³XXXXXX³Correcao no Salto de Linha quando Imp.Lote³±±
±±³Marcelo Pim.³30/11/01³PYME  ³ Adequacao do fonte para utilizacao do    ³±±
±±³            ³        ³PYME  ³ Siga PyMe.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC Function Matr280R3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Tamanho 
Local Titulo   := STR0001	// 'Listagem para Inventario'
Local cDesc1   := STR0002	// 'Este programa emite um relatorio que facilita a digitacao'
Local cDesc2   := STR0003	// 'das quantidades inventariadas.'
Local cDesc3   := STR0004	// "Ele e' emitido de acordo com os parametros informados."
Local cString  := 'SB1'
Local aOrd     := {}
Local wnRel    := 'UMTR280'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {OemToAnsi(STR0009), 1,OemToAnsi(STR0010), 2, 2, 1, '',1 }   //'Zebrado'###'Administracao'
Private nLastKey := 0
Private cPerg    := 'MTR280'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento da Ordem para utilizacao do Siga Pyme             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !__lPyme
	aOrd := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0017)}   //' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '###' Por Endereco     '
Else
	aOrd := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008)}   //' Por Codigo         '###' Por Tipo           '###' Por Descricao    '###' Por Grupo        '
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Almox. de                                    ³
//³ mv_par02     // Almox. ate                                   ³
//³ mv_par03     // Produto de                                   ³
//³ mv_par04     // Produto ate                                  ³
//³ mv_par05     // tipo de                                      ³
//³ mv_par06     // tipo ate                                     ³
//³ mv_par07     // grupo de                                     ³
//³ mv_par08     // grupo ate                                    ³
//³ mv_par09     // descricao de                                 ³
//³ mv_par10     // descricao ate                                ³
//³ mv_par11     // data Selecao de                              ³
//³ mv_par12     // data Selecao ate                             ³
//³ mv_par13     // Imprime Lote/Sub-Lote e N£mero de S‚rie ?    ³
//³ mv_par14     // Lista Prod. C/ Sld Zerado ? (Sim/Nao)        ³
//³ mv_par15     // Do Endereco ?                                ³
//³ mv_par16     // Ate o Endereco ? (Sim/Nao)                   ³
//³ mv_par17     // Do Fornecedor ?                              ³
//³ mv_par18     // Ate o Fornecedor ? (Sim/Nao)                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1(cPerg)
Pergunte(cPerg,.F.)
//-- Define a variavel Tamanho de acordo com Impress„o ou N„o do Lote/Sub-Lote e N.S.
Tamanho := If(mv_par13 == 1,'G','M')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnRel:=SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	dbClearFilter()
	Return Nil
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return Nil
Endif

//-- Re-Define a variavel Tamanho de acordo com Impress„o ou N„o do Lote/Sub-Lote e N.S.
Tamanho := If(mv_par13 == 1,'G','M')

RptStatus({|lEnd| C280Imp(aOrd,@lEnd,wnRel,cString,Titulo,Tamanho)},Titulo)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ C280IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 11.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR280			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C280Imp(aOrd,lEnd,wnRel,cString,Titulo,Tamanho)

Local cRodaTxt  := STR0011 // 'PRODUTO(S)'
Local nCntImpr  := 0
Local ntipo     := 0
Local lRastro   := .F.
Local lRastroS  := .F.
Local lCLocal   := .F.
Local cDet      := '[            ]  [          ]   [            ]  [          ]   [            ]  [          ]'
Local cLoteAnt  := "" 
Local aCompra   := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Li      := 80
Private m_pag   := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCondicao  := ''
Private cCondicao1 := ''
Private lContinua  := .T.
Private lUsaLote   := If(GetMV('MV_RASTRO')=='S',.T.,.F.)
Private lImpLote   := If(mv_par13==1,.T.,.F.)

//-- Define Tamanho do Detalhe
If !lImpLote
	cDet := '[         ][     ][         ][     ][         ][     ]'
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona a ordem escolhida ao Titulo do relatorio          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type('NewHead') # 'U'
	NewHead += ' (' + AllTrim(aOrd[aReturn[8]]) + ')'
Else
	Titulo += ' (' + AllTrim(aOrd[aReturn[8]]) + ')'
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lImpLote
	Cabec1 := 'CODIGO          TP GRUPO DESCRICAO                      UM ALM DESCRICAO       LOCALIZACAO     LOTE       SUB    NUMERO           ______1a. CONTAGEM______       ______2a. CONTAGEM______       ______3a. CONTAGEM______'
	Cabec2 := '                                                               ALMOXARIFADO    FISICA                     LOTE   SERIE            QUANTIDADE      ETIQUETA       QUANTIDADE      ETIQUETA       QUANTIDADE      ETIQUETA'
	//--       123456789012345 12 1234  123456789012345678901234567890 12 12  123456789012345 123456789012345 1234567890 123456 12345678901234 [            ]  [          ]   [            ]  [          ]   [            ]  [          ]
	//--       0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
	//--       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Else
	Cabec1 := 'CODIGO          TP GRUP DESCRICAO                                           UM ALM LOCALIZACAO     1a. CONTAGEM ULT.COMPR. QT.CMP'
	Cabec2 := '                                                                                                                                 
EndIf
//--           123456789012345 12 1234 12345678956789012345678901234567890123456789012345  12 12  123456789012345 [          ] 99/99/9999 99999.99
//--           0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
//--           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os Arquivos e Ordens a serem utilizados           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//dbSelectArea('SB2')
//dbSetOrder(1)
U_MsSetOrder("SB2","B2_FILIAL+B2_COD+B2_LOCAL")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

//dbSelectArea('SB8')
//dbSetOrder(3)
U_MsSetOrder("SB8","B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                     

//dbSelectArea('SBF')
//dbSetOrder(2)
U_MsSetOrder("SBF","BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

dbSelectArea('SB1')
dbSetOrder(aReturn[8])

//If !__lPyme .And. aReturn[8] == 5
//	A280ImpEnd(aOrd,lEnd,wnRel,cString,Titulo,Tamanho)
//Else
	If aReturn[8] == 4
		SB1->(dbSeek(cFilial + mv_par07, .T.))
		cCondicao := 'lContinua .And. !Eof() .And. B1_GRUPO <= mv_par08'
	ElseIf aReturn[8] == 3
		SB1->(dbSeek(cFilial + mv_par09, .T.))
		cCondicao := 'lContinua .And. !Eof() .And. B1_DESC <= mv_par10'
	ElseIf aReturn[8] == 2
		SB1->(dbSeek(cFilial + mv_par05, .T.))
		cCondicao := 'lContinua .And. !Eof() .And. B1_TIPO <= mv_par06'
	ElseIf aReturn[8] == 1  
		SB1->(dbSeek(cFilial + mv_par03, .T.))
		cCondicao := 'lContinua .And. !Eof() .And. B1_COD <= mv_par04'
	ElseIf aReturn[8] == 5 //- Por endereco
        dbSetOrder(10)
		SB1->(dbSeek(cFilial + mv_par15, .T.))
		cCondicao := 'lContinua .And. !Eof() .And. B1_LOCAGRO <= mv_par16'
	Endif
	
	SetRegua(LastRec())
	
	While &(cCondicao) .And. SB1->B1_FILIAL == xFilial("SB1") //SB1->B1_FILIAL cFilial
		
		If lEnd
			@ pRow()+1, 001 PSAY STR0014 // 'CANCELADO PELO OPERADOR'
			Exit
		EndIf
		
		IncRegua()
		
		If !SB2->(dbSeek(xFilial('SB2') + SB1->B1_COD, .F.)) .Or. ;
			(SB1->B1_COD     < mv_par03) .Or. (SB1->B1_COD     > mv_par04) .Or. ;
			(SB1->B1_TIPO    < mv_par05) .Or. (SB1->B1_TIPO    > mv_par06) .Or. ;
			(SB1->B1_DESC    < mv_par09) .Or. (SB1->B1_DESC    > mv_par10) .Or. ;
			(SB1->B1_GRUPO   < mv_par07) .Or. (SB1->B1_GRUPO   > mv_par08) .Or. ;
			(SB1->B1_LOCAGRO < mv_par15) .Or. (SB1->B1_LOCAGRO > mv_par16) .Or. ;
			(SB1->B1_PROC    < mv_par17) .Or. (SB1->B1_PROC    > mv_par18)
			SB1->(dbSkip())
			Loop
		EndIf

        If SB1->B1_MSBLQL = "1"
			SB1->(dbSkip())
			Loop
        Endif

		
		lRastro  := Rastro(SB1->B1_COD)
		lRastroS := Rastro(SB1->B1_COD, 'S')
		lCLocal  := Localiza(SB1->B1_COD)
		
		While !SB2->(Eof()) .And. SB2->B2_FILIAL + SB2->B2_COD == xFilial('SB2') + SB1->B1_COD
			
			If lEnd
				@ pRow()+1, 001 PSAY STR0014 // 'CANCELADO PELO OPERADOR'
				lContinua := .F.
				Exit
			EndIf
			
			//If (!Empty(SB2->B2_DINVENT) .And. ;
			//	(((SB2->B2_DINVENT + SB1->B1_PERINV) < mv_par11) .Or. ;
			//	((SB2->B2_DINVENT + SB1->B1_PERINV) > mv_par12)))
			//	SB2->(dbSkip())
			//	Loop
			//EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica as consistencias de acordo com as perguntas         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (SB2->B2_LOCAL < mv_par01) .Or. (SB2->B2_LOCAL > mv_par02)
				SB2->(dbSkip())
				Loop
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o saldo estiver zerado (mv_par14 == 2 (Nao))     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par14 == 2 .And. SB2->B2_QATU == 0
				SB2->(dbSkip())
				Loop
			EndIf
			
			If Li > 55
				Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona 1 ao contador de registros impressos         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nCntImpr++
			
			f280ImpDet()
			
			If lCLocal .And. lImpLote .And.;
				SBF->(dbSeek(xFilial('SBF') + SB1->B1_COD + SB2->B2_LOCAL, .F.))
				Do While !SBF->(Eof()) .And. ;
					xFilial('SBF') + SB1->B1_COD + SB2->B2_LOCAL == SBF->BF_FILIAL + SBF->BF_PRODUTO + SBF->BF_LOCAL
					If Li > 55
						Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)
						f280ImpDet()
					EndIf
					@ Li, 079 PSAY Left(SBF->BF_LOCALIZ, 15)
					@ Li, 095 PSAY Left(SBF->BF_LOTECTL, 10)
					@ Li, 106 PSAY Left(SBF->BF_NUMLOTE, 06)
					@ Li, 113 PSAY Left(SBF->BF_NUMSERI, 14) + " "
					@ Li, 128 PSAY cDet
					Li++
					SBF->(dbSkip())
				EndDo
			ElseIf lRastro .And. lImpLote .And.;
				SB8->(dbSeek(xFilial('SB8') + SB1->B1_COD + SB2->B2_LOCAL, .F.))
				cLoteAnt   := ""
			
				cCondicao1 := 'SB8->B8_FILIAL + SB8->B8_PRODUTO + SB8->B8_LOCAL + SB8->B8_LOTECTL ' + If(lRastroS,'+ SB8->B8_NUMLOTE','')
				Do While !SB8->(Eof()) .And. ;
					xFilial('SB8') + SB1->B1_COD + SB2->B2_LOCAL + SB8->B8_LOTECTL + If(lRastroS,SB8->B8_NUMLOTE,'') == &(cCondicao1)
					If Li > 55
						Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)
						f280ImpDet()
					EndIf
                    If !(cLoteAnt==SB8->B8_LOTECTL) .Or. lRastroS
						@ Li, 095 PSAY Left(SB8->B8_LOTECTL,10)
						@ Li, 106 PSAY If(lRastroS,Left(SB8->B8_NUMLOTE,06),'')+" "
						@ Li, 128 PSAY cDet
						cLoteAnt := SB8->B8_LOTECTL
						Li++
					Endif	
					SB8->(dbSkip())
				EndDo
			Else
				If lImpLote
				    @ Li, 128 PSAY cDet
				Else   
  	                //CODIGO          TP GRUP DESCRICAO                                           UM ALM LOCALIZACAO     1a. CONTAGEM ULT.COMPR. QT.CMP'
                    //123456789012345 12 1234 12345678956789012345678901234567890123456789012345  12 12  123456789012345 [          ] 99/99/9999 99999.99
                    //0         1         2         3         4         5         6         7         8         9        10        11        12        13
                    //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
					
					//@ Li, 099  PSAY PADR(Posicione("SA2",1,xFilial("SA2")+SB1->B1_PROC,"A2_NREDUZ"),10) //cDet
					//If mv_par19 = 1 //- Lista saldo em estoque ?
					//   @ Li, 90  PSAY SB2->B2_QATU   Picture "@E 999,999.99"
					//Endif   
					//@ Li, 102 PSAY SB1->B1_ESTSEG Picture "@E 999,999.99" 
					
  			        aCompra:= UltCompra(SB1->B1_COD) 
					
					@ Li, 099 PSAY '[           ]'
					@ Li, 112 PSAY aCompra[1,1]
					@ Li, 123 PSAY aCompra[1,2] picture "@E 99999.99"  
				EndIf
				Li++
			EndIf
			SB2->(dbSkip())
		EndDo
		SB1->(dbSkip())
	Enddo
//EndIf
If Li # 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cString)
dbSetOrder(1)
dbClearFilter()

//SB1->(dbSetOrder(1))
//SB2->(dbSetOrder(1))
//SB8->(dbSetOrder(1))
//SBF->(dbSetOrder(1))
U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
U_MsSetOrder("SB2","B2_FILIAL+B2_COD+B2_LOCAL")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
U_MsSetOrder("SB8","B8_FILIAL+B8_PRODUTO+B8_LOCAL+DTOS(B8_DTVALID)+B8_LOTECTL+B8_NUMLOTE")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
U_MsSetOrder("SBF","BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnRel)
Endif

MS_FLUSH()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³f250ImpDet³ Autor ³ Fernando Joly Siquini ³ Data ³ 22.09.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ImpressÆo do Detalhe com os Dados do Produto               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR280			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function f280ImpDet()

If lImpLote
	@ Li, 000 PSAY Left(SB1->B1_COD     , 15)
	@ Li, 016 PSAY Left(SB1->B1_TIPO    , 02)
	@ Li, 019 PSAY Left(SB1->B1_GRUPO   , 04)
	@ Li, 025 PSAY Left(SB1->B1_DESC    , 30)
	@ Li, 056 PSAY Left(SB1->B1_UM      , 02)
	@ Li, 059 PSAY Left(SB2->B2_LOCAL   , 02)
	@ Li, 063 PSAY Left(SB1->B1_LOCAGRO , 15)
Else                      
    //CODIGO          TP GRUP DESCRICAO                                           UM ALM LOCALIZACAO     1a. CONTAGEM ULT.COMPR. QT.CMP'
    //123456789012345 12 1234 12345678956789012345678901234567890123456789012345  12 12  123456789012345 [          ] 99/99/9999 99999.99
    //0         1         2         3         4         5         6         7         8         9        10        11        12        13
    //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	@ Li, 000 PSAY Left(SB1->B1_COD     , 15)
	@ Li, 016 PSAY Left(SB1->B1_TIPO    , 02)
	@ Li, 019 PSAY Left(SB1->B1_GRUPO   , 04)
	@ Li, 024 PSAY Left(SB1->B1_DESC    , 50)
	@ Li, 076 PSAY Left(SB1->B1_UM      , 02)
	@ Li, 079 PSAY Left(SB2->B2_LOCAL   , 02)
	@ Li, 083 PSAY Left(SB1->B1_LOCAGRO , 15)
EndIf
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A280IMPEND³ Autor ³ Larson Zordan         ³ Data ³ 23.11.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relatorio Para a opcao de Endereco+Produto      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR280		                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A280ImpEnd(aOrd,lEnd,wnRel,cString,Titulo,Tamanho)

Local cRodaTxt   := STR0011 // 'PRODUTO(S)'
Local nCntImpr   := 0
Local ntipo      := 0
Local lRastro    := .F.
Local lRastroS   := .F.
Local lCLocal    := .F.
Local cDet       := '[            ]  [          ]   [            ]  [          ]   [            ]  [          ]'

SB1->(dbSetOrder(1))
U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

dbSelectArea("SBE")
//SBE->(dbSetOrder(1))
U_MsSetOrder("SBE","BE_FILIAL+BE_LOCAL+BE_LOCALIZ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
SBE-(dbGotop())
SetRegua(LastRec())

While !Eof() .And. BE_FILIAL == xFilial("SBE")
	
	If lEnd
		@ pRow()+1, 001 PSAY STR0014 // 'CANCELADO PELO OPERADOR'
		Exit
	EndIf
	
	IncRegua()
	
	If (BE_LOCAL < mv_par01) .Or. (BE_LOCAL > mv_par02)
		dbSkip()
		Loop
	EndIf

//	SBF->(dbSetOrder(1))	
	U_MsSetOrder("SBF","BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
	SBF->(dbSeek(xFilial('SBF')+SBE->BE_LOCAL+SBE->BE_LOCALIZ,.F.))
	
	While !SBF->(Eof()) .And. xFilial('SBF')+SBE->BE_LOCAL+SBE->BE_LOCALIZ == SBF->BF_FILIAL+SBF->BF_LOCAL+SBF->BF_LOCALIZ
		
		If lEnd
			@ pRow()+1, 001 PSAY STR0014 // 'CANCELADO PELO OPERADOR'
			lContinua := .F.
			Exit
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica as consistencias de acordo com as perguntas         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SBF->BF_PRODUTO < mv_par03 .Or. SBF->BF_PRODUTO > mv_par04
			SBF->(dbSkip())
			Loop
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o saldo estiver zerado (mv_par14 == 2 (Nao))     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par14 == 2 .And. SBF->BF_QUANT == 0
			SBF->(dbSkip())
			Loop
		EndIf

		SB1->(dbSeek(xFilial('SB1')+SBF->BF_PRODUTO,.F.))

		If 	(SB1->B1_TIPO    < mv_par05) .Or. (SB1->B1_TIPO    > mv_par06) .Or. ;
			(SB1->B1_DESC    < mv_par09) .Or. (SB1->B1_DESC    > mv_par10) .Or. ;
			(SB1->B1_GRUPO   < mv_par07) .Or. (SB1->B1_GRUPO   > mv_par08) .Or. ;
			(SB1->B1_LOCAGRO < mv_par15) .Or. (SB1->B1_LOCAGRO > mv_par16)
			SBF->(dbSkip())
			Loop
		EndIf

		SB2->(dbSeek(xFilial('SB2')+SBF->BF_PRODUTO+SBF->BF_LOCAL,.F.))
		
		If (!Empty(SB2->B2_DINVENT) .And. ;
			(((SB2->B2_DINVENT + SB1->B1_PERINV) < mv_par11) .Or. ;
			((SB2->B2_DINVENT + SB1->B1_PERINV) > mv_par12)))
			SBF->(dbSkip())
			Loop
		EndIf

		lRastro  := Rastro(SBF->BF_PRODUTO)
		lRastroS := Rastro(SBF->BF_PRODUTO, 'S')
		lCLocal  := Localiza(SBF->BF_PRODUTO)
		
		If Li > 55
			Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona 1 ao contador de registros impressos         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCntImpr++
		
		f280ImpDet()
		
		If lCLocal .And. lImpLote 
			If Li > 55
				Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)
				f280ImpDet()
			EndIf
			@ Li, 079 PSAY Left(SBF->BF_LOCALIZ, 15)
			@ Li, 095 PSAY Left(SBF->BF_LOTECTL, 10)
			@ Li, 106 PSAY Left(SBF->BF_NUMLOTE, 06)
			@ Li, 113 PSAY Left(SBF->BF_NUMSERI, 14)+" "
			@ Li, 128 PSAY cDet
			Li++
		ElseIf lRastro .And. lImpLote .And.;
			SB8->(dbSeek(xFilial('SB8') + SB1->B1_COD + SB2->B2_LOCAL, .F.))
			cCondicao1 := 'SB8->B8_FILIAL + SB8->B8_PRODUTO + SB8->B8_LOCAL + SB8->B8_LOTECTL ' + If(lRastroS,'+ SB8->B8_NUMLOTE','')
			Do While !SB8->(Eof()) .And. ;
				xFilial('SB8') + SB1->B1_COD + SB2->B2_LOCAL + SB8->B8_LOTECTL + If(lRastroS,SB8->B8_NUMLOTE,'') == &(cCondicao1)
				If Li > 55
					Cabec(Titulo,Cabec1,Cabec2,wnRel,Tamanho,nTipo)
					f280ImpDet()
				EndIf
				@ Li, 095 PSAY Left(SB8->B8_LOTECTL,10)
				@ Li, 106 PSAY If(lRastroS,Left(SB8->B8_NUMLOTE,06),'')+" "
				@ Li, 128 PSAY cDet
				Li++
				SB8->(dbSkip())
			EndDo
		Else
			If lImpLote
				@ Li, 128 PSAY cDet
			Else
				@ Li, 79 PSAY cDet
			EndIf
			Li++
		EndIf
		
		SBF->(dbSkip())
		
	EndDo
	
	SBE->(dbSkip())

EndDo
Return Nil                                       

////////////////////////////////
Static Function UltCompra(cCod)
  
  Local cAlias:= Alias()
  Local cQry:="", cDtUltCmp:="",i:=0, aCompra:= {} 
  
  cQry := "SELECT TOP 1 D1_COD, D1_QUANT, F1_DTDIGIT "
  cQry += "FROM "
  cQry += RetSQLName("SF1")+" SF1, "
  cQry += RetSQLName("SD1")+" SD1, "
  cQry += RetSQLName("SB1")+" SB1, "
  cQry += RetSQLName("SA2")+" SA2, "
  cQry += RetSQLName("SF4")+" SF4  "            
  cQry += "WHERE SF1.D_E_L_E_T_ <> '*' "
  cQry += "AND SD1.D_E_L_E_T_ <> '*' "  
  cQry += "AND SB1.D_E_L_E_T_ <> '*' "  
  cQry += "AND SA2.D_E_L_E_T_ <> '*' "  
  cQry += "AND SF4.D_E_L_E_T_ <> '*' "  
  cQry += "AND SF1.F1_FILIAL = '"+xFilial("SF1")+"' " 
  cQry += "AND SD1.D1_FILIAL = '"+xFilial("SD1")+"' "
  cQry += "AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
  cQry += "AND SA2.A2_FILIAL = '"+xFilial("SA2")+"' "
  cQry += "AND SF4.F4_FILIAL = '"+xFilial("SF4")+"' "
  cQry += "AND SD1.D1_DOC = SF1.F1_DOC "
  cQry += "AND SD1.D1_SERIE = SF1.F1_SERIE " 
  cQry += "AND SD1.D1_FORNECE = SF1.F1_FORNECE " 
  cQry += "AND SD1.D1_LOJA = SF1.F1_LOJA "    
  cQry += "AND SD1.D1_QUANT > 0 "    
  cQry += "AND SD1.D1_TIPO NOT IN ('D','B') " 
  cQry += "AND NOT (SD1.D1_TIPODOC >= '50' ) " 
  cQry += "AND SB1.B1_COD = SD1.D1_COD " 
  cQry += "AND SF4.F4_CODIGO = SD1.D1_TES " 
  cQry += "AND SA2.A2_COD = SD1.D1_FORNECE " 
  cQry += "AND SA2.A2_LOJA = SD1.D1_LOJA " 
  cQry += "AND D1_COD = '"+cCod+"' "
  cQry += "ORDER BY F1_DTDIGIT DESC" 

  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )  
  
  TcSetField("TRB" , "F1_DTDIGIT", "D", 8, 0)  // Formata para tipo Data
                      
  TRB->(dbGotop())                         
                         
  aCompra:= {}
  
  AADD(aCompra,{"__/__/____",0.00 })
     
  If !TRB->(Eof())
     aCompra[1,1] := TRB->F1_DTDIGIT
     aCompra[1,2] := TRB->D1_QUANT
  Endif           

  TRB->(dbCloseArea())

  dbselectArea(cAlias)

Return aCompra

//-- 151/C-12