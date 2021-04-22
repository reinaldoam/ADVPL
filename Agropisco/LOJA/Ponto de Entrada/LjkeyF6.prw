#include "Protheus.ch"
#include "Rwmake.ch"

/*
   Objetivo.....: 
   Ponto de Entrada para Consulta Customizada de Produtos na Tela de Venda Assistida.
*/

User Function LjkeyF6
  Local cAlias := Alias()
  Local nOrd   := dbSetOrder()
  Local nReg   := Recno()
  Local lRet   := .f.
	
  Local oDlgMain,oFont3,oFont4,bOk,bCancel,cFile
	
  Local c_Pesq    := Space(60)
  Local c_Selecao := ""
	
  Local cFiltro,cChave,cIndSA21,aStru
	
  DEFINE Font oFnt3 Name "Ms Sans Serif" Bold
  DEFINE Font oFnt4 Name "Tahoma" BOLD Size 013,030
	
  DEFINE MSDIALOG oDlgMain Title "Consulta de Produtos" From 96,5 to 480,550 Pixel
	
     @010, 5 to 40,270 Of oDlgMain Pixel

     @015, 15 Say " Pesquisa:"  Size 35,8 Of oDlgMain Pixel Font oFnt3
     @015, 50 Get c_Pesq Picture "@!" Size 129,8 Pixel of oDlgMain

     bOk := {|| Grava_Item(c_Pesq),lRet:= .t.,oDlgMain:End()}
     bCancel := {||oDlgMain:End()}
	
  ACTIVATE MSDIALOG oDlgMain ON INIT EnchoiceBar(oDlgMain,bOk,bCancel) CENTERED
	
  dbSelectArea(cAlias)
  dbSetOrder(nOrd)
  dbGoTo(nReg)
Return lRet

///////////////////////////////////
Static Function Grava_Item(c_Pesq)
  Local cAlias := Alias()
  Local nOrd   := dbSetOrder()
  Local nUsado
  Local lMaisDeUm:= !Empty(aCols[1,2])
	
  Local n_ColProduto,n_ColDescri,n_ColQuant,n_ColVrunit,n_ColVlritem
  Local n_ColLocal,n_ColUm,n_ColDesc,n_ColValdesc,n_ColTes,n_ColValRefpr
  Local n_ColCF,n_ColDescpro,n_ColTabela,n_ColPctab,n_ColYSerie
  Local n_ColBaseIcm,n_ColValIPI,n_ColValIcm,n_ColValIss
	
  //- Pesquisa por descrição
  Local aDescr:= {}
  Local nPos,nTam,oDlgDescr,c_Cond:=""
	
  Local aStru,aCampos,cFile,lRet:= .t.,lPesquisa:= .f.,lCond:= .t.
	
  aStru:= { { "WK_COD"  , "C", 15, 0 },; 
            { "WK_DESCR", "C", 60, 0 },;
            { "WK_PRECO", "C", 10, 2 },;
            { "WK_SALDO", "N", 12, 2 },;
            { "WK_LOCAL", "C", 06, 0 }}
  
  aCampos:= { { "WK_COD"  ,,"Codigo"},;
              { "WK_DESCR",,"Descrição"},;
              { "WK_PRECO",,"Preco"},;
              { "WK_SALDO",,"Saldo"},;
              { "WK_LOCAL",,"Localiz" }}

  cFile:= CriaTrab(aStru,.T.)
  dbUseArea(.t.,,cFile,"wDesc",.F.,.F.)
  Index on WK_DESCR to &cFile
	
  dbSelectArea("SB1")
	
  Set Softseek on
	
  cFiltro := Alltrim(c_Pesq)
	
  lCond := .t.
  
  While lCond
     nPosAt:= At("%", cFiltro) 
     If nPosAt > 1 
   	    cPesq:= '%'+Substring(cFiltro, 1, nPosAt)
   	    cFiltro := StrTran(cFiltro,Substring(cFiltro, 1, nPosAt), "")
	 Else
	    cPesq:= "%"+Alltrim(cFiltro)+"%" 
	    lCond:= .f. 
	 Endif
   	 c_Cond+= " B1_DESC LIKE '" + ALLTRIM(cPesq) + Iif(lCond,"' AND","'") 
  Enddo
  cQry := "SELECT B1_COD,B1_DESC,B1_LOCAGRO "
  cQry += "FROM "+RetSqlName("SB1")+" SB1 "
  cQry += "WHERE SB1.D_E_L_E_T_ <> '*' "
  cQry += "  AND B1_FILIAL = '"+xFilial("SB1")+"' "
  cQry += "  AND "+ ALLTRIM(c_Cond)+ " "  
  cQry += "ORDER BY B1_DESC "
		
  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"SB1T",.T.,.T.)
  dbSelectArea("SB1T")		
  
  While !SB1T->(EOF())
			
     //- Saldo fisico e financeiro
	 SB2->(Dbseek(xFilial("SB2") + SB1T->B1_COD + "01")) //ALLTRIM(GETMV("MV_LOCPAD"))))
			
	 //- Preço de venda
	 SB0->(Dbseek(xFilial("SB0") + SB1T->B1_COD))

     wDesc->(Dbappend())                                
     wDesc->WK_COD   := SB1T->B1_COD
     wDesc->WK_DESCR := SB1T->B1_DESC
     wDesc->WK_SALDO := SB2->B2_QATU - SB2->B2_RESERVA
     wDesc->WK_PRECO := Transform(SB0->B0_PRV1,"@E 999,999.99")
     wDesc->WK_LOCAL := SB1->B1_LOCAGRO
     SB1T->(DbSkip())
  Enddo
  SB1T->(dbCloseArea())
	
  wDesc->(DbGotop())
  DEFINE MSDIALOG oDlgDescr Title "Consulta por descricao" From 96,5 to 410,820 Pixel
     oMark:= MsSelect():New("wDesc",,,aCampos,.F.,"",{35,1,(oDlgDescr:nHeight-30)/2,(oDlgDescr:nClientWidth-4)/2})
	 //oMark:bAval:= {|| Sel_Descr(@c_Descr),oDlgDescr:End()}
	 //bOk := {||Sel_Descr(@c_Descr),oDlgDescr:End()}
	 bOk:= bCancel := {||oDlgDescr:End()}
  ACTIVATE MSDIALOG oDlgDescr On Init EnchoiceBar(oDlgDescr,bOk,bCancel) Centered
	
  dbSelectArea("wDesc")
  dbCloseArea()
	
  FERASE(cFile+GetDbExtension())
  FERASE(cFile+OrdBagExt())
	
  dbSelectArea(cAlias)
  dbSetOrder(nOrd)
return
