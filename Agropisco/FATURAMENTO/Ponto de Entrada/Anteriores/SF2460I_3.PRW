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
  Local lTemBoleto:= .F.
  Local cFilSE1   := xFilial("SE1")
  
  Local cForma:= GetMV("MV_OUTFORM") //- Relacao de condicoes de pagamentos que ao sao vendas
  Local cNat,cBusca
                                      
  If !(SF2->F2_COND $ cForma) 

     //SD2->(dbSetOrder(3)) //- Item nota fiscal               
	 U_MsSetOrder("SD2","D2_FILIAL+D2_DOC+D2_SERIE")//Incluído por Ulisses Jr em 24/04/08 em substituição as linhas acima
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
  
  cBusca:= SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DUPL)
  
  U_GrvCtRec() //Função incluida por Ulisses Jr em 11/10/07 para refazer
  			   //o contas a receber de acordo com as formas de pagamento

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Atualizando banco/agencia/conta corrente no financeiro   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
  cBcoPad := GetMv("MV_BCOBOL") 

  //- Parametros bancos
  //SEE->(DbSetOrder(1))
  U_MsSetOrder("SEE","EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA")//Incluído por Ulisses Jr em 24/04/08 em substituição as linhas acima
  SEE->(dbSeek(xFilial("SEE")+cBcoPad))

  //- Contas a receber
  //dbSelectArea("SE1")
  //dbSetOrder(2) //- E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
  U_MsSetOrder("SE1","E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição as linhas acima
  SE1->(dbSeek(cFilSE1+cBusca,.T.))
   
  While !Eof() .And. cFilSE1+cBusca == SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM   
     If TRIM(SE1->E1_NATUREZ) $ '31101001,31101002'
        Reclock("SE1",.f.)
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
  //³ Impressao do boleto bancario ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
  If lTemBoleto
     //dbSelectArea("SE1")
     //dbSetOrder(2) //- E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
     U_MsSetOrder("SE1","E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição as linhas acima
     SE1->(dbSeek(cFilSE1+cBusca,.T.))
     U_BLTCD001(.t.)
  Endif   
  RestArea(aArea)
RETURN