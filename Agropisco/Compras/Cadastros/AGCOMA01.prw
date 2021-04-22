#include "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"                                                                         

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ AGCOMA01   ¦ Autor ¦                      ¦ Data ¦ 24.07.15   ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina para importar XML das notas fiscais de entrada         ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦                                                                           ¦¦¦
¦¦¦                                                                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AGCOMA01
  Local aTipo:={'N','B','D'} // N-Normal B-Beneficiamento D-Devolucao
  Local nQtd := 0, nValor := 0, cCodProd 
  Local cFile := Space(10)
  Private CPERG   :="NOTAXML"
  Private Caminho := "temp\"

  // Prepara a Pergunta ---                                                      
  Validperg()

  Do while .T.

     Pergunte(CPERG,.T.)    

	 cFile:= cGetFile( "Arquivo NFe (*.xml) | *.xml", "Selecione o Arquivo de Nota Fiscal XML",,Caminho,.T., )  
	 Compara=RetFileName(cFile)  
	 Caminho=Substr(cFile,1,Len(cFile) - (Len(Compara)+4))

	 aDirectory=Directory(caminho+"*.*")
	 nProcura:=aScan(aDirectory,{|x| lower(x[1]) ==lower(compara)+'.xml'})
	 
	 Private nHdl:= fOpen(cFile)

	 aCamposPE:={}

	 If nHdl == -1
	    If !Empty(cFile)
		   MsgAlert("O arquivo de nome "+cFile+" nao pode ser aberto! Verifique os parametros.","Atencao!")
		Endif 	
		Return
	 Endif
	 nTamFile := fSeek(nHdl,0,2)
	 fSeek(nHdl,0,0)
	 cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
	 nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
	 fClose(nHdl)

	 cAviso := ""
	 cErro  := ""
	 oNfe := XmlParser(cBuffer,"_",@cAviso,@cErro)					
	 Private oNF

	 If Type("oNFe:_NfeProc")<> "U"
		oNF := oNFe:_NFeProc:_NFe
	 Else
		oNF := oNFe:_NFe
	 Endif     
	 
	 Private oEmitente  := oNF:_InfNfe:_Emit
	 Private oIdent     := oNF:_InfNfe:_IDE
	 Private oDestino   := oNF:_InfNfe:_Dest
	 Private oTotal     := oNF:_InfNfe:_Total
	 Private oTransp    := oNF:_InfNfe:_Transp
	 Private oDet       := oNF:_InfNfe:_Det
	 Private oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)  
	 Private cEdit1	    := Space(15)
	 Private _DESCdigit :=space(55)
	 Private _NCMdigit  :=space(8)

	 oDet := IIf(ValType(oDet)=="O",{oDet},oDet) 
     
	 // Validacoes -------------------------------
	 // -- CNPJ da NOTA = CNPJ do CLIENTE ? oEmitente:_CNPJ          
	 If mv_par01=1
		_cnpj=GetAdvFVal("SA2","A2_CGC",XFilial("SA2")+mv_par02+mv_par03,1,"")
		dbSelectArea("SM0")
		cCGC := SM0->M0_CGC
		cFli := SM0->M0_FILIAL
	 Else
		_cnpj=GetAdvFVal("SA1","A1_CGC",XFilial("SA1")+mv_par02+mv_par03,1,"") 		
	 EndIf  
              
	 If _cnpj!=oEmitente:_CNPJ:TEXT
		If !MsgStop ("CNPJ do Client/Fornec. digitado ("+mv_par02+"/"+mv_par03+") é diferente do CNPJ do XML("+oEmitente:_CNPJ:TEXT+").Selecione Cliente Correto !!!")
			Return Nil
		Endif 
	 Endif

	 If  cCGC!=oDestino:_CNPJ:TEXT
		If !MsgStop ("Este XML é da Filial:   ("+  oDestino:_enderDest:_xBairro:TEXT  +")  CNPJ:  ("+  oDestino:_CNPJ:TEXT  +"),  Só e Permitido Importar XML da Filial  (" +cFli+ ")  CNPJ: (" +cCGC+ ")")
			Return Nil
		Endif
	 Endif  

	 // -- Nota Fiscal já existe na base ? 
	 If SF1->(DbSeek(XFilial("SF1")+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+Padr(OIdent:_serie:TEXT,3)+mv_par02+mv_par03)) 
		MsgAlert("Nota No.: "+Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)+"/"+OIdent:_serie:TEXT+" do Cliente/Fornec. "+mv_par02+"/"+mv_par03+" Ja Existe. A Importacao sera interrompida")
		Return Nil   
	 Endif
  
	 If  mv_par04 <> (OIdent:_nNF:TEXT)
		Alert("Nota Informada Nao confere com XML Selecionado") 
		Return Nil    
	 EndIf  

	 aCabec := {}
	 aItens := {}
	 
	 aadd(aCabec,{"F1_TIPO"   ,aTipo[mv_par01],Nil,Nil})
	 aadd(aCabec,{"F1_FORMUL" ,"N",Nil,Nil})
	 aadd(aCabec,{"F1_DOC"    ,Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9),Nil,Nil})
	
	 If OIdent:_serie:TEXT ='0'
		aadd(aCabec,{"F1_SERIE"  ,"   ",Nil,Nil})
	 Else  
		aadd(aCabec,{"F1_SERIE"  ,OIdent:_serie:TEXT,Nil,Nil})
	 Endif  
                                 
     //2015-06-29T17:30:58-03:00
	 //cData:=Alltrim(OIdent:_dHEmi:TEXT)
	 //dData:=CTOD(Right(cData,2)+'/'+Substr(cData,6,2)+'/'+Left(cData,4))

	 cData:=Alltrim(OIdent:_dHEmi:TEXT)
	 dData:=Substr(cData,9,2)+'/'+Substr(cData,6,2)+'/'+Left(cData,4)
	 
	 aadd(aCabec,{"F1_EMISSAO",dData,Nil,Nil})
	 aadd(aCabec,{"F1_FORNECE",mv_par02,Nil,Nil})
	 aadd(aCabec,{"F1_LOJA"   ,mv_par03,Nil,Nil})
	 aadd(aCabec,{"F1_ESPECIE","SPED",Nil,Nil})
	    
	 For nX := 1 To Len(oDet)
		// Validacao: Produto Existe no SB1 ? 
		// Se não existir, abrir janela c/ codigo da NF e descricao para digitacao do cod. substituicao. 
		// Deixar opção para cancelar o processamento //  Descricao: oDet[nX]:_Prod:_xProd:TEXT
  
		aLinha := {}
		cProduto:=Left(oDet[nX]:_Prod:_cProd:TEXT+space(15),15)

		cNCM:=IIF(Type("oDet[nX]:_Prod:_NCM")=="U",space(12),oDet[nX]:_Prod:_NCM:TEXT)
		Chkproc=.F.

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Efetua busca na tabela SA5 Produto x Fornecedor  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		DbSelectArea("SA5")
		DbSetOrder(14) // A5_FILIAL+A5_FORNECE+A5_LOJA+A5_CODPRF
		
        If !SA5->(DbSeek(xFilial("SA5")+mv_par02+mv_par03+cProduto))		
		   
		   If !MsgYesNo ("Produto Cod.: "+cProduto+" Nao Encontrado. Informar código correto?")
		      Return Nil
		   Endif
		   
		   DEFINE MSDIALOG _oDlg TITLE "Dig.Cod.Substituicao" FROM C(177),C(192) TO C(509),C(659) PIXEL
		
		      // Cria as Groups do Sistema
		      @ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg

		      // Cria Componentes Padroes do Sistema
		      @ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
		      @ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg			
		      @ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd()) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
		      @ C(040),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
		      @ C(048),C(027) Say "Descricao: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
		      // oSAY1:=TSay():New( C(048),C(027),{||"Descricao: "+_DESCdigit},_oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,C(150),C(032))			
		      @ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Troca())
		      @ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
		      oEdit1:SetFocus()
		
		   ACTIVATE MSDIALOG _oDlg CENTERED 
		   
		   If Chkproc!=.T.
		      MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
			  Return Nil
		   EndIf            
		   cCodProd:= cEdit1

           //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           //³Efetua gravacao na tabela SA5 Produto x Fornecedor  ³
           //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
           RecLock("SA5",.T.)
           SA5->A5_FILIAL:= xFilial("SA5")               
           SA5->A5_FORNECE := mv_par02
           SA5->A5_LOJA    := mv_par03
           SA5->A5_PRODUTO := cCodProd
           SA5->A5_CODPRF  := Left(oDet[nX]:_Prod:_cProd:TEXT+space(15),15)
           SA5->(MsUnLock())
		Else
		   cCodProd:= SA5->A5_PRODUTO
        Endif
		             
		//- Cadastro de Produtos
	    DbSelectArea("SB1")
	    DbSetOrder(1)                             
	    SB1->(DbSeek(XFilial("SB1")+cCodProd))

		//If Empty(SB1->B1_POSIPI) .and. !Empty(cNCM) .and. cNCM != '00000000'
		If !Empty(cNCM) .and. cNCM != '00000000'
		   If SB1->B1_XNCMOK <> "1"
		      RecLock("SB1",.F.)
		      Replace B1_POSIPI with cNCM
		      Replace B1_XNCMOK with "1"
		      MSUnLock()        
		   Endif   
		Endif   
			
		//* Comentado para que a tratativa seja feito pelo
		//If !SB1->(DbSeek(XFilial("SB1")+cProduto)) 
		//	If !MsgYesNo ("Produto Cod.: "+cProduto+" Nao Encontrado. Digita Codigo de Substituicao?")
		//		Return Nil
		//	Endif
		//	DEFINE MSDIALOG _oDlg TITLE "Dig.Cod.Substituicao" FROM C(177),C(192) TO C(509),C(659) PIXEL
		//
		//	// Cria as Groups do Sistema
		//	@ C(002),C(003) TO C(071),C(186) LABEL "Dig.Cod.Substituicao " PIXEL OF _oDlg
        //
		//	// Cria Componentes Padroes do Sistema
		//	@ C(012),C(027) Say "Produto: "+cProduto+" - NCM: "+cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
		//	@ C(020),C(027) Say "Descricao: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg			
		//	@ C(028),C(070) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd()) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
		//	@ C(040),C(027) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
		//	@ C(048),C(027) Say "Descricao: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
		//	// oSAY1:=TSay():New( C(048),C(027),{||"Descricao: "+_DESCdigit},_oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,C(150),C(032))			
		//	@ C(004),C(194) Button "Processar" Size C(037),C(012) PIXEL OF _oDlg Action(Troca())
		//	@ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
        //
		//	oEdit1:SetFocus()
		//
		//	ACTIVATE MSDIALOG _oDlg CENTERED 
		//	If Chkproc!=.T.
		//		MsgAlert("Produto Cod.: "+cProduto+" Nao Encontrado. A Importacao sera interrompida")
		//		Return Nil
		//	EndIf
		//Else                                       
		//	If Empty(SB1->B1_POSIPI) .and. !Empty(cNCM) .and. cNCM != '00000000'
		//		RecLock("SB1",.F.)
		//		Replace B1_POSIPI with cNCM
		//		MSUnLock()
		//	Endif   
		//Endif 
		//aadd(aLinha,{"D1_COD",cProduto,Nil,Nil})
		
        aadd(aLinha,{"D1_COD",cCodProd,Nil,Nil})		
		
		//Jr 16.07.12
		If Val(oDet[nX]:_Prod:_qTrib:TEXT) != 0 
			nQtd := Val(oDet[nX]:_Prod:_qTrib:TEXT)
		Else
			nQtd := Val(oDet[nX]:_Prod:_qCom:TEXT)
		Endif

		nValor := Val(oDet[nX]:_Prod:_vUnCom:TEXT)
		
		If RetCodFil(_cnpj) == GetMv('MV_VXMLI') .or. RetCodFil(cCGC) == GetMv('MV_VXMLI')//Parâmetro deve conter filial com tratamento diferenciado
			cTpConv := If(SB1->B1_TIPCONV == 'M','D','M')
			If cTpConv == 'M'
				nQtd := nQtd*SB1->B1_CONV
				nValor := nValor*SB1->B1_CONV
			Else
				nQtd := nQtd/SB1->B1_CONV
				nValor := nValor/SB1->B1_CONV
			EndIf
		EndIf
		
		aadd(aLinha,{"D1_QUANT",nQtd,Nil,Nil})
		aadd(aLinha,{"D1_VUNIT",nValor,Nil,Nil})
		//Fim Jr				

		aadd(aLinha,{"D1_TOTAL",Val(oDet[nX]:_Prod:_vProd:TEXT),Nil,Nil})
//		aadd(aLinha,{"D1_TES",SB1->B1_TE,Nil,Nil})
		
		_cfop:=oDet[nX]:_Prod:_CFOP:TEXT
		If Left(Alltrim(_cfop),1)="5"
			_cfop:=Stuff(_cfop,1,1,"1")
		Else
			_cfop:=Stuff(_cfop,1,1,"2")
		Endif   
//		aadd(aLinha,{"D1_CF",_cfop,Nil,Nil})
		If Type("oDet[nX]:_Prod:_vDesc")<> "U"
			aadd(aLinha,{"D1_VALDESC",Val(oDet[nX]:_Prod:_vDesc:TEXT),Nil,Nil})
		Endif                      

		//Do Case
		//	Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS00")<> "U"
		//		oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS00
		//	Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS10")<> "U"
		//		oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS10
		//	Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS20")<> "U"
		//		oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS20
		//	Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS30")<> "U"
		//		oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS30
		//	Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS40")<> "U"
		//		oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS40
		//	Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS51")<> "U"
		//		oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS51
		//	Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS60")<> "U"
		//		oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS60
		//	Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS70")<> "U"
		//		oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS70
		//	Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS90")<> "U"
		//		oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS90
		//EndCase
		//CST_Aux:=Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CST:TEXT)
		//aadd(aLinha,{"D1_CLASFIS",CST_Aux,Nil,Nil})

		aadd(aItens,aLinha)
	Next nX
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Inclusao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cx=1                         
	// - Executa a Ultima Nota
	If Len(aItens) > 0
		lMsErroAuto:=.f.
		lMsHelpAuto:=.T.
		ROLLBACKSXE()
		//MSExecAuto({|x,y,z|Mata103(x,y,z)},aCabec,aItens,3) //Nota
		MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3) //Pré-Nota
		If lMsErroAuto
			MSGALERT("ERRO NO PROCESSO")
			MostraErro()
		Else
			ConfirmSX8()
			MSGALERT(Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+" - DOC.GERADO ")
		Endif
	Endif		
Enddo
U_AGP001()
Return 
                            
///////////////////////////
Static Function ValidPerg()
  //
  PRIVATE APERG := {},AALIASSX1:=GETAREA()
  //-- Preencho com espaços, senão o Dbseek nao funciona 
  CPERG=Left(CPERG+Space(10),10)

  //     "X1_GRUPO" ,"X1_ORDEM","X1_PERGUNT"    		,"X1_PERSPA"		,"X1_PERENG"		,"X1_VARIAVL","X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"	,"X1_VALID"	,"X1_VAR01"	,"X1_DEF01"	,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,"X1_VAR02"	,"X1_DEF02"		,"X1_DEFSPA2"		,"X1_DEFENG2"		,"X1_CNT02"	,"X1_VAR03"	,"X1_DEF03"	,"X1_DEFSPA3"	,"X1_DEFENG3"	,"X1_CNT03"	,"X1_VAR04"	,"X1_DEF04"	,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,"X1_VAR05"	,"X1_DEF05"	,"X1_DEFSPA5","X1_DEFENG5"	,"X1_CNT05"	,"X1_F3"	,"X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"
  AADD(APERG,{CPERG ,"01"		,"Tipo de Nota ?"		,"Nota Fiscal de?"	,"Nota Fiscal de?"	,"mv_ch1"	,"N"		,1				,0				,1				,"C"		,""			,"mv_par01"	,"Normal"   ,"Normal"		,"Normal"		,""			,""			,"Beneficiamento","Beneficiamento"	,"Beneficiamento"	,""			,""			,"Devolucao","Devolucao"	,"Devolucao"	,""			,""			,""			,""				,""				,""			,""			,""			,""			,""				,""			,"" 		,"S"		,""				,""})
  AADD(APERG,{CPERG ,"02"		,"Cliente/Fornec ?"	,"Cliente/Fornec ?"	,"Cliente/Fornec ?"	,"mv_ch2"	,"C"		,6				,0				,0				,"C"		,""			,"mv_par02"	,""			,""				,""				,""			,""			,""				,""					,""					,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""			,""				,""			,"FOR" 		,"S"		,""			,""})
  AADD(APERG,{CPERG ,"03"		,"Loja ?"				,"Loja ?"			   ,"Loja ?"			   ,"mv_ch3"	,"C"		,2				,0				,0				,"G"		,""			,"mv_par03"	,""			,""				,""				,""			,""			,""				,""					,""					,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""			,""				,""			,"" 		,"S"		,""				,""})
  AADD(APERG,{CPERG ,"04"		,"Nota ?"				,"Nota ?"			   ,"Nota ?"			   ,"mv_ch4"	,"C"		,9 			,0				,0				,"C"		,""			,"mv_par04"	,""			,""				,""				,""			,""			,""				,""					,""					,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""			,""				,""			,"" 		,"S"		,""				,""})

  DBSELECTAREA("SX1")
  DBSETORDER(1)
  //
  FOR I := 1 TO LEN(APERG)
    IF  !DBSEEK(CPERG+APERG[I,2])
	   RECLOCK("SX1",.T.)
	   FOR J := 1 TO FCOUNT()
	      IF  j <= LEN(APERG[I])
		     FIELDPUT(J,APERG[I,J])
		  ENDIF
	   NEXT
	   MSUNLOCK()
	ENDIF
  NEXT
  RESTAREA(AALIASSX1)
  //
RETURN()

Static Function C(nTam)                                                         
  Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     

  If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
     nTam *= 0.8                                                                
  ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
	 nTam *= 1                                                                  
  Else	// Resolucao 1024x768 e acima                                           
	 nTam *= 1.28                                                               
  EndIf                                                                         
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
  //³Tratamento para tema "Flat"³                                               
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
  If "MP8" $ oApp:cVersion                                                      
     If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
	    nTam *= 0.90                                                            
	 EndIf                                                                      
  EndIf                                                                         
Return Int(nTam)                                                                
  
/////////////////////////
Static Function ValProd()
  _DESCdigit=Alltrim(GetAdvFVal("SB1","B1_DESC",XFilial("SB1")+cEdit1,1,""))
  _NCMdigit=GetAdvFVal("SB1","B1_POSIPI",XFilial("SB1")+cEdit1,1,"")
Return 	ExistCpo("SB1")                                                                               
                         
///////////////////////
Static Function Troca()  
  Chkproc=.T.      
  cProduto=cEdit1
  If Empty(SB1->B1_POSIPI) .and. !Empty(cNCM) .and. cNCM != '00000000'
     RecLock("SB1",.F.)
	 Replace B1_POSIPI with cNCM
  	 MSUnLock()
  Endif 
  _oDlg:End()
Return

/*---------+------------+-------+------------------+------+---------------¦
¦ Função   ¦ RetCodFil  ¦ Autor ¦ UJ               ¦ Data ¦ 16/07/2012    ¦
+----------+------------+-------+------------------+------+---------------+
¦ Descriçäo¦ Retorna o código da filial baseado no CNPJ.                  ¦
+----------+--------------------------------------------------------------*/
Static Function RetCodFil(__xCnpj)
  Local __cFil := ""
  Local nSM0Recno := SM0->(Recno())
  SM0->(dbGoTop())
  While !SM0->(Eof())
     If SM0->M0_CGC == __xCnpj
	    __cFil := SM0->M0_CODFIL
		Exit
	 EndIf
	 SM0->(dbSkip())
  Enddo
  SM0->(dbGoTo(nSM0Recno))
Return __cFil 
                
///////////////////////////
Static Function FornProduto
  Local aProdForn:= {}
  
  For nX := 1 To Len(oDet)
  Next
 


         DEFINE MSDIALOG oDlg TITLE "Parcelas" FROM 8,0 TO 250,500 PIXEL
         oDlg:nStyle := nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_VISIBLE )

         @ 020,010 LISTBOX oLbx VAR cVar FIELDS HEADER "Data",;
                                                       "Valor",;
                                                       "Form.Pgto.",;
                                                       "Moeda" SIZE 230,088 OF oDlg PIXEL ;
                   ON dblClick( MudaParc(oLbx:nAt,@aParcelas,cSimbCheq),oLbx:Refresh(.F.) )
         oLbx:SetArray( aParcelas )
         oLbx:bLine := {|| { aParcelas[oLbx:nAt,1],;
                             Transform(aParcelas[oLbx:nAt,2],"@E 999,999,999.99"),;
                             aParcelas[oLbx:nAt,3],;
                             aParcelas[oLbx:nAt,4]}}

         ACTIVATE MSDIALOG oDlg CENTERED ON INIT;
                                EnchoiceBar(oDlg,{|| nOpcA:=1,oDlg:End() }, {||oDlg:End()} )











