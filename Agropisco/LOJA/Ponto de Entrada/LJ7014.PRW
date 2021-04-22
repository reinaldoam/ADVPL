//
//Ponto de Entrada	LJ7014
//Chamado	Na chamada da função de análise de crédito
//Parâmetros	Array contendo:
//[1] - Código do Cliente
//[2] - Loja do Cliente
//[3] - Valor total da venda
//[4] - Array com as formas de pagamento (aPgtos)
//Retorno	Lógico contendo:
//.T. - Permite a análise de crédito e a validação
//.F. - Não faz a análise de crédito
//Observação	Utilizado para customização da análise de crédito
//
USER Function LJ7014      
  Local lRet:= .T.
  Local cCodCli:= ParamIxb[1]
  Local cLojCli:= ParamIxb[2]
  Local nValor := ParamIxb[3]                   
  
  ALERT("CREDITO")
  
RETURN lRet