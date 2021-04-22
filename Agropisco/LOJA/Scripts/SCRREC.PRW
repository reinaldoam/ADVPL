#INCLUDE "AvPrint.ch"  
#INCLUDE "Font.ch"  
#INCLUDE "rwmake.ch" 

/*                           
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                                                                       ³±±
±±³05/03/2008³Diego Rafael   ³Bops 98346: Atualização da impressão de     ³±±
±±³                          ³somente Agropisco para a empresa que estiver³±±
±±³                          ³sendo Usada no momento                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ScrRec()

SetPrvt("AROTINA,CCADASTRO,")

aRotina := { { "Pesquisar", "AxPesqui"  , 0 , 1},;
             { "Imprimir" , "U_ImpRecibo" , 0 , 2}}

cCadastro := "Emissao de Recibo"

mBrowse( 06, 01, 22, 75, "SF2",, "F2_DOC")

Return

//
//
User Function ImpRecibo()
   Processa({|| RReport(),"Processando Dados"})  
RETURN                                            

/////////////////////////
Static FUNCTION RReport()

AVPRINT oPrn NAME "Emissao de Recibos"
   
   DEFINE FONT oFont1  NAME "Trebuchet MS"	  SIZE 0,10 Bold OF oPrn
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
      
/////////////////////////
Static Function RPrint()
  Local xCor, cReserv
  Local nPrcVenda := 0
  Local cNumOrc

  Private nPage:=1,nLine,nLinVert := 150,nColIni:=160,nColFim:=2300  

  nCol1:=nColIni       //Produto
  nCol2:=nCol1+1100    //Desconto
  nCol3:=nCol2+230     //Preço unitário
  nCol4:=nCol3+250     //Quantidade
  nCol5:=nCol4+180     //Total
  nLinFim:=2800

  cCodCli := SF2->F2_CLIENTE 
  cCodLoj := SF2->F2_LOJA
                         
  //- Clientes
//  DbSelectArea("SA1")
//  DbSetOrder(1)
  U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima.
  SA1->(DbSeek(xFilial("SA1")+cCodCli+cCodLoj))
  
  nTotal    :=0
  nDescItem :=0

  RCabec()

Return
      
////////////////////////
Static Function RCabec()
  Local nLarg:=300,nAlt:=200
  Local nValor, nDocum
  Local nTamRua,cEmail
  
  nLine := 150                                     
  
  //- Nota fiscal
  DbSelectArea("SF2")  
  
  nDocum:= SF2->F2_DOC 
  
  If SF2->F2_VALMERC = 0 //- Nota fiscal para cupom fiscal
     nRecSF2:= SF2->(Recno()) 
     nOrdSF2:= SF2->(IndexOrd())
     cNumCF := Substr(SF2->F2_NFCUPOM,4,6)+Substr(SF2->F2_NFCUPOM,1,3)
     SF2->(DbSetOrder(1))
     SF2->(DbSeek(xFilial("SF2")+cNumCF))
     nValor:= SF2->F2_VALMERC
     SF2->(Dbgoto(nRecSF2))     
     SF2->(DbSetOrder(nOrdSF2))
  Else
     nValor:= SF2->F2_VALMERC
  Endif    

  oPrn:Box(nLine,nLinVert,nLine+650,nColFim) //- Box do cabecalho
  
  oPrn:SayBitmap(nLine+30,nColIni,"msmdilogo.bmp",nLarg,nAlt); nLine += 50
  
  SM0->(DbSelectArea("SM0"))
  SM0->(DbGoTop())
  While (!SM0->(EOF()))
    if SM0->M0_CODIGO == cEmpAnt
       If cEmpAnt == "03"
          cEmail := "E-mail:acompressores@hotmail.com "
          ElseIf cEmpAnt == "01"
              cEmail := "E-mail:agropisco@agropisco.com.br - www.agropisco.com.br"
       EndIf
       Exit
    End 
    SM0->(DbSkip())
  End
  
/*  oPrn:Say(nLine , 0510 , " AGROPISCO COMERCIO E SERVICOS DE EQUIPAMENTOS LTDA"       , oFont1,,,,3)
  oPrn:Say(nLine , 1800 , " Recibo" , oFont5,,,,3) ;nLine += 080  
  oPrn:Say(nLine , 0510 , " Rua Vinca No.238 - Crespo - Cep:69073-180 Manaus-AM"      , oFont1,,,,3)
  oPrn:Say(nLine , 1830 , "000001", oFont5,,,,3) ;nLine += 080
  oPrn:Say(nLine , 0510 ," FONE:(92) 2121-4650/FAX:(92)2121-4660"                    , oFont1,,,,3); nLine += 080
  oPrn:Say(nLine , 0510 ," E-mail:agropisco@agropisco.com.br - www.agropisco.com.br" , oFont1,,,,3); nLine += 060
  oPrn:Line(nLine,nCol1-10,nLine,nColFim); nLine += 040*/

nTamRua := TamToV(SM0->M0_ENDCOB,Len(SM0->M0_ENDCOB))
    
  oPrn:Say(nLine , 0510 , SM0->M0_NOMECOM       , oFont1,,,,3)//Imprime Nome
  oPrn:Say(nLine , 1800 , " Recibo" , oFont5,,,,3) ;nLine += 080  
  
  oPrn:Say(nLine , 0510 ,  Trim(SUBSTR(SM0->M0_ENDCOB,0,nTamRua)) + "  No." + ;
                           AllTrim(SubStr(SM0->M0_ENDCOB,nTamRua+1,Len(SM0->M0_ENDCOB))) + ;
                           " - " + Trim(SM0->M0_BAIRCOB) + " - Cep: " + Trim(SubStr(SM0->M0_CEPCOB,0,5)) +;
                           "-" + Trim(SubStr(SM0->M0_CEPCOB,5,8)) + " " +;
                           Trim(SM0->M0_CIDCOB) + "-" + Trim(SM0->M0_ESTCOB) , oFont1,,,,3)
       
  oPrn:Say(nLine , 1830 , "000001", oFont5,,,,3) ;nLine += 080
  oPrn:Say(nLine , 0510 ,"FONE:" + Trim(SM0->M0_TEL) +"/" + "FAX:"+Trim(SM0->M0_FAX), oFont1,,,,3); nLine += 080
  oPrn:Say(nLine , 0510 , cEmail , oFont1,,,,3); nLine += 060 
  oPrn:Line(nLine,nCol1-10,nLine,nColFim); nLine += 040
  
  oPrn:Say(nLine    ,nColIni ,"Cliente : "+SA1->A1_COD+" - "+SA1->A1_NOME,oFont1,,,,3)
  oPrn:Say(nLine+50 ,nColIni ,"Endereço:  "+SA1->A1_END     ,oFont1,,,,3)
  oPrn:Say(nLine+100,nColIni ,"Bairro  :   "+PADR(SA1->A1_BAIRRO,20)+"- "+Transform(SA1->A1_CEP,"@R 99999-999")	 ,oFont1,,,,3)
  
  If SA1->A1_PESSOA == "J"
     cMask := "@R 99.999.999/9999-99"
  Else
     cMask := "@R 999.999.999-99"
  EndIf     

  oPrn:Say(nLine+150 ,nColIni,"Cgc/cpf :  "+Transform(SA1->A1_CGC,cMask) +"            I.E: " + SA1->A1_INSCR,oFont1,,,,3)
  oPrn:Say(nLine+200,nColIni ,"Telefone:  "+Transform(Alltrim(SA1->A1_TEL),"@R 9999-9999"),oFont1,,,,3) ;nLine += 380

  oPrn:Say(nLine, nColIni, "Recebi do Sr(a). " + Alltrim(SA1->A1_NOME) + " a importância supra de (R$ " + Alltrim(Transform(nValor,"@E 999,999,999.99")) + ")" + Extenso(nValor), oFont2,,,,3) ;nLine += 080  
//  oPrn:Say(nLine, nColIni, Alltrim(Transform(nValor,"@E 999,999,999.99")) + ") " + Extenso(nValor) + ", referente ao ", oFont2,,,,3) ;nLine += 080 
  oPrn:Say(nLine, nColIni, " Referente ao DOCUMENTO FISCAL " + nDocum + ".", oFont2,,,,3) ;nLine += 280 

  //cDescr := "Recebi do Sr(a). " + Alltrim(SA1->A1_NOME) + " a importância supra de (R$"  
  //cDescr += Alltrim(Transform(SL1->L1_VALMERC,"@E 999,999,999.99")) + ") " + Extenso(SL1->L1_VALMERC) + ", referente ao "
  //cDescr += "CUPOM FISCAL " + SL1->L1_DOC + "." 
  //oPrn:Say(nLine, nColIni, PADR(cDescr,60,"*") , oFont3,,,,3) ;nLine += 280  

  oPrn:Say(nLine, 0510, "Manaus, " + Dtoc(dDataBase), oFont2,,,,3) ;nLine += 180  
  oPrn:Say(nLine, 0510, "__________________________________________", oFont3,,,,3) ;nLine += 80  
  
  If cEmpAnt == "01"
  oPrn:Say(nLine, 0510, "                    AGROPISCO             ", oFont4,,,,3) ;nLine += 180  
  ElseIf cEmpAnt == "03"
        oPrn:Say(nLine, 0510, "                  AMAZON COMPRESS         ", oFont4,,,,3) ;nLine += 180  
  EndIf
  
                          
Return                       

//-----------------------------------------------------------------------------------------------------------------

Static Function TamToV(cPalavra,nTotal)
     Local nTam := 0
      For i := 1 To nTotal
       If(SubStr(cPalavra,i,1) == ",") 
        nTam:=i       
       EndIf
      Next
Return nTam