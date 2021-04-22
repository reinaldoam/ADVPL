#INCLUDE "Protheus.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦ M261D3O    ¦ Autor ¦ Williams Messa       ¦ Data ¦ 03/05/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function M261D3O()

Local nPosAcols := ParamIXB    // Registro do aCols que esta sendo processado
//Seleciona o item na tabela SB8
//dbSelectArea("AB8")
//dbSetOrder(1)
U_MsSetOrder("AB8","AB8_FILIAL+AB8_NUMOS+AB8_ITEM+AB8_SUBITE")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   

If AB8->(dbSeek(xFilial("AB8")+aCols[nPosAcols][22]+"01"+StrZero(nPosAcols,2)))
   Alert("Acho!")
   Reclock("AB8",.F.)
      AB8_NRODOC := SD3->D3_DOC
   AB8->(MsUnlock())
EndIf
Return Nil
