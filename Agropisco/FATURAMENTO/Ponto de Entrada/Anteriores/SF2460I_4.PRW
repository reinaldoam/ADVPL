#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF2460I   º Autor ³ Reinaldo Magalhaes º Data ³  02/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para gravar a origem do documento na NF   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Agropisco                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function SF2460I
  Local cNat, cBusca, nReg
  Local aArea      := GetArea()
  Local lSigaTec   := .F.
  Local lTemBoleto := .F.
  Local cFilSE1    := SE1->(xFilial("SE1"))
  Local cForma     := GetMV("MV_OUTFORM") //- Relacao de condicoes de pagamentos que nao sao vendas

  If !(SF2->F2_COND $ cForma)
     SD2->(dbSetOrder(3)) //- Item nota fiscal
     SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE),.T.))
     While !SD2->(Eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE) == SD2->(D2_FILIAL+D2_DOC+D2_SERIE)
        If SD2->D2_TP == "MO"
           lSigaTEC:= .T.
        Endif
        SD2->(DbSkip())
     Enddo
     Reclock("SF2",.F.)
       If lSIGATEC
         SF2->F2_ORIGEM:= "TEC" //- Field Service
        Else
         SF2->F2_ORIGEM:= "VEN" //- Faturamento
       Endif
     MsUnlock()
  Endif

  cBusca:= SF2->(F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DUPL)

  U_GrvCtRec() //Função incluida por Ulisses Jr em 11/10/07 para refazer
  			   //o contas a receber de acordo com as formas de pagamento

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Atualizando banco/agencia/conta corrente no financeiro   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cBcoPad := GetMv("MV_BCOBOL")

  //- Parametros bancos
  SEE->(DbSetOrder(1))
  SEE->(dbSeek(xFilial("SEE")+cBcoPad))

  //- Contas a receber
  SE1->(dbSetOrder(2)) //- E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
  SE1->(dbSeek(cBusca,.T.))
  nReg := SE1->(Recno())
  While !Eof() .And. cBusca == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
     If TRIM(SE1->E1_NATUREZ) $ '31101001,31101002'
        Reclock("SE1",.F.)
        SE1->E1_PORTADO := SEE->EE_CODIGO
        SE1->E1_AGEDEP  := SEE->EE_AGENCIA
        SE1->E1_CONTA   := SEE->EE_CONTA
        SE1->E1_SITUACA := '1'
        SE1->(MsUnlock())
        lTemBoleto:= .T.
     Endif
     SE1->(dbSkip())
  Enddo

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Impressao do boleto bancario  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If lTemBoleto
     SE1->(dbGoTo(nReg))
     U_BLTCD001(.t.)
  Endif
  RestArea(aArea)

RETURN