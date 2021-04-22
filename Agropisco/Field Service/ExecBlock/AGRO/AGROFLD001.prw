#INCLUDE "rwmake.ch"
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  AGROFLD001¦ Autor ¦ Williams Messa       ¦ Data ¦ 19/04/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ MONTA O NRO DE SERIE AUTOMÁTICO PARA O CLIENTE                 ¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
//MONTA O CÓDGIO DO PRODUTO
User Function AGROFLD001(cTEMNRS,cRotina)
Local cNStemp   := ""
Local cNroSerie := Space(14)
//Salva a área do SX7
cAlias := Alias()
   
cQry := "SELECT MAX(AA3_NUMSER) AS AA3_NUMSER FROM AA3010 "
cQry += "WHERE AA3_NUMSER LIKE 'AGR%' AND D_E_L_E_T_ ='' "
cQry += "ORDER BY AA3_NUMSER "


dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRE", .T., .F. )
dbSelectArea("TRE")
TRE->(dbGoTop())
While !TRE->(EOF())
	cNStemp := TRE->AA3_NUMSER
	TRE(dbSkip())
EndDo
//
If cTEMNRS == "N" .AND. cRotina == "I"
	cNroSerie := "AGRO" + StrZero(Val(Substr(cNStemp,5,11))+1,11)
else
	cNroSerie := ""
EndIf

DbCloseArea("TRE")

dbSelectArea(cAlias)

Return(AllTrim(cNroSerie))
