#include "Protheus.ch"
#include "Rwmake.ch"

/*
   Objetivo...: 
   Ponto de Entrada para trazer o armazem do produto caso o mesma esteja em mais de um armazem.
   Observação...: 
   A variável cLocal é do tipo local e o conteúdo atribuido a ela por esse ponto de entrada só tem efeito dentro da função Lj7Prod. 
   Ao usar esse ponto de entrada, é recomendado também criar um gatilho disparado a partir do preenchimento do campo LR_PRODUTO, para que o array 
   aColsDet na posição do local de armazenagem seja atualizado também.
*/

User Function LJ7041                        
  Local aStru,aCampos,cFile,c_Cod,c_Desc,cQry,nRegis                       
  Local _nPosLocal := aScan( aHeaderDet, { |x| Trim(x[2]) == 'LR_LOCAL' })
  
  Local cArea     := Alias()
  Local _cLocal   := ParamIxb[1] // Recebe parâmetro contendo almoxarifado
  Local _aColsDet := ParamIxb[2] // Recebe parâmetro contendo o array aColsDet
  
  If Len(_aColsDet) >= n // Verifico se é um novo item, para só alterar o almoxarifado na inclusão do item     
     
     //- Saldos em estoque
     DbSelectArea( "SB2" )
     DbSeek( xFilial() + SB1->B1_COD )
	   
     aStru:= { {"WK_LOCAL", "C",  2,0}, ;
               {"WK_ARMAZEM", "C", 15,0}, ;
               {"WK_QATU"  , "N", 12,2} }
            
     aCampos:= { {"WK_LOCAL",, "Cod."}, ;
                 {"WK_ARMAZEM",, "Armazem"} , ;
                 {"WK_QATU"  ,, "Saldo"} }
	
     cFile:= CriaTrab(aStru,.t.)
     dbUseArea(.t.,,cFile,"wSaldo",.F.,.F.)
   
     c_Cod  := Alltrim(SB1->B1_COD)
     c_Desc := SB1->B1_DESC
	
     cQry := "SELECT COUNT(*)SOMA "
     cQry += "FROM "+RetSqlName("SB2")+" A "
     cQry += "WHERE A.D_E_L_E_T_ <> '*' "
     cQry += "AND B2_FILIAL = '"+xFilial("SB2")+"' "
     cQry += "AND B2_COD = '"+c_Cod+"' "
     cQry += "GROUP BY B2_COD "
  
     dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )
     nRegis := SOMA             
     dbCloseArea()

     If nRegis > 1
        cQry := StrTran(cQry,"COUNT(*)SOMA", "*")
        cQry := StrTran(cQry,"GROUP BY B2_COD", "ORDER BY B2_LOCAL") 
     
        dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "XXX", .T., .F. )

        dbSelectArea("XXX")		
        dbGotop()
     
	    While !XXX->(EOF())
	       wSaldo->(dbAppend())
		   wSaldo->WK_LOCAL   := XXX->B2_LOCAL
		   wSaldo->WK_ARMAZEM := Posicione("SX5",1,xFilial("SX5")+"Z0"+XXX->B2_LOCAL,"X5_DESCRI")
		   wSaldo->WK_QATU    := XXX->B2_QATU - XXX->B2_RESERVA
		   XXX->(Dbskip())
	    Enddo
	    XXX->(dbCloseArea())
	
	    dbSelectArea("wSaldo")

	    wSaldo->(Dbgotop())
	
	    Define Font oFnt3 Name "Ms Sans Serif" Bold
	    Define Msdialog oDlgSaldo Title "Consulta de saldos" From 96,5 to 400,400 Pixel
	
	    @10,5 to 50,180 Of oDlgSaldo Pixel
	    @15, 15 Say "Codigo:"  Size 35,8 Of oDlgSaldo Pixel Font oFnt3
	    @15, 50 Get c_Cod Picture "@!" Size 35,8 Pixel of oDlgSaldo when .F.
	    @25, 15 Say "Descricao:"  Size 35,8 Of oDlgSaldo Pixel Font oFnt3
	    @25, 50 Get c_Desc Picture "@!" Size 100,8 Pixel of oDlgSaldo when .F.
	
	    oMark:= MsSelect():New("wSaldo",,,aCampos,.F.,,{65,1,(oDlgSaldo:nHeight-30)/2,(oDlgSaldo:nClientWidth-4)/2})

	    bOk := {|| oDlgSaldo:End()}
	    bCancel := {||oDlgSaldo:End()}
	
	    Activate msdialog oDlgSaldo On Init EnchoiceBar(oDlgSaldo,bOk,bCancel) Centered
                                        
        //aColsDet[n][_nPosLocal] := _cLocal 

  	 Endif
     DbSelectArea("wSaldo")
     dbCloseArea()

     Ferase(cFile+GetDBExtension())
     DbSelectArea(cArea)
  Endif
Return _cLocal