//
// Ponto de entrada chamado apos a gravacao do orcamento de vendas
//
USER Function LJ7002   
  Local aArea      := GetArea()
  Local lTemBoleto := .F.
  Local cFilSE1    := xFilial("SE1")
  Local cBcoPad,cNat
     	                     
  Local cBusca  := SL1->(L1_CLIENTE+L1_LOJA+L1_SERIE+L1_DOC)
  Local cBuscaK := SL1->(L1_SERIE+L1_DOC)    	

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
  If !Empty(SL1->L1_TIPO) // Se for finalização de venda
     
     cBcoPad := GetMv("MV_BCOBOL") // Banco padrao para geracao de boleto
  
     //- Parametros bancos
     //SEE->(DbSetOrder(1))
     U_MsSetOrder("SEE","EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
     SEE->(dbSeek(xFilial("SEE")+cBcoPad))

     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Atualizando dados do portador                    ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

//     U_MsSetOrder("SE1","E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
//     SE1->(dbSeek(cFilSE1+cBusca,.T.))
   
//     While !SE1->(Eof()) .And. cFilSE1+cBusca == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
     U_MsSetOrder("SE1","E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")
     SE1->(dbSeek(cFilSE1+cBuscaK,.T.))     
     While !SE1->(Eof()) .And. SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM) == cFilSE1+cBuscaK
  
        RecLock("SE1",.F.)
        SE1->E1_ADM:= SE1->E1_CLIENTE
         
        //- Cartao de credito/debito
        If ALLTRIM(SE1->E1_TIPO) $ "CC#CD"
           cNat:= Posicione("SAE",1,xFilial("SAE")+Trim(SE1->E1_CLIENTE),"AE_NATUREZ")
           SE1->E1_NATUREZ:= If(!Empty(cNat),cNat,"CARTAO")
        Endif                         
     
        //- Deposito C/C
        If ALLTRIM(SE1->E1_TIPO) $ "DP" 
           SE1->E1_NATUREZ:= GetMv("MV_NATDEPO")
        Endif  
         
        //- Boleto bancario
        If ALLTRIM(SE1->E1_TIPO) $ "BO#FI"
           SE1->E1_PORTADO := SEE->EE_CODIGO  
           SE1->E1_AGEDEP  := SEE->EE_AGENCIA 
           SE1->E1_CONTA   := SEE->EE_CONTA   
           SE1->E1_SITUACA := "1"
           lTemBoleto:= .T.
        Endif   
        SE1->(MsUnLock())
        SE1->(dbSkip())
     Enddo
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Impressao do boleto bancario ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
     If lTemBoleto
        //dbSelectArea("SE1")
        //dbSetOrder(2) //- E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
        U_MsSetOrder("SE1","E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
        SE1->(dbSeek(cFilSE1+cBusca,.T.))
        U_BLTCD001(.T.)
     Endif
  Endif
  RestArea(aArea)
Return   