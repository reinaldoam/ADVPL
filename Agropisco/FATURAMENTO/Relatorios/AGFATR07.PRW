#include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AGFATR07   ¦ Autor ¦ Reinaldo Magalhaes   ¦ Data ¦ 28/04/2014 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Imprime requisicao de saida de mercadorias                    ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦ Fonte incluido neste projeto por Ulisses Jr em 09/10/07 para manutenção   ¦¦¦
¦¦¦ das formas de pagamento pelo faturamento.                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
 ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AGFATR07(cPedido)

	SetPrvt("cSavScr1,cTitulo,cDesc1,cDesc2,cDesc3,cString,nPag,cNumPed")
	SetPrvt("cNomeProg,aReturn,wnRel,nArea,cPorta")
	SetPrvt("nAux,nTotal,nDesco,nBruto")
	SetPrvt("nComp,nNorm,p_negrit_l,p_reset,p_negrit_d,cPorta")
	                                             
	cPorta  := "LPT1"
	Titulo  := "SAIDA DE MERCADORIAS"
	cDesc1   := "O objetivo deste relatorio e' imprimir comprovante de vendas"
	cDesc2   := ""
	cDesc3   := ""
	cString  := "SC5"
	nPag     := 0
	cNomeProg:= "AGFATR07"
	cPerg    := "AGFT07    "
    wNrel    := "AGFATR07"

    aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
	
    SetPrint(cString,wnrel,,Titulo,cDesc1,cDesc2,cDesc3,.T.)
    If nLastKey = 27
	   Return
    Endif

    SetDefault(aReturn,cString)

    If nLastKey = 27
	   Return
    Endif
 
    RptStatus({|| Imprime(cPedido) })
    
    Set Device To Screen

    If aReturn[5] == 1
	   Set Printer TO
	   dbcommitAll()
	   ourspool(wnrel)
    Endif
    MS_FLUSH()
return

Static Function Imprime(cPedido)
    nBruto:=0
    nTotal:=0
    nDesco:=0
   
    cImpCod:= "F" //GetMV("MV_X_CDPRO")

	dbSelectArea("SC5")
	
	cNumPed:= cPedido //SC5->C5_NUM
	
	nArea:= GetArea()

    cQry := "SELECT ISNULL(SUM(C6_VALOR),0)TOTAL, ISNULL(SUM(C6_VALDESC),0)DESCONTO,"
    cQry += "       ISNULL(SUM(C6_PRUNIT*C6_QTDVEN),0)BRUTO"    
    cQry += " FROM "+RetSQLName("SC6")          
    cQry += " WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND C6_NUM = '"+cNumPed+"' AND D_E_L_E_T_ <> '*'"
		
    dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
    nTotal += TOTAL                                                                    
    nBruto += BRUTO
    nDesco += DESCONTO
    TRB->(dbCloseArea())
	
	//- Posiciona no arquivo de Clientes
	dbSelectArea( "SA1" )
	dbsetorder(1)
	dbSeek( xFilial("SA1")+SC5->( C5_CLIENTE+C5_LOJACLI ) )
	
	//- Posiciona no arquivo de Fornecedor
	dbSelectArea( "SA2" )
	dbsetorder(1)
	dbSeek( xFilial("SA2")+SC5->( C5_CLIENTE+C5_LOJACLI ) )

	//- Posiciona no arquivo de Vendedores
	dbSelectArea( "SA3" )
	dbsetorder(1)
	dbSeek( xFilial("SA3")+SC5->C5_VEND1 )
	
	//- Posiciona arquivo de condicoes de pagamento
	dbSelectArea("SE4")
	dbsetorder(1)
	dbSeek(xFilial("SE4")+SC5->C5_CONDPAG)
	
    cQry := " SELECT * "
    cQry += " FROM "+RetSQLName("SC6")+" SC6, "+RetSQLName("SB1")+" SB1,"+RetSQLName("SB2")+" SB2, "+RetSQLName("SA2")+" SA2 "
    cQry += " WHERE SC6.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SB2.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*' "
    cQry += " AND C6_PRODUTO = B1_COD "
    cQry += " AND B1_PROC = A2_COD "
    cQry += " AND C6_FILIAL *= B2_FILIAL "
    cQry += " AND C6_PRODUTO *= B2_COD"
    cQry += " AND C6_LOCAL *= B2_LOCAL "
    cQry += " AND C6_FILIAL = '"+xFilial("SC6")+"'  "
    cQry += " AND C6_NUM = '"+cNumPed+"' "

    dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB2", .T., .F. )
 
	nAux:= 12
	
	While !TRB2->(Eof()) .and. TRB2->C6_NUM == cNumPed
		If nAux >= 12
			Cabpvenda()
			nAux:= 1
		Endif
		nAux:= nAux + 1

		@Prow()+1, 0   PSay Substr(TRB2->B1_COD,1,15)
		@Prow()  , 16  PSay TRB2->B1_UM
		@Prow()  , 19  PSay TRB2->C6_QTDVEN               Picture "@E 99999"
		@Prow()  , 25  PSay TRB2->C6_PRCVEN               Picture "@E 999,999.99"
		@Prow()  , 36  PSay TRB2->C6_VALDESC              Picture "@E 999,999.99"
		@Prow()  , 47  PSay TRB2->C6_VALOR                Picture "@E 999,999.99"
		@Prow()  , 58  PSay TRB2->C6_CLASFIS
		@Prow()  , 62  PSay TRB2->B1_PICM                 Picture "@E 99.99"
		@Prow()  , 68  PSay Substr(TRB2->B1_DESC,1,40)    Picture "@!"
		@Prow()  , 109 PSay Substr(TRB2->B1_LOCAGRO,1,15) Picture "@!"
		
		If nAux > 10
			@ PRow()+1, 32 PSay ""
			nAux:= nAux + 1
		Endif
		TRB2->(dbSkip())
	Enddo                
	TRB2->(dbCloseArea())
	If nAux <= 10
		nAux:= nAux + 1
	Endif              
	@ Prow()+1, 0       PSay ""
	@ Prow()+1, 0       PSay "----------------------" 
	@ Prow()+1, 0       PSay "Recebido por" 
	@ Prow()+16-nAux, 0 PSay ""
	RestArea(nArea)
return

Static Procedure Cabpvenda
	nPag:= nPag + 1
	If nPag > 1
		@Prow()+7,0 Psay " " //- Controle para orcamentos com + de uma pagina
	Endif

	Cabimpr2(136, "CONTROLE INTERNO -  SEM VALOR FISCAL")

	@ PRow()+1, 0 PSay "SAIDAS DE MERCADORIAS N.: " + SC5->C5_NUM
	
	If ALLTRIM(SC5->C5_TIPO) $"D|B"
  	   @ PRow()+1,   0 PSay "FORNECEDOR      :" + "(" + SC5->C5_CLIENTE + ")" + SA2->A2_NOME
	   @ PRow()  , 100 PSay "VENDEDOR:" + SC5->C5_VEND1
	   @ PRow()+1,   0 PSay "ENDERECO     :"  +SUBSTR(SA2->A2_END,1,30)+ " - " + SUBSTR(SA2->A2_BAIRRO,1,20)+ " / " + SA2->A2_MUN + " - " + SA2->A2_EST
    Else
      @ PRow()+1,   0 PSay "CLIENTE      :" + "(" + SC5->C5_CLIENTE + ")" + SA1->A1_NOME
	  @ PRow()  , 100 PSay "VENDEDOR:" + SC5->C5_VEND1
	  @ PRow()+1,   0 PSay "ENDERECO     :"  +SUBSTR(SA1->A1_END,1,30)+ " - " + SUBSTR(SA1->A1_BAIRRO,1,20)+ " / " + SA1->A1_MUN + " - " + SA1->A1_EST
    Endif
    
	@ PRow()+1,   0 PSay "COND.PAGTO   :"  +SE4->E4_CODIGO+"-"+SE4->E4_DESCRI
	@ PRow()+1,   0 PSay "DESCONTO     : " + Transform(nDesco,"@E 999,999,999.99")
	@ PRow()+1,   0 PSay "OBSERV. (I)  : " + SC5->C5_OBS1
	@ PRow()  , 085 PSay "          VALOR LIQUIDO:" + Transform(nTotal,"@E 999,999,999.99")
	@ PRow()+1,   0 PSay "OBSERV. (II) : " + SC5->C5_OBS2
	@ PRow()+2,   0 PSay "CODIGO          UN QTDE  PRECO LIQ. VAL.DESC.  PCO. TOTAL CST ALIQ  DESCRICAO                                LOCAL"
	@ PRow()+1,   0 PSay "--------------- -- ----- ---------- ---------- ---------- --- ----- ---------------------------------------- ---------------------"
	//                    XXXXXXXXXXXXXXX XX 99999 999,999.99 999,999.99 999,999.99 XXX 99.99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXX
	//                    01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//                    0         1         2         3         4         5         6         7         8         9        10        11        12        13                                                         
return

//////////////////////////////////////////
Static Procedure Cabimpr2(m_larg, m_msg)
	@ PRow()+1, 0 PSay Replicate("=", m_larg)
	@ PRow()+1, (m_larg - Len(m_msg)) / 2 PSay m_msg
	@ PRow()+1, 0 PSay SM0->M0_NOMECOM
	@ PRow()  , m_larg - 16 PSay "DATA: " + DToC(Date())
	@ PRow()+1, 0 PSay "CNPJ: " + SM0->M0_CGC + "  IE: " + SM0->M0_INSC
	@ PRow()  , m_larg - 16 PSay "HORA: " + Time()
	@ PRow()+1, 0 PSay Replicate("-", m_larg)
Return