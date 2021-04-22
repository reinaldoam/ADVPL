#include "rwmake.ch"

//
// ExecBlock para validar o desconto maximo permitido (Parametro MV_DESCORC)
// Gatilho: AB5_PRCLIS Seq:001
//

USER Function AGPE002(nPrcVen,cProduto,cTabela,nQuant,cCodCli,cLojCli)
  
  Local nPrcTabela, nDescV:= 0,nRet:= 0
  Local nDescMax:= GetMv("MV_DESCORC")                                           
  
  cTabela:= If(Empty(cTabela),"001",cTabela)
  
  nPrcTabela:= AT400Tab(cProduto,cTabela,nQuant,cCodCli,cLojCli,1)           
 
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verifica se o desconto está acima do permitido  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  nRet:= nPrcVen  
  If nPrcVen < nPrcTabela
     nDescV:= Round((1-(nPrcVen / nPrcTabela))*100,2) 
     If nDescV > nDescMax
        nRet:= nPrcTabela     
        Alert("Desconto concedido % " + Transform(nDescV,"@E 999,999.99")+";Desconto permitido % " + Transform(nDescMax,"@E 999,999.99"))
     Endif 
  Endif      
RETURN nRet