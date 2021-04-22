#INCLUDE "AvPrint.ch"    
#INCLUDE "Font.ch"
#include "Protheus.ch"
#include "RwMake.ch"

/* MSIGA                          
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄxxxxÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
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

User Function RAGRO007(nRecno)
  Private cOrc:= Space(06)

  If !Empty(nRecno)
     AB3->(Dbgoto(nRecno))
     cOrc:= AB3->AB3_NUMORC
  Endif   
                                                              
  @ 000,00 TO 200,450 DIALOG oObservacao TITLE "Observacao da Nota Fiscal"
  @ 010,10 SAY "Nro.Orçamento: "
  @ 010,50 Get cOrc when Empty(cOrc) SIZE 150,40
  @ 080,170 BMPBUTTON TYPE 1 ACTION Close(oObservacao)
  Activate Dialog oObservacao CENTERED
    
  Processa({|| RReport(),"Processando Dados"})  
  
Return

/////////////////////////
Static FUNCTION RReport()

AVPRINT oPrn NAME "Orcamentos de Vendas"
   
   
   DEFINE FONT oFont1  NAME "Trebuchet MS"	  SIZE 0,10 Bold OF oPrn
   DEFINE FONT oFont2  NAME "Trebuchet MS"    SIZE 0,11 Bold OF oPrn//"Times New Roman"
   DEFINE FONT oFont3  NAME "Trebuchet MS"    SIZE 0,16 Bold OF oPrn
   DEFINE FONT oFont4  NAME "Trebuchet MS"    SIZE 0,20 Bold OF oPrn
   DEFINE FONT oFont5  NAME "Trebuchet MS"    SIZE 0,22 Bold OF oPrn
   DEFINE FONT oFont6  NAME "Trebuchet MS"    SIZE 0,09 Bold OF oPrn
   DEFINE FONT oFontT  NAME "Trebuchet MS"    SIZE 0,16 Bold OF oPrn
   DEFINE FONT oFont8  NAME "Trebuchet MS"    SIZE 0,14 Bold OF oPrn
   DEFINE FONT oFont7  NAME "Trebuchet MS"    SIZE 0,12 Bold OF oPrn
      
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
  Private nPage:=1,nLine,nLinVert := 150,nColIni:=160,nColFim:=2300

  nCol1:=nColIni       //Produto
  nCol2:=nCol1+1100    //Desconto
  nCol3:=nCol2+230     //Preço unitário
  nCol4:=nCol3+250     //Quantidade
  nCol5:=nCol4+180     //Total
  nLinFim:=2800
 
  nTotal    :=0
  nDescItem :=0

  DbSelectArea("AB3")
//  DbSetOrder(1)
  U_MsSetOrder("AB3","AB3_FILIAL+AB3_NUMORC")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
  AB3->(DbSeek(xFilial("AB3")+cOrc))

  //cObs1 := IIF(Empty(SCJ->CJ_YOBS1),"",SCJ->CJ_YOBS1)
  //cObS2 := IIF(Empty(SCJ->CJ_YOBS2),"",SCJ->CJ_YOBS2)

  //SB1->(dbSetOrder(1))
  U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
  //SA1->(dbSetOrder(1))
  U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
  //AAG->(dbSetOrder(1))  
  U_MsSetOrder("AAG","AAG_FILIAL+AAG_CODPRB")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
 
  //AB4->(dbSetOrder(1))                     
  U_MsSetOrder("AB4","AB4_FILIAL+AB4_NUMORC+AB4_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
  AB4->(dbSeek(xFilial("AB4")+cOrc))
  //Cabeçalho do Produto Equipamento
  RCabec()
  While !AB4->(EOF()) .and. AB4->AB4_NUMORC = AB3->AB3_NUMORC
     ProcRegua(AB4->(LastRec()))
     Ver_Pag()
     SB1->(dbSeek(xFilial("SB1")+AB4->AB4_CODPRO))
     //
     oPrn:Say(nLine,nCol1     , PadR(Left(SB1->B1_COD,15),15)                        , oFontY,,xCor,,3)
     oPrn:Say(nLine,nCol1+250 , PadR(Left(SB1->B1_DESC,60),60)                          , oFontY,,xCor,,3)
     oPrn:Say(nLine,nCol1+1090, PadR(Left(AB4->AB4_NUMSER,15),15)                       , oFontY,,xCor,,3)
     oPrn:Say(nLine,nCol3+280 , PadR(Left("MODELO",10),10)                              , oFontY,,xCor,,3)

     nLine+=60

     AAG->(DbSeek(xFilial()+AB4->AB4_CODPRB))
     oPrn:Say(nLine,nCol1 , PadR("DEFEITO : "+Left(AAG->AAG_DESCRI,40),40)                       , oFont6 ,,xCor,,3);nLine+=60

     AB4->(dbSkip()) 

  Enddo
  oPrn:Say(nLine,nCol1 , PadR("OBS.    : "+AB3->AB3_OBS1  ,100)                       , oFont6 ,,xCor,,3);nLine+=60
  oPrn:Say(nLine,nCol1 , PadR(AB3->AB3_OBS2,  50)                                    , oFont6 ,,xCor,,3);nLine+=60
  oPrn:Say(nLine,nCol1 , PadR(AB3->AB3_OBS3,50)                                    , oFont6 ,,xCor,,3)
  nLine+=60
  //Apontamentos do Equipamento
  RCabec2()                 
  nValor   := 0
  nTotServ := 0
  dbSelectArea("AB5")
 // dbSetOrder(1)
  U_MsSetOrder("AB5","AB5_FILIAL+AB5_NUMORC+AB5_ITEM+AB5_SUBITE")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                    
  dbSeek(xFilial("AB5")+cOrc)
  While !AB5->(EOF()) .and. AB5->AB5_FILIAL+AB5->AB5_NUMORC = xFilial("AB5")+cOrc
     ProcRegua(AB5->(LastRec()))
     Ver_Pag()
     SB1->(dbSeek(xFilial("SB1")+AB5->AB5_CODPRO))
     xCor    := Nil
     cReserv := oFontY
     If Alltrim(SB1->B1_TIPO) == "MO"  // Mao de Obra
        xCor := CLR_HBLUE
        cReserv := oFontX
     Else
       xCor := Nil
       cReserv := oFontY
	 EndIf
     
     oPrn:Say(nLine,nCol1     , PadR(Left(SB1->B1_COD,15),15) , cReserv,,xCor,,3)
     
     If !Empty(AB5->AB5_DESPRO)                                                   
        oPrn:Say(nLine,nCol1+250 , PadR(Left(AB5->AB5_DESPRO,45),45), cReserv,,xCor,,3) 
     Else   
        oPrn:Say(nLine,nCol1+250 , PadR(Left(SB1->B1_DESC,45),45), cReserv,,xCor,,3) 
     Endif   
     
     If Alltrim(SB1->B1_TIPO) != "MO"  // Mao de Obra
        oPrn:Say(nLine,nCol1+1114, PADR(SB1->B1_POSIPI,10), cReserv,,xCor,,3)
        oPrn:Say(nLine,nCol1+1360, PadR(Left(SB1->B1_UM,10),10), cReserv,,xCor,,3)
     Endif
        
     oPrn:Say(nLine,nCol2+440 , PadL(Transform(AB5->AB5_QUANT,"@E 999,999.99"),12)      , cReserv,,xCor,,3)
     oPrn:Say(nLine,nCol3+430 , PadL(Transform(AB5->AB5_VUNIT,"@E 99,999,999.99"),15)   , cReserv,,xCor,,3)
     oPrn:Say(nLine,nCol5+220 , PadL(Transform(AB5->AB5_TOTAL,"@E 99,999,999.99"),15)   , cReserv,,xCor,,3)
     nLine+=60                                              
     
     If Alltrim(SB1->B1_TIPO) == "MO"  // Mao de Obra
       nTotServ += AB5->AB5_TOTAL
     Else                          // Substituicao de Pecas
       nTotal += AB5->AB5_TOTAL
     EndIf
     AB5->(dbSkip()) 
  Enddo
  nLine+=40
  RRoda()
Return
      
////////////////////////
Static Function RCabec()
  Local nLarg:=300,nAlt:=200
  Local cEmail
  Local nTamRua
  nLine := 150

  SA1->(dbSeek(xFilial("SA1")+AB3->AB3_CODCLI+AB3->AB3_LOJA))
  
  oPrn:Box(nLine,nLinVert,nLine+650,nColFim) //- Box do cabecalho
  
  //oPrn:SayBitmap(nLine+30,nColIni,"msmdilogo.bmp",nLarg,nAlt); nLine += 50
  oPrn:SayBitmap(nLine+30,nColIni,"logo_Agropisco.bmp",nLarg,nAlt); nLine += 50
  
  /*
  oPrn:Say(nLine , 0510 , " AGROPISCO COMERCIO E SERVICOS DE EQUIPAMENTOS LTDA"       , oFont1,,,,3)
  oPrn:Say(nLine , 1800 , " Orçamento" , oFont5,,,,3) ;nLine += 080  
  oPrn:Say(nLine , 0510 , " Rua Vinca No.238 Crespo Cep:69073-180 Manaus-AM"      , oFont1,,,,3)
  oPrn:Say(nLine , 1830 , AB3->AB3_NUMORC  , oFont5,,,,3) ;nLine += 080
  oPrn:Say(nLine , 0511 ," CNPJ: 84.125.962.0001/67 "                                 , oFont1,,,,3); nLine += 080
  oPrn:Say(nLine , 0510 ," FONE:(92) 2121-4650/FAX:(92)2121-4660"                    , oFont1,,,,3); nLine += 080
  oPrn:Say(nLine , 0510 ," E-mail:agropisco@agropisco.com.br - www.agropisco.com.br" , oFont1,,,,3); nLine += 060
  oPrn:Line(nLine,nCol1-10,nLine,nColFim); nLine += 040
  */
  
  //SM0->(DbSelectArea("SM0"))
  //SM0->(DbGoTop())
  //While (!SM0->(EOF()))
  //  if SM0->M0_CODIGO == cEmpAnt
  //     If cEmpAnt == "03"
  //        cEmail := "E-mail:acompressores@hotmail.com "
  //        ElseIf cEmpAnt == "01"
  //            cEmail := "E-mail:agropisco@agropisco.com.br - www.agropisco.com.br"
  //     EndIf
  //     Exit
  //  End 
  //  SM0->(DbSkip())
  //End            

  cEmail := "E-mail:agropisco@agropisco.com.br - www.agropisco.com.br"  
  
  nTamRua := TamToV(SM0->M0_ENDCOB,Len(SM0->M0_ENDCOB))
    
  oPrn:Say(nLine , 0510 , PADR(SM0->M0_NOMECOM,40) + "- CNPJ: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont1,,,,3)//Nome empresa / CNPJ
  
  oPrn:Say(nLine , 1800 , " Orçamento" , oFont5,,,,3) ;nLine += 080  
  
  oPrn:Say(nLine , 0510 ,  Trim(SUBSTR(SM0->M0_ENDCOB,0,nTamRua)) + "  No." + ;
                           AllTrim(SubStr(SM0->M0_ENDCOB,nTamRua+1,Len(SM0->M0_ENDCOB))) + ;
                           " - " + Trim(SM0->M0_BAIRCOB) + " - Cep: " + Trim(SubStr(SM0->M0_CEPCOB,0,5)) +;
                           "-" + Trim(SubStr(SM0->M0_CEPCOB,6,8)) + " " +;
                           Trim(SM0->M0_CIDCOB) + "-" + Trim(SM0->M0_ESTCOB) , oFont1,,,,3)
       
  oPrn:Say(nLine , 1830 , AB3->AB3_NUMORC  , oFont5,,,,3) ;nLine += 080
  oPrn:Say(nLine , 0510 ,"FONE:" + Trim(SM0->M0_TEL) +"/" + "DISK-PEÇAS:9132-3246(WHATS APP)", oFont1,,,,3); nLine += 080
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
  oPrn:Say(nLine+200,nColIni ,"Telefone:  "+Transform(Alltrim(SA1->A1_TEL),"@R 9999-9999");
  +"       FAX :"+Transform(Alltrim(SA1->A1_TEL),"@R 9999-9999")+"       Contato :  "+AB3->AB3_CONTAT,oFont1,,,,3) ;nLine += 280
  
  oPrn:Say(nLine , nCol1           , PadR("Codigo",60)   , oFont2,,,,3)
  oPrn:Say(nLine , nCol1+260       , PadR("Produto",60)  , oFont2,,,,3)
  oPrn:Say(nLine , nCol1+900+240   , PadR("Nro.Serie",10)     , oFont2,,,,3)
  oPrn:Say(nLine , nCol3+130+160   , PadR("Modelo.",15)    , oFont2,,,,3)   
//  oPrn:Say(nLine , nCol5+300       , PadR("Defeito",10)      , oFont2,,,,3)
  nLine += 080
                          
Return

///////////////////////
Static Function RRoda()                  
  Local nLarg:=250, nAlt:=200 
  Local nMinFatOS := GetMv("MV_XMINFAT")

  If nLine > 2100
     //cData := diaextenso(ddatabase)+","+alltrim(str(day(ddatabase)))+"/"+mesextenso(ddatabase)+"/"+alltrim(str(year(ddatabase)))+"   "+time()
     //oPrn:Say(3000,nCol1,"Data de Impressao: "+cData,oFont2,,,,3)
     //oPrn:Say(3100,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2,,,,3)
     nPage += 1  
     AVNEWPAGE
     nLine := 150
  Endif

  oPrn:Box(nLine,nLinVert,nLine+450,nColFim)
  nLine += 40

  oPrn:Say(nLine,nCol1+10,"Preços sujeitos a alteração sem aviso prévio",oFont1,,,,3)
  oPrn:Say(nLine-20,nCol3-100,"Peças: ",oFont3,,,,3)   
  oPrn:Say(nLine-20,nCol4+15+10,"R$"+Transform(nTotal,"@E 999,999,999.99"),oFont3,,,,3); nLine += 70 
  oPrn:Say(nLine-20,nCol3-100,"Mao de Obra: ",oFont3,,,,3)   
  oPrn:Say(nLine-20,nCol4+15+10,"R$"+Transform(nTotServ,"@E 999,999,999.99"),oFont3,,,,3); nLine += 100 
  oPrn:Say(nLine-20,nCol3-100,"Total: ",oFont3,,,,3)   
  oPrn:Say(nLine-20,nCol4+15+10,"R$"+Transform(nTotal+nTotServ,"@E 999,999,999.99"),oFont3,,,,3); nLine += 40 
   
  oPrn:Say(nLine,nCol1-135,PadC("",60),oFont1,,,,3) ; nLine += 90

  oPrn:Line(nLine,nLinVert,nLine,nColFim); nLine += 30
  oPrn:Say(nLine,nCol1+280,PadR("O VALOR MÍNIMO PARA FATURAMENTO E ENTREGA É DE R$ " + Transform(nMinFatOS, "@E 999,999.99"),170),oFont7,,,,3); nLine += 100 
  
  oPrn:Say(nLine,nCol1+250,PadR("GARANTIA DE 03 MESES EM RELAÇÃO A PEÇAS SUBSTITUIDAS E SERVIÇO EXECUTADO.",170),oFont7,,,,3); nLine += 100 

  cData := alltrim(str(day(AB3->AB3_EMISSA)))+"/"+substr(mesextenso(AB3->AB3_EMISSA),1,3)+"/"+alltrim(str(year(AB3->AB3_EMISSA)))

  oPrn:Say(nLine,nCol1,"Data: "+cData+"- Hora:"+TIME(),oFont2,,,,3); nLine += 100 

  oPrn:Say(nLine,nCol1,"Forma de pagamento: " + Fn_VerPG(AB3->AB3_CONPAG),oFont2,,,,3); nLine += 50
  //oPrn:Say(nLine,nCol1,"Validade Proposta: " + Dtoc(AB3->AB3_DTVAL),oFont2,,,,3); nLine += 50
  oPrn:Say(nLine,nCol1,"Validade Proposta: " + Dtoc(AB3->AB3_EMISSA+5),oFont2,,,,3); nLine += 50  
  oPrn:Say(nLine,nCol1,"Atendente: "+AB3->AB3_ATEND+SPACE(10),oFont2,,,,3); nLine += 150

  //oPrn:Say(nLine,nCol1,"Eu _____________________________________, portador do RG n._____________________, declaro estar ciente ",oFont2,,,,3); nLine += 50
  //oPrn:Say(nLine,nCol1,"e de acordo que a nao retirada do equipamento acima mencionado no prazo maximo de 90 dias, independente de",oFont2,,,,3); nLine += 50  
  //oPrn:Say(nLine,nCol1,"qualquer notificacao judicial, tem o equipamento em questao executado e seus valores revestidos em favor da",oFont2,,,,3); nLine += 50
  //oPrn:Say(nLine,nCol1,"________________________________, para cobrir eventuais despesas com pecas, mao de obra e locacao e de ",oFont2,,,,3); nLine += 50
  //oPrn:Say(nLine,nCol1,"espaco fisico.                                                                               ",oFont2,,,,3); nLine += 200

  oPrn:Say(nLine,nCol1,"NORMAS E CRITÉRIOS:",oFont8,,,,3); nLine += 50
  oPrn:Say(nLine,nCol1,"A) ORÇAMENTOS: Se decorrido 48 horas (dois dias) após a emissão do  orçamento,  e  o conserto  não  for",oFont2,,,,3); nLine += 50
  oPrn:Say(nLine,nCol1,"autorizado será cobrada uma permanência de 1% ao dia sobre o valor do produto. Após 15 dias, o equipa-",oFont2,,,,3); nLine += 50
  oPrn:Say(nLine,nCol1,"mento será sucateado e vendido para cobrir os gastos com armazenagem;",oFont2,,,,3); nLine += 50
  oPrn:Say(nLine,nCol1,"B) DA CONCLUSÃO DOS SERVIÇOS: Decorridos 15 (quinze dias) após a conclusão do serviço, e se ocorrer",oFont2,,,,3); nLine += 50
  oPrn:Say(nLine,nCol1,"abandono do proprietário responsável, o equipamento será sucateado e vendido para cobrir os gastos",oFont2,,,,3); nLine += 50
  oPrn:Say(nLine,nCol1,"com peças e mão-de-obra;",oFont2,,,,3); nLine += 50
  oPrn:Say(nLine,nCol1,"C) Todo equipamento em garantia devera acompanhar a Nota Fiscal de compra.",oFont2,,,,3); nLine += 100
  
  //- Mensagem colocada em 15/07/11 by Reinaldo Magalhães
  //oPrn:Say(3000,nCol1,"Para cada orçamento não aprovado, será cobrado o valor de R$ 20,00 no ato da entrega.",oFont8,,,,3); nLine += 100

  oPrn:Say(3000,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2,,,,3)

Return

/////////////////////////
Static Function Ver_Pag()
  If nLine >= nLinFim
     //cData := diaextenso(ddatabase)+","+alltrim(str(day(ddatabase)))+"/"+mesextenso(ddatabase)+"/"+alltrim(str(year(ddatabase)))+"   "+time()
     //oPrn:Say(3000,nCol1,"Data de Impressao: "+cData,oFont2,,,,3)
     //oPrn:Say(3100,nCol5,PadL("Pág. "+strzero(nPage,3),15),oFont2,,,,3)
     nPage += 1 
     AvNewPage       
     RCabec()
  Endif      
Return

//////////////////////////////////
Static Function Fn_VerPg(cCondPg)
  DbSelectArea("SE4")
  //DbSetOrder(1)
  U_MsSetOrder("SE4","E4_FILIAL+E4_CODIGO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                    
  SE4->(DbSeek(XFilial()+cCondPg,.T.))
  cRet:= Alltrim(SE4->E4_DESCRI)  
Return(cRet)

////////////////////////
Static Function RCabec2()
  Local nLarg:=300,nAlt:=200
  
  oPrn:Line(nLine,nCol1-10,nLine,nColFim); nLine += 040
  
  oPrn:Say(nLine , nCol1     , PadR("Codigo",60)   , oFont2,,,,3)
  oPrn:Say(nLine , nCol1+260 , PadR("Produto",60)  , oFont2,,,,3)
  oPrn:Say(nLine , nCol1+1140, PadR("NCM",8)     , oFont2,,,,3)
  oPrn:Say(nLine , nCol1+1340, PadR("Und.",10)     , oFont2,,,,3)
  oPrn:Say(nLine , nCol2+420 , PadL("Quant.",12)   , oFont2,,,,3)      
  oPrn:Say(nLine , nCol3+490 , PadR("V.Unit.",15)  , oFont2,,,,3)   
  oPrn:Say(nLine , nCol5+200 , PadL("Total R$",15) , oFont2,,,,3)
  nLine += 080
                          
Return
                                         
Static Function TamToV(cPalavra,nTotal)
     Local nTam := 0
      For i := 1 To nTotal
       If(SubStr(cPalavra,i,1) == ",") 
        nTam:=i       
       EndIf
      Next
Return nTam
