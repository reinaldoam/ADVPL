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
  Local cNat, cwBusca, nReg, xNil
  Local aArea      := GetArea()
  Local cArqNota   := "\BOLETOS\"+SF2->(F2_DOC+F2_SERIE)
  Local cEOL       := CHR(13)+CHR(10)
  Local cSeq       := "01"
  Local lSigaTec   := .F.
  Local lTemBoleto := .F.
  Local lTemOS     := .F.
  Local cFilSE1    := SE1->(xFilial("SE1"))
  Local cForma     := GetMV("MV_OUTFORM") //- Relacao de condicoes de pagamentos que nao sao vendas

  Local cBanco   := Substr(GetMv("MV_XBCBB"),01,03)   
  Local cAgencia := Substr(GetMv("MV_XAGBB2"),01,05)   
  Local cConta   := Substr(GetMv("MV_XCCBB"),01,10)      
  Local cSbConta := Substr(GetMv("MV_XSBBB"),01,03)

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
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Gravando lista de preços ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  SD2->(dbSetOrder(3)) //- Item nota fiscal
  SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE),.t.))

  While !SD2->(Eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE) == SD2->(D2_FILIAL+D2_DOC+D2_SERIE)
     Reclock("SD2",.F.)
     SD2->D2_XPRCTAB := Posicione("SB0",1,xFilial("SB0")+SD2->D2_COD,"B0_PRV1")
     SD2->D2_XCODFAB := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_XCODFAB")
     SD2->(MsUnlock())
     SD2->(DbSkip())
  Enddo
  
  cwBusca:= xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DUPL)

  U_GrvCtRec(xNil) //Função incluida por Ulisses Jr em 11/10/07 para refazer
  			       //o contas a receber de acordo com as formas de pagamento

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Atualizando banco/agencia/conta corrente no financeiro   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  cBcoPad := GetMv("MV_BCOBOL")

  //- Parametros bancos
  //SEE->(DbSetOrder(1))
  //If SEE->(dbSeek(xFilial("SEE")+cBcoPad))
  //   FWrite(xNil,"01 - ENTROU SEE : "+SEE->EE_CODIGO+SEE->EE_AGENCIA+SEE->EE_CONTA+cEOL)
  //Else
  //   FWrite(xNil,"01 - SAIU SEE.. : "+cBcoPad+cEOL)
  //Endif
  
  //- Posiciona na Arq de Parametros CNAB
  DbSelectArea("SEE")
  DbSetOrder(1)
  If DbSeek(xFilial("SEE")+cBanco+PadR(cAgencia,05)+PadR(cConta,10)+PadR(cSbConta,03),.T.)
     FWrite(xNil,"01 - ENTROU SEE : "+SEE->EE_CODIGO+SEE->EE_AGENCIA+SEE->EE_CONTA+cEOL)
  Else                                             
     FWrite(xNil,"01 - SAIU SEE.. : "+cBcoPad+cEOL)
  Endif   

  //- Contas a receber
  SE1->(dbSetOrder(2)) //- E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO     
  SE1->(dbGoTop())
  If SE1->(dbSeek(cwBusca,.T.))
     FWrite(xNil,"02 - ENTROU SE1 : "+cwBusca+" - Registro: "+RTrim(Str(SE1->(Recno()),10))+cEOL)
  Else
     FWrite(xNil,"02 - SAIU SE1.. : "+cwBusca+cEOL)
  Endif

  nReg := SE1->(Recno())
  While !Eof() .And. cwBusca == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
     FWrite(xNil,"03 - ENTROU LOOP: Parcela "+SE1->E1_PARCELA+", Natureza: "+SE1->E1_NATUREZ+" - Registro: "+RTrim(Str(SE1->(Recno()),10))+cEOL)
     If TRIM(SE1->E1_NATUREZ) $ '31101001,31101002'
        FWrite(xNil,"04 - ENTROU CONDICAO E GRAVOU REGISTRO ACIMA."+cEOL)
        Reclock("SE1",.F.)
        SE1->E1_PORTADO := SEE->EE_CODIGO
        SE1->E1_AGEDEP  := SEE->EE_AGENCIA
        SE1->E1_CONTA   := SEE->EE_CONTA
        SE1->E1_SITUACA := '0'
        SE1->(MsUnlock())
        lTemBoleto:= .T.
     Endif
     SE1->(dbSkip())
  Enddo
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Gravando serie e nota das OS finalizadas ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  //If SF2->F2_ORIGEM = 'TEC' 
  //   GravaNota(SC6->C6_NUMOS)
  //Endif
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Gravar nota e serie no orçamento de serviços ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  SC6->(dbSetOrder(1)) //- Item do pedido de venda
  SD2->(dbSetOrder(3)) //- Item nota fiscal

  If SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE),.t.))
     If SC6->(DbSeek(SD2->(D2_FILIAL+D2_PEDIDO+D2_ITEMPV+D2_COD)))
        If !Empty(SC6->C6_NUMOS)
           GravaNota()
        Endif
     Endif   
  Endif   
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Impressao do boleto bancario  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If lTemBoleto
     FWrite(xNil,"05 - TEM BOLETO PARA IMPRESSAO."+cEOL)
     SE1->(dbGoTo(nReg))
     //U_BLTCD001(.t.,xNil,'FT')
     //U_AGFINR03(.t.,xNil,'FT') //AG: 1208-4
     U_AGFINR04(.t.,xNil,'FT') //AG: 5927-7
  Endif
  RestArea(aArea)

  FWrite(xNil,"07 - PROCESSO FINALIZADO."+cEOL)
  FClose(xNil)

RETURN
  
//////////////////////////
Static Function GravaNota
  Local cQry,nConta,cOrc
  
  cQry := "SELECT ISNULL(COUNT(*),0)CONTA "
  cQry += "FROM "+RetSQLName("AB4")+" AB4 "
  cQry += "WHERE AB4.D_E_L_E_T_ <> '*' "
  cQry += "AND AB4_FILIAL= '"+xFilial("AB4")+"' "     
  cQry += "AND AB4_NUMOS = '"+Substr(SC6->C6_NUMOS,1,8)+"' "     
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)),"TRB", .T., .F. )
  nConta := CONTA
  TRB->(dbCloseArea())
  
  If nConta > 0
     cQry:= StrTran(cQry,"ISNULL(COUNT(*),0)CONTA", "*")
  
     dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
     Dbgotop()
     cOrc := TRB->AB4_NUMORC
     TRB->(dbCloseArea())

     cQry := "UPDATE "+RetSqlName("AB3")
     cQry += " SET AB3_XSERIE = '"+SF2->F2_SERIE+"', "     
     cQry += "     AB3_XNOTA = '"+SF2->F2_DOC+"', "     
     cQry += "     AB3_STATUS = 'E' "     
     cQry += "FROM " + RetSqlName("AB3")+" AB3 "
     cQry += "WHERE AB3.D_E_L_E_T_ <> '*' AND "
     cQry += "AB3_FILIAL = '"+xFilial("AB3")+"' "     
     cQry += "AND AB3_NUMORC = '"+cOrc+"' "     
     TcSqlExec(cQry)
  Endif   
Return