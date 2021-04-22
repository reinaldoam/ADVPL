#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 01/08/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function NFAGRO        // incluido pelo assistente de conversao do AP6 IDE em 01/08/02
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M,_xtes")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,WNREL,NTAMNF,CSTRING,COBS1,COBS2")
SetPrvt("COBS3,COBS4,COBS5,COBS6,COBS7,COBS8")
SetPrvt("CPEDANT,NLININI,XNUM_NF,XSERIE,XEMISSAO,XTOT_FAT")
SetPrvt("XLOJA,XFRETE,XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS")
SetPrvt("XICMS_RET,XVALOR_IPI,XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO")
SetPrvt("XPLIQUI,XTIPO,XESPECIE,XVOLUME,CPEDATU,CITEMATU")
SetPrvt("PEDIDO_S,XPED_VEND,XITEM_PED,XNUM_NFDV,XPREF_DV,XICMS")
SetPrvt("XIPI,XCOD_PRO,XQTD_PRO,XPRE_UNI,XPRE_TAB,XVAL_IPI")
SetPrvt("XDESC,XVAL_DESC,XVAL_MERC,XTES,XCF,XICMSOL")
SetPrvt("XICM_PROD,XIPI_PROD,XDESC_ZFR,XPESO_PRO,XPESO_UNIT,XDESCRICAO")
SetPrvt("XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS,XMEN_POS")
SetPrvt("XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ,XDCR")
SetPrvt("XDTDCR,I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID")
SetPrvt("XPED,XPESO_BRUTO,XP_LIQ_PED,XCLIENTE,XTIPO_CLI,XMENSAGEM")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,XDESCCOMP,J,XCOD_CLI,XNOME_CLI,XEND_CLI")
SetPrvt("XBAIRRO,XCEP_CLI,XMUN_CLI,XEST_CLI,XEND_CLIE,XBAIRROE")
SetPrvt("XCEP_CLIE,XMUN_CLIE,XEST_CLIE,XCOB_CLI,XREC_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XINSC_MUN,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA")
SetPrvt("XCALCSUF,ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP")
SetPrvt("XMUN_TRANSP,XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XIES_TRANSP")
SetPrvt("XDESCDUP,XPARC_DUP,XVENC_DUP,XVALOR_DUP,XDUPLICATAS,XNATUREZA")
SetPrvt("XOBS,XCOD_MENS,XFORNECE,XNFORI,XPEDIDO,XPESOPROD")
SetPrvt("INSC_MUN,XFAX,XTRANSP,NOPC,CCOR,NTAMDET,CPISCOFINS")
SetPrvt("XB_ICMS_SOL,XV_ICMS_SOL,_LIMPMSZN,_DESCZFR,LSERVICO,NLINHA")
SetPrvt("XD,_UNITZFR,NBEGIN,_COD_FIS,XDAT_FT,_LSEGNOTA")

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 01/08/02 ==>     #DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ NFNOVO   ³ Autor ³   Wagner Correa       ³ Data ³ 26/07/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Nota Fiscal de Entrada/Saida                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico - Editora Novo Tempo                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteracao ³ Impressao dos dados da escola - yoji 02/02/2001            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota Fiscal                       ³
//³ mv_par02             // Ate a Nota Fiscal                    ³
//³ mv_par03             // Da Serie                             ³
//³ mv_par04             // Nota Fiscal de Entrada/Saida         ³
//³ mv_par05             // Pega inscricao estadual do cliente   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CbTxt     := ""
CbCont    := ""
nOrdem    := 0
Alfa      := 0
Z         := 0
M         := 0
tamanho   := "G"
limite    := 220
titulo    := PADC("Nota Fiscal - Nfiscal",74)
cDesc1    := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida",74)
cDesc2    := ""
cDesc3    := PADC("da Nfiscal",74)
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog  := "NFISCAL"
cPerg     := "NFSIGW"
nLastKey  := 0
lContinua := .T.
nLin      := 0
wnrel     := "SIGANF"

nTamNf:=60     // Apenas Informativo

Pergunte(cPerg,.F.)      //   Pergunta no SX1
cString:="SF2"

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

/*
#IFDEF WINDOWS

	cObs1 := Space(70)
	cObs2 := Space(70)
	cObs3 := Space(70)
	cObs4 := Space(70)
	cObs5 := Space(70)
	cObs6 := Space(70)
	cObs7 := Space(70)
	
	@ 000,00 TO 300,600 DIALOG oObservacao TITLE "Observacao da Nota Fiscal"
	@ 010,10 SAY "Observacao: "
	@ 010,50 Get cObs1
	@ 025,10 SAY "Continuacao: "
	@ 025,50 Get cObs2
	@ 040,10 SAY "Continuacao: "
	@ 040,50 Get cObs3
	@ 055,10 SAY "Continuacao: "
	@ 055,50 Get cObs4
	@ 070,10 SAY "Continuacao: "
	@ 070,50 Get cObs5
	@ 085,10 SAY "Continuacao: "
	@ 085,50 Get cObs6
	@ 100,10 SAY "Continuacao: "
	@ 100,50 Get cObs7
	//	@ 115,10 SAY "Continuacao: "
	//	@ 115,50 Get cObs8
	
	@ 130,270 BMPBUTTON TYPE 1 ACTION Close(oObservacao)
	Activate Dialog oObservacao CENTERED
#ENDIF
*/
VerImp()

#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP6 IDE em 01/08/02 ==>     RptStatus({|| Execute(RptDetail)})
	Return
	// Substituido pelo assistente de conversao do AP6 IDE em 01/08/02 ==>     Function RptDetail
	Static Function RptDetail()
#ENDIF

If mv_par04 == 2
	dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial()+mv_par01+mv_par03)
	cPedant := SD2->D2_PEDIDO
Else
	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
Endif

SetRegua(Val(mv_par02)-Val(mv_par01))

If mv_par04 == 2
	dbSelectArea("SF2")
	While !eof() .and. SF2->F2_DOC    <= mv_par02 .and. lContinua
		If SF2->F2_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		#IFNDEF WINDOWS
			IF LastKey()==286
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ELSE
			IF lAbortPrint
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ENDIF
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verificação do dia de pagamento do cliente                   ³
		//³ Pagamento somente nas quartas - feiras                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*		dbSelectArea("SE1")
		dbsetorder(1)
		dbseek(xfilial()+SF2->F2_SERIE+SF2->F2_DOC)
		if SE1->E1_CLIENTE $ "#000008#000005#000112#000024#000146"
			// E1_VENCTO e E1_VENCREA
			xxdia := dow(SE1->E1_VENCTO)
			if xxdia # 4
				Aviso("Sr(a). "+Substr(cUsuario,7,15),"Favor roda rotina de correção de pagamento do cliente.",{"Ok"})
				Exit
			endif
  		endif                     */
		xLOJA := space(len(SF2->F2_LOJA))
		dbSelectArea("SF2")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio de Levantamento dos Dados da Nota Fiscal              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// * Cabecalho da Nota Fiscal
		
		xNUM_NF     :=SF2->F2_DOC             // Numero
		xSERIE      :=SF2->F2_SERIE           // Serie
		xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF2->F2_VALFAT          // Valor Total da Fatura
		if xTOT_FAT == 0
			xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
		endif
		xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
		xFRETE      :=SF2->F2_FRETE           // Frete
		xSEGURO     :=SF2->F2_SEGURO          // Seguro
		xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
		xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
		xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
		xVOLUME     :=SF2->F2_VOLUME1         // Volume 1 na Nota
		
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbSetOrder(3)
		dbSeek(xFilial()+xNUM_NF+xSERIE)
		cPedAtu  := SD2->D2_PEDIDO
		cItemAtu := SD2->D2_ITEMPV
		Pedido_S := SD2->D2_PEDIDO
		
		xPED_VEND :={}                         // Numero do Pedido de Venda
		xITEM_PED :={}                         // Numero do Item do Pedido de Venda
		xNUM_NFDV :={}                         // nUMERO QUANDO HOUVER DEVOLUCAO
		xPREF_DV  :={}                         // Serie  quando houver devolucao
		xICMS     :={}                         // Porcentagem do ICMS
		xIPI      :={}                         // Porcentagem do IPI
		xCOD_PRO  :={}                         // Codigo  do Produto
		xGRUPO    :={}                         // Grupo do Produto
		xQTD_PRO  :={}                         // Peso/Quantidade do Produto
		xPRE_UNI  :={}                         // Preco Unitario de Venda
		xPRE_TAB  :={}                         // Preco Unitario de Tabela
		xIPI      :={}                         // Porcentagem do IPI
		xVAL_IPI  :={}                         // Valor do IPI
		xDESC     :={}                         // Desconto por Item
		xVAL_DESC :={}                         // Valor do Desconto
		xVAL_MERC :={}                         // Valor da Mercadoria
		xTES      :={}                         // TES
		xCF       :={}                         // Classificacao quanto natureza da Operacao
		xICMSOL   :={}                         // Base do ICMS Solidario
		xICM_PROD :={}                         // ICMS do Produto
		xIPI_PROD :={}                         // ICMS do Produto
		xDESC_ZFR :={}                         // Desconto Zona Franca
		xPISCOFINS:={}                         // PIS e COFINS (SIM ou NAO)

		While !Eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			If SD2->D2_SERIE #mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                   // do Parametro Informado !!!
				Loop
			Endif
			
			AADD(xPISCOFINS,CPISCOFINS)
			_sAlias := Alias()
			dbselectarea("SC6")
			dbsetorder(1)
			dbseek(xfilial()+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
			dbSelectArea(_sAlias)
			if cPISCOFINS == "S"
				AADD(xPRE_UNI  ,SC6->C6_PRUNIT)
				AADD(xVAL_MERC ,SC6->C6_PRUNIT * SD2->D2_QUANT)
			else
				AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
				AADD(xVAL_MERC ,SD2->D2_TOTAL)
			endif
			
			AADD(xPED_VEND ,SD2->D2_PEDIDO)
			AADD(xITEM_PED ,SD2->D2_ITEMPV)
			AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
			AADD(xPREF_DV  ,SD2->D2_SERIORI)
			AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xIPI      ,IIf(Empty(SD2->D2_IPI ),0,SD2->D2_IPI ))
			AADD(xCOD_PRO  ,SD2->D2_COD)
			AADD(xGRUPO    ,SD2->D2_GRUPO)// Ulisses 01/06/06
			AADD(xQTD_PRO  ,SD2->D2_QUANT)     // Guarda as quant. da NF
			AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
			AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
			AADD(xVAL_IPI  ,SD2->D2_VALIPI)
			AADD(xDESC     ,SD2->D2_DESC)
			AADD(xDESC_ZFR ,SD2->D2_DESCZFR)
			AADD(xTES      ,SD2->D2_TES)
			AADD(xCF       ,SD2->D2_CF)
			AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xIPI_PROD ,IIf(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
			_xtes := SD2->D2_TES
			dbskip()
		End
		
		dbSelectArea("SB1")                     // Desc. Generica do Produto
		dbSetOrder(1)
		xPESO_PRO:={}                           // Peso Liquido
		xPESO_UNIT :={}                         // Peso Unitario do Produto
		xDESCRICAO :={}                         // Descricao do Produto
		xUNID_PRO:={}                           // Unidade do Produto
		xCOD_TRIB:={}                           // Codigo de Tributacao
		xMEN_TRIB:={}                           // Mensagens de Tributacao
		xCOD_FIS :={}                           // Cogigo Fiscal
		xCLAS_FIS:={}                           // Classificacao Fiscal
		xMEN_POS :={}                           // Mensagem da Posicao IPI
		xISS     :={}                           // Aliquota de ISS
		xTIPO_PRO:={}                           // Tipo do Produto
		xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL:={}
		xPESO_LIQ:= 0
		xDCR     :={}
		xDTDCR   :={}
		I:=1
		
		SBM->(dbSetOrder(1))//Ulisses 01/06/06
		
		For I:=1 to Len(xCOD_PRO)
			dbSeek(xFilial()+xCOD_PRO[I])
			
			AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
			xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]  // Peso Liquido do Produto
			AADD(xPESO_UNIT , SB1->B1_PESO)
			AADD(xUNID_PRO ,SB1->B1_UM)                      
			                      
			********************Ulisses 01/06/06*********************************
			If SBM->(dbSeek(xFilial("SBM")+xGRUPO[I])) .and. SBM->BM_TIPO = "2"
              If SBM->BM_ASSINAT = "S"
                 cDesc := "ASSINATURA DO JORNAL CONFORME CONTRATO"
              Else       
                 cDesc := "VEICULACAO DE SUA PUBLICIDADE NO CADERNO "+Alltrim(SBM->BM_PICPAD)+" SESSAO "+Alltrim(SB1->B1_DESC)+""
              EndIf   
			Else
              cDesc := SB1->B1_DESC
            EndIf
            **********************************************************************
            			
 		    AADD(xDESCRICAO ,cDesc)
			AADD(xCOD_FIS   ,ALLTRIM(SB1->B1_CLASFIS))  // JORGE
			AADD(xCOD_TRIB ,AllTrim(SB1->B1_ORIGEM)+AllTrim(SB1->B1_GRTRIB))
           
			If Ascan(xMEN_TRIB, AllTrim(SB1->B1_ORIGEM)+AllTrim(SB1->B1_GRTRIB))==0
				AADD(xMEN_TRIB ,AllTrim(SB1->B1_ORIGEM)+AllTrim(SB1->B1_GRTRIB))
			Endif
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			If npElem == 0
				AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			endif
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			DO CASE
				CASE npElem == 1 ; _CLASFIS := "A"
				CASE npElem == 2 ; _CLASFIS := "B"
				CASE npElem == 3 ; _CLASFIS := "C"
				CASE npElem == 4 ; _CLASFIS := "D"
				CASE npElem == 5 ; _CLASFIS := "E"
				CASE npElem == 6 ; _CLASFIS := "F"
			ENDCASE
			nPteste := Ascan(xCLFISCAL,_CLASFIS)
			If nPteste == 0
				AADD(xCLFISCAL,_CLASFIS)
			Endif
			
			If SB1->B1_ALIQISS > 0
				AADD(xISS ,SB1->B1_ALIQISS)
			else
				AADD(xISS ,0)
			Endif
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			xPESO_LIQUID:=0                                 // Peso Liquido da Nota Fiscal
			For j:=1 to Len(xPESO_PRO)
				xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[j]
			Next
		Next
		
		dbSelectArea("SC5")                            // * Pedidos de Venda
		dbSetOrder(1)
		
		xPED        := {}
		xPESO_BRUTO := 0
		xP_LIQ_PED  := 0
		xCONDPAG    := space(len(SC5->C5_CONDPAG))
		xCLIENTE    := space(len(SC5->C5_CLIENTE))
		
		For I:=1 to Len(xPED_VEND)
			dbSeek(xFilial()+xPED_VEND[I])
			If ASCAN(xPED,xPED_VEND[I])==0
				dbSeek(xFilial()+xPED_VEND[I])
				xCLIENTE    :=SC5->C5_CLIENTE            // Codigo do Cliente
				xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
				xMENSAGEM   :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
				xTPFRETE    :=SC5->C5_TPFRETE            // Tipo de Entrega
				xCONDPAG    :=SC5->C5_CONDPAG            // Condicao de Pagamento
				xPESO_BRUTO :=SC5->C5_PBRUTO             // Peso Bruto
				xP_LIQ_PED  :=xP_LIQ_PED + SC5->C5_PESOL // Peso Liquido
				xCOD_VEND:= {SC5->C5_VEND1,;             // Codigo do Vendedor 1
				SC5->C5_VEND2,;             // Codigo do Vendedor 2
				SC5->C5_VEND3,;             // Codigo do Vendedor 3
				SC5->C5_VEND4,;             // Codigo do Vendedor 4
				SC5->C5_VEND5}              // Codigo do Vendedor 5
				xDESC_NF := {SC5->C5_DESC1,;             // Desconto Global 1
				SC5->C5_DESC2,;             // Desconto Global 2
				SC5->C5_DESC3,;             // Desconto Global 3
				SC5->C5_DESC4}              // Desconto Global 4
				AADD(xPED,xPED_VEND[I])
			Endif
			
			If xP_LIQ_PED >0
				xPESO_LIQ := xP_LIQ_PED
			Endif
			
		Next
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		//		dbSeek(xFilial("SE4")+xCONDPAG)  // 060605 agnaldo
		dbSeek(xFilial()+xCONDPAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		dbSelectArea("SC6")                    // * Itens de Pedido de Venda
		dbSetOrder(1)
		xPED_CLI :={}                          // Numero de Pedido
		xDESC_PRO:={}                          // Descricao aux do produto
		xDESCCOMP:={}                          // Classificacao Fiscal Complementar
		
		J:=Len(xPED_VEND)
		For I:=1 to J
			dbSeek(xFilial()+xPED_VEND[I]+xITEM_PED[I])
			AADD(xPED_CLI ,SC6->C6_PEDCLI)
			AADD(xDESC_PRO,ALLTRIM(SC6->C6_DESCRI))
		Next
		
		If AllTrim(xTIPO) $ 'N.C.P.I.S.T.O'
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			
			xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI:=SA1->A1_NOME            // Nome
			xEND_CLI :=SA1->A1_END
			xBAIRRO  :=SA1->A1_BAIRRO
			xCEP_CLI :=SA1->A1_CEP
			xMUN_CLI :=SA1->A1_MUN
			xEST_CLI :=SA1->A1_EST
			
			xEND_CLIE :=alltrim(SA1->A1_END)
			xBAIRROE  :=alltrim(SA1->A1_BAIRRO)
			xCEP_CLIE :=SA1->A1_CEP
			xMUN_CLIE :=alltrim(SA1->A1_MUN)
			xEST_CLIE :=alltrim(SA1->A1_EST)
			
			
			xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual  agnaldo 03/04/04
			/*
			xINSC_CLI:=iif(mv_par05 = 1,SA1->A1_INSCR,;
			iif(mv_par05 = 2,SA1->A1_INSCR2,;
			iif(mv_par05 = 3,SA1->A1_INSCR3,;
			iif(mv_par05 = 4,SA1->A1_INSCR4," "))))
			*/
			xINSC_MUN:=SA1->A1_INSCRM           // Inscricao Municipal
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			xSUFRAMA :=SA1->A1_SUFRAMA            // Codigo Suframa
			xCALCSUF :=SA1->A1_CALCSUF            // Calcula Suframa
			if !empty(xSUFRAMA) .and. xCALCSUF =="S"
				IF XTIPO == 'D' .OR. XTIPO == 'B'
					zFranca := .F.
				else
					zFranca := .T.
				endif
			Else
				zfranca:= .F.
			endif
			
		Else
			zFranca:=.F.
			DbSelectArea("Sf3")
			DbSetOrder(5)
			DbSeek(XFilial()+Mv_par03+mv_par01)
			xCliente := Sf3->F3_ClieFor
			xLoja := Sf3->f3_Loja
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
			xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI :=SA2->A2_END             // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
			xCEP_CLI :=SA2->A2_CEP             // CEP
			xCOB_CLI :=""                      // Endereco de Cobranca
			xREC_CLI :=""                      // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN             // Municipio
			xEST_CLI :=SA2->A2_EST             // Estado
			xCGC_CLI :=SA2->A2_CGC             // CGC
			//			xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
			xINSC_CLI:=iif(mv_par05 = 1,SA2->A2_INSCR,;
			iif(mv_par05 = 2,SA2->A2_INSCR2,;
			iif(mv_par05 = 3,SA2->A2_INSCR3,;
			iif(mv_par05 = 4,SA2->A2_INSCR4," "))))
			xINSC_MUN:=SA2->A2_INSCRM          // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
			xTEL_CLI :=SA2->A2_TEL             // Telefone
			xFAX_CLI :=SA2->A2_FAX             // Fax
		Endif
		
		dbSelectArea("SA3")                   // * Cadastro de Vendedores
		dbSetOrder(1)
		xVENDEDOR:={}                         // Nome do Vendedor
		I:=1
		J:=Len(xCOD_VEND)
		For I:=1 to J
			dbSeek(xFilial()+xCOD_VEND[I])
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next
		
		If xICMS_RET >0                          // Apenas se ICMS Retido > 0
			dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
			dbSetOrder(4)
			dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
			If Found()
				xBSICMRET:=F3_VALOBSE
			Else
				xBSICMRET:=0
			Endif
		Else
			xBSICMRET:=0
		Endif
		dbSelectArea("SA4")                   // * Transportadoras
		dbSetOrder(1)
		dbSeek(xFilial()+SF2->F2_TRANSP)
		xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP  :=SA4->A4_END            // Endereco
		xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
		xEST_TRANSP  :=SA4->A4_EST            // Estado
		xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP  :=SA4->A4_CGC            // CGC
		xTEL_TRANSP  :=SA4->A4_TEL            // Fone
		xIES_TRANSP  :=SA4->A4_INSEST         // INSCRICAO ESTADUAL
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xDESCDUP   :=0
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			Endif
			xDESCDUP   :=SE1->E1_DESCFIN
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		DbSetOrder(1)
		dbSeek(xFilial()+xTES[1])
		xNATUREZA:= SF4->F4_NATOPE             // Natureza da Operacao
		xOBS     := SF4->F4_OBSFIS      // Observacao Fiscal
		xCOD_MENS:= SF4->F4_FORMULA            // Codigo da Mensagem Padrao
		
		
		Imprime(1)
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
		
	EndDo
Else
	
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF1->F1_SERIE == mv_par03 .and. lContinua
		
		If SF1->F1_SERIE #mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		SetRegua(Val(mv_par02)-Val(mv_par01))
		
		#IFNDEF WINDOWS
			IF LastKey()==286
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ELSE
			IF lAbortPrint
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ENDIF
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		xNUM_NF     :=SF1->F1_DOC             // Numero
		xSERIE      :=SF1->F1_SERIE           // Serie
		xFORNECE    :=SF1->F1_FORNECE         // Cliente/Fornecedor
		xEMISSAO    :=SF1->F1_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF1->F1_VALBRUT         // Valor Bruto da Compra
		xLOJA       :=SF1->F1_LOJA            // Loja do Cliente
		xFRETE      :=SF1->F1_FRETE           // Frete
		xSEGURO     :=SF1->F1_DESPESA         // Despesa
		xBASE_ICMS  :=SF1->F1_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF1->F1_BASEIPI         // Base   do IPI
		xBSICMRET   :=SF1->F1_BRICMS          // Base do ICMS Retido
		xVALOR_ICMS :=SF1->F1_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF1->F1_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF1->F1_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF1->F1_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF1->F1_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF1->F1_COND            // Condicao de Pagamento
		xTIPO       :=SF1->F1_TIPO            // Tipo do Cliente
		xNFORI      :=SF1->F1_NFORIG          // NF Original
		xPREF_DV    :=SF1->F1_SERORIG        // Serie Original
		xDESCDUP    :=0
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		cPedAtu := SD1->D1_PEDIDO
		cItemAtu:= SD1->D1_ITEMPC
		
		xPEDIDO  :={}                         // Numero do Pedido de Compra
		xITEM_PED:={}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV:={}                         // Numero quando houver devolucao
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Compra
		xIPI     :={}                         // Porcentagem do IPI
		xPESOPROD:={}                         // Peso do Produto
		xVAL_IPI :={}                         // Valor do IPI
		xDESC    :={}                         // Desconto por Item
		xVAL_DESC:={}                         // Valor do Desconto
		xVAL_MERC:={}                         // Valor da Mercadoria
		xTES     :={}                         // TES
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		xIPI_PROD:={}                         // ICMS do Produto
		xPISCOFINS:={}                         // PIS e COFINS (SIM ou NAO)
		
		while !eof() .and. SD1->D1_DOC==xNUM_NF
			If SD1->D1_SERIE #mv_par03      // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
				Loop
			Endif
			
			AADD(xPISCOFINS," ")
			AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
			AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
			AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
			AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
			AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
			AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
			AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
			AADD(xIPI      ,SD1->D1_IPI)            // % IPI
			AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
			AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
			AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
			AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
			AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
			AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
			AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(xIPI_PROD ,IIf(Empty(SD1->D1_IPI),0,SD1->D1_IPI))
			_xtes := SD1->D1_TES
			dbskip()
		End
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		xUNID_PRO:={}                           // Unidade do Produto
		xDESC_PRO:={}                           //Descricao do Produto
		xDESCCOMP:={}
		xMEN_POS :={}                           // Mensagem da Posicao IPI
		xDESCRICAO :={}                         // Descricao do Produto
		xCOD_TRIB:={}                           // Codigo de Tributacao
		xMEN_TRIB:={}                           // Mensagens de Tributacao
		xCOD_FIS :={}                           // Cogigo Fiscal
		xCLAS_FIS:={}                           // Classificacao Fiscal
		xISS     :={}                           // Aliquota de ISS
		xTIPO_PRO:={}                           // Tipo do Produto
		xLUCRO   :={}                           // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   :={}
		xCALCSUF :=""
		
		I:=1
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			dbSelectArea("SB1")
			
			AADD(xDESC_PRO ,ALLTRIM(SB1->B1_DESC) )
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xCOD_TRIB ,AllTrim(SB1->B1_ORIGEM)+AllTrim(SB1->B1_GRTRIB))
			If Ascan(xMEN_TRIB, AllTrim(SB1->B1_ORIGEM)+AllTrim(SB1->B1_GRTRIB))==0
				AADD(xMEN_TRIB ,AllTrim(SB1->B1_ORIGEM)+AllTrim(SB1->B1_GRTRIB))
			Endif
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xMEN_POS  ,SB1->B1_POSIPI)
			If SB1->B1_ALIQISS > 0
				AADD(xISS,SB1->B1_ALIQISS)
			Endif
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			if npElem == 0
				AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			endif
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			Do Case
				CASE npElem == 1 ; _CLASFIS := "A"
				CASE npElem == 2 ; _CLASFIS := "B"
				CASE npElem == 3 ; _CLASFIS := "C"
				CASE npElem == 4 ; _CLASFIS := "D"
				CASE npElem == 5 ; _CLASFIS := "E"
				CASE npElem == 6 ; _CLASFIS := "F"
			EndCase
			nPteste := Ascan(xCLFISCAL,_CLASFIS)
			If nPteste == 0
				AADD(xCLFISCAL,_CLASFIS)
			Endif
			AADD(xCOD_FIS ,Substr(SC6->C6_CLASFIS,2,1))
		Next
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		If xTIPO == "D" .Or. xTIPO == "B"
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE+xLOJA)
			xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI:=SA1->A1_NOME            // Nome
			xEND_CLI :=SA1->A1_END             // Endereco
			xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
			xCEP_CLI :=SA1->A1_CEP             // CEP
			xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCGC_CLI :=SA1->A1_CGC             // CGC
			//			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xINSC_CLI:=iif(mv_par05 = 1,SA1->A1_INSCR,;
			iif(mv_par05 = 2,SA1->A1_INSCR2,;
			iif(mv_par05 = 3,SA1->A1_INSCR3,;
			iif(mv_par05 = 4,SA1->A1_INSCR4," "))))
			INSC_MUN:=SA1->A1_INSCRM          // Inscricao Municipal
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
		Else
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE+xLOJA)
			xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
			xNOME_CLI:=SA2->A2_NOME               // Nome
			xEND_CLI :=SA2->A2_END                // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO             // Bairro
			xCEP_CLI :=SA2->A2_CEP                // CEP
			xCOB_CLI :=""                         // Endereco de Cobranca
			xREC_CLI :=""                         // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN                // Municipio
			xEST_CLI :=SA2->A2_EST                // Estado
			xCGC_CLI :=SA2->A2_CGC                // CGC
			//      	xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
			xINSC_CLI:=iif(mv_par05 = 1,SA2->A2_INSCR,;
			iif(mv_par05 = 2,SA2->A2_INSCR2,;
			iif(mv_par05 = 3,SA2->A2_INSCR3,;
			iif(mv_par05 = 4,SA2->A2_INSCR4," "))))
			INSC_MUN:=SA2->A2_INSCRM             // Inscricao Municipal
			xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
			xTEL_CLI :=SA2->A2_TEL                // Telefone
			xFAX     :=SA2->A2_FAX                // Fax
			xTRANSP  :=SA2->A2_TRANSP             // Codigo Transportadora
		EndIf
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDUPLICATAS:=IIF(dbSeek(xFilial()+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		dbSetOrder(1)
		dbSeek(xFilial()+xTES[1])
		xNATUREZA:=SF4->F4_NATOPE             // Natureza da Operacao
		xOBS     :=SF4->F4_OBSFIS             // Observacao Fiscal
		
		If xTIPO == "D" .Or. xTIPO == "B"
			xNOME_TRANSP :=""              // Nome Transportadora
			xEND_TRANSP  :=""              // Endereco
			xMUN_TRANSP  :=""              // Municipio
			xEST_TRANSP  :=""              // Estado
			xVIA_TRANSP  :=""              // Via de Transporte
			xCGC_TRANSP  :=""              // CGC
			xTEL_TRANSP  :=""              // Fone
			xIES_TRANSP  :=""
		Else
			dbSelectArea("SA4")
			dbSetOrder(1)
			dbSeek(xFilial("SA4")+xTRANSP)
			
			xNOME_TRANSP :=SA4->A4_NOME    // Nome Transportadora
			xEND_TRANSP  :=SA4->A4_END     // Endereco
			xMUN_TRANSP  :=SA4->A4_MUN     // Municipio
			xEST_TRANSP  :=SA4->A4_EST     // Estado
			xVIA_TRANSP  :=SA4->A4_VIA     // Via de Transporte
			xCGC_TRANSP  :=SA4->A4_CGC     // CGC
			xTEL_TRANSP  :=SA4->A4_TEL     // Fone
			xIES_TRANSP  :=SA4->A4_INSEST  // I.ESTADUAL
		Endif
		
		xTPFRETE     :=" "             // Tipo de Frete
		xVOLUME      := 0              // Volume
		xESPECIE     :=" "             // Especie
		xPESO_LIQ    := 0              // Peso Liquido
		xPESO_BRUTO  := 0              // Peso Bruto
		xCOD_MENS    :=SF4->F4_FORMULA // Codigo da Mensagem
		//      xMENSAGEM    :=SF1->F1_MENS    // Mensagem da Nota
		xPESO_LIQUID :=" "
		
		Imprime(1)
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
		
	EndDo
Endif

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

// Substituido pelo assistente de conversao do AP6 IDE em 01/08/02 ==>  Function VerImp
******************************
Static Function VerImp()
******************************

nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2
	nOpc       := 1
	#IFNDEF WINDOWS
		cCor       := "B/BG"
	#ENDIF
	While .T.
		
		dbCommitAll()
		#IFNDEF WINDOWS
			Set Device to Screen
			DrawAdvWindow(" Formulario ",10,25,14,56)
			SetColor(cCor)
			@ 12,27 Say "Formulario esta posicionado?"
			nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
			Set Device to Print
		#ELSE
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF
		
		Do Case
			Case nOpc==1
				lContinua:=.T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua:=.F.
				Return
		EndCase
	End
Endif
Return

// Substituido pelo assistente de conversao do AP6 IDE em 01/08/02 ==>  Function IMPDET
******************************
Static Function IMPDET(nX)    
******************************
nTamDet := 12              // Tamanho da Area de Detalhe
I  :=1
J  :=1
xB_ICMS_SOL := 0           // Base  do ICMS Solidario
xV_ICMS_SOL := 0           // Valor do ICMS Solidario
_lImpMsZn   :=.F.
_DescZFR:=0
lServico     := .F.
lServ        := .T.
TDPISCOFINS  := 0
For I := nX to Len(xCOD_PRO)
	If !(_xtes $ GetMv("MV_TESSERV") )//"503/553/504") //xTIPO_PRO[I] <> "SE" Marcio Macedo
		If I <= Len(xCOD_PRO)
			Sb1->(DbSeek(xFilial()+xCod_Pro[i]))
			IMPPISCOFINS := .F.
			nLinha:= MLCount(AllTrim(xDESCRICAO[I]),30)
			xD := 0
			If xTIPO_PRO[I] <> "FR"
				@ nLin,000 PSAY Iif(Empty(Sb1->B1_CodCli),Sb1->B1_Cod, Left(Sb1->B1_CodCli,15))+" "+substr(Alltrim( xDESCRICAO[I]),1,36)
				if xPISCOFINS[I] == 'S'
					IMPPISCOFINS := .T.
					TDPISCOFINS := SF2->F2_DESCONT
				ELSE
					IMPPISCOFINS := .F.
				ENDIF
				if alltrim(xtipo) == "I"
				else
					@ nLin,054  PSAY xCOD_FIS[I]
					@ nLin,057  PSAY TRANSFORM(xCOD_TRIB[I], "@R 9-99")
					@ nLin,065  PSAY xUNID_PRO[I]
					@ nLin,069  PSAY xQTD_PRO[I]  Picture "@E 99,999,999.99"
					If MV_PAR04 == 2
						_UnitZFR := xDESC_ZFR[I]/xQTD_PRO[I]
					Else
						_UnitZFR := 0
					Endif
					@ nLin, 083  PSAY xPRE_UNI[I]+_UnitZFR      Picture "@E 99,999,999.999999"
				endif
			Else
				@ nLin,016 PSAY substr(Alltrim( xDESCRICAO[I]),1,36)
			EndIf
			if alltrim(xtipo) == "I"
			else
				If MV_PAR04 == 2
					@ nLin, 104 PSAY xVAL_MERC[I] Picture "@E 99,999,999.99"
				Else
					@ nLin, 104 PSAY xVAL_MERC[I] Picture "@E 99,999,999.99"
				Endif
				@ nLin,119  PSAY xICM_PROD[I]     Picture "99%"
				@ nLin,124  PSAY xIPI_PROD[I]     Picture "99%"
				@ nLin,128  PSAY xVAL_IPI[I]      Picture "@E@Z 99,999.99"
				_x_imp := len(alltrim(substr(xDESCRICAO[I],37,36)))
				if _x_imp > 0
					nLin := nLin + 1
					@ nLin ,016 PSAY substr(xDESCRICAO[I],37,36)
				endif
			endif
			J:=J+1
		Endif
	else
		if lServ
			lServ := .F.
			
			***********Ulisses 01/06/06***********
			nLin := 17
			nLinha:= MLCount(AllTrim(xOBS),50)
			For nX := 1 to nLinha
			  @ nlin, 003 PSAY MEMOLINE(xOBS,50,nX); nlin++
			Next
			**************************************
			
			nLin := 24
//			If !Empty( cObs1 )
//				@ nLin, 16 PSAY Left( cObs1, 70)
				nLin := nLin + 1
				@ nLin, 16 PSAY Left( xMENSAGEM, 70)
//		    EndIf
			//If !Empty( cObs2 )
			//	nLin := nLin + 1
			//	@ nLin, 16 PSAY Left( cObs2, 70)
			//EndIf
			nLin := 30
		endif
		@ nLin,01 PSAY xQTD_PRO[I]  Picture "@E 99999999.99"
		@ nLin, 015 PSAY substr(xDESCRICAO[I],1,70)
		If MV_PAR04 == 2
			_UnitZFR := xDESC_ZFR[I]/xQTD_PRO[I]
		Else
			_UnitZFR := 0
		Endif
		@ nLin, 083  PSAY xINSC_MUN //  85
		@ nLin, 098  PSAY Transform(xPRE_UNI[I]+_UnitZFR,"@E 99,999,999.99")   //93
		If MV_PAR04 == 2
			@ nLin, 118 PSAY xVAL_MERC[I] Picture "@E 99,999,999.99" //118
		Else
			@ nLin, 118 PSAY xVAL_MERC[I] Picture "@E 99,999,999.99" //118
		Endif
		if xISS[I] > 0
			@  nLin, 133 PSAY xISS[I] Picture "99%"
		endif
		
		If I < Len(xCOD_PRO) .and. mod(I,3) = 0//Ulisses 05/06/06 para quebrar impressão após impressão de 3 itens
		  Return I
		EndIf
		
	endif
	nLin :=nLin+1
Next
if lServ
	If !Empty( cObs1 )
		@ nLin, 16 PSAY Left( cObs1, 70)
	EndIf
	If !Empty( cObs2 )
		nLin := nLin + 1
		@ nLin, 16 PSAY Left( cObs2, 70)
	EndIf
	If !Empty( cObs3 )
		nLin := nLin + 1
		@ nLin, 16 PSAY ALLTRIM( cObs3 )
	EndIf
	If !Empty( cObs4 )
		nLin := nLin + 1
		@ nLin, 16 PSAY Left( cObs4, 70)
	EndIf
	If !Empty( cObs5 )
		nLin := nLin + 1
		@ nLin, 16 PSAY Left( cObs5, 70)
	EndIf
	If !Empty( cObs6 )
		nLin := nLin + 1
		@ nLin, 16 PSAY Left( cObs6, 70)
	EndIf
	If !Empty( cObs7 )
		nLin := nLin + 1
		@ nLin, 16 PSAY Left( cObs7, 70)
	EndIf
	if IMPPISCOFINS
		nLin :=nLin+1
		@ nLin ,016 PSAY "REDUCAO REFERENTE AO PIS/COFINS DE ACORDO COM A LEI 10.684 DE 30/05/2003 ART. 25"; NLIN++
	endif
	nLin := 27
	nLin := nLin+1
	//	@ nlin, 001 PSAY xOBS
endif
If xDESCDUP>0
	nLin :=nLin+1
	@ nLin, 65 PSAY "TOTAL DOS PRODUTOS"
	@ nLin, 104  PSAY xVALOR_MERC  Picture "@E 99,999,999.99"
Endif

Return I
//
//
******************************
Static Function IMPMENP()     
******************************
Return
//
//
******************************
Static Function Imprime(nX)   
******************************
SetPrc(0,0)
lServico := .F.         
//Acrescentado por Ulisses em 31/05/06
//em substituição ao comentado abaixo
aDriver := ReadDriver()
@00,00 PSAY &(aDriver[aReturn[4]+2])
/////////////////////////////////////////
//@ 01, 000 PSAY Chr(15)
@ 01, 001 PSAY " "
If mv_par04 == 1
	@ 01, 100 PSAY "X"
Else
	@ 01, 087 PSAY "X"
Endif
@ 01, 125 PSAY xNUM_NF
@ 06, 003 PSAY ALLTRIM(xNATUREZA)
@ 06, 045 PSAY transform(xCF[1],"@R 9.999")                                // Codigo da Natureza de Operacao
@ 09, 003 PSAY xNOME_CLI                              //Nome do Cliente
If !EMPTY(xCGC_CLI)                                   // Se o C.G.C. do Cli/Forn nao for Vazio
	@ 09, 088 PSAY xCGC_CLI Picture "@R 99.999.999/9999-99"
Else
	@ 09, 088 PSAY " "                                 // Caso seja vazio
Endif
@ 09, 126 PSAY xEMISSAO                               // Data da Emissao do Documento
@ 11, 003 PSAY xEND_CLI                               // Endereco
@ 11, 070 PSAY xBAIRRO                                // Bairro
@ 11, 105 PSAY xCEP_CLI Picture "@R 99999-999"        // CEP
@ 11, 143 PSAY " "                                    // Reservado  p/Data Saida/Entrada
@ 12, 003 PSAY alltrim(xMUN_CLI)                               // Municipio
@ 12, 041 PSAY SUBSTR(xTEL_CLI,1,15)                               // Telefone/FAX
@ 12, 080 PSAY xEST_CLI                               // U.F.
@ 12, 093 PSAY xINSC_CLI                              // Insc. Estadual
nLin := 15

nRest:= ImpDet(nX)                 // Detalhe da NF

If _xtes $ GetMv("MV_TESSERV") //"503/553/504" Marcio Macedo
  If nRest < Len(xCOD_PRO)
   @ 35, 050 PSAY "**********"  //Picture "@E@Z 999,999,999.99"
   @ 35, 080 PSAY "**********"  //Picture "@E@Z 999,999,999.99"
   @ 35, 120 PSAY "**********"  //Picture "@E@Z 999,999,999.99"
  Else
   @ 35, 050 PSAY 0  Picture "@E@Z 999,999,999.99"
   @ 35, 080 PSAY 0  Picture "@E@Z 999,999,999.99"
   @ 35, 120 PSAY xTOT_FAT  Picture "@E@Z 999,999,999.99"
   @ 39, 120  PSAY xTOT_FAT Picture "@E@Z 999,999,999.99" // Marcio Macedo
  EndIf 

Else

  if alltrim(xtipo) == "I"
	  @ 37, 038  PSAY xVALOR_MERC Picture "@E@Z 999,999,999.99"  // Valor do ICMS
  else
	  @ 37, 012  PSAY xBASE_ICMS  Picture "@E@Z 999,999,999.99"  // Base do ICMS
	  if _xtes == "538"
		  @ 37, 038  PSAY (xBASE_ICMS*17)/100 Picture "@E@Z 999,999,999.99"  // Valor do ICMS
	  else
		  @ 37, 038  PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS
	  endif
	  @ 37, 067  PSAY xBSICMRET   Picture "@E@Z 999,999,999.99"  // Base ICMS Ret.
	  @ 37, 090  PSAY xICMS_RET   Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.
	  @ 37, 120  PSAY xVALOR_MERC Picture "@E@Z 999,999,999.99"  // Valor Tot. Prod.
	
	  @ 39, 012  PSAY xFRETE      Picture "@E@Z 999,999,999.99"  // Valor do Frete
	  @ 39, 038  PSAY xSEGURO     Picture "@E@Z 999,999,999.99"  // Valor Seguro
	  @ 39, 090  PSAY xVALOR_IPI  Picture "@E@Z 999,999,999.99"  // Valor do IPI	  
	  @ 39, 120  PSAY xTOT_FAT Picture "@E@Z 999,999,999.99"	  
	  @ 43, 003  PSAY ALLTRIM(xNOME_TRANSP)                              // Nome da Transport.

	  If xTIPO_PRO[1] <> "FR"
		  If xTPFRETE=='C'                                          // Frete por conta do
			  @ 43, 080 PSAY "1"                                     // Emitente (1)
		  Else                                                     //     ou
			  @ 43, 080 PSAY "2"                                     // Destinatario (2)
		  Endif
	  EndIf
	  @ 43, 092 PSAY " "                                        // Res. p/Placa do Veiculo
	  @ 43, 112 PSAY " "                                        // Res. p/xEST_TRANSP                          // U.F.
	
	  If !EMPTY(xCGC_TRANSP)                                    // Se C.G.C. Transportador nao for Vazio
		  @ 43, 110 PSAY xCGC_TRANSP Picture "@R 99.999.999/9999-99"
	  Else
		  @ 43, 110 PSAY " "                                     // Caso seja vazio
	  Endif
	
	  @ 45, 003 PSAY xEND_TRANSP                                // END TRANSP
	  @ 45, 066 PSAY xMUN_TRANSP                                // Municipio
	  @ 45, 101 PSAY xEST_TRANSP                                // U.F.
	  @ 45, 120 PSAY xIES_TRANSP                                // Reservado p/Insc. Estad.
	
	  dbSelectArea("SC6")
	  dbSetOrder(4)
	  dbSeek(xFilial("SC6")+xNUM_NF+xSERIE)
	  xDAT_FT:=SC6->C6_DATFAT
	
	  dbSelectArea("SC6")
	  dbSetOrder(1)
	  dbSeek(xFilial("SC6")+cPedAtu)
	  _lSegNota:=.F.
	  @ 47, 006 PSAY xVOLUME  Picture "@E@Z 999,999.99"             // Quant. Volumes
	  @ 47, 028 PSAY xESPECIE Picture "@!"                          // Especie
	
	  @ 47, 075 PSAY " "                                              // Res para Numero
	  @ 47, 100 PSAY xPESO_BRUTO Picture "@E@Z 999,999.999"        // Res para Peso Bruto
	
	  If MV_PAR04==2
		  @ 47, 125 PSAY xP_LIQ_Ped Picture "@E@Z 999,999.999"     // Res para Peso Liquido
	  Else
		  @ 47, 125 PSAY xPESO_LIQ  Picture "@E@Z 999,999.999"     // Res para Peso Liquido
	  Endif
  endif
EndIf
_xx_Alias := Alias()
_xx_Pega_nf := .T.
nLin := 49
dbSelectArea("SE1")
dbSetOrder(1)
dbSeek(xFilial("SE1")+xSERIE+xNUM_NF)
while !eof() .and. SE1->E1_PREFIXO == xSERIE .and. SE1->E1_NUM == xNUM_NF
	@ nLin, 59 psay SE1->E1_PARCELA+" - "+dtoc(SE1->E1_VENCREA); nlin++
	if nlin >= 52
		if _xx_Pega_nf
			@ 52, 100 PSAY xNUM_NF
			_xx_Pega_nf := .F.
		endif
	endif
	dbskip()
end
dbSelectArea(_xx_Alias)

if _xx_Pega_nf
	_xx_Pega_nf := .F.
	@ 52, 100 PSAY xNUM_NF
	While !Eof() .And. SC6->C6_NUM==cPedAtu
		If xNUM_NF==SC6->C6_NOTA
			_lSegNota:=.T.
			Exit
		ElseIf xNUM_NF<>SC6->C6_NOTA .And. !Empty(SC6->C6_NOTA) .And.;
			xDAT_FT==SC6->C6_DATFAT
			_lSegNota:=.F.
			@ 52, 006 PSAY "VIDE NF "+SC6->C6_NOTA
			Exit
		Endif
		dbSelectArea("SC6")
		dbSkip()
	Enddo
endif
@ 59, 128 PSAY xNUM_NF     //60          // Numero da Nota Fiscal
@ 65, 00 PSAY " "
/*
If MV_PAR02 # xNUM_NF
  @ 66, 00 PSAY " "
EndIf
*/
If nRest < Len(xCOD_PRO)
  //@ 66, 00 PSAY " "
  nLin := 0             
  Imprime(nRest+1)       
EndIf

Return .t.
