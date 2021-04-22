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
  Local aArea     := GetArea()
  Local lSigaTec  := .F.  
  Local cBusca    := SF2->F2_DOC+SF2->F2_SERIE
  Local cBuscaSE1 := SF2->F2_FILIAL+SF2->F2_SERIE+SF2->F2_DOC                                                   
  Local lTemBoleto:= .F.
  
  Local cForma:= GetMV("MV_OUTFORM") //- Relacao de condicoes de pagamentos que ao sao vendas
  Local cNat,nRecSE1
                                      
  If !(SF2->F2_COND $ cForma) 

     SD2->(dbSetOrder(3)) //- Item nota fiscal               
     SD2->(DbSeek(xFilial("SD2")+cBusca))

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
  
  U_GrvCtRec() //Função incluida por Ulisses Jr em 11/10/07 para refazer
  			   //o contas a receber de acordo com as formas de pagamento

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Atualizando banco/agencia/conta corrente no financeiro   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
  cBcoPad := GetMv("MV_BCOBOL") 

  cBuscaSE1:= SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC)+" "+"NF " 

  //- Parametros bancos
  SEE->(DbSetOrder(1))
  SEE->(dbSeek(xFilial("SEE")+cBcoPad))
      
  //- Contas a Receber
  SE1->(DbSetOrder(2))
  If !SE1->(dbSeek(xFilial("SE1")+cBuscaSE1))               
     cBuscaSE1:= SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC)+"A"+"NF "   
     SE1->(dbSeek(xFilial("SE1")+cBuscaSE1))   
  Endif   
  
  If !SE1->(Found())
     ALERT("NAO ACHOU "+cBuscaSE1 + "Key: " + SE1->(INDEXKEY()))     
  Endif
   
  nRecSE1:= SE1->(Recno())      
     
  While !SE1->(Eof()) .And. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC) 
     If Trim(SE1->E1_NATUREZ) $ "31101001#31101002"
        RecLock("SE1",.F.)
        SE1->E1_PORTADO := If(!Empty(SEE->EE_CODIGO)  , SEE->EE_CODIGO  , SE1->E1_PORTADO)
        SE1->E1_AGEDEP  := If(!Empty(SEE->EE_AGENCIA) , SEE->EE_AGENCIA , SE1->E1_AGEDEP)
        SE1->E1_CONTA   := If(!Empty(SEE->EE_CONTA)   , SEE->EE_CONTA   , SE1->E1_CONTA)
        SE1->E1_SITUACA := "1"
        SE1->(MsUnLock())  
        lTemBoleto:= .T.
     Endif   
     SE1->(dbSkip())
  Enddo
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Impressao do boleto bancario ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
  If lTemBoleto
     SE1->(Dbgoto(nRecSE1))
     U_BLTCD001(.t.)
  Endif   
  RestArea(aArea)
RETURN