//
// Ponto de entrada chamado apos a gravacao do orcamento de vendas
//
USER Function LJ7002   
  Local aArea      := GetArea()
  Local lTemBoleto := .F.
  Local cBcoPad,cNat,nRecSE1
   	
  //- Verificando se o campo L1_TIPO = V, caso afirmativo, trata-se de uma venda finalizada.        
  If Empty(SL1->L1_TIPO)
     U_SCRORC(1)
     //If MsgYesNo("Imprime orcamento de separacao de pecas ?")
     //   U_SCRORC(2)
   	 //Endif
  Endif
   
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Atualizando banco/agencia/conta corrente no financeiro   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
  If !Empty(SL1->L1_TIPO)

     cBcoPad := GetMv("MV_BCOBOL") // Banco padrao para geracao de boleto
      
     cBuscaSE1:= SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC)+"A" 
  
     //- Parametros bancos
     SEE->(DbSetOrder(1))
     SEE->(dbSeek(xFilial("SEE")+cBcoPad))
      
     //- Contas a Receber
     SE1->(DbSetOrder(2))                       
     SE1->(dbSeek(xFilial("SE1")+cBuscaSE1))
     
     If !SE1->(Found())
        ALERT("NAO ACHOU "+cBuscaSE1 + "Key: " + SE1->(INDEXKEY()))     
     Endif
        
     nRecSE1:= SE1->(Recno())      
  
     While !SE1->(Eof()) .And. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC) 
        RecLock("SE1",.F.)
        SE1->E1_ADM:= SE1->E1_CLIENTE
         
        //- Cartao de credito/debito
        If TRIM(SE1->E1_TIPO) $ "CC#CD"
           cNat:= Posicione("SAE",1,xFilial("SAE")+Trim(SE1->E1_CLIENTE),"AE_NATUREZ")
           SE1->E1_NATUREZ:= If(!Empty(cNat),cNat,"CARTAO")
        Endif                         
     
        //- Deposito C/C
        If TRIM(SE1->E1_TIPO) $ "DP" 
           SE1->E1_NATUREZ:= GetMv("MV_NATDEPO")
        Endif  
         
        //- Boleto bancario
        If TRIM(SE1->E1_TIPO) $ "BO#FI"
           SE1->E1_PORTADO := If(!Empty(SEE->EE_CODIGO)  , SEE->EE_CODIGO  , SE1->E1_PORTADO)
           SE1->E1_AGEDEP  := If(!Empty(SEE->EE_AGENCIA) , SEE->EE_AGENCIA , SE1->E1_AGEDEP)
           SE1->E1_CONTA   := If(!Empty(SEE->EE_CONTA)   , SEE->EE_CONTA   , SE1->E1_CONTA)
           SE1->E1_SITUACA := "1"
           lTemBoleto:= .T.
        Endif   
        MsUnLock()
        SE1->(dbSkip())
     Enddo
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Impressao do boleto bancario ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
     If lTemBoleto
        SE1->(Dbgoto(nRecSE1))
        U_BLTCD001(.t.)
     Endif
  Endif
  RestArea(aArea)
Return   