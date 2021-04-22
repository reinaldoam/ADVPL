#Include "Rwmake.ch"

// Nota fiscal de Entrada Agropisco
// Ulisses Junior em 31/07/07
// Produto
// Formulario antigo
User Function AGPENTP2()

// Este Script somente sera utilizado se a serie da NF for "UNI"

titulo    := PADC("NOTA FISCAL DE ENTRADA",74)
cDesc1    := PADC("IRA EMITIR A NOTA FISCAL DE ENTRADA",74)
cDesc2    := PADC("",74)
cDesc3    := ""
cNatureza := ""
cResp     := "N"
nomeprog  := "AGPENTP1"
cString   := "SF1"
cViaTransp:= ""
aReturn   := { "Especial", 1,"Administracao", 1, 3, 8, "",1 }
nLastKey  := 0
cPerg     := "NFEAGR"
pag       := 0
li        := 0
nFimItens := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da NFPARV ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()
pergunte(cPerg,.F.)

wnrel:= "NFEAGR"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/;
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.,,,"P")
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
/*
SB1->(dbSetOrder(1)) // Produto
SF4->(dbSetOrder(1)) // TES
SC7->(dbSetOrder(1)) // Pedido+Item
SF1->(dbSetOrder(1)) // Cabecalho nota de entrada
SF2->(dbSetOrder(1)) // Cabecalho nota de saida
SD1->(dbSetOrder(1)) // Documento+Serie+Fornecedor+Loja+Produto+Item
  */
U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SF4","F4_FILIAL+F4_CODIGO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SC7","C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SF2","F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SD1","D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SF1","F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
  

SF1->(dbSeek(xFilial("SF1")+mv_par01+mv_par03,.T.))

/***********************************************
Início da impressão dos dados da Nota Fiscal
***********************************************/
aDriver := ReadDriver()

@ 00,000 PSAY &(aDriver[aReturn[4]+2])
lMod := .F.

While !SF1->(Eof()) .And. SF1->F1_FILIAL = xFilial("SF1");
	.And. SF1->F1_DOC <= mv_par02 .And. SF1->F1_SERIE = mv_Par03
	
	If SF1->F1_FORNECE # mv_par04 .or. SF1->F1_LOJA # mv_par05
		SF1->(dbSkip())
		Loop
	EndIf
	
	nValorProd := nValIcm := nBasIcm := nValIpi:=0
	nValorServ := nValIss := nAliqIss:=0
	nValIss := 0
	nQuanVol   := nPesoLiq:= nPesoBru:= nResto := 0
	vPedido    := {}
	vProd      := {}
	nItens     := 0                    
    
    vMsgDev    := {}
    
	SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
	
	While !SD1->(Eof()) .And. SF1->F1_FILIAL = SD1->D1_FILIAL;
		.And. SF1->F1_DOC = SD1->D1_DOC .And. SD1->D1_SERIE = SF1->F1_SERIE;
		.And. SF1->F1_FORNECE = SD1->D1_FORNECE .And. SF1->F1_LOJA = SD1->D1_LOJA
		
		SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
		SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
		
		cObsFis1 := IIf(!Empty(SF4->F4_OBS1),SF4->F4_OBS1,"")
		cObsFis2 := IIf(!Empty(SF4->F4_OBS2),SF4->F4_OBS2,"")
		cObsFis3 := IIf(!Empty(SF4->F4_OBS3),SF4->F4_OBS3,"")
        
  	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Tratamento para mensagens na devolucao da Nota ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SD1->D1_TIPO == "D" //- Devolucao               
		   nPos:= aScan(vMsgDev,{|x| x[1]+x[2] = SD1->D1_NFORI+SD1->D1_SERIORI })
		   If nPos = 0 
		      SF2->(DbSeek(xFilial("SF2")+SD1->(D1_NFORI+D1_SERIORI)))
		      AADD(vMsgDev,{ SD1->D1_NFORI, SD1->D1_SERIORI, SF2->F2_EMISSAO, SF2->F2_ESPECIE } )
		   Endif            
		Endif

		If (nPos := Ascan(vProd,{|x| x[1] = SD2->D2_COD})) = 0
			AADD(vProd,{Left(SB1->B1_COD,15),; 				//Código do Produto
			SB1->B1_DESC,;									//Descrição do Produto
			Alltrim(SB1->B1_ORIGEM)+SF4->F4_SITTRIB,;		//Situação tributária
			SD1->D1_UM,;									//Unidade de medida
			SD1->D1_QUANT,;									//Quantidade
			SD1->D1_VUNIT,;				//SD2->D2_PRCVEN,;	//Preço unitário
			SD1->D1_VUNIT*SD1->D1_QUANT,;//SD2->D2_TOTAL,;	//Valor Total
			SD1->D1_PICM})									//Porcentagem de ICMS
		Else
			vProd[nPos][5] += SD1->D1_QUANT
			vProd[nPos][7] += (SD1->D1_VUNIT*SD1->D1_QUANT)	//SD2->D2_TOTAL
		EndIf
		nValorProd := nValorProd + (SD1->D1_VUNIT*SD1->D1_QUANT)//SD2->D2_TOTAL
		nValIcm    := nValIcm + SD1->D1_VALICM
		nBasIcm    := nBasIcm + SD1->D1_BASEICM
		nValIpi    := nValIpi + SD1->D1_IPI

		SD1->(dbSkip())
		
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Mensagem na nota fiscal de devolucao  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(vMsgDev) > 0 
       cObsFis1:= "DEVOLUCAO "
       cObsFis2:= "" 
       cObsFis3:= ""    
	   For i:= 1 to Len(vMsgDev)		
	      If i < 4 		      
	         cObsFis1 += If(i>1,",","") + vMsgDev[i,4] + vMsgDev[i,1] + "/" + vMsgDev[i,2] + " DE " + Dtoc(vMsgDev[i,3])
	      ElseIf i < 8 
	         cObsFis2 += "," + vMsgDev[i,4] + vMsgDev[i,1] + "/" + vMsgDev[i,2] + " DE " + Dtoc(vMsgDev[i,3])
	      Else
	         cObsFis3 += "," + vMsgDev[i,4] + vMsgDev[i,1] + "/" + vMsgDev[i,2] + " DE " + Dtoc(vMsgDev[i,3])   
	      Endif   
	   Next    
	Endif

	nContProd := 1
	lImprime := .T.
	
	While lImprime
		
		Cabecalho() // Impressão do Cabeçalho da Nota Fiscal. 11/07/07
		nNumItens := 0
		
		While nContProd <= Len(vProd) .and. nNumItens < 17
			@ li,003 Psay vProd[nContProd][1]                                 // Código do Produto       // li -> 33
			@ li,019 Psay vProd[nContProd][2]                                 // Descrição do Produto    // li -> 33
			@ li,080 Psay vProd[nContProd][3]                                 // Origem+Sit. Tributaria  // li -> 33
			@ li,086 Psay vProd[nContProd][4]                                 // Unidade Medida          // li -> 33
			@ li,089 Psay Transform(vProd[nContProd][5],"@E       999.999")   // Quantidade              // li -> 33
			@ li,096 Psay Transform(vProd[nContProd][6],"@E   999,999.9999")  // Valor Unitário          // li -> 33
			@ li,110 Psay Transform(vProd[nContProd][7],"@E 9,999,999.99")    // Valor Total             // li -> 33
			@ li,124 Psay Transform(vProd[nContProd][8],"@E 99")+"%"          // Percentual de ICMS      // li -> 33
			li++
			nContProd++
			nNumItens++
		Enddo
		     
		If nContProd > Len(vProd) .and. SF1->F1_DESCONT > 0
			@ li, 099 Psay "Desconto : "+Transform(SF1->F1_DESCONT,"@E 9,999,999.99")
		EndIf
		
		nDif := nFimItens-li
		li:= li+nDif
				
		nNumItens := 0
		lImpObs1 := .T.
		lImpObs2 := .T.
		lImpObs3 := .T.

		li+=3
		
		If nContProd < Len(vProd)
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
		
		nTotal := nValorProd+nValIpi+SF1->F1_FRETE+SF1->F1_SEGURO+SF1->F1_DESPESA+nValorServ-SF1->F1_DESCONT//IF(Alltrim(SF2->F2_ESPECIE)$"CF#NF",0,SF2->F2_DESCONT)
		
		If nContProd < Len(vProd)
			@ li,018 Psay "**********"
			@ li,043 Psay "**********"
			@ li,069 Psay "**********"
			@ li,098 Psay "**********"
			@ li,122 Psay "**************"
		Else
			@ li,018 Psay Transform(SF1->F1_FRETE  ,"@E 999,999.99") // li -> 73
			@ li,043 Psay Transform(SF1->F1_SEGURO ,"@E 999,999.99") // li -> 73
			@ li,069 Psay Transform(SF1->F1_DESPESA,"@E 999,999.99") // li -> 73
			@ li,098 Psay Transform(nValIpi ,"@E 999,999.99") // li -> 73
			@ li,122 Psay Transform(If(SF1->F1_TIPO == "I",0,nTotal),"@E 999,999,999.99") // li -> 73 --nValorProd+nValIpi
			lImprime := .F.
		EndIf

		li += 12 

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
		li += 5
		@ li,127 Psay NumNota() // SF1->F1_DOC
		li ++
		If ((Val(mv_par02)-Val(mv_par01)) > 0 .or. nContProd < Len(vProd))
			li += 4
		EndIf
		@ li,000 Psay " "
	End
	SF1->(dbSkip())
	
Enddo

Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return

*******************************
Static Function ValidPerg()
*******************************

PutSX1(cPerg,"01"," Da Nota   :","","","mv_ch1","C",06,0,0,"G","","","","","mv_par01")
PutSX1(cPerg,"02"," Até a Nota:","","","mv_ch2","C",06,0,0,"G","","","","","mv_par02")
PutSX1(cPerg,"03"," Serie     :","","","mv_ch3","C",03,0,0,"G","","","","","mv_par03")
PutSX1(cPerg,"04"," Fornecedor:","","","mv_ch4","C",06,0,0,"G","","","","","mv_par04")
PutSX1(cPerg,"05"," Loja      :","","","mv_ch5","C",02,0,0,"G","","","","","mv_par05")

Return

*******************************
Static Function Cabecalho()
*******************************

Li:= PROW()+1
nFimItens := Li+48

SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))

SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
CFOP := SD1->D1_CF

/************************************************
Impressão do Cabeçalho da Nota Fiscal de Entrada
*************************************************/
If SF1->F1_TIPO $ "B"
	dbSelectArea("SA1") // Cadastro de Cliente
	//SA1->(dbSetOrder(1))
	U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       	
	SA1->(dbSeek(xFilial("SA1")+SD1->D1_FORNECE+SD1->D1_LOJA))
ElseIf SF1->F1_TIPO $ "D" .and. SF1->F1_FORMUL = "S"
	dbSelectArea("SA1") // Cadastro de Cliente
	//SA1->(dbSetOrder(1))
	U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       	
	SA1->(dbSeek(xFilial("SA1")+"00272701")) //Agropisco
Else
	dbSelectArea("SA2") // Cadastro de Fornecedor
	//SA2->(dbSetOrder(1))
	U_MsSetOrder("SA2","A2_FILIAL+A2_COD+A2_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       	
	SA2->(dbSeek(xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA))
EndIf
@ li,127 Psay NumNota() //SF2->F2_DOC // li ->1
li += 1
@ li,107 Psay "X"  //li ->5
li += 5

@ li,003 Psay Trim(SF4->F4_TEXTO) // li -> 10
@ li,047 Psay Transform(CFOP,"@R 9.999") // li ->10
li += 3
//021
@ li,003 Psay If(!SF1->F1_TIPO $ "B#D",SA2->A2_COD+" - "+SA2->A2_NOME,SA1->A1_COD+" - "+SA1->A1_NOME) //li -> 13
@ li,095 Psay If(!SF1->F1_TIPO $ "B#D",SA2->A2_CGC,SA1->A1_CGC) Picture "@R 99.999.999/9999-99" // li -> 13
@ li,127 Psay SD1->D1_EMISSAO // li -> 13
li += 2

@ li,003 Psay If(!SF1->F1_TIPO $ "B#D",SA2->A2_END,SA1->A1_END) //li -> 15
@ li,079 Psay If(!SF1->F1_TIPO $ "B#D",SA2->A2_BAIRRO,SA1->A1_BAIRRO) //li -> 15
@ li,107 Psay If(!SF1->F1_TIPO $ "B#D",SA2->A2_CEP,SA1->A1_CEP) //li -> 15
li += 2

@ li,003 Psay If(!SF1->F1_TIPO $ "B#D",SA2->A2_MUN,SA1->A1_MUN)//li -> 17
@ li,064 Psay Transform(If(!SF1->F1_TIPO $ "B#D",SA2->A2_TEL,SA1->A1_TEL),"!!!!!!!!!!!!!!") //li -> 17
@ li,085 Psay If(!SF1->F1_TIPO $ "B#D",SA2->A2_EST,SA1->A1_EST) //li -> 17
@ li,094 Psay If(!SF1->F1_TIPO $ "B#D",SA2->A2_INSCR,SA1->A1_INSCR) //li -> 17
li += 3

/***********************************************
Impressão das Duplicatas
***********************************************/

li += 2
li+=2 //li -> 22
li += 4 // li -> 27
Return

************************
Static Function NumNota 
************************
Local cNumNota:= Space(9)

cNumNota:= SF1->F1_DOC

Return cNumNota

