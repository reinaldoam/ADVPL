#INCLUDE "AvPrint.ch"    
#INCLUDE "Font.ch"
#include "Protheus.ch"
#include "RwMake.ch"
 
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �SCRNFISC � Autor � Reinaldo Magalh�es     � Data � 02.05.17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impress�o de orcamento em impressora n�o fiscal TH         ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SCRNFISC(lCallme,cTpOrc)
  Local oReport
  SetPrvt("c_Obs1,c_Obs2")

  Private cPerg:= 'SCRNFISC01' 
 
  CriaSx1(cPerg)
  
  lCallMe:= If( lCallMe == Nil, .F., lCallMe)  // Verifica se foi chamado pelo menu ou traves de alguma rotina

  //If lCallMe
     mv_par01:= SL1->L1_NUM
  //Else   
  //   Pergunte(cPerg,.T.)
  //Endif
  Processa({ || xPrintRel(lCallMe,cTpOrc),OemToAnsi('Gerando o relat�rio.')}, OemToAnsi('Aguarde...'))
  //Processa({ || xPrintRel(),OemToAnsi('Gerando o relat�rio.')}, OemToAnsi('Aguarde...'))
Return  
    
///////////////////////////////////////// 
Static Function xPrintRel(lCallMe,cTpOrc)  
  Local cAlias := Alias()
  Local aForma := {}
  Local nX 	   := 0
  Local nQtdPag:= 0  
  Local nPos   := 0  
  Local nLarg:=300,nAlt:=200,nColIni:=160
  Local nTxJuros,nPreco,nVlrUnit
       
  Private oPrint          
  Private oFont06  := TFont():New('Arial',,06,,.F.,,,,.F.,.F.)
  Private oFont06n := TFont():New('Arial',,06,,.T.,,,,.F.,.F.)
  Private oFont08  := TFont():New('Arial',,08,,.F.,,,,.F.,.F.)
  Private oFont08n := TFont():New('Arial',,08,,.T.,,,,.F.,.F.)
  Private oFont10  := TFont():New('Arial',,10,,.F.,,,,.F.,.F.)
  Private oFont10n := TFont():New('Arial',,10,,.T.,,,,.F.,.F.)
  Private oFont12  := TFont():New('Arial',,12,,.F.,,,,.F.,.F.)
  Private oFont12n := TFont():New('Arial',,12,,.T.,,,,.F.,.F.)
  Private oFont14  := TFont():New('Arial',,14,,.F.,,,,.F.,.F.)
  Private oFont14n := TFont():New('Arial',,14,,.T.,,,,.F.,.F.)
  Private oFont26  := TFont():New('Arial',,26,,.F.,,,,.F.,.F.)
  Private oFont26n := TFont():New('Arial',,26,,.T.,,,,.F.,.F.)
  Private oFtA12   := TFont():New("Arial",,12,,.f.,,,,,.f.  )

  Private nLin		:= 0
  Private nCol		:= 0
  Private nTotal    := 0 
  Private nDifDesc  := 0 

  oPrint := TMSPrinter():New(OemToAnsi('Comprovante de Vendas'))
  oPrint:SetPortrait()
  oPrint:Setup() 
   
  //- Orcamento de vendas
  DbSelectArea("SL1")
  DbSetOrder(1)
  DbSeek(xFilial("SL1")+mv_par01)
                   
  //- Produto
  DbSelectArea("SB1")
  DbSetOrder(1)

  //- Cliente
  DbSelectArea("SA1")
  DbSetOrder(1)
  DbSeek(XFilial()+SL1->L1_CLIENTE+SL1->L1_LOJA)
  
  //- Formas de pagamento
  DbSelectArea("SL4")
  DbSetOrder(1)
  DbSeek(xFilial("SL4")+SL1->L1_NUM)

  //- Condi��o de pagamentos
  DbSelectArea("SE4")
  DbSetOrder(1)
  DbSeek(XFilial()+Sl1->L1_CondPG)

  DbSelectArea("SL1")
  
  c_Obs1:= SL1->L1_OBS1  
  c_Obs2:= SL1->L1_OBS2
  
  //������������������������Ŀ
  //� Inicio da impress�o	�
  //�������������������������
  oPrint:StartPage()  
  //nLin  := 0005
          
  //��������������������Ŀ
  //� Dados da empresa	�
  //����������������������
  //oPrint:SayBitmap(nLin,0010,"msmdilogo.bmp",nLarg,nAlt, , .T.); nLin += 200                   
  nTamRua := TamToV(SM0->M0_ENDCOB,Len(SM0->M0_ENDCOB))
  oPrint:Say(nLin,0010,SM0->M0_NOMECOM,oFont10n,,,,0); nLin += 50
  oPrint:Say(nLin,0010, Trim(SUBSTR(SM0->M0_ENDCOB,0,nTamRua)) + "  No." + ;
                        AllTrim(SubStr(SM0->M0_ENDCOB,nTamRua+1,Len(SM0->M0_ENDCOB))) + ;
                        " - " + Trim(SM0->M0_BAIRCOB) + " - Cep: " + Trim(SubStr(SM0->M0_CEPCOB,0,5)) +;
                        "-" + Trim(SubStr(SM0->M0_CEPCOB,6,8))+;
                        " " + Trim(SM0->M0_CIDCOB) + "/" + Trim(SM0->M0_ESTCOB), oFont08,,,,3); nLin += 50
  //�������������������Ŀ
  //� Dados do cliente	�
  //���������������������
  //oPrint:Say(nLin,0350,"ORCAMENTO",oFont08n,,,,0); nLin += 60
  oPrint:Say(nLin,0010,"Or�amento: " + SL1->L1_NUM+" - "+cTpOrc,oFont10n,,,,0); nLin += 50
  oPrint:Say(nLin,0010,"Cliente : " + Left(SA1->A1_Nome,30),oFont08,,,,0); nLin += 30
  oPrint:Say(nLin,0010,"CNPJ/CPF : " + SA1->A1_CGC,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Ins.Est : " + SA1->A1_Inscr,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Endere�o: " + Left(SA1->A1_End,25),oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"CEP     : " + SA1->A1_Cep,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Bairro  : " + SA1->A1_Bairro,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Cidade  : " + SA1->A1_Mun,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Estado  : " + SA1->A1_Est,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Fone    : " + SA1->A1_Tel,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Celular : " + SA1->A1_Fax,oFont08,,,,0); nLin += 30
  
  //���������������������Ŀ
  //� Dados do or�amento �
  //�����������������������
  oPrint:Say(nLin,0010,"Data    : " + Dtoc(SL1->L1_EMISSAO),oFont08,,,,0)
  oPrint:Say(nLin,0290,"Hora    : " + Time(),oFont08,,,,0)
  oPrint:Say(nLin,0550,"Validade: " + DTOC(SL1->L1_DTLIM),oFont08,,,,0); nLin += 30

  oPrint:Say(nLin,0010,"Vendedor: " + Posicione("SA3",1,xFilial("SA3")+SL1->L1_VEND,"A3_NOME"), oFont08, 100 )
  
  If !Empty(SL1->L1_XNUMOS)
     oPrint:Say(nLin,0500,"Num. OS : " + SL1->L1_XNUMOS,oFont08,,,,0); nLin += 30
  Else
     nLin += 30     
  Endif
  
  If AllTrim(SL1->L1_CONDPG) == "CN"
     aForma:= {}
     Do While SL4->(L4_FILIAL+L4_NUM) == xFilial("SL4")+SL1->L1_NUM .And. !SL4->(Eof())
        nPos:= aScan(aForma,{|x| x[1] = SL4->L4_FORMA })
        If nPos = 0                    
           DbSelectArea("SX5")
           DbSetOrder(1)
           Sx5->(DbSeek("  "+"24"+SL4->L4_FORMA)) 
           AADD(aForma,{SL4->L4_FORMA, ALLTRIM(Sx5->X5_DESCRI) })
        Endif     
        DbSelectArea("SL4")
        SL4->(DbSkip())
     Enddo                       
     oPrint:Say(nLin,0010,"Pagto   : ",oFont08,,,,0)     
     For i:= 1 to Len(aForma)                            
        oPrint:Say(nLin,0100,aForma[i,2],oFont08,,,,0); nLin += 30
     Next
  Else                                                   
     oPrint:Say(nLin,0010,"Pagto   : "+AllTrim(SE4->E4_DESCRI),oFont08,,,,0); nLin += 30     
  Endif

  oPrint:Say(nLin,0210,"SEM VALOR FISCAL",oFont08n,,,,0); nLin += 50
  oPrint:Say(nLin,0010,REPLICATE(".",100),oFont08,,,,0); nLin += 30
         
  oPrint:Say(nLin, 0010, "Codigo", oFont08n, 100 )
  oPrint:Say(nLin, 0200, "Descricao", oFont08n, 100 )                                  
  oPrint:Say(nLin, 0490, "Qtd", oFont08n, 100 )                                  
  oPrint:Say(nLin, 0600, "VlUnit.", oFont08n, 100 )
  oPrint:Say(nLin, 0710, "VlTotal", oFont08n, 100 ); nLin += 30
         
  oPrint:Say(nLin,0010,REPLICATE(".",100),oFont08,,,,0); nLin += 30
      
  //- Itens do orcamento de vendas
  DbSelectArea("SL2")
  DbSetOrder(1)
  DbSeek(xFilial("SL2")+SL1->L1_NUM)
         
  Do While !SL2->(Eof()) .And. SL2->L2_FILIAL==xFilial("SL2") .And. SL2->L2_NUM == SL1->L1_NUM

     nPreco:= SL2->L2_VRUNIT //- Preco liquido
 	 
	 If SL2->L2_VALDESC > 0
	    nVlrUnit := SL2->L2_PRCTAB //- Preco cheio           
	 Else 
	    nVlrUnit:= SL2->L2_VRUNIT //- Preco liquido
	 Endif   
     
     SB1->(DbSeek(xFilial()+SL2->L2_PRODUTO))
  
     oPrint:Say(nLin, 0010, ALLTRIM(SL2->L2_PRODUTO), oFont08, 100 )
     oPrint:Say(nLin, 0200, ALLTRIM(SL2->L2_DESCRI), oFont08, 100 );nLin += 30
     oPrint:Say(nLin, 0010, "LOC:"+Alltrim(SB1->B1_LOCAGRO)+"/"+SL2->L2_LOCAL, oFont08, 100 )
     oPrint:Say(nLin, 0230, "REF:"+PADR(SB1->B1_XCODFAB,15), oFont08, 100 )
     oPrint:Say(nLin, 0470, Transform(SL2->L2_QUANT,"@E 999,999"), oFont08, 100 )           //- Qtd                                  
     oPrint:Say(nLin, 0570, Transform(nPreco,"@E 999,999.99"), oFont08, 100 )               //- VlUnit
     oPrint:Say(nLin, 0695, Transform(SL2->L2_QUANT*nPreco,"@E 999,999.99"), oFont08, 100 ) //- VlTotal
     nLin += 30                                              
     nDifDesc += SL2->L2_VALDESC
     nTotal += SL2->L2_QUANT*nVlrUnit
     SL2->(DbSkip())
  Enddo      
  
  oPrint:Say(nLin,0010, Replicate(".",100), oFont08n, 100 ); nLin += 30
  oPrint:Say(nLin,0010, "Total Geral R$ "+Transform(nTotal,"@E 999,999.99"), oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, "Desconto Geral R$ "+Transform(nDifDesc,"@E 999,999.99"), oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, "Total Liq. Geral R$ "+Transform(nTotal-nDifDesc,"@E 999,999.99"), oFont08, 100 );nLin += 50
  oPrint:Say(nLin,0010, Replicate(".",100), oFont08n, 100 ); nLin += 50
  
  oPrint:Say(nLin,0010, "MINIMO PARA FATURAMENTO E ENTREGA R$ 200,00", oFont08n, 100 );nLin += 30
  oPrint:Say(nLin,0010, "ORCAMENTO SUJEITO A APROVACAO DE CREDITO", oFont08n, 100 );nLin += 50
  
  If !Empty(c_Obs1)
    oPrint:Say(nLin,0010, "Obs1:" + c_Obs1                   , oFont08, 100 ); nLin += 30
  Endif
  If !Empty(c_Obs2)  
     oPrint:Say(nLin,0010, "Obs2:" + c_Obs2                   , oFont08, 100 ); nLin += 30
  Endif   
  oPrint:EndPage()
  If lCallMe
     oPrint:Print()
  Else   
     oPrint:ResetPrinter()
     oPrint:Preview()                                                             
  Endif   
  oPrint:end()
	
  dbSelectArea(cAlias)
   
Return          

////////////////////////////// 
Static Function CriaSx1(cPerg)
  PutSx1(cPerg,"01","Orcamento ?","Orcamento ?" ,"Orcamento ?","mv_ch1","C",06,0,0,"G","","ORCA","","","mv_par01")
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