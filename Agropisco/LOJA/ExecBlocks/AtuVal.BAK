
/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ Função    ¦ AtuVal      ¦ Autor ¦ Ulisses Junior      ¦ Data ¦ 09/05/2007    ¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ Descriçäo ¦ Função criada para atualizar os valores de preço calculado ou    ¦¦¦
¦¦¦           ¦ margem de lucro, dependendo do campo alterado pelo usuário.     ¦¦¦
¦¦+-----------+------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AtuVal()
Local cReadVar  := ReadVar()
Local xConteudo := &cReadVar
Local nMarkup   := 0, nValor := 0
Local nRecno    := Recno()
cArea := Alias()
cReadVar := Alltrim(StrTran(cReadVar,"M->",""))
//SZ3->(dbSetOrder(1))
U_MsSetOrder("SZ3","Z3_FILIAL+Z3_DOC+Z3_SERIE+Z3_FORNECE+Z3_LOJA+Z3_COD+Z3_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
SZ3->(dbSeek(xFilial("SZ3")+Acols[n][10]+ACols[n][11]+Acols[n][12]+Acols[n][13]+aCols[n][2]+aCols[n][1]))

If cReadVar = "Z3_VCALC"

   nMarkup := SZ3->Z3_PERCOM+SZ3->Z3_PERTRAN+SZ3->Z3_PERFIN+SZ3->Z3_PERICM+SZ3->Z3_PERIR
   nValor  := ((SZ3->Z3_CUSTO+SZ3->Z3_FRETE)/xConteudo)*100
   nValor  := 100-nValor-nMarkup

   RecLock("SZ3",.F.)
     SZ3->Z3_VCALC  := xConteudo
     SZ3->Z3_MLUCRO := nValor
   SZ3->(MsUnLock())

ElseIf cReadVar = "Z3_MLUCRO"

   nMarkup := SZ3->Z3_PERCOM+SZ3->Z3_PERTRAN+SZ3->Z3_PERFIN+SZ3->Z3_PERICM+SZ3->Z3_PERIR+xConteudo//Total %
   nMarkup := (100-nMarkup)/100 //Markup
   nValor  := (SZ3->Z3_CUSTO+SZ3->Z3_FRETE)/nMarkup

   RecLock("SZ3",.F.)
     SZ3->Z3_VCALC  := nValor
     SZ3->Z3_MLUCRO := xConteudo
   SZ3->(MsUnLock())

EndIf

SZ3->(dbGoTo(nRecno))
dbSelectArea(cArea)

Return nValor