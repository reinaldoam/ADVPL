#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*___________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-----------+-------+---------------------+------+------------------+¦¦
¦¦¦ Função    ¦ AGLOJP02  ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 30/04/2008    	  ¦¦¦
¦¦+-----------+-----------+-------+---------------------+------+------------------+¦¦
¦¦¦ Descriçäo ¦ Formação de preço - Rotina desenvolvida para efetuar a formação   ¦¦¦
¦¦¦           ¦ de preços em rotina executa de forma independente, em substituíção¦¦¦
¦¦¦           ¦ a rotina executada nos pontos de entrada de nota fiscal.          ¦¦¦
¦¦+-----------+-------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function AgLojP02()
Local lGrava, cFiltro
Local aCores := {{"Empty(F1_YFLGPRC)","BR_VERDE"},;
				{"F1_YFLGPRC = 'S'","BR_VERMELHO"}}
Private cQry := "", cCadastro := "FORMACAO DE PRECOS"
Private aRotina := { {"Pesquisar"	,"AxPesqui"		,0,1},;
                     {"Visualizar"	,"AxVisual"		,0,2},;
                     {"Forma Preco"	,"U_AgLojP2a()"	,0,4},;
                     {"Legenda"		,"u_LegAutent()",0,5}}
/*
AgLojP2a()// Gera temporário

Wrk->(dbGoTop())
  */

dbSelectArea("SF1")
U_MsSetOrder("SF1","F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO")
//SF1->(dbSetOrder(1))

cFiltro := "!Empty(SF1->F1_STATUS) .and. (SF1->F1_TIPO = 'N' .or. (SF1->F1_TIPO = 'C' .and. SF1->F1_ORIGLAN = 'F' )) "
dbSetFilter({|| &(cFiltro) } , cFiltro )

MBrowse(6,1,22,75,"SF1"  ,,,,,2,aCores)

dbSelectArea("SF1")
cFiltro := ""
dbSetFilter({|| &(cFiltro) } , cFiltro )//Substituir pela linha abaixo e compilar
//dbClearFilter()
Return

*************************
User Function AgLojP2a()
*************************
//ALERT("AgLojP2a()")
If !Empty(SF1->F1_YFLGPRC)
	MsgInfo("Nota fiscal ja utilizada para formar preco","Atencao")
   	if !MsgYesNo("Deseja formar o preço da Nota Fiscal ?")
	  Return
	Endif	
EndIf

//U_MsSetOrder("SF1","F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO")
//SF1->(dbSeek(xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_TIPO))
		
nRecnoSf1 := SF1->(Recno())

U_MsSetOrder("SD1","D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM")
//SD1->(dbSetOrder(1))
SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))

If SF1->F1_TIPO = 'N'
	lGrava := U_AGPLOJP001("N")// Forma preço sem frete

	If lGrava
		SF1->(dbGoTo(nRecnoSf1))
		RecLock("SF1",.F.)
		SF1->F1_YFLGPRC := 'S'
		SF1->(MsUnlock())
	EndIf
			
ElseIf SF1->F1_TIPO = 'C' .and. SF1->F1_ORIGLAN = "F"
	U_MsSetOrder("SF8","F8_FILIAL+F8_NFDIFRE+F8_SEDIFRE+F8_TRANSP+F8_LOJTRAN")
	//SF8->(dbSetOrder(3))
	SF8->(dbSeek(xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
			
	nRecnoSf8 := SF8->(Recno())

	lGrava := U_AGPLOJP001("F")//Forma preço com frete
			
	SF8->(dbGoTo(nRecnoSf8))
			
	If lGrava
	    //Posiciona e flega a nota principal
	    SF1->(dbSeek(xFilial("SF1")+SF8->F8_NFORIG+SF8->F8_SERORIG+SF8->F8_FORNECE+SF8->F8_LOJA))
		RecLock("SF1",.F.)
		SF1->F1_YFLGPRC := 'S'
		SF1->(MsUnlock())
			    
		//Flega a nota de frete
		SF1->(dbGoTo(nRecnoSf1))
		RecLock("SF1",.F.)
		SF1->F1_YFLGPRC := 'S'
		SF1->(MsUnlock())
	EndIf

EndIf
	
//Wrk->(dbCloseArea())

Return

**************************
Static Function AgLojP2a()
**************************

	cQry := " SELECT * FROM "+RetSqlName("SF1")
	cQry += " WHERE D_E_L_E_T_ <> '*' "//Campo p/ flag da formação de preço
	cQry += " AND (F1_TIPO = 'N' OR (F1_TIPO = 'C' AND F1_ORIGLAN = 'F' )) "
	cQry += " ORDER BY F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_TIPO "
	dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "Wrk", .T., .F. )
	
Return
*************************
User Function LegAutent()
*************************
   BrwLegenda(cCadastro,"Legendas",{{"BR_VERDE","Aberto"},{"BR_VERMELHO","Processado"}})

Return
