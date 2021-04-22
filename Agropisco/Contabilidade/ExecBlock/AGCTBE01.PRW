/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AGCTB01  ³ Autor ³ Reinaldo Magalhaes    ³ Data ³ 11.01.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Contabilizacao dos recebimentos por forma de pagamento     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Agropisco                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

///////////////////////////////////
USER Function CtaReceb(cLanc,cOper)
  Local cAlias  := Alias()
  Local lContab := .F. //- Flag para definir se o valor sera ou nao contabilizado                                                                                  

  Local nValor:= 0.00                                 
  Local cBusca:= SF2->F2_DOC+SF2->F2_SERIE 
  
  Local nOrdSD2,nRecSD2

  ALERT("AQUI")
  
  //- Tabelas utilizadas
  DbSelectArea("SAE") 
  //DbSetOrder(1)
  U_MsSetOrder("SAE","AE_FILIAL+AE_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       	
  
  DbSelectArea("SD2") 
                      
  nOrdSD2:= SD2->(IndexOrd())
  nRecSD2:= SD2->(Recno())   
  
  //- Item nota fiscal
//  SD2->(dbSetOrder(3)) 
  U_MsSetOrder("SD2","D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       	
  SD2->(DbSeek(xFilial("SD2")+cBusca))
  
  While !SD2->(Eof()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE) == xFilial("SD2")+cBusca
     lContab := Iif(TRIM(SD2->D2_CF) $ "5102#6102#5933#6933",.T.,.F.)
     SD2->(DBSkip())
  Enddo
     
  SD2->(DbSetOrder(nOrdSD2))
  SD2->(DbGoTo(nRecSD2))
  
  If lContab  
     If AllTrim(SF2->F2_ESPECIE) == "CF"   //- Sigaloja
        nValor:= RecLoja(cLanc,cOper)
     Else
        nValor:= RecFat(cLanc,cOper)   //- Faturamento
     Endif
  Endif
  dbselectArea(cAlias)
RETURN nValor

////////////////////////////////////
Static Function RecLoja(cLanc,cOper)
  Local cBusca := SF2->(F2_SERIE+F2_DOC)
  Local nValor := 0.00
  
  //- Tabelas utilizadas
  DbSelectArea("SL1")
  DbSelectArea("SL4")   
     
  //- Cabecalho do cupom 
//  SL1->(DBSetOrder(2))
  U_MsSetOrder("SL1","L1_FILIAL+L1_SERIE+L1_DOC+L1_PDV")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       	
  SL1->(DBSeek(xFilial("SL1")+cBusca))
  
  //- Condicao negociada
  //SL4->(DbSetOrder(1))
  U_MsSetOrder("SL4","L4_FILIAL+L4_NUM+L4_ORIGEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       	
  SL4->(DbSeek(xFilial("SL4")+SL1->L1_NUM))
  
  If AllTrim(cLanc) ==  "CXA"
     nValor := LojCaixa() 
     
  ElseIf AllTrim(cLanc) ==  "DEB"
     nValor := LojDebito(cOper)  
     
  ElseIf AllTrim(cLanc) ==  "VIS"
     nValor := LojVisa(cOper)
      
  ElseIf AllTrim(cLanc) ==  "DIN"
     nValor := LojDinner(cOper)
      
  ElseIf AllTrim(cLanc) ==  "CRD"
     nValor := LojRedeCard(cOper) 
        
  ElseIf AllTrim(cLanc) ==  "BOL"
     nValor := LojBol()
            
  Endif   
Return nValor          

/////////////////////////                   
Static Function LojCaixa
  Local nValor:= 0.00  
  While !SL4->(Eof()) .and. SL4->(L4_FILIAL+L4_NUM) == xFilial("SL4")+SL1->L1_NUM
     //- Dinheiro
     If AllTrim(SL4->L4_FORMA) $ "R$"
        nValor += SL4->L4_VALOR //- SL4->L4_TROCO
     Endif
     //- Cheque
     If AllTrim(SL4->L4_FORMA) $ "CH"
        nValor += SL4->L4_VALOR
     Endif
     //- Deposito C/C
     If AllTrim(SL4->L4_FORMA) $ "DP"
        nValor += SL4->L4_VALOR 
     Endif   
     SL4->(DbSkip())
  Enddo   
Return nValor   

////////////////////////////////                   
Static Function LojDebito(cOper)
  Local nValor := 0.00
  While !SL4->(Eof()) .and. SL4->(L4_FILIAL+L4_NUM) == xFilial("SL4")+SL1->L1_NUM
     //- Cartao de credito/debito
     If AllTrim(SL4->L4_FORMA) $ "CC#CD"
        cCodCartao:= Substr(SL4->L4_ADMINIS,1,3)
        If cCodCartao $ "003#004" //- RedeShop/ Visa Eletron 
           If cOper == "D"
              SAE->(DbSeek(xFilial("SAE")+cCodCartao))
              nValor += SL4->L4_VALOR * ( SAE->AE_TAXA / 100 )
           Else   
              nValor += SL4->L4_VALOR  
           Endif   
        Endif
     Endif      
     SL4->(DbSkip())
  Enddo
Return nValor   

//////////////////////////////
Static Function LojVisa(cOper)
  Local nValor:= 0.00
  While !SL4->(Eof()) .and. SL4->(L4_FILIAL+L4_NUM) == xFilial("SL4")+SL1->L1_NUM
     
     //- Cartao de credito/debito
     If AllTrim(SL4->L4_FORMA) $ "CC#CD"
        cCodCartao:= Substr(SL4->L4_ADMINIS,1,3)
        If cCodCartao $ "005#009" //- Visa  
           If cOper == "D"
              SAE->(DbSeek(xFilial("SAE")+cCodCartao))
              nValor += SL4->L4_VALOR * ( SAE->AE_TAXA / 100 )
           Else   
              nValor += SL4->L4_VALOR  
           Endif   
        Endif      
     Endif
     SL4->(DbSkip())
  Enddo   
Return nValor  

/////////////////////////////////
Static Function LojDinner(cOper) 
  Local nValor:= 0.00
  While !SL4->(Eof()) .and. SL4->(L4_FILIAL+L4_NUM) == xFilial("SL4")+SL1->L1_NUM
     //- Cartao de credito/debito
     If AllTrim(SL4->L4_FORMA) $ "CC#CD"
        cCodCartao:= Substr(SL4->L4_ADMINIS,1,3)
        If cCodCartao $ "006#007" //- Diners 
           If cOper == "D"
              SAE->(DbSeek(xFilial("SAE")+cCodCartao))
              nValor += SL4->L4_VALOR * ( SAE->AE_TAXA / 100 )
           Else   
              nValor += SL4->L4_VALOR  
           Endif   
        Endif      
     Endif
     SL4->(DbSkip())
  Enddo   
Return nValor  

///////////////////////////////////
Static Function LojRedeCard(cOper) 
  Local nValor:= 0.00
  While !SL4->(Eof()) .and. SL4->(L4_FILIAL+L4_NUM) == xFilial("SL4")+SL1->L1_NUM
     //- Cartao de credito/debito
     If AllTrim(SL4->L4_FORMA) $ "CC#CD"
        cCodCartao:= Substr(SL4->L4_ADMINIS,1,3)
        If cCodCartao $ "001#002"  //- Credicard 
           If cOper == "D"
              SAE->(DbSeek(xFilial("SAE")+cCodCartao))
              nValor += SL4->L4_VALOR * ( SAE->AE_TAXA / 100 )
           Else   
              nValor += SL4->L4_VALOR  
           Endif   
        Endif      
     Endif
     SL4->(DbSkip())
  Enddo   
Return nValor  

//////////////////////
Static Function LojBol
  Local nValor:= 0.00
  While !SL4->(Eof()) .and. SL4->(L4_FILIAL+L4_NUM) == xFilial("SL4")+SL1->L1_NUM
     //- Boleto
     If AllTrim(SL4->L4_FORMA) $ "BO#FI"
        nValor += SL4->L4_VALOR  //- Boleto
     Endif   
     SL4->(DbSkip())
  Enddo   
Return nValor  

///////////////////////////////////
Static Function RecFat(cLanc,cOper)
  Local cCodCartao,cBusca,cBusca,cRecISS
  Local nValor:= 0.00
  
  cRecISS:= Posicione("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_RECISS")
  
  cBusca:= SF2->(F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC)
     
  //- Tabelas utilizadas
  DbSelectArea("SE1")

  //SE1->(DbSetOrder(2))
  U_MsSetOrder("SE1","E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                                       	  
  SE1->(DbSeek(xFilial("SE1")+cBusca))
 
  If AllTrim(cLanc) ==  "CXA"
     nValor := FatCaixa(cBusca,cRecISS)
  
  ElseIf AllTrim(cLanc) ==  "DEB"
     nValor := FatDebito(cBusca,cRecISS,cOper)  
  
  ElseIf AllTrim(cLanc) ==  "VIS"
     nValor := FatVisa(cBusca,cRecISS,cOper) 
  
  ElseIf AllTrim(cLanc) ==  "DIN"
     nValor := FatDinner(cBusca,cRecISS,cOper) 
  
  ElseIf AllTrim(cLanc) ==  "CRD"
     nValor := FatRedeCard(cBusca,cRecISS,cOper)    
  
  ElseIf AllTrim(cLanc) ==  "BOL"
     nValor := FatBol(cBusca,cRecISS)       
  Endif                      
Return nValor          

///////////////////////////////////////
Static Function FatCaixa(cBusca,cRecISS)
  Local n_Valor := 0.00
  Local nValor  := 0.00

  While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+cBusca
                                           
     n_Valor:= SE1->E1_VALOR - If(cRecISS="1",SE1->E1_ISS, 0)
     
     //- Dinheiro
     If TRIM(SE1->E1_NATUREZA) $ GetMv("MV_NATDINH")
        nValor += n_Valor //- Dinheiro
     Endif   
     //- Cheque
     If TRIM(SE1->E1_NATUREZA) $ GetMv("MV_NATCHEQ")
        nValor += n_Valor  //- Cheque
     Endif   
     //- Deposito C/C
     If TRIM(SE1->E1_NATUREZA) $ GetMv("MV_NATDEPO")
        nValor += n_Valor  //- Deposito C/C
     Endif
     SE1->(DbSkip())
  Enddo
Return nValor  
    
///////////////////////////////////////////////
Static Function FatDebito(cBusca,cRecISS,cOper)
  Local n_Valor := 0.00
  Local nValor  := 0.00

  While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+cBusca
                                           
     n_Valor:= SE1->E1_VALOR - If(cRecISS="1",SE1->E1_ISS, 0)
     
     //- Cartao de credito/debito  
     cNat:= Substr(SE1->E1_NATUREZ,1,4)
     
     If cNat $ "CRED#REDE#VISA#DINE"
        cCodCartao := TRIM(SE1->E1_NATUREZ)    
        n_Valor    := SE1->E1_VLRREAL - If(cRecISS="1",SE1->E1_ISS, 0) 
        If cCodCartao $ "REDESHOP#VISAELECTR" //- RedeShop/ Visa Eletron   
           If cOper == "D"
              nValor += ( SE1->E1_VLRREAL - SE1->E1_VALOR ) 
           Else   
              nValor += n_Valor
           Endif   
        Endif      
     Endif
     SE1->(DbSkip())
  Enddo
Return nValor  

//////////////////////////////////////////////
Static Function FatVisa(cBusca,cRecISS,cOper)
  Local n_Valor := 0.00
  Local nValor  := 0.00

  While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+cBusca
                                           
     n_Valor:= SE1->E1_VALOR - If(cRecISS="1",SE1->E1_ISS, 0)
     
     //- Cartao de credito/debito  
     cNat:= Substr(SE1->E1_NATUREZ,1,4)
     
     If cNat $ "CRED#REDE#VISA#DINE"
        cCodCartao:= TRIM(SE1->E1_NATUREZ)
        n_Valor   := SE1->E1_VLRREAL - If(cRecISS="1",SE1->E1_ISS, 0) 
        If cCodCartao $ "VISAAPRZ#VISAAVISTA" //- Visa
           If cOper == "D"
              nValor += ( SE1->E1_VLRREAL - SE1->E1_VALOR ) 
           Else   
              nValor += n_Valor
           Endif 
        Endif        
     Endif
     SE1->(DbSkip())
  Enddo
Return nValor  

///////////////////////////////////////////////
Static Function FatDinner(cBusca,cRecISS,cOper)  
  Local n_Valor := 0.00
  Local nValor  := 0.00

  While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+cBusca
                                           
     n_Valor:= SE1->E1_VALOR - If(cRecISS="1",SE1->E1_ISS, 0)
     
     //- Cartao de credito/debito  
     cNat:= Substr(SE1->E1_NATUREZ,1,4)
     
     If cNat $ "CRED#REDE#VISA#DINE"
        cCodCartao:= TRIM(SE1->E1_NATUREZ)     
        n_Valor   := SE1->E1_VLRREAL - If(cRecISS="1",SE1->E1_ISS, 0)
        If cCodCartao $ "DINERAVIST#DINERAPRZ" //- Diners    
           If cOper == "D"
              nValor += ( SE1->E1_VLRREAL - SE1->E1_VALOR ) 
           Else   
              nValor += n_Valor
           Endif         
        Endif      
     Endif
     SE1->(DbSkip())
  Enddo
Return nValor  

//////////////////////////////////////////////////
Static Function FatRedeCard(cBusca,cRecISS,cOper) 
  Local n_Valor := 0.00
  Local nValor  := 0.00

  While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+cBusca
                                           
     n_Valor:= SE1->E1_VALOR - If(cRecISS="1",SE1->E1_ISS, 0)
     
     //- Cartao de credito/debito  
     cNat:= Substr(SE1->E1_NATUREZ,1,4)
     
     If cNat $ "CRED#REDE#VISA#DINE"
        cCodCartao:= TRIM(SE1->E1_NATUREZ)   
        n_Valor   := SE1->E1_VLRREAL - If(cRecISS="1",SE1->E1_ISS, 0)
        If cCodCartao $ "CREDICAVIS#CREDICAPRZ"  //- Credicard     
           If cOper == "D"
              nValor += ( SE1->E1_VLRREAL - SE1->E1_VALOR ) 
           Else   
              nValor += n_Valor
           Endif
        Endif      
     Endif
     SE1->(DbSkip())
  Enddo
Return nValor  
                       
//////////////////////////////////////
Static Function FatBol(cBusca,cRecISS) 
  Local n_Valor := 0.00
  Local nValor  := 0.00
  
  While !SE1->(Eof()) .and. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == xFilial("SE1")+cBusca
     n_Valor:= SE1->E1_VALOR - If(cRecISS="1",SE1->E1_ISS, 0)
     //- Boleto
     If TRIM(SE1->E1_NATUREZA) $ "31101001#31101002"
        nValor += n_Valor  //- Boleto
     Endif   
     SE1->(DbSkip())
  Enddo
Return nValor