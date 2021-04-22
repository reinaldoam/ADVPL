#include "protheus.ch"
#include "rwmake.ch"
#include "font.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FORLOJ01 ³ Autor ³ Reinaldo Magalhães    ³ Data ³ 21/02/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Quantidade de documentos fiscais emitidos                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Formula                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FORLOJ01
  Local nOpc    := 0 
  Local cAlias  := Alias()
  Local aSay    := {}
  Local aButton := {}
  Local cTitulo := "Verifica numero de documentos emitidos"
  Local cDesc1  := "Essa rotina ira verificar quantos documentos foram emitidos "
  Local cDesc2  := "em um determinado periodo.                                  "

  Local cPerg:= PADR("FORLOJ01",Len(SX1->X1_GRUPO))

  ValidPerg(cPerg)
   
  If !Pergunte(cPerg,.T.)
     Return
  Endif

  aAdd( aSay, cDesc1 )
  aAdd( aSay, cDesc2 )

  aAdd( aButton, { 5, .T., {|x| Pergunte(cPerg) }} )
  aAdd( aButton, { 1, .T., {|x| nOpc := 1, oDlg:End() }} )
  aAdd( aButton, { 2, .T., {|x| nOpc := 2, oDlg:End() }} )

  FormBatch( cTitulo, aSay, aButton )

  If nOpc <> 1
     Return Nil
  Endif
    
  MsAguarde({|lFim| LstDoc()},"Processamento","Aguarde...")

  dbSelectArea(cAlias)
   
Return

////////////////////// 
Static Function LstDoc                          

  Private aDoc:={}

  DEFINE FONT oFont NAME "Arial" SIZE 5,15
  DEFINE FONT oFnt3 NAME "Ms Sans Serif" Bold
 
  MontaQry() //- Monta query com as vendas no periodo informado

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Montando tela para exibição dis dados ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  DEFINE DIALOG oDlg TITLE "Documentos emitidos" FROM 180,180 TO 550,1100 PIXEL
  
  oBrowse := TCBrowse():New( 01 , 01, 455, 156,,{"Tipo","Qtde","Total"}, {30,30,50},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
 
  // Seta vetor para a browse                            
  oBrowse:SetArray(aDoc) 
 
  // Monta a linha a ser exibida no Browse
  oBrowse:bLine := {||{aDoc[oBrowse:nAt,01],;                         
                       Transform(aDoc[oBrowse:nAt,02],"999999"),;
                       Transform(aDoc[oBrowse:nAt,03],"@E 999,999.99") }}    
 
  // Evento de duplo click na celula
  //oBrowse:bLDblClick := {|| U_TFolder(oBrowse:nAt,aPeca,aEquip,aServ,aLoca,aNCla),oBrowse:Refresh() }
 
  TButton():New( 172, 052, "Sair", oDlg,{|| oDlg:End(), nlin := oBrowse:nAt, nOpc := 0   },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
 
  ACTIVATE DIALOG oDlg CENTERED 
Return

/////////////////////////
Static Function MontaQry 
  Local cQuery := ""
  cQuery := "SELECT F2_ESPECIE,COUNT(F2_ESPECIE)NDOC,SUM(SD2.D2_TOTAL)D2_TOTAL "
  cQuery += "FROM "+RetSQLName("SF2")+" SF2 "
  cQuery += "INNER JOIN " 
  cQuery += "("
  cQuery += "SELECT D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,SUM(D2_TOTAL)D2_TOTAL "
  cQuery += "FROM "+RetSQLName("SD2")+" "
  cQuery += "WHERE D_E_L_E_T_ <> '*' "
  cQuery += "AND D2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' " 
  cQuery += "AND D2_CF IN('5102','6102','5405','6405') " 
  cQuery += "GROUP BY D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA "
  cQuery += ") SD2 ON SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA "
  cQuery += "WHERE SF2.D_E_L_E_T_ <> '*' "
  //cQuery += "AND F2_ESPECIE='SPED' OR F2_ESPECIE='NFCE'
  cQuery += "GROUP BY F2_ESPECIE"  
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
  
  Do While !XXX->(Eof())
     AADD(aDoc,{XXX->F2_ESPECIE, XXX->NDOC, XXX->D2_TOTAL })
     XXX->(DbSkip())
  Enddo   
  XXX->(DbCloseArea())
Return	 

/////////////////////////////////
Static Function ValidPerg(cPerg)
  PutSX1(cPerg,"01",PADR("Da Data" ,29)+"?","","","mv_ch1","D",08,0,0,"G","","   ","","",mv_par01)
  PutSX1(cPerg,"02",PADR("Ate a Data" ,29)+"?","","","mv_ch2","D",08,0,0,"G","","   ","","",mv_par02)
Return