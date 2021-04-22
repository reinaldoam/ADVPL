#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function SCRORC(nTipoRel)

SET PRINTER ON
SET DEVICE TO PRINTER 

SetPrvt("ARETURN,NPAG,LI,NTXJUROS,NPRECO,TOTPAGINA,ITEMORC")
SetPrvt("TOTGERAL,DESCITEM,CONTADOR,FORMA,CSTRING")
SetPrvt("c_Obs1,c_Obs2")

cNumOrc := SL1->L1_NUM

c_Obs1:= SL1->L1_OBS1
c_Obs2:= SL1->L1_OBS2        

nTipoRel:= 1

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao:   ³ ORCAMENTO ³ Autor ³ Reinaldo Magalhaes   ³ Data ³ 17.04.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Script de Orcamento para uma futura venda                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Agropisco                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³                                                                       ³±±
±±³05/03/2008³Diego Rafael   ³Bops 98346: Atualização da impressão de     ³±±
±±³                          ³somente Agropisco para a empresa que estiver³±±
±±³                          ³sendo Usada no momento                      ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
aReturn  := { "Especial", 1,"Administracao", 2, 2,"\\Vendas5\Epson", "",1 }

nPag     := 1
li       := 00                      
ITEMORC  := 9

titulo   := "Impressao de Orcamentos - " + iif(nTipoRel=1,"VIA CLIENTE","VIA ESTOQUE")
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
nTipo    := 0
cString  := "SL1"  
nomeprog := "SCRORC"
wnrel    := "SCRORC"
aArea := GetArea()  // Grava a area atual

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//wnrel:=SetPrint("SL1",NomeProg,,titulo,cDesc1,cDesc2,cDesc3,.F.,"")   
wnrel  := SetPrint(cString,wnrel,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,  ,   ,,,.F.,,'EPSON.DRV',.T.,,"\\Vendas5\Epson")

//If nTipoRel = 1 //- Orcamento de vendas
//   wnrel:=SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,  ,   ,,,.F.,,'EPSON.DRV',.T.,,"LPT1")
//Else
//   wnrel:=SetPrint(cString,wnrel,,@titulo,cDesc1,cDesc2,cDesc3,.F.,  ,   ,,,.F.,,'EPSON.DRV',.T.,,"LPT2")
//Endif

If LastKey() == 27 .or. nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If LastKey() == 27 .or. nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

//DbSelectArea("SB1")
//DbSetOrder(1)
U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluido por Ulisses Jr em 24/04/08 em substituição as linhas acima

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo cabe‡alho								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//dbSelectArea( "SL1" )
//dbSetOrder( 1 )
U_MsSetOrder("SL1","L1_FILIAL+L1_NUM")//Incluido por Ulisses Jr em 24/04/08 em substituição as linhas acima
dbSeek( xFilial("SL1")+cNumOrc )

c_Obs1:= SL1->L1_OBS1
c_Obs2:= SL1->L1_OBS2

@ li,000 PSAY Chr(15)

Cabec1()

//- Cadastro de Clientes
//DbSelectArea("SA1")
//DbSetOrder(1)
U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")//Incluido por Ulisses Jr em 24/04/08 em substituição as linhas acima

If SA1->(DbSeek(XFilial()+SL1->L1_CLIENTE+SL1->L1_LOJA))
	
	Cabec2()
	
	nTxJuros  := 0
	TotPagina := 0
	TotGeral  := 0
	DescItem  := 0
	Contador  := 0
	nCalTot   := 0
	nDifDesc  := 0
	
	//DbSelectArea("SL2")
	//DbSetOrder(1)
	U_MsSetOrder("SL2","L2_FILIAL+L2_NUM+L2_ITEM+L2_PRODUTO")//Incluido por Ulisses Jr em 24/04/08 em substituição as linhas acima
    SL2->(DbSeek(xFilial()+cNumOrc))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carregando orcamento em memoria para impressao posterior   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aOrca:= {}
    
	While SL1->L1_NUM == SL2->L2_NUM .And. !Eof()
	   nTxJuros := SL1->L1_JUROS / 100
	   nPreco   := 0
	   nVlrUnit := SL2->L2_PRCTAB
			
	   SB1->(DbSeek(xFilial()+SL2->L2_PRODUTO))
			
	   If SL1->L1_DESCNF > 0 .And. nTxjuros > 0 
          If AllTrim(SL1->L1_CONDPG) == "CN"
             nPreco := Round( (SL2->L2_VLRITEM + (SL2->L2_VLRITEM*nTxJuros))/SL2->L2_QUANT,7)
          Else
             nPreco := SL2->L2_VRUNIT
          EndIf
	   Else
	      nPreco := Round(nVlrUnit+(nVlrUnit*nTxJuros),5)
	   Endif         
	   Aadd(aOrca,{ SB1->B1_COD,                    + ;
		            AllTrim(Left(SB1->B1_DESC,40)), + ;
		            PADR(SB1->B1_LOCAGRO,10),       + ;
		            AllTrim(SB1->B1_UM),            + ;
		            SL2->L2_QUANT,                  + ;
  		            nPreco,                         + ;
		            SL2->L2_TABELA,                 + ;
   		            Round(SL2->L2_QUANT*nPreco,2),  + ;
   		            nTxJuros })
	   DbSelectArea("SL2") 
	   nDifDesc += SL2->L2_VALDESC
	   SL2->(DbSkip())
	Enddo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicio da impressao do orcamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Asort(aOrca,,, {|x,y| x[3] < y[3]})
	
	DBGOTOP()
	
	For J:= 1 to Len(aOrca)
       @ li,001 PSAY aOrca[j,1]
  	   @ li,016 PSAY aOrca[j,2]                         
   	   @ li,060 PSAY aOrca[j,3] Picture "@!"
	   @ li,074 PSAY aOrca[j,4]                            
	   @ li,080 PSAY aOrca[j,5] Picture "9999.99"
	   @ li,093 PSAY aOrca[j,6] Picture "@E 999,999.99"
	   @ li,105 PSAY aOrca[j,7] 
	   @ li,110 PSAY aOrca[j,8] Picture "@E 9,999,999.99"
   	   li := li + 1
	   Contador:= Contador + 1
	
	   If SL1->L1_DESCNF > 0 .And. aOrca[j,9] > 0
	      TotPagina := TotPagina + Round(aOrca[j,5]*aOrca[j,6],2)            
	   Else
	 	  TotPagina := TotPagina + NoRound(aOrca[j,5]*aOrca[j,6],2)
	   EndIf			          
	   
	   If Contador == 9 // Itens por pagina de orçamento
	      SubGeral()
		  TotGeral   := TotGeral + TotPagina
		  TotPagina  := 0
		  nPag       := nPag + 1
		  Cabec1()
		  li:= li + 1
		  DbSelectArea("SL1")
		  Cabec2()
		  Contador := 0
	   Endif
	Next
    DbSelectArea("SL2") 
	TotGeral  := TotGeral + TotPagina
	Geral(nDifDesc)
	Rodape_()
EndIf

RestArea( aArea ) // Restaura a area atual

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

DbCommitAll()
Ms_FLush()

Return

///////////////////////
Static Function Cabec1                                       
Local cEmail
Local nTamRua
  If nPag > 1
     li := li + 6
  Endif 

  SM0->(DbSelectArea("SM0"))
  SM0->(DbGoTop())
  While (!SM0->(EOF()))
    if SM0->M0_CODIGO == cEmpAnt
       If cEmpAnt == "03"
          cEmail := "E-mail:acompressores@hotmail.com "
          ElseIf cEmpAnt == "01"
              cEmail := "E-mail:agropisco@agropisco.com.br - www.agropisco.com.br"
       EndIf
       Exit
    End 
    SM0->(DbSkip())
  End
  
  nTamRua := TamToV(SM0->M0_ENDCOB,Len(SM0->M0_ENDCOB))
  
    /*  
  @ li,055 PSAY "DOC. SEM VALOR FISCAL" 
  li++
  @ li,001 PSAY "AGROPISCO COMERCIO E SERVICOS DE EQUIPAMENTOS LTDA"
  @ li,055 PSAY "ORCAMENTO" //+ iif(nTipoRel=1," - VENDAS "," - SEPARACAO")
  @ li,115 PSAY dDataBase // Date()				
  li++ 
  @ li,001 PSAY "Rua Vinca No.238 - Crespo - Cep:69073-180 Manaus-AM"
  @ li,115 PSAY Time()
  li++
  @ li,001 PSAY "FONE:(92) 2121-4650/FAX:(92)2121-4660"  
  li++
  @ li,001 PSAY "E-mail:agropisco@agropisco.com.br - www.agropisco.com.br"
  li++
  @ li,000 PSAY Replicate("-",130)
  li := li + 1*/ 
                                        
  @ li,055 PSAY "" 
  @ li,001 PSAY SM0->M0_NOMECOM                     
  @ li,055 PSAY "ORCAMENTO"
  @ li,115 PSAY dDataBase // Date()				
    li++ 
  @ li,001 PSAY  Trim(SUBSTR(SM0->M0_ENDCOB,0,nTamRua)) + "  No." + ;
                           AllTrim(SubStr(SM0->M0_ENDCOB,nTamRua+1,Len(SM0->M0_ENDCOB))) + ;
                           " - " + Trim(SM0->M0_BAIRCOB) + " - Cep: " + Trim(SubStr(SM0->M0_CEPCOB,0,5)) +;
                           "-" + Trim(SubStr(SM0->M0_CEPCOB,6,8)) + " " +;
                           Trim(SM0->M0_CIDCOB) + "-" + Trim(SM0->M0_ESTCOB)
  @ li,115 PSAY Time()
    li++ 
  @ li,001 PSAY "FONE:" + Trim(SM0->M0_TEL) +"/" + "FAX:"+Trim(SM0->M0_FAX)
    li++
  @ li,001 PSAY cEmail
    li++  
  @ li,000 PSAY Replicate("-",130)
    li := li + 1

Return

///////////////////////
Static Function Cabec2
  DbSelectArea("SA1")
  @ li,001 PSAY "NUM. ORC. : " + SL1->L1_NUM
  @ li,060 PSAY "Validade : "  + DTOC(SL1->L1_DTLIM)
  @ li,112 PSAY "Pagina : "    + Str(nPag,6)
  li := li + 1
  @ li,001 PSAY "Cliente : "   + Left(SA1->A1_Nome,30)
  @ li,060 PSAY "Endereco: "   + Left(SA1->A1_End,25)
  li := li + 1
  @ li,001 PSAY "Bairro  : "   + SA1->A1_Bairro
  @ li,031 PSAY "Cidade  : "   + SA1->A1_Mun
  @ li,061 PSAY "Estado  : "   + SA1->A1_Est
  @ li,101 PSAY "Cep     : "   + SA1->A1_Cep
  li := li + 1
  @ li,001 PSAY "Telefone: "   + SA1->A1_Tel
  @ li,030 PSAY "Fax     : "   + SA1->A1_Fax
  @ li,060 PSAY "C.G.C   : "   + SA1->A1_CGC
  @ li,100 PSAY "I. Est. : "   + SA1->A1_Inscr
  li := li + 1
  @ li,100 PSAY "RG/CPF  : "   + SA1->A1_PFISICA
  li := li + 1

  If SL1->L1_CONDPG == "CN "
     //- Condicao negociada
//     DbSelectArea("SL4")
//     DbSetOrder(1)
	 U_MsSetOrder("SL4","L4_FILIAL+L4_NUM+L4_ORIGEM")//Incluido por Ulisses Jr em 24/04/08 em substituição as linhas acima
     SL4->(DbSeek(xFilial("SL4")+SL1->L1_NUM))
     aForma:= {}
     While SL4->(L4_FILIAL+L4_NUM) == xFilial("SL4")+SL1->L1_NUM .And. !Eof()
        nPos:= aScan(aForma,{|x| x[1] = SL4->L4_FORMA })
        If nPos = 0                    
           DbSelectArea("SX5")
           DbSetOrder(1)
           Sx5->(DbSeek("  "+"24"+SL4->L4_FORMA)) 
           AADD(aForma,{SL4->L4_FORMA, ALLTRIM(Sx5->X5_DESCRI) })
        Endif     
        DbSelectArea("SL4")
        SL4->(DbSkip())
     Enddo                       
     @ li,001 PSAY "C. Pagto: " 
     For i:= 1 to Len(aForma)  
        @ li,011 PSAY aForma[i,2]
        li++ 
     Next
  Else
    // DbSelectArea("SE4")
   //  DbSetOrder(1)
   	 U_MsSetOrder("SE4","E4_FILIAL+E4_CODIGO")//Incluido por Ulisses Jr em 24/04/08 em substituição as linhas acima
     If SE4->(DbSeek(XFilial()+Sl1->L1_CondPG))
        @ li,001 PSAY "C. Pagto: "+AllTrim(SE4->E4_DESCRI)
     Endif
  Endif
        
  //DbSelectArea("SA3")
  //DbSetOrder(1)
  U_MsSetOrder("SA3","A3_FILIAL+A3_COD")//Incluido por Ulisses Jr em 24/04/08 em substituição as linhas acima
  If SA3->(DbSeek(XFilial()+Sl1->L1_Vend))
     @ li,060 PSAY "Vendedor: "+AllTrim(SA3->A3_Cod)+" - "+AllTrim(SA3->A3_NReduz)
     li := li + 1
  Endif
  @ li,001 PSAY Replicate("-",130); 							li := li + 1
  @ li,001 PSAY "CODIGO        DESCRICAO DO PRODUTO                        LOCALIZ.      UM     QUANT.     PRECO UNIT.  TB    VALOR TOTAL" 
  li := li + 1
  //             9999999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    XXXXXXXXXX    XX    9999999      999,999,99       9,999,999,99
  //             00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111
  //             00000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223
  //             01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
  @ li,01 PSAY Replicate("-",130)
  li := li + 1
Return

///////////////////////
Static Function Rodape_
  //@ li,01 PSAY Replicate("-",130)
  //li:= li +1          
  //@ li,01 PSAY c_Obs1
  //li:= li +1
  //@ li,01 PSAY c_Obs2
  //li:= li +1
  //@ li,01 PSAY " "   
 
  @ Prow()+1, 0 PSay Replicate("-", 129)
  @ Prow()+1, 0 PSay c_Obs1
  @ Prow()+1, 0 PSay c_Obs2
            
  //nAux:= 32 - Prow()
  
  @ Prow()+1, 0 PSay " "+Chr(27)+Chr(67)+Chr(2)
  
  If aReturn[5] == 1 //- Se impressao em disco, chama o gerenciador de impressao...
     Set Printer To
	 dbCommitAll()
	 OurSpool(wnrel)
  Endif
  DbCommitAll()
  Ms_FLush()
Return

/////////////////////////
Static Function SubGeral
  li := li + 1
  @ li,90 PSAY "Total Pagina ------> "+"R$ "+Transform(TotPagina,"@E 999,999.99")
  li := li + 1
  @ li,90 PSAY "Total Liq. Pagina -> "+"R$ "+Transform(TotPagina,"@E 999,999.99")
  li := li + 1
Return

////////////////////////////////
Static Function Geral(nDifDesc)
  //li := li + 1
  //If nTxJuros > 0 .and. SL1->L1_DESCNF > 0
  //   nDifDesc := 0
  //Else
  //	nDifDesc = SL1->L1_DESCONT
  //Endif                  
  
  For i:= Contador to ITEMORC - 2
     @ li,001 PSAY ""
     li++
  Next   
  
  @ li,90 PSAY "Total Geral ------> "+"R$ "+Transform(TotGeral,"@E 999,999.99")
  li := li + 1
  @ li,90 PSAY "Desconto Geral----> "+"R$ "+Transform(nDifDesc,"@E 999,999.99")
  li := li + 1
  @ li,90 PSAY "Total Liq. Geral -> "+"R$ "+Transform(TotGeral-nDifDesc,"@E 999,999.99")
  li++
  @ li,55 PSAY "MÍNIMO PARA FATURAMENTO E ENTREGA R$ 150,00" 
  li++
  @ li,55 PSAY "ORCAMENTO SUJEITO A APROVACAO DE CREDITO" 
  li++
  
Return

Static Function TamToV(cPalavra,nTotal)
     Local nTam := 0
      For i := 1 To nTotal
       If(SubStr(cPalavra,i,1) == ",") 
        nTam:=i       
       EndIf
      Next
Return nTam