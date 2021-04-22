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
  Local cNat, cBusca, nReg, xNil
  Local aArea      := GetArea()
  Local cArqNota   := "\BOLETOS\"+SF2->(F2_DOC+F2_SERIE)
  Local cEOL       := CHR(13)+CHR(10)
  Local cSeq       := "01"
  Local lSigaTec   := .F.
  Local lTemBoleto := .F.
  Local cFilSE1    := SE1->(xFilial("SE1"))
  Local cForma     := GetMV("MV_OUTFORM") //- Relacao de condicoes de pagamentos que nao sao vendas

  // Calcula o nome do arquivo de LOG
  While File(cArqNota+cSeq+".LOG")
     cSeq := StrZero(Val(cSeq)+1,2)
  Enddo

  // Cria o arquivo em disco
  xNil := MsFCreate(cArqNota+cSeq+".LOG")

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

  U_GrvCtRec(xNil) //Função incluida por Ulisses Jr em 11/10/07 para refazer
  			       //o contas a receber de acordo com as formas de pagamento

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Atualizando banco/agencia/conta corrente no financeiro   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cBcoPad := GetMv("MV_BCOBOL")

  //- Parametros bancos
  SEE->(DbSetOrder(1))
  If SEE->(dbSeek(xFilial("SEE")+cBcoPad))
     FWrite(xNil,"01 - ENTROU SEE : "+SEE->EE_CODIGO+SEE->EE_AGENCIA+SEE->EE_CONTA+cEOL)
  Else
     FWrite(xNil,"01 - SAIU SEE.. : "+cBcoPad+cEOL)
  Endif

  //- Contas a receber
  SE1->(dbSetOrder(2)) //- E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
  If SE1->(dbSeek(cBusca,.T.))
     FWrite(xNil,"02 - ENTROU SE1 : "+cBusca+" - Registro: "+RTrim(Str(SE1->(Recno()),10))+cEOL)
  Else
     FWrite(xNil,"02 - SAIU SE1.. : "+cBusca+cEOL)
  Endif

  nReg := SE1->(Recno())
  While !Eof() .And. cBusca == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
     FWrite(xNil,"03 - ENTROU LOOP: Parcela "+SE1->E1_PARCELA+", Natureza: "+SE1->E1_NATUREZ+" - Registro: "+RTrim(Str(SE1->(Recno()),10))+cEOL)
     If TRIM(SE1->E1_NATUREZ) $ '31101001,31101002'
        FWrite(xNil,"04 - ENTROU CONDICAO E GRAVOU REGISTRO ACIMA."+cEOL)
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
     FWrite(xNil,"05 - TEM BOLETO PARA IMPRESSAO."+cEOL)
     SE1->(dbGoTo(nReg))
     U_BLTCD001(.t.,xNil)
  Endif
  RestArea(aArea)

  FWrite(xNil,"07 - PROCESSO FINALIZADO."+cEOL)
  FClose(xNil)

RETURN