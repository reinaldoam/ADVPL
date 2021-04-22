#include "rwmake.ch"

//
// Ponto de entrada para validar a gravacao do orcamento do field service
// Utilizado para verificar o limite de credito do cliente e seu grau de risco.
//

USER FUNCTION AT400TOK
  Local lret    := .T.

  U_MsSetOrder("AB4","AB4_FILIAL+AB4_NUMORC+AB4_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
  
  AB4->(DbSeek(xFilial()+AB3->AB3_NUMORC))
  
  If altera .And. AB4->AB4_TIPO =="3" // Encerrado
     lret:= .F.
  Endif   
  
  If !lret
     Alert("Nao é permitida a alteracao de orcamentos encerrados!!!")   
  Else
     lret:= ValidaOrc() 
  Endif
RETURN lret

//////////////////////////
STATIC FUNCTION ValidaOrc 
  Local lRet      := .T.     
  Local n_Total   := 0
  Local cCondPg   := GetMv("MV_CONDPAD")
  Local nMinFatOS := GetMv("MV_XMINFAT")
  Local cOrcamento:= AB3->AB3_NUMORC
  Local nRisco, nDias, n_Financ, n_Compra, cCodCli, cLojCli
  
  cCodCli := AB3->AB3_CODCLI
  cLojCli := AB3->AB3_LOJA 

  n_Financ := 0.00
  n_Compra := 0.00                       

  //- Condicao de pagamento
  //SE4->(dbSetOrder(1))
  U_MsSetOrder("SE4","E4_FILIAL+E4_CODIGO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                       
  SE4->(dbSeek(xFilial("SE4")+TRIM(M->AB3_CONPAG)))

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Permitir apenas R$,CC,CD,CH para consumidor final  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
  If cCodCli+cLojCli == GetMV("MV_AGRXCLI") //- Cliente consumidor final 
     If !(TRIM(SE4->E4_FORMA) $ "R$#CC#CD#CH")
        Alert("Apenas sao permitidas vendas a vista (R$,CC,CD,CH) para cliente padrao !!!")
        lRet:= .F. 
     Endif 
  Endif    

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Avaliando grau de risco do cliente      ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
  If !(TRIM(SE4->E4_FORMA) $ "R$#CC#CD#CH")   
     If SA1->A1_RISCO == "E"   
        Alert("Cliente bloqueado por risco. A forma de pagamento sera alterada para Dinheiro !!!") 
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
           Alert("Cliente bloqueado por risco. A forma de pagamento sera alterada para Dinheiro !!!")   
           lRet:= .F.
        Endif
 	    If lRet                   
           //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
           //³ Verificando valor da compra em andamento ³
           //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
           n_Compra:= ValorCompra(cOrcamento)
 	    
	       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	       //³Verifica a existencia de titulos em aberto ³
	       //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	       n_Financ := U_ValFinanc(cCodCli, cLojCli) 
           
           If (n_Financ + n_Compra) > SA1->A1_LC     
              ALERT("Limite de credito disponivel inferior ao valor da compra. A forma de pagamento sera alterada para Dinheiro !!!")
              lRet:= .F.   
           Endif   
           
	       //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	       //³Verifica valor minimo para faturamento de OS ³
	       //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
           If n_Compra < nMinFatOS           
              ALERT("Valor abaixo do minimo para faturamento. A forma de pagamento sera alterada para Dinheiro !!!")
              lRet:= .F.   
           Endif   
        Endif
     Endif
  Endif
  If !lRet
     //Reclock("AB3",.F.)
     //Replace AB3->AB3_CONPAG with " "
     //MsUnlock()                          
     M->AB3_CONPAG:= cCondPg
  Endif  
  
  lRet:= ValidEncerra() //- Verifica se pode encerrerar orçamento
   
RETURN lRet      

////////////////////////////////////////
STATIC Function ValorCompra(cOrcamento)
  Local n_Valor := 0
  //- Item do orcamento
//AB5->(dbSetOrder(1))
  U_MsSetOrder("AB5","AB5_FILIAL+AB5_NUMORC+AB5_ITEM+AB5_SUBITE")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                       
  AB5->(DbSeek(xFilial("AB5")+cOrcamento))
  While !AB5->(EOF()) .and. AB5->AB5_NUMORC = cOrcamento
     n_Valor += AB5->AB5_TOTAL
     AB5->(DbSkip())
  Enddo       
RETURN n_Valor        

////////////////////////////
STATIC Function ValidEncerra 
  Local lRet      := .T.
  Local nDel      := Len(aCols[1])
  Local nPosSitua := aScan(aHeader, {|x| Trim(x[2]) == "AB4_TIPO"})
  For i:= 1 to Len(aCols)     
     If !aCols[i][nDel] .And. aCols[i,nPosSitua] == "3" .And. Empty(M->AB3_XMOTEN)  
        Alert("Para encerrar orçamentos é necessário informar o motivo !!!")
        lRet:= .F.   
        Exit
     Endif              
  Next
Return lRet