//
// Ponto de entrada chamado apos a gravacao do orcamento de vendas
//
USER Function LJ7002
   Local cNat, nReg, xNil
   Local aArea      := GetArea()
   Local cArqNota   := "\BOLETOS\"+SL1->(L1_DOC+L1_SERIE)
   Local cEOL       := CHR(13)+CHR(10)
   Local cSeq       := "01"
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

      // Calcula o nome do arquivo de LOG
      While File(cArqNota+cSeq+".LOG")
         cSeq := StrZero(Val(cSeq)+1,2)
      Enddo

      // Cria o arquivo em disco
      xNil := MsFCreate(cArqNota+cSeq+".LOG")

      //- Parametros bancos
      SEE->(DbSetOrder(1))
      If SEE->(dbSeek(xFilial("SEE")+cBcoPad))
         FWrite(xNil,"01 - ENTROU SEE : "+SEE->EE_CODIGO+SEE->EE_AGENCIA+SEE->EE_CONTA+cEOL)
      Else
         FWrite(xNil,"01 - SAIU SEE.. : "+cBcoPad+cEOL)
      Endif

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Atualizando dados do portador                    ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      SE1->(dbSetOrder(2))
      If SE1->(dbSeek(cBusca,.T.))
         FWrite(xNil,"02 - ENTROU SE1 : "+cBusca+" - Registro: "+RTrim(Str(SE1->(Recno()),10))+cEOL)
      Else
         FWrite(xNil,"02 - SAIU SE1.. : "+cBusca+cEOL)
      Endif

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
         FWrite(xNil,"03 - ENTROU LOOP: Parcela "+SE1->E1_PARCELA+", Tipo: "+SE1->E1_TIPO+" - Registro: "+RTrim(Str(SE1->(Recno()),10))+cEOL)
         If ALLTRIM(SE1->E1_TIPO) $ "BO#FI"
            FWrite(xNil,"04 - ENTROU CONDICAO E GRAVOU REGISTRO ACIMA."+cEOL)
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
         FWrite(xNil,"05 - TEM BOLETO PARA IMPRESSAO."+cEOL)
         SE1->(dbGoTo(nReg))
         U_BLTCD001(.T.,xNil)
      Endif

      FWrite(xNil,"07 - PROCESSO FINALIZADO."+cEOL)
      FClose(xNil)
   Endif
   RestArea(aArea)

Return