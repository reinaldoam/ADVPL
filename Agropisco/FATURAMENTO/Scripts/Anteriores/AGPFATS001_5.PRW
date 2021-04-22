#Include "Rwmake.ch"

// Nota fiscal Agropisco
// Ulisses Junior em 19/04/07
// Produto e Serviço

User Function AGPFATS001()

// Este Script somente sera utilizado se a serie da NF for "UNI"

titulo    := PADC("NOTA FISCAL DE SAIDA",74)
cDesc1    := PADC("IRA EMITIR A NOTA FISCAL DE SAIDA",74)
cDesc2    := PADC("",74)
cDesc3    := ""
cNatureza := ""
cResp     := "N"
nomeprog  := "AGPFATS001"
cString   := "SF2"
cViaTransp:= ""
aReturn   := { "Especial", 1,"Administracao", 1, 3, 8, "",1 }
nLastKey  := 0
cPerg     := "NFAGRO"
pag       := 0
li        := 0
nFimItens := 0
nFimServc := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da NFPARV ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Modificado para atender a impressao da NF p/ cupom fiscal   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(Funname()) != "LOJR130"
	wnrel:= "NFAGRO"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/;
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,,"P")
	If nLastKey == 27
		Return
	Endif
	SetDefault(aReturn,cString)
Else
	Mv_Par01:= SF2->F2_DOC
	Mv_Par02:= SF2->F2_DOC
	Mv_Par03:= SF2->F2_SERIE
Endif

SB1->(dbSetOrder(1))//Produto
SF4->(dbSetOrder(1))//TES
SA4->(dbSetOrder(1))//Transportadora
SC5->(dbSetOrder(1))//Cabeçalho do Pedido
SC6->(dbSetOrder(1))//Itens do Pedido - Pedido+Item+Produto
//U_MsSetOrder("SF2", "F2_FILIAL+F2_SERIE+F2_DOC")//Cabeçalho da NF
SF2->(dbSetOrder(1))
//U_MsSetOrder("SD2", "D2_FILIAL+D2_DOC+D2_SERIE")//Itens da NF
SD2->(dbSetOrder(3))        // Documento+Serie+Cliente+Loja+Produto+Item

SF2->(dbSeek(xFilial("SF2")+Mv_Par01+Mv_Par03,.T.))

/***********************************************
Início da impressão dos dados da Nota Fiscal
***********************************************/
aDriver := ReadDriver()

@ 00,000 PSAY &(aDriver[aReturn[4]+2])
lMod := .F.

While !SF2->(Eof()) .And. SF2->F2_FILIAL == xFilial("SF2");
	.And. SF2->F2_DOC <= Mv_par02;
	.And. SF2->F2_SERIE == Mv_Par03
	
	//Selo() // funcao para o Selo Fiscal
	//	Li:= PROW()+1
	//	nFimItens := Li+44
	//	nFimServc := Li+48
	lServ := .F.
	
	nValorProd := nValIcm := nBasIcm := nValIpi:=0
	nValorServ := nValIss := nAliqIss:=0
	nValIss := nInd := 0
	nQuanVol   := nPesoLiq:= nPesoBru:= nResto := 0
	vPedido    := {}
	vProd      := {}
	vServ      := {}
	nItens     := 0                    
	cDescSrv1  := Space(50)
	cDescSrv2  := Space(50)
	cDescSrv3  := Space(50)
	
	SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
	
	// Verifica se ha MOD na Nota Fiscal para impressao do CFOP da MOD.
	While !SD2->(Eof()) .And. SF2->F2_FILIAL == SD2->D2_FILIAL;
		.And. SF2->F2_DOC == SD2->D2_DOC ;
		.And. SD2->D2_SERIE == SF2->F2_SERIE
		
		If SD2->D2_TP == "MO"
			SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
			cObsFis1 := IIf(!Empty(SF4->F4_OBS1),SF4->F4_OBS1,"")
			cObsFis2 := IIf(!Empty(SF4->F4_OBS2),SF4->F4_OBS2,"")
			cObsFis3 := IIf(!Empty(SF4->F4_OBS3),SF4->F4_OBS3,"")
			cTES := SD2->D2_TES
			CFOP := SD2->D2_CF
			lMOD := .T.
		EndIf
		
		SD2->(dbSkip())
		
	EndDo
	
	SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
	
	//	Cabecalho() // Impressão do Cabeçalho da Nota Fiscal.
	
	While !SD2->(Eof()) .And. SF2->F2_FILIAL == SD2->D2_FILIAL;
		.And. SF2->F2_DOC == SD2->D2_DOC ;
		.And. SD2->D2_SERIE == SF2->F2_SERIE
		
		SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
		SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
		
		SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
		
		If ! lMOD
			cObsFis1 := IIf(!Empty(SF4->F4_OBS1),SF4->F4_OBS1,"")
			cObsFis2 := IIf(!Empty(SF4->F4_OBS2),SF4->F4_OBS2,"")
			cObsFis3 := IIf(!Empty(SF4->F4_OBS3),SF4->F4_OBS3,"")
		EndIf
		
		If SD2->D2_TP # "MO" //Se for Produto
			If (nPos := Ascan(vProd,{|x| x[1] = SD2->D2_COD})) = 0
				AADD(vProd,{Left(SB1->B1_COD,15),;                 //Código do Produto
				SB1->B1_DESC,;                             //Descrição do Produto
				Alltrim(SB1->B1_ORIGEM)+SF4->F4_SITTRIB,;  //Situação tributária
				SD2->D2_UM,;                               //Un	idade de medida
				SD2->D2_QUANT,;                            //Quantidade
				SD2->D2_PRCVEN,;                           //Preço unitário
				SD2->D2_TOTAL,;                            //Valor Total
				SD2->D2_PICM})                             //Porcentagem de ICMS
			Else
				vProd[nPos][5] += SD2->D2_QUANT
				vProd[nPos][7] += SD2->D2_TOTAL
			EndIf
			nValorProd := nValorProd + SD2->D2_TOTAL
			nValIcm    := nValIcm + SD2->D2_VALICM
			nBasIcm    := nBasIcm + SD2->D2_BASEICM
			nValIpi    := nValIpi + SD2->D2_IPI
			
		Else //Se for Serviço
			
			SC5->(DbSetOrder(1))
			SC6->(DbSetOrder(1))
			
			SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
			SC6->(DbSeek(xFilial("SC6")+SD2->D2_PEDIDO))
			
			If Empty(SC5->C5_OBS1)
				AB6->(DbSeek(xFilial("AB6")+Left(SC6->C6_NUMOS,6)))
				AB7->(DbSeek(xFilial("AB7")+AB6->AB6_NUMOS))
				AB3->(DbSeek(xFilial("AB3")+Left(AB7->AB7_NUMORC,6)))
				
				cDescSrv1:= If(!Empty(AB3->AB3_OBS1),AB3->AB3_OBS1,"")
				cDescSrv2:= If(!Empty(AB3->AB3_OBS2),AB3->AB3_OBS2,"")
				cDescSrv3:= If(!Empty(AB3->AB3_OBS3),AB3->AB3_OBS3,"")
			Else
				cDescSrv1:= SC5->C5_OBS1
				cDescSrv2:= If(!Empty(SC5->C5_OBS2),SC5->C5_OBS2,"")
				cDescSrv3:= If(!Empty(SC5->C5_OBS3),SC5->C5_OBS3,"")
			EndIf
			
			AADD(vServ,{"SRV",;                               	//Unidade de medida
			SD2->D2_QUANT,;                             		   	//Quantidade
			"",;                                 			//Observação 1
			SD2->D2_PRCVEN,;                             			//Preço unitário
			SD2->D2_TOTAL})											//Valor Total
			
			nValorServ := nValorServ + SD2->D2_TOTAL
			nValIss    := SF2->F2_VALISS //nValIss    + SD2->D2_VALICM
			nAliqIss   := SD2->D2_ALIQISS
		EndIf
		
		SD2->(dbSkip())
		
	End
	
	nContProd := 1
	nContServ := 1
	lImprime := .T.
	
	While lImprime
		
		Cabecalho() // Impressão do Cabeçalho da Nota Fiscal. 11/07/07
		nNumItens := 0
		
		While nContProd <= Len(vProd) .and. nNumItens < 17
			@ li,003 Psay vProd[nContProd][1]                                 // Código do Produto       // li -> 33
			@ li,019 Psay vProd[nContProd][2]                                 // Descrição do Produto    // li -> 33
			@ li,080 Psay vProd[nContProd][3]                                 // Origem+Sit. Tributaria  // li -> 33
			@ li,086 Psay vProd[nContProd][4]                                 // Unidade Medida          // li -> 33
			@ li,089 Psay Transform(vProd[nContProd][5],"@E       999.999")         // Quantidade              // li -> 33
			@ li,096 Psay Transform(vProd[nContProd][6],"@E   999,999.9999")  // Valor Unitário          // li -> 33
			@ li,110 Psay Transform(vProd[nContProd][7],"@E 9,999,999.99")    // Valor Total             // li -> 33
			@ li,124 Psay Transform(vProd[nContProd][8],"@E 99")+"%"         // Percentual de ICMS      // li -> 33
			li++
			nContProd++
			nNumItens++
		End
		
		nDif := nFimItens-li
		li:= li+nDif
		lImpIss := .T.
		
		nNumItens := 0
		lImpObs1 := .T.
		lImpObs2 := .T.
		lImpObs3 := .T.
		While nContServ <= Len(vServ) .and. nNumItens < 4
			
			// Impressão da Linha 1 do Serviço
			@ li,003 Psay vServ[nContServ][1]                                 // Unidade Medida        // li -> 61
			@ li,008 Psay Transform(vServ[nContServ][2],"@E 999")             // Quantidade            // li -> 61
			
			If lImpObs1
				@ li,017 Psay cDescSrv1                                 // Descrição do Serviço  // li -> 61
				lImpObs1 := .F.
			ElseIf lImpObs2
				@ li,017 Psay cDescSrv2                                 // Descrição do Serviço  // li -> 61
				lImpObs2 := .F.
			ElseIf lImpObs3
				@ li,017 Psay cDescSrv3                                 // Descrição do Serviço  // li -> 61
				lImpObs3 := .F.
			EndIf
			
			@ li,089 Psay Transform(vServ[nContServ][4],"@E 9,999,999.99")    // Valor Unitário        // li -> 61
			@ li,108 Psay Transform(vServ[nContServ][5],"@E 9,999,999.99")    // Valor Total           // li -> 61
			If lImpIss .And. nInd < 0
				@ li,127 Psay Transform(nValIss,"@E 999,999.99")
				lImpIss := .F.
			EndIf
			li++
			nNumItens++
			nContServ++ 
			lServ := .T.             
		EndDo			

		If !Empty(cDescSrv2) .And. lImpObs2
			@ li,017 Psay cDescSrv2                                 // Descrição do Serviço  // li -> 61
			lImpObs2 := .F.
			li++
        EndIf

		If !Empty(cDescSrv3) .And. lImpObs3
			@ li,017 Psay cDescSrv3                                 // Descrição do Serviço  // li -> 61
			lImpObs3 := .F.
			li++
        EndIf

		nDif := nFimServc-li
		li   := li+nDif
		
		If lServ
			If nInd < 0
				@ li,052 Psay Transform(nAliqIss,"@E 99")
			Endif
			If nContServ < Len(vServ)
				@ li,125 Psay "************"
			Else
				@ li,125 Psay Transform(nValorServ,"@E 9,999,999.99")
				lServ := .F.
			EndIf
		EndIf
		
		li+=3
		
		If nContProd < Len(vProd) .or. nContServ < Len(vServ)
			@ li,018 Psay "**********"
			@ li,043 Psay "**********"
			@ li,069 Psay "**********"
			@ li,098 Psay "**********"
			@ li,122 Psay "**************"
		Else
			@ li,018 Psay Transform(nBasIcm,"@E 999,999.99") // li -> 71
			@ li,043 Psay Transform(nValIcm,"@E 999,999.99") // li -> 71
			@ li,069 Psay Transform(0 ,"@E 999,999.99")      // li -> 71
			@ li,098 Psay Transform(0,"@E 999,999.99")       // li -> 71
			@ li,122 Psay Transform(If(SF2->F2_TIPO == "I",0,nValorProd),"@E 999,999,999.99") // li -> 71
			lImprime := .F.
		EndIf
		
		li += 2
		
		nValIss := If(nInd < 0, SF2->F2_VALISS*nInd,0)
		
		nTotal := nValorProd+nValIpi+SF2->F2_FRETE+SF2->F2_SEGURO+SF2->F2_DESPESA+nValorServ+nValIss-IF(Alltrim(SF2->F2_ESPECIE)$"CF#NF",0,SF2->F2_DESCONT)
		
		If nContProd < Len(vProd) .or. nContServ < Len(vServ)
			@ li,018 Psay "**********"
			@ li,043 Psay "**********"
			@ li,069 Psay "**********"
			@ li,098 Psay "**********"
			@ li,122 Psay "**************"
		Else
			@ li,018 Psay Transform(SF2->F2_FRETE  ,"@E 999,999.99") // li -> 73
			@ li,043 Psay Transform(SF2->F2_SEGURO ,"@E 999,999.99") // li -> 73
			@ li,069 Psay Transform(SF2->F2_DESPESA,"@E 999,999.99") // li -> 73
			@ li,098 Psay Transform(nValIpi ,"@E 999,999.99") // li -> 73
			@ li,122 Psay Transform(If(SF2->F2_TIPO == "I",0,nTotal),"@E 999,999,999.99") // li -> 73 --nValorProd+nValIpi
			lImprime := .F.
		EndIf
		li += 2 // li -> 77
		
		If SA4->(dbSeek(xFilial("SA4")+SC5->C5_TRANSP))
			@ li,003 Psay SA4->A4_NOME  // li -> 77
			@ li,089 Psay If(SC5->C5_TPFRETE=="F","1","2")  // li -> 77
			//@ li,093 Psay SA4->A4_PLACA  // li -> 77
			@ li,107 Psay SA4->A4_EST  // li -> 77
			@ li,116 Psay SA4->A4_CGC Picture "@R 99.999.999/9999-99"  // li -> 77
			li += 2
			@ li,003 Psay SA4->A4_END  // li -> 79
			@ li,080 Psay SA4->A4_MUN  // li -> 79
			@ li,107 Psay SA4->A4_EST  // li -> 79
			@ li,116 Psay SA4->A4_INSEST  // li -> 79
			li += 2
		Else
			li += 4
		EndIf
		
		@ li,012 Psay Transform(nQuanVol,"@E 9999") // li -> 81
		@ li,030 Psay SC5->C5_ESPECI1 // li -> 81
		@ li,097 Psay Transform(nPesoBru,"@E 999,999.999") // li -> 81
		@ li,122 Psay Transform(nPesoLiq,"@E 999,999.999") // li -> 81
		/*
		RecLock("SF2")
		SF2->F2_ESPECI1 := SC5->C5_ESPECI1
		SF2->F2_VOLUME1 := nQuanVol
		SF2->F2_PLIQUI  := nPesoLiq
		SF2->F2_PBRUTO  := nPesoBru
		SF2->(MsUnLock())
		*/
		li:=li+3     //1234567890123456789012345678901234567890123456789012345678901234567890
		@ li,004 Psay MsgNfCupom(" ")
		li++
		
		If Len(vServ) > 0 .and. !Empty(SC6->C6_NUMOS)
			@ li,004 Psay "PEDIDO : "+SC5->C5_NUM +" / "+"OS : "+Left(SC6->C6_NUMOS,6)+" / "+"ORC FIELD: "+Left(AB7->AB7_NUMORC,6)
		EndIf
		li++
		If !Empty(SF2->F2_VEND1)
			@ li,004 Psay "VENDEDOR : "+Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_NREDUZ") // "ESPACO RESERVADO PARA MENSAGENS DA NF NUM TOTAL DE 65 CARACTERES "
		EndIf
		li++
		If !Empty(cObsFis1)
			@ li,004 Psay cObsFis1 // "ESPACO RESERVADO PARA MENSAGENS DA NF NUM TOTAL DE 65 CARACTERES "
		EndIf
		
		@ li,090 Psay NumNota()
		li++
		
		If !Empty(cObsFis2)
			@ li,004 Psay cObsFis2 // "ESPACO RESERVADO PARA MENSAGENS DA NF NUM TOTAL DE 65 CARACTERES "
		EndIf
		li++
		
		If !Empty(cObsFis3)
			@ li,004 Psay cObsFis3 // "ESPACO RESERVADO PARA MENSAGENS DA NF NUM TOTAL DE 65 CARACTERES "
		EndIf
		li++
		@ li,004 Psay MsgDepCC()   //- Mensagem para deposito em C/C
		li += 4
		@ li,127 Psay NumNota() // SF2->F2_DOC
		li ++
		If ((Val(mv_par02)-Val(mv_par01)) > 0 .or. (nContProd < Len(vProd) .or. nContServ < Len(vServ)))
			li += 4
		EndIf
		@ li,000 Psay " "
	End
	SF2->(dbSkip())
	
Enddo

If AllTrim(Funname()) != "LOJR130"
	Set Device To Screen
	If aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnrel)
	Endif
	MS_FLUSH()
Endif

Return

*******************************
Static Function ValidPerg()
*******************************

PutSX1(cPerg,"01"," Da Nota   :","","","mv_ch1","C",06,0,0,"G","","","","","mv_par01")
PutSX1(cPerg,"02"," Até a Nota:","","","mv_ch2","C",06,0,0,"G","","","","","mv_par02")
PutSX1(cPerg,"03"," Serie     :","","","mv_ch3","C",03,0,0,"G","","","","","mv_par03")

Return

*******************************
Static Function Cabecalho()
*******************************

Li:= PROW()+1
nFimItens := Li+44
nFimServc := Li+48

SD2->(dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
If lMOD
	SF4->(dbSeek(xFilial("SF4")+cTes))
Else
	SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
	CFOP := SD2->D2_CF
Endif

SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

/***********************************************
Armazena as parcelas dos clientes
***********************************************/
Vetor1 := {}

DbSelectArea("SE1")
SE1->(dbSetOrder(1))
IF SE1->(dbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC))
	
	While SE1->E1_NUM == SF2->F2_DOC
		AADD(Vetor1,{SE1->E1_VENCREA,SE1->E1_VALOR,SE1->E1_TIPO,SE1->E1_NUM,SE1->E1_PARCELA})
		SE1->(dbSkip())
	End
	
EndIF

/************************************************
Impressão do Cabeçalho da Nota Fiscal de Saída
*************************************************/
If !SF2->F2_TIPO $ "B#D"
	dbSelectArea("SA1") // Cadastro de Cliente
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA))
	nInd := If(SA1->A1_RECISS $ " #2",1,-1)
Else
	dbSelectArea("SA2") // Cadastro de Fornecedor
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA))
	nInd := 1
EndIf
@ li,127 Psay NumNota() //SF2->F2_DOC // li ->1
li += 1
@ li,093 Psay "X"  //li ->5
li += 5

@ li,003 Psay Trim(SF4->F4_TEXTO) // li -> 10
@ li,047 Psay Transform(CFOP,"@R 9.999") // li ->10
li += 3
//021
@ li,003 Psay If(!SF2->F2_TIPO $ "B#D",SA1->A1_COD+" - "+SA1->A1_NOME,SA2->A2_COD+" - "+SA2->A2_NOME) //li -> 13
@ li,095 Psay If(!SF2->F2_TIPO $ "B#D",SA1->A1_CGC,SA2->A2_CGC) Picture "@R 99.999.999/9999-99" // li -> 13
@ li,127 Psay SD2->D2_EMISSAO // li -> 13
li += 2

@ li,003 Psay If(!SF2->F2_TIPO $ "B#D",SA1->A1_END,SA2->A2_END) //li -> 15
@ li,079 Psay If(!SF2->F2_TIPO $ "B#D",SA1->A1_BAIRRO,SA2->A2_BAIRRO) //li -> 15
@ li,107 Psay If(!SF2->F2_TIPO $ "B#D",SA1->A1_CEP,SA2->A2_CEP) //li -> 15
li += 2

@ li,003 Psay If(!SF2->F2_TIPO $ "B#D",SA1->A1_MUN,SA2->A2_MUN)//li -> 17
@ li,064 Psay Transform(If(!SF2->F2_TIPO $ "B#D",SA1->A1_TEL,SA2->A2_TEL),"!!!!!!!!!!!!!!") //li -> 17
@ li,085 Psay If(!SF2->F2_TIPO $ "B#D",SA1->A1_EST,SA2->A2_EST) //li -> 17
@ li,094 Psay If(!SF2->F2_TIPO $ "B#D",SA1->A1_INSCR,SA2->A2_INSCR) //li -> 17
li += 3

/***********************************************
Impressão das Duplicatas
***********************************************/

nCol:= 3

If Len(Vetor1) > 0
	nCont := 0
	For nX:= 1 to Len(Vetor1)
		
		@ li,nCol+1  Psay  Vetor1[nX][4]+"/"+Vetor1[nX][5] // li -> 20
		@ li,nCol+11 Psay  Vetor1[nX][1] //li -> 20
		@ li,nCol+25 Psay Transform(Vetor1[nX][2],"@E 99,999,999.99") //li -> 20
		nCont++
		nCol += 47
		
		If mod(nX,3) = 0
			nCol := 3
			li++
		EndIf
		
	Next nX
	li += If(nCont < 2, 1, 0)
Else
	li += 2
EndIf

li+=2 //li -> 22
@li,003 Psay SD2->D2_PEDIDO           

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

@li,070 Psay SC5->C5_MENNOTA
@li,107 Psay If(!SF2->F2_TIPO $ "B#D",SA1->A1_CONTATO,SA2->A2_CONTATO) //li -> 17
li += 4 // li -> 27
Return

Static Function Selo()

DbSelectArea("SX5")
SX5->(dbSetOrder(1))

SX5->(DbSeek(xFilial()+"ZC" ))

cSelo := Alltrim(SX5->X5_DESCRI)

@ 206,208 TO 373,560 DIALOG oMen TITLE "Numero do Selo Fiscal de Saida"
@ 13,14 SAY "Selo Fiscal       : "
@ 13,60 GET cSelo SIZE 75,50
@ 61,100 BMPBUTTON TYPE 1 ACTION GravaSelo()
ACTIVATE DIALOG oMen

Return

///////////////////////
Static Function NumNota
Local cNumNota:= Space(6)
If AllTrim(Funname()) == "LOJR130"
	cNumNota:= Substr(SF2->F2_NFCUPOM,4,6)
Else
	cNumNota:= SF2->F2_DOC
Endif
Return cNumNota

////////////////////////////////
Static Function MsgNfCupom(cMsg)
Local cMsgNota:= cMsg
//If AllTrim(Funname()) == "LOJR130"
If Trim(SF2->F2_ESPECIE) == "CF" //- Nota fiscal para cupom fiscal
	cMsgNota:= "NOTA FISCAL REF. CUPOM FISCAL N. " + SF2->F2_DOC
Endif
Return cMsgNota

/////////////////////////
Static Function MsgDepCC               
  Local cMsg:= ""
  //- Administradora financeira
  SE4->(DbSetOrder(1))
  SE4->(DbSeek(xFilial("SE4")+SF2->F2_COND))
  If TRIM(SE4->E4_FORMA) == "DP"
     cMsg:= "EFETUAR DEPOSITO NO BANCO DO BRASIL - 001 AG.1208-4 C/C 7148-X"  
  ElseIf TRIM(SE4->E4_FORMA) == "EP"   
     cMsg:= "EFETUAR DEPOSITO NO BANCO DO BRADESCO - 237 AG.2169-4 C/C 14204-2" 
  Endif
Return cMsg 

///////////////////////////
Static Function GravaSelo()

Close(oMen)
Reclock("SF2")
SF2->F2_SELOFIS := cSelo
MsUnLock()

cSelo := Str(Val(cSelo)+1)
RecLock("SX5")
SX5->X5_Descri := cSelo
MsUnLock()

Return()
