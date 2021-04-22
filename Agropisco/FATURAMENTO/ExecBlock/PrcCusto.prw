#Include "rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PrcCusto   ¦ Autor ¦ Reinaldo Magalhaes   ¦ Data ¦ 19/10/07   ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Informa o preco de custo para TES de consumo                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
 ¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function PrcCusto            
   Local cAlias    := Alias()
   Local nPLocal   := Ascan(aHeader,{|x| Trim(x[2]) == "C6_LOCAL" })
   Local nPProduto := Ascan(aHeader,{|x| Trim(x[2]) == "C6_PRODUTO" })
   Local nPTES     := Ascan(aHeader,{|x| Trim(x[2]) == "C6_TES" })
   Local nPPrcVen  := Ascan(aHeader,{|x| Trim(x[2]) == "C6_PRCVEN" })
   Local nDel      := Len(aCols[1])
   Local nPreco    := aCols[n,nPPrcVen]
   If !aCols[n,nDel] .And. aCols[n,nPTES] $ "534"             
      //- Saldos em estoque 
      DbSelectArea("SB2")
      dbSetOrder(1)
      If DbSeek(xFilial("SB2")+aCols[n,nPProduto]+aCols[n,nPLocal])
         nPreco:= SB2->B2_CM1
      Endif
   Endif
   DbSelectArea(cAlias)
Return nPreco