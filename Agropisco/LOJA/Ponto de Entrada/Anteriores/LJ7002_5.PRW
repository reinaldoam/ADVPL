//
// Ponto de entrada chamado apos a gravacao do orcamento de vendas
//
USER Function LJ7002
   Local cNat, nReg
   Local aArea      := GetArea()
   Local cBcoPad    := GetMv("MV_BCOBOL") // Banco padrao para geracao de boleto
   Local lTemBoleto := .F.
   Local cFilSE1    := SE1->(xFilial("SE1"))
   Local cBusca     := SL1->(L1_FILIAL+L1_CLIENTE+L1_LOJA+L1_SERIE+L1_DOC)

   //- Verificando se o campo L1_TIPO = V, caso afirmativo, trata-se de uma venda finalizada.
   If Empty(SL1->L1_TIPO)
      U_SCRORC(1)
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Atualizando banco/agencia/conta corrente no financeiro   ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If !Empty(SL1->L1_TIPO) // Se for finalização de venda

      //- Parametros bancos
      SEE->(DbSetOrder(1))
      SEE->(dbSeek(xFilial("SEE")+cBcoPad))

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualizando dados do portador                    ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      SE1->(dbSetOrder(2))
      SE1->(dbSeek(cBusca,.T.))
      nReg := SE1->(Recno())
      While !SE1->(Eof()) .And. cBusca == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)

         RecLock("SE1",.F.)
         SE1->E1_ADM:= SE1->E1_CLIENTE

         //- Cartao de credito/debito
         If ALLTRIM(SE1->E1_TIPO) $ "CC#CD"
            cNat:= Posicione("SAE",1,xFilial("SAE")+Trim(SE1->E1_CLIENTE),"AE_NATUREZ")
            SE1->E1_NATUREZ := If(!Empty(cNat),cNat,"CARTAO")
         Endif

         //- Deposito C/C
         If ALLTRIM(SE1->E1_TIPO) $ "DP"
            SE1->E1_NATUREZ := GetMv("MV_NATDEPO")
         Endif

         //- Boleto bancario
         If ALLTRIM(SE1->E1_TIPO) $ "BO#FI"
            SE1->E1_PORTADO := SEE->EE_CODIGO
            SE1->E1_AGEDEP  := SEE->EE_AGENCIA
            SE1->E1_CONTA   := SEE->EE_CONTA
            SE1->E1_SITUACA := "1"
            lTemBoleto      := .T.
         Endif
         MsUnLock()

         SE1->(dbSkip())
      Enddo

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Impressao do boleto bancario  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If lTemBoleto
         SE1->(dbGoTo(nReg))
         U_BLTCD001(.T.)
      Endif
   Endif
   RestArea(aArea)

Return