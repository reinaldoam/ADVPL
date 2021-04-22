#INCLUDE "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  AGRO006   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 02/05/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Retorna o Numero do Orçamento                                  ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AGRO006(cNumOS)
//Salva a área do SX7
Local cOrc := "" 
Local cQry := ""
//
cAlias := Alias()
/*
dbSelectArea("AB7")
//dbSetOrder(1)      
U_MsSetOrder("AB7","AB7_FILIAL+AB7_NUMOS+AB7_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
*/
//Trecho incluído por Ulisses Jr em 17/07/08 em substituição ao comentado acima
cQry := " SELECT * FROM "+RetSqlName("AB7")
cQry += " WHERE D_E_L_E_T_ <> '*' "     
cQry += " AND AB7_FILIAL = '"+xFilial("AB7")+"' "
cQry += " AND AB7_NUMOS = '"+cNumOs+"' "
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "Wrk", .T., .F. )
Wrk->(dbGoTop())

If !Wrk->(Eof())//AB7->(dbSeek(xFilial("AB7")+cNumOS))
	cOrc := Left(Wrk->AB7_NUMORC,6)//Left(AB7->AB7_NUMORC,6)
Else
    cOrc := "   "
EndIf
Wrk->(dbCloseArea())
dbSelectArea(cAlias)

Return(cOrc)
