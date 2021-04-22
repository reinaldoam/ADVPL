#INCLUDE "PROTHEUS.CH"
#INCLUDE "LOJR075.CH"
#INCLUDE "REPORT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LOJR075   º Autor ³ Fernando Salvatori º Data ³  20/01/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Mapa de Vendas                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º              ³        ³      ³                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function ULjr075()
Local oReport
Local aArea := GetArea()

If !FindFunction("TRepInUse") .OR. !TRepInUse()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa versao anterior do fonte³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Lojr075R3()
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³MV_PAR01 -> Filial de          ?³
	//³MV_PAR02 -> Filial ate         ?³
	//³MV_PAR03 -> Data de            ?³
	//³MV_PAR04 -> Data ate           ?³
	//³MV_PAR05 -> Caixa de           ?³
	//³MV_PAR06 -> Caixa ate          ?³
	//³MV_PAR07 -> Considera Devolução?³
	//³MV_PAR08 -> Formas de Pgto     ?³
	//³MV_PAR09 -> Qual moeda         ?³
	//³MV_PAR10 -> Outras Moedas      ?³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Pergunte("LJR075",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := Ljr075RptDef()
	oReport:PrintDialog()
EndIf

RestArea( aArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LOJR075   º Autor ³ Fernando Salvatori º Data ³  20/01/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Mapa de Vendas                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFernando S.   ³06/05/03³MELHOR³Inclusao do parametro MV_PAR08 que tem  º±±
±±º              ³        ³      ³por objetivo, selecionar as formas de   º±±
±±º              ³        ³      ³pagto. que deseja imprimir. Corrigido   º±±
±±º              ³        ³      ³tambem a soma do valor total, onde nao  º±±
±±º              ³        ³      ³estava considerando o cartao de debito. º±±
±±ºMachima       ³15/08/03³MELHOR³Localizacao do relatorio considerando a º±±
±±º              ³        ³      ³moeda e Lay-Away(Loc. EUA/POR)          º±±
±±ºFernando S.   ³13/05/04³MELHOR³Inclusao de nova coluna de impostos paraº±±
±±º              ³        ³      ³discriminar as retencoes de impostos-PISº±±
±±ºMarcio L.     ³12/07/06³102897³Ajuste do cabecalho e da apuracao do    º±±
±±º              ³        ³      ³imposto no ambiente localizado.         º±±
±±ºDolis         ³21/08/06³104382³Tratamento para quando estiver  utilizanº±±
±±º              ³        ³      ³do TOP e existir o campo L1_TROCO1 colo-º±±
±±º              ³        ³      ³car no group by da query                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function LOJR075R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := STR0001				//"Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := STR0002				//"de acordo com os parametros informados pelo usuario."
Local cDesc3         := STR0003				//"Mapa de Vendas"
Local titulo         := STR0003				//"Mapa de Vendas"
Local nLin           := 80
Local aOrd           := ""
Local Cabec1         := ""
Local Cabec2         := ""
Local cPerg          := "LJR075"			// Pergunte que eh chamado no relatorio
Local lUsaQuery      := .F.					// Verifica se o sistema esta trabalhando com Query
Local cArqTmp        := ""					// Arquivo Temporario
Local lUsaNMov       := .F.                //  Verica se foi criado MV_PAR11
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 220
Private tamanho      := "G"					// Tamanho do relatorio
Private nomeprog     := "LOJR075"			// Nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { STR0004, 1, STR0005, 1, 2, 1, "", 1}//"Zebrado"//"Administracao"
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "LOJR075"			// Nome do arquivo usado para impressao em disco
Private lVlrPisCof   := SL1->(FieldPos("L1_ABTOPCC")) > 0
Private lTroco       := SuperGetMV("MV_LJTRLOC",,.F.) .AND. SL1->(FieldPos("L1_TROCO1")) > 0 .AND. cPaisLoc <> "BRA"


dbSelectArea("SE5")
dbSelectArea("SF1")
dbSelectArea("SL1")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parametros do relatorio: LJR075 ³
//³                                ³
//³MV_PAR01 -> Filial de          ?³
//³MV_PAR02 -> Filial ate         ?³
//³MV_PAR03 -> Data de            ?³
//³MV_PAR04 -> Data ate           ?³
//³MV_PAR05 -> Caixa de           ?³
//³MV_PAR06 -> Caixa ate          ?³
//³MV_PAR07 -> Considera Devolução?³
//³MV_PAR08 -> Formas de Pgto     ?³
//³MV_PAR09 -> Qual moeda         ?³
//³MV_PAR10 -> Outras Moedas      ?³
//³MV_PAR11 -> Numero do Movimento?³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pergunta que define o numero do movimento - (Somente se houver a tabela Os Campos nas Tabelas SL1, SE5 e SF1)																  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If SL1->(FieldPos("L1_NUMMOV")>0) .AND. SE5->(FieldPos("E5_NUMMOV")>0) .AND. SF1->(FieldPos("F1_NUMMOV")>0)
	PutSx1( cPerg      ,"11"     ,"Numero do Movimento?         ","Numero do Movimento?"            ,"Numero do Movimento?"            , ;
	       "mv_ch11"    ,"N"      ,2                              ,0                                 ,0                                 , ;
	       "G"         ,""       ,  ""                           ,""                                ,""                                , ;
	       "mv_par11"  ,""       , ""                            ,""                                ,""                                , ;
	       ""          ,""       ,""                             ,""                                ,""                                , ;
	       ""          ,""       ,""                             ,""                                ,""                                , ;
	       ""          ,""       ,                               ,                                  ,        )
	       lUsaNMov := .T.
Endif	
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(	"SL1" , NomeProg, cPerg 	, @titulo, ;
					cDesc1, cDesc2  , cDesc3	, .F.    , ;
					aOrd  , .T.    	, Tamanho	,, .T.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,"SL1")

If nLastKey == 27
	Return
EndIf

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se utiliza Query³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	If 	UPPER(TcGetDb()) <> "DB2"
		lUsaQuery := .T.
	EndIf
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Geracao dos dados para impressao.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| LJ075GeraTmp(lUsaQuery,@cArqTmp,lUsaNMov)}, STR0006 )//"Aguarde"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do relatorio.                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| LJ075Imprime(	Cabec1		, Cabec2, Titulo, nLin, ;
							lUsaQuery	, cArqTmp ) } ,Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LJ075GeraTº Autor ³ Fernando Salvatori º Data ³  20/01/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Gera filtro/arquivo temporario para uso do relatorio.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºGeronimo Alves³13/10/05³086647³Correção para na devolucao na coluna    º±±
±±º              ³        ³      ³Total, somar tambem os impostos         º±±
±±ºHanna Caroline³11/10/05³087020³Inclusao do calculo do troco, no caso deº±±
±±º              ³        ³      ³pagamentos em dinheiro                  º±±
±±ºGeronimo Alves³05/12/05³089250³Implementacao continua, corrigido rela- º±±
±±º              ³        ³      ³cionamento entre tabelas SD1xSL2 atravezº±±
±±º              ³        ³      ³dos campos D1_NUMSEQ e L2_ITEMSD1.      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJ075GeraTmp(lUsaQuery, cArqTmp, lUsaNMov)
Local cQuery     := ""							//Query para montagem do filtro
Local cSeekWhile := ""							//Chave para Loop
Local cIndSL1    := ""							//IndRegua para o SL1
Local cIndSF1    := ""							//IndRegua para o SF1
Local cIndSE5    := ""							//IndRegua para o SE5
Local cCampoTr   := ""
Local aCampos    := {}							//Campos da estrutura DBF
Local aTam       := {}                          //Retorno da funcao TamSX3 para campos DBF
Local aStruTRB   := {}                          //Array com os campos do TRB do tipo Data e Numerico para o comando TCSetField
Local nValDesc   := 0                           //Valor do Desconto
Local nValDProp  := 0							//Valor do Desconto Proporcional
Local nMoeda     := 1                           //Moeda de transacao(venda/devolucao) - Localizacoes
Local nX         := 0							// Variavel do for
Local nVlrTroco  := 0
Local nY
Local nDecs      := 2
Local lSLOExcl   := .F.                         //Define se os registros do arq. SLO estao excluidos(LayAway-Porto Rico/EUA)
Local lSLPExcl   := .F.                         //Define se os registros do arq. SLP estao excluidos(LayAway-Porto Rico/EUA)
Local lUsaPCC    := ( SL2->(FieldPos("L2_VALPIS")) > 0 .AND. SL2->(FieldPos("L2_VALCOFI")) > 0 .AND. SL2->(FieldPos("L2_VALCOFI")) > 0 )
Local nTotal     := 0
Local nPerc      := 0
Local lpTPAbISS  := ( GetNewPar("MV_TPABISS", "1") == "2" )
Local nRestDiv   := 0
Local aTemp      := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se usa Query³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lUsaQuery
	ProcRegua( 4 )
	
	IncProc(STR0007);IncProc(STR0007)//"Selecionando registros para impressão..."
	
	LJ075aStru(@aStruTRB)
	
	cQuery := "SELECT DISTINCT "
	
	cQuery += "' ' LDEV ,"
	cQuery += "SL1.L1_FILIAL   FILIAL  ,"
	cQuery += "SL1.L1_EMISNF   DTEMI   ,"
	cQuery += "SL1.L1_DOC      N_FISCAL,"
	cQuery += "SL1.L1_SERIE    SERIE   ,"
	cQuery += "SL1.L1_DOCPED   N_FISCPED,"
	cQuery += "SL1.L1_SERPED   SERPED  ,"
	cQuery += "SL1.L1_VEND     VENDED  ,"
	cQuery += "SA3.A3_NREDUZ   NOME    ,"
	cQuery += "SL1.L1_CLIENTE  CLIENTE ,"
	cQuery += "SL1.L1_LOJA     LOJA    ,"
	cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"
	cQuery += "SL1.L1_VLRTOT   VLRTOT  ,"
	cQuery += "SL1.L1_OPERADO  CAIXA   ,"
	If SL1->( FieldPos ( "L1_TROCO1" ) ) > 0 .AND. cPaisLoc == "BRA"
		cQuery += "(SL1.L1_DINHEIR - SL1.L1_TROCO1) DINHEIRO,"
	Else
		cQuery += "SL1.L1_DINHEIR  DINHEIRO,"
	EndIf
	cQuery += "SL1.L1_CHEQUES  CHEQUES ,"
	cQuery += "SL1.L1_CARTAO   CARTAO  ,"
	cQuery += "SL1.L1_VLRDEBI  VLRDEBI ,"
	cQuery += "SL1.L1_CONVENI  CONVENIO,"
	cQuery += "SL1.L1_VALES    VALES   ,"
	cQuery += "SL1.L1_FINANC   FINANC  ,"
	cQuery += "SL1.L1_OUTROS   OUTROS  ,"
	cQuery += "SL1.L1_CREDITO  CREDITO ,"
	cQuery += "SL1.L1_VALISS   VALISS  ,"
	
	cQuery += "(SUM(SL2.L2_VALDESC) + SUM(SL2.L2_DESCPRO)) DESCON ,"
	cQuery += "(SL1.L1_VLRTOT  - SL1.L1_VALMERC) ACRES "
	
	If cPaisLoc <> "BRA"
		cQuery += ", SL1.L1_MOEDA  MOEDA,  "
		cQuery += "' '             LAYAWAY,"
		cQuery += "'   '           HISTOR  "
		If lTroco
			cQuery += ", SL1.L1_TROCO1  TROCO1, "
			cQuery += " SL1.L1_TROCO2  TROCO2,  "
			cQuery += " SL1.L1_TROCO3  TROCO3,  "
			cQuery += " SL1.L1_TROCO4  TROCO4,  "
			cQuery += " SL1.L1_TROCO5  TROCO5   "
		EndIf
	EndIf
	
	If lVlrPisCof
		cQuery += ", SL1.L1_ABTOPCC ABTOPCC "
	EndIf
	
	cQuery += "FROM "+RetSQLName("SL1")+" SL1, "
	cQuery += RetSQLName("SL2")+" SL2, "
	cQuery += RetSQLName("SA1")+" SA1, "
	cQuery += RetSQLName("SA3")+" SA3 "
	
	cQuery += "WHERE "
	
	cQuery += "SA1.A1_FILIAL = '"+ xFilial( "SA1" ) +"' "
	cQuery += "AND SA1.A1_COD = SL1.L1_CLIENTE "
	cQuery += "AND SA1.A1_LOJA = SL1.L1_LOJA "
	
	cQuery += "AND SA3.A3_FILIAL = '"+ xFilial( "SA3" ) +"' "
	cQuery += "AND SA3.A3_COD = SL1.L1_VEND "
	
	cQuery += "AND SL1.L1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	
	cQuery += " AND (((SL1.L1_TIPO = 'V' AND SL1.L1_DOC <> '' AND SL1.L1_ORCRES = '') OR (SL1.L1_TIPO = 'P' AND SL1.L1_DOCPED <> ''))) "
	
	cQuery += "AND SL1.L1_EMISNF  BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "
	cQuery += "AND SL1.L1_OPERADO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	
	cQuery += "AND SL2.L2_FILIAL = SL1.L1_FILIAL "
	cQuery += "AND SL2.L2_NUM = SL1.L1_NUM "
	
	If cPaisLoc $ "POR|EUA"
		cQuery += " AND L1_CONDPG <> 'LAY' "	  //Desprezar as finalizacoes de Lay-Away
	EndIf
	
	If lUsaNMov
		If MV_PAR11 > 0 // Filtra Somente Quando For Informado o Numero do Movimento
			cQuery += " AND SL1.L1_NUMMOV = " + AllTrim(Str(MV_PAR11) )
		Endif
	Endif
	cQuery += "AND SL1.D_E_L_E_T_ <> '*' "
	cQuery += "AND SL2.D_E_L_E_T_ <> '*' "
	cQuery += "AND SA1.D_E_L_E_T_ <> '*' "
	cQuery += "AND SA3.D_E_L_E_T_ <> '*' "
	
	cQuery += "GROUP BY "
	cQuery += "SL1.L1_FILIAL, "
	cQuery += "SL1.L1_EMISNF, "
	cQuery += "SL1.L1_DOC, "
	cQuery += "SL1.L1_SERIE , "
	cQuery += "SL1.L1_DOCPED, "
	cQuery += "SL1.L1_SERPED, "
	cQuery += "SL1.L1_VEND , "
	cQuery += "SA3.A3_NREDUZ , "
	cQuery += "SL1.L1_CLIENTE , "
	cQuery += "SL1.L1_LOJA , "
	cQuery += "SA1.A1_NREDUZ , "
	cQuery += "SL1.L1_VLRTOT , "
	cQuery += "SL1.L1_VALMERC , "
	cQuery += "SL1.L1_OPERADO , "
	cQuery += "SL1.L1_DINHEIR , "
	cQuery += "SL1.L1_CHEQUES , "
	cQuery += "SL1.L1_CARTAO , 	"
	cQuery += "SL1.L1_VLRDEBI ,"
	cQuery += "SL1.L1_CONVENI , "
	cQuery += "SL1.L1_VALES , "
	cQuery += "SL1.L1_FINANC , "
	cQuery += "SL1.L1_OUTROS , "
	cQuery += "SL1.L1_CREDITO, "
	cQuery += "SL1.L1_VALISS "
	If cPaisLoc <> "BRA"
		cQuery += ", SL1.L1_MOEDA "
		
		If lTroco
			cQuery += ", SL1.L1_TROCO1, "
			cQuery += " SL1.L1_TROCO2 ,  "
			cQuery += " SL1.L1_TROCO3 ,  "
			cQuery += " SL1.L1_TROCO4 ,  "
			cQuery += " SL1.L1_TROCO5    "
		EndIf
	ElseIf SL1->( FieldPos ( "L1_TROCO1" ) ) > 0
		cQuery += ", SL1.L1_TROCO1 "
	EndIf
	
	If lVlrPisCof
		cQuery += ", SL1.L1_ABTOPCC "
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recebimento por Lay-Away(Porto Rico/EUA)      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc $ "POR|EUA"
		cQuery += "UNION ALL "
		
		cQuery += "SELECT DISTINCT "
		cQuery += "' ' LDEV ,"
		cQuery += "SLO.LO_FILIAL   FILIAL  ,"
		cQuery += "SE5.E5_DATA     DTEMI   ,"
		cQuery += "SLO.LO_NUMLAY   N_FISCAL,"
		cQuery += "SE5.E5_PREFIXO  SERIE   ,"
		cQuery += "'      '   N_FISCPED,"
		cQuery += "'   '      SERPED  ,"
		cQuery += "'      '        VENDED  ,"
		cQuery += "'               ' NOME  ,"
		cQuery += "SE5.E5_CLIFOR   CLIENTE ,"
		cQuery += "SE5.E5_LOJA     LOJA    ,"
		cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"
		cQuery += "SE5.E5_VALOR    VLRTOT  ,"
		cQuery += "SE5.E5_BANCO    CAIXA   ,"
		cQuery += "0.00            DINHEIRO,"
		cQuery += "0.00            CHEQUES ,"
		cQuery += "0.00            CARTAO  ,"
		cQuery += "0.00            VLRDEBI ,"
		cQuery += "0.00            CONVENIO,"
		cQuery += "0.00            VALES   ,"
		cQuery += "0.00            FINANC  ,"
		cQuery += "0.00            OUTROS  ,"
		cQuery += "0.00            CREDITO ,"
		cQuery += "0.00            VALISS  ,"
		cQuery += "0.00            DESCON  ,"
		cQuery += "0.00            ACRES   ,"
		cQuery += "SLO.LO_MOEDA    MOEDA   ,"
		cQuery += "'S'             LAYAWAY ,"
		If !( AllTrim( Upper( TcGetDb() ) ) $ "ORACLE_INFORMIX" )
			cQuery += "SUBSTRING(SE5.E5_HISTOR,1,3) HISTOR "
		Else
			cQuery += "SUBSTR(SE5.E5_HISTOR,1,3) HISTOR    "
		EndIf
		
		cQuery += " FROM "+ RetSqlName("SE5") + " SE5,"
		cQuery += RetSqlName("SLO") + " SLO,"
		cQuery += RetSqlName("SLP") + " SLP,"
		cQuery += RetSqlName("SA1") + " SA1"
		
		cQuery += " WHERE "
		
		cQuery += "  SE5.E5_PREFIXO = SLP.LP_PREFIXO AND "   //SE5 x SLP
		cQuery += "  SE5.E5_NUMERO = SLP.LP_NUME1 AND "
		cQuery += "  SE5.E5_PARCELA = SLP.LP_PARCELA AND "
		
		cQuery += "  SE5.E5_CLIFOR = SLO.LO_CLIENTE AND "	 //SLO x SE5
		cQuery += "  SE5.E5_LOJA = SLO.LO_LOJA AND "
		
		cQuery += "  SLP.LP_FILIAL = SLO.LO_FILIAL AND "	    //SLO x SLP
		cQuery += "  SLP.LP_NUMLAY = SLO.LO_NUMLAY AND "
		
		cQuery += "  SA1.A1_FILIAL = '"+ xFilial( "SA1" ) +"' AND "	 //SLO x SA1
		cQuery += "  SLO.LO_CLIENTE = SA1.A1_COD AND "
		cQuery += "  SLO.LO_LOJA = SA1.A1_LOJA AND "
		
		cQuery += "  (SE5.E5_PREFIXO = '"+ &(SuperGetMv("MV_LWPREF1")) +"' AND SE5.E5_TIPO = 'RA ' AND SE5.E5_RECPAG = 'R' AND SE5.E5_TIPODOC = 'RA') AND "    //LayAway - recebimento
		
		cQuery += "  SLO.LO_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND "
		cQuery += "  SE5.E5_DATA  BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' AND "
		cQuery += "  SE5.E5_BANCO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		
		If lUsaNMov		
			If MV_PAR11 > 0 // Filtra Somente Quando For Informado o Numero do Movimento
				cQuery += " AND SE5.E5_NUMMOV = " + AllTrim(Str(MV_PAR11) )		
			Endif
		Endif
		cQuery += "AND SLO.D_E_L_E_T_ <> '*' "
		cQuery += "AND SLP.D_E_L_E_T_ <> '*' "
		cQuery += "AND SA1.D_E_L_E_T_ <> '*' "
		cQuery += "AND SE5.D_E_L_E_T_ <> '*' "
		
		//Contemplar os casos em que o Lay-Away eh anulado no mesmo dia de seu cadastro.
		//Deve considerar o recebimento inicial feito na inclusao do Lay-Away, que serah
		//compensado com o cancelamento selecionado abaixo
		cQuery += "UNION ALL "
		
		cQuery += "SELECT DISTINCT "
		cQuery += "' ' LDEV ,"
		cQuery += "SE5.E5_FILIAL   FILIAL  ,"
		cQuery += "SE5.E5_DATA     DTEMI   ,"
		cQuery += "SLO.LO_NUMLAY   N_FISCAL,"
		cQuery += "SE5.E5_PREFIXO  SERIE   ,"
		cQuery += "'      '   N_FISCPED,"
		cQuery += "'   '      SERPED  ,"
		cQuery += "'      '        VENDED  ,"
		cQuery += "'               ' NOME  ,"
		cQuery += "SE5.E5_CLIFOR   CLIENTE ,"
		cQuery += "SE5.E5_LOJA     LOJA    ,"
		cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"
		cQuery += "SE5.E5_VALOR    VLRTOT  ,"
		cQuery += "SE5.E5_BANCO    CAIXA   ,"
		cQuery += "0.00            DINHEIRO,"
		cQuery += "0.00            CHEQUES ,"
		cQuery += "0.00            CARTAO  ,"
		cQuery += "0.00            VLRDEBI ,"
		cQuery += "0.00            CONVENIO,"
		cQuery += "0.00            VALES   ,"
		cQuery += "0.00            FINANC  ,"
		cQuery += "0.00            OUTROS  ,"
		cQuery += "0.00            CREDITO ,"
		cQuery += "0.00            VALISS  ,"
		cQuery += "0.00            DESCON  ,"
		cQuery += "0.00            ACRES   ,"
		cQuery += "SLO.LO_MOEDA    MOEDA   ,"
		cQuery += "'S'             LAYAWAY ,"
		If !( AllTrim( Upper( TcGetDb() ) ) $ "ORACLE_INFORMIX" )
			cQuery += "SUBSTRING(SE5.E5_HISTOR,1,3) HISTOR "
		Else
			cQuery += "SUBSTR(SE5.E5_HISTOR,1,3) HISTOR    "
		EndIf
		
		cQuery += "FROM "+RetSqlName("SLO") + " SLO,"
		cQuery += RetSqlName("SLP") + " SLP,"
		cQuery += RetSqlName("SE5") + " SE5,"
		cQuery += RetSqlName("SA1") + " SA1 "
		
		cQuery += " WHERE "
		
		cQuery += "  SLO.LO_STATUS = '4' AND"               //Lay-Away anulado
		
		cQuery += "  SLO.LO_NUMLAY = SLP.LP_NUMLAY AND"     //SLO x SLP
		cQuery += "  SLO.LO_FILIAL = SLP.LP_FILIAL AND"
		
		cQuery += "  SLP.LP_PREFIXO = SE5.E5_PREFIXO AND"   //SLP x SE5
		cQuery += "  SLP.LP_NUME1 = SE5.E5_NUMERO AND"
		cQuery += "  SLP.LP_PARCELA = SE5.E5_PARCELA AND"
		cQuery += "  SLP.LP_TIPOE1 = SE5.E5_TIPO AND"
		
		cQuery += "  SLO.LO_CLIENTE = SE5.E5_CLIFOR AND"	   //SLO x SE5
		cQuery += "  SLO.LO_LOJA = SE5.E5_LOJA AND"
		
		cQuery += "  SA1.A1_FILIAL = '"+ xFilial( "SA1" ) +"' AND "	//SLO x SA1
		cQuery += "  SLO.LO_CLIENTE = SA1.A1_COD AND"
		cQuery += "  SLO.LO_LOJA = SA1.A1_LOJA AND"
		
		cQuery += " (SE5.E5_DATA BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "') AND "
		cQuery += " (SE5.E5_BANCO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "') AND "
		
		cQuery += " (SE5.E5_PREFIXO = '"+ &(SuperGetMv("MV_LWPREF1")) +"' AND SE5.E5_TIPO = 'RA ' AND SE5.E5_TIPODOC = 'RA' AND E5_RECPAG = 'R') AND "    //Recebimento de Lay-Away
		
		If lUsaNMov
			If MV_PAR11 > 0 // Filtra Somente Quando For Informado o Numero do Movimento
				cQuery += " AND SE5.E5_NUMMOV = " + AllTrim(Str(MV_PAR11) )		
			Endif    
		Endif
		cQuery += " SLO.D_E_L_E_T_<>'*' AND"
		cQuery += " SE5.D_E_L_E_T_<>'*' AND"
		cQuery += " SA1.D_E_L_E_T_<>'*' "
		//Nao verificar o arq. SLP porque eh excluido no cancelamento de Lay-Away
		
	EndIf
	
	If MV_PAR07 == 1
		
		cQuery += "UNION ALL "
		
		cQuery += "SELECT DISTINCT "
		cQuery += "'|' LDEV              ,"
		cQuery += "SF1.F1_FILIAL   FILIAL   ,"
		cQuery += "SF1.F1_EMISSAO  DTEMI    ,"
		cQuery += "SF1.F1_DOC      N_FISCAL ,"
		cQuery += "SF1.F1_SERIE    SERIE    ,"
		cQuery += "'      '   N_FISCPED,"
		cQuery += "'   '      SERPED  ,"
		cQuery += "''           VENDED   ,"
		cQuery += "''  		   NOME     ,"
		cQuery += "SF1.F1_FORNECE  CLIENTE  ,"
		cQuery += "SF1.F1_LOJA	   LOJA     ,"
		cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"
		
		If lUsaPCC
			
			cQuery += "SUM(( SD1.D1_TOTAL + SD1.D1_VALIPI ) - ( ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI ) * " + ;
			"( ( SL2.L2_VALPIS / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) + ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI ) * " + ;
			"( ( SL2.L2_VALCOFI / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) + ( ( ( SD1.D1_TOTAL + SD1.D1_VALIPI ) * " + ;
			"( ( SL2.L2_VALCSLL / SL2.L2_VLRITEM ) * 100 ) ) / 100 ) ) + ( SD1.D1_VALIMP1 + SD1.D1_VALIMP2 + SD1.D1_VALIMP3 + SD1.D1_VALIMP4 + SD1.D1_VALIMP5 ) ) VLRTOT ,"
			
		Else
			
			cQuery += "SUM(SD1.D1_TOTAL + SD1.D1_VALIPI + SD1.D1_VALIMP1 + SD1.D1_VALIMP2 + SD1.D1_VALIMP3 + SD1.D1_VALIMP4 + SD1.D1_VALIMP5 ) VLRTOT  ,"
			
		EndIf
		
		IF !( AllTrim( Upper( TcGetDb() ) ) $ "ORACLE_INFORMIX" )
			cQuery += "SUBSTRING(SD1.D1_NUMCQ,1,3) CAIXA   ,"
		Else
			cQuery += "SUBSTR(SD1.D1_NUMCQ,1,3) CAIXA   ,"
		EndIF
		
		cQuery += "0.00   DINHEIRO  ,"
		cQuery += "0.00   CHEQUES   ,"
		cQuery += "0.00   CARTAO    ,"
		cQuery += "0.00   VLRDEBI   ,"
		cQuery += "0.00   CONVENIO  ,"
		cQuery += "0.00   VALES     ,"
		cQuery += "0.00   FINANC    ,"
		cQuery += "0.00   OUTROS    ,"
		cQuery += "0.00   CREDITO   ,"
		cQuery += "0.00   VALISS    ,"
		cQuery += "0.00   DESCON    ,"
		cQuery += "0.00   ACRES "
		If cPaisLoc <> "BRA"
			cQuery += ", SF1.F1_MOEDA  MOEDA , "
			cQuery += "' '             LAYAWAY,"
			cQuery += "'   '           HISTOR  "
			
			If lTroco
				cQuery += ", 0.00   TROCO1, "
				cQuery += " 0.00   TROCO2,  "
				cQuery += " 0.00   TROCO3,  "
				cQuery += " 0.00   TROCO4,  "
				cQuery += " 0.00   TROCO5   "
			EndIf
		EndIf
		
		If lVlrPisCof
			cQuery += ", 0.00  ABTOPCC "
		EndIf
		
		cQuery += "FROM "+RetSQLName("SF1")+" SF1, "
		cQuery += RetSQLName("SA1")+" SA1, "
		cQuery += RetSQLName("SD1")+" SD1 "
		
		If lUsaPCC
			cQuery += ", " + RetSQLName("SD2") + " SD2, " + RetSQLName("SL2") + " SL2 "
		EndIf
		
		cQuery += "WHERE SA1.A1_FILIAL = '"+xFilial( "SA1" )+"' "
		cQuery += "AND SA1.A1_COD = SF1.F1_FORNECE "
		cQuery += "AND SA1.A1_LOJA = SF1.F1_LOJA "
		
		cQuery += "AND SF1.F1_FILIAL  BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		cQuery += "AND SF1.F1_EMISSAO BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "
		cQuery += "AND SF1.F1_TIPO = 'D' "
		
		cQuery += "AND SD1.D1_FILIAL  = SF1.F1_FILIAL "
		cQuery += "AND SD1.D1_DOC     = SF1.F1_DOC "
		cQuery += "AND SD1.D1_SERIE   = SF1.F1_SERIE "
		cQuery += "AND SD1.D1_FORNECE = SF1.F1_FORNECE "
		cQuery += "AND SD1.D1_LOJA    = SF1.F1_LOJA "
		cQuery += "AND SD1.D1_ORIGLAN = 'LO' "
		
		IF !( AllTrim( Upper( TcGetDb() ) ) $ "ORACLE_INFORMIX" )
			cQuery += "AND SUBSTRING(SD1.D1_NUMCQ,1,3) BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		Else
			cQuery += "AND SUBSTR(SD1.D1_NUMCQ,1,3) BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
		EndIF
		
		If lUsaNMov
			IF MV_PAR11 > 0 // Filtra Somente Quando For Informado o Numero do Movimento
				cQuery += " AND SF1.F1_NUMMOV = " + AllTrim(Str(MV_PAR11) )		
			Endif
		Endif
		cQuery += "AND SF1.D_E_L_E_T_ <> '*' "
		cQuery += "AND SA1.D_E_L_E_T_ <> '*' "
		cQuery += "AND SD1.D_E_L_E_T_ <> '*' "
		
		If lUsaPCC
			
			cQuery += " AND SD2.D_E_L_E_T_ <> '*' AND SD2.D2_FILIAL = SF1.F1_FILIAL AND SD2.D2_DOC = SD1.D1_NFORI AND " + ;
			" SD2.D2_SERIE = SD1.D1_SERIORI AND SD2.D2_CLIENTE = SD1.D1_FORNECE AND SD2.D2_LOJA = SD1.D1_LOJA AND " + ;
			" SD2.D2_COD = SD1.D1_COD AND SD2.D2_ITEM = SD1.D1_ITEMORI AND SL2.D_E_L_E_T_ <> '*' AND " + ;
			" SL2.L2_FILIAL = SF1.F1_FILIAL AND SL2.L2_SERIE = SD2.D2_SERIE AND SL2.L2_DOC = SD2.D2_DOC AND " + ;
			" SL2.L2_PRODUTO = SD2.D2_COD AND SL2.L2_ITEM = SD2.D2_ITEMPV  AND SL2.L2_STATUS = 'D' "
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Relaciono univocamente as tabelas SD1 e SL2 atraves dos campos D1_NUMSEQ e L2_ITEMSD1.                ³
			//³Caso L2_ITEMSD1 esteja vazio (que soh ocorrera com dados legados) este tratamento nao serah efetuado. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SL2->(FieldPos("L2_ITEMSD1")) > 0
				cQuery += " AND ( SD1.D1_NUMSEQ = SL2.L2_ITEMSD1 OR SL2.L2_ITEMSD1 = '      ' ) "
			Endif
			
		EndIf
		
		cQuery += "GROUP BY "
		cQuery += "SF1.F1_FILIAL, "
		cQuery += "SF1.F1_EMISSAO, "
		cQuery += "SF1.F1_DOC, "
		cQuery += "SF1.F1_SERIE, "
		cQuery += "SF1.F1_FORNECE, "
		cQuery += "SF1.F1_LOJA, "
		cQuery += "SA1.A1_NREDUZ,  "
		
		IF !( AllTrim( Upper( TcGetDb() ) ) $ "ORACLE_INFORMIX" )
			cQuery += "SUBSTRING(SD1.D1_NUMCQ,1,3) "
		Else
			cQuery += "SUBSTR(SD1.D1_NUMCQ,1,3) "
		EndIF
		If cPaisLoc <> "BRA"
			cQuery += ", SF1.F1_MOEDA "
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cancelamento do Lay-Away(Porto Rico/EUA)      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc $ "POR|EUA"
			cQuery += "UNION ALL "
			
			cQuery += "SELECT DISTINCT "
			cQuery += "'|' LDEV             ,"
			cQuery += "SE5.E5_FILIAL   FILIAL  ,"
			cQuery += "SE5.E5_DATA     DTEMI   ,"
			cQuery += "SE5.E5_NUMERO   N_FISCAL,"
			cQuery += "SE5.E5_PREFIXO  SERIE   ,"
			cQuery += "'      '   N_FISCPED,"
			cQuery += "'   '      SERPED  ,"
			cQuery += "'      '        VENDED  ,"
			cQuery += "'               ' NOME  ,"
			cQuery += "SE5.E5_CLIFOR   CLIENTE ,"
			cQuery += "SE5.E5_LOJA     LOJA    ,"
			cQuery += "SA1.A1_NREDUZ   NOM_CLI ,"
			cQuery += "SE5.E5_VALOR    VLRTOT  ,"
			cQuery += "SE5.E5_BANCO    CAIXA   ,"
			cQuery += "0.00            DINHEIRO,"
			cQuery += "0.00            CHEQUES ,"
			cQuery += "0.00            CARTAO  ,"
			cQuery += "0.00            VLRDEBI ,"
			cQuery += "0.00            CONVENIO,"
			cQuery += "0.00            VALES   ,"
			cQuery += "0.00            FINANC  ,"
			cQuery += "0.00            OUTROS  ,"
			cQuery += "0.00            CREDITO ,"
			cQuery += "0.00            VALISS  ,"
			cQuery += "0.00            DESCON  ,"
			cQuery += "0.00            ACRES   ,"
			cQuery += "SLO.LO_MOEDA    MOEDA   ,"
			cQuery += "'S'             LAYAWAY ,"
			cQuery += "'   '           HISTOR   "
			
			cQuery += " FROM "+ RetSqlName("SE5") + " SE5,"
			cQuery += RetSqlName("SLO") + " SLO,"
			cQuery += RetSqlName("SA1") + " SA1"
			
			cQuery += " WHERE "
			
			cQuery += "  (SE5.E5_DATA >= '" + Dtos(mv_par03) + "' AND SE5.E5_DATA <= '" + Dtos(mv_par04) + "') AND "
			cQuery += "  (SE5.E5_BANCO >= '" + mv_par05 + "' AND SE5.E5_BANCO <= '" + mv_par06 + "') AND "
			cQuery += "  (SE5.E5_PREFIXO = '"+ &(SuperGetMv("MV_LWPREF1")) +"' AND SE5.E5_TIPO = 'RA ' AND SE5.E5_RECPAG = 'P' AND SE5.E5_TIPODOC = 'VL') AND "    //LayAway cancelado
			
			cQuery += "  SA1.A1_FILIAL = '"+ xFilial( "SA1" ) +"' AND "  //SE5 x SA1
			cQuery += "  SE5.E5_CLIFOR = SA1.A1_COD AND "
			cQuery += "  SE5.E5_LOJA = SA1.A1_LOJA AND "
			
			cQuery += "  SE5.E5_NUMERO = SLO.LO_NUMLAY AND "	            //SE5 x SLO
			cQuery += "  SLO.LO_STATUS = '4' AND "
			
			cQuery += "  SE5.D_E_L_E_T_<>'*' AND "
			cQuery += "  SLO.D_E_L_E_T_<>'*' AND "
			cQuery += "  SA1.D_E_L_E_T_<>'*' "
			
		EndIf
	EndIf
	
	cQuery += "ORDER BY FILIAL, DTEMI, CAIXA, LDEV"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o tratamento/compatibilidade com o Top Connect    		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := ChangeQuery(cQuery)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava um arquivo com a query para possiveis testes (DEBUG)   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//MemoWrite("C:\LOJR075.SQL",cQuery)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o ALIAS do arquivo temporario                     		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TRB", .F., .T.)
	
	For nX := 1 To Len(aStruTRB)
		TcSetField( "TRB", aStruTRB[nX,1], aStruTRB[nX,2], aStruTRB[nX,3], aStruTRB[nX,4] )
	Next nX
	
	IncProc(STR0007);IncProc(STR0007)//"Selecionando registros para impressão..."
	
	If SL1->(FieldPos("L1_ABTOPCC")) > 0 .AND. cPaisLOC == "BRA"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Varre todo o arquivo de trabalho, se existir o campo L1_ABTOPCC e for BRASIL ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		TRB->(DBGoTop())
		
		While ! TRB->(EOF())
			
			nParcelas := 0
			nRestDiv  := 0
			aTemp     := {}
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Venda balcão não grava nada qdo tem abatimento total do PIS/COFINS/CSLL já o venda assistida grava ³
			//³no L1_OUTROS. Por isso esse processo para colocar o que foi abatido no campo L1_DINHEIR.           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	(TRB->DINHEIRO	+	TRB->CHEQUES	+	TRB->CARTAO	+	TRB->VLRDEBI	+;
				TRB->CONVENIO 	+	TRB->VALES		+	TRB->FINANC	+	TRB->CREDITO ) == 0 .AND. ;
				(	TRB->OUTROS		==	TRB->ABTOPCC	.OR.TRB->OUTROS == 0 )
				
				If TRB->OUTROS == 0
					Replace DINHEIRO With TRB->ABTOPCC
				Else
					Replace DINHEIRO With TRB->OUTROS
				Endif
				
				Replace OUTROS   With 0
				
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava no array aTemp as formas de pagamento ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If TRB->DINHEIRO > 0
				nParcelas ++
				aAdd(aTemp, "DINHEIRO")
			EndIf
			
			If TRB->CHEQUES > 0
				nParcelas ++
				aAdd(aTemp, "CHEQUES")
			EndIf
			
			If TRB->CARTAO > 0
				nParcelas ++
				aAdd(aTemp, "CARTAO")
			EndIf
			
			If TRB->VLRDEBI > 0
				nParcelas ++
				aAdd(aTemp, "VLRDEBI")
			EndIf
			
			If TRB->CONVENIO > 0
				nParcelas ++
				aAdd(aTemp, "CONVENIO")
			EndIf
			
			If TRB->VALES > 0
				nParcelas ++
				aAdd(aTemp, "VALES")
			EndIf
			
			If TRB->FINANC > 0
				nParcelas ++
				aAdd(aTemp, "FINANC")
			EndIf
			
			If TRB->CREDITO > 0
				nParcelas ++
				aAdd(aTemp, "CREDITO")
			EndIf
			
			If TRB->OUTROS > 0
				nParcelas ++
				aAdd(aTemp, "OUTROS")
			EndIf
			
			SA1->(DBSetOrder(1))
			SA1->(MsSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida se o cliente recolhe ISS³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) ) .AND. ! lpTPAbISS
				
				For nX := 1 To Len(aTemp)
					FieldPut( FieldPos ( aTemp[nX] ), ( FieldGet( FieldPos( aTemp[nX] ) ) + Round( ( VALISS / nParcelas ), 2) ) )
					nRestDiv += Round( ( VALISS / nParcelas ), 2 )
				Next nX
				
				If nRestDiv <> VALISS
					FieldPut( FieldPos( aTemp[nX] ), ( FieldGet( FieldPos( aTemp[nX] ) ) - ( nRestDiv - VALISS ) ) )
				EndIf
				
			EndIf
			TRB->(DBSkip())
			
		EndDo
		
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Varre todo o arquivo de trabalho, se nao existir o campo L1_ABTOPCC ou nao for BRASIL ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		TRB->(DBGoTop())
		
		While ! TRB->(EOF())
			
			nParcelas := 0
			nRestDiv  := 0
			aTemp     := {}
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava no array aTemp as formas de pagamento ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If TRB->DINHEIRO > 0
				nParcelas ++
				aAdd(aTemp, "DINHEIRO")
			EndIf
			
			If TRB->CHEQUES > 0
				nParcelas ++
				aAdd(aTemp, "CHEQUES")
			EndIf
			
			If TRB->CARTAO > 0
				nParcelas ++
				aAdd(aTemp, "CARTAO")
			EndIf
			
			If TRB->VLRDEBI > 0
				nParcelas ++
				aAdd(aTemp, "VLRDEBI")
			EndIf
			
			If TRB->CONVENIO > 0
				nParcelas ++
				aAdd(aTemp, "CONVENIO")
			EndIf
			
			If TRB->VALES > 0
				nParcelas ++
				aAdd(aTemp, "VALES")
			EndIf
			
			If TRB->FINANC > 0
				nParcelas ++
				aAdd(aTemp, "FINANC")
			EndIf
			
			If TRB->CREDITO > 0
				nParcelas ++
				aAdd(aTemp, "CREDITO")
			EndIf
			
			If TRB->OUTROS > 0
				nParcelas ++
				aAdd(aTemp, "OUTROS")
			EndIf
			
			SA1->(DBSetOrder(1))
			SA1->(MsSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida se o cliente recolhe ISS³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) ) .AND. ! lpTPAbISS
				
				For nX := 1 To Len( aTemp )
					FieldPut( FieldPos( aTemp[nX] ), ( FieldGet( FieldPos( aTemp[nX] ) ) + Round( ( VALISS / nParcelas ), 2) ) )
					nRestDiv += Round( ( VALISS / nParcelas ), 2 )
				Next nX
				
				If nRestDiv <> VALISS
					FieldPut( FieldPos( aTemp[nX] ), ( FieldGet( FieldPos( aTemp[nX] ) ) - ( nRestDiv - VALISS ) ) )
				EndIf
				
			EndIf
			TRB->(DBSkip())
			
		EndDo
		
	EndIf
	
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montando Array aCampos com a estrutura do DBF         		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd( aCampos, {"LDEV","C",1,0} )
	
	aTam := TamSX3("L1_FILIAL")
	AAdd( aCampos, {"FILIAL","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_EMISNF")
	AAdd( aCampos, {"DTEMI","D",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_DOC")
	AAdd( aCampos, {"N_FISCAL","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_SERIE")
	AAdd( aCampos, {"SERIE","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_DOCPED")
	AAdd( aCampos, {"N_FISCPED","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_SERPED")
	AAdd( aCampos, {"SERPED","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VEND")
	AAdd( aCampos, {"VENDED","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("A3_NREDUZ")
	AAdd( aCampos, {"NOME","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_CLIENTE")
	AAdd( aCampos, {"CLIENTE","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_LOJA")
	AAdd( aCampos, {"LOJA","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("A1_NREDUZ")
	AAdd( aCampos, {"NOM_CLI","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VLRTOT")
	AAdd( aCampos, {"VLRTOT","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_OPERADO")
	AAdd( aCampos, {"CAIXA","C",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_DINHEIR")
	AAdd( aCampos, {"DINHEIRO","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_CHEQUES")
	AAdd( aCampos, {"CHEQUES","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_CARTAO")
	AAdd( aCampos, {"CARTAO","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VLRDEBI")
	AAdd( aCampos, {"VLRDEBI","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_CONVENI")
	AAdd( aCampos, {"CONVENIO","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VALES")
	AAdd( aCampos, {"VALES","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_FINANC")
	AAdd( aCampos, {"FINANC","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_OUTROS")
	AAdd( aCampos, {"OUTROS","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_CREDITO")
	AAdd( aCampos, {"CREDITO","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VALISS")
	aAdd( aCampos, { "VALISS", "N", aTam[01], aTam[02] })
	
	aTam := TamSX3("L1_VLRTOT")
	AAdd( aCampos, {"DESCON","N",aTam[1],aTam[2]} )
	
	aTam := TamSX3("L1_VLRTOT")
	AAdd( aCampos, {"ACRES","N",aTam[1],aTam[2]} )
	
	If lVlrPisCof
		aTam := TamSX3("L1_ABTOPCC")
		AAdd( aCampos, {"ABTOPCC","N",aTam[1],aTam[2]} )
	EndIf
	
	If cPaisLoc <> "BRA"
		aTam := TamSX3("L1_MOEDA")
		AAdd( aCampos, {"MOEDA","N",aTam[1],aTam[2]} )
		
		AAdd( aCampos, {"LAYAWAY","C",1,0} )
		
		AAdd( aCampos, {"HISTOR","C",3,0} )
		
		If lTroco
			aTam := TamSX3("L1_TROCO1")
			AAdd( aCampos, {"TROCO","N",aTam[1],aTam[2]} )
		EndIf
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criando estrutura Temporaria                          		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqTmp := CriaTrab( aCampos, .T. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definindo um Alias para a estrutura                   		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbUseArea(.T.,,cArqTmp,"TRB", .T., .F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abertura dos arquivos a serem utilizados              		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "TRB" )
	
	dbSelectArea( "SA1" )
	dbSetOrder( 1 )
	
	dbSelectArea( "SA3" )
	dbSetOrder( 1 )
	
	dbSelectArea( "SL2" )
	dbSetOrder( 1 )
	
	dbSelectArea( "SL1" )
	dbSetOrder( 1 )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Selecionando os registros para filtro no arquivo.     		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SL1->L1_FILIAL >= '"+MV_PAR01+"' .AND. SL1->L1_FILIAL <= '"+MV_PAR02+"' .AND. "
	cQuery += "(((SL1->L1_TIPO == 'V' .AND. !Empty(SL1->L1_DOC) .AND. Empty(SL1->L1_ORCRES)) .OR. (SL1->L1_TIPO == 'P' .AND. !Empty(SL1->L1_DOCPED) ))) .AND. "
	cQuery += "DtoS(SL1->L1_EMISNF)  >= '"+DtoS(MV_PAR03)+"' .AND. DtoS(SL1->L1_EMISNF) <= '"+DtoS(MV_PAR04)+"' .AND. "
	cQuery += "SL1->L1_OPERADO >= '"+MV_PAR05+"' .AND. SL1->L1_OPERADO <= '"+MV_PAR06+"'"
	If cPaisLoc $ "POR|EUA"
		cQuery += " .AND. L1_CONDPG <> 'LAY' "	  //Desprezar as finalizacoes de Lay-Away
	EndIf
	
	If lUsaNMov
		If MV_PAR11 > 0 // Filtra Somente Quando For Informado o Numero do Movimento
			cQuery += " AND SL1.L1_NUMMOV = " + AllTrim(Str(MV_PAR11) )
		Endif
	Endif
	cIndSL1 := CriaTrab( NIL, .F. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtrando orcamento conforme informacoes do parametro.		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IndRegua("SL1",cIndSL1,IndexKey(),,cQuery)
	dbGotop()
	
	ProcRegua( Reccount() )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerando arquivo temporario.                           		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do While !Eof()
		
		IncProc(STR0007)//"Selecionando registros para impressão..."
		
		If ! SA1->( MsSeek( xFilial( "SA1" ) + SL1->L1_CLIENTE + SL1->L1_LOJA ) )
			dbSkip()
			Loop
		EndIf
		
		If ! SA3->( MsSeek( xFilial( "SA3" ) + SL1->L1_VEND ) )
			dbSkip()
			Loop
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se nao for Brasil, verifica as casas decimais da moeda selecionada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc <> "BRA"
			nMoeda  := Max(SL1->L1_MOEDA,1)
			nDecs   := MsDecimais(mv_par09)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Nao Imprimir outras moedas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par10 == 2
				If SL1->L1_MOEDA <> mv_par09
					DbSkip()
					Loop
				EndIf
			EndIf
			
			If lTroco
				For nY := 1 to MoedFin()
					cCampoTr  := "L1_TROCO" + AllTrim( Str ( nY ) )
					
					If SL1->( FieldPos ( cCampoTr ) ) > 0
						nVlrTroco  += Round( xMoeda( & ( cCampoTr ),nY ,mv_par09 ,SL1->L1_EMISSAO ,nDecs + 1 ),nDecs )
					EndIf
					
				Next nY
			EndIf
			
		EndIf
		
		dbSelectArea( "SL2" )
		If ! MsSeek( cSeekWhile := SL1->L1_FILIAL + SL1->L1_NUM )
			dbSelectArea( "SL1" )
			dbSkip()
			Loop
		EndIf
		
		nValDesc   := 0
		nValDProp  := 0
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Armazenando informacoes de desconto e desc. proporcional.    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do While cSeekWhile == L2_FILIAL + L2_NUM .AND. !Eof()
			
			nValDesc   += L2_VALDESC
			nValDProp  += L2_DESCPRO
			
			dbSkip()
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravando Arquivo Temporario.                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea( "TRB" )
		RecLock( "TRB", .T. )
		
		Replace LDEV           With " "
		Replace FILIAL         With SL1->L1_FILIAL
		Replace DTEMI          With SL1->L1_EMISNF
		Replace N_FISCAL       With SL1->L1_DOC
		Replace SERIE          With SL1->L1_SERIE
		Replace N_FISCPED      With SL1->L1_DOCPED
		Replace SERPED         With SL1->L1_SERPED
		Replace VENDED         With SL1->L1_VEND
		Replace NOME           With SA3->A3_NREDUZ
		Replace CLIENTE        With SL1->L1_CLIENTE
		Replace LOJA           With SL1->L1_LOJA
		Replace NOM_CLI        With SA1->A1_NREDUZ
		Replace VLRTOT         With SL1->L1_VLRTOT
		Replace CAIXA          With SL1->L1_OPERADO
		
		// Venda balcão não grava nada qdo tem abatimento total do PIS/COFINS/CSLL já o venda assistida grava no
		// L1_OUTROS. Por isso esse processo para colocar o que foi abatido no campo L1_DINHEIR.
		If	  SL1->( FieldPos( "L1_ABTOPCC" ) ) > 0 .AND.;
			( SL1->L1_DINHEIR + SL1->L1_CHEQUES	+ SL1->L1_CARTAO + SL1->L1_VLRDEBI + ;
			SL1->L1_CONVENI + SL1->L1_VALES	+ SL1->L1_FINANC + SL1->L1_CREDITO ) == 0 .AND. ;
			( SL1->L1_OUTROS == SL1->L1_ABTOPCC .OR. SL1->L1_OUTROS == 0 )
			
			If SL1->L1_OUTROS == 0
				Replace DINHEIRO	With SL1->L1_ABTOPCC
			Else
				Replace DINHEIRO	With SL1->L1_OUTROS
			Endif
			
			Replace OUTROS	With 0
			
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida se existe o campo troco, caso nao tenha valida ³
			//³se o valor liquido eh mairo que o valor em dinheiro   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cPaisLoc == "BRA"
				If  ( SL1->( FieldPos( "L1_TROCO1" ) ) > 0 )
					Replace DINHEIRO	With (SL1->L1_DINHEIR - SL1->L1_TROCO1)
					
				ElseIf SL1->L1_DINHEIR > SL1->L1_VLRLIQ
					Replace DINHEIRO	With SL1->L1_VLRLIQ
				Else
					Replace DINHEIRO	With SL1->L1_DINHEIR
				EndIf
			Else
				Replace DINHEIRO	With SL1->L1_DINHEIR
			Endif
			
			
			Replace OUTROS         With SL1->L1_OUTROS
			
		EndIf
		
		Replace CHEQUES		With SL1->L1_CHEQUES
		Replace CARTAO		With SL1->L1_CARTAO
		Replace VLRDEBI		With SL1->L1_VLRDEBI
		Replace CONVENIO	With SL1->L1_CONVENI
		Replace VALES		With SL1->L1_VALES
		Replace FINANC		With IF(SL1->L1_FORMPG)=="BO",SL1->L1_OUTROS,SL1->L1_FINANC)
		Replace CREDITO		With SL1->L1_CREDITO
		Replace VALISS		With SL1->L1_VALISS
		
		Replace ACRES		With SL1->L1_VLRTOT - SL1->L1_VALMERC
		Replace DESCON		With nValDesc + nValDProp
		
		If lVlrPisCof
			Replace ABTOPCC	With SL1->L1_ABTOPCC
		EndIf
		
		nParcelas := 0
		nRestDiv  := 0
		aTemp     := {}
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Grava no array aTemp as formas de pagamento ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TRB->DINHEIRO > 0
			nParcelas ++
			aAdd(aTemp, "DINHEIRO")
		EndIf
		
		If TRB->CHEQUES > 0
			nParcelas ++
			aAdd(aTemp, "CHEQUES")
		EndIf
		
		If TRB->CARTAO > 0
			nParcelas ++
			aAdd(aTemp, "CARTAO")
		EndIf
		
		If TRB->VLRDEBI > 0
			nParcelas ++
			aAdd(aTemp, "VLRDEBI")
		EndIf
		
		If TRB->CONVENIO > 0
			nParcelas ++
			aAdd(aTemp, "CONVENIO")
		EndIf
		
		If TRB->VALES > 0
			nParcelas ++
			aAdd(aTemp, "VALES")
		EndIf
		
		If TRB->FINANC > 0
			nParcelas ++
			aAdd(aTemp, "FINANC")
		EndIf
		
		If TRB->CREDITO > 0
			nParcelas ++
			aAdd(aTemp, "CREDITO")
		EndIf
		
		If TRB->OUTROS > 0
			nParcelas ++
			aAdd(aTemp, "OUTROS")
		EndIf
		
		SA1->(DBSetOrder(1))
		SA1->(MsSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))
		
		If ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) ) .AND. ! lpTPAbISS
			
			For nX := 1 To Len(aTemp)
				
				TRB->(FieldPut(FieldPos(aTemp[nX]), ( FieldGet(FieldPos(aTemp[nX])) + Round(( VALISS / nParcelas ), 2) )))
				
				nRestDiv += Round(( TRB->VALISS / nParcelas ), 2)
				
			Next
			
			If nRestDiv <> VALISS
				FieldPut(FieldPos(aTemp[nX]), ( FieldGet(FieldPos(aTemp[nX])) - ( nRestDiv - TRB->VALISS ) ))
			EndIf
			
		EndIf
		
		If cPaisLoc <> "BRA"
			Replace MOEDA	With nMoeda
			
			If lTroco
				Replace TROCO	With nVlrTroco
			EndIf
			
		EndIf
		
		MsUnlock()
		
		dbSelectArea( "SL1" )
		dbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apagando indice temporario.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	FErase( cIndSL1 + OrdBagExt() )
	RetIndex( "SL1" )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recebimento por Lay-Away(Porto Rico/EUA)      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cPaisLoc $ "POR|EUA"
		
		dbSelectArea( "SLO" )
		dbSetOrder( 1 )
		
		dbSelectArea( "SLP" )
		dbSetOrder( 3 )
		
		dbSelectArea( "SE5" )
		dbSetOrder( 1 )
		
		cQuery := "DTOS(SE5->E5_DATA) >= '"+DtoS(MV_PAR03)+"' .AND. DTOS(SE5->E5_DATA) <= '"+DtoS(MV_PAR04)+"' "
		cQuery += ".AND. SE5->E5_BANCO >= '"+MV_PAR05+"' .AND. SE5->E5_BANCO <= '"+MV_PAR06+"' "
		cQuery += ".AND. (SE5->E5_PREFIXO = '"+ &(SuperGetMv("MV_LWPREF1")) +"' .AND. SE5->E5_TIPO = 'RA ' .AND. SE5->E5_RECPAG = 'R' .AND. SE5->E5_TIPODOC = 'RA')"    //LayAway - recebimento
		
		If lUsaNMov
			If MV_PAR11 > 0 // Filtra Somente Quando For Informado o Numero do Movimento
				cQuery += " AND SE5.E5_NUMMOV = " + AllTrim(Str(MV_PAR11) )
			Endif
		Endif
		cIndSE5 := CriaTrab( NIL, .F. )
		
		IndRegua("SE5",cIndSE5,IndexKey(),,cQuery)
		dbGotop()
		
		ProcRegua( Reccount() )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gerando arquivo temporario.                           		 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do While !Eof()
			
			IncProc(STR0007)//"Selecionando registros para impressão..."
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se nao encontrar o registro correspondente no SLP, verificar no SLO.³
			//³Deve considerar os Lay-Aways cancelados(LO_STATUS='4')              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lSLOExcl  := !SLO->(MsSeek(xFilial("SLO")+Trim(SE5->E5_NUMERO)))
			lSLPExcl  := !SLP->(MsSeek(xFilial("SLP")+SE5->E5_PREFIXO+Trim(SE5->E5_NUMERO)+SE5->E5_PARCELA))
			
			If lSLPExcl .AND. ( lSLOExcl .OR. ( !lSLOExcl .AND. SLO->LO_STATUS <> "4" ) )
				dbSkip()
				Loop
			EndIf
			
			If !lSLPExcl .AND. !SLO->( MsSeek ( xFilial( "SLO" ) + SLP->LP_NUMLAY ) )
				dbSkip()
				Loop
			EndIf
			
			If SLO->LO_FILIAL < mv_par01 .OR. SLO->LO_FILIAL > mv_par02
				dbSkip()
				Loop
			EndIf
			
			If !SA1->( MsSeek ( xFilial ( "SA1" ) + SE5->E5_CLIFOR + SE5->E5_LOJA ) )
				dbSkip()
				Loop
			EndIf
			
			nMoeda  := Max( SLO->LO_MOEDA,1 )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Nao Imprimir outras moedas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par10 == 2
				If SLO->LO_MOEDA <> mv_par09
					DbSkip()
					Loop
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gravando Arquivo Temporario.                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "TRB" )
			RecLock( "TRB", .T. )
			
			Replace LDEV           With " "
			Replace FILIAL         With SLO->LO_FILIAL
			Replace DTEMI          With SE5->E5_DATA
			Replace N_FISCAL       With SLO->LO_NUMLAY
			Replace SERIE          With SE5->E5_PREFIXO
			
			Replace N_FISCPED      With "      "
			Replace SERPED         With "   "
			
			Replace VENDED         With ""
			Replace NOME           With ""
			Replace CLIENTE        With SLO->LO_CLIENTE
			Replace LOJA           With SLO->LO_LOJA
			Replace NOM_CLI        With SA1->A1_NREDUZ
			Replace VLRTOT         With SE5->E5_VALOR
			Replace CAIXA          With SE5->E5_BANCO
			
			Replace DINHEIRO       With 0.00
			Replace CHEQUES        With 0.00
			Replace CARTAO         With 0.00
			Replace VLRDEBI        With 0.00
			Replace CONVENIO       With 0.00
			Replace VALES          With 0.00
			Replace FINANC         With 0.00
			Replace OUTROS         With 0.00
			Replace CREDITO        With 0.00
			Replace VALISS         With 0.00
			Replace DESCON         With 0.00
			Replace ACRES          With 0.00
			Replace MOEDA          With nMoeda
			Replace LAYAWAY        With 'S'
			Replace HISTOR         With Substr(SE5->E5_HISTOR,1,3)
			
			MsUnlock()
			
			dbSelectArea( "SE5" )
			dbSkip()
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apagando indice temporario.                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FErase( cIndSE5 + OrdBagExt() )
		RetIndex( "SE5" )
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificando se considera devolucoes.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MV_PAR07 == 1
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Abertura de arquivos com os indices                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea( "SD1" )
		dbSetOrder( 1 )
		
		dbSelectArea( "SF1" )
		dbSetOrder( 1 )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Selecionando parametros para filtro.                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SF1->F1_FILIAL  >= '"+MV_PAR01+"' .AND. SF1->F1_FILIAL <= '"+MV_PAR02+"' .AND. "
		cQuery += "DtoS(SF1->F1_EMISSAO) >= '"+DtoS(MV_PAR03)+"' .AND. DtoS(SF1->F1_EMISSAO) <= '"+DtoS(MV_PAR04)+"' .AND. "
		cQuery += "SF1->F1_TIPO == 'D' "
		
		If lUsaNMov
			If MV_PAR11 > 0 // Filtra Somente Quando For Informado o Numero do Movimento
				cQuery += " AND SF1.F1_NUMMOV = " + AllTrim(Str(MV_PAR11) )
			Endif
		Endif
		cIndSF1 := CriaTrab( NIL, .F. )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtrando as notas de entrada.                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IndRegua( "SF1",cIndSF1,IndexKey(),,cQuery )
		dbGotop()
		
		ProcRegua( RecCount() )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Varrendo as informacoes de documento de entrada.             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do While !Eof()
			
			IncProc(STR0007)//"Selecionando registros para impressão..."
			
			If ! SA1->( MsSeek( xFilial( "SA1" ) + SF1->F1_FORNECE + SF1->F1_LOJA ) )
				dbSkip()
				Loop
			EndIf
			
			If cPaisLoc <> "BRA"
				nMoeda  := Max(SF1->F1_MOEDA,1)
				If mv_par10 == 2  //Nao Imprimir outras moedas
					If SF1->F1_MOEDA <> mv_par09
						DbSkip()
						Loop
					EndIf
				EndIf
			EndIf
			
			dbSelectArea( "SD1" )
			If ! MsSeek( cSeekWhile := SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA )
				dbSelectArea( "SF1" )
				dbSkip()
				Loop
			EndIf
			
			If ( SubStr(D1_NUMCQ,1,3) < MV_PAR05 .OR. SubStr(D1_NUMCQ,1,3) > MV_PAR06 ) .OR. (D1_ORIGLAN <> "LO")
				dbSelectArea( "SF1" )
				dbSkip()
				Loop
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gravacao do arquivo temporario.                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "TRB" )
			RecLock( "TRB" , .T. )
			
			Replace LDEV           With "|"
			Replace FILIAL         With SF1->F1_FILIAL
			Replace DTEMI          With SF1->F1_EMISSAO
			Replace N_FISCAL       With SF1->F1_DOC
			Replace SERIE          With SF1->F1_SERIE
			Replace N_FISCPED      With "      "
			Replace SERPED         With "   "
			Replace VENDED         With ""
			Replace NOME           With ""
			Replace CLIENTE        With SF1->F1_FORNECE
			Replace LOJA           With SF1->F1_LOJA
			Replace NOM_CLI        With SA1->A1_NREDUZ
			Replace CAIXA          With SubStr(SD1->D1_NUMCQ,1,3)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se tem apuração de PIS/COFINS/CSLL, pego o percentual dos valores na tabela SL2 e faço o proporcional ³
			//³para a devolução, caso não use, o total é dado pela soma do valor bruto com o valor do ipi da tab. SF1³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lUsaPCC
				
				SD2->(DBSetOrder(3))
				SL2->(DBSetOrder(3))
				
				DBSelectArea( "TRB" )
				Replace VLRTOT With 0
				
				While	SD1->D1_FILIAL	== xFilial("SD1")	.AND. SD1->D1_DOC		== SF1->F1_DOC		.AND.;
					SD1->D1_SERIE	== SF1->F1_SERIE	.AND. SD1->D1_FORNECE	== SF1->F1_FORNECE	.AND.;
					SD1->D1_LOJA	== SF1->F1_LOJA		.AND. !SD1->(EOF() )
					
					nTotal := ( SD1->D1_TOTAL - SD1->D1_VALDESC )
					
					If SD2->(MsSeek(xFilial("SD2") + SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEMORI))
						
						If SL2->(MsSeek(xFilial("SL2") + SD2->D2_SERIE + SD2->D2_DOC + SD2->D2_COD))
							
							While SL2->L2_Filial == xFilial("SL2") .AND. SL2->L2_SERIE == SD2->D2_SERIE .AND. ;
								SL2->L2_DOC == SD2->D2_DOC .AND. SL2->L2_PRODUTO == SD2->D2_COD .AND. ! SL2->(EOF())
								
								If SL2->L2_ITEM == SD2->D2_ITEMPV
									
									DBSelectArea( "TRB" )
									
									nPerc  := ( ( SL2->L2_VALPIS / SL2->L2_VLRITEM ) * 100 )
									nTotal := ( nTotal - ( ( ( SD1->D1_TOTAL - SD1->D1_VALDESC ) * nPerc ) / 100 ) )
									
									nPerc  := ( ( SL2->L2_VALCOFI / SL2->L2_VLRITEM ) * 100 )
									nTotal := ( nTotal - ( ( ( SD1->D1_TOTAL - SD1->D1_VALDESC ) * nPerc ) / 100 ) )
									
									nPerc  := ( ( SL2->L2_VALCSLL / SL2->L2_VLRITEM ) * 100 )
									nTotal := ( nTotal - ( ( ( SD1->D1_TOTAL - SD1->D1_VALDESC ) * nPerc ) / 100 ) )
									
									Replace VLRTOT  With ( VLRTOT + nTotal )
									Exit
									
								EndIf
								
								SL2->(DBSkip())
								
							EndDo
							
						EndIf
						
					EndIf
					
					SD1->(DBSkip())
					
				EndDo
				
			EndIf
			
			DBSelectArea("TRB")
			
			If ! (	TRB->( FieldPos( "VALPIS" ) ) > 0 .AND. TRB->( FieldPos( "VALCOFI" ) ) > 0 .AND.;
				TRB->( FieldPos( "VALCSLL" ) ) > 0 )
				
				Replace VLRTOT With ( SF1->F1_VALBRUT + SF1->F1_VALIPI )
				
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava conteudo no arquivo temporario³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Replace DINHEIRO       With 0.00
			Replace CHEQUES        With 0.00
			Replace CARTAO         With 0.00
			Replace VLRDEBI        With 0.00
			Replace CONVENIO       With 0.00
			Replace VALES          With 0.00
			Replace FINANC         With 0.00
			Replace OUTROS         With 0.00
			Replace CREDITO        With 0.00
			Replace VALISS         With 0.00
			Replace DESCON         With 0.00
			Replace ACRES          With 0.00
			
			If cPaisLoc <> "BRA"
				Replace MOEDA       With nMoeda
			EndIf
			
			MsUnlock()
			
			dbSelectArea( "SF1" )
			dbSkip()
			
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apagando indice temporario.                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FErase( cIndSF1 + OrdBagExt() )
		RetIndex( "SF1" )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cancelamento do Lay-Away(Porto Rico/EUA)      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cPaisLoc $ "POR|EUA"
			
			dbSelectArea( "SLO" )
			dbSetOrder( 1 )
			
			dbSelectArea( "SA1" )
			dbSetOrder( 1 )
			
			dbSelectArea( "SE5" )
			dbSetOrder( 1 )
			
			cQuery := "DTOS(SE5->E5_DATA) >= '"+DtoS(MV_PAR03)+"' .AND. DTOS(SE5->E5_DATA) <= '"+DtoS(MV_PAR04)+"' .AND. "
			cQuery += "SE5->E5_BANCO >= '"+MV_PAR05+"' .AND. SE5->E5_BANCO <= '"+MV_PAR06+"' .AND. "
			cQuery += "(SE5->E5_PREFIXO = '"+ &(SuperGetMv("MV_LWPREF1")) +"' .AND. SE5->E5_TIPO = 'RA ' .AND. SE5->E5_RECPAG = 'P' .AND. SE5->E5_TIPODOC = 'VL')"    //LayAway - cancelamento
			
			cIndSE5 := CriaTrab( NIL, .F. )
			
			IndRegua("SE5",cIndSE5,IndexKey(),,cQuery)
			dbGotop()
			
			ProcRegua( Reccount() )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gerando arquivo temporario.                           		 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Do While !Eof()
				
				IncProc(STR0007)//"Selecionando registros para impressão..."
				
				If !SLO->(MsSeek(xFilial("SLO")+Trim(SE5->E5_NUMERO)))
					dbSkip()
					Loop
				EndIf
				
				If !SA1->(MsSeek(xFilial("SA1")+SE5->E5_CLIFOR+SE5->E5_LOJA))
					dbSkip()
					Loop
				EndIf
				
				nMoeda  := Max(SLO->LO_MOEDA,1)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Nao Imprimir outras moedas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If mv_par10 == 2
					If SLO->LO_MOEDA <> mv_par09
						DbSkip()
						Loop
					EndIf
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gravacao do arquivo temporario.                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "TRB" )
				RecLock( "TRB" , .T. )
				
				Replace LDEV           With "|"
				Replace FILIAL         With SE5->E5_FILIAL
				Replace DTEMI          With SE5->E5_DATA
				Replace N_FISCAL       With SE5->E5_NUMERO
				Replace SERIE          With SE5->E5_PREFIXO
				
				Replace N_FISCPED      With "      "
				Replace SERPED         With "   "
				
				Replace VENDED         With ""
				Replace NOME           With ""
				Replace CLIENTE        With SE5->E5_CLIFOR
				Replace LOJA           With SE5->E5_LOJA
				Replace NOM_CLI        With SA1->A1_NREDUZ
				Replace VLRTOT         With SE5->E5_VALOR
				Replace CAIXA          With SE5->E5_BANCO
				
				Replace DINHEIRO       With 0.00
				Replace CHEQUES        With 0.00
				Replace CARTAO         With 0.00
				Replace VLRDEBI        With 0.00
				Replace CONVENIO       With 0.00
				Replace VALES          With 0.00
				Replace FINANC         With 0.00
				Replace OUTROS         With 0.00
				Replace CREDITO        With 0.00
				Replace VALISS         With 0.00
				Replace DESCON         With 0.00
				Replace ACRES          With 0.00
				Replace MOEDA          With nMoeda
				Replace LAYAWAY        With 'S'
				Replace HISTOR         With '   '
				
				MsUnlock()
				
				dbSelectArea( "SE5" )
				dbSkip()
			EndDo
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Apagando indice temporario.                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FErase( cIndSE5 + OrdBagExt() )
			RetIndex( "SE5" )
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Indexando arquivo temporario para emissao do relatorio.      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "TRB" )
	IndRegua("TRB",cArqTmp,"FILIAL + DtoS(DTEMI) + CAIXA + LDEV")
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LJ075Impriº Autor ³ Fernando Salvatori º Data ³  21/01/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Montagem e impressao do relatorio.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±³                         ATUALIZACOES SOFRIDAS                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³           Motivo da Alteracao            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Magh Moura  ³02.08.05³02444/³No total geral nao estava totalizando to- ³±±
±±³            ³        ³2005- ³dos os caixas, apenas o total do ultimo   ³±±
±±³            ³        ³00    ³caixa.                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJ075Imprime(Cabec1,	Cabec2,	Titulo,	nLin, ;
							 lUsaQuery,	cArqTmp )

Local cFilAtu   := "" 				//Filial atual utilizada no relatorio
Local cCaiAtu   := ""				//Caixa utilizada no relatorio
Local uDatAtu   := ""               //Data de emissao utilizada no relatorio
Local nX        := ""				//Var Auxiliar
Local nScanForm := 0                //Posicao da forma de pagamento
Local nMoeda    := 1                     //Moeda da transacao
Local nTotTrocCx:= 0
Local nTotTrocDt:= 0
Local nTotTrocFl:= 0
Local nVlrTroco := 0
Local nDecs     := MsDecimais(mv_par09)  //Num. de casas decimais da moeda selecionada
Local nTotImps  := 0                     //Total de impostos variaveis discriminados em uma venda - Localizacoes
Local lDados    := ( TRB->( RecCount() ) <> 0 )
Local aFormas   := {}				//Array contendo as formas de pagamento
Local aFormaImp := {}               //Array com as formas de pagto que serao impressas
Local cFormasImp:= ""               //Formas de pagamento que serao impressas
Local cSimbMoeda:= IIf(cPaisLoc == "BRA","R$","$$")  //Simbolo da moeda(Dinheiro)
Local nTroco    := 0                //Entradas de Troco
Local nPosMoed  := 0                //Posicao da moeda

Local aTotCx    := Array(10)        //Array Total por caixa
Local aTotDt    := Array(10)        //Array Total por data
Local aTotFi    := Array(10)        //Array Total por Filial
Local aTotGer   := Array(10)        //Array Total Geral
Local aSangria  := Array(10)        //Armazena as sangrias Sangria

Local aTotCxDev := Array(10)        //Array Total por caixa
Local aTotDtDev := Array(10)        //Array Total por data
Local aTotFiDev := Array(10)        //Array Total por Filial
Local aTotGerDev:= Array(10)        //Array Total Geral

Local aColunas  := Array(18)        //Array com as posicoes das colunas
Local aPicts    := Array(12)        //Array com as pictures de impressao

Local lFirstDev   := .T.            //Considera impressao de Devolucao
Local lSubTotCx   := .F.            //Define se imprime sub-total para o Caixa
Local lSubTotDt   := .F.            //Define se imprime sub-total para a Data
Local lSubTotFil  := .F.            //Define se imprime sub-total para a Filial
Local lLayAway    := .F.            //Define se eh Lay-Away

Local nVlrTot     := 0                //Impressao do Valor Total (SL1)
Local nTamL1_DOC  := TamSX3("L1_DOC")[1] // Tamanho do campo L1_DOC
Local cNomeVnd    := ""					// Nome do vendedor

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parametros do relatorio: LJR075 ³
//³                                ³
//³MV_PAR01 -> Filial de          ?³
//³MV_PAR02 -> Filial ate         ?³
//³MV_PAR03 -> Data de            ?³
//³MV_PAR04 -> Data ate           ?³
//³MV_PAR05 -> Caixa de           ?³
//³MV_PAR06 -> Caixa ate          ?³
//³MV_PAR07 -> Considera Devolução?³
//³MV_PAR08 -> Formas de Pgto     ?³
//³MV_PAR09 -> Qual moeda         ?³
//³MV_PAR10 -> Outras Moedas      ?³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Zera estrutura das Arrays para soma dos totais.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFill( aTotCx , 0 )
aFill( aTotDt , 0 )
aFill( aTotFi , 0 )
aFill( aTotGer, 0 )
aFill( aSangria, 0 )

aFill( aTotCxDev ,0 )
aFill( aTotDtDev ,0 )
aFill( aTotFiDev ,0 )
aFill( aTotGerDev,0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicoes das colunas dos relatorios                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aColunas[01] := 000
aColunas[02] := 004
aColunas[03] := 013
If cPaisLoc == "BRA"
	aColunas[04] := 020
	aColunas[05] := 024
Else
	aColunas[04] := 026 // Serie
EndIf
aColunas[06] := 031
If cPaisLoc == "BRA"
	aColunas[07] := 047
	aColunas[08] := 054
Else
	aColunas[07] := 044
	aColunas[08] := 051
EndIf

aColunas[09] := 075
aColunas[10] := 089
aColunas[11] := 103
aColunas[12] := 117
aColunas[13] := 131

aColunas[14] := 145
aColunas[15] := 159
aColunas[16] := 173
aColunas[17] := 187
aColunas[18] := 207

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pictures utilizadas no relatorio.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Foram tirado as PesqPict, pois as colunas de formas de pgto sao configuraveis e preciso delas com
//o mesmo tamanho, para evitar a bagunca com as colunas.
aPicts[01] := "@E 99,999,999.99"//PesqPict( "SL1","L1_DINHEIR",9 )
aPicts[02] := "@E 99,999,999.99"//PesqPict( "SL1","L1_CHEQUES",9 )
aPicts[03] := "@E 99,999,999.99"//PesqPict( "SL1","L1_CARTAO" ,9 )
aPicts[04] := "@E 99,999,999.99"//PesqPict( "SL1","L1_CONVENI",9 )
aPicts[05] := "@E 99,999,999.99"//PesqPict( "SL1","L1_VALES"  ,9 )
aPicts[06] := "@E 99,999,999.99"//PesqPict( "SL1","L1_FINANC" ,9 )
aPicts[07] := "@E 99,999,999.99"//PesqPict( "SL1","L1_OUTROS" ,9 )
aPicts[08] := "@E 99,999,999.99"//PesqPict( "SL1","L1_VLRTOT" ,9 )
aPicts[09] := "@E 99,999,999.99"//PesqPict( "SL1","L1_VLRTOT" ,9 )
aPicts[10] := "@E 99,999,999.99"//PesqPict( "SL1","L1_CREDITO",9 )
aPicts[11] := "@E 99,999,999.99"//PesqPict( "SL1","L1_VLRTOT" ,9 )
aPicts[12] := "@E 99,999,999.99"//PesqPict( "SL1","L1_VLRDEBI",9 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preparando as formas de pagamento                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AAdd( aFormas, { cSimbMoeda, "DINHEIRO",aPicts[01],STR0022   })//"Dinheiro"
AAdd( aFormas, { "CH"      , "CHEQUES" ,aPicts[02],STR0023   })//"Cheque"
AAdd( aFormas, { "CC"      , "CARTAO"  ,aPicts[03],STR0024   })//"Cartao"
AAdd( aFormas, { "CO"      , "CONVENIO",aPicts[04],STR0025   })//"Convenio"
AAdd( aFormas, { "VA"      , "VALES"   ,aPicts[05],STR0026   })//"Vales"
AAdd( aFormas, { "BO"      , "FINANC"  ,aPicts[06],STR0027   })//"Financiado"
AAdd( aFormas, { "OU"      , "OUTROS"  ,aPicts[07],STR0028   })//"Outros"
AAdd( aFormas, { "CD"      , "VLRDEBI" ,aPicts[12],STR0029   })//"Debito"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Limpando separadores de formas de pagamento.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cFormasImp := StrTran(AllTrim(Upper(MV_PAR08)),"/","")
cFormasImp := StrTran(AllTrim(cFormasImp),"*","")
cFormasImp := StrTran(AllTrim(cFormasImp),"-","")
cFormasImp := StrTran(AllTrim(cFormasImp),"|","")
cFormasImp := StrTran(AllTrim(cFormasImp),"\","")
cFormasImp := StrTran(AllTrim(cFormasImp),"_","")
cFormasImp := StrTran(AllTrim(cFormasImp),",","")
cFormasImp := StrTran(AllTrim(cFormasImp),".","")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazenando na array aFormaImp as formas de pagamento p/ impressao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nX := 1 to Len( cFormasImp ) Step 2
	nScanForm := aScan( aFormas,{ |ExpA1| ExpA1[1] == SubStr( cFormasImp,nX,2) } )
	
	If nScanForm > 0
		AAdd( aFormaImp, aFormas[nScanForm] )
	EndIf
Next nX

If Empty( aFormaImp ) .OR. Len( aFormaImp ) > 5
	
	If Len( aFormaImp ) > 5
		// "Foram escolhidas " // " formas de pagamento (" // "). Devido ao tamanho do relatório é permitida até 5 formas. Ajuste os parâmetros do relatório."
		MsgStop( STR0044 + Alltrim(Str(Len(aFormaImp))) + STR0045 + Alltrim( MV_PAR08 ) + STR0046 )
	Else
		Help(" ",1,"LOJR075001")
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Encerra arquivo temporario.                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("TRB")
	dbCloseArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaurar as tabelas utilizadas e limpar os arquivos temporarios    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lUsaQuery
		dbSelectArea("SL1")
		RetIndex("SL1")
		
		dbSelectArea("SL2")
		RetIndex("SL2")
		
		dbSelectArea("SA1")
		RetIndex("SA1")
		
		dbSelectArea("SA3")
		RetIndex("SA3")
		
		dbSelectArea("SB1")
		RetIndex("SB1")
		
		dbSelectArea("SF4")
		RetIndex("SF4")
		
		dbSelectArea("SF1")
		RetIndex("SF1")
		
		dbSelectArea("SD1")
		RetIndex("SD1")
		
		dbSelectArea("SA2")
		RetIndex("SA2")
	Else
		FErase( cArqTmp + OrdBagExt() )
		FErase( cArqTmp + GetDBExtension() )
	EndIf
	
	Return NIL
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea( "TRB" )
dbGotop()
SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Conceito TRB->lDev                                                  ³
//³ Campo Flag que tem por objetivo, separar os registros de venda e os ³
//³ registros de devolucao, com sua criacao, a query fica unica e o     ³
//³ processamento fica mais rapido                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do Cabecalho do relatorio.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec1 := PadR(STR0010,04)//"CX. "
Cabec1 += PadR(STR0011,09)//"Data     "
If cPaisLoc == "BRA"
	Cabec1 += PadR(STR0012, nTamL1_DOC+1) //"N.Fisc."
Else
	Cabec1 += PadR(STR0012, 13) //"N.Fisc."
EndIf
If cPaisLoc == "BRA"
	Cabec1 += PadR(STR0013,04)//"Ser."
Else
	Cabec1 += PadR(STR0013,05)//"Ser."
EndIf
//Nao imprime codigo do vendedor para Localizacoes devido ao tamanho do numero
//da nota fiscal(de 6 ateh 13 caracteres)
If cPaisLoc == "BRA"
	Cabec1 += PadR(STR0014,07)//"Vend.  "
EndIf
if cPaisLoc == "BRA"
	Cabec1 += PadR(STR0015,16)//"Nome Vend       "
Else
	Cabec1 += PadR(STR0015,13)//"Nome Vend       "
EndIf
Cabec1 += PadR(STR0016,07)//"Clien. "
If cPaisLoc == "BRA"
	Cabec1 += PadR(STR0017,20)//"Nome Cliente        "
Else
	Cabec1 += PadR(STR0017,23)//"Nome Cliente        "
Endif

For nX := 1 To Len( aFormaImp )
	Cabec1 += PadL(aFormaImp[nX][4],14)
Next nX

For nX := (1 + Len( aFormaImp )) To 5
	Cabec1 += Space(14)
Next nX

Cabec1 += PadL(STR0038,14)//"Impostos"
Cabec1 += PadL(STR0018,14)//"Desc."
If cPaisLoc == "BRA"
	Cabec1 += PadL(STR0019,14)//"Acr."
Else
	//Impressao dos impostos variaveis ao inves do acrescimo - Localizacoes
	Cabec1 += PadL(STR0037,14)//"Impostos"
EndIf
Cabec1 += PadL(STR0020,14)//"Credito"
Cabec1 += PadL(STR0021,20)//"Total"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento do relatorio.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do While !Eof()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@nLin,00 PSAY STR0030//"*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
	
	cFilAtu   := TRB->FILIAL //Quebra por filial
	lSubTotFil:= .F.
	nTotTrocFl:= 0
	
	Do While !Eof() .AND. cFilAtu == TRB->FILIAL
		
		uDatAtu   := TRB->DTEMI //Quebra por data de emissao
		lSubTotDt := .F.
		nTotTrocDt:= 0
		
		Do While !Eof() .AND. cFilAtu == TRB->FILIAL .AND. uDatAtu == TRB->DTEMI
			
			cCaiAtu   := TRB->CAIXA //Quebra por caixa
			lSubTotCx := .F.
			nTotTrocCx:= 0
			
			Do While !Eof() .AND. cFilAtu == TRB->FILIAL .AND. uDatAtu == TRB->DTEMI .AND. cCaiAtu == TRB->CAIXA
				
				IncRegua(STR0031)//"Imprimindo, aguarde..."
				
				If cPaisLoc <> "BRA"
					nMoeda    := TRB->MOEDA
					If lUsaQuery .AND. mv_par10 == 2  //Nao Imprimir outras moedas
						If TRB->MOEDA <> mv_par09
							DbSkip()
							Loop
						EndIf
					EndIf
				EndIf
				
				lSubTotCx := .T.
				lSubTotDt := .T.
				lSubTotFil:= .T.
				nTotImps  := 0
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao do cabecalho.                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				If nLin > 55
					Cabec(	Titulo	, Cabec1	, Cabec2, ;
							NomeProg, Tamanho	, nTipo )
					nLin     := 8
				EndIf
				               
				If cPaisLoc$"POR|EUA"
					lLayAway := TRB->LAYAWAY == "S"
				Else                                                            
					lLayAway := .F.
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se LDEV estiver vazio, se trata de orcamentos vendidos              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				If Empty( TRB->LDEV )
					lFirstDev := .T.
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Valor total da venda eh a soma dos valores de cada forma de pgto.   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lLayAway
						nVlrTot := TRB->DINHEIRO + TRB->CHEQUES + TRB->CARTAO + TRB->CONVENIO
						nVlrTot += TRB->VALES + TRB->FINANC + TRB->OUTROS + TRB->CREDITO + TRB->VLRDEBI
					Else
						nVlrTot := TRB->VLRTOT
					EndIf
					
					If lVlrPisCof
						nVlrTot -= TRB->ABTOPCC
					EndIf
					
					SA1->(DBSetOrder(1))
					SA1->(MsSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))
					
					If ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) )
						
						nVlrTot -= TRB->VALISS
						
					EndIf
					
					@nLin,aColunas[01] PSAY TRB->CAIXA
					@nLin,aColunas[02] PSAY DtoC(TRB->DTEMI)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Informacoes do Vendedor/Cliente/Nota fiscal                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					@nLin,aColunas[03] PSAY IIf(! Empty(TRB->N_FISCAL),TRB->N_FISCAL,TRB->N_FISCPED )
					@nLin,aColunas[04] PSAY IIf(! Empty(TRB->SERIE),TRB->SERIE,TRB->SERPED )
					//Nao imprime codigo do vendedor para Localizacoes devido ao tamanho do numero
					//da nota fiscal(de 6 ateh 13 caracteres)
					If cPaisLoc == "BRA"
						@nLin,aColunas[05] PSAY TRB->VENDED
						cNomeVnd := TRB->NOME
					Else
						cNomeVnd := Left(TRB->NOME, 12)
					EndIf
					@nLin,aColunas[06] PSAY cNomeVnd
					@nLin,aColunas[07] PSAY TRB->CLIENTE
					@nLin,aColunas[08] PSAY TRB->NOM_CLI
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Impressao das formas de pagamento selecionadas no parametro.        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					If !lLayAway
						For nX := 1 To Len(aFormaImp)
							@nLin,aColunas[nX+8] PSAY Transform( Round(xMoeda(TRB->&(aFormaImp[nX][2]),nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs),;
							aFormaImp[nX][3])
						Next nX
					Else
						For nX := 1 To Len(aFormaImp)
							If Trim(aFormaImp[nX][1]) == Trim(TRB->HISTOR) .OR. ;  //Valido para CH, CC, CD, FI, VA, etc
								(Trim(aFormaImp[nX][1])=="$$" .AND. IsMoney(TRB->HISTOR))  //Dinheiro
								@nLin,aColunas[nX+8] PSAY Transform( Round(xMoeda(TRB->VLRTOT,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs),;
								aFormaImp[nX][3])
							Else
								@nLin,aColunas[nX+8] PSAY Transform( Round(xMoeda(TRB->&(aFormaImp[nX][2]),nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs),;
								aFormaImp[nX][3])
							EndIf
						Next nX
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Informacoes de Impostos/Credito/Acrescimo/Desconto e Valor Total.   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					@nLin,aColunas[14] PSAY Transform(Round(xMoeda(( IIf(lVlrPisCof,TRB->ABTOPCC,0) + ;
					iIf( ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) ), TRB->VALISS, 0 ) ), ;
					nMoeda,mv_par09,TRB->DTEMI,nDecs+1),;
					nDecs), aPicts[07] )
					
					@nLin,aColunas[15] PSAY Transform(Round(xMoeda(TRB->DESCON,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)  , aPicts[08] )
					If cPaisLoc == "BRA"
						@nLin,aColunas[16] PSAY Transform(Round(xMoeda(TRB->ACRES,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs), aPicts[09] )
					Else
						If lTroco
							
							If lUsaQuery
								nVlrTroco  := 0
								For nX := 1 to MoedFin()
									nVlrTroco += Round(xMoeda(&("TRB->TROCO"+AllTrim(Str(nX))),nX,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
								Next nX
								nTotTrocCx  += nVlrTroco
								nTotTrocDt  += nVlrTroco
								nTotTrocFl  += nVlrTroco
								nVlrTot     -= nVlrTroco
							Else
								nTotTrocCx  += TRB->TROCO
								nTotTrocDt  += TRB->TROCO
								nTotTrocFl  += TRB->TROCO
								nVlrTot     -= TRB->TROCO
								nVlrTroco   := TRB->TROCO
							EndIf
							
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Soma os impostos variaveis que incidem na NF³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !lLayAway
							nTotImps  := LJ075Imps("SL1")
						EndIf
						
						@nLin,aColunas[16] PSAY Transform(Round(xMoeda(nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)  , aPicts[09] )
						
					EndIf
					
					@nLin,aColunas[17] PSAY Transform(Round(xMoeda(TRB->CREDITO,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) , aPicts[10] )
					@nLin,aColunas[18] PSAY Transform(Round(xMoeda(nVlrTot,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)      , aPicts[11] )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Caso LDEV estiver preenchido se trata de Orcamentos Devolvidos.     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Else
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprimir indicacao de devolucoes caso for a primeira impressao.     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lFirstDev
						nLin += 1
						@nLin,97 PSAY STR0032//"*************** DEVOLUCOES ***************"
						nLin += 2
						lFirstDev := .F.
					EndIf
					
					nVlrTot := TRB->VLRTOT //Valor total da Devolucao
					
					@nLin,aColunas[01] PSAY TRB->CAIXA
					@nLin,aColunas[02] PSAY DtoC(TRB->DTEMI)
					
					If cPaisLoc <> "BRA"
						If !lLayAway
							nTotImps  := LJ075Imps("SF1")
						EndIf
						
						If ! ( TRB->(FieldPos("VALPIS")) > 0 .AND. TRB->(FieldPos("VALCOFI")) > 0 .AND. TRB->(FieldPos("VALCSLL")) > 0 )
							nVlrTot := Round(xMoeda(TRB->VLRTOT,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) //Valor total da Devolucao
						Else
							nVlrTot := Round(xMoeda(TRB->VLRTOT+nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) //Valor total da Devolucao
						Endif
						
					EndIf
					
					If lVlrPisCof
						nVlrTot -= TRB->ABTOPCC
					EndIf
					
					SA1->(DBSetOrder(1))
					SA1->(MsSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))
					
					If ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) )
						
						nVlrTot -= TRB->VALISS
						
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Informacoes de devolucao                                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					@nLin,aColunas[03] PSAY TRB->N_FISCAL
					@nLin,aColunas[04] PSAY TRB->SERIE
					If cPaisLoc == "BRA"
						@nLin,aColunas[05] PSAY TRB->VENDED
					EndIf
					@nLin,aColunas[06] PSAY TRB->NOME
					@nLin,aColunas[07] PSAY TRB->CLIENTE
					@nLin,aColunas[08] PSAY TRB->NOM_CLI
					@nLin,aColunas[09] PSAY "             "
					@nLin,aColunas[10] PSAY "             "
					@nLin,aColunas[11] PSAY "             "
					@nLin,aColunas[12] PSAY "             "
					@nLin,aColunas[13] PSAY "             "
					@nLin,aColunas[14] PSAY "             "
					@nLin,aColunas[15] PSAY "          "
					If cPaisLoc == "BRA" .OR. (cPaisLoc <> "BRA" .AND. lLayAway)
						@nLin,aColunas[16] PSAY "          "
					Else
						@nLin,aColunas[16] PSAY Transform(Round(xMoeda(nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) , aPicts[09] )
					EndIf
					@nLin,aColunas[17] PSAY "             "
					@nLin,aColunas[18] PSAY Transform( nVlrTot      , aPicts[11] )
				EndIf
				
				nLin += 1
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Realiza soma dos valores selecionados para impressao de sub totais  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Empty( TRB->LDEV )
					Lj075SomCx(@aTotCx,nVlrTot,aFormaImp,nMoeda,nDecs,nTotImps,lLayAway,nVlrTroco)
				Else
					Lj075SomCx(@aTotCxDev,nVlrTot,aFormaImp,nMoeda,nDecs,nTotImps,lLayAway,nVlrTroco)
				EndIf
				
				dbSkip()
			EndDo
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Repasso os valores do Caixa para a quebra por Data.                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lSubTotCx //Somente imprime os sub-totais caso haja registros impressos para o Caixa
				
				If cPaisLoc <> "BRA" .AND. lTroco
					nLin++
					@nLin,00 PSAY STR0039 + cCaiAtu  //"T R O C O           ---- > Caixa: "
					For nX := 1 To Len(aFormaImp)
						If Trim(aFormaImp[nX][1])=="$$"
							@nLin,aColunas[ (08 + nX) ] PSAY Transform( nTotTrocCx, "@E 99,999,999.99" )
						EndIf
					Next nX
				EndIf
				If cPaisLoc == "BRA"
					LJ075SngTr(xFilial("SE5"), xFilial("SE5"), MV_PAR03, MV_PAR04, cCaiAtu, cCaiAtu, @aSangria, @nTroco, aFormaImp)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Caso exista Sangria ou entrada de troco, somar com dinheiro.        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nX := 1 to Len( aSangria )
						aTotCx[nX] -= aSangria[nX]
						aTotDt[nX] -= aSangria[nX]
					Next nX
					
					If nTroco > 0
						nPosMoed := aScan( aFormaImp,{|x| x[1] == cSimbMoeda} )
						If nPosMoed > 0
							aTotCx[nPosMoed] += nTroco
							aTotDt[nPosMoed] += nTroco
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Efetuo o recalculo do total das formas.                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Len( aSangria ) > 0 .OR. nTroco > 0
						aTotCx[10] := 0
						For nX := 1 to Len( aTotCx ) - 1
							If ( AllTrim(Str(nX)) == "6" )              //-- Se for retenção, subtrai.
								aTotCx[10] -= aTotCx[nX]
							ElseIf ( ! AllTrim(Str(nX)) $ "7;8" )   //-- Adiciona se não for desconto/Acréscimo.
								aTotCx[10] += aTotCx[nX]
							EndIf
						Next nX
						
					EndIf
					
					nLin += 1
					@nLin,00 PSAY PadR(STR0042,20)//"Sangria: "
					For nX := 1 To Len(aFormaImp) //Impressao das sangrias
						@nLin,aColunas[ (08 + nX) ] PSAY Transform( aSangria[nX]*(-1) , aPicts[nX] ) //Multiplico por -1 para exibir valores em negativo
					Next nX
					
					nLin += 1
					@nLin,00 PSAY PadR(STR0043,20)//"Entrada de Troco: "
					For nX := 1 To Len(aFormaImp) //Impressao da entrada de troco
						If aFormaImp[nX][1] == cSimbMoeda
							@nLin,aColunas[ (08 + nX) ] PSAY Transform( nTroco , aPicts[nX] )
						Else
							@nLin,aColunas[ (08 + nX) ] PSAY Transform( 0 , aPicts[nX] )
						EndIf
					Next nX
					nLin += 1
				EndIf
				
				nLin += 1
				@nLin,00 PSAY STR0033 + cCaiAtu//"S U B  -  T O T A L ---- > Caixa: "
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime os totais das formas de pagamento.                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
					@nLin,aColunas[ (08 + nX) ] PSAY Transform( (aTotCx[nX] - aTotCxDev[nX]) , aPicts[nX] )
				Next nX
				For nX := 6 To 10//Impressao do desconto/acrescimo/credito/total
					@nLin,aColunas[ (08 + nX) ] PSAY Transform( (aTotCx[nX] - aTotCxDev[nX]) , aPicts[nX] )
				Next nX
				
				nLin += 1
				@nLin,00 PSAY __PrtThinLine() //Linha Grafica
				nLin += 2
			EndIf
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Totaliza no final senao mostra apenas    ³
			//³o total do ultimo caixa e nao total geral³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Lj075SomTot(@aTotDt,aTotCx,aFormaImp)
			Lj075SomTot(@aTotDtDev,aTotCxDev,aFormaImp)
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Limpo os totais para nova concatenacao.                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			aFill( aTotCx , 0 )
			aFill( aTotCxDev , 0 )
			aFill( aSangria, 0 )
			nTroco := 0
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Repasso os valores do Caixa para a quebra por Data.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lSubTotDt //Somente imprime os sub-totais caso haja registros impressos para a Data
			Lj075SomTot(@aTotFi,aTotDt,aFormaImp)
			Lj075SomTot(@aTotFiDev,aTotDtDev,aFormaImp)
			
			If cPaisLoc <> "BRA" .AND. lTroco
				@nLin,00 PSAY STR0040 + DtoC( uDatAtu )  //"T R O C O           ---- > Data: "
				For nX := 1 To Len(aFormaImp)
					If Trim(aFormaImp[nX][1])=="$$"
						@nLin,aColunas[ (08 + nX) ] PSAY Transform( nTotTrocDt, "@E 99,999,999.99" )
					EndIf
				Next nX
				nLin += 2
			EndIf
			
			nLin -= 1
			@nLin,00 PSAY STR0034 + DtoC( uDatAtu )  //"S U B  -  T O T A L ---- > Data: "
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime os totais das formas de pagamento.                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
				@nLin,aColunas[ (08 + nX) ] PSAY Transform( (aTotDt[nX] - aTotDtDev[nX]) , aPicts[nX] )
			Next nX
			For nX := 6 To 10
				@nLin,aColunas[ (08 + nX) ] PSAY Transform( (aTotDt[nX] - aTotDtDev[nX]) , aPicts[nX] )
			Next nX
			
			nLin += 1
			@nLin,00 PSAY __PrtThinLine() //Linha grafica
			
			nLin += 2
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Limpo os totais para nova concatenacao.                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		aFill( aTotDt , 0 )
		aFill( aTotDtDev , 0 )
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Repasso os valores do Caixa para a quebra por Filial.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSubTotFil //Somente imprime os sub-totais caso haja registros impressos para a Filial
		Lj075SomTot(@aTotGer,aTotFi,aFormaImp)
		Lj075SomTot(@aTotGerDev,aTotFiDev,aFormaImp)
		
		If cPaisLoc <> "BRA" .AND. lTroco
			@nLin,00 PSAY STR0041 + cFilAtu  //"T R O C O           ---- > Filial: "
			For nX := 1 To Len(aFormaImp)
				If Trim(aFormaImp[nX][1])=="$$"
					@nLin,aColunas[ (08 + nX) ] PSAY Transform( nTotTrocFl, "@E 99,999,999.99" )
				EndIf
			Next nX
			nLin += 2
		EndIf
		
		nLin -= 1
		@nLin,00 PSAY STR0035 + cFilAtu//"S U B  -  T O T A L ---- > Filial: "
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime os totais das formas de pagamento.                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
			@nLin,aColunas[ (08 + nX) ] PSAY Transform( (aTotFi[nX] - aTotFiDev[nX]), aPicts[nX] )
		Next nX
		For nX := 6 To 10
			@nLin,aColunas[ (08 + nX) ] PSAY Transform( (aTotFi[nX] - aTotFiDev[nX]), aPicts[nX] )
		Next nX
		
		nLin += 1
		@nLin,00 PSAY __PrtThinLine()//Linha grafica
		
		nLin += 2
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpo os totais para nova concatenacao.                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aFill( aTotFi , 0 )
	aFill( aTotFiDev , 0 )
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se existe registro na base de dados, imprimir o total geral.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lDados
	nLin -= 1
	@nLin,00 PSAY STR0036//"T O T A L     G E R A L ---- > "
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime os totais das formas de pagamento.                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
		@nLin,aColunas[ (08 + nX) ] PSAY Transform( (aTotGer[nX] - aTotGerDev[nX]) , aPicts[nX] )
	Next nX
	For nX := 6 To 10
		@nLin,aColunas[ (08 + nX) ] PSAY Transform( (aTotGer[nX] - aTotGerDev[nX]) , aPicts[nX] )
	Next nX
	
	nLin += 1
	@nLin,00 PSAY __PrtFatLine()//Linha grafica grifada !
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Descarrega o Cache armazenado na memoria para a impressora.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MS_FLUSH()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encerra arquivo temporario.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaurar as tabelas utilizadas e limpar os arquivos temporarios    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lUsaQuery
	dbSelectArea("SL1")
	RetIndex("SL1")
	
	dbSelectArea("SL2")
	RetIndex("SL2")
	
	dbSelectArea("SA1")
	RetIndex("SA1")
	
	dbSelectArea("SA3")
	RetIndex("SA3")
	
	dbSelectArea("SB1")
	RetIndex("SB1")
	
	dbSelectArea("SF4")
	RetIndex("SF4")
	
	dbSelectArea("SF1")
	RetIndex("SF1")
	
	dbSelectArea("SD1")
	RetIndex("SD1")
	
	dbSelectArea("SA2")
	RetIndex("SA2")
Else
	FErase( cArqTmp + OrdBagExt() )
	FErase( cArqTmp + GetDBExtension() )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Lj075SomCxºAutor  ³Fernando Salvatori  º Data ³  21/01/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que realiza a soma dos valores de sub total para o   º±±
±±º          ³caixa                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJR075                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Lj075SomCx( aTotCx, 	nVlrTot, 	aFormaImp, 	nMoeda,		;
							nDecs, 		nTotImps,  	lLayAway,	nVlrTroco)
Local nX := 0

For nX := 1 to Len( aFormaImp )
	If !lLayAway
		aTotCx[nX] += Round(xMoeda(TRB->&(aFormaImp[nX][2]),nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
	Else
		If Trim(aFormaImp[nX][1]) == Trim(TRB->HISTOR) .OR. ;  //Valido para CH, CC, CD, FI, VA, etc
			(Trim(aFormaImp[nX][1])=="$$" .AND. IsMoney(TRB->HISTOR))  //Dinheiro
			aTotCx[nX] += 	Round(xMoeda(TRB->VLRTOT,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
		Else
			aTotCx[nX] += Round(xMoeda(TRB->&(aFormaImp[nX][2]),nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
		EndIf
	EndIf
	If cPaisLoc <> "BRA" .AND. Trim(aFormaImp[nX][1])=="$$" .AND. lTroco .AND. nVlrTroco > 0
		aTotCx[nX] -= nVlrTroco
	EndIf
Next nX

SA1->(DBSetOrder(1))
SA1->(MsSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))

If ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) )
	
	nVlrTot -= TRB->VALISS
	
EndIf

aTotCx[06] += Round(xMoeda(( IIf(lVlrPisCof,TRB->ABTOPCC,0) + iIf( ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) ), TRB->VALISS, 0 ) ),nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
aTotCx[07] += Round(xMoeda(TRB->DESCON,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
If cPaisLoc == "BRA"
	aTotCx[08] += Round(xMoeda(TRB->ACRES,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
Else
	aTotCx[08] += Round(xMoeda(nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
EndIf
aTotCx[09] += Round(xMoeda(TRB->CREDITO,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
aTotCx[10] += Round(xMoeda(nVlrTot,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Lj075SomToºAutor  ³Fernando Salvatori  º Data ³  21/01/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que realiza a soma dos valores de sub total para os  º±±
±±º          ³demais totalizadores (data,filial,total geral)              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJR075                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Lj075SomTot(aTotWrite,aTotRead,aFormaImp)
Local nX := 0        //Contador

For nX := 1 To Len(aTotWrite)
	aTotWrite[nX] += aTotRead[nX]
Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LJ075Imps ºAutor  ³Fernando Machima    º Data ³  15/08/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calcula o total de impostos variaveis discriminados de uma º±±
±±º          ³ venda ou devolucao - Localizacoes                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJR075                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJ075Imps(cAliasArq)

LOCAL nX
LOCAL nImpostos  := 0
LOCAL aArea      := GetArea()
LOCAL aTesImpInf := {}

If cAliasArq == "SL1"
	DbSelectArea("SL2")
	DbSetOrder(3)
	If MsSeek(xFilial("SL2")+TRB->SERIE+TRB->N_FISCAL)
		While !Eof() .AND. xFilial("SL2") == SL2->L2_FILIAL .AND. ;
			TRB->SERIE+TRB->N_FISCAL == SL2->L2_SERIE+SL2->L2_DOC
			
			aTesImpInf  := TesImpInf(SL2->L2_TES)
			For nX := 1 to Len(aTesImpInf)
				If aTesImpInf[nX][3] == "1"  //Incide na NF
					nImpostos  += SL2->(FieldGet(FieldPos("L2_"+Substr(aTesImpInf[nX][2],4,7))))
				EndIf
			Next nX
			
			DbSkip()
		End
	EndIf
ElseIf cAliasArq == "SF1"
	DbSelectArea("SD1")
	DbSetOrder(1)
	If MsSeek(xFilial("SD1")+TRB->N_FISCAL+TRB->SERIE+TRB->CLIENTE+TRB->LOJA)
		While !Eof() .AND. xFilial("SD1") == SD1->D1_FILIAL .AND. ;
			TRB->N_FISCAL+TRB->SERIE+TRB->CLIENTE+TRB->LOJA == SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
			
			aTesImpInf  := TesImpInf(SD1->D1_TES)
			For nX := 1 to Len(aTesImpInf)
				If aTesImpInf[nX][3] == "1"  //Incide na NF
					nImpostos  += SD1->(FieldGet(FieldPos("D1_"+Substr(aTesImpInf[nX][2],4,7))))
				EndIf
			Next nX
			
			DbSkip()
		End
	EndIf
EndIf

RestArea(aArea)

Return (nImpostos)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³LJ075aStruºAutor  ³Fernando Machima    º Data ³  15/08/2003 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cria o array com os campos Data e Numero para a execucao doº±±
±±º          ³ comando TCSetField                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJR075                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJ075aStru(aStruTRB)

LOCAL aTam  := {}

aTam := TamSX3("L1_EMISNF")
AAdd( aStruTRB, {"DTEMI","D",aTam[1],aTam[2]} )

aTam := TamSX3("L1_VLRTOT")
AAdd( aStruTRB, {"VLRTOT","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_DINHEIR")
AAdd( aStruTRB, {"DINHEIRO","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_CHEQUES")
AAdd( aStruTRB, {"CHEQUES","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_CARTAO")
AAdd( aStruTRB, {"CARTAO","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_VLRDEBI")
AAdd( aStruTRB, {"VLRDEBI","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_CONVENI")
AAdd( aStruTRB, {"CONVENIO","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_VALES")
AAdd( aStruTRB, {"VALES","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_FINANC")
AAdd( aStruTRB, {"FINANC","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_OUTROS")
AAdd( aStruTRB, {"OUTROS","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_CREDITO")
AAdd( aStruTRB, {"CREDITO","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_DESCONT")
AAdd( aStruTRB, {"DESCON","N",aTam[1],aTam[2]} )

aTam := TamSX3("L1_DESCONT")
AAdd( aStruTRB, {"ACRES","N",aTam[1],aTam[2]} )

If lVlrPisCof
	aTam := TamSX3("L1_ABTOPCC")
	AAdd( aStruTRB, {"ABTOPCC","N",aTam[1],aTam[2]} )
EndIf

If cPaisLoc <> "BRA"
	aTam := TamSX3("L1_MOEDA")
	AAdd( aStruTRB, {"MOEDA","N",aTam[1],aTam[2]} )
	
	If lTroco
		aTam := TamSX3("L1_TROCO1")
		AAdd( aStruTRB, {"TROCO1","N",aTam[1],aTam[2]} )
		
		aTam := TamSX3("L1_TROCO2")
		AAdd( aStruTRB, {"TROCO2","N",aTam[1],aTam[2]} )
		
		aTam := TamSX3("L1_TROCO3")
		AAdd( aStruTRB, {"TROCO3","N",aTam[1],aTam[2]} )
		
		aTam := TamSX3("L1_TROCO4")
		AAdd( aStruTRB, {"TROCO4","N",aTam[1],aTam[2]} )
		
		aTam := TamSX3("L1_TROCO5")
		AAdd( aStruTRB, {"TROCO5","N",aTam[1],aTam[2]} )
	EndIf
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJ075SngTrºAutor  ³Fernando Salvatori  º Data ³ 15/10/2004  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retira os valores de sangria e entrada de troco de um      º±±
±±º          ³ determinado periodo.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ ExpL1 -> .T. - Utiliza Query / .F. - Utiliza Codebase      º±±
±±º          ³ determinado periodo.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ aRet -> [1]: Valor da Sangria.                             º±±
±±º          ³         [2]: Valor da entrada de troco.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function LJ075SngTr(cDeFilSE5, 	cAteFilSE5,	dDataDe, 	dDataAte, ;
					cBancoDe, 	cBancoAte, 	aSangria, 	nTroco, ;
					aFormaImp)
Local lUsaQuery := .F. //Utiliza Query
Local cQuery    := ""  //Query concatenada
Local nPosMoed  := 0   //Posicao da moeda
Local aArea     := GetArea()

aRet := Array(2)
AFill( aRet, 0 )

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		lUsaQuery := .T.
	EndIf
#ENDIF

//Selecionando registros na query
If lUsaQuery
	cQuery := "SELECT SE5.E5_DATA, SE5.E5_VALOR, SE5.E5_BANCO, SE5.E5_AGENCIA, SE5.E5_CONTA, SE5.E5_PREFIXO,"
	cQuery += " SE5.E5_NUMERO, SE5.E5_PARCELA, SE5.E5_TIPO, SE5.E5_TIPODOC, SE5.E5_CLIFOR, SE5.E5_LOJA, SE5.E5_SEQ,"
	cQuery += " SE5.E5_VENCTO, SE5.E5_MOEDA, SE5.E5_RECPAG"
	cQuery += " FROM " + RetSQLName("SE5") + " SE5"
	cQuery += " WHERE SE5.E5_FILIAL BETWEEN '" + cDeFilSE5 + "' AND '" + cAteFilSE5 + "'"
	cQuery += " AND SE5.E5_DATA BETWEEN '" + DToS(dDataDe) + "' AND '" + DToS(dDataAte) + "'"
	cQuery += " AND SE5.E5_BANCO BETWEEN '" + cBancoDe + "' AND '" + cBancoAte + "'"
	cQuery += " AND SE5.E5_TIPODOC = 'TR' "
	cQuery += " AND (SE5.E5_SITUACA <> 'C' OR SE5.E5_MOEDA <> 'ES')"
	cQuery += " AND SE5.D_E_L_E_T_ = ' '"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'SE5TMP', .F., .T.)
	
	TCSetField("SE5TMP", "E5_DATA", "D")
	TCSetField("SE5TMP", "E5_VENCTO", "D")
	
	Do While !EOF()
		//Verifica se tem cancelamento para este titulo.
		If TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
			dbSkip()
			Loop
		EndIf
		
		If ( AllTrim(E5_TIPO) $ ( MV_CRNEG + "/PA" ) ) .OR. E5_VENCTO > E5_DATA
			dbSkip()
			Loop
		EndIf
		
		If E5_RECPAG == "P" // => Saldo inicial
			If (nPosMoed := aScan( aFormaImp,{ |x| x[1] == E5_MOEDA } )) > 0
				aSangria[nPosMoed] += E5_VALOR
			EndIf
		ElseIf E5_RECPAG == "R" // => Saldo inicial
			nTroco += E5_VALOR
		EndIf
		
		dbSkip()
		
	EndDo
	
	dbSelectArea("SE5TMP")
	dbCloseArea()
Else
	dbSelectArea("SE5")
	dbSetOrder(1)
	MsSeek(cDeFilSE5 + DToS( dDataDe ), .T. )	// Filial + Data
	
	While !EOF() .AND. E5_FILIAL >= cDeFilSE5 .AND. E5_FILIAL <= cAteFilSE5
		
		If !(DToS(E5_DATA) >= DToS(dDataDe) .AND. DToS(E5_DATA) <= DToS(dDataAte) .AND. E5_BANCO  >= cBancoDe .AND. E5_BANCO  <= cBancoAte)
			dbSkip()
			Loop
		EndIf
		
		IF E5_SITUACA == "C"
			// Estorno ou cancelado
			dbSkip()
			Loop
		Endif
		
		//Verifica se tem cancelamento para este titulo.
		If TemBxCanc(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)
			dbSkip()
			Loop
		EndIf
		
		If ( AllTrim(E5_TIPO) $ ( MV_CRNEG + "/PA" ) ) .OR. E5_VENCTO > E5_DATA
			dbSkip()
			Loop
		Endif
		
		IF E5_TIPODOC <> "TR"
			dbSkip()
			Loop
		Endif
		
		If E5_RECPAG == "P" // => Saldo inicial
			If (nPosMoed := aScan( aFormaImp,{ |x| x[1] == E5_MOEDA } )) > 0
				aSangria[nPosMoed] += E5_VALOR
			EndIf
		ElseIf E5_RECPAG == "R" // => Saldo inicial
			nTroco += E5_VALOR
		EndIf
		
		dbSkip()
		
	EndDo
EndIf

RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ljr075RptDefºAutor  ³Hanna             º Data ³  25/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para informar as celulas que serao utilizadas no re- º±±
±±º          ³latorio                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LOJA075                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ljr075RptDef()
Local oReport				// Objeto do relatorio
Local oSection1				// Objeto da secao 1
Local oSection2				// Objeto da secao 2
Local oSection3				// Objeto da secao 2
Local oSection4				// Objeto da secao 2
Local cAlias1	:= "SL1"	// Define o cAlias1 como SL1

#IFDEF TOP
	cAlias1		:= GetNextAlias()						// Pega o proximo Alias Disponivel
#ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera a tela com os dados para a confirmação da geracao do relatorio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Mapa de Vendas
//"Este programa tem como objetivo imprimir relatorio "
//"de acordo com os parametros informados pelo usuario."
DEFINE REPORT oReport NAME "LOJR075" TITLE STR0003 PARAMETER "LJR075" ACTION {|oReport| Ljr075PrtRpt( oReport )} DESCRIPTION STR0001 + STR0002
oReport:SetLandscape()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao1 do relatorio, com quebra por filial ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection1 OF oReport TITLE STR0003 TABLES "SL1" 	//"Mapa de Vendas"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "FILIAL"	OF oSection1 ALIAS "SL1" TITLE STR0047 SIZE 2	// Filial

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao2 do relatorio, com quebra por data de emissao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection2 OF oSection1 TITLE STR0003 TABLES "SL1" 	//"Mapa de Vendas"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "DTEMI" OF oSection2 PICTURE "99/99/99" SIZE 8 TITLE STR0011	// DATA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao3 do relatorio, com quebra por Operador - Caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection3 OF oSection2 TITLE STR0003 TABLES "SL1" 	//"Mapa de Vendas"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao3³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "CAIXA"	OF oSection3 TITLE STR0010 SIZE 3		// CX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define a secao3 do relatorio -Vendas emitidas por Dia x Caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE SECTION oSection4 OF oSection3 TITLE STR0003 TABLES "SL1" 	//"Mapa de Vendas"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define as celulas que irao aparecer na secao1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE CELL NAME "N_FISCAL"	OF oSection4 SIZE 6 TITLE STR0012	//"N.Fisc."
DEFINE CELL NAME "SERIE"	OF oSection4 SIZE 3 TITLE STR0013 	// "Ser."
DEFINE CELL NAME "VENDED"	OF oSection4 SIZE 6 TITLE STR0014	// "Vend.  "
DEFINE CELL NAME "NOME"		OF oSection4 SIZE 20 TITLE STR0015	// "Nome Vend       "

DEFINE CELL NAME "A1_COD"	OF oSection4 ALIAS "SA1" TITLE STR0016	// "Clien. "
DEFINE CELL NAME "A1_NOME"	OF oSection4 ALIAS "SA1" SIZE 20 TITLE STR0017	// "Nome Cliente        "

DEFINE CELL NAME "DINHEIRO"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0022	//"Dinheiro"
DEFINE CELL NAME "CHEQUES"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0023	//"Cheque"
DEFINE CELL NAME "CARTAO"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0024	//"Cartao"
DEFINE CELL NAME "CONVENIO"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0025	//"Convenio"
DEFINE CELL NAME "VALES"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0026	//"Vales"
DEFINE CELL NAME "FINANC"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0027	//"Financiado"
DEFINE CELL NAME "OUTROS"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0028	//"Outros"
DEFINE CELL NAME "VLRDEBI"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0029	//"Debito"
DEFINE CELL NAME "RETENC"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0038	//"Retencöes"
DEFINE CELL NAME "DESCON"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0018 	//"Desc."
DEFINE CELL NAME "ACRES"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0019 	//"Acr."
DEFINE CELL NAME "CREDITO"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0020 	//"Credito"

DEFINE CELL NAME "VLRTOT"	OF oSection4 SIZE 13 PICTURE "@E 99,999,999.99" TITLE STR0021	//"Total"

oSection4:Cell("DINHEIRO"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("CHEQUES"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("CARTAO"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("CONVENIO"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("VALES"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("FINANC"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("OUTROS"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("VLRDEBI"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("RETENC"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("DESCON"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("ACRES"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("CREDITO"):SetHeaderAlign( "RIGHT" )
oSection4:Cell("VLRTOT"):SetHeaderAlign( "RIGHT" )
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ljr075PrtRptºAutor  ³Hanna               º Data ³  11/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para impressao do relatorio personalizavel             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ lojr075                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ljr075PrtRpt(oReport)
Local cArqTmp := ""
Local cFilAtu   := "" 				//Filial atual utilizada no relatorio
Local cCaiAtu   := ""				//Caixa utilizada no relatorio
Local uDatAtu   := ""               //Data de emissao utilizada no relatorio
Local nX        := ""				//Var Auxiliar
Local nScanForm := 0                //Posicao da forma de pagamento
Local nMoeda    := 1                //Moeda da transacao
Local nTotTrocCx:= 0				//Total de troco do caixa
Local nTotTrocDt:= 0				//Total de troco da data
Local nTotTrocFl:= 0				//Total de troco da filial
Local nVlrTroco := 0				// Valor do troco total
Local nDecs     := MsDecimais(mv_par09)  //Num. de casas decimais da moeda selecionada
Local nTotImps  := 0                     //Total de impostos variaveis discriminados em uma venda - Localizacoes
Local lDados    := .F.				// Valida se os dados foram gerados
Local aFormas   := {}				//Array contendo as formas de pagamento
Local aFormaImp := {}               //Array com as formas de pagto que serao impressas
Local cFormasImp:= ""               //Formas de pagamento que serao impressas
Local cSimbMoeda:= IIf(cPaisLoc == "BRA","R$","$$")  //Simbolo da moeda(Dinheiro)
Local nTroco    := 0                //Entradas de Troco
Local nPosMoed  := 0                //Posicao da moeda

Local aTotCx    := Array(10)        //Array Total por caixa
Local aTotDt    := Array(10)        //Array Total por data
Local aTotFi    := Array(10)        //Array Total por Filial
Local aTotGer   := Array(10)        //Array Total Geral
Local aSangria  := Array(10)        //Armazena as sangrias Sangria
Local aPicts    := Array(12)        //Array com as pictures de impressao

Local aTotCxDev := Array(10)        //Array Total por caixa
Local aTotDtDev := Array(10)        //Array Total por data
Local aTotFiDev := Array(10)        //Array Total por Filial
Local aTotGerDev:= Array(10)        //Array Total Geral

Local lFirstDev   := .T.            //Considera impressao de Devolucao
Local lSubTotCx   := .F.            //Define se imprime sub-total para o Caixa
Local lSubTotDt   := .F.            //Define se imprime sub-total para a Data
Local lSubTotFil  := .F.            //Define se imprime sub-total para a Filial
Local lLayAway    := .F.            //Define se eh Lay-Away
Local lUsaQuery	  := .F.            //Define se utiliza a query

Local nVlrTot     := 0                //Impressao do Valor Total (SL1)
Local nTamL1_DOC  := TamSX3("L1_DOC")[1] // Tamanho do campo L1_DOC
Local cNomeVnd    := ""					// Nome do vendedor
             
Local oSection1 := oReport:Section(1)				// Define a secao 1 do relatorio
Local oSection2 := oSection1:Section(1)				// Define que a secao 2 serah filha da secao 1
Local oSection3 := oSection2:Section(1)				// Define que a secao 3 serah filha da secao 2
Local oSection4 := oSection3:Section(1)				// Define que a secao 4 serah filha da secao 3

Private lVlrPisCof   := SL1->(FieldPos("L1_ABTOPCC")) > 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parametros do relatorio: LJR075 ³
//³                                ³
//³MV_PAR01 -> Filial de          ?³
//³MV_PAR02 -> Filial ate         ?³
//³MV_PAR03 -> Data de            ?³
//³MV_PAR04 -> Data ate           ?³
//³MV_PAR05 -> Caixa de           ?³
//³MV_PAR06 -> Caixa ate          ?³
//³MV_PAR07 -> Considera Devolução?³
//³MV_PAR08 -> Formas de Pgto     ?³
//³MV_PAR09 -> Qual moeda         ?³
//³MV_PAR10 -> Outras Moedas      ?³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Zera estrutura das Arrays para soma dos totais.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFill( aTotCx , 0 )
aFill( aTotDt , 0 )
aFill( aTotFi , 0 )
aFill( aTotGer, 0 )
aFill( aSangria, 0 )

aFill( aTotCxDev ,0 )
aFill( aTotDtDev ,0 )
aFill( aTotFiDev ,0 )
aFill( aTotGerDev,0 )

#IFDEF TOP
	If 	UPPER(TcGetDb()) <> "DB2"
		lUsaQuery := .T.
	EndIf
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Geracao dos dados para impressao.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LJ075GeraTmp(lUsaQuery,@cArqTmp)

aPicts[01] := "@E 99,999,999.99"//PesqPict( "SL1","L1_DINHEIR",9 )
aPicts[02] := "@E 99,999,999.99"//PesqPict( "SL1","L1_CHEQUES",9 )
aPicts[03] := "@E 99,999,999.99"//PesqPict( "SL1","L1_CARTAO" ,9 )
aPicts[04] := "@E 99,999,999.99"//PesqPict( "SL1","L1_CONVENI",9 )
aPicts[05] := "@E 99,999,999.99"//PesqPict( "SL1","L1_VALES"  ,9 )
aPicts[06] := "@E 99,999,999.99"//PesqPict( "SL1","L1_FINANC" ,9 )
aPicts[07] := "@E 99,999,999.99"//PesqPict( "SL1","L1_OUTROS" ,9 )
aPicts[08] := "@E 99,999,999.99"//PesqPict( "SL1","L1_VLRTOT" ,9 )
aPicts[09] := "@E 99,999,999.99"//PesqPict( "SL1","L1_VLRTOT" ,9 )
aPicts[10] := "@E 99,999,999.99"//PesqPict( "SL1","L1_CREDITO",9 )
aPicts[11] := "@E 99,999,999.99"//PesqPict( "SL1","L1_VLRTOT" ,9 )
aPicts[12] := "@E 99,999,999.99"//PesqPict( "SL1","L1_VLRDEBI",9 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preparando as formas de pagamento                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AAdd( aFormas, { cSimbMoeda, "DINHEIRO",aPicts[01],STR0022   })//"Dinheiro"
AAdd( aFormas, { "CH"      , "CHEQUES" ,aPicts[02],STR0023   })//"Cheque"
AAdd( aFormas, { "CC"      , "CARTAO"  ,aPicts[03],STR0024   })//"Cartao"
AAdd( aFormas, { "CO"      , "CONVENIO",aPicts[04],STR0025   })//"Convenio"
AAdd( aFormas, { "VA"      , "VALES"   ,aPicts[05],STR0026   })//"Vales"
AAdd( aFormas, { "FI"      , "FINANC"  ,aPicts[06],STR0027   })//"Financiado"
AAdd( aFormas, { "OU"      , "OUTROS"  ,aPicts[07],STR0028   })//"Outros"
AAdd( aFormas, { "CD"      , "VLRDEBI" ,aPicts[12],STR0029   })//"Debito"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Limpando separadores de formas de pagamento.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cFormasImp := StrTran(AllTrim(Upper(MV_PAR08)),"/","")
cFormasImp := StrTran(AllTrim(cFormasImp),"*","")
cFormasImp := StrTran(AllTrim(cFormasImp),"-","")
cFormasImp := StrTran(AllTrim(cFormasImp),"|","")
cFormasImp := StrTran(AllTrim(cFormasImp),"\","")
cFormasImp := StrTran(AllTrim(cFormasImp),"_","")
cFormasImp := StrTran(AllTrim(cFormasImp),",","")
cFormasImp := StrTran(AllTrim(cFormasImp),".","")

oSection4:Cell("DINHEIRO"):Disable()
oSection4:Cell("CHEQUES"):Disable()
oSection4:Cell("CARTAO"):Disable()
oSection4:Cell("CONVENIO"):Disable()
oSection4:Cell("VALES"):Disable()
oSection4:Cell("FINANC"):Disable()
oSection4:Cell("OUTROS"):Disable()
oSection4:Cell("VLRDEBI"):Disable()

lDados    := ( TRB->( RecCount() ) <> 0 )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazenando na array aFormaImp as formas de pagamento p/ impressao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to Len( cFormasImp ) Step 2
	nScanForm := aScan( aFormas,{ |ExpA1| ExpA1[1] == SubStr( cFormasImp,nX,2) } )
	
	If nScanForm > 0
		AAdd( aFormaImp, aFormas[nScanForm] )
	EndIf
Next nX

If Empty( aFormaImp ) .OR. Len( aFormaImp ) > 5
	
	If Len( aFormaImp ) > 5
		// "Foram escolhidas " // " formas de pagamento (" // "). Devido ao tamanho do relatório é permitida até 5 formas. Ajuste os parâmetros do relatório."
		MsgStop( STR0044 + Alltrim(Str(Len(aFormaImp))) + STR0045 + Alltrim( MV_PAR08 ) + STR0046 )
	Else
		Help(" ",1,"LOJR075001")
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Encerra arquivo temporario.                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("TRB")
	dbCloseArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaurar as tabelas utilizadas e limpar os arquivos temporarios    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
		dbSelectArea("SL1")
		RetIndex("SL1")
		
		dbSelectArea("SL2")
		RetIndex("SL2")
		
		dbSelectArea("SA1")
		RetIndex("SA1")
		
		dbSelectArea("SA3")
		RetIndex("SA3")
		
		dbSelectArea("SB1")
		RetIndex("SB1")
		
		dbSelectArea("SF4")
		RetIndex("SF4")
		
		dbSelectArea("SF1")
		RetIndex("SF1")
		
		dbSelectArea("SD1")
		RetIndex("SD1")
		
		dbSelectArea("SA2")
		RetIndex("SA2")
	#ELSE
		FErase( cArqTmp + OrdBagExt() )
		FErase( cArqTmp + GetDBExtension() )
	#ENDIF
	
	Return NIL
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea( "TRB" )
dbGotop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento do relatorio.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do While !Eof()
	
	cFilAtu   := TRB->FILIAL //Quebra por filial
	lSubTotFil:= .F.
	nTotTrocFl:= 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicia e imprime o conteudo da Secao1³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:Init()
	oSection1:Cell("FILIAL"):SetValue( TRB->FILIAL )
	oSection1:PrintLine()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gera a barra de processamento. Inicia a Secao 2 e 3³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:IncMeter()

	Do While !Eof() .AND. cFilAtu == TRB->FILIAL
		
		uDatAtu   := TRB->DTEMI //Quebra por data de emissao
		lSubTotDt := .F.
		nTotTrocDt:= 0
		oSection2:Init()
		oSection2:Cell("DTEMI"):SetValue( TRB->DTEMI )
		oSection2:PrintLine()

		Do While !Eof() .AND. cFilAtu == TRB->FILIAL .AND. uDatAtu == TRB->DTEMI
			cCaiAtu   := TRB->CAIXA //Quebra por caixa
			lSubTotCx := .F.
			nTotTrocCx:= 0
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Inicia e imprime o conteudo da Secao2³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSection3:Init()
			oSection3:Cell("CAIXA"):SetValue( TRB->CAIXA )
			oSection3:PrintLine()

			oSection4:Init()
			oSection4:Finish()
			oSection4:Init()

			oSection4:Cell("SERIE"):Show()
			oSection4:Cell("VENDED"):Show()
			oSection4:Cell("NOME"):Show()
			oSection4:Cell("A1_COD"):Show()
			oSection4:Cell("A1_NOME"):Show()

			oSection4:Cell("N_FISCAL"):ShowHeader()
			oSection4:Cell("SERIE"):ShowHeader()
			oSection4:Cell("VENDED"):ShowHeader()
			oSection4:Cell("NOME"):ShowHeader()
			oSection4:Cell("A1_COD"):ShowHeader()
			oSection4:Cell("A1_NOME"):ShowHeader()
			oSection4:Cell("DINHEIRO"):ShowHeader()
			oSection4:Cell("CHEQUES"):ShowHeader()
			oSection4:Cell("CARTAO"):ShowHeader()
			oSection4:Cell("CONVENIO"):ShowHeader()
			oSection4:Cell("VALES"):ShowHeader()
			oSection4:Cell("FINANC"):ShowHeader()
			oSection4:Cell("OUTROS"):ShowHeader()
			oSection4:Cell("VLRDEBI"):ShowHeader()
			oSection4:Cell("RETENC"):ShowHeader()
			oSection4:Cell("DESCON"):ShowHeader()
			oSection4:Cell("ACRES"):ShowHeader()
			oSection4:Cell("CREDITO"):ShowHeader()
			oSection4:Cell("VLRTOT"):ShowHeader()

			Do While !Eof() .AND. cFilAtu == TRB->FILIAL .AND. uDatAtu == TRB->DTEMI .AND. cCaiAtu == TRB->CAIXA
				
				If cPaisLoc <> "BRA"
					nMoeda    := TRB->MOEDA
					If lUsaQuery .AND. mv_par10 == 2  //Nao Imprimir outras moedas
						If TRB->MOEDA <> mv_par09
							DbSkip()
							Loop
						EndIf
					EndIf
				EndIf
				
				lSubTotCx := .T.
				lSubTotDt := .T.
				lSubTotFil:= .T.
				nTotImps  := 0
				
				If cPaisLoc$"POR|EUA"
					lLayAway := TRB->LAYAWAY == "S"
				Else                                                            
					lLayAway := .F.
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se LDEV estiver vazio, se trata de orcamentos vendidos              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Empty( TRB->LDEV )
					lFirstDev := .T.
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Valor total da venda eh a soma dos valores de cada forma de pgto.   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lLayAway
						nVlrTot := TRB->DINHEIRO + TRB->CHEQUES + TRB->CARTAO + TRB->CONVENIO
						nVlrTot += TRB->VALES + TRB->FINANC + TRB->OUTROS + TRB->CREDITO + TRB->VLRDEBI
					Else
						nVlrTot := TRB->VLRTOT
					EndIf
					
					If lVlrPisCof
						nVlrTot -= TRB->ABTOPCC
					EndIf
					
					SA1->( DBSetOrder( 1 ) )
					SA1->( MsSeek( xFilial( "SA1" ) + TRB->CLIENTE + TRB->LOJA ) )
					
					If ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) )
						nVlrTot -= TRB->VALISS
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Informacoes do Vendedor/Cliente/Nota fiscal                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection4:Cell("N_FISCAL"):SetValue( IIf( !Empty( TRB->N_FISCAL ),TRB->N_FISCAL,TRB->N_FISCPED ) )
					oSection4:Cell("SERIE"):SetValue( IIf( !Empty( TRB->SERIE ),TRB->SERIE,TRB->SERPED ) )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Nao imprime codigo do vendedor para Localizacoes devido ao ³
					//³tamanho do numero da nota fiscal(de 6 ateh 13 caracteres)  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cPaisLoc == "BRA"
						oSection4:Cell("VENDED"):SetValue( TRB->VENDED )
						oSection4:Cell("NOME"):SetValue( TRB->NOME )
					Else
						oSection4:Cell("NOME"):SetValue( Left(TRB->NOME, 12) )
					EndIf

					SA1->( DBSetOrder( 1 ) )
					SA1->( MsSeek( xFilial( "SA1" ) + TRB->CLIENTE + TRB->LOJA ) )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Impressao das formas de pagamento selecionadas no parametro.        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lLayAway
						For nX := 1 To Len(aFormaImp)
							oSection4:Cell(aFormaImp[nX][2]):Enable()
							oSection4:Cell(aFormaImp[nX][2]):SetValue( Round(xMoeda(TRB->&(aFormaImp[nX][2]),nMoeda,MV_PAR09,TRB->DTEMI,nDecs+1),nDecs) )
						Next nX
					Else
						For nX := 1 To Len(aFormaImp)
							If Trim(aFormaImp[nX][1]) == Trim(TRB->HISTOR) .OR. ;  //Valido para CH, CC, CD, FI, VA, etc
								(Trim(aFormaImp[nX][1])=="$$" .AND. IsMoney(TRB->HISTOR))  //Dinheiro
								oSection4:Cell("VLRTOT"):SetValue( Round(xMoeda(TRB->VLRTOT,nMoeda,MV_PAR09,TRB->DTEMI,nDecs+1),nDecs) )
							Else
								oSection4:Cell(aFormaImp[nX][2]):Enable()
								oSection4:Cell(aFormaImp[nX][2]):SetValue( Round(xMoeda(TRB->&(aFormaImp[nX][2]),nMoeda,MV_PAR09,TRB->DTEMI,nDecs+1),nDecs) )
							EndIf
						Next nX
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Informacoes de Impostos/Credito/Acrescimo/Desconto e Valor Total.   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection4:Cell("RETENC"):SetValue( Round( xMoeda( ( IIf( lVlrPisCof, TRB->ABTOPCC, 0 ) + ;
					iIf( ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) ), TRB->VALISS, 0 ) ), ;
					nMoeda, mv_par09, TRB->DTEMI, nDecs + 1 ), nDecs ) )

					oSection4:Cell("DESCON"):SetValue( Round(xMoeda(TRB->DESCON,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) )

					If cPaisLoc == "BRA"
						oSection4:Cell("ACRES"):SetValue(Round(xMoeda(TRB->ACRES,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs))
					Else
						If lTroco
							
							If lUsaQuery
								nVlrTroco  := 0
								For nX := 1 to MoedFin()
									nVlrTroco += Round(xMoeda(&("TRB->TROCO"+AllTrim(Str(nX))),nX,mv_par09,TRB->DTEMI,nDecs+1),nDecs)
								Next nX
								nTotTrocCx  += nVlrTroco
								nTotTrocDt  += nVlrTroco
								nTotTrocFl  += nVlrTroco
								nVlrTot     -= nVlrTroco
							Else
								nTotTrocCx  += TRB->TROCO
								nTotTrocDt  += TRB->TROCO
								nTotTrocFl  += TRB->TROCO
								nVlrTot     -= TRB->TROCO
								nVlrTroco   := TRB->TROCO
							EndIf
							
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Soma os impostos variaveis que incidem na NF³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !lLayAway
							nTotImps  := LJ075Imps("SL1")
						EndIf

						oSection4:Cell("ACRES"):SetValue( Round(xMoeda(nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) )
					EndIf

					oSection4:Cell("CREDITO"):SetValue( Round(xMoeda(TRB->CREDITO,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) )
					oSection4:Cell("VLRTOT"):SetValue( Round(xMoeda(nVlrTot,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Caso LDEV estiver preenchido se trata de Orcamentos Devolvidos.     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection4:PrintLine()
				Else
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprimir indicacao de devolucoes caso for a primeira impressao.     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lFirstDev
						oReport:SkipLine(1)
						oReport:PrintText( STR0032 )			//"*************** DEVOLUCOES ***************"
						oReport:SkipLine(1)
						lFirstDev := .F.
					EndIf
					
					nVlrTot := TRB->VLRTOT //Valor total da Devolucao

					If cPaisLoc <> "BRA"
						If !lLayAway
							nTotImps  := LJ075Imps("SF1")
						EndIf
						
						If ! ( TRB->(FieldPos("VALPIS")) > 0 .AND. TRB->(FieldPos("VALCOFI")) > 0 .AND. TRB->(FieldPos("VALCSLL")) > 0 )
							nVlrTot := Round(xMoeda(TRB->VLRTOT,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) //Valor total da Devolucao
						Else
							nVlrTot := Round(xMoeda(TRB->VLRTOT+nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs) //Valor total da Devolucao
						Endif
						
					EndIf
					
					If lVlrPisCof
						nVlrTot -= TRB->ABTOPCC
					EndIf
					
					SA1->(DBSetOrder(1))
					SA1->(MsSeek(xFilial("SA1")+TRB->CLIENTE+TRB->LOJA))
					
					If ( SA1->A1_RECISS == "1" .AND. GetNewPar("MV_DESCISS", .F.) )
						nVlrTot -= TRB->VALISS
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Informacoes de devolucao                                            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oSection4:Cell("N_FISCAL"):SetValue( TRB->N_FISCAL )
					oSection4:Cell("SERIE"):SetValue( TRB->SERIE )

					If cPaisLoc == "BRA"
						oSection4:Cell("VENDED"):SetValue( TRB->VENDED )
					EndIf

					oSection4:Cell("NOME"):SetValue( TRB->NOME )
					oSection4:Cell("CLIENTE"):SetValue( TRB->CLIENTE )
					oSection4:Cell("NOME"):SetValue( TRB->NOME )
					oSection4:Cell("CLIENTE"):SetValue( TRB->CLIENTE )
					
					LJR075HideAll( oSection4 )					

					If cPaisLoc == "BRA" .OR. (cPaisLoc <> "BRA" .AND. lLayAway)
						oSection4:Cell("ACRES"):Hide()
					Else
						oSection4:Cell("ACRES"):Show()
						oSection4:Cell("ACRES"):SetValue(Round(xMoeda(nTotImps,nMoeda,mv_par09,TRB->DTEMI,nDecs+1),nDecs))
					EndIf 
					oSection4:Cell("VLRTOT"):Show()
					oSection4:Cell("VLRTOT"):SetValue( nVlrTot )
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Realiza soma dos valores selecionados para impressao de sub totais  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Empty( TRB->LDEV )
					Lj075SomCx(@aTotCx,nVlrTot,aFormaImp,nMoeda,nDecs,nTotImps,lLayAway,nVlrTroco)
				Else
					Lj075SomCx(@aTotCxDev,nVlrTot,aFormaImp,nMoeda,nDecs,nTotImps,lLayAway,nVlrTroco)
				EndIf
				
				dbSkip()
			EndDo

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Repasso os valores do Caixa para a quebra por Data.                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lSubTotCx //Somente imprime os sub-totais caso haja registros impressos para o Caixa
				
				If cPaisLoc <> "BRA" .AND. lTroco

					For nX := 1 To Len(aFormaImp)
						If Trim(aFormaImp[nX][1])=="$$"
							oReport:SkipLine(1)
							oReport:PrintText( STR0039 + cCaiAtu + nTotTrocCx )  //"T R O C O           ---- > Caixa: "
							oReport:SkipLine(1)
						EndIf
					Next nX
				EndIf

				//ÚÄÄÄÄÄÄÄ¿
				//³Sangria³
				//ÀÄÄÄÄÄÄÄÙ
				If cPaisLoc == "BRA"
					LJ075SngTr(xFilial("SE5"), xFilial("SE5"), MV_PAR03, MV_PAR04, cCaiAtu, cCaiAtu, @aSangria, @nTroco, aFormaImp)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Caso exista Sangria ou entrada de troco, somar com dinheiro.        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nX := 1 to Len( aSangria )
						aTotCx[nX] -= aSangria[nX]
						aTotDt[nX] -= aSangria[nX]
					Next nX
					
					If nTroco > 0
						nPosMoed := aScan( aFormaImp,{|x| x[1] == cSimbMoeda} )
						If nPosMoed > 0
							aTotCx[nPosMoed] += nTroco
							aTotDt[nPosMoed] += nTroco
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Efetuo o recalculo do total das formas.                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Len( aSangria ) > 0 .OR. nTroco > 0
						aTotCx[10] := 0
						For nX := 1 to Len( aTotCx ) - 1
							If ( AllTrim(Str(nX)) == "6" )              //-- Se for retenção, subtrai.
								aTotCx[10] -= aTotCx[nX]
							ElseIf ( ! AllTrim(Str(nX)) $ "7;8" )   //-- Adiciona se não for desconto/Acréscimo.
								aTotCx[10] += aTotCx[nX]
							EndIf
						Next nX
					EndIf
					
					oSection4:Cell("N_FISCAL"):SetSize(13)
					oSection4:Cell("N_FISCAL"):SetValue( STR0042 )
					oSection4:Cell("SERIE"):Disable()
					LJR075HideAll( oSection4 )

					For nX := 1 To Len(aFormaImp)
						oSection4:Cell(aFormaImp[nX][2]):Show()
						oSection4:Cell(aFormaImp[nX][2]):SetValue( aSangria[nX]*(-1) )
					Next nX
					oSection4:PrintLine()
					
					oSection4:Cell("SERIE"):Enable()
					//Impressao da entrada de troco
					oReport:PrintText( STR0043 + Transform( nTroco , aPicts[nX] ))
				EndIf
				
				oSection4:Cell("A1_COD"):Hide()
				oSection4:Cell("A1_NOME"):HideHeader()
				
				oSection3:Finish()
				oSection4:Finish()
				oSection3:Init()
				oSection4:Init()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime os totais das formas de pagamento.                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				oSection4:Cell("N_FISCAL"):SetSize(45)
				oSection4:Cell("N_FISCAL"):SetValue( STR0033 + cCaiAtu )	// "S U B  -  T O T A L ---- > Caixa: "

				For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
					oSection4:Cell(aFormaImp[nX][2]):Show()
					oSection4:Cell(aFormaImp[nX][2]):SetValue( aTotCx[nX] - aTotCxDev[nX] )
				Next nX

				oSection4:Cell("RETENC"):Show()
				oSection4:Cell("RETENC"):SetValue(aTotCx[6] - aTotCxDev[6])
				oSection4:Cell("DESCON"):Show()
				oSection4:Cell("DESCON"):SetValue(aTotCx[7] - aTotCxDev[7])
				oSection4:Cell("ACRES"):Show()
				oSection4:Cell("ACRES"):SetValue(aTotCx[8] - aTotCxDev[8])
				oSection4:Cell("CREDITO"):Show()
				oSection4:Cell("CREDITO"):SetValue(aTotCx[9] - aTotCxDev[9])
				oSection4:Cell("VLRTOT"):Show()
				oSection4:Cell("VLRTOT"):SetValue(aTotCx[10] - aTotCxDev[10])
				
				oSection4:Cell("VENDED"):Disable()
				oSection4:Cell("NOME"):Disable()
				oSection4:Cell("A1_COD"):Disable()

				oSection4:PrintLine()
			EndIf
			
			oSection4:Cell("VENDED"):SetSize(6)
			oSection4:Cell("VENDED"):Enable()
			oSection4:Cell("NOME"):Enable()
			oSection4:Cell("A1_COD"):Enable()

			oSection4:Cell("SERIE"):SetSize(3)
			oSection4:Cell("SERIE"):Show()
			oSection4:Cell("VENDED"):Show()
			oSection4:Cell("NOME"):Show()
			oSection4:Cell("A1_COD"):Show()
			oSection4:Cell("A1_NOME"):Show()
			oSection4:Cell("N_FISCAL"):SetSize(6)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Totaliza no final senao mostra apenas    ³
			//³o total do ultimo caixa e nao total geral³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Lj075SomTot(@aTotDt,aTotCx,aFormaImp)
			Lj075SomTot(@aTotDtDev,aTotCxDev,aFormaImp)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Limpo os totais para nova concatenacao.                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aFill( aTotCx , 0 )
			aFill( aTotCxDev , 0 )
			aFill( aSangria, 0 )
			nTroco := 0
		EndDo
		oSection2:Finish()
		oSection3:Finish()
		oSection4:Finish()
		oSection2:Init()
		oSection3:Init()
		oSection4:Init()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Repasso os valores do Caixa para a quebra por Data.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lSubTotDt //Somente imprime os sub-totais caso haja registros impressos para a Data
			Lj075SomTot(@aTotFi,aTotDt,aFormaImp)
			Lj075SomTot(@aTotFiDev,aTotDtDev,aFormaImp)
			
			If cPaisLoc <> "BRA" .AND. lTroco
				//Impressao do troco
				oReport:PrintText( STR0040 + DtoC( uDatAtu ) + Transform( nTotTrocDt, "@E 99,999,999.99" ) )
				oReport:SkipLine(1)
			EndIf

			LJR075HideAll( oSection4 )			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime os totais das formas de pagamento.                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oSection4:Cell("N_FISCAL"):SetSize(45)
			oSection4:Cell("N_FISCAL"):SetValue( STR0034 + DtoC( uDatAtu ) )	//"S U B  -  T O T A L ---- > Data: "

			For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
				oSection4:Cell(aFormaImp[nX][2]):Show()
				oSection4:Cell(aFormaImp[nX][2]):SetValue( aTotDt[nX] - aTotDtDev[nX] )
			Next nX

			oSection4:Cell("RETENC"):Show()
			oSection4:Cell("RETENC"):SetValue(aTotDt[6] - aTotDtDev[6])
			oSection4:Cell("DESCON"):Show()
			oSection4:Cell("DESCON"):SetValue(aTotDt[7] - aTotDtDev[7])
			oSection4:Cell("ACRES"):Show()
			oSection4:Cell("ACRES"):SetValue(aTotDt[8] - aTotDtDev[8])
			oSection4:Cell("CREDITO"):Show()
			oSection4:Cell("CREDITO"):SetValue(aTotDt[9] - aTotDtDev[9])
			oSection4:Cell("VLRTOT"):Show()
			oSection4:Cell("VLRTOT"):SetValue(aTotDt[10] - aTotDtDev[10])
				
			oSection4:Cell("NOME"):Disable()
			oSection4:Cell("A1_COD"):Disable()
			oSection4:Cell("VENDED"):Disable()

			oSection4:PrintLine()

			oSection4:Cell("N_FISCAL"):SetSize(6)
			oSection4:Cell("NOME"):Enable()
			oSection4:Cell("A1_COD"):Enable()
			oSection4:Cell("VENDED"):Enable()
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Limpo os totais para nova concatenacao.                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aFill( aTotDt , 0 )
		aFill( aTotDtDev , 0 )
	EndDo
	oSection1:Finish()
	oSection2:Finish()
	oSection3:Finish()
	oSection4:Finish()
	oSection1:Init()
	oSection2:Init()
	oSection3:Init()
	oSection4:Init()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Repasso os valores do Caixa para a quebra por Filial.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSubTotFil //Somente imprime os sub-totais caso haja registros impressos para a Filial
		Lj075SomTot(@aTotGer,aTotFi,aFormaImp)
		Lj075SomTot(@aTotGerDev,aTotFiDev,aFormaImp)
		
		If cPaisLoc <> "BRA" .AND. lTroco
			oReport:PrintText( STR0041 + cFilAtu + Transform( nTotTrocFl, "@E 99,999,999.99" ) )	  //"T R O C O           ---- > Filial: "
			oReport:SkipLine(1)
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Esconde as celulas do relatorio³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		LJR075HideAll( oSection4 )
		oSection4:Cell("N_FISCAL"):SetSize(45)
		oSection4:Cell("N_FISCAL"):SetValue( STR0035 + cFilAtu )	//"S U B  -  T O T A L ---- > Filial: "

		For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
			oSection4:Cell(aFormaImp[nX][2]):Show()
			oSection4:Cell(aFormaImp[nX][2]):SetValue( aTotFi[nX] - aTotFiDev[nX] )
		Next nX

		oSection4:Cell("RETENC"):Show()
		oSection4:Cell("RETENC"):SetValue(aTotFi[6] - aTotFiDev[6])
		oSection4:Cell("DESCON"):Show()
		oSection4:Cell("DESCON"):SetValue(aTotFi[7] - aTotFiDev[7])
		oSection4:Cell("ACRES"):Show()
		oSection4:Cell("ACRES"):SetValue(aTotFi[8] - aTotFiDev[8])
		oSection4:Cell("CREDITO"):Show()
		oSection4:Cell("CREDITO"):SetValue(aTotFi[9] - aTotFiDev[9])
		oSection4:Cell("VLRTOT"):Show()
		oSection4:Cell("VLRTOT"):SetValue(aTotFi[10] - aTotFiDev[10])
			
		oSection4:Cell("NOME"):Disable()
		oSection4:Cell("A1_COD"):Disable()
		oSection4:Cell("VENDED"):Disable()

		oSection4:PrintLine()

		oSection4:Cell("N_FISCAL"):SetSize(6)
		oSection4:Cell("NOME"):Enable()
		oSection4:Cell("A1_COD"):Enable()
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Limpo os totais para nova concatenacao.                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aFill( aTotFi , 0 )
	aFill( aTotFiDev , 0 )
EndDo
oSection4:Finish()
oSection3:Finish()
oSection2:Finish()
oSection1:Finish()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se existe registro na base de dados, imprimir o total geral.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lDados
	oSection1:Init()
	oSection2:Init()
	oSection3:Init()
	oSection4:Init()
	LJR075HideAll( oSection4 )

	oSection4:Cell("N_FISCAL"):SetSize(45)
	oSection4:Cell("N_FISCAL"):SetValue( STR0036 )	//"T O T A L     G E R A L ---- > "

	For nX := 1 To Len(aFormaImp) //Impressao das formas de pagto
		oSection4:Cell(aFormaImp[nX][2]):Show()
		oSection4:Cell(aFormaImp[nX][2]):SetValue( aTotGer[nX] - aTotGerDev[nX] )
	Next nX

	oSection4:Cell("RETENC"):Show()
	oSection4:Cell("RETENC"):SetValue(aTotGer[6] - aTotGerDev[6])
	oSection4:Cell("DESCON"):Show()
	oSection4:Cell("DESCON"):SetValue(aTotGer[7] - aTotGerDev[7])
	oSection4:Cell("ACRES"):Show()
	oSection4:Cell("ACRES"):SetValue(aTotGer[8] - aTotGerDev[8])
	oSection4:Cell("CREDITO"):Show()
	oSection4:Cell("CREDITO"):SetValue(aTotGer[9] - aTotGerDev[9])
	oSection4:Cell("VLRTOT"):Show()
	oSection4:Cell("VLRTOT"):SetValue(aTotGer[10] - aTotGerDev[10])
		
	oSection4:Cell("NOME"):Disable()
	oSection4:Cell("A1_COD"):Disable()   
	oSection4:Cell("VENDED"):Disable()

	oSection4:PrintLine()

	oSection4:Cell("N_FISCAL"):SetSize(6)
	oSection4:Cell("NOME"):Enable()
	oSection4:Cell("A1_COD"):Enable()
EndIf
oSection4:Finish()
oSection3:Finish()
oSection2:Finish()
oSection1:Finish()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encerra arquivo temporario.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaurar as tabelas utilizadas e limpar os arquivos temporarios    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lUsaQuery
	dbSelectArea("SL1")
	RetIndex("SL1")
	
	dbSelectArea("SL2")
	RetIndex("SL2")
	
	dbSelectArea("SA1")
	RetIndex("SA1")
	
	dbSelectArea("SA3")
	RetIndex("SA3")
	
	dbSelectArea("SB1")
	RetIndex("SB1")
	
	dbSelectArea("SF4")
	RetIndex("SF4")
	
	dbSelectArea("SF1")
	RetIndex("SF1")
	
	dbSelectArea("SD1")
	RetIndex("SD1")
	
	dbSelectArea("SA2")
	RetIndex("SA2")
Else
	FErase( cArqTmp + OrdBagExt() )
	FErase( cArqTmp + GetDBExtension() )
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LJR075HideAllºAutor  ³Hanna Caroline   º Data ³  11/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esconde as celulas do relatorio                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGALOJA                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LJR075HideAll( oSection4 )
oSection4:Cell("SERIE"):Hide()
oSection4:Cell("VENDED"):Hide()
oSection4:Cell("NOME"):Hide()
oSection4:Cell("A1_COD"):Hide()
oSection4:Cell("A1_NOME"):Hide()

oSection4:Cell("DINHEIRO"):Hide()
oSection4:Cell("CHEQUES"):Hide()
oSection4:Cell("CARTAO"):Hide()
oSection4:Cell("CONVENIO"):Hide()
oSection4:Cell("VALES"):Hide()
oSection4:Cell("FINANC"):Hide()
oSection4:Cell("OUTROS"):Hide()
oSection4:Cell("VLRDEBI"):Hide()
oSection4:Cell("RETENC"):Hide()
oSection4:Cell("DESCON"):Hide()
oSection4:Cell("ACRES"):Hide()
oSection4:Cell("CREDITO"):Hide()
oSection4:Cell("VLRTOT"):Hide()

oSection4:Cell("N_FISCAL"):HideHeader()
oSection4:Cell("SERIE"):HideHeader()
oSection4:Cell("VENDED"):HideHeader()
oSection4:Cell("NOME"):HideHeader()
oSection4:Cell("A1_COD"):HideHeader()
oSection4:Cell("A1_NOME"):HideHeader()

oSection4:Cell("DINHEIRO"):HideHeader()
oSection4:Cell("CHEQUES"):HideHeader()
oSection4:Cell("CARTAO"):HideHeader()
oSection4:Cell("CONVENIO"):HideHeader()
oSection4:Cell("VALES"):HideHeader()
oSection4:Cell("FINANC"):HideHeader()
oSection4:Cell("OUTROS"):HideHeader()
oSection4:Cell("VLRDEBI"):HideHeader()
oSection4:Cell("RETENC"):HideHeader()
oSection4:Cell("DESCON"):HideHeader()
oSection4:Cell("ACRES"):HideHeader()
oSection4:Cell("CREDITO"):HideHeader()
oSection4:Cell("VLRTOT"):HideHeader()

Return
