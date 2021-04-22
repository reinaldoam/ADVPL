#include "Rwmake.Ch" 

//----------------------------------------------------------
/*/{Protheus.doc} 
Execblock AGESTE02.prw para validacao do NCM dos produtos. 
/*/
//----------------------------------------------------------

User Function AGESTE02(cNCM,cSeq)
  Local cAlias  := Alias()
  Local aArea   := GetArea()
  Local cQuery:= "", cRet:=""
 
  cQuery := " SELECT * "
  cQuery += " FROM "+RetSQLName("SZ1")+" SZ1 "
  cQuery += " WHERE SZ1.D_E_L_E_T_ <> '*' "
  cQuery += " AND Z1_FILIAL = '"+xFilial("SZ1")+"' "                 
  cQuery += " AND Z1_NCMDE <= '"+cNCM+"' "
  cQuery += " AND Z1_NCMATE >= '"+cNCM+"' "
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
                                            
  If !TMP->(EOF())              
     If cSeq == "01" // Entrada
        cRet:= TMP->Z1_TE 
     ElseIf cSeq == "02" //- Saida
        cRet:= TMP->Z1_TS  
     Else 
        cRet:= TMP->Z1_TSNFSB //- Saida simbólica
     Endif  
  Else 
     If cSeq == "01" // Entrada
        cRet:= M->B1_TE 
     ElseIf cSeq == "02" //- Saida
        cRet:= M->B1_TS
     Else 
        cRet:= M->B1_XTSNFSB //- Saida simbólica
     Endif  
  Endif   

  TMP->(dbCloseArea())

  dbSelectArea(cAlias)
  RestArea(aArea)
  
Return cRet