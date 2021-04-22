#include "rwmake.ch"     
#include 'MsOle.ch'     
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  intword   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 08/05/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ O objetivo eh fazer a integracao entre o Protheus e o MS Word. ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function intword()
   
   Local cPerg := "RAGR08"
   Local oDlg

   //ValidPerg(cPerg)
   Pergunte(cPerg,.T.)

   @ 96,012 TO 250,400 DIALOG oDlg TITLE OemToAnsi("Integracao com MS-Word")
   @ 08,005 TO 048,190
   @ 18,010 SAY OemToAnsi("Esta rotina ira imprimir os contratos conforme os parametros digitados.")
   @ 56,100 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.T.)
   @ 56,130 BMPBUTTON TYPE 1 ACTION (WordImp(),oDlg:End())
   @ 56,160 BMPBUTTON TYPE 2 ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED
   
Return()

Static Function WordImp()
//Variáveis do Cabeçalho
Local wcContrato,wcCliente,wcEndereco,wcCnpj,wcInscEstadual,wcInscMunic,wcRepresentante,wcIdentidade,wcOrgao,wcCPF
Local wcTempo,wcDataIni,wcDataFim, wcEmissao
//Variáveis dos Itens
Local waCod		:= {}
Local waDescr	:= {}
Local waVTot	:= {}
Local waVTotprv := {}
Local nAuxTot	:= 0 //valor do aluguel
Local nAuxPrv   := 0 //valor original do produto
//
Local cPathDot	:= "\\AGROSYSTEM\Protheus8\Protheus_Data\dirdoc\Contrato.Dot"
Private	hWord

//Close(oDlg)
//Abertura dos arquivos para seleção e dados.
dbSelectArea("SA1") //Cadastro de Clientes
dbSetOrder(1)

dbSelectArea("SB1") //Cadastro de Clientes
dbSetOrder(1)

dbSelectArea("AAM")//Cabeçalho dos contratos
dbSetOrder(1)//AAM_FILIAL+AAM_CONTRT

dbSelectArea("AAN")//Itens dos contratos
dbSetOrder(1)//AAN_FILIAL+AAN_CONTRT+AAN_ITEM

AAM->(dbSeek(xFilial("AAM")+MV_PAR01))
SA1->(dbSeek(xFilial("SA1")+AAM->AAM_CODCLI+AAM->AAM_LOJA))

//Carrega as Variáveis do cabeçalho dos contratos
wcContrato	    := AAM->AAM_CONTRT
wcCliente	    := AAM->AAM_CODCLI+"-"+SA1->A1_NOME
wcEndereco      := SA1->A1_END+"-"+SA1->A1_BAIRRO
wcCnpj          := SA1->A1_CGC 
wcInscEstadual  := SA1->A1_INSCR
wcInscMunic     := SA1->A1_INSCRM
wcRepresentante := AAM->AAM_REPRES 
wcIdentidade    := AAM->AAM_RG
wcOrgao         := AAM->AAM_ORG
wcCPF           := AAM->AAM_CPF
wcTempo         := Alltrim(Str(AAM->AAM_FIMVIG - AAM->AAM_INIVIG))
wcDataIni       := AAM->AAM_INIVIG
wcDataFim       := AAM->AAM_FIMVIG
wcEmissao       := DTOC(dDataBase)
//Carrega no Vetor os Itens
AAN->(dbSeek(xFilial("AAN")+MV_PAR01))
While !AAN->(Eof()) .And. AAN->AAN_CONTRT == MV_PAR01
    aAdd(waCod,SB1->B1_COD)
    SB1->(dbSeek(xFilial("SB1")+AAN->AAN_CODPRO+"01"))
	aAdd(waDescr,SB1->B1_DESC)
	aAdd(waVTotprv,Transform(SB1->B1_PRV1,"@E 999,999,999.99"))
	aAdd(waVTot,Transform(AAN->AAN_VALOR,"@E 999,999,999.99"))
	nAuxTot += AAN->AAN_VALOR
	nAuxPrv += SB1->B1_PRV1
AAN->(dbSkip())
EndDo
//Conecta ao word
hWord	:= OLE_CreateLink()
OLE_SetPropertie( hWord, oleWdPrintBack, .T.)
OLE_SetPropertie( hWord, oleWdVisible, .T.)
OLE_NewFile(hWord, cPathDot)
//Montagem das variaveis do cabecalho		
OLE_SetDocumentVar(hWord, 'cContrato'      , wcContrato)
OLE_SetDocumentVar(hWord, 'cCliente'       , wcCliente)	
OLE_SetDocumentVar(hWord, 'cEndereco'      , wcEndereco)	
OLE_SetDocumentVar(hWord, 'cCnpj'          , wcCnpj)	
OLE_SetDocumentVar(hWord, 'cInscEstadual'  , wcInscEstadual)	
OLE_SetDocumentVar(hWord, 'cInscMunic'     , wcInscMunic)	
OLE_SetDocumentVar(hWord, 'cRepresentante' , wcRepresentante)	
OLE_SetDocumentVar(hWord, 'cIdentidade'    , wcIdentidade)	
OLE_SetDocumentVar(hWord, 'cOrgao'         ,wcOrgao)	
OLE_SetDocumentVar(hWord, 'cCPF'           ,wcCPF)	
OLE_SetDocumentVar(hWord, 'cTempo'         ,wcTempo)	
OLE_SetDocumentVar(hWord, 'cDataIni'       ,wcDataIni)	
OLE_SetDocumentVar(hWord, 'cDataFim'       ,wcDataFim)	
OLE_SetDocumentVar(hWord, 'cEmissao'       ,wcEmissao)	

//Tratamento para os itens
OLE_SetDocumentVar(hWord, 'Prt_nroitens',str(Len(waCod)))	//variavel para identificar o numero total de
															//linhas na parte variavel
															//Sera utilizado na macro do documento para execucao 
															//do for next
//Montagem das variaveis dos itens. No documento word estas variaveis serao criadas dinamicamente da seguinte forma:
// prt_cod1, prt_cod2 ... prt_cod10
For nK := 1 to Len(waCod)
	OLE_SetDocumentVar(hWord,"prt_cod"  +AllTrim(Str(nK)),waCod[nK])
	OLE_SetDocumentVar(hWord,"prt_descr"+AllTrim(Str(nK)),waDescr[nK])
	OLE_SetDocumentVar(hWord,"prt_prv"  +AllTrim(Str(nK)),waVTotprv[nK])
	OLE_SetDocumentVar(hWord,"prt_tot"  +AllTrim(Str(nK)),waVTot[nK])
next
OLE_ExecuteMacro(hWord,"tabitens")
OLE_SetDocumentVar(hWord, 'prt_totorc', Transform(nAuxTot,"@E 999,999,999.99"))
OLE_SetDocumentVar(hWord, 'prt_totprv', Transform(nAuxPrv,"@E 999,999,999.99"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando as variaveis do documento do Word                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OLE_UpdateFields(hWord)
//If MsgYesNo("Imprime o Documento ?")
//	Ole_PrintFile(hWord,"ALL",,,1)
//EndIf
		
If MsgYesNo("Fecha o Word e Corta o Link ?")
   OLE_CloseFile( hWord )
   OLE_CloseLink( hWord )
Endif	

Return()
