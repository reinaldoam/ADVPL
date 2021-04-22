
//- P.E Para autorizar a baixa do orçamento.

USER Function MT415AUT
  Local lret:= .T.  
  Local cQry, cNumOrc                            
  Local nDescV:= 0
  Local nDescMax:= GetMv("MV_DESCORC")                                           
 
  cNumOrc:= SCJ->CJ_NUM

  cQry := "SELECT CK_PRODUTO,DA1_CODPRO,CK_PRCVEN,DA1_PRCVEN,CJ_VALIDA,CK_CLIENTE,CK_LOJA "
  cQry += "FROM "+RetSQLName("SCJ")+" A, "+RetSQLName("SCK")+" B, "+RetSQLName("DA1")+" C "
  cQry += "WHERE A.D_E_L_E_T_ <> '*' AND B.D_E_L_E_T_ <> '*' AND C.D_E_L_E_T_ <> '*' "
  cQry += "AND CJ_FILIAL = '"+XFILIAL("SCJ")+"' "
  cQry += "AND CJ_NUM = '"+cNumOrc+"' "
  cQry += "AND CJ_FILIAL = CK_FILIAL AND CJ_NUM = CK_NUM "      
  cQry += "AND CK_PRODUTO = DA1_CODPRO" 

  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
  dbSelectArea("TRAB")
                          
  TRAB->(dbGotop())
  
  While !TRAB->(Eof()) 
     If TRAB->CJ_VALIDA < Dtos(Date()) //.Or. TRAB->CK_PRCVEN < TRAB->DA1_PRCVEN
        lret:= .F.                                                            
        Exit
     Endif                 
 	 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	 //³Cálculo do desconto concedido baseado na tabela de preços ³
	 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     If TRAB->CK_PRCVEN  < TRAB->DA1_PRCVEN
        nDescV:= Round((1-(TRAB->CK_PRCVEN / TRAB->DA1_PRCVEN))*100,2) 
        If nDescV > nDescMax
           lret:= .F.                                                                 
           Exit
        Endif 
     Endif
     TRAB->(DbSkip())  
  Enddo             
  If !lret
     Alert("Orçamento com validade vencida ou desconto acima do permitido!!!")        
  Endif
  TRAB->(dbCloseArea())
 
RETURN lret                                                 
