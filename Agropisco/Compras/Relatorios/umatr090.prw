#INCLUDE "MATR090.CH"
#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR090  � Autor �Alexandre Inacio Lemes � Data �06/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da rela��o de Compras                              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR090(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function UMatr090()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//����������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                �
	//������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	MATR090R3()
EndIf                   

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef�Autor  �Alexandre Inacio Lemes �Data  �06/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da rela��o de Compras                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local aOrdem   := {STR0004,STR0005,STR0006,STR0007}//"Fornecedor"###"Data De Digitacao"###"Tipo+Grupo+Codigo"###" Grupo+Codigo"
Local aArea	   := Getarea() 
Local aSB1Cod  := TamSX3("B1_COD")
Local aSB1Ite  := TAMSX3("B1_CODITE")
Local lVeiculo := Upper(GetMV("MV_VEICULO")) == "S"
Local nTamCli  := Max(TAMSX3("A1_NOME")[1],TAMSX3("A2_NOME")[1])-15
Local cTitle   := STR0001 //"Relacao de Compras"
Local cPictImp := X3Picture("D1_TOTAL")
Local nTamSX1  := Len(SX1->X1_GRUPO)
Local oReport 
Local oSection1
Local oSection2
#IFDEF TOP
	Local cAliasSD1 := GetNextAlias()
#ELSE
	Local cAliasSD1 := "SD1"
#ENDIF

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Produto de                           �
//� mv_par02             // Produto Ate                          �
//� mv_par03             // Data digitacao de                    �
//� mv_par04             // Data digitacao Ate                   �
//� mv_par05             // Fornecedor de                        �
//� mv_par06             // Fornecedor Ate                       �
//� mv_par07             // Imprime Devolucao Compra ?           �
//� mv_par08             // Filtra Dt Devolucao ?                �
//� mv_par09             // Moeda                                �
//� mv_par10             // Outras moedas                        �
//� mv_par11             // Somente NFE com TES                  �
//� mv_par12             // Imprime Devolucao Venda  ?           �
//����������������������������������������������������������������
AjustaSX1()

//��������������������������������������������������������������Ŀ
//� Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                �
//����������������������������������������������������������������
dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(PADR("MTR090",nTamSX1))
Do While !SX1->(Eof()) .And. SX1->X1_GRUPO == PADR("MTR090",nTamSX1)
	If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. ;
		(SX1->X1_TAMANHO <> IIf( lVeiculo , aSB1Ite[1] , aSB1Cod[1] ) .Or. Upper(SX1->X1_F3) <> IIf( lVeiculo , "VR4" , "SB1" ) )
		RecLock("SX1",.F.)
		SX1->X1_TAMANHO := IIf( lVeiculo , aSB1Ite[1] , aSB1Cod[1] )
		SX1->X1_F3      := IIf( lVeiculo , "VR4" , "SB1" )
		dbCommit()
		MsUnlock()		
	EndIf
	DbSkip()
EndDo

DbCommitall()
RestArea(aArea)

Pergunte("MTR090",.F.)
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
oReport:= TReport():New("MTR090",cTitle,"MTR090", {|oReport| ReportPrint(oReport,aOrdem,cAliasSD1)},STR0002+" "+STR0003) //"Este relatorio ira imprimir a relacao de itens referentes a compras efetuadas."
oReport:SetTotalInLine(.F.)
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
oSection1:= TRSection():New(oReport,STR0029,{"SD1","SF1","SD2","SF2","SB1","SA1","SA2","SF4"},aOrdem)
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderPage()    
oSection1:SetLineStyle(.F.)
//oSection1:SetReadOnly()
                                              
oSection1:SetNoFilter("SA1")
oSection1:SetNoFilter("SA2")
oSection1:SetNoFilter("SF1")
oSection1:SetNoFilter("SF2")
oSection1:SetNoFilter("SD2")
oSection1:SetNoFilter("SF4")
oSection1:SetNoFilter("SD2")
oSection1:SetNoFilter("SB1")

TRCell():New(oSection1,"D1_DOC"    ,"SD1",/*Titulo*/	,/*Picture*/, TamSX3("D1_DOC")[1]+5,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_COD"    ,"SD1",/*Titulo*/	,/*Picture*/,TamSX3("D1_COD")[1]+15,/*lPixel*/,/*{|| code-block de impressao }*/,/**/,/**/, /**/, /**/, /**/,.F.)

If lVeiculo
   TRCell():New(oSection1,"D1_CODITE" ,"SD1",RetTitle("B1_CODITE"),/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
EndIf

TRCell():New(oSection1,"COD"       ,"SD1",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| cCod })  // C�lula para controle do c�digo do produto, n�o ser� impressa
oSection1:Cell("COD"):Disable()

TRCell():New(oSection1,"B1_DESC"   ,"SB1",/*Titulo*/	,/*Picture*/,15,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_QUANT"  ,"SD1",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_UM"     ,"SD1",STR0031		,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"VALUNIT"   ,"   ",STR0023		,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| nValUnit })

If cPaisloc=="BRA"
	If lVeiculo
		TRCell():New(oSection1,"D1_IPI","SD1",STR0039,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	Else
		TRCell():New(oSection1,"D1_IPI","SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	EndIf
Else
	TRCell():New(oSection1,"IMPNOINC","   ",STR0024,cPictImp,/*Tamanho*/,/*lPixel*/,{|| nImpNoInc })
EndIf

TRCell():New(oSection1,"VALTOTAL"  ,"   ",STR0026,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| nValTot  })

If cPaisloc=="BRA"
	If lVeiculo
		TRCell():New(oSection1,"D1_PICM","SD1",STR0040,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	Else
		TRCell():New(oSection1,"D1_PICM","SD1",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	EndIf
Else
	TRCell():New(oSection1,"IMPINC","   ",STR0025,cPictImp,/*Tamanho*/,/*lPixel*/,{|| nImpInc })
EndIf

TRCell():New(oSection1,"D1_FORNECE","SD1",STR0032		,/*Picture*/,TamSX3("D1_FORNECE")[1]+10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"RAZAOSOC"  ,"   ",STR0027		,/*Picture*/,nTamCli-10	,/*lPixel*/,{|| cRazao })
TRCell():New(oSection1,"D1_TIPO"   ,"SD1",STR0033		,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_TES"    ,"SD1",STR0034		,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_TP"     ,"SD1",STR0035		,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_GRUPO"  ,"SD1",/*Titulo*/	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_DTDIGIT","SD1",STR0036		,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"VALCUSTO"  ,"   ",STR0028		,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| nValCusto })
TRCell():New(oSection1,"D1_LOCAL"  ,"SD1",STR0037		,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection1:Cell("VALUNIT"):GetFieldInfo("D1_VUNIT")
oSection1:Cell("VALTOTAL"):GetFieldInfo("D1_TOTAL")
oSection1:Cell("VALCUSTO"):GetFieldInfo("D1_CUSTO")

oSection2:= TRSection():New(oSection1,STR0030,{"SD2","SF2","SD1","SF1","SB1","SA1","SA2","SF4"}) 
oSection2:SetHeaderPage()
oSection2:SetTotalInLine(.F.)   
oSection2:SetLineStyle()
//oSection2:SetReadOnly()

oSection2:SetNoFilter("SA1")
oSection2:SetNoFilter("SA2")
oSection2:SetNoFilter("SF1")
oSection2:SetNoFilter("SF2")
oSection2:SetNoFilter("SD2")
oSection2:SetNoFilter("SF4")
oSection2:SetNoFilter("SD1")
oSection2:SetNoFilter("SB1")

TRCell():New(oSection2,"D2_DOC"    ,"SD2",/*Titulo*/,/*Picture*/,6			 ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D2_COD"    ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"B1_DESC"   ,"SB1",/*Titulo*/,/*Picture*/,15/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D2_QUANT"  ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| SD2->D2_QUANT * -1 })
TRCell():New(oSection2,"D2_UM"     ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"PRCVEN"    ,"   ",STR0023	 ,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| nValUnit })

If cPaisloc=="BRA"
	TRCell():New(oSection2,"D2_IPI","SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
Else
	TRCell():New(oSection2,"IMPNOINC","   ",STR0024,cPictImp,/*Tamanho*/,/*lPixel*/,{|| nImpNoInc })
EndIf

TRCell():New(oSection2,"VALTOTAL"  ,"   ",STR0026,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| nValTot * -1 })

If cPaisloc=="BRA"
	TRCell():New(oSection2,"D2_PICM","SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
Else
	TRCell():New(oSection2,"IMPINC","   ",STR0025,cPictImp,/*Tamanho*/,/*lPixel*/,{|| nImpInc })
EndIf

TRCell():New(oSection2,"D2_CLIENTE","SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"RAZAOSOC"  ,"   ",STR0027	 ,/*Picture*/,nTamCli-10 ,/*lPixel*/,{|| cRazao })
TRCell():New(oSection2,"D2_TIPO"   ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D2_TES"    ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D2_TP"     ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D2_GRUPO"  ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"D2_EMISSAO","SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection2,"VALCUSTO"  ,"   ",STR0028	 ,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| nValCusto * -1 })
TRCell():New(oSection2,"D2_LOCAL"  ,"SD2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oSection2:Cell("PRCVEN"  	):GetFieldInfo("D2_PRCVEN"	)	 
oSection2:Cell("VALTOTAL"	):GetFieldInfo("D2_TOTAL"	)
oSection2:Cell("VALCUSTO"	):GetFieldInfo("D2_CUSTO"	)
oSection2:Cell("D2_DOC"		):GetFieldInfo("D1_DOC"		)
oSection2:Cell("D2_CLIENTE"	):GetFieldInfo("D1_FORNECE"	)
oSection2:Cell("D2_TIPO"	):GetFieldInfo("D1_TIPO"	)
oSection2:Cell("D2_TES"		):GetFieldInfo("D1_TES"		)
oSection2:Cell("D2_TP"		):GetFieldInfo("D1_TP"		)
oSection2:Cell("D2_GRUPO"	):GetFieldInfo("D1_GRUPO"	)
oSection2:Cell("D2_EMISSAO"	):GetFieldInfo("D1_DTDIGIT"	)

oSection2:Cell("D2_DOC"		):HideHeader()
oSection2:Cell("D2_COD"		):HideHeader()
oSection2:Cell("B1_DESC"	):HideHeader()
oSection2:Cell("D2_QUANT"	):HideHeader()
oSection2:Cell("D2_UM"		):HideHeader()
oSection2:Cell("PRCVEN"		):HideHeader()
If cPaisloc=="BRA"
	oSection2:Cell("D2_IPI"	):HideHeader()
Else
	oSection2:Cell("IMPNOINC"):HideHeader()
EndIf
oSection2:Cell("VALTOTAL"):HideHeader()
If cPaisloc=="BRA"
	oSection2:Cell("D2_PICM"):HideHeader()
Else
	oSection2:Cell("IMPINC"	):HideHeader()
EndIf
oSection2:Cell("D2_CLIENTE"	):HideHeader()
oSection2:Cell("RAZAOSOC"	):HideHeader()
oSection2:Cell("D2_TIPO"	):HideHeader()
oSection2:Cell("D2_TES"		):HideHeader()
oSection2:Cell("D2_TP"		):HideHeader()
oSection2:Cell("D2_GRUPO"	):HideHeader()
oSection2:Cell("D2_EMISSAO"	):HideHeader()
oSection2:Cell("VALCUSTO"	):HideHeader()
oSection2:Cell("D2_LOCAL"	):HideHeader()

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Alexandre Inacio Lemes �Data  �06/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da rela��o de Compras                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasSD1)

Local oSection1  := oReport:Section(1) 
Local oSection2  := oReport:Section(1):Section(1)   
Local nOrdem     := oReport:Section(1):GetOrder()
Local aImpostos  := {}
Local aRecno     := {}
Local cCampImp   := ""
Local cTipo1	 := ""
Local cTipo2	 := ""
Local cFilUsrSD1 := ""
Local cCondSD2   := ""
Local cArqTrbSD2 := ""
Local nNewIndSD2 := 0
Local nImpos     := 0
Local nY         := 0
Local nDecs      := Msdecimais(mv_par09) //casas decimais utilizadas na moeda da impressao
Local oBreak
Local oBreak1    
Local oBreak2    
Local oBreak3    
Local lQuery     := .F.
Local lMoeda     := .T.

#IFDEF TOP
	Local cSelect   := ""
	Local cSelect1  := ""
    Local cOrder    := ""
	Local cWhereSB1 := ""
	Local cWhereSF1 := ""
	Local cWhereSF4 := "%%"
    Local cFrom     := "%%"
	Local cAliasSF4 := cAliasSD1
	Local aStrucSD1 := SD1->(dbStruct())      
	Local cName		:= ""
	Local nX        := 0
#ELSE
	Local cCondicao := ""
    Local cIndexKey := ""
	Local cAliasSF4 := "SF4"
#ENDIF 

PRIVATE cRazao   := ""
PRIVATE lVeiculo := Upper(GetMV("MV_VEICULO")) == "S"
PRIVATE nValUnit := 0
PRIVATE nValTot  := 0
PRIVATE nValCusto:= 0 
PRIVATE	nImpInc  :=	0
PRIVATE	nImpNoInc:=	0
PRIVATE cCod	 := ""

//������������������������������������������������������������Ŀ
//� Adiciona a ordem escolhida ao titulo do relatorio          �
//��������������������������������������������������������������
oReport:SetTitle(oReport:Title() + " ("+AllTrim(aOrdem[nOrdem])+") ")

dbSelectArea("SD1")
//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
#IFDEF TOP

 	MakeSqlExpr(oReport:uParam)
    
 	oReport:Section(1):BeginQuery()	

    lQuery := .T.

	cSelect := "%" 
    	
	DbSelectArea("SX3")
	DbSetOrder(2)
	DbSeek("D1_VALIMP")
	While !Eof() .And. X3_ARQUIVO == "SD1" .And. X3_CAMPO = "D1_VALIMP"
		cSelect += ", " + X3_CAMPO 
		DbSkip()
	EndDo
	
	If lVeiculo
		cSelect   += ",B1_CODITE "	
	    cWhereSB1 := "%"
		cWhereSB1 += " B1_CODITE >= '" + MV_PAR01 + "'"
		cWhereSB1 += " AND B1_CODITE <= '" + MV_PAR02 + "'"
	    cWhereSB1 += "%"
    Else
	    cWhereSB1 := "%"
		cWhereSB1 += " D1_COD >= '" + MV_PAR01 + "'"
		cWhereSB1 += " AND D1_COD <= '" + MV_PAR02 + "'"
	    cWhereSB1 += "%"
 	Endif

    //�������������������������������������������������������������������Ŀ
    //�Esta rotina foi escrita para adicionar no select os campos         �
    //�usados no filtro do usuario quando houver, a rotina acrecenta      �
    //�somente os campos que forem adicionados ao filtro testando         �
    //�se os mesmo j� existem no select ou se forem definidos novamente   �
    //�pelo o usuario no filtro, esta rotina acrecenta o minimo possivel  �
    //�de campos no select pois pelo fato da tabela SD1 ter muitos campos |
    //�e a query ter UNION, ao adicionar todos os campos do SD1 podera'   |
    //�derrubar o TOP CONNECT e abortar o sistema.                        |
    //���������������������������������������������������������������������	   	
	cSelect1 := "D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_DTDIGIT, D1_COD,   D1_QUANT, D1_VUNIT,"
	cSelect1 += "D1_TOTAL,  D1_TES, D1_IPI,   D1_PICM,    D1_TIPO, D1_TP,      D1_GRUPO, D1_CUSTO, D1_LOCAL, D1_QTDEDEV, D1_ITEM, D1_UM," 
   	cFilUsrSD1:= oSection1:GetAdvplExp()
    If !Empty(cFilUsrSD1)
		For nX := 1 To SD1->(FCount())
			cName := SD1->(FieldName(nX))
		 	If AllTrim( cName ) $ cFilUsrSD1
	      		If aStrucSD1[nX,2] <> "M"  
	      			If !cName $ cSelect .And. !cName $ cSelect1
		        		cSelect += ","+cName 
		          	Endif 	
		       	EndIf
			EndIf 			       	
		Next
    Endif    
	
	If mv_par11 == 1
		cSelect += ", F4_AGREG "	
	    cFrom := "%"
	    cFrom += "," + RetSqlName("SF4") + " SF4 "
	    cFrom += "%" 	    

	    cWhereSF4 := "%"
		cWhereSF4 += " SF4.F4_FILIAL ='" + xFilial("SF4") + "'"
		cWhereSF4 += " AND SF4.F4_CODIGO = SD1.D1_TES"
		cWhereSF4 += " AND SF4.D_E_L_E_T_ <> '*' AND "
        cWhereSF4 += "%"
    EndIf

	If (mv_par12 == 1)
		cTipo1 := "D','B"
		cTipo2 := cTipo1
	Else
		cTipo1 := "B"
		cTipo2 := "D','B"
	EndIf
	
    cSelect += "%"

	cWhereSF1 := "%"
	cWhereSF1 += "NOT ("+IsRemito(3,'SF1.F1_TIPODOC')+ ") AND "
	cWhereSF1 += "%"

	If nOrdem == 1
		cOrder := "% D1_FILIAL, D1_FORNECE, D1_LOJA,    D1_DOC,   D1_SERIE,  D1_ITEM %"
	ElseIf nOrdem == 2
		cOrder := "% D1_FILIAL, D1_DTDIGIT, D1_FORNECE, D1_LOJA,   D1_DOC,   D1_SERIE, D1_ITEM %"
	ElseIf nOrdem == 3 .And. lVeiculo
		cOrder := "% D1_FILIAL, D1_TP,	    D1_GRUPO,   B1_CODITE, D1_DTDIGIT %"
	ElseIf nOrdem == 3 .And. !lVeiculo
		cOrder := "% D1_FILIAL, D1_TP,		D1_GRUPO,   D1_COD,    D1_DTDIGIT %"
	ElseIf nOrdem == 4 .And. lVeiculo
		cOrder := "% D1_FILIAL, D1_GRUPO,   D1_CODITE,  D1_DTDIGIT %"
	ElseIf nOrdem == 4 .And. !lVeiculo
		cOrder := "% D1_FILIAL, D1_GRUPO,   D1_COD,     D1_DTDIGIT %"
	EndIf

	BeginSql Alias cAliasSD1
			
	SELECT D1_FILIAL,D1_DOC,     D1_SERIE,   D1_FORNECE, D1_LOJA, D1_DTDIGIT,    D1_COD,   D1_QUANT, D1_VUNIT,
		   D1_TOTAL, D1_TES,     D1_IPI,     D1_PICM,    D1_TIPO, D1_TP,         D1_GRUPO, D1_CUSTO, D1_LOCAL, D1_QTDEDEV, D1_ITEM,D1_UM,
	       F1_MOEDA, F1_TXMOEDA, F1_DTDIGIT, B1_DESC,    B1_UM,   A1_NOME RAZAO, A1_NREDUZ RAZAORED, SD1.R_E_C_N_O_ SD1RECNO,
	       B1_CODITE D1_CODITE,  'C' TIPO
	       %Exp:cSelect%

	FROM %table:SF1% SF1 , %table:SD1% SD1 , %table:SB1% SB1 , %table:SA1% SA1 %Exp:cFrom%

   	WHERE SF1.F1_FILIAL   = %xFilial:SF1%   AND 
	      %Exp:cWhereSF1%
	      SF1.%NotDel%                      AND
          SD1.D1_FILIAL   =  %xFilial:SD1%  AND
          SD1.D1_DOC      =  SF1.F1_DOC     AND
          SD1.D1_SERIE    =  SF1.F1_SERIE   AND  
          SD1.D1_FORNECE  =  SF1.F1_FORNECE AND
          SD1.D1_LOJA     =  SF1.F1_LOJA    AND  
	      SD1.D1_TIPO  IN (%Exp:cTipo1%)    AND 
	      SD1.%NotDel%                      AND
          SB1.B1_FILIAL   =  %xFilial:SB1%  AND
          SB1.B1_COD      =  SD1.D1_COD     AND
	      SB1.%NotDel%                      AND
          SA1.A1_FILIAL   =  %xFilial:SA1%  AND
          SA1.A1_COD      =  SD1.D1_FORNECE AND
          SA1.A1_LOJA     =  SD1.D1_LOJA    AND
	      SA1.%NotDel%                      AND
	      %Exp:cWhereSF4%
 	      SD1.D1_DTDIGIT >= %Exp:Dtos(mv_par03)% AND 
	      SD1.D1_DTDIGIT <= %Exp:Dtos(mv_par04)% AND 
		  SD1.D1_FORNECE >= %Exp:mv_par05% AND 
	      SD1.D1_FORNECE <= %Exp:mv_par06% AND      
	      %Exp:cWhereSB1%

	UNION

	SELECT D1_FILIAL, D1_DOC,     D1_SERIE,   D1_FORNECE, D1_LOJA, D1_DTDIGIT,    D1_COD,   D1_QUANT, D1_VUNIT,
		   D1_TOTAL,  D1_TES,     D1_IPI,     D1_PICM,    D1_TIPO, D1_TP,         D1_GRUPO, D1_CUSTO, D1_LOCAL, D1_QTDEDEV, D1_ITEM,D1_UM,
	       F1_MOEDA,  F1_TXMOEDA, F1_DTDIGIT, B1_DESC,    B1_UM,   A2_NOME RAZAO, A2_NREDUZ RAZAORED, SD1.R_E_C_N_O_ SD1RECNO,
   	       B1_CODITE  D1_CODITE,  'F' TIPO
	       %Exp:cSelect%

	FROM %table:SF1% SF1 , %table:SD1% SD1 , %table:SB1% SB1 , %table:SA2% SA2 %Exp:cFrom%

   	WHERE SF1.F1_FILIAL   = %xFilial:SF1%   AND 
	      %Exp:cWhereSF1%
	      SF1.%NotDel%                      AND
          SD1.D1_FILIAL   =  %xFilial:SD1%  AND
          SD1.D1_DOC      =  SF1.F1_DOC     AND
          SD1.D1_SERIE    =  SF1.F1_SERIE   AND  
          SD1.D1_FORNECE  =  SF1.F1_FORNECE AND
          SD1.D1_LOJA     =  SF1.F1_LOJA    AND  
	      SD1.D1_TIPO NOT IN (%Exp:cTipo2%)  AND 
	      SD1.%NotDel%                      AND
          SB1.B1_FILIAL   =  %xFilial:SB1%  AND
          SB1.B1_COD      =  SD1.D1_COD     AND
	      SB1.%NotDel%                      AND
          SA2.A2_FILIAL   =  %xFilial:SA2%  AND
          SA2.A2_COD      =  SD1.D1_FORNECE AND
          SA2.A2_LOJA     =  SD1.D1_LOJA    AND
	      SA2.%NotDel%                      AND
	      %Exp:cWhereSF4%
 	      SD1.D1_DTDIGIT >= %Exp:Dtos(mv_par03)% AND 
	      SD1.D1_DTDIGIT <= %Exp:Dtos(mv_par04)% AND 
		  SD1.D1_FORNECE >= %Exp:mv_par05% AND 
	      SD1.D1_FORNECE <= %Exp:mv_par06% AND      
	      %Exp:cWhereSB1%

	ORDER BY %Exp:cOrder%
					
	EndSql 

    oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

#ELSE
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao Advpl                          �
	//��������������������������������������������������������������������������
	MakeAdvplExpr(oReport:uParam)

	cCondicao := 'D1_FILIAL == "'       + xFilial("SD1") + '".And.'

    If lVeiculo   
		cCondicao += 'D1_CODITE >= "'   + mv_par01       + '".And.D1_CODITE <="'       + mv_par02       + '".And.'
    Else
		cCondicao += 'D1_COD >= "'      + mv_par01       + '".And.D1_COD <="'          + mv_par02       + '".And.'
    EndIf

	//��������������������������������������������������������������Ŀ
	//� Despreza Nota Fiscal sem TES de acordo com parametro         �
	//����������������������������������������������������������������
	If mv_par11 == 1 
	   cCondicao += '!Empty(D1_TES) .And. '
	Endif
	
	//�������������������������Ŀ
	//� Imprime Dev. Vendas ? 	�
	//���������������������������
	If mv_par12 == 2 
	   cCondicao += '!(D1_TIPO $ "D") .And. '
	EndIf

	cCondicao += 'Dtos(D1_DTDIGIT) >= "'+ Dtos(mv_par03) + '".And.Dtos(D1_DTDIGIT) <="'+ Dtos(mv_par04) + '".And.'
	cCondicao += 'D1_FORNECE >= "'      + mv_par05       + '".And.D1_FORNECE <="'      + mv_par06       + '".And. '
	cCondicao += '!('+IsRemito(2,"SD1->D1_TIPODOC")+')'

	If nOrdem == 1
		cIndexKey := "D1_FILIAL+D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE+D1_ITEM"
	ElseIf nOrdem == 2
		cIndexKey := "D1_FILIAL+Dtos(D1_DTDIGIT)+D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE+D1_ITEM"
	ElseIf nOrdem == 3 .And. lVeiculo
		cIndexKey := "D1_FILIAL+D1_TP+D1_GRUPO+D1_CODITE+Dtos(D1_DTDIGIT)"
	ElseIf nOrdem == 3 .And. !lVeiculo
		cIndexKey := "D1_FILIAL+D1_TP+D1_GRUPO+D1_COD+Dtos(D1_DTDIGIT)"
	ElseIf nOrdem == 4 .And. lVeiculo
		cIndexKey := "D1_FILIAL+D1_GRUPO+D1_CODITE+Dtos(D1_DTDIGIT)"
	ElseIf nOrdem == 4 .And. !lVeiculo
		cIndexKey := "D1_FILIAL+D1_GRUPO+D1_COD+Dtos(D1_DTDIGIT)"
	EndIf

	oReport:Section(1):SetFilter(cCondicao,cIndexKey)

	TRPosition():New(oSection1,"SB1",1,{|| xFilial("SB1")+(cAliasSD1)->D1_COD })

#ENDIF
	
//��������������������������������������������������������������Ŀ
//� Monta IndRegua caso liste NFs de devolucao                   �
//����������������������������������������������������������������
If mv_par07 == 1
	cArqTrbSD2:= CriaTrab("",.F.)
	//�����������������������������������������������������������Ŀ
	//� Verifica data caso FILTRE NFs de devolucao fora do periodo�
	//�������������������������������������������������������������
	If mv_par08 == 1
		cCondSD2	:=	( "D2_FILIAL == '" + xFilial("SD2") + "'" )
		cCondSD2	+=	( " .And. DTOS(D2_EMISSAO)>='" + DTOS(mv_par03) + "'" )
		cCondSD2	+=	( " .And. DTOS(D2_EMISSAO)<='" + DTOS(mv_par04) + "'" )
	Else
		cCondSD2	:=	( "D2_FILIAL == '" + xFilial("SD2") + "'")
	EndIf
	cCondSD2 +=	( ".And. !(" + IsRemito(2,'SD2->D2_TIPODOC') + ")" )
				
	dbSelectArea("SD2")
	IndRegua("SD2",cArqTrbSD2,"D2_FILIAL+D2_COD+D2_NFORI+D2_ITEMORI+D2_SERIORI+D2_CLIENTE+D2_LOJA",,cCondSD2,STR0010)		//"Selecionando Registros..."
	nNewIndSD2 := RetIndex("SD2")
	dbSelectArea("SD2")
	#IFNDEF TOP
		dbSetIndex(cArqTrbSD2+OrdBagExt())
	#ENDIF
	dbSetOrder(nNewIndSD2+1)
	dbGoTop()
EndIf

cFilUsrSD1:= oSection1:GetAdvplExp()

If nOrdem == 1

	//��������������������������������������������������������������Ŀ
	//� Definicao das quebras e totalizadores que serao Impressos.   �
	//����������������������������������������������������������������	
	oBreak1 := TRBreak():New(oSection1,oSection1:Cell("D1_DOC")    ,STR0017,.F.,"NFE") // "TOTAL NOTA FISCAL --> "
	oBreak2 := TRBreak():New(oSection1,oSection1:Cell("D1_FORNECE"),STR0018,.F.) // "TOTAL FORNECEDOR  --> "

	//��������������������������������������������������������������������������������������������������������������������������Ŀ
	//� A ordem de chamada de cada TRFunction nao deve ser alterada, pois representa a ordem da celula gerada para planilha XML  �
	//����������������������������������������������������������������������������������������������������������������������������		
	TRFunction():New(oSection1:Cell("D1_QUANT"),NIL,"SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),NIL,"SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.F.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALTOTAL"),NIL,"SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPINC")  ,NIL,"SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.F.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALCUSTO"),NIL,"SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 

	//��������������������������������������������������������������Ŀ
	//� Dispara a funcao PrintDevol() para a impressao da oSection2  �
	//� apartir do Break NFE abaixo apos a impressao do totalizador. �
	//����������������������������������������������������������������	
	oBreak:= oReport:Section(1):GetBreak("NFE")
	oBreak:OnPrintTotal({|| PrintDevol(aRecno,lQuery,oReport,oSection1,oSection2,cAliasSD1,(cAliasSD1)->SD1RECNO) })
	
	//��������������������������������������������������������������Ŀ
	//� Impressao dos totalizadores SD1 (-) SD2 Devolucoes.          �
	//����������������������������������������������������������������	
	TRFunction():New(oSection1:Cell("D1_QUANT"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1QTD2"):GetValue() + oSection2:GetFunction("SD2QTD2"):GetValue() , oSection1:GetFunction("SD1QTD2"):ReportValue() + oSection2:GetFunction("SD2QTD2"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1NIC2"):GetValue() + oSection2:GetFunction("SD2NIC2"):GetValue() , oSection1:GetFunction("SD1NIC2"):ReportValue() + oSection2:GetFunction("SD2NIC2"):ReportValue() ) },.F.,.T.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALTOTAL"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1TOT2"):GetValue() + oSection2:GetFunction("SD2TOT2"):GetValue() , oSection1:GetFunction("SD1TOT2"):ReportValue() + oSection2:GetFunction("SD2TOT2"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPINC")  ,NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1INC2"):GetValue() + oSection2:GetFunction("SD2INC2"):GetValue() , oSection1:GetFunction("SD1INC2"):ReportValue() + oSection2:GetFunction("SD2INC2"):ReportValue() ) },.F.,.T.) 
    EndIf
	TRFunction():New(oSection1:Cell("VALCUSTO"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1CUS2"):GetValue() + oSection2:GetFunction("SD2CUS2"):GetValue() , oSection1:GetFunction("SD1CUS2"):ReportValue() + oSection2:GetFunction("SD2CUS2"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 		

ElseIf nOrdem == 2

	//��������������������������������������������������������������Ŀ
	//� Definicao das quebras e totalizadores que serao Impressos.   �
	//����������������������������������������������������������������	
	oBreak1 := TRBreak():New(oSection1,oSection1:Cell("D1_DOC")    ,STR0017,.F.,"NFE") // "TOTAL NOTA FISCAL --> "
	oBreak2 := TRBreak():New(oSection1,oSection1:Cell("D1_FORNECE"),STR0018,.F.) // "TOTAL FORNECEDOR  --> "
	oBreak3 := TRBreak():New(oSection1,oSection1:Cell("D1_DTDIGIT"),STR0019,.F.) // "TOT. NA DATA "

	//��������������������������������������������������������������������������������������������������������������������������Ŀ
	//� A ordem de chamada de cada TRFunction nao deve ser alterada, pois representa a ordem da celula gerada para planilha XML  �
	//����������������������������������������������������������������������������������������������������������������������������    
	TRFunction():New(oSection1:Cell("D1_QUANT"),NIL,"SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),NIL,"SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.F.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALTOTAL"),NIL,"SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPINC")  ,NIL,"SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.F.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALCUSTO"),NIL,"SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 

	//��������������������������������������������������������������Ŀ
	//� Dispara a funcao PrintDevol() para a impressao da oSection2  �
	//� apartir do Break NFE abaixo apos a impressao do totalizador. �
	//����������������������������������������������������������������	
	oBreak:= oReport:Section(1):GetBreak("NFE")
	oBreak:OnPrintTotal({|| PrintDevol(aRecno,lQuery,oReport,oSection1,oSection2,cAliasSD1,(cAliasSD1)->SD1RECNO) })

	//��������������������������������������������������������������Ŀ
	//� Impressao dos totalizadores SD1 (-) SD2 Devolucoes.          �
	//����������������������������������������������������������������	
	TRFunction():New(oSection1:Cell("D1_QUANT"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|| oSection1:GetFunction("SD1QTD2"):GetValue() + oSection2:GetFunction("SD2QTD2"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|| oSection1:GetFunction("SD1NIC2"):GetValue() + oSection2:GetFunction("SD2NIC2"):GetValue() },.F.,.F.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALTOTAL"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|| oSection1:GetFunction("SD1TOT2"):GetValue() + oSection2:GetFunction("SD2TOT2"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPINC")  ,NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|| oSection1:GetFunction("SD1INC2"):GetValue() + oSection2:GetFunction("SD2INC2"):GetValue() },.F.,.F.) 
    EndIf
	TRFunction():New(oSection1:Cell("VALCUSTO"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|| oSection1:GetFunction("SD1CUS2"):GetValue() + oSection2:GetFunction("SD2CUS2"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 		
	TRFunction():New(oSection1:Cell("D1_QUANT"),NIL,"ONPRINT",oBreak3,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1QTD3"):GetValue() + oSection2:GetFunction("SD2QTD3"):GetValue() , oSection1:GetFunction("SD1QTD3"):ReportValue() + oSection2:GetFunction("SD2QTD3"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),NIL,"ONPRINT",oBreak3,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1NIC3"):GetValue() + oSection2:GetFunction("SD2NIC3"):GetValue() , oSection1:GetFunction("SD1NIC3"):ReportValue() + oSection2:GetFunction("SD2NIC3"):ReportValue() ) },.F.,.T.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALTOTAL"),NIL,"ONPRINT",oBreak3,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1TOT3"):GetValue() + oSection2:GetFunction("SD2TOT3"):GetValue() , oSection1:GetFunction("SD1TOT3"):ReportValue() + oSection2:GetFunction("SD2TOT3"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPINC")  ,NIL,"ONPRINT",oBreak3,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1INC3"):GetValue() + oSection2:GetFunction("SD2INC3"):GetValue() , oSection1:GetFunction("SD1INC3"):ReportValue() + oSection2:GetFunction("SD2INC3"):ReportValue() ) },.F.,.T.) 
    EndIf
	TRFunction():New(oSection1:Cell("VALCUSTO"),NIL,"ONPRINT",oBreak3,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1CUS3"):GetValue() + oSection2:GetFunction("SD2CUS3"):GetValue() , oSection1:GetFunction("SD1CUS3"):ReportValue() + oSection2:GetFunction("SD2CUS3"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 		

ElseIf nOrdem == 3

	//��������������������������������������������������������������Ŀ
	//� Definicao das quebras e totalizadores que serao Impressos.   �
	//����������������������������������������������������������������	
	oBreak1 := TRBreak():New(oSection1,oSection1:Cell("COD"),STR0014,.F.,"PROD") // "TOTAL PRODUTO     --> "
	oBreak2 := TRBreak():New(oSection1,oSection1:Cell("D1_GRUPO")  ,STR0015,.F.) // "TOTAL GRUPO "
	oBreak3 := TRBreak():New(oSection1,oSection1:Cell("D1_TP")     ,STR0016,.F.) // "TOTAL TIPO  "
	
	//��������������������������������������������������������������Ŀ
	//� Dispara a funcao PrintDevol() para a impressao da oSection2  �
	//� apartir do Break NFE abaixo apos a impressao do totalizador. �      
	//����������������������������������������������������������������	
	oBreak:= oReport:Section(1):GetBreak("PROD")
	oBreak:OnBreak({|| PrintDevol(aRecno,lQuery,oReport,oSection1,oSection2,cAliasSD1,(cAliasSD1)->SD1RECNO) })
    
	//��������������������������������������������������������������Ŀ
	//� Impressao dos totalizadores SD1 (-) SD2 Devolucoes.          �
	//����������������������������������������������������������������	
	//��������������������������������������������������������������������������������������������������������������������������Ŀ
	//� A ordem de chamada de cada TRFunction nao deve ser alterada, pois representa a ordem da celula gerada para planilha XML  �
	//����������������������������������������������������������������������������������������������������������������������������
	TRFunction():New(oSection1:Cell("D1_QUANT"),NIL,"ONPRINT",oBreak1,,/*cPicture*/,{|| oSection1:GetFunction("SD1QTD1"):GetValue() + oSection2:GetFunction("SD2QTD1"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),NIL,"ONPRINT",oBreak1,,/*cPicture*/,{|| oSection1:GetFunction("SD1NIC1"):GetValue() + oSection2:GetFunction("SD2NIC1"):GetValue() },.F.,.F.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALTOTAL"),NIL,"ONPRINT",oBreak1,,/*cPicture*/,{|| oSection1:GetFunction("SD1TOT1"):GetValue() + oSection2:GetFunction("SD2TOT1"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPINC")  ,NIL,"ONPRINT",oBreak1,,/*cPicture*/,{|| oSection1:GetFunction("SD1INC1"):GetValue() + oSection2:GetFunction("SD2INC1"):GetValue() },.F.,.F.) 
    EndIf
	TRFunction():New(oSection1:Cell("VALCUSTO"),NIL,"ONPRINT",oBreak1,,/*cPicture*/,{|| oSection1:GetFunction("SD1CUS1"):GetValue() + oSection2:GetFunction("SD2CUS1"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 		
	TRFunction():New(oSection1:Cell("D1_QUANT"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|| oSection1:GetFunction("SD1QTD2"):GetValue() + oSection2:GetFunction("SD2QTD2"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|| oSection1:GetFunction("SD1NIC2"):GetValue() + oSection2:GetFunction("SD2NIC2"):GetValue() },.F.,.F.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALTOTAL"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|| oSection1:GetFunction("SD1TOT2"):GetValue() + oSection2:GetFunction("SD2TOT2"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPINC")  ,NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|| oSection1:GetFunction("SD1INC2"):GetValue() + oSection2:GetFunction("SD2INC2"):GetValue() },.F.,.F.) 
    EndIf
	TRFunction():New(oSection1:Cell("VALCUSTO"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|| oSection1:GetFunction("SD1CUS2"):GetValue() + oSection2:GetFunction("SD2CUS2"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 		
	TRFunction():New(oSection1:Cell("D1_QUANT"),NIL,"ONPRINT",oBreak3,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1QTD3"):GetValue() + oSection2:GetFunction("SD2QTD3"):GetValue() , oSection1:GetFunction("SD1QTD3"):ReportValue() + oSection2:GetFunction("SD2QTD3"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),NIL,"ONPRINT",oBreak3,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1NIC3"):GetValue() + oSection2:GetFunction("SD2NIC3"):GetValue() , oSection1:GetFunction("SD1NIC3"):ReportValue() + oSection2:GetFunction("SD2NIC3"):ReportValue() ) },.F.,.T.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALTOTAL"),NIL,"ONPRINT",oBreak3,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1TOT3"):GetValue() + oSection2:GetFunction("SD2TOT3"):GetValue() , oSection1:GetFunction("SD1TOT3"):ReportValue() + oSection2:GetFunction("SD2TOT3"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPINC")  ,NIL,"ONPRINT",oBreak3,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1INC3"):GetValue() + oSection2:GetFunction("SD2INC3"):GetValue() , oSection1:GetFunction("SD1INC3"):ReportValue() + oSection2:GetFunction("SD2INC3"):ReportValue() ) },.F.,.T.) 
    EndIf
	TRFunction():New(oSection1:Cell("VALCUSTO"),NIL,"ONPRINT",oBreak3,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1CUS3"):GetValue() + oSection2:GetFunction("SD2CUS3"):GetValue() , oSection1:GetFunction("SD1CUS3"):ReportValue() + oSection2:GetFunction("SD2CUS3"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 		

ElseIf nOrdem == 4

	//��������������������������������������������������������������Ŀ
	//� Definicao das quebras e totalizadores que serao Impressos.   �
	//����������������������������������������������������������������	
	oBreak1 := TRBreak():New(oSection1,oSection1:Cell("COD"),STR0014,.F.,"PROD") // "TOTAL PRODUTO     --> "
	oBreak2 := TRBreak():New(oSection1,oSection1:Cell("D1_GRUPO")  ,STR0015,.F.) // "TOTAL GRUPO "

	//��������������������������������������������������������������Ŀ
	//� Dispara a funcao PrintDevol() para a impressao da oSection2  �
	//� apartir do Break NFE abaixo apos a impressao do totalizador. �
	//����������������������������������������������������������������	
	oBreak:= oReport:Section(1):GetBreak("PROD")
	oBreak:OnBreak({|| PrintDevol(aRecno,lQuery,oReport,oSection1,oSection2,cAliasSD1,(cAliasSD1)->SD1RECNO) })

	//��������������������������������������������������������������Ŀ
	//� Impressao dos totalizadores SD1 (-) SD2 Devolucoes.          �
	//����������������������������������������������������������������	
	//��������������������������������������������������������������������������������������������������������������������������Ŀ
	//� A ordem de chamada de cada TRFunction nao deve ser alterada, pois representa a ordem da celula gerada para planilha XML  �
	//����������������������������������������������������������������������������������������������������������������������������
	TRFunction():New(oSection1:Cell("D1_QUANT"),NIL,"ONPRINT",oBreak1,,/*cPicture*/,{|| oSection1:GetFunction("SD1QTD1"):GetValue() + oSection2:GetFunction("SD2QTD1"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),NIL,"ONPRINT",oBreak1,,/*cPicture*/,{|| oSection1:GetFunction("SD1NIC1"):GetValue() + oSection2:GetFunction("SD2NIC1"):GetValue() },.F.,.F.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALTOTAL"),NIL,"ONPRINT",oBreak1,,/*cPicture*/,{|| oSection1:GetFunction("SD1TOT1"):GetValue() + oSection2:GetFunction("SD2TOT1"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPINC")  ,NIL,"ONPRINT",oBreak1,,/*cPicture*/,{|| oSection1:GetFunction("SD1INC1"):GetValue() + oSection2:GetFunction("SD2INC1"):GetValue() },.F.,.F.) 
    EndIf
	TRFunction():New(oSection1:Cell("VALCUSTO"),NIL,"ONPRINT",oBreak1,,/*cPicture*/,{|| oSection1:GetFunction("SD1CUS1"):GetValue() + oSection2:GetFunction("SD2CUS1"):GetValue() },.F.,.F. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 		
	TRFunction():New(oSection1:Cell("D1_QUANT"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1QTD2"):GetValue() + oSection2:GetFunction("SD2QTD2"):GetValue() , oSection1:GetFunction("SD1QTD2"):ReportValue() + oSection2:GetFunction("SD2QTD2"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1NIC2"):GetValue() + oSection2:GetFunction("SD2NIC2"):GetValue() , oSection1:GetFunction("SD1NIC2"):ReportValue() + oSection2:GetFunction("SD2NIC2"):ReportValue() ) },.F.,.T.) 
	EndIf
	TRFunction():New(oSection1:Cell("VALTOTAL"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1TOT2"):GetValue() + oSection2:GetFunction("SD2TOT2"):GetValue() , oSection1:GetFunction("SD1TOT2"):ReportValue() + oSection2:GetFunction("SD2TOT2"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPINC")  ,NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1INC2"):GetValue() + oSection2:GetFunction("SD2INC2"):GetValue() , oSection1:GetFunction("SD1INC2"):ReportValue() + oSection2:GetFunction("SD2INC2"):ReportValue() ) },.F.,.T.) 
    EndIf
	TRFunction():New(oSection1:Cell("VALCUSTO"),NIL,"ONPRINT",oBreak2,,/*cPicture*/,{|lSection,lReport,lPage| If( !lReport, oSection1:GetFunction("SD1CUS2"):GetValue() + oSection2:GetFunction("SD2CUS2"):GetValue() , oSection1:GetFunction("SD1CUS2"):ReportValue() + oSection2:GetFunction("SD2CUS2"):ReportValue() ) },.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 		

EndIf

//��������������������������������������������������������������Ŀ
//� Os TRFunctions abaixo nao sao impressos, servem apenas para  �
//� acumular os valores das oSection1 e oSection2 para serem     �
//� utilizados na impressao do totalizador geral da oSection1    �
//� acima ONPRINT que subtrai as devolucoes SD1 - SD2.           �
//����������������������������������������������������������������
If nOrdem == 3 .Or. nOrdem == 4

	TRFunction():New(oSection1:Cell("D1_QUANT"),"SD1QTD1","SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
	TRFunction():New(oSection1:Cell("VALTOTAL"),"SD1TOT1","SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
	TRFunction():New(oSection1:Cell("VALCUSTO"),"SD1CUS1","SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    oSection1:GetFunction("SD1QTD1"):Disable()
    oSection1:GetFunction("SD1TOT1"):Disable()
    oSection1:GetFunction("SD1CUS1"):Disable()
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),"SD1NIC1","SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.T.) 
		TRFunction():New(oSection1:Cell("IMPINC")  ,"SD1INC1","SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.T.) 
	    oSection1:GetFunction("SD1NIC1"):Disable()
	    oSection1:GetFunction("SD1INC1"):Disable()
	EndIf

	TRFunction():New(oSection2:Cell("D2_QUANT"),"SD2QTD1","SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
	TRFunction():New(oSection2:Cell("VALTOTAL"),"SD2TOT1","SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
	TRFunction():New(oSection2:Cell("VALCUSTO"),"SD2CUS1","SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    oSection2:GetFunction("SD2QTD1"):Disable()
    oSection2:GetFunction("SD2TOT1"):Disable()
    oSection2:GetFunction("SD2CUS1"):Disable()
    If cPaisloc <> "BRA"
		TRFunction():New(oSection2:Cell("IMPNOINC"),"SD2NIC1","SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.T.) 
		TRFunction():New(oSection2:Cell("IMPINC")  ,"SD2INC1","SUM",oBreak1,,/*cPicture*/,/*uFormula*/,.F.,.T.) 
	    oSection2:GetFunction("SD2NIC1"):Disable()
	    oSection2:GetFunction("SD2INC1"):Disable()
    EndIf

EndIf

TRFunction():New(oSection1:Cell("D1_QUANT"),"SD1QTD2","SUM",oBreak2,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } )
TRFunction():New(oSection1:Cell("VALTOTAL"),"SD1TOT2","SUM",oBreak2,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } )
TRFunction():New(oSection1:Cell("VALCUSTO"),"SD1CUS2","SUM",oBreak2,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } )
oSection1:GetFunction("SD1QTD2"):Disable()
oSection1:GetFunction("SD1TOT2"):Disable()
oSection1:GetFunction("SD1CUS2"):Disable()
If cPaisloc <> "BRA"
	TRFunction():New(oSection1:Cell("IMPNOINC"),"SD1NIC2","SUM",oBreak2,,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection1:Cell("IMPINC")  ,"SD1INC2","SUM",oBreak2,,/*cPicture*/,/*uFormula*/,.F.,.T.)
	oSection1:GetFunction("SD1NIC2"):Disable()
	oSection1:GetFunction("SD1INC2"):Disable()
EndIf

TRFunction():New(oSection2:Cell("D2_QUANT"),"SD2QTD2","SUM",oBreak2,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } )
TRFunction():New(oSection2:Cell("VALTOTAL"),"SD2TOT2","SUM",oBreak2,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } )
TRFunction():New(oSection2:Cell("VALCUSTO"),"SD2CUS2","SUM",oBreak2,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } )
oSection2:GetFunction("SD2QTD2"):Disable()
oSection2:GetFunction("SD2TOT2"):Disable()
oSection2:GetFunction("SD2CUS2"):Disable()
If cPaisloc <> "BRA"
	TRFunction():New(oSection2:Cell("IMPNOINC"),"SD2NIC2","SUM",oBreak2,,/*cPicture*/,/*uFormula*/,.F.,.T.)
	TRFunction():New(oSection2:Cell("IMPINC")  ,"SD2INC2","SUM",oBreak2,,/*cPicture*/,/*uFormula*/,.F.,.T.)
	oSection2:GetFunction("SD2NIC2"):Disable()
	oSection2:GetFunction("SD2INC2"):Disable()
EndIf

If nOrdem == 2 .Or. nOrdem == 3

	TRFunction():New(oSection1:Cell("D1_QUANT"),"SD1QTD3","SUM",oBreak3,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
	TRFunction():New(oSection1:Cell("VALTOTAL"),"SD1TOT3","SUM",oBreak3,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
	TRFunction():New(oSection1:Cell("VALCUSTO"),"SD1CUS3","SUM",oBreak3,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    oSection1:GetFunction("SD1QTD3"):Disable()
    oSection1:GetFunction("SD1TOT3"):Disable()
    oSection1:GetFunction("SD1CUS3"):Disable()
    If cPaisloc <> "BRA"
		TRFunction():New(oSection1:Cell("IMPNOINC"),"SD1NIC3","SUM",oBreak3,,/*cPicture*/,/*uFormula*/,.F.,.T.) 
		TRFunction():New(oSection1:Cell("IMPINC")  ,"SD1INC3","SUM",oBreak3,,/*cPicture*/,/*uFormula*/,.F.,.T.) 
	    oSection1:GetFunction("SD1NIC3"):Disable()
	    oSection1:GetFunction("SD1INC3"):Disable()
	EndIf

	TRFunction():New(oSection2:Cell("D2_QUANT"),"SD2QTD3","SUM",oBreak3,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
	TRFunction():New(oSection2:Cell("VALTOTAL"),"SD2TOT3","SUM",oBreak3,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
	TRFunction():New(oSection2:Cell("VALCUSTO"),"SD2CUS3","SUM",oBreak3,,/*cPicture*/,/*uFormula*/,.F.,.T. ,,, {|| IIf( mv_par11 == 1 ,(cAliasSF4)->F4_AGREG <> "N" , .T. ) } ) 
    oSection2:GetFunction("SD2QTD3"):Disable()
    oSection2:GetFunction("SD2TOT3"):Disable()
    oSection2:GetFunction("SD2CUS3"):Disable()
    If cPaisloc <> "BRA"
		TRFunction():New(oSection2:Cell("IMPNOINC"),"SD2NIC3","SUM",oBreak3,,/*cPicture*/,/*uFormula*/,.F.,.T.) 
		TRFunction():New(oSection2:Cell("IMPINC")  ,"SD2INC3","SUM",oBreak3,,/*cPicture*/,/*uFormula*/,.F.,.T.) 
	    oSection2:GetFunction("SD2NIC3"):Disable()
	    oSection2:GetFunction("SD2INC3"):Disable()
    EndIf

EndIf

oReport:SetMeter(SD1->(LastRec()))
dbSelectArea(cAliasSD1)

oSection1:Init()

While !oReport:Cancel() .And. !(cAliasSD1)->(Eof())

	lMoeda := .T.

	oReport:IncMeter()
	If oReport:Cancel()
		Exit
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Considera filtro escolhido                                   �
	//����������������������������������������������������������������
	dbSelectArea(cAliasSD1)
	If !Empty(cFilUsrSD1)
	    If !(&(cFilUsrSD1))
	       dbSkip()
    	   Loop
    	EndIf   
	EndIf

	If lQuery
		//������������������������������������������������������������������������������Ŀ
		//� Desconsidera quando for Cliente e Tipo da NF <> Devolucao ou Beneficiamento  �
		//| Em situa��es onde o C�digo do Cliente e C�digo do Fornecedor s�o iguais      |
		//| e necess�rio este crit�rio para n�o imprimir o relat�rio incorretamente.     |
		//��������������������������������������������������������������������������������   
	 	if (cAliasSD1)->TIPO == "C" 
		   If !(cAliasSD1)->D1_TIPO $ "DB"
			   dbSkip()
    		   Loop
    		EndIf
    	EndIf         
		
		//��������������������������������������������������������������Ŀ
		//� Nao imprimir notas com moeda diferente da escolhida.         �
		//����������������������������������������������������������������
		If mv_par10==2 
			If If((cAliasSD1)->F1_MOEDA==0,1,(cAliasSD1)->F1_MOEDA) != mv_par09
				lMoeda := .F.
			Endif
		EndIf
	
		cRazao   := (cAliasSD1)->RAZAO			
        nValUnit := xmoeda((cAliasSD1)->D1_VUNIT,(cAliasSD1)->F1_MOEDA,mv_par09,(cAliasSD1)->F1_DTDIGIT,nDecs+1,(cAliasSD1)->F1_TXMOEDA)
        nValTot  := xmoeda((cAliasSD1)->D1_TOTAL,(cAliasSD1)->F1_MOEDA,mv_par09,(cAliasSD1)->F1_DTDIGIT,nDecs+1,(cAliasSD1)->F1_TXMOEDA)
		nValCusto:= xmoeda((cAliasSD1)->D1_CUSTO,1,mv_par09,(cAliasSD1)->F1_DTDIGIT,nDecs+1,(cAliasSD1)->F1_TXMOEDA)
		
		// Vari�vel para atualizar o C�digo quando for estiver usando ve�culo ou n�o
		If lVeiculo
		   cCod:=(cAliasSD1)->D1_CODITE
		Else
		   cCod:= (cAliasSD1)->D1_COD
		EndIf

		If cPaisLoc <> "BRA"
			aImpostos:=TesImpInf((cAliasSD1)->D1_TES)
			nImpInc	:=	0
			nImpNoInc:=	0
			nImpos	:=	0
			For nY:=1 to Len(aImpostos)
				cCampImp:=(cAliasSD1)+"->"+(aImpostos[nY][2])
				nImpos:=&cCampImp
				nImpos:=xmoeda(nImpos,(cAliasSD1)->F1_MOEDA,mv_par09,(cAliasSD1)->F1_DTDIGIT,nDecs+1,(cAliasSD1)->F1_TXMOEDA)
				If ( aImpostos[nY][3]=="1" )
					nImpInc	+=nImpos
				Else
					If aImpostos[nY][3]=="2"
						nImpInc-=nImpos
					Else
						nImpNoInc+=nImpos
					Endif
				EndIf
			Next
		EndIf
	Else
		//��������������������������������������������������������������Ŀ
		//� Nao imprimir notas com moeda diferente da escolhida.         �
		//����������������������������������������������������������������
		If mv_par10==2 
			If If(SF1->F1_MOEDA==0,1,SF1->F1_MOEDA) != mv_par09
				lMoeda := .F.
			Endif
		EndIf	

		//���������������������������������������������������������������Ŀ
		//�Posiciona o Fornecedor SA2 ou Cliente SA1 conf. o tipo da Nota �
		//�����������������������������������������������������������������	
		If (cAliasSD1)->D1_TIPO $ "DB"
			SA1->(dbSetOrder(1))
			SA1->(MsSeek( xFilial("SA1") + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA ))
			cRazao := SA1->A1_NOME
		Else
			SA2->(dbSetOrder(1))
			SA2->(MsSeek( xFilial("SA2") + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA ))
			cRazao := SA2->A2_NOME
		EndIf

		//��������������������������������������������������������������Ŀ
		//� posiciona o SF1                                              �
		//����������������������������������������������������������������
		SF1->(MsSeek((cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA))

		//��������������������������������������������������������������Ŀ
		//� posiciona o SF4                                              �
		//����������������������������������������������������������������
		If mv_par11 == 1
			SF4->(MsSeek( xFilial("SF4") + (cAliasSD1)->D1_TES ))
		EndIf
		
		nValUnit := xmoeda((cAliasSD1)->D1_VUNIT,SF1->F1_MOEDA,mv_par09,SF1->F1_DTDIGIT,nDecs+1,SF1->F1_TXMOEDA) 
		nValTot  := xmoeda((cAliasSD1)->D1_TOTAL,SF1->F1_MOEDA,mv_par09,SF1->F1_DTDIGIT,nDecs+1,SF1->F1_TXMOEDA) 
		nValCusto:= xmoeda((cAliasSD1)->D1_CUSTO,1,mv_par09,SF1->F1_DTDIGIT,nDecs+1,SF1->F1_TXMOEDA)

		If cPaisLoc <> "BRA"
			aImpostos:=TesImpInf((cAliasSD1)->D1_TES)
			nImpInc	:=	0
			nImpNoInc:=	0
			nImpos	:=	0
			For nY:=1 to Len(aImpostos)
				cCampImp:=(cAliasSD1)+"->"+(aImpostos[nY][2])
				nImpos:=&cCampImp
				nImpos:=xmoeda(nImpos,SF1->F1_MOEDA,mv_par09,SF1->F1_DTDIGIT,nDecs+1,SF1->F1_TXMOEDA)
				If ( aImpostos[nY][3]=="1" )
					nImpInc	+=nImpos
				Else
					If aImpostos[nY][3]=="2"
						nImpInc-=nImpos
					Else
						nImpNoInc+=nImpos
					Endif
				EndIf
			Next
		EndIf

	EndIf
			    
    If lMoeda 

		oSection1:PrintLine()		
    
		//���������������������������������������������������������������Ŀ
		//� Verificar a existencia de Devolucoes de Compras.              �
		//�����������������������������������������������������������������
		If (cAliasSD1)->D1_QTDEDEV <> 0 .And. mv_par07 == 1
			AADD(aRecno,IIf(lQuery,(cAliasSD1)->SD1RECNO,Recno()))
		Endif

    EndIf
    
	dbSelectArea(cAliasSD1)
	dbSkip()

EndDo

oSection1:Finish()

//��������������������������������������������������������������Ŀ
//� Exclui o Arquivo Trabalho SD2 quando imprime NFs de devolucao�
//����������������������������������������������������������������
If mv_par07 == 1

	RetIndex("SD2")
	dbSelectArea("SD2")
	dbClearFilter()
	dbSetOrder(1)
	
	If File(cArqTrbSD2+OrdBagExt())
		Ferase(cArqTrbSD2+OrdBagExt())
	EndIf
	
EndIf

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �PrintDevol� Autor �Alexandre Inacio Lemes �Data  �07/08/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime as devolucoes de compras SD2                       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PrintDevol(aRecno,lQuery,oReport,oSection1,oSection2,cAliasSD1,nRecno)

Local nDecs    := Msdecimais(mv_par09) //casas decimais utilizadas na moeda da impressao
Local nX       := 0
Local nY       := 0
Local nSaveRec := If( lQuery, nRecno, Recno() )

oSection2:Init()
		
TRPosition():New(oSection2,"SB1",1,{|| xFilial("SB1")+SD2->D2_COD })

For nX :=1 to Len(aRecno)
	
	dbSelectArea("SD1")
	dbGoto(aRecno[nX])
	dbSelectArea("SD2")
	MsSeek(SD1->D1_FILIAL+SD1->D1_COD+SD1->D1_DOC+SD1->D1_ITEM+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
	SF2->(MsSeek(SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA))
	
	While !Eof() .And. SD1->D1_FILIAL+SD1->D1_COD+SD1->D1_DOC+SD1->D1_ITEM+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA ==;
		SD2->D2_FILIAL+SD2->D2_COD+SD2->D2_NFORI+SD2->D2_ITEMORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA
		
		If nX == 1
			oReport:PrintText(STR0012,,oSection2:Cell("D2_DOC"):ColPos()) //'-Devolucoes:'
		Endif
		
		If lVeiculo
			oReport:PrintText("[ " + SD2->D2_CODITE + " ]",,oSection2:Cell("D2_COD"):ColPos())
		EndIf
		
		If cPaisLoc <> "BRA"
			aImpostos:=TesImpInf(SD2->D2_TES)
			nImpInc	:=	0
			nImpNoInc:=	0
			nImpos	:=	0
			For nY:=1 to Len(aImpostos)
				cCampImp:="SD2->"+(aImpostos[nY][2])
				nImpos:=&cCampImp
				nImpos:=xmoeda(nImpos,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
				If ( aImpostos[nY][3]=="1" )
					nImpInc	+=nImpos
				Else
					If aImpostos[nY][3]=="2"
						nImpInc-=nImpos
					Else
						nImpNoInc+=nImpos
					Endif
				EndIf
			Next nY
		Endif
		
   		nValUnit := xmoeda(SD2->D2_PRCVEN,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA) 
		nValTot  := xmoeda(SD2->D2_TOTAL,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA) 
		nValCusto:= xmoeda(SD2->D2_CUSTO1,1,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)

		SA2->(dbSetOrder(1))
		SA2->(MsSeek( xFilial("SA2") + SD2->D2_CLIENTE + SD2->D2_LOJA ))
		cRazao := SA2->A2_NOME

		oSection2:PrintLine()
		
		dbSelectArea("SD2")
		dbSkip()
		
	EndDo

    If nX == Len(aRecno)		
		oReport:ThinLine()
		oReport:SkipLine()		
    EndIf
      
Next nX

oSection2:Finish()

dbSelectArea(cAliasSD1)
dbgoto(nSaveRec)
aRecno := {}

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR090R3� Autor � Paulo Boschetti       � Data � 28.12.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da rela��o de Compras                              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR090(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Bruno        �09/12/98�melhor�Acerto para impressao na Argentina.     ���
��� Cesar Valadao�31/08/99�21449A�Impressao do campo D1_LOCAL.            ���
��� Patricia Sal.�17/12/99�XXXXXX�Troca da PesqPictQt() pela PesqPict()   ���
���              �        �      �Conversao campo Fornec.(20 pos.)/ Acerto���
���              �        �      �das Includes.                           ���
��� Patricia Sal.�14/02/00�002574�Acerto na Totalizacao das NF's.         ���
��� Paulo Augusto�26/05/00�Melhor�Acerto para imprimir o imposto1 no campo���
���              �        �      �de IVA que estava usando o IPI          ���
��� Patricia Sal.�11/07/00�005088�Validar Filtro Usuario.                 ���
��� Marcello     �23/08/00�oooooo�Impressao da relacao em outras moedas   ���
��� Alex Lemes   �23/04/02�      �Revisao Geral Implementacao Query p/SQL ���
�������������������������������������������������������������������������Ĵ��
���Marcos Hirak  �09/02/04�XXXXXX�Imprimir B1_CODITE quando for gestao de ���
���              �        �      �Concessionarias ( MV_VEICULO = "S")     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MATR090R3()

LOCAL wnrel     := "MATR090"
LOCAL nOrdem    := 1
LOCAL limite    := 220
LOCAL cString   := "SD1"

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         �
//����������������������������������������������������������������
Local aArea1	:= Getarea() 
LOCAL nI		:= 1
Local nTamSX1   := Len(SX1->X1_GRUPO)

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       �
//����������������������������������������������������������������
Private lVEIC		:= UPPER(GETMV("MV_VEICULO"))=="S"
Private aSB1Cod	:= {}
Private aSB1Ite	:= {}
Private nCOL1		:= 0
Private nCOL2		:= 0
Private XSB1, xSD1, xSD2, xSF1, xSF2 , xSF4, xSA2, xSA1
Private cCABPROD  := STR0014 //"TOTAL PRODUTO     --> "
PRIVATE titulo  := OemToAnsi(STR0001)	//"Relacao de Compras"
PRIVATE cDesc1  := OemToAnsi(STR0002)	//"Este relatorio ira imprimir a relacao de itens"
PRIVATE cDesc2  := OemToAnsi(STR0003)	//"referentes a compras efetuadas."
PRIVATE cDesc3  := ""
PRIVATE cPerg   := "MTR090"
PRIVATE tamanho := "G"
PRIVATE aOrd    := {OemToAnsi(STR0004),OemToAnsi(STR0005),OemToAnsi(STR0006) ,OemToAnsi(STR0007)}//" Fornecedor         "###" Data De Digitacao  "###" Tipo+Grupo+Codigo  "###" Grupo+Codigo   "
PRIVATE aReturn := {OemToAnsi(STR0008),1,OemToAnsi(STR0009), 1, 2, 1, "",1}		//"Zebrado"###"Administracao"
PRIVATE aLinha  := { }
PRIVATE nomeprog:= "MATR090"
PRIVATE nLastKey:= 0

dbselectarea("SD2")
dbsetorder(1)
XSD2		:= XFILIAL("SD2")

dbselectarea("SF2")
dbsetorder(1)
XSF2		:= XFILIAL("SF2")

dbselectarea("SA2")
dbsetorder(1)
XSA2		:= XFILIAL("SA2")

dbselectarea("SF4")
dbsetorder(1)
XSF4		:= XFILIAL("SF4")

dbselectarea("SF1")
dbsetorder(1)
XSF1		:= XFILIAL("SF1")

dbselectarea("SD1")
dbsetorder(1)
XSD1		:= XFILIAL("SD1")

dbselectarea("SA1")
dbsetorder(1)
XSA1		:= XFILIAL("SA1")

dbselectarea("SB1")
dbsetorder(1)
XSB1		:= XFILIAL("SB1")

cabec2:= ""
m_pag := 01

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
AjustaSX1()
//��������������������������������������������������������������Ŀ
//� Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                �
//����������������������������������������������������������������
aSB1Cod	:= TAMSX3("B1_COD")
aSB1Ite	:= TAMSX3("B1_CODITE")

if lVEIC

	nCOL1		:= LEN(cCABPROD)
	nCOL2		:= AT('PRODU', UPPER(cCABPROD))

	IF nCOL2 > 0 
	   FOR nI := nCOL2 TO nCOL1
   	   IF SUBSTR(cCABPROD,nI,1) == ' '
   	      EXIT
   	   ENDIF
		 NEXT // nCOL2
	ENDIF		 
	nCOL2	:= nI
   DBSELECTAREA("SX1")
   DBSETORDER(1)
   DBSEEK(PADR(cPerg,nTamSX1))
   DO WHILE SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .AND. !SX1->(EOF())
      IF "PRODU" $ UPPER(SX1->X1_PERGUNT) .AND. UPPER(SX1->X1_TIPO) == "C" .AND. ;
      (SX1->X1_TAMANHO <> aSB1Ite[1] .OR. UPPER(SX1->X1_F3) <> "VR4")

         RECLOCK("SX1",.F.)
         SX1->X1_TAMANHO := aSB1Ite[1]
         SX1->X1_F3 := "VR4"
         DBCOMMIT()
         MSUNLOCK()
         
      ENDIF
      DBSKIP()
   ENDDO
   DBCOMMITALL()
   RESTAREA(aArea1)
else
   DBSELECTAREA("SX1")
   DBSETORDER(1)
   DBSEEK(PADR(cPerg,nTamSX1))
   DO WHILE SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .AND. !SX1->(EOF())
      IF "PRODU" $ UPPER(SX1->X1_PERGUNT) .AND. UPPER(SX1->X1_TIPO) == "C" .AND. ;
      (SX1->X1_TAMANHO <> aSB1Cod[1] .OR. UPPER(SX1->X1_F3) <> "SB1")

         RECLOCK("SX1",.F.)
         SX1->X1_TAMANHO := aSB1Cod[1]
         SX1->X1_F3 := "SB1"
         DBCOMMIT()
         MSUNLOCK()
         
      ENDIF
      DBSKIP()
   ENDDO
   DBCOMMITALL()
   RESTAREA(aArea1)
endif

Pergunte("MTR090",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Produto de                           �
//� mv_par02             // Produto Ate                          �
//� mv_par03             // Data digitacao de                    �
//� mv_par04             // Data digitacao Ate                   �
//� mv_par05             // Fornecedor de                        �
//� mv_par06             // Fornecedor Ate                       �
//� mv_par07             // Imprime Devolucao Compra ?           �
//� mv_par08             // Filtra Dt Devolucao ?                �
//� mv_par09             // Moeda                                �
//� mv_par10             // Outras moedas                        �
//� mv_par11             // Somente NFE com TES                  �
//� mv_par12             // Imprime Devolucao Venda ?            �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
If nLastKey == 27
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	dbClearFilter()
	Return
Endif

If Type("NewHead")#"U"
	Titulo := NewHead
EndIf
nomeprog:=wnRel

//��������������������������������������������������������������Ŀ
//� Verifica campos para selecao dos indexados (Marcos Hirakawa  �
//����������������������������������������������������������������
nOrdem := aReturn[8]

RptStatus({|lEnd| C090Imp      ( @lEnd,wnRel   ,cString, nOrdem)},ALLTRIM(titulo)+" ("+alltrim(aOrd[nOrdem])+")") // titulo)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CA090Imp � Autor �Alexandre Inacio Lemes � Data �25/04/2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MTR090                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C090Imp(lEnd,WnRel,cString, nOrdem)

LOCAL cbCont    := 0
LOCAL nTotal    := 0
LOCAL nTotTip   := 0
LOCAL nTotGrp   := 0
LOCAL nTotProd  := 0
LOCAL nTotForn  := 0
LOCAL nCnt      := 0
LOCAL nTotQt1   := 0
LOCAL nTotQt2   := 0
LOCAL nTotQt3   := 0
LOCAL nTotVal1  := 0
LOCAL nTotVal2  := 0
LOCAL nTotVal3  := 0
LOCAL nTotDtVal := 0
LOCAL nTotDtCus := 0
LOCAL nTotDtQt  := 0
LOCAL nPosNome  := 133
LOCAL nTamNome  := 040
LOCAL nTamReduz := 026
LOCAL nDecs     := Msdecimais(mv_par09) //casas decimais utilizadas na moeda da impressao
LOCAL cTipAnt   := ""
LOCAL cChave    := ""
LOCAL condicao  := ""
LOCAL cGrpAnt   := ""
LOCAL cCondSD2  := ""
LOCAL cIndice   := ""
LOCAL cNomeArq  := ""
LOCAL cNomeArq1 := ""
LOCAL cQuery    := ""
LOCAL cAliasSF1 := "SF1"
LOCAL cAliasSD1 := "SD1"
LOCAL cAliasSB1 := "SB1"
LOCAL cAliasSA1 := "SA1"
LOCAL cAliasSA2 := "SA2"
LOCAL cAliasSF4 := "SF4"
LOCAL aStrucSF1 := {}
LOCAL aStrucSD1 := {}
LOCAL aStrucSB1 := {}
LOCAL aStrucSA1 := {}
LOCAL aStrucSA2 := {}
LOCAL aStrucSF4 := {}
LOCAL nSD1 		:= 0
LOCAL nSF1 		:= 0
LOCAL nSA1 		:= 0
LOCAL nSA2 		:= 0
LOCAL nSF4 		:= 0  
LOCAL nY		:= 0
LOCAL cTipGrp	:= ""
LOCAL cProdAnt	:= ""
LOCAL cQuebra	:= ""
LOCAL aRec      := {}
LOCAL aImposto	:= {}
LOCAL nImpInc   := 0
LOCAL nImpNoInc	:= 0
LOCAL nImpos	:= 0
LOCAL cCampImp  := ""
LOCAL nTaxa		:= 0
LOCAL nMoeda	:= 0
LOCAL dDtDig    := dDataBase
LOCAL aTotais   := {0,0,0,0,0,0,0,0,0,0,0,0}
LOCAL aTamSXG   := TamSXG("001")
LOCAL lFiltro   := .T.                                                 
LOCAL lQuery    := .F.
Local cName     := ""
Local cQryAdd   := ""
Local nX        := 0
Local i         := 0
Local nSb1      := 0
Local nIncCol	:= 0
Local cTipo1	:= ""
Local cTipo2	:= ""
//������������������������������������������������������������Ŀ
//�Elementos do aTotais                                        �
//�01 e 02 = Total Imposto nao incluido e incluido / NF        �
//�03 e 04 = Total Imposto nao incluido e incluido / Fornecedor�
//�05 e 06 = Total Imposto nao incluido e incluido / Data      �
//�07 e 08 = Total Imposto nao incluido e incluido / Grupo     �
//�09 e 10 = Total Imposto nao incluido e incluido / Tipo      �
//�11 e 12 = Total Imposto nao incluido e incluido / Geral     �
//��������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         �
//����������������������������������������������������������������
Local lT

SF1->(dbsetorder(1))
SF2->(dbsetorder(1))

//��������������������������������������������������������������Ŀ
//�Verifica conteudo da variavel p/ Grupo de Clientes (001)      �
//����������������������������������������������������������������

If cPaisLoc == "BRA"
	If aTamSXG[1] <> aTamSXG[3]
		cabec1:= STR0021  //"NOTA         PRODUTO         DESCRICAO                            QUANTIDADE UM      PR.UNITARIO  IPI             VALOR  ICM  CODIGO               RAZAO SOCIAL               TP TES TIPO GRUPO DATA DIG.           CUSTO LO"
		//                    XXXXXXXXXXXX XXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXXX XXXXX XXXXXXXXXXXXXXXX XXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXX XX XXX X   XXXX  XX/XX/XXXX XXXXXXXXXXXXXXX XX
		//                    0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
		//                    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Else
		cabec1:= STR0020  //"NOTA         PRODUTO         DESCRICAO                            QUANTIDADE UM      PR.UNITARIO  IPI             VALOR  ICM  CODIGO RAZAO SOCIAL                             TP TES TP  GRUPO  DATA DIG.           CUSTO LO"
		//                    XXXXXXXXXXXX XXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX XX XXXXXXXXXXXXXXXX XXXXX XXXXXXXXXXXXXXXX XXXXX XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XX XXX X   XXXX  XX/XX/XXXX XXXXXXXXXXXXXXX XX
		//                    0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1
		//                    0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	Endif
ElseIf cPaisLoc == "MEX"
	cabec1	:= STR0038
	nIncCol	:= 8
Else
	cabec1	:= STR0022
EndIf

li := 80

//��������������������������������������������������������������Ŀ
//� Monta IndRegua caso liste NFs de devolucao                   �
//����������������������������������������������������������������
If mv_par07 == 1
	cNomeArq1:= CriaTrab("",.F.)
	//�����������������������������������������������������������Ŀ
	//� Verifica data caso FILTRE NFs de devolucao fora do periodo�
	//�������������������������������������������������������������
	If mv_par08 == 1
		cCondSD2	:=	( "D2_FILIAL == '" + xSD2 + "'" )
		cCondSD2	+=	( " .And. DTOS(D2_EMISSAO)>='" + DTOS(mv_par03) + "'" )
		cCondSD2	+=	( " .And. DTOS(D2_EMISSAO)<='" + DTOS(mv_par04) + "'" )
	Else
		cCondSD2	:=	( "D2_FILIAL == '" + xSD2 + "'")
	EndIf
	cCondSD2 +=	( ".And. !(" + IsRemito(2,'SD2->D2_TIPODOC') + ")" )
				
	dbSelectArea("SD2")
	IndRegua("SD2",cNomeArq1,"D2_COD+D2_NFORI+D2_ITEMORI+D2_SERIORI+D2_CLIENTE+D2_LOJA",,cCondSD2,STR0010)		//"Selecionando Registros..."
	nIndSD2 := RetIndex("SD2")
	dbSelectArea("SD2")
	#IFNDEF TOP
		dbSetIndex(cNomeArq1+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndSD2+1)
	dbGoTop()
EndIf

// Se nao utiliza tamanho min., considera tamanho maximo e altera LayOut referente ao Grupo 001.
If aTamSXG[1]  <>  aTamSXG[3]
	nPosNome += aTamSXG[4] - aTamSXG[3]
	nTamNome -= aTamSXG[4] - aTamSXG[3]
Endif

If (mv_par12 == 1)
	cTipo1 := "'D','B'"
	cTipo2 := cTipo1
Else
	cTipo1 := "'B'"
	cTipo2 := "'D','B'"
EndIf

#IFDEF TOP
	If (TcSrvType()#'AS/400')
		//��������������������������������Ŀ
		//� Query para SQL                 �
		//����������������������������������
		aStrucSF1 := SF1->(dbStruct())
		aStrucSD1 := SD1->(dbStruct())
		aStrucSB1 := SB1->(dbStruct())
		aStrucSA1 := SA1->(dbStruct())
		aStrucSA2 := SA2->(dbStruct())
		aStrucSF4 := SF4->(dbStruct())
		cALiasSF1 := "QRYSD1"
		cAliasSD1 := "QRYSD1"
		cALiasSB1 := "QRYSD1"
		cALiasSA1 := "QRYSD1"
		cALiasSA2 := "QRYSD1"
		If mv_par11 == 1
			cALiasSF4 := "QRYSD1"
      Endif    
		lQuery :=.T.

      cQuery := "SELECT D1_FILIAL"		// 01
      cQuery += ", D1_DOC"				// 02
      cQuery += ", D1_SERIE"  			// 03
      cQuery += ", D1_FORNECE"			// 04
      cQuery += ", D1_LOJA"				// 05
      cQuery += ", D1_DTDIGIT"			// 06
      cQuery += ", D1_COD"				// 07
      cQuery += ", D1_QUANT"  			// 08
      cQuery += ", D1_VUNIT"  			// 09
      cQuery += ", D1_TOTAL" 			// 10
      cQuery += ", D1_TES"				// 11
      cQuery += ", D1_IPI" 				// 12
      cQuery += ", D1_PICM"				// 13
      cQuery += ", D1_TIPO"				// 14
      cQuery += ", D1_TP"  				// 15
      cQuery += ", D1_GRUPO" 			// 16
      cQuery += ", D1_CUSTO"			// 17
      cQuery += ", D1_LOCAL"  			// 18
      cQuery += ", D1_QTDEDEV"			// 19
      cQuery += ", D1_ITEM"				// 20
      cQuery += ", D1_UM"  				// 21

	  If lVEIC
	      cQuery += ", B1_CODITE"		// 22
      Endif

	  DbSelectArea("SX3")
	  DbSetOrder(2)
	  DbSeek("D1_VALIMP") 
	  While !Eof() .And. X3_ARQUIVO == "SD1" .And. X3_CAMPO = "D1_VALIMP"
	  	cQryAdd +=	(IIF( EMPTY(ALLTRIM(cQryAdd)),"",", ") + X3_CAMPO )
	    DbSkip()
      EndDo   
      
      If !Empty(aReturn[7])
			For nX := 1 To SD1->(FCount())
				cName := SD1->(FieldName(nX))
			 	If AllTrim( cName ) $ aReturn[7]
		      	If aStrucSD1[nX,2] <> "M"  
		      		If !cName $ cQuery .And. !cName $ cQryAdd
							cQryAdd +=	(IIF( EMPTY(ALLTRIM(cQryAdd)),"",", ") + cName )
			       	Endif 	
					EndIf
				EndIf 			       	
			Next nX
      Endif    
      
      If ! Empty(Alltrim(cQryAdd))
	      cQuery += ", " + cQryAdd	// 23
	  endif

      cQuery += ", F1_MOEDA"	// 24
      cQuery += ", F1_TXMOEDA"	// 25
      cQuery += ", F1_DTDIGIT"	// 26

	  If mv_par11 == 1
	 	cQuery += ", F4_AGREG"	// 27
      Endif

      cQuery += ", B1_DESC"		// 28
	  cQuery += ", B1_UM"		// 29

	  cQuery += ", A1_NOME"		// 30
	  cQuery += ", A1_NREDUZ"	// 31
	  cQuery += ", SD1.R_E_C_N_O_ SD1RECNO" 	// 32
	  cQuery += ", 'C' TIPO "  // Cliente

	  cQuery += " FROM " + RetSqlName("SF1") + " SF1"
	  cQuery += ", " + RetSqlName("SD1") + " SD1"
	  cQuery += ", " + RetSqlName("SB1") + " SB1"
	  cQuery += ", " + RetSqlName("SA1") + " SA1"
	  
	  If mv_par11 == 1
	  	cQuery += ", " + RetSqlName("SF4") + " SF4"
	  Endif 

      cQuery += " WHERE"
      cQuery += " SF1.F1_FILIAL='" + xSF1 + "'" 
      cQuery += " AND NOT (" + IsRemito(3,'SF1.F1_TIPODOC') + ")"
	  cQuery += " AND SF1.D_E_L_E_T_ <> '*'"
	  cQuery += " AND SD1.D1_FILIAL = '" + xSD1 + "'"
      cQuery += " AND SD1.D1_DOC = SF1.F1_DOC"
      cQuery += " AND SD1.D1_SERIE = SF1.F1_SERIE"
      cQuery += " AND SD1.D1_FORNECE = SF1.F1_FORNECE"
      cQuery += " AND SD1.D1_LOJA = SF1.F1_LOJA"
      cQuery += " AND SD1.D1_TIPO IN ("+ cTipo1 +")"
      cQuery += " AND SD1.D_E_L_E_T_ <> '*'"
      cQuery += " AND SB1.B1_FILIAL ='" + xSB1 + "'"
      cQuery += " AND SB1.B1_COD = SD1.D1_COD"
      cQuery += " AND SB1.D_E_L_E_T_ <> '*'"
      
      If mv_par11 == 1
			cQuery += " AND SF4.F4_FILIAL ='" + xSF4 + "'"
			cQuery += " AND SF4.F4_CODIGO = SD1.D1_TES"
			cQuery += " AND SF4.D_E_L_E_T_ <> '*'"
	  Endif	      
	  
	  cQuery += " AND SA1.A1_FILIAL ='" + xSA1 + "'"
	  cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE"
	  cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA"
	  cQuery += " AND SA1.D_E_L_E_T_ <> '*'"
	  
	  IF ! lVEIC
	  	 cQuery += " AND D1_COD >= '" + MV_PAR01 + "'"
		 cQuery += " AND D1_COD <= '" + MV_PAR02 + "'"
	  ELSE
		 cQuery += " AND B1_CODITE >= '" + MV_PAR01 + "'"
		 cQuery += " AND B1_CODITE <= '" + MV_PAR02 + "'"
	  ENDIF			
	  
	  cQuery += " AND D1_DTDIGIT >= '" + DTOS(MV_PAR03) + "'"
	  cQuery += " AND D1_DTDIGIT <= '" + DTOS(MV_PAR04) + "'"
	  cQuery += " AND D1_FORNECE >= '" + MV_PAR05 + "'"
	  cQuery += " AND D1_FORNECE <= '" + MV_PAR06 + "'"
		
	  cQuery += " UNION "

	  cQuery += "SELECT D1_FILIAL"	// 01 
	  cQuery += ", D1_DOC"			// 02
	  cQuery += ", D1_SERIE"		// 03
	  cQuery += ", D1_FORNECE"   	// 04
	  cQuery += ", D1_LOJA"	   		// 05
	  cQuery += ", D1_DTDIGIT"   	// 06
	  cQuery += ", D1_COD"	  		// 07
	  cQuery += ", D1_QUANT"	  	// 08
	  cQuery += ", D1_VUNIT"	  	// 09
	  cQuery += ", D1_TOTAL"	  	// 10
	  cQuery += ", D1_TES"	  		// 11
	  cQuery += ", D1_IPI"	   		// 12
	  cQuery += ", D1_PICM"	   		// 13
	  cQuery += ", D1_TIPO"		   	// 14
	  cQuery += ", D1_TP"  	   		// 15
	  cQuery += ", D1_GRUPO"	   	// 16
	  cQuery += ", D1_CUSTO"	   	// 17
	  cQuery += ", D1_LOCAL"	   	// 18
	  cQuery += ", D1_QTDEDEV"   	// 19
	  cQuery += ", D1_ITEM"  	  	// 20
	  cQuery += ", D1_UM"			// 21

	  If lVEIC
	      cQuery += ", B1_CODITE" 		// 22
      Endif

      If ! Empty(Alltrim(cQryAdd))
		cQuery += ", " + cQryAdd   		// 23
	  Endif
		
	  cQuery += ", F1_MOEDA"	    	// 24
	  cQuery += ", F1_TXMOEDA"   		// 25
	  cQuery += ", F1_DTDIGIT"   		// 26
	  
	  If mv_par11 == 1
	 	cQuery +=", F4_AGREG" 			// 27
	  Endif
	  cQuery += ", B1_DESC"  			// 28
	  cQuery += ", B1_UM"	   	   		// 29
	  cQuery += ", A2_NOME"				// 30
	  cQuery += ", A2_NREDUZ"			// 31
	  cQuery += ", SD1.R_E_C_N_O_ SD1RECNO"	// 32
  	  cQuery += ", 'F' TIPO "  // Fornecedor
		
	  cQuery += " FROM " + RetSqlName("SF1") + " SF1"
	  cQuery += ", " + RetSqlName("SD1") + " SD1"
	  cQuery += ", " + RetSqlName("SB1") + " SB1"
	  cQuery += ", " + RetSqlName("SA2") + " SA2"
		
	  If mv_par11 == 1
	 	cQuery += ", " + RetSqlName("SF4") + " SF4"
	  Endif 
	  
	  cQuery += " WHERE"
	  cQuery += " SF1.F1_FILIAL='" + xSF1 + "'"
	  cQuery += " AND SF1.D_E_L_E_T_ <> '*'"
	  cQuery += " AND SD1.D1_FILIAL = '" + xSD1 + "'"
	  cQuery += " AND SD1.D1_DOC = SF1.F1_DOC"
	  cQuery += " AND SD1.D1_SERIE = SF1.F1_SERIE"
	  cQuery += " AND SD1.D1_FORNECE = SF1.F1_FORNECE"
	  cQuery += " AND SD1.D1_LOJA = SF1.F1_LOJA"
	  cQuery += " AND SD1.D1_TIPO NOT IN ("+ cTipo2 +")"
	  cQuery += " AND NOT (" + IsRemito(3,'SD1.D1_TIPODOC') + ")"
	  cQuery += " AND SD1.D_E_L_E_T_ <> '*'"
	  cQuery += " AND SB1.B1_FILIAL ='" + xSB1 + "'"
	  cQuery += " AND SB1.B1_COD = SD1.D1_COD"
	  cQuery += " AND SB1.D_E_L_E_T_ <> '*'"
	  
	  If mv_par11 == 1
	   	 cQuery += " AND SF4.F4_FILIAL ='" + xSF4 + "'"
		 cQuery += " AND SF4.F4_CODIGO = SD1.D1_TES"
		 cQuery += " AND SF4.D_E_L_E_T_ <> '*'"
	  Endif    
	  
	  cQuery += " AND SA2.A2_FILIAL ='" + xSA2 + "'"
	  cQuery += " AND SA2.A2_COD = SD1.D1_FORNECE"
	  cQuery += " AND SA2.A2_LOJA = SD1.D1_LOJA"
	  cQuery += " AND SA2.D_E_L_E_T_ <> '*'"
	  
	  IF ! lVEIC
		 cQuery += " AND D1_COD >= '" + MV_PAR01 + "'"
	     cQuery += " AND D1_COD <= '" + MV_PAR02 + "'"
	  Else
	     cQuery += " AND B1_CODITE >= '" + MV_PAR01 + "'"
		 cQuery += " AND B1_CODITE <= '" + MV_PAR02 + "'"
	  Endif	
	  
	  cQuery += " AND D1_DTDIGIT >= '" + DTOS(MV_PAR03) + "'"
	  cQuery += " AND D1_DTDIGIT <= '" + DTOS(MV_PAR04) + "'"
	  cQuery += " AND D1_FORNECE >= '" + MV_PAR05 + "'"
	  cQuery += " AND D1_FORNECE <= '" + MV_PAR06 + "'"

	  If nOrdem == 1
	   	 cQuery += " ORDER BY 4,5,2,3,20"	 //D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE, D1_ITEM	
	  ElseIf nOrdem == 2 
	 	 cQuery += " ORDER BY 6,4,5,2,3,20" //D1_DTDIGIT,D1_FORNECE,D1_LOJA,D1_DOC,D1_SERIE, D1_ITEM		
	  ElseIf nOrdem == 3 
		  If ! lVEIC
		 	cQuery += " ORDER BY 15,16,7,6" //D1_TP,D1_GRUPO,D1_COD,D1_DTDIGIT
		  Else
		    // O Campo 22 � B1_CODITE para Gest�o de Concession�rias !
			cQuery += " ORDER BY 15,16,22,6" //D1_TP,D1_GRUPO,B1_CODITE,D1_DTDIGIT
		  Endif
      ElseIf nOrdem == 4 
	      If ! lVEIC
		   	 cQuery += " ORDER BY 16,7,6"    //D1_GRUPO,D1_COD,D1_DTDIGIT
		  Else
		     // O Campo 22 � B1_CODITE para Gest�o de Concession�rias !
		 	cQuery += " ORDER BY 16,22,6"    //D1_GRUPO,B1_CODITE,D1_DTDIGIT
		   Endif
      Endif

	  cQuery := ChangeQuery(cQuery)
	  dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cALiasSD1,.T.,.T.) //"Seleccionado registros"

	  For nSD1 := 1 to Len(aStrucSD1)
         If aStrucSD1[nSD1,2] != 'C' .and.  FieldPos(aStrucSD1[nSD1][1]) > 0
            TCSetField(cALiasSD1, aStrucSD1[nSD1,1], aStrucSD1[nSD1,2],aStrucSD1[nSD1,3],aStrucSD1[nSD1,4])
         EndIf	
      Next nSD1

      For nSF1 := 1 to Len(aStrucSF1)
         If aStrucSF1[nSF1,2] != 'C' .and.  FieldPos(aStrucSF1[nSF1][1]) > 0
            TCSetField(cALiasSF1, aStrucSF1[nSF1,1], aStrucSF1[nSF1,2],aStrucSF1[nSF1,3],aStrucSF1[nSF1,4])
         EndIf	
      Next nSF1 
      
      For nSB1 := 1 to Len(aStrucSB1)
         If aStrucSB1[nSB1,2] != 'C' .and.  FieldPos(aStrucSB1[nSB1][1]) > 0
            TCSetField(cALiasSB1, aStrucSB1[nSB1,1], aStrucSB1[nSB1,2],aStrucSB1[nSB1,3],aStrucSB1[nSB1,4])
         EndIf	
      Next nSB1
      
      For nSA1 := 1 to Len(aStrucSA1)
         If aStrucSA1[nSA1,2] != 'C' .and.  FieldPos(aStrucSA1[nSA1][1]) > 0
            TCSetField(cALiasSA1, aStrucSA1[nSA1,1], aStrucSA1[nSA1,2],aStrucSA1[nSA1,3],aStrucSA1[nSA1,4])
         EndIf	
      Next nSA1
      
      For nSA2 := 1 to Len(aStrucSA2)
         If aStrucSA2[nSA2,2] != 'C' .and.  FieldPos(aStrucSA2[nSA2][1]) > 0
            TCSetField(cALiasSA2, aStrucSA2[nSA2,1], aStrucSA2[nSA2,2],aStrucSA2[nSA2,3],aStrucSA2[nSA2,4])
         EndIf	
      Next nSA2

      If mv_par11 == 1
          For nSF4 := 1 to Len(aStrucSF4)
             If aStrucSF4[nSF4,2] != 'C' .and.  FieldPos(aStrucSF4[nSF4][1]) > 0
                TCSetField(cALiasSF4, aStrucSF4[nSF4,1], aStrucSF4[nSF4,2],aStrucSF4[nSF4,3],aStrucSF4[nSF4,4])
             EndIf	
          Next nSF4
      Endif    
   Else 
#ENDIF        
		cNomeArq := CriaTrab("",.F.)
		dbSelectArea(cAliasSD1)
		If nOrdem == 1
			cChave   := mv_par05
			Condicao := IIF( !Empty(aReturn[7]), aReturn[7] + ".And. ", "")
			Condicao +=	"D1_FILIAL == '" + xSD1 + "'"
			Condicao += " .And. D1_FORNECE <= '" + mv_par06 + "'"
			cIndice  := "D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE+D1_ITEM"
		ElseIf nOrdem == 2
			cChave   := dtos(mv_par03)
			Condicao := IIF( !Empty(aReturn[7]), aReturn[7] + ".And. ", "")
			Condicao +=	"D1_FILIAL == '" + xSD1 + "'"
			Condicao +=	" .And. dtos(D1_DTDIGIT) <= '" + dtos(mv_par04) + "'"
			cIndice  := "Dtos(D1_DTDIGIT)+D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE+D1_ITEM"
		ElseIf nOrdem == 3
			Condicao := IIF(! Empty(aReturn[7]), aReturn[7] + ".And. ", "")
			Condicao +=	"D1_FILIAL == '" + xSD1 + "'"
			cIndice  := "D1_TP+D1_GRUPO+D1_COD+Dtos(D1_DTDIGIT)"
      ElseIf nOrdem == 4
			Condicao := IIF(! Empty(aReturn[7]), aReturn[7] + ".And. ", "")
			Condicao +=	"D1_FILIAL == '" + xSD1 + "'"
	      cIndice  := "D1_GRUPO+D1_COD+Dtos(D1_DTDIGIT)"
      Endif
		Condicao += " .And. !(" + IsRemito(2,'SD1->D1_TIPODOC') + ")"			
		If (mv_par12 == 2)   
			Condicao += " .And. (SD1->D1_TIPO <> 'D') "
		EndIf
      IndRegua("SD1",cNomeArq,cIndice,,Condicao,STR0010)		//"Selecionando Registros..."
      nIndSD1 := RetIndex("SD1")
      dbSelectArea(cAliasSD1)
		#IFNDEF TOP
      	dbSetIndex(cNomeArq+OrdBagExt())
		#ENDIF	   
      dbSetOrder(nIndSD1+1)	
      If nOrdem == 1 .Or. nOrdem == 2
			MsSeek(cChave,.T.)
      Else
			dbGoTop()
      Endif
#IFDEF TOP
	Endif
#ENDIF                   

SetRegua(SD1->(RecCount())) // Total de Elementos da Regua
dbSelectArea(cAliasSD1)

nTotQt   := 0
nTotVal  := 0
// INICIO. VERIFICAR SE O PRIMEIRO REGISTRO � IMPRIM�VEL ! MARCOS HIRAKAWA
IF ! lVEIC
	If mv_par11 == 1
	   DO WHILE !(cAliasSD1)->(EOF())
   	   IF SF4->( DBSeek(xSF4 + (cAliasSD1)->D1_TES) )
				EXIT
			ENDIF
	      (cAliasSD1)->(DBSKIP())		
		ENDDO
	Endif	
	cProdAnt := (cAliasSD1)->D1_COD
	cGrpAnt  := (cAliasSD1)->D1_GRUPO
	cTipAnt  := (cAliasSD1)->D1_TP
	cTipGrp  := (cAliasSD1)->D1_TP+(cAliasSD1)->D1_GRUPO
	cCodAnt  := (cAliasSD1)->D1_DOC
	cForna   := (cAliasSD1)->D1_FORNECE
	cSerNf   := (cAliasSD1)->D1_SERIE
ELSE
   DO WHILE !(cAliasSD1)->(EOF())
      IF SB1->(DBSEEK( XSB1 + (cAliasSD1)->D1_COD)) .and. ;
      (SB1->B1_CODITE >= MV_PAR01 .AND. SB1->B1_CODITE <= MV_PAR02)
			If (mv_par11 <> 1) ;
			.or. (mv_par11 == 1 .AND. SF4->( DBSeek(xSF4 + (cAliasSD1)->D1_TES) ))
				EXIT
			ENDIF
		Endif	
		(cAliasSD1)->(DBSKIP())
	ENDDO
	cProdAnt := (cAliasSD1)->D1_COD
	cGrpAnt  := (cAliasSD1)->D1_GRUPO
	cTipAnt  := (cAliasSD1)->D1_TP
	cTipGrp  := (cAliasSD1)->D1_TP+(cAliasSD1)->D1_GRUPO
	cCodAnt  := (cAliasSD1)->D1_DOC
	cForna   := (cAliasSD1)->D1_FORNECE
	cSerNf   := (cAliasSD1)->D1_SERIE
ENDIF
// FIM. VERIFICAR SE O PRIMEIRO REGISTRO � IMPRIM�VEL ! MARCOS HIRAKAWA

If nOrdem == 1
	cQuebra      := (cAliasSD1)->D1_FORNECE
Elseif nOrdem == 2
	cQuebraDtDig := (cAliasSD1)->D1_DTDIGIT
Endif

If !lQuery
	//��������������������������������������������������������������Ŀ
	//� posiciona o cabecalho da nota                                �
	//����������������������������������������������������������������
	(cAliasSF1)->(MsSeek((cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA))
Endif

nTaxa   :=(cAliasSF1)->F1_TXMOEDA
nMoeda  :=(cAliasSF1)->F1_MOEDA
dDtDig  :=(cAliasSF1)->F1_DTDIGIT

dbSelectArea(cAliasSD1)
While !Eof()
	
	If lEnd
		@PROW()+1,001 PSAY STR0011		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	         
	If lQuery
		//������������������������������������������������������������������������������Ŀ
		//� Desconsidera quando for Cliente e Tipo da NF <> Devolucao ou Beneficiamento  �
		//| Em situa��es onde o C�digo do Cliente e C�digo do Fornecedor s�o iguais      |
		//| e necess�rio este crit�rio para n�o imprimir o relat�rio incorretamente.     |
		//��������������������������������������������������������������������������������   
		if (cAliasSD1)->TIPO == "C" 
		   If !(cAliasSD1)->D1_TIPO $ "DB"
			   dbSkip()
    		   Loop
    		EndIf
    	EndIf    
  	EndIf
	
	IF ! lVEIC
	
		lFiltro := Iif(((cAliasSD1)->D1_COD < mv_par01 .Or. (cAliasSD1)->D1_COD > mv_par02) .Or.;
		((cAliasSD1)->D1_DTDIGIT < mv_par03 .Or. (cAliasSD1)->D1_DTDIGIT > mv_par04) .Or.;
		((cAliasSD1)->D1_FORNECE < mv_par05 .Or. (cAliasSD1)->D1_FORNECE > mv_par06),.F.,.T.)
	
	ELSe
	
		If ;
      ( SB1->(DBSEEK( XSB1 + (cAliasSD1)->D1_COD)) .AND. ;
      (SB1->B1_CODITE < mv_par01 .OR. SB1->B1_CODITE > mv_par02) ) ;
		.Or.;
		( (cAliasSD1)->D1_DTDIGIT < mv_par03 .Or. (cAliasSD1)->D1_DTDIGIT > mv_par04 ) ;
		.Or.;
		( (cAliasSD1)->D1_FORNECE < mv_par05 .Or. (cAliasSD1)->D1_FORNECE > mv_par06 )
		
			lFiltro := .F.
		else
			lFiltro := .T.
		Endif
	
	ENDIF	
	//��������������������������������������������������������������Ŀ
	//� Verifica o Filtro do usuario                                 �
	//����������������������������������������������������������������
	If !Empty(aReturn[7]) .And. lFiltro
		lFiltro := Iif(&(aReturn[7]),.T.,.F.)
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Verifica Moeda                                               �
	//����������������������������������������������������������������
	if mv_par10==2  //nao imprimir notas com moeda diferente da escolhida
		if if((cAliasSF1)->F1_MOEDA==0,1,(cAliasSF1)->F1_MOEDA) != mv_par09
			lFiltro := .F.
		endif
	endif
	
	#IFDEF SHELL
		//��������������������������������������������������������������Ŀ
		//� Despreza Nota Fiscal Cancelada.                              �
		//����������������������������������������������������������������
		If (cAliasSD1)->D1_CANCEL == "S"
			lFiltro := .F.
		EndIf
	#ENDIF
	//��������������������������������������������������������������Ŀ
	//� Despreza Nota Fiscal sem TES de acordo com parametro         �
	//����������������������������������������������������������������
	If mv_par11 == 1 .And. Empty((cAliasSD1)->D1_TES)
		lFiltro := .F.
	Endif

	//��������������������������������������������������������������Ŀ
	//� VERIFICAR SE TEM O TES NA TABELA SF4, QDO TEM O PARAMETRO 11,�
	//� E SEM SER FILTRADO POR SQL QUERY.     MARCOS HIRAKAWA        �
	//����������������������������������������������������������������
	If lFiltro .AND. (!lQuery) .And.( mv_par11=1 ) .And. (!Empty((cAliasSD1)->D1_TES));
	.AND.  (!SF4->( DBSeek(xSF4 + (cAliasSD1)->D1_TES) ))
		lFiltro := .F.
	ENDIF

	If lFiltro
		
		If li > 59
			cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
		Endif
		// SO' IMPRIMIRA' B1_CODITE SE FOR NA ORDEM DE FORNECEDOR E DATA DE DIGITACAO!
		@ li,000 PSAY (cAliasSD1)->D1_DOC Picture PesqPict("SD1","D1_DOC",Len((cAliasSD1)->D1_DOC))

		IF lVEIC .AND. (nOrdem == 1 .OR. nOrdem == 2)
			If !lQuery
				dbSelectArea(cAliasSB1)
				dbSetOrder(1)
				MsSeek(xSB1 + (cAliasSD1)->D1_COD )
			ENDIF
			@ li,013+nIncCol PSAY '[ ' + (cAliasSB1)->B1_CODITE + ' ]'
			li++
		ENDIF
		@ li,013+nIncCol PSAY (cAliasSD1)->D1_COD Picture PesqPict("SD1","D1_COD",6)

		If !lQuery
			dbSelectArea(cAliasSB1)
			dbSetOrder(1)
			MsSeek(xSB1 + (cAliasSD1)->D1_COD )
		Endif

		@ li,029+nIncCol PSAY Substr((cAliasSB1)->B1_DESC,1,30)
		
		dbSelectArea(cAliasSD1)
		
		If cPaisLoc <> "BRA"
			aImpostos:=TesImpInf((cAliasSD1)->D1_TES)
			nImpInc	:=	0
			nImpNoInc:=	0
			nImpos	:=	0
			For nY:=1 to Len(aImpostos)
				cCampImp:=(cAliasSD1)+"->"+(aImpostos[nY][2])
				nImpos:=&cCampImp
				nImpos:=xmoeda(nImpos,nMoeda,mv_par09,dDtDig,nDecs+1,nTaxa)
				If ( aImpostos[nY][3]=="1" )
					nImpInc	+=nImpos
				Else
					If aImpostos[nY][3]=="2"
						nImpInc-=nImpos
					Else
						nImpNoInc+=nImpos
					Endif
				EndIf
			Next
			aTotais[01] += nImpNoInc // Total imposto nao incluido / NF
			aTotais[02] += nImpInc   // Total imposto incluido     / NF
			aTotais[03] += nImpNoInc // Total imposto nao incluido / Fornecedor
			aTotais[04] += nImpInc   // Total imposto incluido     / Fornecedor
			aTotais[05] += nImpNoInc // Total imposto nao incluido / Data
			aTotais[06] += nImpInc   // Total imposto incluido     / Data
			aTotais[07] += nImpNoInc // Total imposto nao incluido / Grupo
			aTotais[08] += nImpInc   // Total imposto incluido     / Grupo
			aTotais[09] += nImpNoInc // Total imposto nao incluido / Tipo
			aTotais[10] += nImpInc   // Total imposto incluido     / Tipo
			aTotais[11] += nImpNoInc // Geral imposto nao incluido
			aTotais[12] += nImpInc   // Geral imposto incluido
		Endif
		
		@ li,060+nIncCol PSAY (cAliasSD1)->D1_QUANT    Picture PesqPict("SD1","D1_QUANT",16)
		@ li,077+nIncCol PSAY (cAliasSD1)->D1_UM       Picture PesqPict("SD1","D1_UM",2)
		@ li,080+nIncCol PSAY xmoeda((cAliasSD1)->D1_VUNIT,(cAliasSF1)->F1_MOEDA,mv_par09,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA) Picture PesqPict("SD1","D1_VUNIT",16,mv_par09)
		
		If cPaisloc=="BRA"
			@ li,097 PSAY (cAliasSD1)->D1_IPI  Picture PesqPict("SD1","D1_IPI",5)
			@ li,103 PSAY xmoeda((cAliasSD1)->D1_TOTAL,(cAliasSF1)->F1_MOEDA,mv_par09,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA) Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
			@ li,120 PSAY (cAliasSD1)->D1_PICM Picture PesqPict("SD1","D1_PICM",5)
			@ li,126 PSAY (cAliasSD1)->D1_FORNECE
		Else
			@ li,097+nIncCol PSAY nImpNoInc   	Picture TM(nImpNoInc,12)
			@ li,110+nIncCol PSAY xmoeda((cAliasSD1)->D1_TOTAL,(cAliasSF1)->F1_MOEDA,mv_par09,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA) Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
			@ li,127+nIncCol PSAY nImpInc     	Picture TM(nImpInc,12)
			@ li,140+nIncCol PSAY (cAliasSD1)->D1_FORNECE
		Endif
		//���������������������������������������������������������������Ŀ
		//� Exibir Cod. e Nome do Fornecedor/Cliente conf. o tipo da Nota �
		//�����������������������������������������������������������������
		If (cAliasSD1)->D1_TIPO $ "DB"
			If !lQuery
				dbSelectArea(cAliasSA1)
				dbSetOrder(1)
				If MsSeek(xSA1 + (cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)
					If cPaisLoc == "BRA"
						@ li,nPosNome PSAY Substr((cAliasSA1)->A1_NOME,1,nTamNome)
					Else
						@ li,147+nIncCol PSAY Left((cAliasSA1)->A1_NREDUZ,nTamReduz-nIncCol)
					EndIf
				Endif
			Else
				If cPaisLoc == "BRA"
					@ li,nPosNome PSAY Substr((cAliasSA1)->A1_NOME,1,nTamNome)
				Else
					@ li,147+nIncCol PSAY Left((cAliasSA1)->A1_NREDUZ,nTamReduz-nIncCol)
				EndIf
			Endif
		Else
			If !lQuery
				dbSelectArea(cAliasSA2)
				dbSetOrder(1)
				If MsSeek(xSA2 + (cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)
					If cPaisLoc == "BRA"
						@ li,nPosNome PSAY Substr((cAliasSA2)->A2_NOME,1,nTamNome)
					Else
						@ li,147+nIncCol PSAY Left((cAliasSA2)->A2_NREDUZ,nTamReduz-nIncCol)
					EndIf
				Endif
			Else
				If cPaisLoc == "BRA"
					@ li,nPosNome PSAY Substr((cAliasSA2)->A1_NOME,1,nTamNome)
				Else
					@ li,147+nIncCol PSAY Left((cAliasSA2)->A1_NREDUZ,nTamReduz-nIncCol)
				Endif
			Endif
		EndIf
		
		dbSelectArea(cAliasSD1)
		
		@ li,174 PSAY (cAliasSD1)->D1_TIPO		Picture PesqPict("SD1","D1_TIPO",2)
		@ li,177 PSAY (cAliasSD1)->D1_TES		Picture PesqPict("SD1","D1_TES",3)
		@ li,181 PSAY (cAliasSD1)->D1_TP		Picture PesqPict("SD1","D1_TP",2)
		@ li,185 PSAY (cAliasSD1)->D1_GRUPO		Picture PesqPict("SD1","D1_GRUPO",4)
		@ li,191 PSAY (cAliasSD1)->D1_DTDIGIT
		nAuxCus:=xmoeda((cAliasSD1)->D1_CUSTO,1,mv_par09,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA)
		@ li,201 PSAY nAuxCus					Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
		@ li,218 PSAY (cAliasSD1)->D1_LOCAL		Picture PesqPict("SD1","D1_LOCAL",2)
		
		If !lQuery .Or. mv_par11 == 2
			dbSelectArea(cAliasSF4)
			MsSeek(xSF4 + (cAliasSD1)->D1_TES)
		Endif
		
		If (cAliasSF4)->F4_AGREG <> "N"
			nTotForn += nAuxCus //D1_CUSTO
			nTotProd += nAuxCus //D1_CUSTO
			nTotal   += nAuxCus //D1_CUSTO
			nTotDtCus+= nAuxCus //D1_CUSTO
			nAuxTot:=xmoeda((cAliasSD1)->D1_TOTAL,(cAliasSF1)->F1_MOEDA,mv_par09,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA)
			nTotQt   += (cAliasSD1)->D1_QUANT
			nTotVal  += nAuxTot //D1_TOTAL
			nTotQt1  += (cAliasSD1)->D1_QUANT
			nTotVal1 += nAuxTot //D1_TOTAL
			nTotQt2  += (cAliasSD1)->D1_QUANT          // Total Geral da Quant.
			nTotVal2 += nAuxTot //D1_TOTAL   // Total Geral do Valor
			nTotQt3  += (cAliasSD1)->D1_QUANT
			nTotVal3 += nAuxTot //D1_TOTAL
			nTotDtQt += (cAliasSD1)->D1_QUANT
			nTotDtVal+= nAuxTot //D1_TOTAL
		Endif
		//���������������������������������������������������������������Ŀ
		//� Verificar a existencia de Devolucoes de Compras.              �
		//�����������������������������������������������������������������
		dbSelectArea(cAliasSD1)
		If (cAliasSD1)->D1_QTDEDEV <> 0 .And. mv_par07 == 1
			AADD(aRec,Iif(lQuery,(cAliasSD1)->SD1RECNO,Recno()))
		Endif
		nCnt+=1
		li++
		
	Endif
	
	dbSelectArea(cAliasSD1)
	dbSkip()
	IncRegua()
   IF ! lVEIC
   
		lFiltro := Iif(((cAliasSD1)->D1_COD < mv_par01 .Or. (cAliasSD1)->D1_COD > mv_par02) .Or.;
		((cAliasSD1)->D1_DTDIGIT < mv_par03 .Or. (cAliasSD1)->D1_DTDIGIT > mv_par04) .Or.;
		((cAliasSD1)->D1_FORNECE < mv_par05 .Or. (cAliasSD1)->D1_FORNECE > mv_par06),.F.,.T.)
		
	ELSE
		
		If ;
      ( SB1->(DBSEEK( XSB1 + (cAliasSD1)->D1_COD )) .AND. ;
       (SB1->B1_CODITE < mv_par01 .OR. SB1->B1_CODITE > mv_par02);
      );
		.Or.;
		( (cAliasSD1)->D1_DTDIGIT < mv_par03 .Or. (cAliasSD1)->D1_DTDIGIT > mv_par04 );
		.Or.;
		( (cAliasSD1)->D1_FORNECE < mv_par05 .Or. (cAliasSD1)->D1_FORNECE > mv_par06 )
		
			lFiltro := .F.
		else
			lFiltro := .T.
		Endif
		
	ENDIF
	//��������������������������������������������������������������Ŀ
	//� Verifica o Filtro do usuario                                 �
	//����������������������������������������������������������������
	If !Empty(aReturn[7]) .And. lFiltro
		lFiltro := Iif(&(aReturn[7]),.T.,.F.)
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Verifica Moeda                                               �
	//����������������������������������������������������������������
	if mv_par10==2  //nao imprimir notas com moeda diferente da escolhida
		if if((cAliasSF1)->F1_MOEDA==0,1,(cAliasSF1)->F1_MOEDA) != mv_par09
			lFiltro := .F.
		endif
	endif
	
	#IFDEF SHELL
		//��������������������������������������������������������������Ŀ
		//� Despreza Nota Fiscal Cancelada.                              �
		//����������������������������������������������������������������
		If (cAliasSD1)->D1_CANCEL == "S"
			lFiltro := .F.
		EndIf
	#ENDIF
	//��������������������������������������������������������������Ŀ
	//� Despreza Nota Fiscal sem TES de acordo com parametro         �
	//����������������������������������������������������������������
	If mv_par11 == 1 .And. Empty((cAliasSD1)->D1_TES)
		lFiltro := .F.
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� VERIFICAR SE TEM O TES NA TABELA SF4, QDO TEM O PARAMETRO 11,�
	//� E SEM SER FILTRADO POR SQL QUERY.     MARCOS HIRAKAWA        �
	//����������������������������������������������������������������
	If lFiltro .AND. (!lQuery) .And.( mv_par11=1 ) .And. (!Empty((cAliasSD1)->D1_TES));
	.AND.  (!SF4->( DBSeek(xSF4 + (cAliasSD1)->D1_TES) ))
		lFiltro := .F.
	ENDIF

	If ;
	(;
	 (;
	  ( (cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE <> cCodAnt+cSerNF+cForna .And. nOrdem <3 );
    .Or.;
     ( (cAliasSD1)->D1_COD <> cProdAnt .And. nOrdem >2);
    );
    .And.;
	 lFiltro;
	);
	.Or.;
	Eof()
		
		nSaveRec := Iif( lQuery, (cAliasSD1)->SD1RECNO, Recno() )
		
		If nCnt >= 1 .And. nOrdem < 3
			ImpTotN(nTotProd,titulo,nOrdem,aTotais,nIncCol)
			aTotais[1] := 0 // Total imposto nao incluido / NF
			aTotais[2] := 0 // Total imposto incluido     / NF
		Endif
		
		//���������������������������������������������������������������Ŀ
		//� Tratar Devolucoes de Compras.                                 �
		//�����������������������������������������������������������������
		
		For i:=1 to Len(aRec)
			
			dbSelectArea("SD1")
			dbGoto(aRec[i])
			dbSelectArea("SD2")
			MsSeek(SD1->D1_COD+SD1->D1_DOC+SD1->D1_ITEM+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
			SF2->(MsSeek(SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA))
			
			nTaxa   :=SF2->F2_TXMOEDA
			nMoeda  :=SF2->F2_MOEDA
			dDtDig  :=SF2->F2_EMISSAO
			
			While !Eof() .And. SD1->D1_COD+SD1->D1_DOC+SD1->D1_ITEM+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA ==;
				SD2->D2_COD+SD2->D2_NFORI+SD2->D2_ITEMORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA
				
				dbSelectArea("SF4")

				if !empty(SD2->D2_TES) .and. MsSeek(xSF4 + SD2->D2_TES)

					dbSelectArea("SD2")
					If i == 1
						@ li++,000 PSAY STR0012		//'-Devolucoes:'
					Endif
					
					@ li,000 PSAY SD2->D2_DOC Picture PesqPict("SD2","D2_DOC",Len((cAliasSD1)->D1_DOC))
	
					IF lVEIC .AND. (nOrdem == 1 .OR. nOrdem == 2)
						If !lQuery
							dbSelectArea(cAliasSB1)
							dbSetOrder(1)
							MsSeek(xSB1 + SD1->D1_COD)
						ENDIF
						@ li,013+nIncCol PSAY '[ ' + (cAliasSB1)->B1_CODITE + ' ]'
						li++
					ENDIF
	
					@ li,013+nIncCol PSAY SD2->D2_COD Picture PesqPict("SD2","D2_COD",6)
					
					dbSelectArea("SB1")
					dbSetOrder(1)
					If MsSeek(xSB1 + SD1->D1_COD,.F.)
						@ li,029+nIncCol PSAY Substr(SB1->B1_DESC,1,30)
					Endif
					
					dbSelectArea("SD2")
					
					If cPaisLoc <> "BRA"
						aImpostos:=TesImpInf(SD2->D2_TES)
						nImpInc	:=	0
						nImpNoInc:=	0
						nImpos	:=	0
						For nY:=1 to Len(aImpostos)
							cCampImp:="SD2->"+(aImpostos[nY][2])
							nImpos:=&cCampImp
							nImpos:=xmoeda(nImpos,nMoeda,mv_par09,dDtDig,nDecs+1,nTaxa)
							If ( aImpostos[nY][3]=="1" )
								nImpInc	+=nImpos
							Else
								If aImpostos[nY][3]=="2"
									nImpInc-=nImpos
								Else
									nImpNoInc+=nImpos
								Endif
							EndIf
						Next
						aTotais[01] += nImpNoInc // Total imposto nao incluido / NF
						aTotais[02] += nImpInc   // Total imposto incluido     / NF
						aTotais[03] += nImpNoInc // Total imposto nao incluido / Fornecedor
						aTotais[04] += nImpInc   // Total imposto incluido     / Fornecedor
						aTotais[05] += nImpNoInc // Total imposto nao incluido / Data
						aTotais[06] += nImpInc   // Total imposto incluido     / Data
						aTotais[07] += nImpNoInc // Total imposto nao incluido / Grupo
						aTotais[08] += nImpInc   // Total imposto incluido     / Grupo
						aTotais[09] += nImpNoInc // Total imposto nao incluido / Tipo
						aTotais[10] += nImpInc   // Total imposto incluido     / Tipo
						aTotais[11] += nImpNoInc // Geral imposto nao incluido
						aTotais[12] += nImpInc   // Geral imposto incluido
					Endif
					
					@ li,060+nIncCol PSAY SD2->D2_QUANT * -1 Picture PesqPict("SD2","D2_QUANT",16)
					@ li,077+nIncCol PSAY SD2->D2_UM		  Picture PesqPict("SD2","D2_UM",2)
					@ li,080+nIncCol PSAY xmoeda(SD2->D2_PRCVEN,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA) Picture PesqPict("SD2","D2_PRCVEN",16,mv_par09)
					
					If cPaisloc=="BRA"
						@ li,097 PSAY SD2->D2_IPI		Picture PesqPict("SD2","D2_IPI",5)
						@ li,103 PSAY xmoeda(SD2->D2_TOTAL * -1,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)	Picture PesqPict("SD2","D2_TOTAL",16,mv_par09)
						@ li,120 PSAY SD2->D2_PICM		Picture PesqPict("SD2","D2_PICM",5)
						@ li,126 PSAY SD2->D2_CLIENTE
					Else
						@ li,097+nIncCol PSAY nImpNoInc   Picture  TM(nImpNoInc,12)
						@ li,110+nIncCol PSAY xmoeda(D2_TOTAL * -1,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)	Picture PesqPict("SD2","D2_TOTAL",16,mv_par09)
						@ li,127+nIncCol PSAY nImpInc     Picture  TM(nImpInc,12)
						@ li,140+nIncCol PSAY SD2->D2_CLIENTE
					Endif
					
					//���������������������������������������������������������������Ŀ
					//� Exibir Cod. e Nome do Fornecedor/Cliente conf. o tipo da Nota �
					//�����������������������������������������������������������������
					
					dbSelectArea("SA2")
					dbSetOrder(1)
					If MsSeek(xSA2 + SD2->D2_CLIENTE + SD2->D2_LOJA)
						If cPaisLoc == "BRA"
							@ li,nPosNome  PSAY Substr(("SA2")->A2_NOME,1,nTamNome)
						Else
							@ li,147+nIncCol PSAY Left(("SA2")->A2_NREDUZ,nTamReduz-nIncCol)
						EndIf
					Endif
					
					dbSelectArea("SD2")
					
					@ li,174 PSAY SD2->D2_TIPO		Picture PesqPict("SD2","D2_TIPO",2)
					@ li,177 PSAY SD2->D2_TES		Picture PesqPict("SD2","D2_TES",3)
					@ li,181 PSAY SD2->D2_TP		Picture PesqPict("SD2","D2_TP",1)
					@ li,185 PSAY SD2->D2_GRUPO		Picture PesqPict("SD2","D2_GRUPO",4)
					@ li,191 PSAY SD2->D2_EMISSAO
					@ li,201 PSAY xmoeda(SD2->D2_CUSTO1 * -1,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)  Picture PesqPict("SD2","D2_CUSTO1",15,mv_par09)
					@ li,218 PSAY SD2->D2_LOCAL		Picture PesqPict("SD2","D2_LOCAL",2)
					
					dbSelectArea("SF4")
					MsSeek(xSF4 + SD2->D2_TES)
					
					If SF4->F4_AGREG <> "N"
						nAuxCus:=xmoeda(SD2->D2_CUSTO1,1,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
						nAuxTot:=xmoeda(SD2->D2_TOTAL,SF2->F2_MOEDA,mv_par09,SF2->F2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
						nTotQt1  -= SD2->D2_QUANT
						nTotVal1 -= nAuxTot //D2_TOTAL
						nTotQt2  -= SD2->D2_QUANT
						nTotVal2 -= nAuxTot //D2_TOTAL
						nTotForn -= nAuxCus //D2_CUSTO1
						nTotal   -= nAuxCus //D2_CUSTO1
						nTotDtQt  -= SD2->D2_QUANT
						nTotDtVal -= nAuxTot //D2_TOTAL
						nTotDtCus -= nAuxCus //D2_CUSTO1
						
						nTotQt   -= SD2->D2_QUANT
						nTotVal  -= nAuxTot //D2_TOTAL
						nTotQt3  -= SD2->D2_QUANT
						nTotVal3 -= nAuxTot //D2_TOTAL
						nTotProd -= nAuxCus //D2_CUSTO1
						
					Endif
					
					li++
				endif	
				dbSelectArea("SD2")
				dbSkip()
				
			EndDo
			
			dbSelectArea(cAliasSD1)
			
		Next
		
		dbgoto(nSaveRec)
		// Alterei a posicao da linha abaixo ! marcos hirakawa.
		// aRec := {}
		dbSelectArea(cAliasSD1)

		If nOrdem == 1 .Or. nOrdem == 2
			
			If Len(aRec) <> 0
				@ li++,000 PSAY Replicate('-',220)
			Endif
			
			If nCnt >= 1
				
				If  nOrdem == 1 .and. (cAliasSD1)->D1_FORNECE <> cQuebra .Or. nOrdem == 2 .and. (cAliasSD1)->D1_FORNECE <> cForna
					ImpTotF(nTotForn,titulo,nOrdem,nTotQt1,nTotVal1,aTotais,nIncCol)
					aTotais[3] := 0 // Total imposto nao incluido / Fornecedor
					aTotais[4] := 0 // Total imposto incluido     / Fornecedor
					nTotForn   := 0
					ntotQt1    := 0
					nTotVal1   := 0
				Endif
				
				IF nOrdem == 2 .and. (cAliasSD1)->D1_DTDIGIT <> cQuebraDtDig
					ImpTotDt(nTotDtCus,titulo,nOrdem,nTotDtQt,nTotDtVal,cQuebraDtDig,aTotais,nIncCol)
					aTotais[5] := 0 // Total imposto nao incluido / Data
					aTotais[6] := 0 // Total imposto incluido     / Data
					nTotDtVal  := 0
					nTotDtCus  := 0
					nTotDtQt   := 0
				Endif
				
			Endif
			
			If !lQuery
				//��������������������������������������������������������������Ŀ
				//� posiciona o cabecalho da nota                                �
				//����������������������������������������������������������������
				(cAliasSF1)->(MsSeek((cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA))
			EndIf
			
			nTaxa   := (cAliasSF1)->F1_TXMOEDA
			nMoeda  := (cAliasSF1)->F1_MOEDA
			dDtDig  := (cAliasSF1)->F1_DTDIGIT
			cCodAnt := (cAliasSD1)->D1_DOC
			cForna  := (cAliasSD1)->D1_FORNECE
			cSerNf  := (cAliasSD1)->D1_SERIE
			nTotProd:= 0
			nTotQt  := 0
			nTotVal := 0
			nCnt    := 0
			
			If nOrdem == 1
				cQuebra      := (cAliasSD1)->D1_FORNECE
			Elseif nOrdem == 2
				cQuebraDtDig := (cAliasSD1)->D1_DTDIGIT
			Endif
			
		Else
			
			If (nTotProd <> 0 .Or. cProdAnt <> (cAliasSD1)->D1_COD) .And. nCnt >= 1
				ImpTotPr(nTotProd,cTipGrp,titulo,nOrdem,cProdAnt,nIncCol)
			EndIf
			nTotGrp += nTotProd
			nTotProd := 0
			nTotQt   := 0
			nTotVal  := 0
			cProdAnt := (cAliasSD1)->D1_COD
			nCnt     := 0
			
			If IIf(nOrdem == 3,(cAliasSD1)->D1_TP+(cAliasSD1)->D1_GRUPO <> cTipGrp,(cAliasSD1)->D1_GRUPO <> cGrpAnt)
				If nTotGrp <> 0
					ImpTotGrp(nTotGrp,cGrpAnt,cTipAnt,titulo,nOrdem,nTotQt1,nTotVal1,aTotais,nIncCol)
					aTotais[07] := 0 // Total imposto nao incluido / Grupo
					aTotais[08] := 0 // Total imposto incluido     / Grupo
				EndIf
				nTotTip += nTotGrp
				nTotGrp  := 0
				nTotQT1  := 0
				nTotVal1 := 0
				cTipGrp  := (cAliasSD1)->D1_TP+(cAliasSD1)->D1_GRUPO
				cGrpAnt  := (cAliasSD1)->D1_GRUPO
			Endif
			
			If IIf(nOrdem == 3,(cAliasSD1)->D1_TP <> cTipAnt,.t.)
				If nTotTip <> 0 .and. nOrdem == 3
					ImpTotTip(nTotTip,cTipAnt,titulo,nOrdem,nTotQt3,nTotVal3,aTotais,nIncCol)
					aTotais[09] := 0 // Total imposto nao incluido / Tipo
					aTotais[10] := 0 // Total imposto incluido     / Tipo
				EndIf
				nTotTip := 0
				nTotQt3 := 0
				nTotVal3:= 0
				cTipAnt := (cAliasSD1)->D1_TP
			Endif
			
		Endif
		// Alterado a posicao da linha abaixo ! ver acima ! marcos hirakawa.
		aRec := {}
		
	Endif
	
EndDo

If li <> 80
	If nTotal <> 0
		If li > 55
			cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
		Else
			If nOrdem == 2
				li++
			Endif
		Endif
		
		@ li,000 PSAY STR0013		//"TOTAL GERAL       --> "
		@ li,060+nIncCol	 PSAY nTotQt2  	Picture PesqPict("SD1","D1_QUANT",16)
		If cPaisLoc == "BRA"
			@ li,103		 PSAY nTotVal2  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
		Else
			@ li,097+nIncCol PSAY aTotais[11] 	Picture TM(aTotais[7],12)
			@ li,110+nIncCol PSAY nTotVal2  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
			@ li,127+nIncCol PSAY aTotais[12] 	Picture TM(aTotais[8],12)
		EndIf
		@ li,201 PSAY nTotal    		Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
		li++
		Roda(CbCont,"NOTAS","G")
	Endif
Endif

#IFDEF TOP
	dbSelectArea(cAliasSD1)
	dbCloseArea()
#ENDIF

RetIndex("SD1")
dbSelectArea("SD1")
dbClearFilter()
dbSetOrder(1)

RetIndex("SD2")
dbSelectArea("SD2")
dbClearFilter()
dbSetOrder(1)

If File(cNomeArq+OrdBagExt())
	Ferase(cNomeArq+OrdBagExt())
Endif

If File(cNomeArq1+OrdBagExt())
	Ferase(cNomeArq1+OrdBagExt())
EndIf

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpTotPr � Autor � Paulo Boschetti       � Data � 28.12.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime total do produto                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpTotPr(ExpN1,ExpC1,ExpC2,ExpN2,ExpC3,ExpN3)              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1: Total custo do produto                              ���
���          � ExpC1: Grupo do produto                                    ���
���          � ExpC2: Titulo do relat.                                    ���
���          � ExpN2: ordem do relat.                                     ���
���          � ExpC3: Cod.do produto                                      ���
���          � ExpN3: incremento na coluna devido tam.do campo documento  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR090                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpTotPr(nTotProd,cTipGrp,titulo,nOrdem,cProdAnt,nIncCol)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
IF ! lVEIC
	@ li,000 PSAY STR0014		//"TOTAL PRODUTO     --> "
ELSE
   SB1->(DBSETORDER(1))
   SB1->(DBSEEK(XSB1 + cProdAnt))
	@ li,000 PSAY SUBSTR(cCABPROD,1,nCOL2) + ' [ ' + SB1->B1_CODITE + ' ] ' +;
	SUBSTR(cCABPROD,nCOL2 + 1)
	
ENDIF	
@ li,060+nIncCol 	 PSAY nTotQt   	Picture PesqPict("SD1","D1_QUANT",16)
If cPaisLoc == "BRA"
	@ li,103		 PSAY nTotVal  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
Else
	@ li,110+nIncCol PSAY nTotVal  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
EndIf
@ li,201 PSAY nTotProd 		Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
li++
Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpTotGrp� Autor � Paulo Boschetti       � Data � 28.12.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime total do Grupo                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpTotGrp(ExpN1,ExpC1,ExpC2,ExpC3,ExpN2,ExpN3,ExpN4,ExpA1, ���
���          �           ExpN5)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1: Total custo do grupo                                ���
���          � ExpC1: Grupo do produto                                    ���
���          � ExpC2: Tipo do produto                                     ���
���          � ExpC3: Titulo do relat.                                    ���
���          � ExpN2: ordem do relat.                                     ���
���          � ExpN3: total qtde. do grupo                                ���
���          � ExpN4: total valor do grupo                                ���
���          � ExpA1: array totais IMP.                                   ���
���          � ExpN5: incremento na coluna devido tam.do campo documento  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR090                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpTotGrp(nTotGrp,cGrupo,cTipAnt,titulo,nOrdem,nTotQt1,nTotVal1,aTotais,nIncCol)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
@ li,000 PSAY STR0015+cGrupo+"  --> "		//"TOTAL GRUPO "
@ li,060+nIncCol	 PSAY nTotQt1  	Picture PesqPict("SD1","D1_QUANT",16)
If cPaisLoc == "BRA"
	@ li,103		 PSAY nTotVal1 	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
Else
	@ li,097+nIncCol PSAY aTotais[07] 	Picture TM(aTotais[07],12)
	@ li,110+nIncCol PSAY nTotVal1 		Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
	@ li,127+nIncCol PSAY aTotais[08] 	Picture TM(aTotais[08],12)
EndIf
@ li,201 PSAY nTotGrp  			Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
If nOrdem == 4
	li+=2
Else
	li++
Endif
Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpTotTip� Autor � Paulo Boschetti       � Data � 28.12.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime Total do Tipo                                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpTotTip(ExpN1,ExpC1,ExpC2,ExpN2,ExpN3,ExpN4,ExpA1,ExpN5) ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1: Total custo do tipo prod.                           ���
���          � ExpC1: Tipo do produto                                     ���
���          � ExpC2: Titulo do relat.                                    ���
���          � ExpN2: ordem do relat.                                     ���
���          � ExpN3: total qtde. do tipo prod.                           ���
���          � ExpN4: total valor do tipo prod                            ���
���          � ExpA1: array totais IMP.                                   ���
���          � ExpN5: incremento na coluna devido tam.do campo documento  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR090                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpTotTip(nTotTip,cTipo,titulo,nOrdem,nTotQt3,nTotVal3,aTotais,nIncCol)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
@ li,000 PSAY STR0016+cTipo+"    --> "		//"TOTAL TIPO  "
@ li,060+nIncCol 	 PSAY nTotQt3   	Picture PesqPict("SD1","D1_QUANT",16)
If cPaisLoc == "BRA"
	@ li,103		 PSAY nTotVal3  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
Else
	@ li,097+nIncCol PSAY aTotais[09] 	Picture TM(aTotais[09],12)
	@ li,110+nIncCol PSAY nTotVal3  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
	@ li,127+nIncCol PSAY aTotais[10] 	Picture TM(aTotais[10],12)
EndIf
@ li,201 PSAY nTotTip   		Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
li+=2
Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpTotN  � Autor � Paulo Boschetti       � Data � 28.12.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime Total da Nota Fiscal                               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpTotN(ExpN1,ExpC1,ExpN2,ExpA1,ExpN3)		              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1: Total custo da nota                                 ���
���          � ExpC1: Titulo do relat.                                    ���
���          � ExpN2: ordem do relat.                                     ���
���          � ExpA1: array totais IMP.                                   ���
���          � ExpN3: incremento na coluna devido tam.do campo documento  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR090                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpTotN(nTotProd,titulo,nOrdem,aTotais,nIncCol)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
If nTotVal <> 0 .Or. nTotProd <> 0
	@ li,000 PSAY STR0017		//"TOTAL NOTA FISCAL --> "
	@ li,060+nIncCol	 PSAY nTotQt 		Picture PesqPict("SD1","D1_QUANT",16)
	If cPaisLoc == "BRA"
		@ li,103 	 	 PSAY nTotVal		Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
	Else
		@ li,097+nIncCol PSAY aTotais[1] 	Picture TM(aTotais[1],12)
		@ li,110+nIncCol PSAY nTotVal	  	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
		@ li,127+nIncCol PSAY aTotais[2] 	Picture TM(aTotais[2],12)
	EndIf
	@ li,201 PSAY nTotProd			Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
	li+=1
EndIf
Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpTotF  � Autor � Paulo Boschetti       � Data � 28.12.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime Total do Fornecedor                                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpTotF(ExpN1,ExpC1,ExpN2,ExpN3,ExpN4,ExpA1,ExpN5)		  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1: Total custo do fornecedor                           ���
���          � ExpC1: Titulo do relat.                                    ���
���          � ExpN2: ordem do relat.                                     ���
���          � ExpN3: total qtde. do fornecedor                           ���
���          � ExpN4: total valor do fornecedor                           ���
���          � ExpA1: array totais IMP.                                   ���
���          � ExpN5: incremento na coluna devido tam.do campo documento  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR090                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpTotF(nTotProd,titulo,nOrdem,nTotQt1,nTotVal1,aTotais,nIncCol)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
If nTotVal1 <> 0 .Or. nTotProd <> 0
	@ li,000 PSAY STR0018		//"TOTAL FORNECEDOR  --> "
	@ li,060+nIncCol	 PSAY nTotQt1  	Picture PesqPict("SD1","D1_QUANT",16)
	If cPaisLoc == "BRA"
		@ li,103		 PSAY nTotVal1 	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
	Else
		@ li,097+nIncCol PSAY aTotais[3] 	Picture TM(aTotais[3],12)
		@ li,110+nIncCol PSAY nTotVal1 	Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
		@ li,127+nIncCol PSAY aTotais[4] 	Picture TM(aTotais[4],12)
	EndIf
	@ li,201 PSAY nTotProd 			Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
	li+=2
EndIf
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpTotDt � Autor � Rogerio F. Guimaraes  � Data � 05.12.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime Total das Notas por data de digitacao              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpTotDT(ExpN1,ExpC1,ExpN2,ExpN3,ExpN4,ExpC2,ExpA1,ExpN5)  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1: Total custo da data		                          ���
���          � ExpC1: Titulo do relat.                                    ���
���          � ExpN2: ordem do relat.                                     ���
���          � ExpN3: total qtde. da data		                          ���
���          � ExpN4: total valor da data		                          ���
���          � ExpC2: data						                          ���
���          � ExpA1: array totais IMP.                                   ���
���          � ExpN5: incremento na coluna devido tam.do campo documento  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR090                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpTotDt(nTotCus,titulo,nOrdem,nTotQt,nTotVal,cQuebraDtDig,aTotais,nIncCol)
If li > 59
	cabec(titulo+" ("+alltrim(aOrd[nOrdem])+")",cabec1,cabec2,nomeprog,tamanho,15)
Endif
If nTotVal <> 0 .Or. nTotCus <> 0
	@ li,000 PSAY STR0019+DTOC(cQuebraDtDig) //"TOT.DA DATA "
	@ li,060+nIncCol	 PSAY nTotQt		Picture PesqPict("SD1","D1_QUANT",16)
	If cPaisLoc == "BRA"
		@ li,103 		 PSAY nTotVal		Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
	Else
		@ li,097+nIncCol PSAY aTotais[5] 	Picture TM(aTotais[5],12)
		@ li,110+nIncCol PSAY nTotVal		Picture PesqPict("SD1","D1_TOTAL",16,mv_par09)
		@ li,127+nIncCol PSAY aTotais[6] 	Picture TM(aTotais[6],12)
	EndIf
	@ li,201 PSAY nTotCus			Picture PesqPict("SD1","D1_CUSTO",15,mv_par09)
	li++
	@ li,000 PSAY Replicate("-",220)
	li+=1
EndIf
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Nereu Humberto Jr     � Data �08.12.2004���
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

Local aArea		:= GetArea()
Local aHelpP10	:= {}
Local aHelpE10	:= {}
Local aHelpS10	:= {}
Local aHelpP11  := {} 
Local aHelpE11  := {} 
Local aHelpS11  := {} 

Aadd( aHelpP10, "Indicar se as Notas Fiscais em          " )
Aadd( aHelpP10, "outras moedas devem ser convertidas para" )
Aadd( aHelpP10, " a moeda seleciona no parametro Qual Moe" )
Aadd( aHelpP10, "da, ou se nao devem ser impressas.      " )

Aadd( aHelpE10, "Determine if the list Invoices in other " )
Aadd( aHelpE10, "  currencies must be converted into the " )
Aadd( aHelpE10, "selected currency found in paramet Qhich" )
Aadd( aHelpE10, "Currency?,or if they must not be printed" )

Aadd( aHelpS10, "Indicar si las solo Facturas en         " )
Aadd( aHelpS10, "otras monedas deben convertirse a la    " )
Aadd( aHelpS10, "moneda seleccionada en el parametro     " )
Aadd( aHelpS10, "Cual Moneda? o si no deben imprimirse.  " )

Aadd( aHelpP11, "Listar apenas Notas Fiscais com TES     " )
Aadd( aHelpP11, "Sim ou Nao                              " )

Aadd( aHelpE11, "Only list Invoices with TES             " )
Aadd( aHelpE11, "Yes or No                               " )

Aadd( aHelpS11, "Listar solo Facturas con TES            " ) 
Aadd( aHelpS11, "Si o No                                 " ) 
      
PutSx1( "MTR090","11","Somente NF com TES ?"," Solo Fac. con TES ?","Only invoice with TIO ?","mv_chb",;
"N",1,0,0,"C","","","","S","mv_par11","Sim","Si","Yes","","Nao","No","No","","","","","","","","","","","","")

PutSX1Help("P.MTR09010.",aHelpP10,aHelpE10,aHelpS10)	 
PutSX1Help("P.MTR09011.",aHelpP11,aHelpE11,aHelpS11)	 

DbSelectArea("SX1")
DbSetOrder(1)

If (SX1->(DbSeek("MTR090    "+"07")))
	If SX1->X1_PERGUNT != PadR("Imprime Devolucao Compra ?",30)
		RecLock("SX1   ",.F.)
		Replace SX1->X1_PERGUNT With PadR("Imprime Devolucao Compra ?",30)
		MsUnlock()
	EndIf
	If SX1->X1_PERSPA != PadR("+Imprime Devolucion Compra ?",30)
		RecLock("SX1   ",.F.)
		Replace SX1->X1_PERSPA With PadR("+Imprime Devolucion Compra ?",30)
		MsUnlock()
	EndIf
	If SX1->X1_PERENG != PadR("+Print Purchase Return ?",30)
		RecLock("SX1   ",.F.)
		Replace SX1->X1_PERENG With PadR("+Print Purchase Return ?",30)
		MsUnlock()
	EndIf
Endif

If (SX1->(DbSeek("MTR090    "+"11")))
	If SX1->X1_PYME != "S"
		RecLock("SX1   ",.F.)
		Replace SX1->X1_PYME With "S"
		MsUnlock()
	EndIf
Endif

aHelpP10 := {}

Aadd( aHelpP10, "Considera a impressao das notas fiscais " )
Aadd( aHelpP10, "devolvidas no cadastro de itens do      " )
Aadd( aHelpP10, "documento de entrada (SD1, D1_TIPO = D)." )

Aadd( aHelpE10, "Considera la impresion de las facturas  " )
Aadd( aHelpE10, "devueltas en el registro de items del   " )
Aadd( aHelpE10, "documento de entrada (SD1, D1_TIPO = D)." )

Aadd( aHelpS10, "Considers printing of invoices returned " )
Aadd( aHelpS10, "in registration of items from inflow    " )
Aadd( aHelpS10, "document (SD1, D1_TIPO = D).			 " )

PutSx1( "MTR090","12","Imprime Devolucao Venda ?","Imprime Devolucion Venta ?","Print Sales Return ?","mv_chc",;
"N",1,0,1,"C","","","","S","mv_par12","Sim","Si","Yes","","Nao","No","No","","","","","","","","","","","","")

PutSX1Help("P.MTR09012.",aHelpP10,aHelpE10,aHelpS10)

RestArea(aArea)

Return
