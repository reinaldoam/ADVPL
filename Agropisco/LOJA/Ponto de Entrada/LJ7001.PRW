//
// Ponto de Entrada	LJ7001
// Chamado antes das gravações
// Parâmetros	Array de uma posição contendo: nTipo (1-orcamento,  2-venda,  3-pedido).
// Retorno	Lógico. Continua o processo de finalização da venda ou retorna para a tela de venda.
// Observação	Ponto de entrada para validações no final da venda.
//
USER Function LJ7001
  Local lRet     := .T.
  Local lTemServ := .F.
  Local n_Total  := 0
  Local nRisco,nDias,n_Financ,n_Avista,n_Compra,cCodCli,cLojCli
  
  n_Financ := 0.00
  n_Compra := 0.00                       
  n_Avista := 0.00
  
  U_MsSetOrder("AB6","AB6_FILIAL+AB6_NUMOS")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
  
  If ParamIxb[1] = 1 // 1-orcamento,  2-venda,  3-pedido
     
     cCodCli := SA1->A1_COD
     cLojCli := SA1->A1_LOJA 

     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Permitir apenas R$,CC,CD,CH para consumidor final  ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
     If cCodCli+cLojCli == GetMV("MV_AGRXCLI") //- Cliente consumidor final
        lRet:= VerPagto()
        If !lRet
           Alert("Apenas sao permitidas vendas em R$,CC,CD,CH para consumidor final !!!") 
        Endif 
     Endif    
     
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Verificando valor da compra em andamento ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
     n_Compra:= If(lRet, ValorCompra(), 0)  
     
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Verificando valor pago a vista R$,CC,CD  ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
     n_Avista:= If(lRet, PagtoAvista(), 0)
     
     If n_Compra > n_Avista
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Avaliando grau de risco do cliente      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
        If SA1->A1_RISCO == "E"   
           Alert("Cliente bloqueado por risco. Somente pagamento em dinheiro !!!") 
           lRet:= .F. 
        ElseIf SA1->A1_RISCO $ "BCD"  
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³Verificando grau de risco do cliente ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
           If SA1->A1_RISCO == "B"
              nRisco:= GetMV("MV_RISCOB")
           ElseIf SA1->A1_RISCO == "C" 
              nRisco:= GetMV("MV_RISCOC")
           Else                           
              nRisco:= GetMV("MV_RISCOD")
           Endif                            
  	       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³Avalia o grau de risco do cliente de acordo com o parâmetro MV_RISCO ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
           lRisco := U_VerRisco(nRisco, cCodCli, cLojCli)
           If lRisco 
              Alert("Cliente bloqueado por risco !!!")   
              lRet:= .F.
           Endif
 		   If lRet
		      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		      //³Verifica a existencia de titulos em aberto ³
		      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		      n_Financ := U_ValFinanc(cCodCli, cLojCli) 
              If (n_Financ + n_Compra) > SA1->A1_LC     
                 ALERT("Limite de credito disponivel inferior ao valor da compra !!!")
                 lRet:= .F.   
              Endif
           Endif                                    
        Endif
     Endif 
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³Verifica a existencia de preço menor que lista ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
     If lRet
        lRet:= MenorTab()
        If !lRet
           ALERT("Desconto maior que o permitido !!!")
        Endif
     Endif   
  ElseIf ParamIxb[1] = 2 // Gravar como venda
     If TemServico() 
        lTemServ:= .T.
     Endif   
     If lTemServ .And. Empty(M->LQ_XNUMOS)     
        Alert("Favor informar o número da OS")
        lRet:= .F.   
     Endif       
     If lTemServ
        AB6->(DbSeek(xFilial("AB6")+M->LQ_XNUMOS))
        If AB6->AB6_STATUS <> "E"
           Alert("OS não encerrada!!!")
           lRet:= .F.   
        Endif
     Endif
  Endif           
RETURN lRet      

////////////////////////////
STATIC Function ValorCompra
  Local n_Valor     := 0
  Local nDel        := Len(aCols[1])
  Local nPosVlrItem := aScan(aHeader, {|x| Trim(x[2]) == "LR_VLRITEM"})   
  For i:= 1 to Len(aCols)     
     If !aCols[i][nDel]
        n_Valor+= aCols[i,nPosVlrItem]
     Endif   
  Next              
RETURN n_Valor 

/////////////////////////////////////////////////
USER Function VerRisco(nRisco,cCodCli,cLojCli) 
  Local nDias,lRisco:= .F.
  
  //- Contas a receber
  //DbSelectArea("SE1")
  //DbSetOrder(2)
  U_MsSetOrder("SE1","E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
  SE1->(DbSeek(xFilial()+cCodCli+cLojCli))
        
  While !SE1->(Eof()) .And. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA) == SE1->(xFilial("SE1"))+cCodCli+cLojCli
     //- Verificando se o titulo está pago ou ainda não vencido
     If SE1->E1_SALDO = 0 .Or. SE1->E1_VENCREA > dDataBase .Or. TRIM(SE1->E1_TIPO) $ "RA#NCC"
        SE1->(DbSkip())
        Loop                             
     Endif
     nDias:= dDataBase - SE1->E1_VENCREA  //- No de dias que o titulo está vencido 
     If nDias > nRisco
        lRisco:= .T.
        Exit
     Endif   
     SE1->(DbSkip())
  Enddo  
RETURN lRisco

/////////////////////////////////////////
USER Function ValFinanc(cCodCli, cLojCli)
  Local nTotal:= 0
  //- Contas a receber
  //DbSelectArea("SE1")
  //DbSetOrder(2)
  U_MsSetOrder("SE1","E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima  
  SE1->(DbSeek(xFilial()+cCodCli+cLojCli))
  While !SE1->(Eof()) .And. SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA) == xFilial()+cCodCli+cLojCli
     //- Verificando se o titulo está pago 
     If SE1->E1_SALDO = 0 .Or. TRIM(SE1->E1_TIPO) $ "RA#NCC"
        SE1->(DbSkip())
        Loop                             
     Endif
     nTotal += SE1->E1_SALDO
     SE1->(DbSkip())
  Enddo  
RETURN nTotal

////////////////////////////
STATIC Function PagtoAvista
  Local nTotal:= 0 
  Local nDel  := Len(aCols[1])
  For i:= 1 to Len(aPgtos)
     If Trim(aPgtos[i,3]) $ "R$#CC#CD#CH" 
           nTotal += aPgtos[i,2]
     Endif
  Next
RETURN nTotal

/////////////////////////
STATIC Function VerPagto
  Local nDel:= Len(aPgtos[1])
  Local lRet:= .T. 
  For i:= 1 to Len(aPgtos)   
     If !(Trim(aPgtos[i,3]) $ "R$#CC#CD#CH")  
        lRet:= .F.
     Endif                    
  Next
RETURN lRet

/////////////////////////
STATIC Function MenorTab
  Local cCodigo,nPrcVen,nPrcTab,nDescV
  Local lRet       := .T.
  Local nDel       := Len(aCols[1])
  Local nPosCodigo := aScan(aHeader, {|x| Trim(x[2]) == "LR_PRODUTO"})     
  Local nPosVrUnit := aScan(aHeader, {|x| Trim(x[2]) == "LR_VRUNIT"})   

  Local cNivel1    := ALLTRIM(GetMv("MV_DESCUS1")) // Desconto gerente
  Local cNivel2    := ALLTRIM(GetMv("MV_DESCUS2")) // Desconto diretoria    
  
  Local nDescMax   := GetMv("MV_DESCORC")                                           
  
  For i:= 1 to Len(aCols)     
     If !aCols[i][nDel]
	    cCodigo := aCols[i,nPosCodigo]
	    nPrcVen := aCols[i,nPosVrUnit]
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³Cálculo do desconto concedido baseado na tabela de preços ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    nPrcTab := Posicione("SB0",1,xFilial("SB0")+cCodigo,"B0_PRV1")

        If nPrcVen  < nPrcTab
           nDescV:= Round((1-(nPrcVen / nPrcTab))*100,2) 
           If nDescV > nDescMax .And. !(UPPER(Trim(SubStr(cUsuario,7,15))) $ cNivel1) //- Verifica se o usuário pode dar desconto
              lret:= .F.                                                                 
              Exit
           Endif 
        Endif
     Endif   
  Next              
RETURN lRet 

///////////////////////////
Static Function TemServico
  Local lRet       := .F.
  Local nDel       := Len(aCols[1])
  Local nPosCodigo := aScan(aHeader, {|x| Trim(x[2]) == "LR_PRODUTO"})     
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³Verificando serviços se existe serviçosem numero de OS ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  For i:= 1 to Len(aCols)     
     If !aCols[i][nDel]
	    If Alltrim(aCols[i,nPosCodigo]) == "11"
	       lRet:= .T.
	       Exit
	    Endif   
	 Endif
  Next	    
RETURN lRet