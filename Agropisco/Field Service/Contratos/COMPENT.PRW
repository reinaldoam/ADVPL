#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function COMPENT()

titulo    := PADC("COMPROVANTE DE ENTREGA",74)
cDesc1    := PADC("IRA EMITIR UM COMPROVANTE DE LOCACAO DE EQUIPAMENTOS",74)
cDesc2    := PADC("",74)
cDesc3    := ""
cNatureza := ""
cResp     := "N"
nomeprog  := "COMPENT"
cString   := "AAM"
cViaTransp:= ""
aReturn   := { "Especial", 1,"Administracao", 1, 3, 8, "",1 }
nLastKey  := 0
cPerg     := "COMPEN"
pag       := 0
li        := 0
nFimItens := 0
nFimServc := 0

aArea := GetArea()  // Grava a area atual

ValidPerg()
pergunte(cPerg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint("AAM",NomeProg,,titulo,cDesc1,cDesc2,cDesc3,.F.,"")
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

DbSelectArea("AAM")
//DbSetOrder(1)                    
U_MsSetOrder("AAM","AAM_FILIAL+AAM_CONTRT")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

AAM->(dbSeek( xFilial("AAM")+MV_PAR01 ))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no arquivo cabe‡alho								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "AAN" )
//dbSetOrder( 1 )
U_MsSetOrder("AAN","AAN_FILIAL+AAN_CONTRT+AAN_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
AAN->(dbSeek( xFilial("AAN")+MV_PAR01 ))

@ li,000 PSAY Chr(15)

Cabec1()

//- Cadastro de Clientes
DbSelectArea("SA1")
//DbSetOrder(1)
U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

If SA1->(DbSeek(XFilial()+AAM->AAM_CODCLI+AAM->AAM_LOJA))
	
	Cabec2()
	
	nDiaria  := 0
	
	DbSelectArea("AAN")
//	DbSetOrder(1)
	U_MsSetOrder("AAN","AAN_FILIAL+AAN_CONTRT+AAN_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
    AAN->(DbSeek(xFilial()+AAM->AAM_CONTRT))
	
	While AAM->AAM_FILIAL+AAM->AAM_CONTRT == AAN->AAN_FILIAL+AAN->AAN_CONTRT .And. !AAN->(Eof())
			
	   SB1->(DbSeek(xFilial()+AAN->AAN_CODPRO))
			
       @ li,001 PSAY SB1->B1_COD
  	   @ li,016 PSAY AllTrim(Left(SB1->B1_DESC,40))                         
	   @ li,059 PSAY AAN->AAN_QTEQP Picture "9999999"
	   @ li,075 PSAY Transform(AAN->AAN_VUNEQP,"@E 999,999.99")
	   @ li,100 PSAY Transform(AAN->AAN_VLREQP,"@E 999,999.99")
	   @ li,120 PSAY AAN->AAN_NUMSER
   	   li := li + 1
	   
	   nDiaria += AAN->AAN_VLRUNI
	   
	   AAN->(DbSkip())
	   
	Enddo
	li++
	@ li,001 PSAY "VALOR DA DIARIA : "+Transform(nDiaria,"@E 999,999,999.99")
	li++                                                                
    @ li,01 PSAY Replicate("-",130)								;li := li + 1
    @ li,001 PSAY "OBSERVACAO 1 : "+MV_PAR02						;li:=li+1
    @ li,001 PSAY "OBSERVACAO 2 : "+MV_PAR03						;li:=li+2
    @ li,001 PSAY "RECEBIDO POR :_________________________________________";li:=li+2
    @ li,001 PSAY "DATA DO RECEBIDO :_________/__________/__________ ";li:=li+2
    @ li,01 PSAY Replicate("-",130); 							li := li + 1
    
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
     
/*  @ li,001 PSAY "AGROPISCO COMERCIO E SERVICOS DE EQUIPAMENTOS LTDA"
  @ li,055 PSAY "COMPROVANTE DE ENTREGA - LOCACAO(OES) DE EQUIPAMENTO(S)
  @ li,115 PSAY dDataBase // Date()				
  li++ 
  @ li,001 PSAY "Rua Vinca No.238 - Crespo - Cep:69073-180 Manaus-AM"
  @ li,115 PSAY Time()
  li++
  @ li,001 PSAY "FONE:(92) 2121-4650/FAX:(92)2121-4660"  
  li++
  @ li,001 PSAY "E-mail:agropisco@agropisco.com.br - www.agropisco.com.br"  
  li++*/
                                             
 
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
  
  @ li,001 PSAY SM0->M0_NOMECOM                     
  @ li,055 PSAY "COMPROVANTE DE ENTREGA - LOCACAO(OES) DE EQUIPAMENTO(S)
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
  @ li,001 PSAY "NUM. CONTRATO:   "+ AAM->AAM_CONTRT
  @ li,060 PSAY "Inicio Vigencia: "+ DTOC(AAM->AAM_INIVIG)
  @ li,100 PSAY "Fim Vigencia:    "+ DTOC(AAM->AAM_FIMVIG)
  
  li := li + 1
  @ li,001 PSAY "Cliente : "   + Left(SA1->A1_Nome,30)
  @ li,060 PSAY "Endereco: "   + Left(SA1->A1_End,25)
  li := li + 1
  @ li,001 PSAY "Bairro  : "   + Left(SA1->A1_Bairro,20)
  @ li,060 PSAY "Cidade  : "   + SA1->A1_Mun
  @ li,085 PSAY "Estado  : "   + SA1->A1_Est
  @ li,100 PSAY "Cep     : "   + SA1->A1_Cep
  li := li + 1
  @ li,001 PSAY "Telefone: "   + SA1->A1_Tel
  @ li,030 PSAY "Fax     : "   + SA1->A1_Fax
  @ li,060 PSAY "C.G.C   : "   + SA1->A1_CGC
  @ li,100 PSAY "I. Est. : "   + SA1->A1_Inscr
  li := li + 1

  @ li,001 PSAY Replicate("-",130); 							li := li + 1
  @ li,001 PSAY "CODIGO        DESCRICAO DO PRODUTO                           QUANT.        PRECO UNIT.             VALOR 	EQUIP.       NUM. SERIE" 
  li := li + 1
  //             9999999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    XXXXXXXXXX    XX    9999999      999,999,99       9,999,999,99
  //             00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111
  //             00000000001111111111222222222233333333334444444444555555555566666666667777777777888888888899999999990000000000111111111122222222223
  //             01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
  @ li,01 PSAY Replicate("-",130); 							li := li + 1
Return

*******************************
Static Function ValidPerg()
*******************************

PutSX1(cPerg,"01","Do Contrato   :","","","mv_ch1","C",15,0,0,"G","","","","","mv_par01")
PutSX1(cPerg,"02","Observacao 1  :","","","mv_ch2","C",50,0,0,"G","","","","","mv_par02")
PutSX1(cPerg,"03","Observacao 2  :","","","mv_ch3","C",50,0,0,"G","","","","","mv_par03")
Return

Static Function TamToV(cPalavra,nTotal)
     Local nTam := 0
      For i := 1 To nTotal
       If(SubStr(cPalavra,i,1) == ",") 
        nTam:=i       
       EndIf
      Next
Return nTam