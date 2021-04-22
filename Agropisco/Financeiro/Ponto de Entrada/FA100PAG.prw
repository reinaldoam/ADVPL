#include "Protheus.ch"
#include "Rwmake.ch"
#INCLUDE "AvPrint.ch"  
#INCLUDE "Font.ch"  

/*_______________________________________________________________________________
���������������������������������������������������������������������������������
��+-----------+------------+-------+----------------------+------+------------+��
��� Fun��o    � F100PAG    � Autor �                      � Data �            ���
��+-----------+------------+-------+----------------------+------+------------+��
��� Descri��o � Ponto de entrada para impressao do comprovante de sangria     ���
��+-----------+---------------------------------------------------------------+��
���������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
User Function FA100PAG
  Local lPerg := MsgYesNo("Imprime comprovante de sangria?")
  If lPerg                  
     ImpSangria()
  Endif 
Return 

//
//
Static Function ImpSangria()                                

  Local oFont3,oFont4 

  AVPRINT oPrn NAME "Emissao de Compriovante de Sangria"
   
  DEFINE FONT oFont1  NAME "Trebuchet MS"	 SIZE 0,10 Bold OF oPrn
  DEFINE FONT oFont2  NAME "Trebuchet MS"    SIZE 0,11 Bold OF oPrn//"Times New Roman"
  DEFINE FONT oFont3  NAME "Trebuchet MS"    SIZE 0,16 Bold OF oPrn
  DEFINE FONT oFont4  NAME "Trebuchet MS"    SIZE 0,20 Bold OF oPrn
  DEFINE FONT oFont5  NAME "Trebuchet MS"    SIZE 0,22 Bold OF oPrn
  DEFINE FONT oFont6  NAME "Trebuchet MS"    SIZE 0,09 Bold OF oPrn
  DEFINE FONT oFontT  NAME "Trebuchet MS"    SIZE 0,16 Bold OF oPrn
      
  DEFINE FONT oFontX  NAME "Trebuchet MS"     SIZE 0,09 Bold Italic Underline OF oPrn//"Times New Roman"
  DEFINE FONT oFontY  NAME "Trebuchet MS"     SIZE 0,09 Bold OF oPrn//"Times New Roman"

  oPrn:SETPORTRAIT()
   
  AVPAGE
     Processa({|X| lEnd := X, RPrint() })
  AVENDPAGE
   
  AVENDPRINT  
  oPrn:SETPORTRAIT()
  oFont1:End()
  oFont2:End()
  oFont3:End()
  oFont4:End()                                   
  oFont5:End()
  oFontT:End()                                   
Return .T.
      
///////////////////////
Static Function RPrint
  Local nLarg:=300,nAlt:=200,nLine,nLinVert:= 150,nColIni:=160,nColFim:=2300,nCol1:=160
  
  Local nTamRua,cEmail,dData,nValor,cHist,cCaixa
  Local oFont3,oFont4 
 
  dData  := SE5->E5_DATA
  nValor := SE5->E5_VALOR
  cHist  := SE5->E5_HISTOR
  cCaixa := SE5->E5_BANCO
  
  nLine := 150                                     
  
  cEmail := "E-mail:agropisco@agropisco.com.br - www.agropisco.com.br"

  oPrn:Box(nLine,nLinVert,nLine+650,nColFim) //- Box do cabecalho
  
  oPrn:SayBitmap(nLine+30,nColIni,"msmdilogo.bmp",nLarg,nAlt); nLine += 50
  
  nTamRua := TamToV(SM0->M0_ENDCOB,Len(SM0->M0_ENDCOB))
    
  oPrn:Say(nLine , 0510 , SM0->M0_NOMECOM       , oFont1,,,,3)//Imprime Nome
  oPrn:Say(nLine , 1800 , "Comprovante Sangria" , oFont3,,,,3) ;nLine += 080  
  
  oPrn:Say(nLine , 0510 ,  Trim(SUBSTR(SM0->M0_ENDCOB,0,nTamRua)) + "  No." + ;
                           AllTrim(SubStr(SM0->M0_ENDCOB,nTamRua+1,Len(SM0->M0_ENDCOB))) + ;
                           " - " + Trim(SM0->M0_BAIRCOB) + " - Cep: " + Trim(SubStr(SM0->M0_CEPCOB,0,5)) +;
                           "-" + Trim(SubStr(SM0->M0_CEPCOB,6,8)) + " " +;
                           Trim(SM0->M0_CIDCOB) + "-" + Trim(SM0->M0_ESTCOB) , oFont1,,,,3); nLine += 080
       
  oPrn:Say(nLine , 0510 ,"FONE:" + Trim(SM0->M0_TEL) +"/" + "FAX:"+Trim(SM0->M0_FAX), oFont1,,,,3); nLine += 080
  oPrn:Say(nLine , 0510 , cEmail , oFont1,,,,3); nLine += 060
  oPrn:Line(nLine,nCol1-10,nLine,nColFim); nLine += 040

  oPrn:Say(nLine, nColIni, "FOI RETIRADO DO CAIXA " + cCaixa + " A IMPORTANCIA SUPRA DE (R$" , oFont2,,,,3) ;nLine += 080  
  oPrn:Say(nLine, nColIni, Alltrim(Transform(nValor,"@E 999,999,999.99")) + ") " + Extenso(nValor) + ", REFERENTE A ", oFont2,,,,3) ;nLine += 080
  oPrn:Say(nLine, nColIni, cHist + ".", oFont2,,,,3) ;nLine += 280 

  oPrn:Say(nLine, 0510, "Manaus, " + Dtoc(dData), oFont2,,,,3) ;nLine += 180  
  oPrn:Say(nLine, 0510, "____________________", oFont3,,,,3) ;nLine += 80    
  oPrn:Say(nLine, 0510, "      CAIXA         ", oFont4,,,,3) ;nLine += 180  
                          
  oPrn:Say(nLine, 0510, "____________________", oFont3,,,,3) ;nLine += 80    
  oPrn:Say(nLine, 0510, "      GERENCIA      ", oFont4,,,,3) ;nLine += 180  

Return                                             

///////////////////////////////////////
Static Function TamToV(cPalavra,nTotal)
     Local nTam := 0
      For i := 1 To nTotal
       If(SubStr(cPalavra,i,1) == ",") 
        nTam:=i       
       EndIf
      Next
Return nTam