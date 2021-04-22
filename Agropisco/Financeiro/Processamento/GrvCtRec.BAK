#INCLUDE "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Rotina    ¦ GrvCtRec   ¦ Autor ¦ Ulisses Junior       ¦ Data ¦ 11/10/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Regrava o contas a receber com origem do faturamento          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦Utilizado como base o fonte desenvolvido pelo Ronilton com mesma finalidade¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function GrvCtRec()
Local cQry, nTxAdm := 1, cNumCart := Space(19)
Local cNatSE1 := "",lGeraSE5 := .F.
Local nInd    := SE1->(IndexOrd())
Local nReg    := SE1->(Recno())
Local cFilSE1 := xFilial("SE1")
Local cBusca  := SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DUPL
Local aArea  := GetArea()  
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.
Private aRotina   := { {"Pesquisar" ,"AxPesqui",0,1} ,;
                       {"Visualizar","AxVisual",0,2} ,;
                       {"Baixar"    ,"FINA070",0,3}}

   
cQry := "SELECT * FROM "+RetSqlName("SE1")+" WHERE D_E_L_E_T_ = ' ' AND E1_FILIAL = '"+cFilSE1+"' AND "
cQry += "E1_CLIENTE = '"+SF2->F2_CLIENTE+"' AND E1_LOJA = '"+SF2->F2_LOJA+"' AND "
cQry += "E1_PREFIXO = '"+SF2->F2_PREFIXO+"' AND E1_NUM = '"+SF2->F2_DUPL+"' AND "
cQry += "E1_NATUREZ NOT IN ('ISS','IRRF','PIS','COFINS','CSLL','INSS') "
cQry += "ORDER BY E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO"
   
dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)), "xSE1", .F., .T.)
   
xSE1->(dbGoTop())
   
cQry := "SELECT * FROM "+RetSQLName("SCV")+" WHERE D_E_L_E_T_ = ' ' AND CV_FILIAL = '"+XFILIAL("SCV")+"' AND "
cQry += "CV_PEDIDO = '"+xSE1->E1_PEDIDO+"' ORDER BY CV_VENCTO, CV_FORMAPG"

dbUseArea(.T., "TOPCONN", TCGenQry(,,ChangeQuery(cQry)), "TMP0", .F., .T.)

TCSetField("TMP0","CV_VENCTO", "D", 8, 0)

While !xSE1->(Eof()) .And. !TMP0->(Eof()) .And. cFilSE1+cBusca = xSE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)

	Do Case
		Case Trim(TMP0->CV_FORMAPG) = "R$"  
			cNatSE1 := GetMv("MV_NATDINH")
			lGeraSE5 := .T.
		Case Trim(TMP0->CV_FORMAPG) = "CH"  ; cNatSE1 := GetMv("MV_NATCHEQ")
		Case Trim(TMP0->CV_FORMAPG) = "VA"  ; cNatSE1 := GetMv("MV_NATVALE")
		Case Trim(TMP0->CV_FORMAPG) = "DP"  ; cNatSE1 := GetMv("MV_NATDEPO")
		Case Trim(TMP0->CV_FORMAPG) $ "BO,NP,EP,DC,CT,FI"
			cNatSE1 := GetMv("MV_NATFIN")
		Case Trim(TMP0->CV_FORMAPG) = "CC"  ; cNatSE1 := GetMv("MV_NATCART")
		Case Trim(TMP0->CV_FORMAPG) = "CD"  ; cNatSE1 := GetMv("MV_NATTEF")
		Case Trim(TMP0->CV_FORMAPG) = "CO"  ; cNatSE1 := GetMv("MV_NATCONV")
		OtherWise                           ; cNatSE1 := GetMv("MV_NATOUTR") 
	EndCase
             
	cQry := "UPDATE "+RetSqlName("SE1")+" SET E1_TIPO = '"+xSE1->E1_TIPO+"', "
	cQry += "E1_VENCTO = '"+dtos(TMP0->CV_VENCTO)+"', E1_VENCORI = '"+dtos(TMP0->CV_VENCTO)+"', "
	cQry += "E1_VENCREA = '"+dtos(DataValida(TMP0->CV_VENCTO))+"', "
    
	nSaldo := TMP0->CV_VALOR
	
	If Trim(TMP0->CV_FORMAPG) $ "CC,CD"
		//SAE->(dbSetOrder(1))
		U_MsSetOrder("SAE","AE_FILIAL+AE_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
		SAE->(dbSeek(XFILIAL("SAE")+TMP0->CV_CODADM))
		//cQry += "E1_CLIENTE = '"+SAE->AE_COD+"', E1_LOJA = '01', E1_NOMCLI = '"+Left(SAE->AE_DESC,20)+"', "
		nTxAdm := 1 - (SAE->AE_TAXA/100)
		cNatSE1 := SAE->AE_NATUREZ
		cNumCart := TMP0->CV_NUMCART
	ElseIf Trim(TMP0->CV_FORMAPG) = "R$"
//		nSaldo := 0   //criar parametro para o banco
		cQry += "E1_PORTADO = '"+Left(GetMv("MV_CXLOJA"),3)+"', E1_AGEDEP = '.', E1_CONTA = '.', E1_HIST = 'VENDA EM DINHEIRO', "
//		cQry += "E1_MOVIMEN = '"+dtos(ddatabase)+"', E1_BAIXA = '"+dtos(ddatabase)+"', E1_STATUS = 'B', "
	Endif
      
	cQry += "E1_VALOR = '"+str(TMP0->CV_VALOR*nTxAdm,17,2)+"', E1_SALDO = '"+str(nSaldo*nTxAdm,17,2)+"', "
	cQry += "E1_VLCRUZ = '"+str(xMoeda(TMP0->CV_VALOR*nTxAdm,xSE1->E1_MOEDA,1,xSE1->E1_EMISSAO,NIL,xSE1->E1_TXMOEDA),17,2)+"', "
	cQry += "E1_NATUREZ = '"+StrTran(cNatSE1,'"','')+"', E1_VLRREAL = '"+str(TMP0->CV_VALOR,17,2)+"', "
	cQry += "E1_NUMCART = '"+cNumCart+"', E1_NUMNOTA = '"+xSE1->E1_NUM+"' "
    
	cQry += "WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND E1_CLIENTE = '"+xSE1->E1_CLIENTE+"' AND "
	cQry += "E1_LOJA = '"+xSE1->E1_LOJA+"' AND E1_PREFIXO = '"+xSE1->E1_PREFIXO+"' AND "
	cQry += "E1_NUM = '"+xSE1->E1_NUM+"' AND E1_PARCELA = '"+xSE1->E1_PARCELA+"' AND "
	cQry += "E1_TIPO = '"+xSE1->E1_TIPO+"' AND D_E_L_E_T_ <> '*' "
      
	TcSqlExec(cQry)

	If lGeraSE5   
		dbSelectArea("SE1")
		//SE1->(dbSetOrder(2))                                                                                   
		U_MsSetOrder("SE1","E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
		If SE1->(dbSeek(xSE1->E1_FILIAL+xSE1->E1_CLIENTE+xSE1->E1_LOJA+xSE1->E1_PREFIXO+xSE1->E1_NUM+xSE1->E1_PARCELA+xSE1->E1_TIPO))
		    lISS := (Posicione("SA1",1,xFilial("SA1")+xSE1->E1_CLIENTE+xSE1->E1_LOJA,"A1_RECISS") = "1")
			
			xValor := SE1->E1_VALOR//-If(lISS,SE1->E1_ISS,0)
			
        	aVet := InicVarSE1(.F.,xValor,Left(GetMv("MV_CXLOJA"),3),".    ",".         ")
        	MsExecAuto({|x,y| FINA070(x,y) } , aVet, 3)
        
			If lMsErroAuto
		      Alert("Ocorreu um erro no recebimento da nota fiscal !")
		      MostraErro()
		      dbSelectArea("SE1")
		   	EndIf

        EndIf	

		lGeraSE5 := .F.
		RestArea(aArea)
	EndIf
      
	xSE1->(dbSkip())
	TMP0->(dbSkip())
End

TMP0->(dbCloseArea())
xSE1->(dbCloseArea())

SE1->(dbSetOrder(nInd))
SE1->(dbGoTo(nReg))

Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ InicVarSE1 ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 22/02/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Inicializa vetor com o conteudo a ser gravado no SE1          ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function InicVarSE1(lGrvTit,nValRec,cBcoBai,cAgeBai,cNcoBai)
   Local aVet := {}, cHist := "BAIXA REF VENDA EM DINHEIRO"
   
   aAdd( aVet, { "E1_PREFIXO"	, xSE1->E1_PREFIXO				, Nil } )
   aAdd( aVet, { "E1_NUM"		, xSE1->E1_NUM					, Nil } )
   aAdd( aVet, { "E1_PARCELA"	, xSE1->E1_PARCELA				, Nil } )
   aAdd( aVet, { "E1_TIPO"		, xSE1->E1_TIPO					, Nil } )
   aAdd( aVet, { "E1_CLIENTE"	, xSE1->E1_CLIENTE				, Nil } )
   aAdd( aVet, { "E1_LOJA"		, xSE1->E1_LOJA					, Nil } )
   aAdd( aVet, { "AUTMOTBX"     , "NOR"							, Nil } )
   aAdd( aVet, { "AUTBANCO"     , cBcoBai						, Nil } )
   aAdd( aVet, { "AUTAGENCIA"   , cAgeBai						, Nil } )
   aAdd( aVet, { "AUTCONTA"     , cNcoBai						, Nil } )
   aAdd( aVet, { "AUTDTBAIXA"   , dDataBase						, Nil } )
   aAdd( aVet, { "AUTDTCREDITO" , dDataBase        				, Nil } )
   aAdd( aVet, { "AUT_HIST"     , cHist							, Nil } )
   aAdd( aVet, { "AUTVALREC"    , nValRec						, Nil } )


Return(aVet)