#INCLUDE "MATR440.CH"
#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR440  � Autor � Alexandre Inacio Lemes� Data �02/06/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Lista os itens que atingiram o ponto de pedido.            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR440(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ�� 
���        ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.              ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Eduardo Fern�24.07.06�XXXXXX�Inclusao mv_par19 (Seleciona Filiais ?)   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function UMTR440

Local lSigaCusOk := .T.
Local oReport 
                     
ALERT("UMTR440")
//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//�������������������������������������������������������������������
If !(FindFunction("SIGACUS_V") .And. SIGACUS_V() >= 20060810)
	Aviso(STR0014,STR0015,{STR0018}) //"Atualizar patch do programa SIGACUS.PRW !!!"
    lSigaCusOk := .F.
EndIf
If !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20060321)
	Aviso(STR0014,STR0016,{STR0018}) //"Atualizar patch do programa SIGACUSA.PRX !!!"
    lSigaCusOk := .F.
EndIf
If !(FindFunction("SIGACUSB_V") .And. SIGACUSB_V() >= 20050512)
	Aviso(STR0014,STR0017,{STR0018}) //"Atualizar patch do programa SIGACUSB.PRX !!!"
    lSigaCusOk := .F.
EndIf

If lSigaCusOk 

	If FindFunction("TRepInUse") .And. TRepInUse()
		//������������������������������������������������������������������������Ŀ
		//�Interface de impressao                                                  �
		//��������������������������������������������������������������������������
		oReport:= ReportDef() 
        If Isblind()  
           oreport:nfontbody:=5 
        EndIf                 
		oReport:PrintDialog()
	Else
		MATR440R3()
	EndIf
	
EndIf
                                               
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Alexandre Inacio Lemes �Data  �02/06/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Lista os itens que atingiram o ponto de pedido.            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nExp01: nReg = Registro posicionado do SC3 apartir Browse  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport 
Local oSection1 
Local oCell         
Local oBreak
#IFDEF TOP
	Local cAliasSB1 := GetNextAlias()
#ELSE
	Local cAliasSB1 := "SB1"
#ENDIF

//��������������������������������������������������������������Ŀ
//� Ajusta o grupo de Perguntas                                  �
//����������������������������������������������������������������
AjustaSx1()

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Produto de                           �
//� mv_par02             // Produto ate                          �
//� mv_par03             // Grupo de                             �
//� mv_par04             // Grupo ate                            �
//� mv_par05             // Tipo de                              �
//� mv_par06             // Tipo ate                             �
//� mv_par07             // Local de                             �
//� mv_par08             // Local ate                            �
//� mv_par09             // Considera Necess Bruta   1 - Sim     � Pto Pedido
//� mv_par10             // Saldo Neg Considera      1 - Sim     � Lote Economico
//� mv_par11             // Considera C.Q.           1 - Sim     �
//� mv_par12             // Cons.Qtd. De 3os.? Sim / Nao         �
//� mv_par13             // Cons.Qtd. Em 3os.? Sim / Nao         �
//� mv_par14             // Qtd. PV nao Liberado ?" Subtr/Ignora �
//� mv_par15             // Descricao completa do produto?       �
//� mv_par16             // Considera Saldo Armazem de           �
//� mv_par17             // Considera Saldo Armazem ate          �
//� mv_par18             // Data limite p/ empenhos              �
//� mv_par19             // Seleciona Filiais ? (Sim/Nao)        �
//� mv_par20    		 // Considera Est. Seguranca ?  (Sim/Nao)�
//� mv_par21    		 // Considera Saldo Negativo ?  (Sim/Nao)�
//����������������������������������������������������������������
Pergunte("MTU440",.F.)
	
//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New("MTU440",STR0005,"MTU440",{|oReport| ReportPrint(oReport,cAliasSB1)},STR0001+" "+STR0002) //"Emite uma relacao com os itens em estoque que atingiram o Ponto de Pedido ,sugerindo a quantidade a comprar."
oReport:SetTotalInLine(.F.)
oReport:SetTotalText(STR0010) // "TOTAL GERAL A COMPRAR"
oReport:SetLandscape() 
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSection1:= TRSection():New(oReport,STR0030,{"SB1","SB2","SG1"},/*aOrdem*/) // "Produtos"
oSection1:SetHeaderPage()

TRCell():New(oSection1,"B1_COD"  ,"SB1",/*Titulo*/	,/*Picture*/						,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_DESC" ,"SB1",/*Titulo*/	,/*Picture*/						,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_TIPO" ,"SB1",STR0042	,/*Picture*/						,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_GRUPO","SB1",/*Titulo*/	,/*Picture*/						,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"B1_UM"   ,"SB1",STR0043,/*Picture*/						,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"SLDPRV"  ,"   ",STR0019	,PesqPictQt("B1_LE",12)				,TamSX3("B2_QATU")[1],/*lPixel*/,{|| nSaldo - nPrevis })
TRCell():New(oSection1,"PREVIS"  ,"   ",STR0020+CRLF+STR0037,PesqPict("SB2","B2_SALPEDI",12)	,TamSX3("B2_SALPEDI")[1],/*lPixel*/,{|| nPrevis },,,"RIGHT") //"Entrada "##"Prevista"
TRCell():New(oSection1,"B1_EMIN" ,"SB1",/*Titulo*/	,/*Picture*/						,/*Tamanho*/,/*lPixel*/,{|| RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)},,,"RIGHT")
TRCell():New(oSection1,"ESTSEG"  ,"   ",STR0021+CRLF+STR0031,PesqPictQt("B1_ESTSEG",12)			,TamSX3("B1_ESTSEG")[1],/*lPixel*/,{|| nESTSEG },,,"RIGHT") //"Estoque"##"de Seguranca"
TRCell():New(oSection1,"B1_LE"   ,"SB1",/*Titulo*/	,PesqPictQt("B1_LE",12)				,/*Tamanho*/,/*lPixel*/,{|| RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1)},,,"RIGHT")
TRCell():New(oSection1,"B1_TOLER","SB1",/*Titulo*/	,PesqPictQt("B1_LE",12)				,/*Tamanho*/,/*lPixel*/,{|| RetFldProd((cAliasSB1)->B1_COD,"B1_TOLER",cAliasSB1)},,,"RIGHT")
TRCell():New(oSection1,"TOLER"   ,"   ",STR0022	,PesqPictQt("B1_LE",12)				,/*Tamanho*/,/*lPixel*/,{|| 	nToler := (RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1) * RetFldProd((cAliasSB1)->B1_COD,"B1_TOLER",cAliasSB1))/100 })
TRCell():New(oSection1,"B1_QE"   ,"SB1",STR0040+CRLF+STR0041,PesqPictQt("B1_LE",12)				,/*Tamanho*/,/*lPixel*/,{|| RetFldProd((cAliasSB1)->B1_COD,"B1_QE",cAliasSB1)},,,"RIGHT") //"Qtde. por "##"Embalagem"
TRCell():New(oSection1,"QUANT"   ,"   ",STR0023+CRLF+STR0024,PesqPictQt("B1_LE",12)				,TamSX3("C1_QUANT")[1],/*lPixel*/,{|| nQuant },,,"RIGHT") //"Quantidade"##" a Comprar"
TRCell():New(oSection1,"VALOR"   ,"   ",STR0032+CRLF+STR0033,TM(0,16)							,TamSX3("B2_VATU1")[1],/*lPixel*/,{|| nQuant * IIf( RetFldProd((cAliasSB1)->B1_COD,"B1_UCOM",cAliasSB1) < (cAliasSB1)->B1_DATREF , RetFldProd((cAliasSB1)->B1_COD,"B1_CUSTD",cAliasSB1) ,RetFldProd((cAliasSB1)->B1_COD,"B1_UPRC",cAliasSB1)) },,,"RIGHT") //"Vlr.Estimado"##" da Compra"
TRCell():New(oSection1,"TIPOVAL" ,"   ",STR0025	,/*Picture*/						,4,/*lPixel*/,{|| cTipoVal := IIf( RetFldProd((cAliasSB1)->B1_COD,"B1_UCOM",cAliasSB1) < (cAliasSB1)->B1_DATREF , "STD" , "U.CO" ) })
TRCell():New(oSection1,"DATA"    ,"   ",STR0026+CRLF+STR0036,/*Picture*/						,TamSX3("C1_DATPRF")[1],/*lPixel*/,{|| dData := IIf( RetFldProd((cAliasSB1)->B1_COD,"B1_UCOM",cAliasSB1) < (cAliasSB1)->B1_DATREF,(cAliasSB1)->B1_DATREF, RetFldProd((cAliasSB1)->B1_COD,"B1_UCOM",cAliasSB1)) },,,"CENTER") //"Data de "##"Referencia"
TRCell():New(oSection1,"VALUNIT" ,"   ",STR0027+CRLF+STR0028,TM(0,14)							,TamSX3("B2_VATU1")[1],/*lPixel*/,{|| nValUnit := IIf( RetFldProd((cAliasSB1)->B1_COD,"B1_UCOM",cAliasSB1) < (cAliasSB1)->B1_DATREF , RetFldProd((cAliasSB1)->B1_COD,"B1_CUSTD",cAliasSB1) ,RetFldProd((cAliasSB1)->B1_COD,"B1_UPRC",cAliasSB1)) },,,"RIGHT") //"Vlr.Unitario"##" da Compra"
TRCell():New(oSection1,"PRAZO"   ,"   ",STR0034+CRLF+STR0044+CRLF+STR0045,/*Picture*/						,TamSX3("B1_PE")[1],/*lPixel*/,{|| nPrazo := CalcPrazo((cAliasSB1)->B1_COD,nQuant)},,,"RIGHT") // "Prazo Entrega"##" em Dias"

TRFunction():New(oSection1:Cell("VALOR"),NIL,"SUM",/*oBreak*/,,/*cPicture*/,/*uFormula*/,.F.,.T.) //"TOTAL GERAL A COMPRAR"
                       
Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Alexandre Inacio Lemes �Data  �05/06/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Lista os itens que atingiram o ponto de pedido.            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasSB1)

Local oSection1 := oReport:Section(1) 
Local cLocCQ    := GetMV("MV_CQ")
Local nNeces    := 0
Local nAuxQuant := 0
Local nSaldAux	:= 0
Local nX        := 0
Local lValidSB1 := .T.  
Local lQtdPrev  := SuperGetMV('MV_QTDPREV')

Local lMR440QTD := ExistBlock( "MR440QTD" )
Local lMT170SB1 := ExistBlock( "MT170SB1" )
Local lMT170Sld := ExistBlock( "MT170SLD" )

#IFDEF TOP
	Local lMT170QRY := ExistBlock( "MT170QRY" )
	Local cSelect 	:= ""
	Local cSelectPE := ""
#ELSE
	Local cCondicao := ""
#ENDIF  

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Tratamento da impressao por Filiais�
//����������������������������������������������������������������
Local aFilsCalc :={}
Local nForFilial:= 0
Local cFilBack  := cFilAnt

Private cTipoVal := ""
Private nQuant   := 0
Private nSaldo   := 0
Private nValUnit := 0
Private nValor   := 0
Private nPrazo   := 0
Private nToler   := 0
Private nEstSeg  := 0
Private nPrevis  := 0

// Funcao para a escolha de filiais
If !IsBlind() 
	aFilsCalc:= MatFilCalc( mv_par19 == 1 )
EndIf	

If !Empty( aFilsCalc ) .OR. IsBlind()

	If IsBlind()
		dbSelectArea("SM0")
		dbSeek(cEmpAnt)
		aFilsCalc := {{.T.,SM0->M0_CODFIL,SM0->M0_FILIAL,SM0->M0_CGC}}
	Endif

	For nForFilial := 1 to Len(aFilsCalc)
			
		If aFilsCalc[nForFilial,1]
			
			// Altera filial corrente
			cFilAnt := aFilsCalc[nForFilial,2]
		
			oReport:SetTitle( STR0005 + " - " + aFilsCalc[ nForFilial, 3 ] ) //Titulo do Relatorio
			
			oReport:EndPage() // Reinicia Paginas
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			//������������������������������������������������������������������������Ŀ
			//�Filtragem do relat�rio                                                  �
			//��������������������������������������������������������������������������
			#IFDEF TOP
				//��������������������������������������������������������������������Ŀ
				//�Transforma parametros Range em expressao SQL                        �	
				//����������������������������������������������������������������������
				MakeSqlExpr(oReport:uParam)

				cSelect := "SB1.* FROM " + RetSqlName("SB1")+" SB1 "
				cSelect += "WHERE SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
				cSelect += "SB1.B1_COD    >='" +mv_Par01+"' AND SB1.B1_COD <='"   +mv_Par02+"' AND "
				cSelect += "SB1.B1_GRUPO  >='" +mv_Par03+"' AND SB1.B1_GRUPO <='" +mv_Par04+"' AND "
				cSelect += "SB1.B1_TIPO   >='" +mv_Par05+"' AND SB1.B1_TIPO <='"  +mv_Par06+"' AND "
				cSelect += "SB1.B1_LOCPAD >='" +mv_Par07+"' AND SB1.B1_LOCPAD <='"+mv_Par08+"' AND " 
				cSelect += "SB1.B1_MSBLQL <>'1' AND "
				cSelect += "SB1.B1_CONTRAT <> 'S' AND SB1.B1_TIPO <> 'BN' AND "
				cSelect += "SB1.D_E_L_E_T_ = ' ' "
				//����������������������������������������������������������������������Ŀ
				//� MT170QRY - Ponto de Entrada p/ manipulacao da Query - filtro em SB1	 �
				//������������������������������������������������������������������������
				If lMT170QRY
					cSelectPE := Execblock('MT170QRY', .F., .F., {"SELECT "+cSelect})
					If ValType(cSelectPE)=='C' .And. AT("SELECT ",cSelectPE) > 0
						//�����������������������������������������������������������������������Ŀ
						//� Devido Embedded SQL, retira-se o SELECT da expressao da query         �
						//�������������������������������������������������������������������������
						cSelect := Substr(cSelectPE,AT("SELECT ",cSelectPE)+7,Len(cSelectPE)-7)
					EndIf
				Endif
				cSelect := "%"+cSelect+"%"

				//��������������������������������������������������������������������Ŀ
				//�Query do relat�rio da secao 1                                       �
				//����������������������������������������������������������������������
				oReport:Section(1):BeginQuery()	
			
				BeginSql Alias cAliasSB1
			
				    SELECT %Exp:cSelect%
			
					ORDER BY %Order:SB1% 
						
				EndSql 
				//������������������������������������������������������������������������Ŀ
				//�Metodo EndQuery ( Classe TRSection )                                    �
				//�                                                                        �
				//�Prepara o relat�rio para executar o Embedded SQL.                       �
				//�                                                                        �
				//�ExpA1 : Array com os parametros do tipo Range                           �
				//�                                                                        �
				//��������������������������������������������������������������������������
			
				oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
				
			#ELSE
			
				//������������������������������������������������������������������������Ŀ
				//�Transforma parametros Range em expressao Advpl                          �
				//��������������������������������������������������������������������������
				MakeAdvplExpr(oReport:uParam)
			
				cCondicao := 'B1_FILIAL  == "' + xFilial("SB1") + '".And.' 
				cCondicao += 'B1_COD     >= "' + mv_par01 + '".And. B1_COD    <="' + mv_par02 + '".And.'
				cCondicao += 'B1_GRUPO   >= "' + mv_par03 + '".And. B1_GRUPO  <="' + mv_par04 + '".And.'
				cCondicao += 'B1_TIPO    >= "' + mv_par05 + '".And. B1_TIPO   <="' + mv_par06 + '".And.'
				cCondicao += 'B1_LOCPAD  >= "' + mv_par07 + '".And. B1_LOCPAD <="' + mv_par08 + '".And.'
			   	cCondicao += 'B1_MSBLQL  <> "1" .And. '
				cCondicao += 'B1_CONTRAT <> "S" .And. B1_TIPO <> "BN"'
	
				oReport:Section(1):SetFilter(cCondicao,IndexKey())
			#ENDIF		
			
			oReport:SetMeter(SB1->(LastRec()))
			oSection1:Init()
			
			dbSelectArea(cAliasSB1)
			While !oReport:Cancel() .And. !(cAliasSB1)->(Eof())
	
				oReport:IncMeter()
				
				If oReport:Cancel()
					Exit
				EndIf

				If IsProdMod((cAliasSB1)->B1_COD)
					(cAliasSB1)->(dbSkip())
					Loop
				EndIf
			
				//�����������������������������������������������������������Ŀ
				//� MT170SB1 - Ponto de entrada para validar o produto        �
				//�������������������������������������������������������������
				If lMT170SB1
					lValidSB1 := ExecBlock("MT170SB1",.F.,.F.,{cAliasSB1})
					If ValType( lValidSB1 ) == "L" .And. !lValidSB1
						(cAliasSB1)->(dbSkip())
						Loop
					EndIf						
				EndIf

				//�������������������������������������������������Ŀ
				//� Calcula o saldo atual de todos os almoxarifados �
				//���������������������������������������������������
				dbSelectArea("SB2")
				dbSetOrder(1)
				dbSeek( xFilial("SB2") + (cAliasSB1)->B1_COD )
			
				While !Eof() .And. SB2->B2_FILIAL + SB2->B2_COD == xFilial("SB2") + (cAliasSB1)->B1_COD
			
			        If ( SB2->B2_LOCAL >= mv_par16 .And. SB2->B2_LOCAL <= mv_par17 ) .And. !( SB2->B2_LOCAL == cLocCQ .And. mv_par11 == 2 )
						nSaldo +=(SaldoSB2(Nil,Nil,If(Empty(mv_par18),dDataBase,mv_par18),mv_par12==1,mv_par13==1)+SB2->B2_SALPEDI+SB2->B2_QACLASS+IIF(lQtdPrev="S",B2_SALPPRE,0))
						If mv_par14 == 1
							nSaldo -= SB2->B2_QPEDVEN
						EndIf
						nPrevis += SB2->B2_SALPEDI
						//����������������������������������������������������������������������Ŀ
						//� MT170SLD - Ponto de Entrada p/ manipulacao do saldo do produto    	 �
						//������������������������������������������������������������������������
						If lMT170Sld
							nSaldAux := ExecBlock("MT170SLD",.F.,.F.,{nSaldo,SB2->B2_COD,SB2->B2_LOCAL})
							If ValType(nSaldAux) == 'N'
								nSaldo := nSaldAux
							EndIf
						Endif

			        EndIf
			        
					dbSelectArea("SB2")
					dbSkip()
				EndDo
			               
				nEstSeg := CalcEstSeg( RetFldProd((cAliasSB1)->B1_COD,"B1_ESTFOR",cAliasSB1),cAliasSB1 )

				If mv_par20 == 1
					nSaldo -= nEstSeg
				EndIf
			
				If (Round(nSaldo,4) <> 0) .Or. (mv_par09 == 1)
					Do Case
						Case ( RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1) != 0 .And. MV_PAR09 == 1 )
			
							If ( mv_par10 == 2 .And. nSaldo < 0 )
								nSaldo -= RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1)
							EndIf
				
							nNeces := If((nSaldo < 0),Abs(nSaldo)+RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1),;
									(If(QtdComp(nSaldo)==QtdComp(RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)),1,0);
									+RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)-nSaldo))
			          
						    //-- Soma 1 na quantidade da necessidade:
						    //-- Ex: Ponto Pedido = 10 e Estoque = 9, ao inves de gerar 2 SCs de 1 pc ira gera 1 SC de 2 pcs (para sair do ponto de pedido) 										
							If nSaldo <  QtdComp(RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)) //-- Se o Saldo for menor que o Ponto do Pedido
								nNeces += 1 
							EndIf
			
						Case ( RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1) != 0 .And. MV_PAR09 == 2 )
			
							If ( mv_par10 == 2 .And. nSaldo < 0 )
								nSaldo -= RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1)
							EndIf
			
							nNeces := If((nSaldo < 0),Abs(nSaldo),;
										(If(QtdComp(nSaldo) ==  QtdComp(RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)),1,0);
										+RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)-nSaldo))
			
						    //-- Soma 1 na quantidade da necessidade:
						    //-- Ex: Ponto Pedido = 10 e Estoque = 9, ao inves de gerar 2 SCs de 1 pc ira gera 1 SC de 2 pcs (para sair do ponto de pedido) 										 										
							If nSaldo <  QtdComp(RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)) //-- Se o Saldo for menor que o Ponto do Pedido
								nNeces += 1 
							EndIf           
						
						Case ( RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1) != 0 .And. (nSaldo < 0  .or. mv_par09 == 2) )
			
							If ( mv_par10 == 2 .And. nSaldo < 0 )
								nNeces := Abs(nSaldo)+RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1)
							Else
								nNeces := If( Abs(nSaldo)<RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1),RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1),if(nSaldo<0,Abs(nSaldo),0))
							EndIf

						OtherWise

							nNeces := IF(mv_par09 == 1,IIf(nSaldo<0,Abs(nSaldo)+1,0),0)
					EndCase
				Else
					If RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1) != 0
						nNeces := ( RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1) )
						nNeces += 1 
					Else
						nNeces := 0
					EndIf
				EndIf
			
				If nNeces > 0
					//�����������������������������������������������������������Ŀ
					//� Verifica se o produto tem estrutura                       �
					//�������������������������������������������������������������
					dbSelectArea("SG1")
					If dbSeek( xFilial("SG1")+(cAliasSB1)->B1_COD )
						aQtdes := CalcLote((cAliasSB1)->B1_COD,nNeces,"F")
					Else                  
						aQtdes := CalcLote((cAliasSB1)->B1_COD,nNeces,"C")
					Endif
					For nX := 1 to Len(aQtdes)
						nQuant += aQtdes[nX]
					Next
				EndIf
			 
				dbSelectArea(cAliasSB1)
				dbSetOrder(oSection1:GetIdxOrder())
			
				If lMR440QTD
					nAuxQuant := Execblock("MR440QTD",.f.,.f.,NQUANT)
					If ValType(nAuxQuant) == "N"
						nQuant := nAuxQuant
					EndIf
				EndIf
			
				If nQuant > 0
					oSection1:PrintLine()
				EndIf
			
				nSaldo := 0
				nQuant := 0
				nPrevis:= 0
				
				dbSelectArea(cAliasSB1)
				dbSkip()
			
			EndDo
			
		EndIf
			
	Next nForFilial
		
	oSection1:Finish()

EndIf

// Restaura filial original apos processamento
cFilAnt:=cFilBack 

Return NIL

/*                           
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � PLANO DE MELHORIA CONTINUA        �Programa   MATR440.PRX  ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data                            ���
�������������������������������������������������������������������������Ĵ��
���      01  �                          �                                 ���
���      02  � Ricardo Berti            � 25/09/2006 - Bops 00000107928   ���
���      03  �                          �                                 ���
���      04  �                          �                                 ���
���      05  � Ricardo Berti            � 25/09/2006 - Bops 00000107928   ���
���      06  �                          �                                 ���
���      07  �                          �                                 ���
���      08  � Alexandre Inacio Lemes   � 02/03/2006                      ���
���      09  � Alexandre Inacio Lemes   � 02/03/2006                      ���
���      10  � Alexandre Inacio Lemes   � 02/03/2006                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR440R3� Autor � Eveli Morasco         � Data � 16/04/93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Lista os itens que atingiram o ponto de pedido             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Marcelo P.S.�17/11/97�12601A� Incluir pergunta:para considerar C.Q.    ���
���Rogerio F.G.�02/12/97�13690A� Ajuste Utiliza. Cpo B1_QE,B1_LM          ���
���Marcelo P.  �13/02/98�xxxxxx� Ajuste no Campo B1_QE.                   ���
���Rodrigo     �19/02/98�11231A� Ajuste no Calculo da necessida qdo usa   ���
���            �        �      � Ponto de Pedido (B1_EMIN)                ���
���Eduardo     �21.05.98�16326A� Acerto para considerar Estoque de Seg.   ���
���Rodrigo Sart�11/09/98�6742A � Ajuste Utiliza. Cpo B1_QE,B1_LM          ���
���Rodrigo Sart�05/11/98�XXXXXX� Acerto p/ Bug Ano 2000                   ���
���Edson       �25.11.98�18720 � Correcao no calculo do saldo por almox.  ���
���Eduardo Fern�24.07.06�XXXXXX� Inclusao mv_par19 (Seleciona Filiais ?)  ���
�������������������������������������������������������������������������Ĵ��
���Mauro Vajman�27.07.06�      �Inclusao da Filial no cabecalho e quebra/ ���
���            �        �      �totalizacao por filial                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function MATR440R3
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local wnrel
Local Tamanho  := "G"
Local cDesc1   := STR0001	//"Emite uma relacao com os itens em estoque que atingiram o Ponto de"
Local cDesc2   := STR0002	//"Pedido ,sugerindo a quantidade a comprar."
Local cDesc3   := ""

Local aFilsCalc :={}

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private padrao de todos os relatorios         �
//����������������������������������������������������������������
Private nomeprog := "MATR440"
Private cString  := "SB1"
Private aReturn  := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
Private nLastKey := 0
Private cPerg    := "MTU440"
Private titulo   := OemToAnsi(STR0005)		//"Itens em Ponto de Pedido"
//��������������������������������������������������������������Ŀ
//� Contadores de linha e pagina                                 �
//����������������������������������������������������������������
Private li       := 80
Private m_pag    := 1

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//�������������������������������������������������������������������
If !(FindFunction("SIGACUS_V") .And. SIGACUS_V() >= 20060810)
	Aviso(STR0014,STR0015,{STR0018}) //"Atualizar patch do programa SIGACUS.PRW !!!"
	Return
EndIf
If !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20060321)
	Aviso(STR0014,STR0016,{STR0018}) //"Atualizar patch do programa SIGACUSA.PRX !!!"
	Return
EndIf
If !(FindFunction("SIGACUSB_V") .And. SIGACUSB_V() >= 20050512)
	Aviso(STR0014,STR0017,{STR0018}) //"Atualizar patch do programa SIGACUSB.PRX !!!"
	Return
EndIf

//��������������������������������������������������������������Ŀ
//� Ajusta o grupo de Perguntas                                  �
//����������������������������������������������������������������
AjustaSX1()

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Produto de                           �
//� mv_par02             // Produto ate                          �
//� mv_par03             // Grupo de                             �
//� mv_par04             // Grupo ate                            �
//� mv_par05             // Tipo de                              �
//� mv_par06             // Tipo ate                             �
//� mv_par07             // Local de                             �
//� mv_par08             // Local ate                            �
//� mv_par09             // Considera Necess Bruta   1 - Sim     � Pto Pedido
//� mv_par10             // Saldo Neg Considera      1 - Sim     � Lote Economico
//� mv_par11             // Considera C.Q.           1 - Sim     �
//� mv_par12             // Cons.Qtd. De 3os.? Sim / Nao         �
//� mv_par13             // Cons.Qtd. Em 3os.? Sim / Nao         �
//� mv_par14             // Qtd. PV nao Liberado ?" Subtr/Ignora �
//� mv_par15             // Descricao completa do produto?       �
//� mv_par16             // Considera Saldo Armazem de           �
//� mv_par17             // Considera Saldo Armazem ate          �
//� mv_par18             // Data limite p/ empenhos              �
//� mv_par19             // Seleciona Filiais ? (Sim/Nao)        �
//� mv_par20             // Lista saldo negativo ? (Sim/Nao)     �
//����������������������������������������������������������������
Pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString,,,,2) 

If nLastKey = 27
	dbClearFilter()
	Return
Endif

Processa( { |lEnd| R440Imp( @lEnd, tamanho, wnrel, cString, MatFilCalc( mv_par19 == 1 ) ) }, Titulo )

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R440IMP  � Autor � Cristina M. Ogura     � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR440			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R440Imp(lEnd,tamanho,wnrel,cString,aFilsCalc)

Local cLocCQ   := GetMV("MV_CQ")
Local cRodaTxt := STR0006	//"PRODUTO(S)"
Local cTipoVal := ""
Local cabec1   := ""
Local cabec2   := ""

Local nQuant   := 0
Local nSaldo   := 0
Local nValUnit := 0
Local nValor   := 0
Local nValTot  := 0
Local nPrazo   := 0
Local nToler   := 0
Local nEstSeg  := 0
Local nNeces   := 0
Local nCntImpr := 0
Local nTipo    := 0
Local nAuxQuant:= 0
Local nSaldAux := 0
Local nX       := 0
Local nPrevis  := 0
Local lValidSB1:=.T.
Local lQuery   :=.F.
Local lQtdPrev := SuperGetMV('MV_QTDPREV')

Local lMR440QTD:= ExistBlock( "MR440QTD" )  
Local lMT170SB1:= ExistBlock( "MT170SB1" )
Local lMT170Sld:= ExistBlock( "MT170SLD" )
Local bWhile   := {}

#IFDEF TOP
	Local aStru		:= {}
	Local cAliasSB1 := GetNextAlias()
	Local cQuery	:= ""
	Local cQueryPE	:= ""
	Local lMT170QRY := ExistBlock( "MT170QRY" )
#ELSE
	Local cAliasSB1 := "SB1"
#ENDIF

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Tratamento da impressao por Filiais�
//����������������������������������������������������������������
Local nForFilial := 0
Local cFilBack   := cFilAnt

//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//���������������������������������������������������������������������
nTipo  := IIf(aReturn[4]==1,15,18)

//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
If mv_par15 == 1
	cabec1 := STR0007		//"CODIGO          DESCRICAO                      TP GRP  UM  SALDO ATUAL     PONTO DE   ESTOQUE DE         LOTE ___TOLERANCIA___   QUANTIDADE QUANTIDADE A   VALOR ESTIMADO BASE  DATA DE   VALOR UNITARIO     PRAZO DE"
	cabec2 := STR0008		//"                                                                             PEDIDO    SEGURANCA    ECONOMICO   %   QUANTIDADE   POR EMBAL.      COMPRAR        DA COMPRA      REFERENCIA      DA COMPRA      ENTREGA"
	*****                   123456789012345 123456789012345678901234567890 12 1234 12 9.999.999,99 9.999.999,99 9.999.999,99 9.999.999,99 999 9.999.999,99 9.999.999,99 9.999.999,99 9.999.999.999,99 XXXX 99/99/9999 999.999.999,99 99999 Dia(s)
	*****                   0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21
	*****                   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
Else
	cabec1 := STR0012 //"CODIGO                                  TP GRP  UM  SALDO ATUAL       ENTRADA     PONTO DE   ESTOQUE DE         LOTE ___TOLERANCIA___   QUANTIDADE QUANTIDADE A   VALOR ESTIMADO BASE  DATA DE   VALOR UNITARIO     PRAZO DE"
	cabec2 := STR0013 //"DESCRICAO                                                            PREVISTA       PEDIDO    SEGURANCA    ECONOMICO   %   QUANTIDADE   POR EMBAL.      COMPRAR        DA COMPRA      REFERENCIA      DA COMPRA      ENTREGA"
EndIf

// Funcao para a escolha de filiais
If !IsBlind() 
	aFilsCalc:= MatFilCalc( mv_par19 == 1 )
EndIf

If !Empty(aFilsCalc).OR. IsBlind()

	If IsBlind()
		dbSelectArea("SM0")
		dbSeek(cEmpAnt)
		aFilsCalc := {{.T.,SM0->M0_CODFIL,SM0->M0_FILIAL,SM0->M0_CGC}}
	Endif
	
	dbSelectArea("SB1")
	aStru := SB1->(dbStruct())

	For nForFilial := 1 to Len(aFilsCalc)
		
		If aFilsCalc[nForFilial,1]
			
			// Altera filial corrente
			cFilAnt := aFilsCalc[nForFilial,2]
			
			li := 80 // Reinicia Paginas
			
			lQuery := .F.
			dbSelectArea("SB1")
			ProcRegua(RecCount())

			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
					lQuery := .T.
					cQuery := "SELECT SB1.*,SB1.R_E_C_N_O_ SB1RECNO FROM " + RetSqlName("SB1")+" SB1 "
					cQuery += "WHERE SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
					cQuery += "SB1.B1_COD >='"  +mv_Par01+"' AND SB1.B1_COD <='"  +mv_Par02+"' AND "
					cQuery += "SB1.B1_GRUPO>='" +mv_Par03+"' AND SB1.B1_GRUPO<='" +mv_Par04+"' AND "
					cQuery += "SB1.B1_TIPO>='"  +mv_Par05+"' AND SB1.B1_TIPO<='"  +mv_Par06+"' AND "
					cQuery += "SB1.B1_LOCPAD>='"+mv_Par07+"' AND SB1.B1_LOCPAD<='"+mv_Par08+"' AND "
					cQuery += "SB1.B1_MSBLQL <>'1' AND "
					cQuery += "SB1.B1_CONTRAT<>'S' AND SB1.B1_TIPO<>'BN' AND "
					cQuery += "SB1.D_E_L_E_T_ = ' ' "
					//����������������������������������������������������������������������Ŀ
					//� MT170QRY - Ponto de Entrada p/ manipulacao da Query - filtro em SB1	 �
					//������������������������������������������������������������������������
					If lMT170QRY
						cQueryPE := Execblock('MT170QRY', .F., .F., {cQuery})
						cQuery   := If(ValType(cQueryPE)=='C', cQueryPE, cQuery)
					Endif
					
					cQuery += " ORDER BY "+SqlOrder(SB1->(IndexKey()))
					
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasSB1)

					For nX := 1 To Len(aStru)
						If ( aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1])<>0 )
							TcSetField(cAliasSB1,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
						EndIf
					Next

					dbGoTop()
					bWhile := { || !(cAliasSB1)->(Eof()) }
				Else
					dbSeek( xFilial("SB1")+mv_Par01,.T. )
					bWhile := { ||  !SB1->(Eof()) .And. SB1->B1_FILIAL+SB1->B1_COD <= xFilial("SB1")+mv_par02 }
				EndIf
			#ELSE
				dbSeek( xFilial("SB1")+mv_Par01,.T. )
				bWhile := { ||  !SB1->(Eof()) .And. SB1->B1_FILIAL+SB1->B1_COD <= xFilial("SB1")+mv_par02 .And. SB1->B1_MSBLQL <>'1' }
			#ENDIF
	
			nValTot := 0
			
			While Eval(bWhile)

				If lEnd
					@PROW()+1,001 PSAY STR0009		//"CANCELADO PELO OPERADOR"
					Exit
				Endif
				
				IncProc( OemToAnsi(STR0029) + ": " + aFilsCalc[ nForFilial, 3 ] )

				If IsProdMod(B1_COD)
					//���������������������������������Ŀ
					//� Filtra produtos MOD				�
					//�����������������������������������
				   	dbSkip()
			   		Loop
				EndIf

				If !Empty(aReturn[7])
					If !&(aReturn[7])
						dbSkip()
						Loop
					Endif   
				EndIf
				If !lQuery
					//���������������������������������������������Ŀ
					//� Filtra grupos e tipos nao selecionados  	�
					//�����������������������������������������������
					If B1_GRUPO < mv_par03 .Or. B1_GRUPO > mv_par04 .Or.;
						B1_TIPO  < mv_par05 .Or. B1_TIPO  > mv_par06 .Or.;
						B1_TIPO == "BN" .Or. B1_CONTRAT == "S" 
					   	dbSkip()
				   		Loop
					EndIf
			
					//����������������������������������Ŀ
					//� Filtra armazem padrao do Produto �
					//������������������������������������
					If B1_LOCPAD < mv_par07 .Or. B1_LOCPAD > mv_par08
						dbSkip()
						Loop
					EndIf
				EndIf

				//�����������������������������������������������������������Ŀ
				//� MT170SB1 - Ponto de entrada para validar o produto        �
				//�������������������������������������������������������������
				If lMT170SB1
					lValidSB1 := ExecBlock("MT170SB1",.F.,.F.,{cAliasSB1})
					If ValType( lValidSB1 ) == "L" .And. !lValidSB1
						(cAliasSB1)->(dbSkip())
						Loop
					EndIf						
				EndIf
			
				//�����������������������������������������������������������Ŀ
				//� Direciona para funcao que calcula o necessidade de compra �
				//�������������������������������������������������������������
				//�������������������������������������������������Ŀ
				//� Calcula o saldo atual de todos os almoxarifados �
				//���������������������������������������������������
				dbSelectArea("SB2")
				dbSeek( xFilial("SB2") + (cAliasSB1)->B1_COD )
				While !Eof() .And. SB2->B2_FILIAL + SB2->B2_COD == xFilial("SB2") + (cAliasSB1)->B1_COD
					If B2_LOCAL < mv_par16 .OR. B2_LOCAL > mv_par17
						dbSkip()
						Loop
					EndIf
					//�������������������������������������������Ŀ
					//� inclui os produtos que estao no C.Q.      �
					//���������������������������������������������
					If B2_LOCAL == cLocCQ .And. mv_par11 == 2
						dbSkip()
						Loop
					EndIf
					nSaldo += (SaldoSB2(NIL,NIL,If(Empty(mv_par18),dDataBase,mv_par18),mv_par12==1,mv_par13==1)+B2_SALPEDI+B2_QACLASS+IIF(lQtdPrev="S",B2_SALPPRE,0))
					
					If mv_par14 == 1
						nSaldo -= B2_QPEDVEN
					EndIf
					
					nPrevis += B2_SALPEDI
					//����������������������������������������������������������������������Ŀ
					//� MT170SLD - Ponto de Entrada p/ manipulacao do saldo do produto    	 �
					//������������������������������������������������������������������������
					If lMT170Sld
						nSaldAux := ExecBlock("MT170SLD",.F.,.F.,{nSaldo,SB2->B2_COD,SB2->B2_LOCAL})
						If ValType(nSaldAux) == 'N'
							nSaldo := nSaldAux
						EndIf
					Endif
					dbSkip()
				EndDo

				nEstSeg := CalcEstSeg( RetFldProd((cAliasSB1)->B1_COD,"B1_ESTFOR",cAliasSB1),cAliasSB1 )
				If mv_par20 == 1
					nSaldo -= nEstSeg
				EndIf
				If (Round(nSaldo,4) # 0) .Or. (mv_par09 == 1)
					Do Case
						Case ( RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1) != 0 .And. MV_PAR09 == 1 )
							If ( mv_par10 == 2 .And. nSaldo < 0 )
								nSaldo -= RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1)
							EndIf
							
							nNeces := If((nSaldo < 0),Abs(nSaldo)+RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1),;
										(If(QtdComp(nSaldo)==QtdComp(RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)),1,0);
										+RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)-nSaldo))
							
							//-- Soma 1 na quantidade da necessidade:
							//-- Ex: Ponto Pedido = 10 e Estoque = 9, ao inves de gerar 2 SCs de 1 pc ira gera 1 SC de 2 pcs
							If nSaldo <  QtdComp(RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)) //-- Se o Saldo for menor que o Ponto do Pedido
								nNeces += 1
							EndIf
							
						Case ( RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1) != 0 .And. MV_PAR09 == 2 )
							If ( mv_par10 == 2 .And. nSaldo < 0 )
								nSaldo -= RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1)
							EndIf
							
							nNeces := If((nSaldo < 0),Abs(nSaldo),;
										(If(QtdComp(nSaldo) ==  QtdComp(RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)),1,0);
										+RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)-nSaldo))
							
							//-- Soma 1 na quantidade da necessidade:
							//-- Ex: Ponto Pedido = 10 e Estoque = 9, ao inves de gerar 2 SCs de 1 pc ira gera 1 SC de 2 pcs
							If nSaldo < QtdComp(RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1)) //-- Se o Saldo for menor que o Ponto do Pedido
								nNeces += 1
							EndIf
							
						Case ( RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1) != 0 .And. (nSaldo < 0  .or. mv_par09 == 2) )
							If ( mv_par10 == 2 .And. nSaldo < 0 )
								nNeces := Abs(nSaldo)+RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1)
							Else
								nNeces := If( Abs(nSaldo)<RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1),RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1),if(nSaldo<0,Abs(nSaldo),0))
							EndIf
						OtherWise
							nNeces := If(mv_par09 == 1,IIf(nSaldo<0,Abs(nSaldo)+1,0),0)
					EndCase
				Else
					If RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1) != 0
						nNeces := ( RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1) ) 
						nNeces += 1
					Else
						nNeces := 0
					Endif
				EndIf
   			    //������������������������������������������Ŀ
				//� Verifica de considera saldos negativos  �
				//�������������������������������������������
				If nSaldo < 0 .And. mv_par21 = 2 
				   DbSelectArea(cAliasSB1)
				   dbSkip()
				   Loop
				EndIf
				
				If nNeces > 0
					//�����������������������������������������������������������Ŀ
					//� Verifica se o produto tem estrutura                       �
					//�������������������������������������������������������������
					dbSelectArea("SG1")
					If dbSeek( xFilial("SG1")+(cAliasSB1)->B1_COD )
						aQtdes := CalcLote((cAliasSB1)->B1_COD,nNeces,"F")
					Else
						aQtdes := CalcLote((cAliasSB1)->B1_COD,nNeces,"C")
					Endif
					For nX := 1 to Len(aQtdes)
						nQuant += aQtdes[nX]
					Next
				EndIf
				
				dbSelectArea(cAliasSB1)
				
				If lMR440QTD
					nAuxQuant := Execblock("MR440QTD",.f.,.f.,NQUANT)
					If ValType(nAuxQuant) == "N"
						nQuant := nAuxQuant
					EndIf
				EndIf
				
				If nQuant > 0
					
					//���������������������������������������������Ŀ
					//� Pega o prazo de entrega do material         �
					//�����������������������������������������������
					nPrazo := CalcPrazo((cAliasSB1)->B1_COD,nQuant)
					dbSelectArea(cAliasSB1)
					
					//���������������������������������������������Ŀ
					//� Calcula a tolerancia do item                �
					//�����������������������������������������������
					nToler   := (RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1) * RetFldProd((cAliasSB1)->B1_COD,"B1_TOLER",cAliasSB1))/100
					
					If li > 55
						Cabec( titulo + " - " + aFilsCalc[ nForFilial, 3 ], cabec1, cabec2, nomeprog, Tamanho, nTipo )
					EndIf
					
					//�������������������������������������������������������Ŀ
					//� Adiciona 1 ao contador de registros impressos         �
					//���������������������������������������������������������
					nCntImpr++
					
					//���������������������������������������������������������Ŀ
					//� Verifica qual dos precos e' mais recente servir de base �
					//�����������������������������������������������������������
					If RetFldProd((cAliasSB1)->B1_COD,"B1_UCOM",cAliasSB1) < B1_DATREF
						cTipoVal := "STD"
						dData    := B1_DATREF
						nValUnit := RetFldProd((cAliasSB1)->B1_COD,"B1_CUSTD",cAliasSB1)
					Else
						cTipoVal := "U.CO"
						dData    := RetFldProd((cAliasSB1)->B1_COD,"B1_UCOM",cAliasSB1)
						nValUnit := RetFldProd((cAliasSB1)->B1_COD,"B1_UPRC",cAliasSB1)
					EndIf
					nValor := nQuant * nValUnit
					
					@ li,000 PSAY B1_COD
					If mv_par15 == 1
						@ li,016 PSAY SubStr(B1_DESC,1,20)
					Else
						li++
						@ li,000 PSAY SubStr(B1_DESC,1,30)
					EndIf
					@ li,040 PSAY B1_TIPO
					@ li,043 PSAY B1_GRUPO
					@ li,048 PSAY B1_UM
					@ li,051 PSAY nSaldo-nPrevis Picture PesqPictQt("B1_LE",12)
					@ li,065 PSAY nPrevis   Picture PesqPict("SB2","B2_SALPEDI",12)
					@ li,078 PSAY RetFldProd((cAliasSB1)->B1_COD,"B1_EMIN",cAliasSB1) Picture PesqPictQt("B1_EMIN",12)
					@ li,091 PSAY nESTSEG   Picture PesqPictQt("B1_ESTSEG",12)
					@ li,104 PSAY RetFldProd((cAliasSB1)->B1_COD,"B1_LE",cAliasSB1) Picture PesqPictQt("B1_LE",12)
					@ li,117 PSAY RetFldProd((cAliasSB1)->B1_COD,"B1_TOLER",cAliasSB1)  Picture "999"
					@ li,121 PSAY nToler    Picture PesqPictQt("B1_LE",12)
					@ li,134 PSAY RetFldProd((cAliasSB1)->B1_COD,"B1_QE",cAliasSB1) Picture PesqPictQt("B1_LE",12)
					@ li,147 PSAY nQuant    Picture PesqPictQt("B1_LE",12)
					@ li,160 PSAY nValor    Picture TM(nValor,16)
					@ li,177 PSAY cTipoVal
					@ li,182 PSAY dData
					@ li,193 PSAY nValUnit  Picture TM(nValUnit,14)
					@ li,208 PSAY nPrazo    Picture "99999"
					@ li,214 PSAY OemtoAnsi(STR0011)  //  "Dia(s)"
					
					nValTot += nValor
					li++
					
				EndIf
				
				nSaldo := 0
				nQuant := 0
				nPrevis:= 0
				
				dbSelectArea(cAliasSB1)
				dbSkip()
				
			EndDo
			
			If li != 80
				Li++
				@ li,000 PSAY STR0010+Replicate(".",131)		//"TOTAL GERAL A COMPRAR"
				@ li,153 PSAY nValTot Picture TM(nValTot,16)
				Roda(nCntImpr,cRodaTxt,Tamanho)
			EndIf

		EndIf
		//��������������������������������������������������������������Ŀ
		//� Devolve a condicao original do arquivo principal             �
		//����������������������������������������������������������������
		If lQuery
			If Select(cAliasSB1) > 0
				(cAliasSB1)->(dbCloseArea())
			Endif	
		EndIf		
	Next nForFilial
	
	dbSelectArea(cString)
	dbClearFilter()
	Set Order To 1

	If aReturn[5] = 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	EndIf

	MS_FLUSH()

EndIf

// Restaura filial original apos processamento
cFilAnt:=cFilBack 

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Nereu Humberto Jr     � Data �01.08.2005���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Cria as perguntas necesarias para o programa                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSX1()

Local aHelpPor :={ }
Local aHelpEng :={ }
Local aHelpSpa :={ }

PutSX1("MTU440","14","Qtd. PV nao Liberado ?","Ctd. PV no Liberado ?","Qt So Not Relesead ?","mv_che","N",01,0,1,"C","","","","","mv_par14","Subtrae","Resta","Subtract","","Ignora","Ignora","Ignore","","","","","","","","","")

Aadd( aHelpPor, "Informar se a quantidade do pedido de   " )
Aadd( aHelpPor, "venda n�o liberado dever� ser subtra�do " )
Aadd( aHelpPor, "ou ignorado.                            " )

Aadd( aHelpEng, "Enter if the quantity of the sales order" )
Aadd( aHelpEng, " not released must be substracted or    " )
Aadd( aHelpEng, "ignored.                                " )

Aadd( aHelpSpa, "Informar si la cantidad de pedido de    " )
Aadd( aHelpSpa, "venta no liberado debera ser substraido " )
Aadd( aHelpSpa, "o ignorado.                             " )

PutSX1Help("P.MTU44014.",aHelpPor,aHelpEng,aHelpSpa)

//-------------------------------------------------------------------------------------------------------------------------------//
aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }
Aadd( aHelpPor, "Informar se a impressao da descricao do " )
Aadd( aHelpPor, "produto sera reduzida ou completa.      " )

Aadd( aHelpEng, "Enter if the printout of the product des" )
Aadd( aHelpEng, "cription will be summarized or complete." )

Aadd( aHelpSpa, "Informar si la impresion de descripcion " )
Aadd( aHelpSpa, "del producto sera reducida o completa.  " )

PutSx1( "MTU440","15","Descricao completa produto ?","�Descripcion completa pdcto. ?","Full product description ?","mv_chf",;
	"N",1,0,1,"C","","","","","mv_par15","Nao","No","No","","Sim","Si","Yes","","","","","","","","","")
PutSX1Help("P.MTU44015.",aHelpPor,aHelpEng,aHelpSpa)

//-------------------------------------------------------------------------------------------------------------------------------//
aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

aAdd( aHelpPor, "Armazem inicial a ser considerado na    " )
aAdd( aHelpPor, "filtragem do Cadastro de Saldos (SB2).  " )

aAdd( aHelpEng, "To filter stock from initial            " )
aAdd( aHelpEng, "warehouse (SB2).                        " )

aAdd( aHelpSpa, "Filtrar Saldo Deposito inicial (SB2).   " )
aAdd( aHelpSpa, "                                        " )

PutSX1("MTU440","16","Considera Saldo Armazem de", "Consd. Deposito de","Cons. Warehouse from","mv_chg",;
	"C",2,0,1,"G","","","","","mv_par16","","","","","","","","","","","","","","","","")
PutSX1Help("P.MTU44016.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//
aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

aAdd( aHelpPor, "Armazem final a ser considerado na      " )
aAdd( aHelpPor, "filtragem do Cadastro de Saldos (SB2).  " )

aAdd( aHelpEng, "To filter stock from final              " )
aAdd( aHelpEng, "warehouse (SB2).                        " )

aAdd( aHelpSpa, "Filtrar Saldo Deposito final (SB2).     " )
aAdd( aHelpSpa, "                                        " )

PutSX1("MTU440","17","Considera Saldo Armazem ate","Consd. Deposito a", "Cons. Warehouse to","mv_chh",;
	"C",2,0,1,"G","","","","","mv_par17","","","","ZZ","","","","","","","","","","","","")
PutSX1Help("P.MTU44017.",aHelpPor,aHelpEng,aHelpSpa)
//-------------------------------------------------------------------------------------------------------------------------------//
aHelpPor :={ }
aHelpEng :={ }
aHelpSpa :={ }

Aadd( aHelpPor, "Informe a data limite para empenhos.    " )
Aadd( aHelpPor, "                                        " )

Aadd( aHelpEng, "Limit date for allocations.             " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "Fecha limite para reservas.             " )
Aadd( aHelpSpa, "                                        " )

PutSX1("MTU440","18","Data Limite para Empenho ? ","Fch.Limite p/ Res.Produccion", "Deadline to Allocat. ?","mv_chi",;
	"D",8,0,0,"G","","","","","mv_par18","","","","","","","","","","","","","","","","")
PutSX1Help("P.MTU44018.",aHelpPor,aHelpEng,aHelpSpa)   

PutSx1("MTU440", ;   	                            //-- 01 - X1_GRUPO
	'19' , ;                                        //-- 02 - X1_ORDEM
	'Seleciona Filiais ?', ;           				//-- 03 - X1_PERGUNT
	'�Selecciona Sucursales?', ;       				//-- 04 - X1_PERSPA
	'Select branch offices?', ;        				//-- 05 - X1_PERENG
	'mv_chj', ;                                     //-- 06 - X1_VARIAVL
	'N', ;                                          //-- 07 - X1_TIPO
	1, ;                                            //-- 08 - X1_TAMANHO
	0, ;                                            //-- 09 - X1_DECIMAL
	2, ;                                            //-- 10 - X1_PRESEL
	'C', ;                                          //-- 11 - X1_GSC
	'', ;                                           //-- 12 - X1_VALID
	'', ;                                           //-- 13 - X1_F3
	'', ;                                           //-- 14 - X1_GRPSXG
	'', ;                                           //-- 15 - X1_PYME
	'mv_par19', ;                                   //-- 16 - X1_VAR01
	'Sim' , ;                           			//-- 17 - X1_DEF01
	'Si', ; 	                           			//-- 18 - X1_DEFSPA1
	'Yes', ;                            			//-- 19 - X1_DEFENG1
	'', ;                                           //-- 20 - X1_CNT01
	'Nao', ;                            			//-- 21 - X1_DEF02
	'No', ;	                            			//-- 22 - X1_DEFSPA2
	'No', ; 	                           			//-- 23 - X1_DEFENG2
	'', ;                             				//-- 24 - X1_DEF03
	'', ;                             				//-- 25 - X1_DEFSPA3
	'', ;                             				//-- 26 - X1_DEFENG3
	'', ;                                           //-- 27 - X1_DEF04
	'', ;                                           //-- 28 - X1_DEFSPA4
	'', ;                                           //-- 29 - X1_DEFENG4
	'', ;                                           //-- 30 - X1_DEF05
	'', ;                                           //-- 31 - X1_DEFSPA5
	'', ;                                           //-- 32 - X1_DEFENG5
	{'Seleciona as filiais desejadas. Se NAO', ;	//-- 33 - HelpPor1#3
	 'apenas a filial corrente sera afetada.', ; 	//--      HelpPor2#3
	 '                                        '}, ;	//--      HelpPor3#3
	{'Selecciona las sucursales deseadas. Si', ; 	//-- 34 - HelpPor1#3
	 'NO solamente la sucursal actual es', ;  		//--      HelpPor2#3
	 'afectado.'}, ; 								//--      HelpPor3#3
	{'Select desired branch offices. If NO', ;  	//-- 35 - HelpPor1#3
	 'only current branch office will be', ; 	 	//--      HelpPor2#3
	 'affected.'}, ;								//--      HelpPor3#3
	 '')                                            //-- 36 - X1_HELP

PutSx1("MTU440", "20", "Considera Est. Seguranca ?", "�Considera stock de la segu. ?", "It considers Security Inv. ?", "mv_chk", "N", 1, 0, 1, "C","","","","","mv_par20", "Sim"    , "Si"       , "Yes"       , "", "Nao"       , "No"        , "No"        ,"","","","","","","","","",;
		{"Define se o Estoque de Seguran�a ","informado no Cadastro de Produtos, ","ser� considerado para o c�lculo ","das necessidades."}, ;
		{"It defines if the Security Inventory ","informed in I register in cadastre it ","of products, will be considered for ","the calculation of the necessities."}, ;
		{"Define si el Stock de la Seguridad me ","inform� adentro lo coloca en cadastre","de productos, es considerado para","el c�lculo de las necesidades."})

PutSx1("MTU440", "21", "Lista Saldo Negativos ?", "", "", "mv_chl", "N", 1, 0, 1, "C","","","","","mv_par21", "Sim"    , "Si"       , "Yes"       , "", "Nao"       , "No"        , "No"        ,"","","","","","","","","",;
		{"","","",""}, ;
		{"","","",""}, ;
		{"","","",""})

Return