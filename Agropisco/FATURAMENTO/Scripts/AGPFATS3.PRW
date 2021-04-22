#Include "Rwmake.ch"

// Nota fiscal Agropisco
// Ulisses Junior em 15/09/08
// Fonte armazenado para suprir a 
// necessidade de continuar usando 
// o formulário antigo, uma vez que existe outro formulário sendo utilizado
User Function AGPFATS3()

// Este Script somente sera utilizado se a serie da NF for "UNI"

titulo    := PADC("NOTA FISCAL DE SAIDA",74)
cDesc1    := PADC("IRA EMITIR A NOTA FISCAL DE SAIDA",74)
cDesc2    := PADC("",74)
cDesc3    := ""
cNatureza := ""
cResp     := "N"
nomeprog  := "AGPFATS2"
cString   := "SF2"
cViaTransp:= ""
aReturn   := { "Especial", 1,"Administracao", 1, 3, 8, "",1 }
nLastKey  := 0
cPerg     := "NFAGRO"
pag       := 0
li        := 0
nFimItens := 0
nFimServc := 0
lTranspLj := .F.
cTransp   := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da NFPARV ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ValidPerg()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Modificado para atender a impressao da NF p/ cupom fiscal   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(Funname()) != "LOJR130"
	wnrel:= "AGPFATS2"
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
	cTransp := SL1->L1_TRANSP
	lTranspLj := .T.
Endif
/*
SB1->(dbSetOrder(1)) //- Produto
SF4->(dbSetOrder(1)) //- TES
SA4->(dbSetOrder(1)) //- Transportadora
SC5->(dbSetOrder(1)) //- Cabeçalho do Pedido
SC6->(dbSetOrder(1)) //- Itens do Pedido - Pedido+Item+Produto
SF2->(dbSetOrder(1)) //- Cabecalho nota fiscal de saida 
SD2->(dbSetOrder(3)) //- Item nota fiscal               
SF1->(dbSetOrder(1)) //- Cabecalho nota fiscal de entrada
*/
U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SF4","F4_FILIAL+F4_CODIGO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SA4","A4_FILIAL+A4_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SC5","C5_FILIAL+C5_NUM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SC6","C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SF2","F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SD2","D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SF1","F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
U_MsSetOrder("SD1","D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       

//SF2->(dbSeek(xFilial("SF2")+Mv_Par01+Mv_Par03,.T.))

SF1->(dbSeek(xFilial("SF1")+Mv_Par01+Mv_Par03,.T.))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratamento criado para a reimpressao da nota fiscal / cupom ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/***********************************************
Início da impressão dos dados da Nota Fiscal
***********************************************/
aDriver := ReadDriver()

@ 00,000 PSAY &(aDriver[aReturn[4]+2])
lMod := .F.

While !SF1->(Eof()) .And. SF1->F1_FILIAL == xFilial("SF1");
	.And. SF1->F1_DOC <= Mv_par02;
	.And. SF1->F1_SERIE == Mv_Par03
	
	//Selo() // funcao para o Selo Fiscal
	//	Li:= PROW()+1
	//	nFimItens := Li+44
	//	nFimServc := Li+48
	lServ := .F.

	cObsFis1   := cObsFis2 := cObsFis3:= ""
	nValorProd := nValIcm  := nBasIcm := nValIpi:=0
	nValorServ := nValIss  := nAliqIss:=0
	nValIss    := nInd     := 0
	nDescont   := 0
	nDescIcm   := 0
	lDesc      := .F.
	nQuanVol   := nPesoLiq := nPesoBru:= nResto := 0
	vPedido    := {}
	vProd      := {}
	vServ      := {}
	vTes	   := {}
	nItens     := 0                    
	cDescSrv1  := Space(50)
	cDescSrv2  := Space(50)
	cDescSrv3  := Space(50)
	cTES	   := Space(03)
	//cRecISS    := Posicione("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_RECISS")
	
	SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE))
	
	// Verifica se ha MOD na Nota Fiscal para impressao do CFOP da MOD.
	While !SD1->(Eof()) .And. SF1->F1_FILIAL == SD1->D1_FILIAL;
		                .And. SF1->F1_DOC == SD1->D1_DOC ;
		                .And. SD1->D1_SERIE == SF1->F1_SERIE
		
		If SD1->D1_TP == "MO"
			SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
			//cObsFis1 := IIf(!Empty(SF4->F4_OBS1) .And. cRecISS="1" ,SF4->F4_OBS1,"") SUBSTITUIDO PELA LINHA ABAIXO POR ULISSES JR EM 06/09/07
			//cObsFis2 := IIf(!Empty(SF4->F4_OBS2),SF4->F4_OBS2,"")                                             "
			//cObsFis3 := IIf(!Empty(SF4->F4_OBS3),SF4->F4_OBS3,"")                                             "
            If Ascan(vTes,{|x| x = SD1->D1_TES}) = 0
	            If !Empty(SF4->F4_OBS1) 
					If Empty(cObsFis1)
						cObsFis1 := SF4->F4_OBS1
					ElseIf Empty(cObsFis2)
						cObsFis2 := SF4->F4_OBS1
					ElseIf Empty(cObsFis3)
						cObsFis3 := SF4->F4_OBS1
					EndIf
			    EndIf
				If !Empty(SF4->F4_OBS2)
					If Empty(cObsFis1)
						cObsFis1 := SF4->F4_OBS2
					ElseIf Empty(cObsFis2)
						cObsFis2 := SF4->F4_OBS2
					ElseIf Empty(cObsFis3)
						cObsFis3 := SF4->F4_OBS2
					EndIf
				EndIf
				If !Empty(SF4->F4_OBS3)
					If Empty(cObsFis1)
						cObsFis1 := SF4->F4_OBS3
					ElseIf Empty(cObsFis2)
						cObsFis2 := SF4->F4_OBS3
					ElseIf Empty(cObsFis3)
						cObsFis3 := SF4->F4_OBS3
					EndIf
				EndIf		
           		AADD(vTes,SD1->D1_TES)
            EndIf
			lMOD := .T.
		EndIf
		SD1->(dbSkip())
	Enddo
	
	SD1->(DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE))
	 
//	Cabecalho() // Impressão do Cabeçalho da Nota Fiscal.
	
	vMsgDev:= {}              
	vNfB := {}
	
	While !SD1->(Eof()) .And. SF1->F1_FILIAL == SD1->D1_FILIAL;
		.And. SF1->F1_DOC == SD1->D1_DOC ;
		.And. SD1->D1_SERIE == SF1->F1_SERIE
		
		SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
		
		SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
	
		
		If Ascan(vTes,{|x| x = SD1->D1_TES}) = 0 //!lMOD
			//cObsFis1 := IIf(!Empty(SF4->F4_OBS1),SF4->F4_OBS1,"") Substituido pelo trecho abaixo por Ulisses Jr em 06/09/07
			//cObsFis2 := IIf(!Empty(SF4->F4_OBS2),SF4->F4_OBS2,"")                        "
			//cObsFis3 := IIf(!Empty(SF4->F4_OBS3),SF4->F4_OBS3,"")                        "
            If !Empty(SF4->F4_OBS1) 
				If Empty(cObsFis1)
					cObsFis1 := SF4->F4_OBS1
				ElseIf Empty(cObsFis2)
					cObsFis2 := SF4->F4_OBS1
				ElseIf Empty(cObsFis3)
					cObsFis3 := SF4->F4_OBS1
				EndIf
			EndIf	
			If !Empty(SF4->F4_OBS2)
				If Empty(cObsFis1)
					cObsFis1 := SF4->F4_OBS2
				ElseIf Empty(cObsFis2)
					cObsFis2 := SF4->F4_OBS2
				ElseIf Empty(cObsFis3)
					cObsFis3 := SF4->F4_OBS2
				EndIf
			EndIf
			If !Empty(SF4->F4_OBS3)
				If Empty(cObsFis1)
					cObsFis1 := SF4->F4_OBS3
				ElseIf Empty(cObsFis2)
					cObsFis2 := SF4->F4_OBS3
				ElseIf Empty(cObsFis3)
					cObsFis3 := SF4->F4_OBS3
				EndIf
			EndIf	
            AADD(vTes,SD2->D2_TES)
		EndIf
		
  	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Tratamento para mensagens na devolucao da Nota ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SD1->D1_NFORI) //- Devolucao ou Beneficiamento
		   nPos:= aScan(vMsgDev,{|x| x[1]+x[2] = SD1->D1_NFORI+SD1->D1_SERIORI })
		   If nPos = 0 
		      SF1Area := SF1->(GetArea())
		      SF1->(DbSeek(xFilial("SF1")+SD1->(D1_NFORI+D1_SERIORI)))
		      AADD(vMsgDev,{ SD1->D1_NFORI, SD1->D1_SERIORI, SF1->F1_EMISSAO } )
		      SF1->(RestArea(SF1Area))
		   Endif            
		Endif
		
	
		If SD1->D1_TP # "MO" //Se for Produto                 
		    nPos    := Ascan(vProd,{|x| x[1] = SD1->D1_COD } )
		    nPrcProd:= SD1->D1_VUNIT //If((SD2->D2_DESCON+SD1->D1_DESCZFR) > 0, SD2->D2_PRUNIT, SD2->D2_PRCVEN)
			If nPos = 0
				AADD(vProd,{SB1->B1_COD,;                     // Código do Produto
				            SB1->B1_DESC,;                             // Descrição do Produto
				            Alltrim(SB1->B1_ORIGEM)+SF4->F4_SITTRIB,;  // Situação tributária
				            SD1->D1_UM,;                               // Un	idade de medida
				            SD1->D1_QUANT,;                            // Quantidade
				            nPrcProd,;                                 // Preço unitário (1)
				            nPrcProd * SD1->D1_QUANT,;                 // Valor Total    (2)
				            SD1->D1_PICM } )                           // Porcentagem de ICMS
				            //SD2->D2_PRCVEN,;                         // Preço unitário (1)
				            //SD2->D2_PRCVEN * SD2->D2_QUANT,;         // Valor Total    (2)
			Else
				vProd[nPos][5] += SD1->D1_QUANT
				//vProd[nPos][7] += (SD2->D2_PRCVEN * SD2->D2_QUANT)     //SD2->D2_TOTAL
				vProd[nPos][7] += (nPrcProd * SD1->D1_QUANT)     //SD2->D2_TOTAL
			EndIf
			     
			If SD1->D1_ORIGLAN == "LO" //- Vendido pelo loja
			   nValorProd := nValorProd + (SD1->D1_PRUNIT * SD1->D1_QUANT) //SD2->D2_TOTAL
			Else 
			   nPrcProd:= SD1->D1_VUNIT
			   nValorProd := nValorProd + (nPrcProd * SD2->D2_QUANT) //SD2->D2_TOTAL
			Endif   
			nValIcm    := nValIcm + SD1->D1_VALICM
			nBasIcm    := nBasIcm + SD1->D1_BASEICM
			nValIpi    := nValIpi + SD1->D1_VALIPI

			cTES := SD1->D1_TES
			CFOP := SD1->D1_CF
			
			nDescont += SD1->D1_VALDESC
			//nDescIcm += SD2->D2_DESCZFR

		Else //Se for Serviço
			
			//SC5->(DbSetOrder(1))
			//SC6->(DbSetOrder(1))
			U_MsSetOrder("SC5","C5_FILIAL+C5_NUM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
			U_MsSetOrder("SC6","C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
			
			//SC5->(DbSeek(xFilial("SC5")+SD1->D1_PEDIDO))
			//SC6->(DbSeek(xFilial("SC6")+SD1->D1_PEDIDO))
			/*
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
			 */
			AADD(vServ,{"SRV",;                               	//Unidade de medida
			SD1->D1_QUANT,;                             		   	//Quantidade
			"",;                                 			//Observação 1
			SD1->D1_PRUNIT,; //SD2->D2_PRCVEN,; 		//Preço unitário
			(SD1->D1_VUNIT*SD1->D1_QUANT)})	//SD2->D2_TOTAL   //Valor Total
			
			nValorServ := nValorServ + (SD1->D1_VUNIT*SD1->D1_QUANT)//SD2->D2_TOTAL
			nValIss    := SF1->F1_VALISS //nValIss    + SD2->D2_VALICM
			nAliqIss   := SD1->D1_ALIQISS
		EndIf
		
		SD1->(dbSkip())
		
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Mensagem na nota fiscal de devolucao ou Beneficiamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(vMsgDev) > 0 
       cObsFis1:= IIF(SF1->F1_TIPO = "D", "DEVOLUCAO NF " , "NOTA FISCAL ")
       cObsFis2:= "" 
       cObsFis3:= ""    
	   For i:= 1 to Len(vMsgDev)		
	      If i < 4 		      
	         cObsFis1 += If(i>1,",","") + vMsgDev[i,1] + "/" + vMsgDev[i,2] + " DE " + Dtoc(vMsgDev[i,3])
	      ElseIf i < 8 
	         cObsFis2 += "," + vMsgDev[i,1] + "/" + vMsgDev[i,2] + " DE " + Dtoc(vMsgDev[i,3])
	      Else
	         cObsFis3 += "," + vMsgDev[i,1] + "/" + vMsgDev[i,2] + " DE " + Dtoc(vMsgDev[i,3])   
	      Endif   
	   Next    
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ajusta mensagem informada no controle de loja  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*    If !Empty(SF2->F2_NFCUPOM) 
       c_Nota := SF2->F2_DOC   //- Substr(SF2->F2_NFCUPOM,4,6)
       c_Serie:= SF2->F2_SERIE //- Substr(SF2->F2_NFCUPOM,1,3)  
       //- Buscando mensagem informada no controle de loja
       //SL1->(DbSetOrder(2))
       U_MsSetOrder("SL1","L1_FILIAL+L1_SERIE+L1_DOC+L1_PDV")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
       
       If SL1->(DbSeek(xFilial("SL1")+c_Serie+c_Nota))  
 	      //cObsFis1 := SL1->L1_OBS1
		  //cObsFis2 := SL1->L1_OBS2
          If !Empty(SL1->L1_OBS1) 
		     If Empty(cObsFis1)
			    cObsFis1 := SL1->L1_OBS1
			 ElseIf Empty(cObsFis2)
				cObsFis2 := SL1->L1_OBS1
			 ElseIf Empty(cObsFis3)
				cObsFis3 := SL1->L1_OBS1
			 EndIf
          EndIf
		  If !Empty(SL1->L1_OBS2)
		     If Empty(cObsFis1)
			    cObsFis1 := SL1->L1_OBS2
			 ElseIf Empty(cObsFis2)
				cObsFis2 := SL1->L1_OBS2
			 ElseIf Empty(cObsFis3)
				cObsFis3 := SL1->L1_OBS2
			 EndIf
	      EndIf		
       Endif
    Endif*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verificando endereco de cobranca do cliente atraves do grupo de clientes  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA1") // Cadastro de Cliente
	//SA1->(dbSetOrder(1))
	U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
	If SF1->F1_TIPO $ "D,B"
		SA1->(dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA))
		
		If !Empty(SA1->A1_GRPVEN)
		   cObsFis2:= "Entregar na " + Trim(SA1->A1_ENDCOB) 
		   cObsFis3:= Trim(SA1->A1_BAIRROC) + " - " + Trim(SA1->A1_MUNC) + "/" + SA1->A1_ESTC + " -Cep:" + SA1->A1_CEPC 
		Endif
	EndIf		
		nContProd := 1
		nContServ := 1
		lImprime  := .T.
	
		nFormulario:= 0
	
	While lImprime
		
		Cabecalho() // Impressão do Cabeçalho da Nota Fiscal. 11/07/07
		nNumItens := 1
		
		While nContProd <= Len(vProd) .and. nNumItens < 17
			@ li,003 Psay vProd[nContProd][1]                                 // Código do Produto       // li -> 33
			@ li,019 Psay vProd[nContProd][2]                                 // Descrição do Produto    // li -> 33
			@ li,080 Psay vProd[nContProd][3]                                 // Origem+Sit. Tributaria  // li -> 33
			@ li,086 Psay vProd[nContProd][4]                                 // Unidade Medida          // li -> 33
			@ li,089 Psay Transform(vProd[nContProd][5],"@E 9999.99")         // Quantidade              // li -> 33
			@ li,096 Psay Transform(vProd[nContProd][6],"@E 999,999.9999")    // Valor Unitário          // li -> 33
			@ li,110 Psay Transform(vProd[nContProd][7],"@E 9,999,999.99")    // Valor Total             // li -> 33
			@ li,124 Psay Transform(vProd[nContProd][8],"@E 99")+"%"          // Percentual de ICMS      // li -> 33
			li++
			nContProd++
			nNumItens++
		Enddo
		     
		If nContProd > Len(vProd) .and. nDescont > 0
			@ li, 099 Psay "Desconto : "+Transform(nDescont,"@E 9,999,999.99")
			lDesc := .T.
		EndIf
		
		If nContProd > Len(vProd) .and. nDescIcm > 0
	        If lDesc
	        	li++
	        EndIf
			@ li, 092 Psay "Desconto de ICMS: "+Transform(nDescIcm,"@E 9,999,999.99")
		EndIf

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
		
		If nContProd <= Len(vProd) .or. nContServ < Len(vServ)
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
			@ li,122 Psay Transform(If(SF1->F1_TIPO == "I",0,nValorProd),"@E 999,999,999.99") // li -> 71
			lImprime := .F.
		EndIf
		
		li += 2
		
		nValIss := If(nInd < 0, SF1->F1_VALISS*nInd,0)
		If SF1->F1_TIPO == "D"
			nTotal := SF1->F1_VALBRUT
		Else
			nTotal := nValorProd+nValIpi+SF1->F1_FRETE+SF1->F1_SEGURO+SF1->F1_DESPESA+nValorServ+nValIss-(nDescont+nDescIcm) //IF(Alltrim(SF2->F2_ESPECIE)$"CF#NF",0,SF2->F2_DESCONT)
		EndIf	
		
		If nContProd <= Len(vProd) .or. nContServ < Len(vServ)
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
		li += 3 // li -> 77
		
		If SA4->(dbSeek(xFilial("SA4")+If(!lTranspLj,SC5->C5_TRANSP,cTransp)))
			@ li,003 Psay SA4->A4_NOME  // li -> 77
			//@ li,089 Psay If(SC5->C5_TPFRETE=="F","1","2")  // li -> 77
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
			@ li,089 Psay If(SC5->C5_TPFRETE=="F","1","2")  // li -> 77
			li += 4
		EndIf
		cEspecie := ""// Era SC5->C5_ESPECIE1
		@ li,012 Psay Transform(nQuanVol,"@E 9999") // li -> 81
		@ li,030 Psay cEspecie // li -> 81
		@ li,097 Psay Transform(nPesoBru,"@E 999,999.999") // li -> 81
		@ li,122 Psay Transform(nPesoLiq,"@E 999,999.999") // li -> 81
		li:=li+2     //1234567890123456789012345678901234567890123456789012345678901234567890
        
	//	@ li,004 Psay MsgNfCupom(" ")
		li++
/*		
		If Len(vServ) > 0 .and. !Empty(SC6->C6_NUMOS)
			@ li,004 Psay "PEDIDO : "+SC5->C5_NUM +" / "+"OS : "+Left(SC6->C6_NUMOS,6)+" / "+"ORC FIELD: "+Left(AB7->AB7_NUMORC,6)
		EndIf
		li++
		If !Empty(SF2->F2_VEND1)
			@ li,004 Psay "VENDEDOR : "+Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_NREDUZ") // "ESPACO RESERVADO PARA MENSAGENS DA NF NUM TOTAL DE 65 CARACTERES "
		EndIf

		If !Empty(SF2->F2_VEND2)
			@ li,025 Psay "ATENDENTE : "+Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND2,"A3_NREDUZ") // "ESPACO RESERVADO PARA MENSAGENS DA NF NUM TOTAL DE 65 CARACTERES "
		EndIf
  */
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
		//@ li,004 Psay MsgDepCC()   //- Mensagem para deposito em C/C
		li += 4
		@ li,127 Psay NumNota() // SF2->F2_DOC
		li ++
		If ((Val(mv_par02)-Val(mv_par01)) > 0 .or. (nContProd < Len(vProd) .or. nContServ < Len(vServ)))
			li += 4
		EndIf
		@ li,000 Psay " "
	Enddo
	
	SF1->(dbSkip())
	
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
Local c_RecISS,c_RecINSS,c_RecCOFI,c_RecCSLL,c_RecPIS,n_Valor

Li:= PROW()+1
nFimItens := Li+44
nFimServc := Li+48

SD1->(dbSeek(xFilial("SD2")+SF1->F1_DOC+SF1->F1_SERIE))

If lMOD .And. Empty(cTes)
	SF4->(dbSeek(xFilial("SF4")+SD1->D1_TES))
	//CFOP := SF4->F4_CF
	CFOP := SD1->D1_CF
Else
//	SF4->(dbSeek(xFilial("SF4")+cTes))
	//CFOP := SF4->F4_CF
	While !SD1->(Eof()) .and. SD1->(D1_DOC+D1_SERIE) = SF1->(F1_DOC+F1_SERIE)
		If SD1->D1_TES = cTes
			CFOP := SD1->D1_CF
			Exit
		EndIf
		SD1->(dbSkip())
	End	

    nDescont := If(nDescont = 0, SF1->F1_DESCONT, nDescont)
Endif

/*
SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
*/
nQuanVol := 0//SC5->C5_VOLUME1
nPesoLiq := 0//SC5->C5_PESOL
nPesoBru := 0//SC5->C5_PBRUTO
/***********************************************
Armazena as parcelas dos clientes
***********************************************/
Vetor1 := {}

DbSelectArea("SE1")
//SE1->(dbSetOrder(1))
U_MsSetOrder("SE1","E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
IF SE1->(dbSeek(xFilial("SE1")+SF1->F1_SERIE+SF1->F1_DUPL))
	While SE1->E1_NUM == SF1->F1_DUPL
	    If !Trim(E1_TIPO) $ "IS-,IR-,IN-" .And. Trim(SE1->E1_NATUREZ) $ "31101001#31101002"   
	        c_RecISS  := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_RECISS")
	        c_RecINSS := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_RECINSS")
	        c_RecCOFI := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_RECCOFI")
	        c_RecCSLL := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_RECCSLL")
	        c_RecPIS  := Posicione("SA1",1,xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA),"A1_RECPIS")
  		    n_Valor   := SE1->E1_VALOR
  		    If c_RecISS = "1"
   		        n_Valor -= SE1->E1_ISS
   		    Endif   
  		    AADD(Vetor1,{SE1->E1_VENCREA,n_Valor,SE1->E1_TIPO,SE1->E1_NUM,SE1->E1_PARCELA})
  		Endif   
		SE1->(dbSkip())
	Enddo
Endif

/************************************************
Impressão do Cabeçalho da Nota Fiscal de Saída
*************************************************/

If SF1->F1_TIPO $ "B#D"
	dbSelectArea("SA1") // Cadastro de Cliente
	//SA1->(dbSetOrder(1))
	U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       	
	SA1->(dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA))
	If SA1->A1_RECISS $ " #2"
		nInd := 1
		If AT("ISS RETIDO",cObsFis1) > 0
			cObsFis1 := ""
		EndIf
		If AT("ISS RETIDO",cObsFis2) > 0
			cObsFis2 := ""
		EndIf
		If AT("ISS RETIDO",cObsFis3) > 0
			cObsFis3 := ""
		EndIf
	Else
		nInd := -1
	EndIf	
Else
	dbSelectArea("SA2") // Cadastro de Fornecedor
	//SA2->(dbSetOrder(1))
	U_MsSetOrder("SA2","A2_FILIAL+A2_COD+A2_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
	alert(SA2->(dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)))
	nInd := 1
EndIf
@ li,127 Psay NumNota() //SF2->F2_DOC // li ->1
li += 1
@ li,105 Psay "X"  //li ->5
li += 5

@ li,003 Psay Trim(SF4->F4_TEXTO) // li -> 10
@ li,047 Psay Transform(CFOP,"@R 9.999") // li ->10
li += 3
//021
@ li,003 Psay If(SF1->F1_TIPO $ "B#D",SA1->A1_COD+" - "+SA1->A1_NOME,SA2->A2_COD+" - "+SA2->A2_NOME) //li -> 13
@ li,095 Psay If(SF1->F1_TIPO $ "B#D",SA1->A1_CGC,SA2->A2_CGC) Picture "@R 99.999.999/9999-99" // li -> 13
@ li,127 Psay SF1->F1_EMISSAO // li -> 13
li += 2

@ li,003 Psay If(SF1->F1_TIPO $ "B#D",SA1->A1_END,SA2->A2_END) //li -> 15
@ li,079 Psay If(SF1->F1_TIPO $ "B#D",SA1->A1_BAIRRO,SA2->A2_BAIRRO) //li -> 15
@ li,107 Psay If(SF1->F1_TIPO $ "B#D",SA1->A1_CEP,SA2->A2_CEP) //li -> 15
li += 2

@ li,003 Psay If(SF1->F1_TIPO $ "B#D",SA1->A1_MUN,SA2->A2_MUN)//li -> 17
@ li,064 Psay Transform(If(!SF1->F1_TIPO $ "B#D",SA1->A1_TEL,SA2->A2_TEL),"!!!!!!!!!!!!!!") //li -> 17
@ li,085 Psay If(SF1->F1_TIPO $ "B#D",SA1->A1_EST,SA2->A2_EST) //li -> 17
@ li,094 Psay If(SF1->F1_TIPO $ "B#D",SA1->A1_INSCR,SA2->A2_INSCR) //li -> 17
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
//@li,003 Psay SD1->D1_PEDIDO           

//SC5->(DbSetOrder(1))
U_MsSetOrder("SC5","C5_FILIAL+C5_NUM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
//SC5->(DbSeek(xFilial("SC5")+SD2->D2_PEDIDO))

//@li,070 Psay SC5->C5_MENNOTA
//@li,107 Psay If(!SF2->F2_TIPO $ "B#D",SA1->A1_CONTATO,SA2->A2_CONTATO) //li -> 17
li += 4 // li -> 27
Return

**********************
Static Function Selo()
**********************

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
Local cNumNota:= Space(9)
	cNumNota:= SF1->F1_DOC
//Endif
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
  //SE4->(DbSetOrder(1))
  U_MsSetOrder("SE4","E4_FILIAL+E4_CODIGO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       
  SE4->(DbSeek(xFilial("SE4")+SF1->F1_COND))
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


////////////////////////////
STATIC Function MsgDevolucao

Return nil