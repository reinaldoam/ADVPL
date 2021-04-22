#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  RESUMO    ¦       ¦                      ¦ Data ¦ 10/07/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Resumo de Caixa - Agropisco                                   ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function RESUMO()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "RESUMO DE CAIXA - "+SM0->M0_FILIAL
Local nLin           := 01
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "RESU"+SM0->M0_CODFIL // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RESU"+SM0->M0_CODFIL // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := "RESU"+SM0->M0_CODFIL
Private cString      := "SE1"

CriaSx1()
Pergunte(cPerg,.F.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cFilia := xFilial("SE1")
Local cDATA  := DTOS(MV_PAR01)

Private nDinheiro := 0
Private nChequeAv := 0
Private nChequePr := 0
Private nCCAura   := 0
Private nCCDebito := 0
Private nCCVisa   := 0
Private nCCMaster := 0
Private nCCAmeric := 0
Private nCCDinner := 0
Private nCCVisaEl := 0
Private nCCRedeSh := 0
Private nCCCheque := 0
Private nBolBanco := 0
Private nNotaProm := 0
Private nDepConta := 0
Private nCarteira := 0
Private nSaldo    := 0
Private nDuplicat := 0
Private nCrediari := 0
Private nEmpenho  := 0
Private nChequeLi := 0
Private nBoletoLi := 0
Private nTransfer := 0
Private nEntrada  := 0
Private nSaida    := 0
Private nOutrosPg := 0
Private nSemClien := 0
Private nTotNotas := 0
Private nTotDesco := 0
Private nTotCredi := 0
Private nTotTroca := 0
Private nTotDevol := 0
Private nTotBrind := 0
Private nTotConsu := 0
Private nTotBruto := 0
Private nSubTotal := 0
Private nTotLiqui := 0
Private nTotApoli := 0
Private cMinApoli := ""
Private cMaxApoli := ""
Private nTotFatur := 0

DbSelectArea("SA6")
DbSetOrder(1)

DbSelectArea("SE8")
DbSetOrder(1)

PegaResumo()

nTotLiqui := nDinheiro + nChequeAv + nChequePr + nCCVisa   + nCCMaster + nCCAmeric + nCCDinner + nCCVisaEl
nTotLiqui += nCCRedeSh + nCCCheque + nBolBanco + nDepConta + nNotaProm + nCarteira + nDuplicat + nCrediari + nEmpenho + nCCDebito +  nCCAura + nChequeLi + nBoletoLi + nTotFatur
nTotLiqui += nOutrosPg + nSemClien - nTotDevol

nSubTotal := nTotLiqui + nTotDevol
nTotBruto := nSubTotal + nTotDesco + nTotTroca  + nTotCredi

nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1

@ nLin,001 PSAY "RESUMO FINANCEIRO NA DATA :       "+DTOC(MV_PAR01)+"   ("+If(Empty(mv_par02), "", mv_par02)+;
If( Empty(mv_par03) , "", If( Empty(mv_par03) , "", ", ")+mv_par03)+If( Empty(mv_par04) , "", If( Empty(mv_par02+mv_par03) , "", ", ")+mv_par04)+")"

nLin := nLin + 2
@ nLin,001 PSAY "TOTAL BRUTO EM NOTAS      : "+Transform(nTotBruto,"@E 999,999,999.99") ; nLin += 2
@ nLin,001 PSAY "DESCONTOS CONCEDIDOS      : "+Transform(nTotDesco,"@E 999,999,999.99") ; nLin += 2
If nTotCredi <> 0
	@ nLin,001 PSAY "CREDITOS CONCEDIDOS       : "+Transform(nTotCredi,"@E 999,999,999.99") ; nLin += 2
Endif
@ nLin,001 PSAY "TROCAS                    : "+Transform(nTotTroca,"@E 999,999,999.99") ; nLin += 2
@ nLin,001 PSAY "SUB-TOTAL                 : "+Transform(nSubTotal,"@E 999,999,999.99") ; nLin += 2
@ nLin,001 PSAY "DEVOLUCOES                : "+Transform(nTotDevol,"@E 999,999,999.99") ; nLin += 2
@ nLin,001 PSAY "TOTAL LIQUIDO             : "+Transform(nTotLiqui,"@E 999,999,999.99") ; nLin += 2
If nTotBrind <> 0
	@ nlin,001 PSAY "BRINDES                   : "+Transform(nTotBrind,"@E 999,999,999.99") ; nLin += 2
Endif
If nTotConsu <> 0
	@ nlin,001 PSAY "CONSUMOS                  : "+Transform(nTotConsu,"@E 999,999,999.99") ; nLin += 2
Endif
@ nLin,001 PSAY "NUMERO DE NOTAS EMITIDAS  : "+Transform(nTotNotas,"@E 999999,999,999")    ; nLin++
If nTotApoli > 0
	@ nLin,001 PSAY "NUMERO DE APOLICES        : "+Transform(nTotApoli,"@E 999999,999,999")+;
	"    DE "+cMinApoli+" A "+cMaxApoli ; nLin++
Endif
		
@ nLin,001 PSAY repli("-",130) ; nLin++
@ nLin,001 PSAY "TESOURARIA:"  ; nLin++
@ nLin,001 PSAY repli("-",130) ; nLin++
		
If nEntrada  <> 0
	@ nlin,001 PSAY " + ENTRADA NO CAIXA       : "+Transform(nEntrada ,"@E 999,999,999.99") ; nLin += 2
Endif
		
If nDinheiro <> 0
	@ nlin,001 PSAY " + VENDAS EM DINHEIRO     : "+Transform(nDinheiro,"@E 999,999,999.99") ; nLin += 2
Endif
		
If nSaida    <> 0
	@ nlin,001 PSAY " - SAIDA DO CAIXA         : "+Transform(nSaida   ,"@E 999,999,999.99") ; nLin += 2
Endif
@ nlin,030 PSAY   " ---------------"; nLin += 1
@ nlin,001 PSAY   " = DINHEIRO NO CAIXA      : "+Transform((nEntrada+nDinheiro)-nSaida,"@E 999,999,999.99") ; nLin += 2
		
If nChequeAv <> 0
	@ nlin,001 PSAY "CHEQUE                    : "+Transform(nChequeAv+nChequePr,"@E 999,999,999.99") ; nLin += 2
Endif

If nCCaura <> 0
	@ nlin,001 PSAY "CARTAO AURA               : "+Transform(nCCAura  ,"@E 999,999,999.99") ; nLin += 2
Endif
		
If nCCVisa   <> 0
	@ nlin,001 PSAY "CARTAO VISA               : "+Transform(nCCVisa  ,"@E 999,999,999.99") ; nLin += 2
Endif

If nCCDebito   <> 0
	@ nlin,001 PSAY "CARTAO DE DEBITO          : "+Transform(nCCDebito  ,"@E 999,999,999.99") ; nLin += 2
Endif

If nCCMaster <> 0
	@ nlin,001 PSAY "CARTAO MASTERCARD         : "+Transform(nCCMaster,"@E 999,999,999.99") ; nLin += 2
Endif

If nCCAmeric <> 0
	@ nlin,001 PSAY "CARTAO AMERICAN           : "+Transform(nCCAmeric,"@E 999,999,999.99") ; nLin += 2
Endif

If nCCDinner <> 0
	@ nlin,001 PSAY "CARTAO DINNERS            : "+Transform(nCCDinner,"@E 999,999,999.99") ; nLin += 2
Endif

If nCCVisaEl <> 0
	@ nlin,001 PSAY "VISA ELECTRON             : "+Transform(nCCVisaEl,"@E 999,999,999.99") ; nLin += 2
Endif

If nCCRedeSh <> 0
	@ nlin,001 PSAY "REDESHOP/MAESTRO          : "+Transform(nCCRedeSh,"@E 999,999,999.99") ; nLin += 2
Endif

If nCCCheque <> 0
	@ nlin,001 PSAY "CHEQUE ELETRONICO         : "+Transform(nCCCheque,"@E 999,999,999.99") ; nLin += 2
Endif

If nDepConta <> 0
	@ nlin,001 PSAY "DEPOSITO EM CONTA         : "+Transform(nDepConta,"@E 999,999,999.99") ; nLin += 2
Endif

If nBolBanco <> 0
	@ nlin,001 PSAY "BOLETO BANCARIO           : "+Transform(nBolBanco,"@E 999,999,999.99") ; nLin += 2
Endif

If nNotaProm <> 0
	@ nlin,001 PSAY "NOTA PROMISSORIA          : "+Transform(nNotaProm,"@E 999,999,999.99") ; nLin += 2
Endif

If nCarteira <> 0
	@ nlin,001 PSAY "CARTEIRA                  : "+Transform(nCarteira,"@E 999,999,999.99") ; nLin += 2
Endif

If nDuplicat <> 0
	@ nlin,001 PSAY "DUPLICATA                 : "+Transform(nDuplicat,"@E 999,999,999.99") ; nLin += 2
Endif

If nCrediari <> 0
	@ nlin,001 PSAY "FINANCIAMENTO             : "+Transform(nCrediari,"@E 999,999,999.99") ; nLin += 2
Endif

If nEmpenho  <> 0
	@ nlin,001 PSAY "EMPENHO                   : "+Transform(nEmpenho ,"@E 999,999,999.99") ; nLin += 2
Endif

If nChequeLi <> 0
	@ nlin,001 PSAY "CHEQUE A LIQUIDAR         : "+Transform(nChequeLi ,"@E 999,999,999.99") ; nLin += 2
EndIf

If nBoletoLi <> 0
	@ nlin,001 PSAY "BOLETO A LIQUIDAR         : "+Transform(nChequeLi ,"@E 999,999,999.99") ; nLin += 2
EndIf

If nOutrosPg <> 0
	@ nlin,001 PSAY "OUTROS PAGAMENTOS         : "+Transform(nOutrosPg,"@E 999,999,999.99") ; nLin += 2
Endif

If nSemClien > 0
	@ nlin,001 PSAY "RECEBIMENTO DIVERSOS      : "+Transform(nSemClien,"@E 999,999,999.99") ; nLin += 2
Endif
        
If nTotFatur > 0
	@ nlin,001 PSAY "FATURAMENTO SERVICOS      : "+Transform(nTotFatur,"@E 999,999,999.99") ; nLin += 2
Endif

If nLin < 57
	nLin := 57
Endif
@ nlin,001 PSAY " __________________          __________________" ; nLin++
@ nLin,001 PSAY "       CAIXA                      GERENTE      "
		
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return
		
////////////////////////////
Static Function PegaResumo()
Local cQry, nPerc, nValDev
Local cCX1    := If( Empty(MV_PAR02) , "ZZZ", MV_PAR02)
Local cCX2    := If( Empty(MV_PAR03) , "ZZZ", MV_PAR03)
Local cCX3    := If( Empty(MV_PAR04) , "ZZZ", MV_PAR04)
Local cFilSD2 := XFILIAL("SD2")
Local cFilSL4 := XFILIAL("SL4")
Local cFilSE5 := XFILIAL("SE5")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando creditos concedidos  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
cQry := "SELECT L1_DOC, L1_SERIE, L1_CLIENTE, L1_LOJA, L1_CREDITO FROM "+RetSQLName("SL1")+" WHERE "
cQry += "L1_EMISSAO = '"+Dtos(mv_par01)+"' AND L1_FILIAL = '"+XFILIAL("SL1")+"' AND D_E_L_E_T_ <> '*' AND "
cQry += "L1_TIPO = 'V' AND L1_OPERADO IN ('"+cCX1+"','"+cCX2+"','"+cCX3+"') AND L1_CREDITO <> 0"
		
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
		
While !Eof()
	//- Movimento bancario
	dbSelectArea("SE5")
	dbSetOrder(7)
	If !dbSeek(cFilSE5+TRB->(L1_SERIE+L1_DOC+"A"+"CR "+L1_CLIENTE+L1_LOJA))
	    nTotCredi += TRB->L1_CREDITO
	Endif
	dbSelectArea("TRB")
	dbSkip()
Enddo
dbCloseArea()
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando as vendas por forma de pagamento  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
cQry := "SELECT L1_CLIENTE, L1_LOJA, L1_SERIE, L1_DOC, L4_FORMA, L4_DATA, L4_VALOR, L4_ADMINIS, L4_TROCO "
cQry += "FROM "+RetSQLName("SL1")+" A, "+RetSQLName("SL4")+" B WHERE "
cQry += "L1_EMISNF = '"+Dtos(mv_par01)+"' AND L1_FILIAL = '"+XFILIAL("SL1")+"' AND A.D_E_L_E_T_ <> '*' AND "
cQry += "B.D_E_L_E_T_ <> '*' AND L1_FILIAL = L4_FILIAL AND L1_NUM = L4_NUM AND L1_TIPO = 'V' AND "
cQry += "L1_OPERADO IN ('"+cCX1+"','"+cCX2+"','"+cCX3+"')"
		
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
		
TcSetField("TRB" , "L4_DATA", "D", 8, 0)  // Formata para tipo Data
		
dbSelectArea("TRB")
dbGoTop()
		
While !Eof()
	// Posiciona nos Itens da Nota Fiscal de Saida
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(cFilSD2+TRB->(L1_DOC+L1_SERIE+L1_CLIENTE+L1_LOJA)))
	// Acumula por Forma de Pagamento
	SomaForma(SubStr(L4_FORMA,1,2),L4_DATA,SubStr(L4_ADMINIS,1,3),L4_VALOR-L4_TROCO,L4_VALOR-L4_TROCO,1)
	dbSkip()
Enddo
dbCloseArea()
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificando as vendas feitas pelo faturamento ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
cQry := "SELECT ISNULL(SUM(D2_TOTAL),0)TOTAL FROM "+RetSQLName("SD2")+" SD2 "
cQry += " WHERE D2_FILIAL = '"+XFILIAL("SD2")+"' AND D2_EMISSAO = '"+Dtos(mv_par01)+"' "
cQry += "AND D2_TIPO ='N' AND D2_PEDIDO <> ' ' AND SD2.D_E_L_E_T_ <> '*' "
		
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
nTotFatur += TOTAL
dbCloseArea()
		
//- Quantidade de notas fiscais emitidas
cQry := "SELECT ISNULL(COUNT(*),0)TOTAL FROM "+RetSQLName("SF2")+" SF2 "
cQry += "WHERE F2_FILIAL = '"+XFILIAL("SF2")+"' AND F2_EMISSAO = '"+Dtos(mv_par01)+"' AND F2_TIPO ='N' AND "
cQry += "SF2.D_E_L_E_T_ <> '*'"
		
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
nTotNotas += TOTAL
dbCloseArea()
		
//- Soma o total dos descontos concedidos
cQry := "SELECT ISNULL(SUM(D2_DESCON),0)TOTAL FROM "+RetSQLName("SD2")+" SD2, "+RetSQLName("SL1")+" SL1 "
cQry += "WHERE D2_FILIAL = '"+XFILIAL("SD2")+"' AND D2_EMISSAO = '"+Dtos(mv_par01)+"' AND D2_TIPO ='N' AND "
cQry += "SD2.D_E_L_E_T_ <> '*' AND SL1.D_E_L_E_T_ <> '*' AND D2_FILIAL = L1_FILIAL AND D2_DOC = L1_DOC AND "
cQry += "D2_SERIE = L1_SERIE AND D2_CLIENTE = L1_CLIENTE AND D2_LOJA = L1_LOJA AND L1_OPERADO IN "
cQry += "('"+cCX1+"','"+cCX2+"','"+cCX3+"')"
		
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
nTotDesco += TOTAL
dbCloseArea()
		
//- Trocas e devolucoes
cQry := "SELECT D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_TOTAL, D1_VALDESC, L1_NUM, L1_VLRLIQ "
cQry += "FROM "+RetSQLName("SD1")+" A, "+RetSQLName("SL1")+" B "
cQry += "WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_=' ' AND D1_FILIAL=L1_FILIAL AND D1_TES = '132' AND "
cQry += "D1_NFORI=L1_DOC AND D1_SERIORI=L1_SERIE AND D1_TIPO='D' AND D1_DTDIGIT = '"+Dtos(mv_par01)+"' AND "
cQry += "L1_TIPO = 'V' AND D1_FILIAL = '"+XFILIAL("SD1")+"' AND "
cQry += "SUBSTRING(D1_NUMCQ,1,3) IN ('"+cCX1+"','"+cCX2+"','"+cCX3+"') AND D1_LOCAL = '01'"
		
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
		
dbSelectArea("TRB")
dbGoTop()
While !EOF()
	If PesqDevTrc() == "T"
		nTotTroca += D1_TOTAL - D1_VALDESC
	Else
		nTotDevol += D1_TOTAL - D1_VALDESC
	Endif
	dbSkip()
Enddo
dbCloseArea()
		
//- Entradas no Caixa
cQry1 := "SELECT ISNULL(SUM(E5_VALOR),0)ENTRADA FROM "+RetSQLName("SE5")
cQry1 += " WHERE E5_DATA = '"+Dtos(MV_par01)+"' "
cQry1 += " AND ((E5_RECPAG='R' AND E5_TIPODOC ='TR') OR (E5_RECPAG='R' AND E5_TIPODOC IN ('','VL','ES'))) AND "
cQry1 += " E5_HISTOR <> 'Estorno de transferencia.                              ' AND "
cQry1 += " E5_SITUACA <> 'C' AND "
cQry1 += " D_E_L_E_T_ <> '*' AND "
cQry1 += " E5_BANCO IN ("
cQry1 += " '"+cCX1+"','"+cCX2+"','"+cCX3+"')"
		
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry1)), "TRB", .T., .F. )
nEntrada += ENTRADA
dbCloseArea()
		
//- Saidas no Caixa
cQry2 := "SELECT ISNULL(SUM(E5_VALOR),0)SAIDA FROM "+RetSQLName("SE5")
cQry2 += " WHERE E5_DATA = '"+Dtos(MV_par01)+"' "
cQry2 += " AND ((E5_RECPAG='P' AND E5_TIPODOC ='TR') OR (E5_RECPAG='P' AND E5_TIPODOC IN ('','VL','ES','LJ') )) AND "
cQry2 += " E5_HISTOR <> 'Estorno de transferencia.                              ' AND "
cQry2 += " E5_SITUACA <> 'C' AND "
cQry2 += " D_E_L_E_T_ <> '*' AND "
cQry2 += " E5_BANCO IN ( "
cQry2 += "'"+cCX1+"','"+cCX2+"','"+cCX3+"')"
		
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry2)), "TRB", .T., .F. )
nSaida += SAIDA
dbCloseArea()
Return
		
////////////////////////////////////////////////////////////////////////
Static Function SomaForma(cTipo,dVencto,cCodCli,nValor,nVlrReal,nSinal)
Do Case
	Case cTipo == "R$"
		nDinheiro += (nValor * nSinal)                //- Dinheiro
	Case cTipo == "CH" .And. dVencto == mv_par01
		nChequeAv += (nValor * nSinal)                //- Cheque a vista
	Case cTipo == "CH" .And. dVencto <> mv_par01
		nChequePr += (nValor * nSinal)                //- Cheque pre-datado
	Case cTipo == "CC" .And. cCodCli $ "001#002"
		nCCMaster += (nVlrReal * nSinal)              //- Cartao Mastecard
	Case cTipo == "CD" .And. cCodCli == "003"
		nCCRedeSh += (nVlrReal * nSinal)              //- Redeshop
	Case cTipo == "CC" .And. cCodCli $ "005#009"
		nCCVisa   += (nVlrReal * nSinal)              //- Cartao Visa
	Case cTipo == "CC" .And. cCodCli $ "006#007"
		nCCDinner += (nVlrReal * nSinal)              //- Dinners
	Case cTipo == "CD" .And. cCodCli == "004"
		nCCVisaEl += (nVlrReal * nSinal)              //- Visa Eletron
	Case cTipo == "BO"
		nBolBanco += (nValor * nSinal)                //- Boleto
	Case cTipo == "FI"
		nCrediari += (nValor * nSinal)
	Case Empty(cCodCli)
		nSemClien += (nValor * nSinal)
	OtherWise  //Case cTipo <> "CR"
		nOutrosPg += (nValor * nSinal)
EndCase
Return
		
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PesqDevTrc ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 23/05/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Pesquisa troca ou devolucao para a venda                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
		¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PesqDevTrc()
Local nReg
Local cAlias := Alias()
Local cBusca := XFILIAL("SE5")+D1_SERIE+D1_DOC+"A"+"NCC"+D1_FORNECE+D1_LOJA
Local cRet   := "D"
		
dbSelectArea("SE5")
dbSetOrder(7)
dbSeek(cBusca,.T.)
While !Eof() .And. cBusca == E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA
	nReg := Recno()
	If !Empty(E5_DOCUMEN) .And. dbSeek(E5_FILIAL+SubStr(E5_DOCUMEN,1,13)) //+E5_CLIFOR+E5_LOJA)
		dbSelectArea("SL1")
		dbSetOrder(2)
		If dbSeek(XFILIAL("SL1")+SE5->E5_PREFIXO+SE5->E5_NUMERO)
			cRet := "T"
			Exit
		Endif
		dbSelectArea("SE5")
	Endif
	dbGoTo(nReg)
	dbSkip()
Enddo
dbSelectArea(cAlias)
Return(cRet)
		
Static Function CriaSx1()
PutSX1(cPerg,"01","Data "    ,"Data "    ,"Data "   ,"mv_ch1","D",8,0,0,"G","","SA6","","","mv_par01")
PutSX1(cPerg,"02","1o Caixa ","1o Caixa ","1o Caixa","mv_ch2","C",3,0,0,"G","","SA6","","","mv_par02")
PutSX1(cPerg,"03","2o Caixa" ,"2o Caixa ","2o Caixa","mv_ch3","C",3,0,0,"G","","SA6","","","mv_par03")
PutSX1(cPerg,"04","3o Caixa" ,"3o Caixa ","3o Caixa","mv_ch4","C",3,0,0,"G","","SA6","","","mv_par04")
Return Nil