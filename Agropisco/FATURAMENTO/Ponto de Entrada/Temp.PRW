//ExecBlock: 	A415TDOK
//*Ponto:	Na Função de Validação da GetDadosDB a qual retornará lRetorno.
//Observações:	Permite validação da rotina de Orçamento de Venda.
//Retorno Esperado:       .T. ou .F.
USER Function A415TDOK
  Local lRet:= .T.

  Local nPosProduto:= aScan(aHeader, {|x| Trim(x[2]) == "CK_PRODUTO"})
  Local nPosPrUnit := aScan(aHeader, {|x| Trim(x[2]) == "CK_PRUNIT"})
  Local nPosQuant  := aScan(aHeader, {|x| Trim(x[2]) == "CK_QTDVEN"})
 
  Local nPrcTabela:= a415Tabela(aCols[n,nPosProduto],M->CJ_TABELA,aCols[n,nPosQuant])
          
RETURN lRet