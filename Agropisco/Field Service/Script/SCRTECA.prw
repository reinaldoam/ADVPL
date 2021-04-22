#INCLUDE "AvPrint.ch"    
#INCLUDE "Font.ch"
#include "Protheus.ch"
#include "RwMake.ch"
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³SCRTECA ³ Autor ³ Reinaldo Magalhães     ³ Data ³ 08.05.17   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressão de orçamento do field service                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SCRTECA(lCallme)
  Local oReport
  SetPrvt("c_Obs1,c_Obs2")

  Private cPerg:= 'SCRTECA001' 
 
  CriaSx1(cPerg)
  
  lCallMe:= If( lCallMe == Nil, .F., lCallMe)  // Verifica se foi chamado pelo menu ou traves de alguma rotina

  If lCallMe
     mv_par01:= AB3->AB3_NUMORC
  Else   
     Pergunte(cPerg,.T.)
  Endif

  Processa({ || xPrintRel(lCallMe),OemToAnsi('Gerando o relatório.')}, OemToAnsi('Aguarde...'))
Return  
    
/////////////////////////////////// 
Static Function xPrintRel(lCallMe)  
  Local cAlias := Alias()
  Local aForma := {}
  Local nX 	   := 0
  Local nQtdPag:= 0  
  Local nPos   := 0  
  Local nLarg  :=300,nAlt:=200,nColIni:=160
  Local aTotal := { 0 , 0 }
       
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

  oPrint := TMSPrinter():New(OemToAnsi('Orcamento Serviço'))
  oPrint:SetPortrait()
  oPrint:Setup() 
   
  //- Orcamento Field Service
  DbSelectArea("AB3")
  dbSetOrder(1)
  dbSeek(xFilial("AB3")+mv_par01,.T.)
  
  //- Itens do orçamento Field
  DbSelectArea("AB4")
  dbSetOrder(1)
  
  //- Subitens do Orcamento Tecnico
  DbSelectArea("AB5")
  dbSetOrder(1)

  //- Ocorrencias de defeitos
  DbSelectArea("AAG")
  dbSetOrder(1)
  
  //- Produto
  DbSelectArea("SB1")
  DbSetOrder(1)

  //- Cliente
  DbSelectArea("SA1")
  DbSetOrder(1)
  DbSeek(xFilial("SA1")+AB3->AB3_CODCLI+AB3->AB3_LOJA)

  //- Condição de pagamentos
  DbSelectArea("SE4")
  DbSetOrder(1)
  DbSeek(XFilial()+AB3->AB3_CONPAG)

  DbSelectArea("AB3")
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Inicio da impressão	³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  oPrint:StartPage()  
          
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Dados da empresa	³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  //oPrint:SayBitmap(nLin,0010,"msmdilogo.bmp",nLarg,nAlt, , .T.); nLin += 200                   
  oPrint:Say(nLin,0010, "AGROPISCO COM. E SERV. DE EQUIP. EIRELE",oFont10n,,,,0); nLin += 50
  oPrint:Say(nLin,0010, "AV.IVANETE MACHADO No. 755 - PARQUE 10 - Cep:69055-750 - MANAUS/AM", oFont08,,,,3); nLin += 50
  oPrint:Say(nLin,0010, "FONE:(92) 2121-4650 /FAX:(92) 2121-4660", oFont08,,,,3); nLin += 50
  oPrint:Say(nLin,0010, "WhatsAPP:(92) 99132-3246", oFont08,,,,3); nLin += 50

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Dados do cliente	³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  //oPrint:Say(nLin,0350,"ORCAMENTO",oFont08n,,,,0); nLin += 60
  oPrint:Say(nLin,0010,"Orçamento: " + AB3->AB3_NUMORC,oFont10n,,,,0); nLin += 50
  oPrint:Say(nLin,0010,"Cliente : " + Left(SA1->A1_Nome,30),oFont08,,,,0); nLin += 30
  oPrint:Say(nLin,0010,"CNPJ/CPF : " + SA1->A1_CGC,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Ins.Est : " + SA1->A1_Inscr,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Endereço: " + Left(SA1->A1_End,25),oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"CEP     : " + SA1->A1_Cep,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Bairro  : " + SA1->A1_Bairro,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Cidade  : " + SA1->A1_Mun,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Estado  : " + SA1->A1_Est,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Fone    : " + SA1->A1_Tel,oFont08,,,,0); nLin += 30
  //oPrint:Say(nLin,0010,"Celular : " + SA1->A1_Fax,oFont08,,,,0); nLin += 30
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Dados do orçamento ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  oPrint:Say(nLin,0010,"Data     : " + dtoc(AB3->AB3_EMISSA),oFont08,,,,0)
  oPrint:Say(nLin,0290,"Hora     : " + AB3->AB3_HORA,oFont08,,,,0)
  oPrint:Say(nLin,0550,"Validade : " + dtoc(AB3->AB3_DTVAL),oFont08,,,,0); nLin += 30
  oPrint:Say(nLin,0010,"Atendente: " + AB3->AB3_ATEND, oFont08, 100 );nLin += 30     
  oPrint:Say(nLin,0010,"Pagto    : " + AllTrim(SE4->E4_DESCRI),oFont08,,,,0); nLin += 30     
  oPrint:Say(nLin,0010,"Contato  : " + AllTrim(AB3->AB3_CONTAT),oFont08,,,,0); nLin += 50     

  oPrint:Say(nLin,0210,"SEM VALOR FISCAL",oFont08n,,,,0); nLin += 50
  oPrint:Say(nLin,0010,REPLICATE(".",100),oFont08,,,,0); nLin += 30
         
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Imprimindo itens do Orcamento Tecnico  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  oPrint:Say(nLin, 0010, "Codigo", oFont08n, 100)
  oPrint:Say(nLin, 0250, "Produto", oFont08n, 100); nLin += 30                                  
  oPrint:Say(nLin, 0010, "Nr.Serie", oFont08n, 100)                                  
  oPrint:Say(nLin, 0250, "Defeito", oFont08n, 100); nLin += 30
       
  oPrint:Say(nLin,0010,REPLICATE(".",100),oFont08,,,,0); nLin += 30
 
  AB4->(dbSeek(xFilial("AB4")+AB3->AB3_NUMORC))

  Do While !AB4->(Eof()) .And. xFilial("AB4") = AB4->AB4_FILIAL .And. AB3->AB3_NUMORC = AB4->AB4_NUMORC
  
	 AAG->(dbSeek(xFilial("AAG")+AB4->AB4_CODPRB)) //- Ocorrencias de defeitos
     
     SB1->(DbSeek(XFILIAL("SB1")+AB4->AB4_CODPRO)) //- Produtos
  
     oPrint:Say(nLin, 0010, ALLTRIM(AB4->AB4_CODPRO), oFont08, 100 )     
     oPrint:Say(nLin, 0250, ALLTRIM(SB1->B1_DESC), oFont08, 100 );nLin += 30
     oPrint:Say(nLin, 0010, AB4->AB4_NUMSER, oFont08, 100 )                                  
     oPrint:Say(nLin, 0250, Left(AAG->AAG_DESCRI,40), oFont08, 100 ); nLin += 30                                              
     AB4->(DbSkip())
  Enddo      
  oPrint:Say(nLin,0010, Replicate(".",100), oFont08n, 100 ); nLin += 30                               
  oPrint:Say(nLin,0010, "Obs.: "+Left(AB3->AB3_OBS1,50), oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, Replicate(".",100), oFont08n, 100 ); nLin += 30                               
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Imprimindo subitens do Orcamento Tecnico  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  oPrint:Say(nLin, 0010, "Codigo", oFont08n, 100)
  oPrint:Say(nLin, 0230, "Descricao", oFont08n, 100);nLin += 30
  oPrint:Say(nLin, 0230, "UM", oFont08n, 100)                                  
  oPrint:Say(nLin, 0420, "Quant.", oFont08n, 100)
  oPrint:Say(nLin, 0550, "VlUnit.", oFont08n, 100)
  oPrint:Say(nLin, 0660, "VlTotal", oFont08n, 100)
  nLin += 30
  
  AB5->(dbSeek(xFilial("AB5")+AB3->AB3_NUMORC))
		
  Do While !AB5->(Eof()) .And. xFilial("AB5") = AB5->AB5_FILIAL .And. AB3->AB3_NUMORC = AB5->AB5_NUMORC
     
     SB1->(dbSeek(xFilial("SB1")+AB5->AB5_CODPRO))
     
     oPrint:Say(nLin, 0010, Left(SB1->B1_COD,15)                     , oFont08, 100 )     
     oPrint:Say(nLin, 0230, Left(SB1->B1_DESC,45)                    , oFont08, 100 ); nLin += 30
     oPrint:Say(nLin, 0230, Left(SB1->B1_UM,2)                       , oFont08, 100 )                                  
     oPrint:Say(nLin, 0370, Transform(AB5->AB5_QUANT,"@E 999,999")   , oFont08, 100 )                                  
     oPrint:Say(nLin, 0520, Transform(AB5->AB5_VUNIT,"@E 999,999.99"), oFont08, 100 )
     oPrint:Say(nLin, 0645, Transform(AB5->AB5_TOTAL,"@E 999,999.99"), oFont08, 100 ); nLin += 30

  	 If Alltrim(SB1->B1_TIPO) = "MO"  // Mao de Obra
	    aTotal[02] += AB5->AB5_TOTAL
     Else                          // Substituicao de Pecas
		aTotal[01] += AB5->AB5_TOTAL
     EndIf
     AB5->(DbSkip())
  Enddo                                                                
  oPrint:Say(nLin,0010, Replicate(".",100), oFont08n, 100 ); nLin += 30
  oPrint:Say(nLin,0010, "Peças R$ "+Transform(aTotal[01],"@E 999,999.99"), oFont08n, 100 );nLin += 30
  oPrint:Say(nLin,0010, "Mão de Obra R$ "+Transform(aTotal[02],"@E 999,999.99"), oFont08n, 100 );nLin += 30
  oPrint:Say(nLin,0010, "Total R$ "+Transform(aTotal[01]+aTotal[02],"@E 999,999.99"), oFont08n, 100 );nLin += 30
  oPrint:Say(nLin,0010, Replicate(".",100), oFont08n, 100 ); nLin += 30
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ NORMAS E CRITERIOS     ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                              
  oPrint:Say(nLin,0010, "NORMAS E CRITÉRIOS", oFont08n, 100 );nLin += 50
  oPrint:Say(nLin,0010, "A) ORCAMENTOS: Se decorrido 48 horas (dois dias) após a"   , oFont08, 100 );nLin += 30 
  oPrint:Say(nLin,0010, "emissão do orcamento e o conserto não for autorizado será" , oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, "cobrada uma permanencia de 1% ao dia sobre o valor do" , oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, "produto. Após 15 dias,o equipamento será sucateado e" , oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, "vendido para cobrir os gastos com armazenagem;"          , oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, "B) DA CONCLUSAO DOS SERVICOS: Decorridos 15 (quinze)"     , oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, "dias, após a conclusão do serviço,e se ocorrer abandono do" , oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, "proprietário responsável,o equipamento será sucateado e", oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, "vendido para cobrir os gastos com peças e mão-de-obra;", oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, "C) Todo equipamento em garantia deverá acompanhar o", oFont08, 100 );nLin += 30
  oPrint:Say(nLin,0010, "documento fiscal de compra.", oFont08, 100 );nLin += 30
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ DADOS FINAIS     ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                              
  oPrint:Say(nLin,0010, Replicate(".",100), oFont08n, 100 ); nLin += 30
  oPrint:Say(nLin,0010,"Data de impressão: " + dtoc(dDataBase),oFont08,,,,0)
  oPrint:Say(nLin,0450,"Hora impressao: " + Time(),oFont08,,,,0);nLin += 30
  oPrint:Say(nLin,0010, Replicate(".",100), oFont08n, 100 ); nLin += 30
  
  oPrint:Say(nLin,0010, "PRECOS SUJEITO A ALTERAÇÃO SEM AVISO PRÉVIO.", oFont08n, 100 );nLin += 30
  oPrint:Say(nLin,0010, "", oFont08n, 100 );nLin += 50

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