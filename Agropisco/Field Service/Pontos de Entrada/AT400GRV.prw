#Include "rwmake.ch"

User Function AT400GRV()

// Mostra o Numero da OS
//SA1->(DbSetOrder(1))
U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima                   
SA1->(DbSeek(xFilial()+AB3->AB3_CODCLI))

//AB4->(DbSetOrder(1))
U_MsSetOrder("AB4","AB4_FILIAL+AB4_NUMORC+AB4_ITEM")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima                   
AB4->(DbSeek(xFilial()+AB3->AB3_NUMORC))

cOrc  := AB3->AB3_NUMORC
cNome := FunName()     

If Alltrim(cNome) == "TECA400" .And. !Empty(AB4->AB4_NUMOS)
    //AB6->(DbSetOrder(1))
	U_MsSetOrder("AB6","AB6_FILIAL+AB6_NUMOS")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima                       
    If AB6->(DbSeek(xFilial("AB6")+Left(AB4->AB4_NUMOS,6)))
       Reclock("AB6",.F.)
       AB6->AB6_CONPAG := AB3->AB3_CONPAG
	   AB6->AB6_NUMORC := U_AGRO006(Left(AB4->AB4_NUMOS,6))//Acrescentado por Ulisses Jr em 17/07/08
       AB6->(MsUnlock())
    Endif

    // Gravando status de orcamento com OS	
	Reclock("AB4",.F.)
	AB4->AB4_XTIPO:='2'
    AB4->(MsUnlock())

	//-- Gravando status como A ara permitir alterar a OS
	Reclock("AB3",.F.)
	AB3->AB3_STATUS:='A'
    AB3->(MsUnlock())
	
	Alert("Numero da OS:"+Left(AB4->AB4_NUMOS,6))

EndIf
     
//�������������������������������������������Ŀ
//� Grava dados de log  �
//��������������������������������������������� 
If Alltrim(cNome) == "TECA400" .And. AB4->AB4_TIPO == "3" //- Encerrado
	Reclock("AB3",.F.)
	AB3->AB3_XRESPE := UPPER(Trim(SubStr(cUsuario,7,15))) //- Responsavel pelo encerramento
	AB3->AB3_XDTENC := dDataBase                          //- Data de encerramento
	AB3->AB3_XHRENC := Substr(Time(),1,5)                 //- Hora de encerramento
    AB3->(MsUnlock())
Endif


//�������������������������������������������Ŀ
//� Grava valor do m�o-de-obra no or�amento  �
//��������������������������������������������� 
If Alltrim(cNome) == "TECA400"
   cQry := "UPDATE "+RetSqlName("AB3")+" "
   cQry += "SET AB3_XVLMOB = AB5_TOTAL "
   cQry += "FROM "+RetSqlName("AB3")+ " A "
   cQry += "INNER JOIN "
   cQry += "( "
   cQry += "SELECT AB5_FILIAL,AB5_NUMORC,SUM(AB5_TOTAL)AB5_TOTAL "
   cQry += "FROM "+RetSqlName("AB5")+" B "
   cQry += "WHERE B.D_E_L_E_T_ <>'*' "
   cQry += "AND AB5_FILIAL = '"+xFilial("AB5")+"' "        
   cQry += "AND AB5_NUMORC = '"+cOrc+"' "     
   cQry += "AND (AB5_CODPRO = '11' OR  AB5_CODPRO = '001364') "      
   cQry += "GROUP BY AB5_FILIAL,AB5_NUMORC "
   cQry += ")C "
   cQry += "ON A.AB3_FILIAL = C.AB5_FILIAL AND A.AB3_NUMORC = C.AB5_NUMORC "
   cQry += "WHERE A.D_E_L_E_T_ <>'*' "   
   cQry += "AND AB3_FILIAL = '"+xFilial("AB3")+"' "     
   cQry += "AND AB3_NUMORC = '"+cOrc+"' "     
   TCSQLExec(cQry)
Endif
Return