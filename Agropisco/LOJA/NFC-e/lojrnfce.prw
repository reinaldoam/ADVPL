#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

//Modalidades de TEF disponíveis no sistema
#DEFINE TEF_SEMCLIENT_DEDICADO  "2"         // Utiliza TEF Dedicado Troca de Arquivos                      
#DEFINE TEF_COMCLIENT_DEDICADO  "3"			// Utiliza TEF Dedicado com o Client
#DEFINE TEF_DISCADO             "4"			// Utiliza TEF Discado 
#DEFINE TEF_LOTE                "5"			// Utiliza TEF em Lote
#DEFINE TEF_CLISITEF			 "6"		// Utiliza a DLL CLISITEF
#DEFINE TEF_CENTROPAG			 "7"		// Utiliza a DLL tef mexico


// Possibilidades de uso do parametro MV_AUTOCOM
#DEFINE DLL_SIGALOJA			0			// Usa somente periféricos da SIGALOJA.DLL
#DEFINE DLL_SIGALOJA_AUTOCOM	1			// Usa periféricos da SIGALOJA.DLL e da AUTOCOM
#DEFINE DLL_AUTOCOM				2			// Usa somente periféricos da AUTOCOM

// Retornos da GetRemoteType()
#DEFINE REMOTE_JOB	 			-1			// Não há Remote, executando Job
#DEFINE REMOTE_DELPHI			0			// O Remote está em Windows Delphi
#DEFINE REMOTE_QT				1			// O Remote está em Windows QT
#DEFINE REMOTE_LINUX			2			// O Remote está em Linux
#DEFINE REMOTE_HTML				5			// Não há Remote, executando HTML

// Tipos de equipamentos
#DEFINE EQUIP_IMPFISCAL			1
#DEFINE EQUIP_PINPAD			2
#DEFINE EQUIP_CMC7				3
#DEFINE EQUIP_GAVETA			4
#DEFINE EQUIP_IMPCUPOM			5
#DEFINE EQUIP_LEITOR			6
#DEFINE EQUIP_BALANCA			7
#DEFINE EQUIP_DISPLAY			8
#DEFINE EQUIP_IMPCHEQUE			9
#DEFINE EQUIP_IMPNAOFISCAL		10			

// Qual DLL o Equipamento esta utilizando
#DEFINE EQUIP_DLL_NENHUM		0			// O equipamento nao foi configurado 
#DEFINE EQUIP_DLL_AUTOCOM		1			// O equipamento foi configurado para utilizar a AUTOCOM
#DEFINE EQUIP_DLL_SIGALOJA		2			// O equipamento foi configurado para utilizar a SIGALOJA

//**************************************************************************************************//
//Tags para impressão em Impressoras Fiscal e Não-Fiscal
//
//	NOTAS:
//		- essas tags foram baseadas no modulo Daruma Não-Fiscal
// 		- ao adicionar uma tag aqui inserir na funções da sigaloja, 
//		totvsapi e autocom para tratar as tags por modelo de ECF, 
//		nos fontes dos modelos e no LOJA1305 que trata da remoção da tag nao utilizada
//**************************************************************************************************//
#DEFINE TAG_ESC			CHR(27)
#DEFINE TAG_NEGRITO_INI	 "<b>"	//Inicia Texto em Negrito
#DEFINE TAG_NEGRITO_FIM	"</b>" //finaliza texto em negrito
#DEFINE TAG_ITALICO_INI	"<i>"	//itálico
#DEFINE TAG_ITALICO_FIM	"</i>" //itálico
#DEFINE TAG_CENTER_INI	"<ce>"	//centralizado
#DEFINE TAG_CENTER_FIM	"</ce>"//centralizado
#DEFINE TAG_SUBLI_INI	 "<s>"	//sublinhado
#DEFINE TAG_SUBLI_FIM 	"</s>"	//sublinhado
#DEFINE TAG_EXPAN_INI 	"<e>"	//expandido
#DEFINE TAG_EXPAN_FIM	 "</e>"	//expandido
#DEFINE TAG_CONDEN_INI	"<c>"	//condensado
#DEFINE TAG_CONDEN_FIM	"</c>"	//condensado
#DEFINE TAG_NORMAL_INI	"<n>"	//normal 
#DEFINE TAG_NORMAL_FIM	"</n>"	//normal
#DEFINE TAG_PULALI_INI	"<l>"	//pula 1 linha
#DEFINE TAG_PULALI_FIM	"</l>"	//pula 1 linha
#DEFINE TAG_PULANL_INI	"<sl>"	//pula NN linhas
#DEFINE TAG_PULANL_FIM	"</sl>"//pula NN linha
#DEFINE TAG_RISCALN_INI	"<tc>"	//risca a linha caracter especifico
#DEFINE TAG_RISCALN_FIM	"</tc>"
#DEFINE TAG_TABS_INI		"<tb>"	//tabulação
#DEFINE TAG_TABS_FIM		"</tb>"
#DEFINE TAG_DIREITA_INI	"<ad>" //alinhado a direita
#DEFINE TAG_DIREITA_FIM	"</ad>"
#DEFINE TAG_ELITE_INI	 "<fe>"	//habilita fonte elite
#DEFINE TAG_ELITE_FIM 	"</fe>"
#DEFINE TAG_TXTEXGG_INI	"<xl>"	//habilita texto extra grande
#DEFINE TAG_TXTEXGG_FIM	"</xl>"
#DEFINE TAG_GUIL_INI		"<gui>"//ativa guilhotina
#DEFINE TAG_GUIL_FIM		"</gui>"
#DEFINE TAG_EAN13_INI 	"<ean13>"	//codigo de barra ean13
#DEFINE TAG_EAN13_FIM	 "</ean13>"
#DEFINE TAG_EAN8_INI		"<ean8>"	//codigo de barra ean8
#DEFINE TAG_EAN8_FIM		"</ean8>"
#DEFINE TAG_UPCA_INI		"<upc-a>" //codigo de barras upc-a
#DEFINE TAG_UPCA_FIM		"</upc-a>"
#DEFINE TAG_CODE39_INI	"<code39>"//codigo de barras CODE39
#DEFINE TAG_CODE39_FIM	"</code39>"
#DEFINE TAG_CODE93_INI	"<code93>" //codigo de barras CODE93
#DEFINE TAG_CODE93_FIM	"</code93>"
#DEFINE TAG_CODABAR_INI	"<codabar>"//codigo de barras CODABAR
#DEFINE TAG_CODABAR_FIM	"</codabar>"
#DEFINE TAG_MSI_INI		"<msi>" //codigo de barras MSI
#DEFINE TAG_MSI_FIM		"</msi>"
#DEFINE TAG_CODE11_INI	"<code11>"//codigo de barras CODE11
#DEFINE TAG_CODE11_FIM	"</code11>"
#DEFINE TAG_PDF_INI		"<pdf>" //codigo de barras PDF
#DEFINE TAG_PDF_FIM		"</pdf>"
#DEFINE TAG_COD128_INI	"<code128>" //codigo de barras CODE128
#DEFINE TAG_COD128_FIM	"</code128>"
#DEFINE TAG_I2OF5_INI	 "<i2of5>" //codigo I2OF5
#DEFINE TAG_I2OF5_FIM 	"</i2of5>"
#DEFINE TAG_S2OF5_INI 	"<s2of5>" //codigo S2OF5
#DEFINE TAG_S2OF5_FIM	 "</s2of5>"
#DEFINE TAG_QRCODE_INI	"<qrcode>"	//codigo do tipo QRCODE
#DEFINE TAG_QRCODE_FIM	"</qrcode>"
#DEFINE TAG_BMP_INI		"<bmp>" //imprimi logotipo carregado
#DEFINE TAG_BMP_FIM		"</bmp>"
#DEFINE TAG_NIVELQRCD_INI "<correcao>" // nivel de correção do QRCode
#DEFINE TAG_NIVELQRCD_FIM "</correcao>"


#DEFINE MTAG_NEGRITO_INI	 TAG_ESC+"E"	//Inicia Texto em Negrito
#DEFINE MTAG_NEGRITO_FIM	 TAG_ESC+"F" //finaliza texto em negrito
#DEFINE MTAG_ITALICO_INI	TAG_ESC+"41"	//itálico
#DEFINE MTAG_ITALICO_FIM TAG_ESC+"40" //itálico
#DEFINE MTAG_CENTER_INI	TAG_ESC+"j1"	//centralizado
#DEFINE MTAG_CENTER_FIM	TAG_ESC+"j0"//centralizado
#DEFINE MTAG_SUBLI_INI	TAG_ESC+"-1"	//sublinhado
#DEFINE MTAG_SUBLI_FIM 	TAG_ESC+"-0"	//sublinhado
#DEFINE MTAG_EXPAN_INI 	TAG_ESC+"W1"	//expandido
#DEFINE MTAG_EXPAN_FIM	TAG_ESC+"W0"	//expandido
#DEFINE MTAG_CONDEN_INI	CHR(15)	//condensado
#DEFINE MTAG_CONDEN_FIM	CHR(18)	//condensado
#DEFINE MTAG_NORMAL_INI	CHR(20)	//normal 
#DEFINE MTAG_NORMAL_FIM	""	//normal
#DEFINE MTAG_PULALI_INI	CHR(10)	//pula 1 linha
#DEFINE MTAG_PULALI_FIM	""	//pula 1 linha
#DEFINE MTAG_PULANL_INI	TAG_ESC+"f1"	//pula NN linhas
#DEFINE MTAG_PULANL_FIM	""//pula NN linha
#DEFINE MTAG_RISCALN_INI	""	//risca a linha caracter especifico
#DEFINE MTAG_RISCALN_FIM	""
#DEFINE MTAG_TABS_INI		TAG_ESC+"B"	//tabulação
#DEFINE MTAG_TABS_FIM		TAG_ESC+"B"
#DEFINE MTAG_DIREITA_INI	TAG_ESC+"j2" //alinhado a direita
#DEFINE MTAG_DIREITA_FIM	TAG_ESC+"j0"
#DEFINE MTAG_ELITE_INI	 TAG_ESC+"!01"	//habilita fonte elite
#DEFINE MTAG_ELITE_FIM 	TAG_ESC+"!00"	
#DEFINE MTAG_TXTEXGG_INI	TAG_ESC+"!41"		//habilita texto extra grande
#DEFINE MTAG_TXTEXGG_FIM	TAG_ESC+"!40"	
#DEFINE MTAG_EAN13_INI 	TAG_ESC+"b1"	//codigo de barra ean13
#DEFINE MTAG_EAN13_FIM	 ""
#DEFINE MTAG_EAN8_INI	TAG_ESC+"b2"	//codigo de barra ean8
#DEFINE MTAG_EAN8_FIM		""
#DEFINE MTAG_UPCA_INI		TAG_ESC+"b8" //codigo de barras upc-a
#DEFINE MTAG_UPCA_FIM		""
#DEFINE MTAG_CODE39_INI	TAG_ESC+"b6"//codigo de barras CODE39
#DEFINE MTAG_CODE39_FIM	""
#DEFINE MTAG_CODE93_INI	TAG_ESC+"b7" //codigo de barras CODE93
#DEFINE MTAG_CODE93_FIM	""
#DEFINE MTAG_CODABAR_INI	TAG_ESC+"b9"//codigo de barras CODABAR
#DEFINE MTAG_CODABAR_FIM	""
#DEFINE MTAG_MSI_INI		TAG_ESC+"b10" //codigo de barras MSI
#DEFINE MTAG_MSI_FIM		""
#DEFINE MTAG_CODE11_INI	TAG_ESC+"b11" //codigo de barras CODE11
#DEFINE MTAG_CODE11_FIM	""
#DEFINE MTAG_PDF_INI		TAG_ESC+CHR(128) //codigo de barras PDF
#DEFINE MTAG_PDF_FIM		""
#DEFINE MTAG_COD128_INI	TAG_ESC+"b5" //codigo de barras CODE128
#DEFINE MTAG_COD128_FIM	""
#DEFINE MTAG_I2OF5_INI	 TAG_ESC+"b4" //codigo I2OF5
#DEFINE MTAG_I2OF5_FIM 	""
#DEFINE MTAG_S2OF5_INI 	TAG_ESC+"b3" //codigo S2OF5
#DEFINE MTAG_S2OF5_FIM	 ""
#DEFINE MTAG_QRCODE_INI	TAG_ESC+Chr(129)	//codigo do tipo QRCODE
#DEFINE MTAG_QRCODE_FIM	""
#DEFINE MTAG_BMP_INI		CHR(22)+"8"//imprimi logotipo carregado
#DEFINE MTAG_BMP_FIM		CHR(22)+"9"
#DEFINE MTAG_NIVELQRCD_INI "" // nivel de correção do QRCode
#DEFINE MTAG_NIVELQRCD_FIM ""
#DEFINE MTAG_GUIL_INI	TAG_ESC+"m"//ativa guilhotina
#DEFINE MTAG_GUIL_FIM	""

//Tags disponibilizadas apenas para a bematech
#DEFINE TAG_ITF	 "<itf>"
#DEFINE TAG_ISBN	"<isbn>"
#DEFINE TAG_PLESSEY	 "<plessey>"

//Informações de NFCe
#DEFINE _NFCE_AVISO_CONTINGENCIA 	"01" 
#DEFINE _NFCE_ENCONTRAR_IMPRESSORA 	"02" 
#DEFINE _NFCE_TIMEOUT_SERVICO 		"03"
#DEFINE _NFE_MARCA_IMPRESSORA 		"04" 
#DEFINE _NFCE_TIPO_AMBIENTE 		"05"
#DEFINE _NFCE_CODIGO_PARCEIRO 		"06" 
#DEFINE _NFCE_CODIGO_PDV 		"07" 
#DEFINE _NFCE_CODIGO_EMPRESA 		"08"
#DEFINE _NFCE_TOKEN_SEFAZ 		"09" 
#DEFINE _NFCE_AJUSTAR_PAGTO_TOTAL 	"10" 
#DEFINE _NFCE_NUMERACAO_AUTOMATICA 	"11" 
#DEFINE _NFCE_HABILITA_LEI_IMPOSTO 	"12" 
#DEFINE _NFCE_MENSAGEM_COMPLEMENTAR 	"13"
#DEFINE _NFCE_EMIENTE_CNPJ_CPF	 	"14" 
#DEFINE _NFCE_EMITENTE_NOME 		"15" 
#DEFINE _NFCE_EMITENTE_IE 		"16"
#DEFINE _NFCE_EMITENTE_IM 		"17" 
#DEFINE _NFCE_EMITENTE_CRT 		"18"
#DEFINE _NFCE_EMITENTE_CUF 		"19"  
#DEFINE _NFCE_EMTIENTE_CNUMFG 		"20" 
#DEFINE _NFCE_EMITENTE_ENDERECO_LOGR 	"21" 
#DEFINE _NFCE_EMITENTE_ENDERECO_NUMERO 	"22"
#DEFINE _NFCE_EMITENTE_ENDERECO_BAIRRO 	"23" 
#DEFINE _NFCE_EMITENTE_ENDERECO_CNUM	"24" 
#DEFINE _NFCE_EMITENTE_ENDERECO_XNUM 	"25" 
#DEFINE _NFCE_EMITENTE_ENDERECO_UF 	"26" 
#DEFINE _NFCE_EMITENTE_ENDERECO_CEP 	"27" 
#DEFINE _NFCE_CANC_INUTILIZA_AUTOMATICO	"28"

Static nQtdColuna := 48 //Quantidade de Colunas da impressora

User Function LOJRNFCe(	oNFCe		, oProt		, nDecimais	, aFormas	,;
						cProtAuto	, lContigen	, cDtHoraAut, aEmitNfce	,; 
						aDestNfce	, aIdNfce	, aPagNfce	, aItemNfce	,; 
						aTotal		, cChvNFCe	, cInscMun	)

	Local lPrinter 	:= .F.			
	Local cXml		:= ""
	Local cXmlProt	:= ""
	Local cPath 			:= "\spool\"		
	Local cSession			:= GetPrinterSession()	
	Local cStartPath		:= GetSrvProfString("StartPath","")	
	Local lAdjustToLegacy	:= .T.

	Private cBmp 			:= cStartPath + "NfceLogo.bmp" 	//Logo
	Private oPrint
	
	Default oNFCe		:= NIL 
	Default oProt		:= NIL
	Default nDecimais 	:= 0
	Default aFormas 	:= {}
	Default aEmitNfce 	:= {}
	Default aDestNfce 	:= {}
	Default aIdNfce 	:= {}
	Default aPagNfce 	:= {}
	Default aItemNfce 	:= {}
	Default aTotal 		:= {}
	Default cProtAuto	:= ""
	Default lContigen	:= .T.
	Default cDtHoraAut	:= ""
	Default cChvNFCe	:= ""
	Default cInscMun	:= ""          		                                          	                                	    
		
	oPrint := FWMsPrinter():New("Impressão NFC-e", , lAdjustToLegacy,cPath)
	lPrinter:= oPrint:IsPrinterActive()   //Verifica se existe alguma impressora conectada...
		                    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso nao encontre a impressora conectada localmente,³
	//³abre a tela para escolha de impressora de rede      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lPrinter
		oPrint:Setup()
	Endif
	
	If !oPrint:IsPrinterActive()
		MsgInfo("Não existe impressora conectada ao computador!")
		Return
	Endif
	
	If ValType(oNFCe) == "O"	
		oPrint:SetPortrait()
		oPrint:SetPaperSize(DMPAPER_A4)
		
		LJMsgRun("Iprimindo NFC-e",,{|| U_LjrImpNFCE(oNFCe, oProt, nDecimais, aFormas, cProtAuto, lContigen, cDtHoraAut, ;
						aEmitNfce, aDestNfce, aIdNfce, aPagNfce, aItemNfce, aTotal, cChvNFCe, cInscMun)})
		
		oPrint:Preview()
	Else
		MsgInfo("Não há dados para serem impressos!")	
	EndIf
	
Return Nil

User Function LjRImpNFCE(	oNFCe		, oProt		, nDecimais	, aFormas	,; 
							cProtAuto	, lContigen	, cDtHoraAut, aEmitNfce	,; 
							aDestNfce	, aIdNfce	, aPagNfce	, aItemNfce	,;
							aTotal		, cChvNFCe	, cInscMun	)
	
	Local aItNfceAux	:= {}//Itens	
	Local cCrLf			:= ""
	Local cLinha		:= Replicate("-", 113)//Replicate("-",113) + cCrLf
	Local nContItImp	:= 0
	Local nItemQtde		:= 0
	Local nItemUnit 	:= 0
	Local nItemTotal	:= 0
	Local nTotDesc 		:= 0
	Local nTotAcresc	:= 0 		
	Local nFtQrCode		:= 0.38 //Fator Conersao tamanho QrCode, referente a posição da linha 1
	Local nValFtr		:= 0 	//Valor Fatorado

	Local nX			:= 0 
	Local nY			:= 0 
	Local nAuxLn		:= 0
	
	Local nAlgL			:= 0
	Local nAlgR			:= 1
	Local nAlgC			:= 2
	
	Local cKeyQrCode	:= ""
	Local cTextoTemp	:= ""
	Local cAmbiente		:= SuperGetMv( "MV_AMBNFCE",, "2" )
	Local cURLNFCE		:= ""
	Local lL2TotImp		:= SL2->(FieldPos ("L2_TOTIMP")) > 0
	Local nDecVRUNIT	:= TamSX3("L2_VRUNIT")[2]//quantidade de casas decimais a serem impressas no campo VlUnit do DANFE	
	Local nTotImpNCM	:= 0
	Local nTotVLRNCM	:= 0	
	Local nTamPgV		:= oPrint:nVertRes()//-170//Comprimento vertical da impressao
	Local oFont, oFont1, oFont2, oFont3, oFont4, oFont5
		
	oFont  := TFont():New("Courier New",,14,,.T.,,,,.T.,)
	oFont1 := TFont():New("Courier New",,13,,.T.,,,,.T.,)
	oFont2 := TFont():New("Courier New",,11,,.T.,,,,,)
	oFont3 := TFont():New("Courier New",,12,,.T.,,,,.T.,)
	oFont4 := TFont():New("Courier New",,16,,.T.,,,,.T.,)
	oFont5 := TFont():New("Courier New",,15,,.T.,,,,.T.,)	
	
	// Inicia a impressao da pagina
	oPrint:StartPage()

	// Imprime o cabecalho                            
	//Divisao I
	oPrint:SetFont(oFont)
	nAuxLn := 80
	oPrint:SayBitmap( 0025, 0050, cBmp, 200, 200)
	oPrint:Say( nAuxLn,0300,AllTrim(aEmitNfce:_XNOME:TEXT) ) //Denominação do Emitente
	oPrint:Say( nAuxLn,1210,"Inscricao Municipal:" + cInscMun) //Denominação do Emitente
	nAuxLn += 40
	oPrint:Say( nAuxLn,0300,AllTrim("CNPJ:" + aEmitNfce:_CNPJ:TEXT))	//CNPJ do Emitente //Inscrição Estadual do Emitente
	oPrint:Say( nAuxLn,1210,Alltrim("Inscrição Estadual :" + aEmitNfce:_IE:TEXT))	//CNPJ do Emitente //Inscrição Estadual do Emitente
	nAuxLn += 70
	oPrint:Say( nAuxLn,0300,AllTrim(aEmitNfce:_ENDEREMIT:_XLGR:TEXT) + " Nr. " + AllTrim(aEmitNfce:_ENDEREMIT:_NRO:TEXT) + ", " +;
				AllTrim(aEmitNfce:_ENDEREMIT:_XBAIRRO:TEXT) + ", " + AllTrim(aEmitNfce:_ENDEREMIT:_XMUN:TEXT) + ", "+;
				AllTrim(aEmitNfce:_ENDEREMIT:_UF:TEXT))		//Endereço do Emitente

	//
	// Divisão II – Informações Fixas do DANFE NFC-e
	//
	oPrint:SetFont(oFont)
	nAuxLn += 40
	oPrint:Say( nAuxLn,0050, cLinha, oFont3 )
	nAuxLn += 40
	oPrint:SetFont(oFont)		
	oPrint:Say( nAuxLn,0680,"DANFE NFC-e - Documento Auxiliar" )
	nAuxLn += 40
	oPrint:Say( nAuxLn,0500,"da Nota Fiscal Eletrônica para Consumidor Final" )
	nAuxLn += 40
	oPrint:Say( nAuxLn,0510,"Não permite aproveitamento de crédito de ICMS" )
	
	//
	// Divisão III – Informações de Detalhe da Venda
	// * a impressao dessa divisão é opcional ou conforme definido por UF
	// 
	nAuxLn += 40	
	oPrint:Say( nAuxLn,050, cLinha , oFont3 )
	nAuxLn += 40
	oPrint:Say( nAuxLn,0080,"Codigo           Descricao                    Qtd    Un      VlUnit.     VlTotal", oFont)
		
	For nX := 1 to Len(aItemNfce)	 
	
		nContItImp++ //Contador de itens a serem impressos

		nItemQtde	:= Val(aItemNfce[nX]:_PROD:_QCOM:TEXT)
		nItemUnit 	:= Val(aItemNfce[nX]:_PROD:_VUNCOM:TEXT)
		nItemTotal	:= Val(aItemNfce[nX]:_PROD:_VPROD:TEXT)

		//Quando desconto, subtrai do valor do item
		If Type("aItemNfce["+AllTrim(Str(nX))+"]:_PROD:_VDESC") == "O"
			nTotDesc += Val(aItemNfce[nX]:_PROD:_VDESC:TEXT)
		EndIf

		//Acumulamos o acrescimo (Frete/Seguro/Despesa)
		If Type("aItemNfce["+AllTrim(Str(nX))+"]:_PROD:_VOUTRO") == "O"
			nTotAcresc += Val(aItemNfce[nX]:_PROD:_VOUTRO:TEXT)
		EndIf
		
		nAuxLn += 60
		
		oPrint:Say( nAuxLn,0080,PADR(aItemNfce[nX]:_PROD:_CPROD:TEXT,15) + " "  ,oFont1 )	//Codigo de Produto
			
		//Se a Descricao for maior que 12 caracteres, imprimimos a descricao em uma linha soh e os outros 
		// campos na linha seguinte, caso contrario, todas as informacoes sao impressas em uma linha unica		
		If Len(aItemNfce[nX]:_PROD:_XPROD:TEXT) > 12			
			oPrint:Say( nAuxLn,0430,PADR(aItemNfce[nX]:_PROD:_XPROD:TEXT,44)	+ " "  ,oFont1 )	//Descricao de Produto		
		Else
			oPrint:Say( nAuxLn,0430,PADR(aItemNfce[nX]:_PROD:_XPROD:TEXT,12)	+ " "  ,oFont1 )	//Descricao de Produto
		EndIf
		
		oPrint:Say( nAuxLn,1250,PADL(AllTrim(Str(nItemQtde)),6) 				+ " "  ,oFont1 )					//Qtde
		oPrint:Say( nAuxLn,1500,PADR(aItemNfce[nX]:_PROD:_UCOM:TEXT,2)		+ " "  ,oFont1 )					//Unidade de Medida
		oPrint:Say( nAuxLn,1650,PadL(AllTrim(Str(nItemUnit ,(20-nDecVRUNIT), nDecVRUNIT)),8)	+ " "  ,oFont1 )	//Valor Unit.
		oPrint:Say( nAuxLn,1950,PADL(AllTrim(Str(nItemTotal,18, 2)),9)  ,oFont1 ) 			   					//Valor Total		
		
		If nAuxLn > nTamPgV
			nAuxLn := 20
			oPrint:EndPage()
			oPrint:StartPage()
		EndIf
	Next nX
	
	nAuxLn += 40
	oPrint:Say( nAuxLn,050, cLinha, oFont3 )
	
	//
	// Divisão IV – Informações de Total do DANFE NFC-e
	//
	oPrint:SetFont(oFont1)
	nAuxLn += 70
	oPrint:Say( nAuxLn,0080,"Qtd. Total de Itens")
	oPrint:Say( nAuxLn,1900,PADR( AllTrim( Str(Len(aItemNfce)) ),38 ) )
	nAuxLn += 40
	oPrint:Say( nAuxLn,0080,"Valor Total R$")
	oPrint:Say( nAuxLn,1900,PADR(AllTrim(Str(Val(aTotal:_ICMSTOT:_VNF:TEXT),18,2)),43))
	
	If nTotDesc > 0
		nAuxLn += 40
		oPrint:Say( nAuxLn,0080,"Valor dos Descontos R$")
		oPrint:Say( nAuxLn,1900,PADR(AllTrim(Str(nTotDesc,18,2)),39) )
	EndIf
	
	If nTotAcresc > 0
		nAuxLn += 40
		oPrint:Say( nAuxLn,0080,"Valor dos Acrescimos R$")
		oPrint:Say( nAuxLn,1900,PADR(AllTrim(Str(nTotAcresc,18,2)),39) )
	EndIf
			
	oPrint:SetFont(oFont)
	nAuxLn += 55
	oPrint:Say( nAuxLn,0080,"Forma de Pagamento" , oFont4)
	oPrint:Say( nAuxLn,1900,"Valor Pago" , oFont4)
	
	oPrint:SetFont(oFont1)	
	For nX := 1 to Len(aPagNFCe)					
		nAuxLn += 50
		
		If (nY := aScan(aFormas,{|x| Alltrim(x[2]) == Alltrim(aPagNfce[nX]:_TPAG:TEXT) })) > 0 			
			oPrint:Say( nAuxLn,0080,aFormas[nY][1])
			oPrint:Say( nAuxLn,1900, PADR(AllTrim(Str(Val(aPagNfce[nX]:_VPAG:TEXT),18,2)),40 ) )
		Else
			oPrint:Say( nAuxLn,0080,"OUTROS" )
			oPrint:Say( nAuxLn,1900,PadL( AllTrim(Str(Val(aPagNfce[nX]:_VPAG:TEXT),18,2)),40 ) )						
		EndIf
		
		If nAuxLn > nTamPgV
			nAuxLn := 20
			oPrint:EndPage()
			oPrint:StartPage()
		EndIf
		
	Next nX
	
	nAuxLn += 50
	oPrint:Say( nAuxLn,050, cLinha , oFont3 )
	
	// Divisão V – Informações dos Tributos no DANFE NFC-e
	//
	If lL2TotImp .AND. FindFunction("Lj950ImpNC")
	
		//Totaliza Imposto
		DbSelectArea("SL2")
		SL2->(DbSeek(xFilial("SL2")+SL1->L1_NUM))
		While SL2->( !Eof() ) .AND. ( xFilial("SL2") + SL1->L1_NUM == SL2->L2_FILIAL + SL2->L2_NUM )
			nTotImpNCM += SL2->L2_TOTIMP
			nTotVLRNCM += SL2->L2_VLRITEM				
			SL2->( dbSkip() )
		End

		nAuxLn += 60
		oPrint:Say( nAuxLn,0080,noAcento(Lj950ImpNC(nTotVLRNCM,nTotImpNCM,nDecimais, .T.)) ,oFont1 )	
	EndIf
	
	nAuxLn += 40
	oPrint:Say( nAuxLn,050, cLinha , oFont3 )
		
	//Divisão Va – Mensagem de Interesse do Contribuinte
	//Conteúdo da tag <infCpl> - Informações Complementares
	If Type("oNfce:_NFE:_INFNFE:_INFADIC") == "O"
	
		//para que haja a quebra de linha durante a impressao, separamos cada linha por |		
		aInfCpl := StrToKArr(oNfce:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT, "|")
		nInfCpl := Len( aInfCpl )	//quantidade de quebra de linhas			
		For nY := 1 to nInfCpl
			nAuxLn += 40
			oPrint:Say( nAuxLn,0080,aInfCpl[nY]  ,oFont1 )
					
			If nAuxLn > nTamPgV
				nAuxLn := 20
				oPrint:EndPage()
				oPrint:StartPage()
			EndIf
		Next					
	EndIf
	
	nAuxLn += 40
	oPrint:Say( nAuxLn,050, cLinha , oFont3 )
				
	// Divisão VI – Mensagem Fiscal e Informações da Consulta via Chave de Acesso
	//
	If cAmbiente == "2"
		nAuxLn += 40
		oPrint:Say( nAuxLn,0650,"EMITIDA EM AMBIENTE DE TESTE - SEM VALOR FISCAL" ,oFont2)
	EndIf
	
	If lContigen
		nAuxLn += 60
		oPrint:Say( nAuxLn,0800,"NFC-e EMITIDA EM CONTINGÊNCIA" ,oFont2)
	EndIf
	
	nAuxLn += 80
	oPrint:Say( nAuxLn, 0550,"Numero:" + aIdNfce:_NNF:TEXT + " Serie:" + aIdNfce:_SERIE:TEXT + " Emissao:"  + ;
	SubStr(aIdNfce:_DHEMI:TEXT,9,2) + "/" + SubStr(aIdNfce:_DHEMI:TEXT,6,2)  + "/" + SubStr(aIdNfce:_DHEMI:TEXT,1,4) + ;
	" " + SubStr(aIdNfce:_DHEMI:TEXT,12,2) + ":" + SubStr(aIdNfce:_DHEMI:TEXT,15,2)  + ":" + SubStr(aIdNfce:_DHEMI:TEXT,18,2) , oFont1)  //Hora
 
	nAuxLn += 70                                   
	oPrint:Say( nAuxLn, 0680," Consulte pela chave de acesso em: " ,oFont)
	nAuxLn += 60	
	cURLNFCE := LjNFCeURL(cAmbiente,.T.)
	oPrint:Say( nAuxLn, 0120, cURLNFCE ,oFont2)
	
	nAuxLn += 80
	oPrint:Say( nAuxLn, 0900,"CHAVE DE ACESSO" ,oFont)		//A frase “CHAVE DE ACESSO”, em caixa alta;	
	
	nAuxLn += 60
	oPrint:Say( nAuxLn, 0500,SubStr(cChvNFCe, 1,4) + " "  + SubStr(cChvNFCe, 5,4) + " " +;
				SubStr(cChvNFCe, 9,4) + " "  + SubStr(cChvNFCe,13,4) + " "  + SubStr(cChvNFCe,17,4) + " "  +;
				SubStr(cChvNFCe,21,4) + " "  + SubStr(cChvNFCe,25,4) + " "  + SubStr(cChvNFCe,29,4) + " "  +;
				SubStr(cChvNFCe,33,4) + " "  + SubStr(cChvNFCe,37,4) + " "  + SubStr(cChvNFCe,41,4) ,oFont1)
	
	nAuxLn += 50
	oPrint:Say( nAuxLn,050, cLinha , oFont3 )	
	
	If nAuxLn > nTamPgV 
		nAuxLn := 20
		oPrint:EndPage()
		oPrint:StartPage()
	EndIf
	
	//
	// Divisão VII – Informações sobre o Consumidor
	//
	nAuxLn += 60
	oPrint:Say(nAuxLn, 0980,"CONSUMIDOR",oFont)
		
	If Empty(aDestNfce)		
		nAuxLn += 40
		oPrint:Say( nAuxLn, 0780,"CONSUMIDOR NÃO IDENTIFICADO" , oFont1)//Deve constar a palavra "CONSUMIDOR" centralizada e em caixa alta		
	Else
		If Type("aDestNfce:_CNPJ") <> 'U'
			nAuxLn += 40
			oPrint:Say( nAuxLn, 0300,"CNPJ:" + AllTrim(aDestNfce:_CNPJ:TEXT), oFont1)
		ElseIf Type("aDestNfce:_CPF") <> 'U'
			nAuxLn += 40
			oPrint:Say( nAuxLn, 0300,"CPF:" + AllTrim(aDestNfce:_CPF:TEXT), oFont1)
		ElseIf Type("aDestNfce:_IDESTRANGEIRO") <> 'U'
			nAuxLn += 40
			oPrint:Say( nAuxLn, 0300,"Id. Estrangeiro:" + AllTrim(aDestNfce:_IDESTRANGEIRO:TEXT), oFont1)
		EndIf
		
		If Type("aDestNfce:_XNOME") <> 'U'
			nAuxLn += 40
			oPrint:Say( nAuxLn, 0300," Nome:" + AllTrim(aDestNfce:_XNOME:TEXT) + ' ', oFont1 )
		EndIf
			//Verifica se possui endereço			
		If Type("aDestNfce:_ENDERDEST") <> 'U'
			nAuxLn += 40
			oPrint:Say( nAuxLn, 0300," Endereco:" + AllTrim(aDestNfce:_ENDERDEST:_XLGR:TEXT) + ',' + AllTrim(aDestNfce:_ENDERDEST:_NRO:TEXT) + ' ' + AllTrim(aDestNfce:_ENDERDEST:_XBAIRRO:TEXT) + ' ' + aDestNfce:_ENDERDEST:_XMUN:TEXT + ' ', oFont1)
		EndIf
	EndIf
	
	nAuxLn += 40	
	oPrint:Say( nAuxLn,050, cLinha , oFont3 )
		
	//
	// Divisão VIII – Informações da Consulta via QR Code
	//
	nAuxLn += 70
	
	If nAuxLn > nTamPgV-150		
		oPrint:EndPage()
		oPrint:StartPage()
		nAuxLn := 100
	EndIf
	
	oPrint:Say(nAuxLn, 0750,"Consulta via leitor de QR Code",oFont)
	
	cKeyQRCode := LjNFCeQRCo(oNFCe, cAmbiente)	//Obtem o QR-Code		
	
	/*
	Tratamento feito para controlar posição da impressao do QRCODE, pois o metodo
	do mesmo, nao esta respeitando a posição de impressao quando a Quebra de Pagina
	*/
	If nAuxLn > nTamPgV-1000
		oPrint:EndPage()
		oPrint:StartPage()
		nAuxLn := 80
	EndIf  
	
	nAuxLn += 775
	
	//Impressão do QrCode
	oPrint:QRCode( nAuxLn, 750, cKeyQRCode,5)	
	
	nAuxLn += 40

	If !lContigen
		cTextoTemp := "Protocolo Autorização:" + cProtAuto
		
		oPrint:Say( nAuxLn, 0370,cTextoTemp )
	EndIf

	////////////////////
	//Fim da Impressão/
	oPrint:EndPage()
	/////////////////
		
Return

//--------------------------------------------------------
/*{Protheus.doc} LjRDnfNfce
Imprime Danfe(Vulgo: Danfinha)

@author  Varejo
@version P11.8
@since   27/01/2016
@return	 lRet - imprimiu 
*/
//--------------------------------------------------------
User Function LjRDnfNfce(cXML, cXMLProt, cChvNFCe, lDANFEPad)
Local cChave		:= ""
Local nX			:= 0 
Local nY			:= 0 
Local aFormas		:= {}
Local aRet			:= {}
Local lRet			:= .T. //Retorna se conseguiu transmitir a Nota, não deve retornar erro caso ocorra problema de impressao
Local lCondensa		:= SuperGetMV("MV_LJCONDE",,.F.) .Or. IIf("EPSON" $ Alltrim(LJGetStation("IMPFISC")),.T.,.F.)
Local lImpComum		:= SuperGetMV("MV_LJSTPRT",,1) == 2
Local cCgcCli		:= ""
Local cTexto		:= ""  
Local cCrLf			:= Chr(10)
Local cTagCondIni	:= Iif(lCondensa, TAG_CONDEN_INI , "")
Local cTagCondFim	:= IIf(lCondensa, TAG_CONDEN_FIM , "")
Local cTracejado 	:= IIf(lCondensa, "--------------------------------------------------------", Replicate( "-", nQtdColuna ))
Local cLinha		:= TAG_CENTER_INI + cTagCondIni + cTracejado + cTagCondFim + TAG_CENTER_FIM + cCrLf
Local cImpressora	:= ""
Local cPorta		:= ""
Local cKeyQrCode	:= ""
Local cTextoTemp	:= ""
Local cTextoAux 	:= ""
Local cFormaPgto	:= ""
Local cVlrFormPg	:= ""
Local lContigen 	:= .T. 								//Sinaliza emissao em modo de contingencia
Local cProtAuto		:= ""								//Chave de Autorizacao
Local cAmbiente		:= ""
Local cDtHoraAut	:= ""
Local lL2TotImp		:= SL2->(FieldPos("L2_TOTIMP")) > 0
Local nTotImpNCM	:= 0
Local nTotVLRNCM	:= 0
Local nItemQtde		:= 0
Local nItemUnit		:= 0
Local nItemTotal	:= 0
Local nItemDesc		:= 0
Local nTotDesc		:= 0 
Local nTotAcresc	:= 0								//somatoria do acrescimo da venda (frete)
Local nDecVRUNIT	:= TamSX3("L2_VRUNIT")[2]			//quantidade de casas decimais a serem impressas no campo VlUnit do DANFE
Local cInscMun		:= ""
Local cDescItem		:= ""
Local cLineRegIt	:= ""

Local aEmitNfce		:= {}								//dados do emitente
Local aIdNfce		:= {}								//dados de Identificacao da Nfc-e
Local aPagNfce		:= {}								//dados dos pagtos  
Local aTotal		:= {}								//Totais(NF,Desconto,ICMS...)

Local nSaltoLn		:= SuperGetMV("MV_FTTEFLI",, 1)		// Linha pula entre comprovante
Local lGuil			:= SuperGetMV("MV_FTTEFGU",, .T.)	// Ativa guilhotina

Local lLj7084		:= .T.								// retorno do PE LJ7084
Local lPOS			:= Iif(FindFunction("STFIsPOS"), STFIsPOS(), .F.)
Local nContItImp	:= 0								//Contador de itens a serem impressos
Local aInfCpl		:= {}								//vetor com as mensagens que possuem quebra de linha
Local nInfCpl		:= 0								//quantidade de quebra de linhas
Local nMVNFCEDES	:= SuperGetMV("MV_NFCEDES",, 0)		// Exibe ou não desconto por item na DANFE NFC-e

//Parametros enviados pela função no fonte LOJNFCE
Default cXml 		:= ""
Default cXmlProt	:= ""
Default cChvNFCe	:= ""
Default lDanfePad	:= .F.

Private oNFCe				//retorno do XML da NFCe funcao convertido para objeto
Private oProt				//retorno do XML do protocolo de autorizacao convertido para objeto
Private aDestNFCe	:= {}	//dados do destinatário
Private aItemNFCe	:= {}	//dados dos itens

BEGIN SEQUENCE

	//-----------------------------------------------------
	// Conversao XML da NFC-e e do Protocolo de Autorizacao
	//-----------------------------------------------------
	aRet := LjXMLNFCe(cXML)
	If aRet[1]
		oNFCe := aRet[2]
	Else
		BREAK
	EndIf
	
	aRet := LjXMLNFCe(cXMLProt)
	If aRet[1]
		oProt := aRet[2]
	Else
		BREAK
	EndIf
	
	/*
		Armazena a chave que está no arquivo XML, pois se o ERP enviar uma nota na modalidade NORMAL e o TSS ter entrado 
		em CONTINGENCIA de forma automatica, o elemento MODALIDADE da chave eletronica sera substituido pelo TSS	
	*/
	cChvNFCe := StrTran(oNFCe:_NFE:_INFNFE:_ID:TEXT, "NFe")	//Chave da NFC-e

	//------------------------
	// Ponto de Entrada LJ7084
	//------------------------
	// Permite definir o que será realizado com os dados do DANFE
	// ex: customizar a impressao, e-mail, sms ou nao imprimir
	// .T. - apos a execucao do ponto de entrada, realiza a impressao padrao do DANFE
	// .F. - apos a execucao do ponto de entrada, NAO realiza a impressao padrao do DANFE
	If ExistBlock("LJ7084")
		lLj7084 := ExecBlock( "LJ7084", .F., .F., {oNFCe, oProt} )
		If ValType(lLj7084) <> "L"
			lLj7084 = .T.
		EndIf
	EndIf

	//--------------------------
	// Impressao padrao do DANFE
	//--------------------------
	If lDanfePad .AND. lLJ7084

		//----------------------------------------
		// Comunicacao com a impressora nao fiscal
		//----------------------------------------
		If !lPos .AND. nHdlECF == -1
			cImpressora	:= LJGetStation("IMPFISC")
			cPorta := "AUTO"

			If !IsBlind()
				LjMsgRun( "Aguarde. Abrindo a Impressora Não Fiscal...",, { || nHdlECF := INFAbrir( cImpressora,cPorta ) } )
			Else
				conout("Aguarde. Abrindo a Impressora...")
				nHdlECF := INFAbrir( cImpressora,cPorta )
			EndIf

			//Verifica se houve comunicacao com a impressora
			If nHdlECF == -1
				If !IsBlind()
					MsgStop("NFC-e: Não foi possível estabelecer comunicação com a Impressora:" + cImpressora)
				Else
					conout("NFC-e: Não foi possível estabelecer comunicação com a Impressora:" + cImpressora)
					//nao ha necessidade de retornar erro quando houver erro de impressora
				EndIf				
				//aborta a impressao
				BREAK
			EndIf
		EndIf
		
		//Valida se existe nDecimais, variavel é Privete declarada no Loja701
		If Type("nDecimais") == "U"
			nDecimais := MsDecimais(1)				// Quantidade de casas decimais
		EndIf

		aFormas := LjDfRetFrm()
		
		//Verifica se conseguiu montar o objeto do XML e sinaliza nao contingencia 
		If (oProt <> NIL) .And. LjRTemNode(oProt:_PROTNFE:_INFPROT,"_NPROT")
			cProtAuto 	:= AllTrim(oProt:_PROTNFE:_INFPROT:_NPROT:TEXT)
			lContigen	:= .F.

			If LjRTemNode(oProt:_PROTNFE:_INFPROT,"_DHRECBTO")
				cDtHoraAut := oProt:_PROTNFE:_INFPROT:_DHRECBTO:TEXT
				cProtAuto += " " + SubStr(cDtHoraAut,9,2) + "/" + SubStr(cDtHoraAut,6,2)  + "/" + SubStr(cDtHoraAut,1,4) 	//Data
				cProtAuto += " " + SubStr(cDtHoraAut,12,2) + ":" + SubStr(cDtHoraAut,15,2)  + ":" + SubStr(cDtHoraAut,18,2)  //Hora
			EndIf
		EndIf

		//------------------------------------------------------------
		//Separa objetos do XML para facilitar a manipulacao dos dados
		//------------------------------------------------------------
		aEmitNfce	:= oNfce:_NFE:_INFNFE:_EMIT 		//Emitente

		//Ambiente (Normal ou Homologação)
		cAmbiente := oNFCe:_NFE:_INFNFE:_IDE:_TPAMB:TEXT

		//Quando não informa CPF/CNPJ, não retorna o objeto _DEST		
		If LjRTemNode(oNfce:_NFE:_INFNFE,"_DEST")
			aDestNfce	:= oNfce:_NFE:_INFNFE:_DEST 	//Destinatário
		EndIf

		aIdNfce		:= oNfce:_NFE:_INFNFE:_IDE			//Detalhe da NFC-e
		
		//Quando possui apenas um item, não retorna um Array de _PAG e sim os detalhes da Forma de Pagto, caso contrario retorna Array
		If Type("oNfce:_NFE:_INFNFE:_PAG[1]") == "O"
			aPagNfce	:= oNfce:_NFE:_INFNFE:_PAG
		Else
			aAdd(aPagNfce, oNfce:_NFE:_INFNFE:_PAG)
		EndIf

		//Quando possui apenas um item, não retorna um Array de _DET e sim os detalhes do produto, caso contrario retorna Array	
		If Type("oNfce:_NFE:_INFNFE:_DET[1]") == "O"
			aItemNfce	:= oNfce:_NFE:_INFNFE:_DET
		Else
			aAdd( aItemNfce, oNfce:_NFE:_INFNFE:_DET )
		EndIf
		
		//Total da NF
		aTotal := oNfce:_NFE:_INFNFE:_TOTAL
		
		//Verifica compatibilidade de Impressao: 4-DANFE Detalhada e 5-DANFE Resumida
		If !aIdNfce:_TPIMP:TEXT $ "45"
			If !IsBlind()
				MsgStop("Nfc-e: Tipo de Impressão incompatível: "+aIdNfce:_TPIMP:TEXT)
			Else
				Conout("Nfc-e: Tipo de Impressão incompatível: "+aIdNfce:_TPIMP:TEXT)
			EndIf			
			//aborta a rotina de impressao
			BREAK
		EndIf

		//
		// Divisão I - Informações do Cabeçalho
		//
		If LjRTemNode(aEmitNfce,"_IM")
			cInscMun := " IM:"+aEmitNfce:_IM:TEXT
		EndIf
		cTexto += TAG_BMP_INI+TAG_BMP_FIM  //Logo da NFC-e, deve estar carregado na impressora(Utilizar Tool para carregar imagem)
		cTexto += cTagCondIni + AllTrim(aEmitNfce:_XNOME:TEXT) + cCrLf 						//Denominação do Emitente		
		cTexto += AllTrim("CNPJ:" + aEmitNfce:_CNPJ:TEXT + " / IE:" + aEmitNfce:_IE:TEXT + cInscMun) + cCrLf	//CNPJ do Emitente //Inscrição Estadual do Emitente
		cTexto += AllTrim(aEmitNfce:_ENDEREMIT:_XLGR:TEXT) + ;
				  " Nr." + AllTrim(aEmitNfce:_ENDEREMIT:_NRO:TEXT) + "," + ;
				  AllTrim(aEmitNfce:_ENDEREMIT:_XBAIRRO:TEXT) + "," + ;
				  AllTrim(aEmitNfce:_ENDEREMIT:_XMUN:TEXT) + ", " + ;
				  AllTrim(aEmitNfce:_ENDEREMIT:_UF:TEXT) + cTagCondFim + cCrLf		//Endereço do Emitente
		cTexto += cLinha	                                    

		//
		// Divisão II – Informações Fixas do DANFE NFC-e
		//		
		cTexto += TAG_CENTER_INI+cTagCondIni+"DANFE NFC-e - Documento Auxiliar" + cTagCondFim+TAG_CENTER_FIM + cCrLf
		cTexto += TAG_CENTER_INI+cTagCondIni+"da Nota Fiscal Eletrônica para Consumidor Final" + cTagCondFim+TAG_CENTER_FIM+ cCrLf
		cTexto += TAG_CENTER_INI+cTagCondIni+"Não permite aproveitamento de crédito de ICMS" + cTagCondFim+TAG_CENTER_FIM + cCrLf
		cTexto += cLinha	                                    

		//
		// Divisão III – Informações de Detalhe da Venda
		// * a impressao dessa divisão é opcional ou conforme definido por UF
		// 
		cTexto += TAG_CONDEN_INI+TAG_NEGRITO_INI+"Codigo          Descricao       Qtd Un   VlUnit  VlTotal"+TAG_NEGRITO_FIM+TAG_CONDEN_FIM+ cCrLf

		For nX := 1 to Len(aItemNfce)

			nContItImp++ //Contador de itens a serem impressos

			nItemQtde	:= Val(aItemNfce[nX]:_PROD:_QCOM:TEXT)
			nItemUnit 	:= Val(aItemNfce[nX]:_PROD:_VUNCOM:TEXT)
			nItemTotal	:= Val(aItemNfce[nX]:_PROD:_VPROD:TEXT)

			//Quando desconto, subtrai do valor do item
			If LjRTemNode(aItemNfce[nX]:_PROD,"_VDESC")
				nTotDesc += Val(aItemNfce[nX]:_PROD:_VDESC:TEXT)
			EndIf

			//Acumulamos o acrescimo (Frete/Seguro/Despesa)
			If LjRTemNode(aItemNfce[nX]:_PROD,"_VOUTRO")
				nTotAcresc += Val(aItemNfce[nX]:_PROD:_VOUTRO:TEXT)
			EndIf
			
			cLineRegIt:= ""
			cLineRegIt+= TAG_CONDEN_INI
			
			cDescItem := AllTrim(aItemNfce[nX]:_PROD:_XPROD:TEXT)			
			
			//Se a Descricao for igual a 12 caracteres, imprime tudo numa linha só 
			//Se descrição maior que 12 imprime toda a descrição, pula linha e imprime o que falta
			If Len(cDescItem) > 13
				cLineRegIt += cDescItem + cCrLf 													//Descricao de Produto
				cLineRegIt += PADR(aItemNfce[nX]:_PROD:_CPROD:TEXT,28)		+ " "					//Codigo de Produto
			Else
				cLineRegIt += PADR(aItemNfce[nX]:_PROD:_CPROD:TEXT,15)		+ " "					//Codigo de Produto
				cLineRegIt += cDescItem	                                    + " "					//Descricao de Produto
			EndIf

			cLineRegIt += PADL(AllTrim(Str(nItemQtde)),6) 				+ " "					//Qtde
			cLineRegIt += PADR(aItemNfce[nX]:_PROD:_UCOM:TEXT,2)		+ " "					//Unidade de Medida
			cLineRegIt += PadL(AllTrim(Str(nItemUnit ,(21-nDecVRUNIT), nDecVRUNIT)),8)	+ " "	//Valor Unit.
			cLineRegIt += PADL(AllTrim(Str(nItemTotal,18, 2)),8) 			   					//Valor Total
			
			If nMVNFCEDES == 1
				If Type("aItemNfce["+AllTrim(Str(nX))+"]:_PROD:_VDESC") == "O"
					cLineRegIt += cCrLf
					cLineRegIt += PADR("Desconto no Item " + aItemNfce[nX]:_PROD:_CPROD:TEXT, 29)
					cLineRegIt += PADL("-" + AllTrim(Str(Val(aItemNfce[nX]:_PROD:_VDESC:TEXT),18, 2)),26) 
				EndIf
			EndIf
			
			cTexto += cLineRegIt
			cTexto += TAG_CONDEN_FIM + cCRLF

			//Tratamento necessário pois dependendo tamanho das informações dos itens a serem impressos,
			//apos um determinado tamanho o texto não é impresso, gerenado o erro de DEBUG/TOTVSAPI na DLL.
			//para isso foi quebrada a impressão em 50 itens.
			If nContItImp == 30
				If !lPos
					INFTexto(cTexto)  //Envia comando para a Impressora
				Else
					STWPrintTextNotFiscal(cTexto)
				EndIf
				cTexto		:= ""
				nContItImp	:= 0
			EndIf

		Next nX
		cTexto += cLinha                                     	                                          
			
		//-------------------------------------------------------------------------------------
		// Divisão IV – Informações de Total do DANFE NFC-e
		//-------------------------------------------------------------------------------------
		
		//--------------------------------------------
		// "Qtd. Total de Itens"
		//--------------------------------------------
		cTextoAux 	:= "Qtd. Total de Itens"
		cTextoAux 	:= cTextoAux + PADL( AllTrim( Str(Len(aItemNfce)) ), nQtdColuna-Len(cTextoAux) )
		cTexto 		+= TAG_CENTER_INI + cTagCondIni + cTextoAux + cTagCondFim + TAG_CENTER_FIM + cCrLf
		
		//--------------------------------------------
		// "Valor Total R$"
		//--------------------------------------------
		cTextoAux 	:= "Valor Total R$"
		cTextoAux 	:= cTextoAux + PADL( AllTrim(Str(Val(aTotal:_ICMSTOT:_VNF:TEXT),18,2)), nQtdColuna-Len(cTextoAux) )
		cTexto 		+= TAG_CENTER_INI + cTagCondIni + cTextoAux + cTagCondFim + TAG_CENTER_FIM + cCrLf
		
		If nTotDesc > 0
			//--------------------------------------------
			// "Valor Descontos R$"
			//--------------------------------------------
			cTextoAux 	:= "Valor Descontos R$"
			cTextoAux 	:= cTextoAux + PADL(AllTrim(Str(nTotDesc,18,2)), nQtdColuna-Len(cTextoAux) )
			cTexto 		+= TAG_CENTER_INI + cTagCondIni + cTextoAux + cTagCondFim + TAG_CENTER_FIM + cCrLf
		EndIf
		
		If nTotAcresc > 0
			//--------------------------------------------
			// "Valor Acrescimos R$"
			//--------------------------------------------
			cTextoAux 	:= "Valor Acrescimos R$"
			cTextoAux 	:= cTextoAux + PADL(AllTrim(Str(nTotAcresc,18,2)), nQtdColuna-Len(cTextoAux) )
			cTexto 		+= TAG_CENTER_INI + cTagCondIni + cTextoAux + cTagCondFim + TAG_CENTER_FIM + cCrLf
		EndIf	
		
		
		//---------------------------------------------------------
		// "Forma de Pagamento                    Valor Pago"
		//---------------------------------------------------------
		cTextoAux 	:= "Forma de Pagamento"
		cTextoAux 	:= cTextoAux + PADL("Valor Pago", nQtdColuna-Len(cTextoAux) )
		cTexto += TAG_CENTER_INI + cTagCondIni + TAG_NEGRITO_INI + cTextoAux + TAG_NEGRITO_FIM + cTagCondFim + TAG_CENTER_FIM + cCrLf
		
		For nX := 1 to Len(aPagNFCe)
							
			If (nY := aScan(aFormas,{|x| Alltrim(x[2]) == Alltrim(aPagNfce[nX]:_TPAG:TEXT) })) > 0 	
				cFormaPgto := aFormas[nY][1]
			Else
				cFormaPgto := "OUTROS"
			EndIf
			
			cVlrFormPg := AllTrim(Str(Val(aPagNfce[nX]:_VPAG:TEXT),18,2))
			
			cTexto += TAG_CENTER_INI + cTagCondIni + cFormaPgto + PADL( cVlrFormPg , nQtdColuna-Len(cFormaPgto) ) + cTagCondFim + TAG_CENTER_FIM + cCrLf
			
		Next nX
		cTexto += cLinha
		
		//
		// 	Divisão V – Informações dos Tributos no DANFE NFC-e
		//
		//  Trecho retirado pois já havia sido impresso no LOJANF		
		// 	

		
					
		//
		//Divisão Va – Mensagem de Interesse do Contribuinte
		//Conteúdo da tag <infCpl> - Informações Complementares
		//
		If LjRTemNode(oNfce:_NFE:_INFNFE,"_INFADIC")
			cTexto += TAG_CENTER_INI + TAG_NEGRITO_INI

			//para que haja a quebra de linha durante a impressao, separamos cada linha por |
			aInfCpl := StrToKArr(oNfce:_NFE:_INFNFE:_INFADIC:_INFCPL:TEXT, "|")
			nInfCpl := Len( aInfCpl )	//quantidade de quebra de linhas			
			For nY := 1 to nInfCpl
				cTexto += aInfCpl[nY]
				If nY <> nInfCpl
					cTexto += cCrLf
				EndIf
			Next

			cTexto += TAG_NEGRITO_FIM + TAG_CENTER_FIM + cCrLf
		EndIf
		cTexto += cLinha

		//
		// Divisão VI – Mensagem Fiscal e Informações da Consulta via Chave de Acesso
		//
		If cAmbiente == "2"
			cTexto += TAG_CENTER_INI+ TAG_NEGRITO_INI +"EMITIDA EM AMBIENTE DE TESTE - SEM VALOR FISCAL" + TAG_NEGRITO_FIM + TAG_CENTER_FIM + cCrLf			
		EndIf

		If lContigen
			cTexto += TAG_CENTER_INI+ TAG_NEGRITO_INI +"NFC-e EMITIDA EM CONTINGÊNCIA" + TAG_NEGRITO_FIM + TAG_CENTER_FIM + cCrLf			
		EndIf

		cTexto += cTagCondIni
		cTexto += "Numero:" + aIdNfce:_NNF:TEXT 								//Número da NFC-e
		cTexto += " Serie:" + aIdNfce:_SERIE:TEXT 								//Série da NFC-e
		cTexto += " Emissao:"
		cTexto += " " + SubStr(aIdNfce:_DHEMI:TEXT,9,2) + "/" + SubStr(aIdNfce:_DHEMI:TEXT,6,2)  + "/" + SubStr(aIdNfce:_DHEMI:TEXT,1,4) 	//Data
		cTexto += " " + SubStr(aIdNfce:_DHEMI:TEXT,12,2) + ":" + SubStr(aIdNfce:_DHEMI:TEXT,15,2)  + ":" + SubStr(aIdNfce:_DHEMI:TEXT,18,2)  //Hora
		//TODO: Quando contingência, deve emitir uma via para o estabelecimento
		cTexto += cTagCondFim + cCrLf 
		
		cTexto += TAG_CENTER_INI+cTagCondIni+"Via Consumidor"+cTagCondFim+ TAG_CENTER_FIM + cCrLf 
		
		cTexto += cLinha	                                    
		cTexto += TAG_CENTER_INI+cTagCondIni+" Consulte pela chave de acesso em: " + cTagCondFim+TAG_CENTER_FIM + cCrLf 	
		
		cTexto += TAG_CENTER_INI+cTagCondIni+ LjNFCeURL(cAmbiente, .T.) + cTagCondFim+TAG_CENTER_FIM + cCrLf 	
		
		cTexto += TAG_CENTER_INI+ "Chave de Acesso" + TAG_CENTER_FIM + cCrLf	//A frase “CHAVE DE ACESSO”, em caixa alta;	

		cTexto += TAG_CENTER_INI+cTagCondIni
		cTexto += SubStr(cChvNFCe, 1,4) + " "
		cTexto += SubStr(cChvNFCe, 5,4) + " "
		cTexto += SubStr(cChvNFCe, 9,4) + " "
		cTexto += SubStr(cChvNFCe,13,4) + " "
		cTexto += SubStr(cChvNFCe,17,4) + " "
		cTexto += SubStr(cChvNFCe,21,4) + " "			
		cTexto += SubStr(cChvNFCe,25,4) + " "
		cTexto += SubStr(cChvNFCe,29,4) + " "
		cTexto += SubStr(cChvNFCe,33,4) + " "
		cTexto += SubStr(cChvNFCe,37,4) + " "
		cTexto += SubStr(cChvNFCe,41,4)
		cTexto += cTagCondFim+TAG_CENTER_FIM	+ cCrLf		
		cTexto += cLinha

		//
		// Divisão VII – Informações sobre o Consumidor
		//
		cTexto += TAG_CENTER_INI+"Consumidor"+TAG_CENTER_FIM+ cCrLf
		cTexto += TAG_CENTER_INI+cTagCondIni
		If Empty(aDestNfce)
			cTexto += "Consumidor nao identificado" + cCrLf //Deve constar a palavra "CONSUMIDOR" centralizada e em caixa alta		
		Else
			If LjRTemNode(aDestNfce,"_CNPJ")
				cTexto += "CNPJ:" + AllTrim(aDestNfce:_CNPJ:TEXT)
			ElseIf LjRTemNode(aDestNfce,"_CPF")
				cTexto += "CPF:" + AllTrim(aDestNfce:_CPF:TEXT)
			ElseIf LjRTemNode(aDestNfce,"_IDESTRANGEIRO")
				cTexto += "Id. Estrangeiro:" + AllTrim(aDestNfce:_IDESTRANGEIRO:TEXT)
			EndIf
			
			If LjRTemNode(aDestNfce,"_XNOME")
				cTexto += " Nome:" + AllTrim(aDestNfce:_XNOME:TEXT) + ' '
			EndIf

			//Verifica se possui endereço			
			If LjRTemNode(aDestNfce,"_ENDERDEST")
				cTexto += " Endereco:" + AllTrim(aDestNfce:_ENDERDEST:_XLGR:TEXT) + ',' + AllTrim(aDestNfce:_ENDERDEST:_NRO:TEXT) + ' ' + AllTrim(aDestNfce:_ENDERDEST:_XBAIRRO:TEXT) + ' ' + aDestNfce:_ENDERDEST:_XMUN:TEXT + ' '
			EndIf

			cTexto += cCrLf
		EndIf
		cTexto += cTagCondFim+TAG_CENTER_FIM
		cTexto += cLinha

		//
		// Divisão VIII – Informações da Consulta via QR Code
		//
		cKeyQRCode := LjNFCeQRCo(oNFCe, cAmbiente)	//Obtem o QR-Code

		cTexto += TAG_CENTER_INI+cTagCondIni+"Consulta via leitor de QR Code"+cTagCondFim+TAG_CENTER_FIM + cCrLf
		cTexto += TAG_CENTER_INI+TAG_QRCODE_INI+cKeyQRCode+TAG_QRCODE_FIM+TAG_CENTER_FIM
		If !lContigen
			cTextoTemp := "ProtocoloAutorizacao:" + cProtAuto
			cTexto += cTagCondIni+ cTextoTemp + cTagCondFim + cCrLf
		EndIf
		cTexto += cLinha

		//Salta linha extra
		For nX := 1 to nSaltoLn
			cTexto += cCrLf
		Next nX

		//----------------
		// Imprime o DANFE
		//----------------
		If lImpComum// Impressora Laser
			U_LOJRNFCe(	oNFCe		, oProt		, nDecimais	, aFormas	,;
						cProtAuto	, lContigen	, cDtHoraAut, aEmitNfce	,; 
						aDestNfce	, aIdNfce	, aPagNfce	, aItemNfce	,; 
						aTotal		, cChvNFCe	, cInscMun	)
		Else //Imprime Não Fiscal				
			If lPos
				STWPrintTextNotFiscal(cTexto)
			Else
				INFTexto(cTexto)	//Envia comando para a Impressora
			EndIf
			
			//
			//Realiza o corte do papel, apos a impressao da DANFE
			//
			If lGuil
				cTexto := TAG_GUIL_INI+TAG_GUIL_FIM		//Corte de Papel
	
				If lPos
					STWPrintTextNotFiscal(cTexto)
				Else
					INFTexto(cTexto)	 //Envia comando para a Impressora
				EndIf
			EndIf
		EndIf		
	EndIf

RECOVER
	lRet := .F.

END SEQUENCE

aRet := { lRet,cChvNFCe }

Return  aRet


//--------------------------------------------------------
/*{Protheus.doc} LjRTemNode
Verifica se existe o nó no XML

@author  Varejo
@version P11.8
@since   02/02/2016
@return	 lRet - existe ? 
*/
//--------------------------------------------------------
Static Function LjRTemNode(oObjeto,cNode)
Local lRet := .F.

lRet := (XmlChildEx(oObjeto,cNode) <> NIL)

Return lRet
