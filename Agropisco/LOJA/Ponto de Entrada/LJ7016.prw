#include "Protheus.ch"
#include "Rwmake.ch"

User Function LJ7016

/*
Ponto de entrada para adicionar rotinas ao Toolbar da venda assistida.

Array bidimensional contendo:

[1] - Titulo para o menu
[2] - Titulo para botao (tip)
[3] - Resource
[4] - Funcao a ser executada
[5] - Aparece na toolbar lateral ? (TRUE / FALSE)
[6] - Habilitada ? (TRUE / FALSE)
[7] - Grupo (1- Gravacao, 2- Detalhes, 3- Estoque, 4- Outros)
[8] - Tecla de atalho
*/

Local aRet  := {}

aFuncoes[11][6] := .F.

aAdd( aRet, {'Tela Pesq.', 'Tela Pesq.', 'Tela Pesq.' , {||u_LjkeyF6()}, .F., .T., 4, {8,'Ctrl+H'}  } )
aAdd( aRet, {'Saldo', 'Saldo', 'Saldo' , {||u_LjkeyCTRLI()}, .F., .T., 4, {9,'Ctrl+I'}  } )
aAdd( aRet, {'Ver Nota', 'Ver Nota', 'SOLICITA', {|| VerNotas("V")}, .T., .T., 4, {10 ,'Ctrl+J'}  } )

Return aRet  

//////////////////////////////
Static Function VerNotas(cPar)
  Local n_Ord    := SB1->(IndexOrd())
  Local cAlias   := Alias()
  Local nOrd     := dbSetOrder()
  Local nReg     := Recno()
  Local lRet     := .f.
  Local aStru    := {}
  Local aCampos  := {}
  Local c_Ref,c_Cod,cQry,oDlgNota,oFont3,bOk,bCancel,cFile                   
  
  Local nPosProd := aPosCpo[Ascan(aPosCpo,{|x| Alltrim(Upper(x[1])) == "LR_PRODUTO"})][2] // Posicao da codigo do produto
  Local nPosLocal:= Ascan(aPosCpoDet,{|x| Alltrim(Upper(x[1])) == "LR_LOCAL"})			  // Posicao do local (armazem)
                         
  cPar:= If( cPar == Nil, "G", cPar) // G-Acesso gerencial, V-Acesso vendedor
 
  If !Empty(aCols[n][nPosProd]) .AND. Len(aColsDet) >= n
     c_Cod  := aCols[n][nPosProd]
     c_Ref  := Posicione("SB1",1,xFilial("SB1")+c_Cod,"B1_XCODFAB")
     c_Desc := Posicione("SB1",1,xFilial("SB1")+c_Cod,"B1_DESC")
  Endif   
  
  //c_Ref  := IIF(Empty(SB1->B1_XCODFAB),M->B1_XCODFAB,SB1->B1_XCODFAB)
  //c_Cod  := IIF(Empty(SB1->B1_COD),M->B1_COD,SB1->B1_COD)
  //c_Desc := IIF(Empty(SB1->B1_DESC),M->B1_DESC,SB1->B1_DESC) 
  
  cQry := "SELECT TOP 3 D1_COD,D1_DOC,D1_SERIE,D1_DTDIGIT,D1_QUANT,D1_VUNIT,D1_TOTAL " 
  cQry += "FROM "+RetSqlName("SD1")+" SD1 " 
  cQry += "WHERE D_E_L_E_T_ <> '*' "
  
  If cPar == "G"
     //cQry += "AND D1_CF IN('1101','2101','1102','2102','1910','2910','1949','2949','2551','2556','1912','2912') "
     cQry += "AND D1_CF IN('1101','2101','1102','2102') "  
  Else
     cQry += "AND D1_CF IN('1101','2101','1102','2102') "  
  Endif
     
  If SM0->M0_CODFIL == "02"                         
     cQry += "AND (D1_FILIAL='02' AND D1_COD = '"+c_Cod+"' OR D1_FILIAL='01' AND D1_COD = '"+c_Ref+"') "
  Else 
     cQry += "AND D1_FILIAL = '"+xFilial("SD1")+"'
     cQry += "AND D1_COD = '"+c_Cod+"' "  
  Endif
  cQry += "ORDER BY D1_DTDIGIT DESC "
  
  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"SD1T",.T.,.T.)
  
  TcSetField("SD1T", "D1_DTDIGIT", "D", 8, 0)  // Formata para tipo Data

  dbSelectArea("SD1T")		
    
  If !SD1T->(EOF()) 
  
     If cPar == "G"
        aStru:= { {"WK_NOTA", "C", 9,0}, ;
                  {"WK_QUANT", "N", 11,2}, ;    
                  {"WK_VUNIT", "N", 11,2}, ;    
                  {"WK_DATA"  , "C", 10,0} }   
               
	    aCampos:= { {"WK_NOTA",, "Nota"}, ;
   	                {"WK_QUANT",,"Quantidade"}, ;
                    {"WK_VUNIT",,"Vl.Unit.", 11,2}, ;    
	                {"WK_DATA"  ,, "Data"} }
	 Else 
        aStru:= { {"WK_NOTA", "C", 9,0}, ;
                  {"WK_QUANT", "N", 11,2}, ;    
                  {"WK_DATA"  , "C", 10,0} }   
               
	    aCampos:= { {"WK_NOTA",, "Nota"}, ;
   	                {"WK_QUANT",,"Quantidade"}, ;
	                {"WK_DATA"  ,, "Data"} }
	 Endif
	 
	 cFile:= CriaTrab(aStru,.t.)
	 dbUseArea(.t.,,cFile,"wNota",.F.,.F.)
	
     Do while !SD1T->(EOF())
	    wNota->(dbAppend())
		wNota->WK_NOTA  := SD1T->D1_DOC
		wNota->WK_QUANT := SD1T->D1_QUANT 
        
        If cPar == "G"
           wNota->WK_VUNIT := SD1T->D1_VUNIT 
        Endif   
		
		wNota->WK_DATA  := Dtoc(SD1T->D1_DTDIGIT)
		SD1T->(Dbskip())
	 Enddo
	 
	 SD1T->(dbCloseArea())
	
	 dbSelectArea("wNota")
	 
	 wNota->(Dbgotop())
	
	 Define Font oFnt3 Name "Ms Sans Serif" Bold
	 Define msdialog oDlgNota Title "Consulta de Notas de Compras" From 96,5 to 400,400 Pixel
	
	   @10,5 to 50,180 Of oDlgNota Pixel
	
	   @15, 15 Say "Codigo:"  Size 35,8 Of oDlgNota Pixel Font oFnt3
	   @15, 50 Get c_Cod Picture "@!" Size 35,8 Pixel of oDlgNota when .F.
	
	   @25, 15 Say "Descricao:"  Size 35,8 Of oDlgNota Pixel Font oFnt3
	   @25, 50 Get c_Desc Picture "@!" Size 100,8 Pixel of oDlgNota when .F.
	
	   oMark:= MsSelect():New("wNota",,,aCampos,.F.,,{65,1,(oDlgNota:nHeight-30)/2,(oDlgNota:nClientWidth-4)/2})
	
	   bOk := {||lRet:= .t.,oDlgNota:End()}
	   bCancel := {||oDlgNota:End()}
	
	 Activate msdialog oDlgNota On Init EnchoiceBar(oDlgNota,bOk,bCancel) Centered
	
	 dbSelectArea("wNota")
	 dbCloseArea()
	 Ferase(cFile+GetDBExtension())
  Else
     SD1T->(dbCloseArea())     	 
  Endif
	
  dbSelectArea(cAlias)
  dbSetOrder(nOrd)
  dbGoTo(nReg)
Return


