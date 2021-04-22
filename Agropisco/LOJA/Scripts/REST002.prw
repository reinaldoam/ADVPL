//#include "AvPrint.ch"    
#include "Font.ch"
#include "RwMake.ch"
 
User Function REST002(lCallme)
	Local oReport
	Private cPerg := 'REST002' 
 
	CriaSx1(cPerg)

    If lCallMe
       mv_par01:= SL1->L1_NUM
    Else   
   	   Pergunte(cPerg,.T.)
   	Endif
   	   
	Processa({ || xPrintRel(),OemToAnsi('Gerando o relatório.')}, OemToAnsi('Aguarde...'))
Return  
    
//////////////////////////// 
Static Function xPrintRel()  
    Local cAlias := Alias()
 
	Local nX 		:= 0
	Local nQtdPag 	:= 0  
    Local nLarg:=300,nAlt:=200,nColIni:=160
       
	Private oPrint          
	Private oFont08		:= TFont():New('Arial',,06,,.F.,,,,.F.,.F.)
	Private oFont08n	:= TFont():New('Arial',,06,,.T.,,,,.F.,.F.)
	Private oFont08		:= TFont():New('Arial',,08,,.F.,,,,.F.,.F.)
	Private oFont08n	:= TFont():New('Arial',,08,,.T.,,,,.F.,.F.)
	Private oFont10		:= TFont():New('Arial',,10,,.F.,,,,.F.,.F.)
	Private oFont10n	:= TFont():New('Arial',,10,,.T.,,,,.F.,.F.)
	Private oFont12		:= TFont():New('Arial',,12,,.F.,,,,.F.,.F.)
	Private oFont12n	:= TFont():New('Arial',,12,,.T.,,,,.F.,.F.)
	Private oFont14		:= TFont():New('Arial',,14,,.F.,,,,.F.,.F.)
	Private oFont14n	:= TFont():New('Arial',,14,,.T.,,,,.F.,.F.)
	Private oFont26		:= TFont():New('Arial',,26,,.F.,,,,.F.,.F.)
	Private oFont26n	:= TFont():New('Arial',,26,,.T.,,,,.F.,.F.)
    Private oFtA12	    := TFont():New("Arial",,12,,.f.,,,,,.f.  )

	Private nLin		:= 0
	Private nTotal      := 0 
 
	//- Orcamento de vendas
	DbSelectArea("SL1")
	DbSetOrder(1)
	DbSeek(xFilial("SL1")+mv_par01)
		
	If SL1->L1_TIPO == "V"

   	   oPrint := TMSPrinter():New(OemToAnsi('Comprovante de Vendas'))
	   oPrint:SetPortrait()  
 
       oPrint:StartPage()  
	
	   nLin  := 0010
       
       oPrint:SayBitmap(nLin,0010,"msmdilogo.bmp",nLarg,nAlt); nLin += 200
       
	   nTamRua := TamToV(SM0->M0_ENDCOB,Len(SM0->M0_ENDCOB))

       oPrint:Say(nLin,0010,PADC(SM0->M0_NOMECOM,40),oFont08n,,,,0); nLin += 50
       
       oPrint:Say(nLin, 0010, Trim(SUBSTR(SM0->M0_ENDCOB,0,nTamRua)) + "  No." + ;
                            AllTrim(SubStr(SM0->M0_ENDCOB,nTamRua+1,Len(SM0->M0_ENDCOB))) + ;
                            " - " + Trim(SM0->M0_BAIRCOB) + " - Cep: " + Trim(SubStr(SM0->M0_CEPCOB,0,5)) +;
                            "-" + Trim(SubStr(SM0->M0_CEPCOB,6,8)), oFont08,,,,3); nLin += 50
                            
       oPrint:Say(nLin,0010,PADC(Trim(SM0->M0_CIDCOB) + "-" + Trim(SM0->M0_ESTCOB) + " - " + SM0->M0_TEL,40),oFont08n,,,,0); nLin += 50                            

	   oPrint:Say(nLin,0010,"CUPOM FISCAL - 2a. VIA",oFont14n,,,,0); nLin += 100      
	
	   oPrint:Say(nLin,0010,"Cupom: "+SL1->L1_DOC,oFont08,,,,0); nLin += 50
	   oPrint:Say(nLin,0010,"Serie: "+SL1->L1_SERIE,oFont08,,,,0); nLin += 50
	   
	   oPrint:Say(nLin,0010,"Data: " + Dtoc(SL1->L1_EMISNF),oFont08,,,,0); nLin += 50
	   oPrint:Say(nLin,0010,"Hora: " + Substr(SL1->L1_HORA,1,6),oFont08,,,,0); nLin += 50
	   oPrint:Say(nLin,0010,"Pagto: "+FormPag(SL1->L1_FORMPG),oFont08,,,,0); nLin += 100
	   
       oPrint:Say(nLin ,0010    , "ITEM"  , oFont08, 100 )
       oPrint:Say(nLin ,0010+100, "CODIGO", oFont08, 100 )
       oPrint:Say(nLin ,0010+400, "DESCRICAO", oFont08, 100 )                                  
       oPrint:Say(nLin ,0010+1000, "QTDE", oFont08, 100 )                                  
       oPrint:Say(nLin ,0010+1100, "UN", oFont08, 100 )                                  
       oPrint:Say(nLin ,0010+1200, "VL. UNITARIO", oFont08, 100 )
       oPrint:Say(nLin ,0010+1500, "ICMS", oFont08, 100 )
       oPrint:Say(nLin ,0010+1700, "VL.ITEM", oFont08, 100 ); nLin += 100


	   //- Itens do orcamento de vendas
       DbSelectArea("SL2")
	   DbSetOrder(1)
	   DbSeek(xFilial("SL2")+mv_par01)
                           
       Do while !SL2->(Eof()) .And. SL2->L2_NUM = mv_par01 
          oPrint:Say(nLin ,0010 ,Padr(SL2->L2_DESCRI,20)                      , oFont08, 100 )                                  
	      oPrint:Say(nLin ,0320-50, Transform(SL2->L2_QUANT,"@E 999,999")     , oFont08, 100 )                                  
	      oPrint:Say(nLin ,0420-50, Transform(SL2->L2_VRUNIT,"@E 999,999.99") , oFont08, 100 )
	      oPrint:Say(nLin ,0520-50, Transform(SL2->L2_VLRITEM,"@E 999,999.99"), oFont08, 100 )
          nLin += 50                                              
          nTotal += SL2->L2_VLRITEM
          SL2->(DbSkip())
       Enddo                       
       oPrint:Say(nLin,0010, Replicate("=",40), oFont08n, 100 ); nLin += 50
       oPrint:Say(nLin,0010, "VALOR TOTAL:"   , oFont08n, 100 )
       oPrint:Say(nLin,0520-50, Transform(nTotal,"@E 999,999.99"),oFont08n, 100 ); nLin += 50
       oPrint:Say(nLin,0010, "VENDEDOR:", oFont08n, 100 )
       oPrint:Say(nLin,0300, Posicione("SA3",1,xFilial("SA3")+SL1->L1_VEND,"A3_NOME"), oFont08n, 100 ); nLin += 50
       oPrint:Say(nLin,0010, Replicate("=",40), oFont08n, 100 )
 
	   oPrint:EndPage()
 
	   oPrint:Preview()
	   oPrint:end()
	Endif
    dbSelectArea(cAlias)
Return          

////////////////////////////// 
Static Function CriaSx1(cPerg)
  PutSx1(cPerg,"01","Do Orcamento ?","Do Orcamento ?" ,"Do Orcamento ?","mv_ch1","C",06,0,0,"G","","SL1","","","mv_par01")
return
                                 
/////////////////////////////////
Static Function FormPag(cCodCond)
  Local cArea:= Alias()
  Local cDescCond:= Space(55)
  DbSelectArea("SX5")
  DbSetOrder(1)
  If DbSeek(xFilial("SX5")+"24"+cCodCond)
     cDescCond:= Alltrim(SX5->X5_DESCRI)   
  Endif
  DbSelectArea(cArea)
Return cDescCond                                            

///////////////////////////////////////
Static Function TamToV(cPalavra,nTotal)
     Local nTam := 0
      For i := 1 To nTotal
       If(SubStr(cPalavra,i,1) == ",") 
        nTam:=i       
       EndIf
      Next
Return nTam