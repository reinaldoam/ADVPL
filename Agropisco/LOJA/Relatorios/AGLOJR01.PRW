//#include "AvPrint.ch"    
#include "Font.ch"
#include "RwMake.ch"
 
User Function AGLOJR01(lCallme)
	Local oReport
	Private cPerg := 'AGLOJR1' 
 
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

       oPrint:Say(nLin,0010,PADC(SM0->M0_NOMECOM,40),oFont10n,,,,0); nLin += 50
       
       oPrint:Say(nLin, 0010, Trim(SUBSTR(SM0->M0_ENDCOB,0,nTamRua)) + "  No." + ;
                            AllTrim(SubStr(SM0->M0_ENDCOB,nTamRua+1,Len(SM0->M0_ENDCOB))) + ;
                            " - " + Trim(SM0->M0_BAIRCOB) + " - Cep: " + Trim(SubStr(SM0->M0_CEPCOB,0,5)) +;
                            "-" + Trim(SubStr(SM0->M0_CEPCOB,6,8)), oFont08,,,,3); nLin += 50
                            
       oPrint:Say(nLin,0010,PADC(Trim(SM0->M0_CIDCOB) + "-" + Trim(SM0->M0_ESTCOB) + " - " + SM0->M0_TEL,40),oFont10n,,,,0); nLin += 50                            

	   oPrint:Say(nLin,0750,"CUPOM FISCAL - 2a. VIA",oFont14n,,,,0); nLin += 100      
	
	   oPrint:Say(nLin,0010,"Cupom: "+SL1->L1_DOC,oFont10,,,,0); nLin += 50
	   oPrint:Say(nLin,0010,"Serie: "+SL1->L1_SERIE,oFont10,,,,0); nLin += 50
	   
	   oPrint:Say(nLin,0010,"Data: " + Dtoc(SL1->L1_EMISNF),oFont10,,,,0); nLin += 50
	   oPrint:Say(nLin,0010,"Hora: " + Substr(SL1->L1_HORA,1,6),oFont10,,,,0); nLin += 50
	   oPrint:Say(nLin,0010,"Pagto: "+FormPag(SL1->L1_FORMPG),oFont10,,,,0); nLin += 100
	   
       oPrint:Say(nLin ,0010, "ITEM"  , oFont08, 100 )
       oPrint:Say(nLin ,0110, "CODIGO", oFont08, 100 )
       oPrint:Say(nLin ,0410, "DESCRICAO", oFont08, 100 )                                  
       oPrint:Say(nLin ,1110, "QTDE", oFont08, 100 )                                  
       oPrint:Say(nLin ,1260, "UN", oFont08, 100 )                                  
       oPrint:Say(nLin ,1410, "VL. UNITARIO", oFont08, 100 )
       oPrint:Say(nLin ,1610, "ST", oFont08, 100 )
       oPrint:Say(nLin ,1810, "VL.ITEM", oFont08, 100 ); nLin += 100

	   //- Itens do orcamento de vendas
       DbSelectArea("SL2")
	   DbSetOrder(1)
	   DbSeek(xFilial("SL2")+mv_par01)
                           
       Do while !SL2->(Eof()) .And. SL2->L2_NUM = mv_par01
          oPrint:Say(nLin, 0010, SL2->L2_ITEM, oFont08, 100 )
          oPrint:Say(nLin, 0110, SL2->L2_PRODUTO, oFont08, 100 )
          oPrint:Say(nLin, 0410, Padr(SL2->L2_DESCRI,40), oFont08, 100 )                                  
	      oPrint:Say(nLin, 1110, Transform(SL2->L2_QUANT,"@E 999,999"), oFont08, 100 ) 
	      oPrint:Say(nLin, 1260, SL2->L2_UM, oFont08, 100 )	      
	      oPrint:Say(nLin, 1410, Transform(SL2->L2_VRUNIT,"@E 999,999.99") , oFont08, 100 )
	      oPrint:Say(nLin, 1610, SL2->L2_SITTRIB, oFont08, 100 )
	      oPrint:Say(nLin, 1810, Transform(SL2->L2_VLRITEM,"@E 999,999.99"), oFont08, 100 )
          nLin += 50                                              
          nTotal += SL2->L2_VLRITEM
          SL2->(DbSkip())
       Enddo                       
       nLin += 50
       oPrint:Say(nLin,1410, "VALOR TOTAL:"   , oFont10, 100 )
       oPrint:Say(nLin,1810, Transform(nTotal,"@E 999,999.99"),oFont10n, 100 ); nLin += 50
       oPrint:Say(nLin,0010, "VENDEDOR:"+Posicione("SA3",1,xFilial("SA3")+SL1->L1_VEND,"A3_NOME"), oFont08, 100 ); nLin += 100
                                                                                              
       oPrint:Say(nLin,0010,"O PRAZO DE TROCA DE MERCADORIAS É DE 07 (SETE) DIAS A PARTIR DA DATA DA COMPRA", oFont08n, 100 ); nLin += 100
       oPrint:Say(nLin,0010,"IMPRESSO EM: " + DTOC(dDatabase) + " " + "HORARIO:"+Time(), oFont08n, 100 ); nLin += 100
       
       oPrint:Say(nLin,0010,"__________________________", oFont08, 100 ); nLin += 30
       oPrint:Say(nLin,0010,"        Gerente           ", oFont08, 100 ); nLin += 100  
       
       oPrint:Say(nLin,0010,"O CUPOM FISCAL É UM DOCUMENTO EQUIVALENTE A NOTA FISCAL. DIFERENCIANDO-SE DESTA POR TER QUE SER EMITIDO POR UMA IMPRESSORA FISCAL ESPECIAL", oFont08, 100 ); nLin += 100
       
       oPrint:Say(nLin,0010,"1. FUNDAMENTO LEGAL", oFont08n, 100 ); nLin += 50
       oPrint:Say(nLin,0010,"A OGRIGATORIEDADE DE USO DO EMISSOR DE CUPOM FISCAL-ECF FOI INSTITUIDO PELA LEI FEDERAL 9.532 DE 10 DE DEZEMBRO DE 1997 (ARTIGOS", oFont08, 100 ); nLin += 50
       oPrint:Say(nLin,0010,"61 E 62) E PELO DECRETO ESTADUAL 16.084 DE 02 DE MARCO DE 1998", oFont08, 100 ); nLin += 100 
       
       oPrint:Say(nLin,0010,"2.DEFINICOES DE ECF", oFont08n, 100 ); nLin += 50 
       oPrint:Say(nLin,0010,"EMISSOR DE CUPOM FISCAL (ECF) É UM EQUIPAMENTO DE AUTOMACAO COMERCIAL COM CAPACIDADE DE EMITIR DOCUMENTOS FISCAIS. DESTA", oFont08, 100 ); nLin += 50
       oPrint:Say(nLin,0010,"FORMA, ALEM DE SER UM IMPORTANTE INSTRUMENTO DE GESTAO DA EMPRESA VAREJISTA. SIMPLIFICANDO E AGILIZANDO A EMISSAO DO", oFont08, 100 ); nLin += 50
       oPrint:Say(nLin,0010,"DOCUMENTO FISCAL,TAMBEM É UM INSTRUMENTO DE CONTROLE FISCAL DE INTERESSE DO FISCO,SUJEITO, PORTANTO AS REGRAS", oFont08, 100 ); nLin += 50
       oPrint:Say(nLin,0010,"ESTABELECIDAS NA LEGISLACAO DO ICMS", oFont08, 100 ); nLin += 50 

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