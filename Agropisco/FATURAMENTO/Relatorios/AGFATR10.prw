#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AGFATR10  º Autor ³ WERMESON  GADELHA  º Data ³  02/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELATORIO DE COMISSAO - NOVO MODELO DE COMISSAO            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AGFATR10()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2     := "de acordo com os parametros informados pelo usuario."
Local cDesc3     := "RELATÓRIO DE COMISSAO"
Local cPict      := ""
Local titulo     := "RELATÓRIO DE COMISSAO"
Local nLin       := 180
Local Cabec1     := ""  
Local Cabec2     := ""
Local imprime    := .T.
Local aOrd       := {}
Local aVendaCom  := {}

Local cCodUsu    := RetCodUsr()                             //- Codigo do usuario logado
Local cNomUsu    := ALLTRIM(Upper(SubStr(cUsuario, 7, 15))) //- Nome do usuário
Local cAutCom    := ALLTRIM(GetMv("MV_XLSTCOM"))            //- Usuario que podem visualizar todas as comissoes
Local cCodVend   := ""

Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "G"
Private nomeprog   := "AGFATR10" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg      := "FATR10" 
Private lweb       := IsBlind() 

Private cString   := "SD2"                         

Private aDevoluc := {} 

dbSelectArea("SD2")
U_MsSetOrder("SD2","D2_FILIAL+D2_COD+D2_LOCAL+D2_NUMSEQ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima

If lWeb  
   mv_par01 := "  "
   mv_par02 := "ZZ"
   mv_par03 := dTos(date())
   mv_par04 := dTos(date())
   mv_par05 := "      "
   mv_par06 := "ZZZZZZ"
   mv_par07 := 4
   mv_par08 := "   "
   mv_par09 := "ZZZ"
   mv_par10 := "      "
   mv_par11 := "ZZZZZZ"
   __AIMPRESS[1]:=1 
Else
   Pergunte(cPerg,.F.)
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Monta a interface padrao com o usuario...                           ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
   If nLastKey == 27
      Return                               
   Endif
   SetDefault(aReturn,cString)
EndIf   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tratativa para impressao de relatorio por vendedor  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(cNomUsu $ cAutCom)
   cCodVend := Posicione("SA3",7,xFilial("SA3")+cCodUsu,"A3_COD")
   mv_par10 := cCodVend
   mv_par11 := cCodVend
Endif  

//                                                                                                             1         1         1         1         1         1         1         1         1          
//         0	     1		   2		 3		   4 	     5		   6		 7		   8		 9	       0  	     1         2         3		   4		 5         6         7         8          
//		   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Cabec1  := "NOTA FISCAL      CLIENTE                                           VALOR BASE  PRC LISTA   DESC%    ACRESC.     VENDEDOR                %      COMISSÃO   COND. PAG." 
Cabec2  := ""
//          XXX - XXXXXXXXX  99999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999,999.99  999,999.99  999.99%  999,999.99  XXXXXXXXXXXXXXXXXXXX  999.99%    999.99   xxxxxxxxxxxxxxx

Cabec2  := SPACE(91)+"PERIODO DE " + SubStr(dTos(mv_par03),7,2) + "/"+ SubStr(dTos(mv_par03),5,2)+ "/" +SubStr(dTos(mv_par03),1,4) +; 
		   " ATE " + SubStr(dTos(mv_par04),7,2) + "/"+ SubStr(dTos(mv_par04),5,2)+ "/" + SubStr(dTos(mv_par04),1,4) 

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  02/01/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLinII)

Local aVendaCom  := {}                            

Local nTotDevV   := 0 //- Total de devolução por vendedor
Local nTotDevG   := 0 //- Total de devolução geral

Private nRegis	 := 0
Private cAuxDoc  := ""
pRIVATE cAuxSer  := ""
Private cAuxTES  := ""
Private cTes1	 := ""
Private cAuxVend := ""
Private nType    := 0
Private nPeca    := 0
Private nLocacao := 0
Private nServico := 0                    
Private nCalcCom1:= 0
Private nCalcCom2:= 0

Private nLin     := 180 
                       //  11  		1    	  2		3	  4	   5      6     7      8      9        10
Private cCfPeca  := getmv("MV_CFPECA")
Private cCfServ  := getmv("MV_CFSERV")
Private cTesLoca := getmv("MV_TESLOCA")
Private nAuxLin  := nLin
Private lImp 	 := .F.
                     
Private nValBase := 0
Private nValBVen := 0
Private nValBLst := 0
Private nAcreG   := 0

Private nValCom  := 0
Private nValLista:= 0 
Private nValDesc:= 0 

Private nValCVen  := 0
Private nValBDesc := 0 

Private nBase    := 0
Private nPrcLista:= 0

Private nDesc  := 0
Private nAcreT := 0
Private nAcreP := 0
Private nAcreV := 0

AAdd(aVendaCom, {0, 0})

dbSelectArea(cString)
dbSetOrder(1)

MontaQry()

DevForaPrz() //- Devoluções fora do prazo de comissão

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                        
DbSelectArea("XXX")      
      
SetRegua(nRegis)

dbGoTop()

Do while !XXX->(EOF())
   
   IncRegua()
   
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica se a NF tem devolucao  ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   //If !VerifSD1()	
   //   cAuxDoc  := XXX->D2_DOC
   //   cAuxSer  := XXX->D2_SERIE
   //   cAuxTES  := XXX->D2_CF
   //   cTes1    := XXX->D2_TES
   //   cAuxVend := XXX->F2_VEND1
   //   lImp   := .T.
   //   XXX->(dbSkip())
   //   Loop 	  
   //Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 55  
       If nAuxLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
           Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
           nLin := 9 
           nAuxLin := 9 
       Endif
   Endif 
   
   If cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE
                     
      aVendaCom := QryVend(XXX->F2_DOC,XXX->F2_SERIE,XXX->F2_CLIENTE,XXX->F2_LOJA)  
         
      nBase     := aVendaCom[1][1] //QryVend(XXX->F2_DOC,XXX->F2_SERIE)  
      nPrcLista := aVendaCom[1][2]
      
      nDesc     := IIF(nBase > nPrcLista, 0, (1-(nBase/nPrcLista))*100)  
      nAcreP    := IIF(nBase > nPrcLista, ((nBase/nPrcLista)-1)*100,0) //- Acrescimo em percentual 
      nAcreV    := IIF(nBase > nPrcLista, nBase-nPrcLista,0)           //- Acrescimo em valor
      
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Regra para cálculo de percentual de comissão baseado em desconto  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If nDesc = 0
         nCalcCom1 := 1 // as vendas que não tiverem descontos  1% de comissão
      ElseIf nDesc > 0 .And. nDesc <= 3    
         nCalcCom1 := 0.7 // as vendas que  tiverem até 3% de desconto  0,7% de comissão
      ElseIf nDesc > 3 .And. nDesc <= 5
         nCalcCom1 := 0.5 // as vendas que  tiverem de 3,1% até 5% de desconto  0,5% de comissão
      ElseIf nDesc > 5    
         nCalcCom1 := 0.5 // as vendas que  tiverem mais de 5% de desconto  0,25% de comissão
      Endif

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Regra para cálculo de percentual de comissão baseado em acrescimo ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      If nAcreP > 5
         nCalcCom1 := 1.50
      Endif   

      If nBase > 0 
         @nLin, 000 PSay XXX->D2_SERIE+" - "+XXX->D2_DOC
         @nLin, 017 PSay SubStr(XXX->D2_CLIENTE+" - "+Posicione("SA1",1,xFilial("SA1")+XXX->D2_CLIENTE,"A1_NOME"),1,40)
         @nLin, 067 PSay Transform(nBase,"@E 999,999.99")
         @nLin, 079 PSay Transform(nPrcLista,"@E 999,999.99")
         @nLin, 091 PSay Transform(nDesc,"@E 999.99")+"%"  
         @nLin, 101 PSay Transform(nAcreV,"@E 999,999.99") //
         @nLin, 113 PSay SubStr(Posicione("SA3",1,xFilial("SA3")+XXX->F2_VEND1,"A3_NOME"),1,20)
         @nLin, 135 PSay Transform(nCalcCom1,"@E 999.99")+"%"
         @nLin, 146 PSay Transform((nCalcCom1 * nBase)/100,"@E 999.99")
         @nLin, 155 PSay Iif (XXX->F2_COND = "CN", "CONDICAO NEGOCIADA", Posicione("SE4",1,xFilial("SE4")+XXX->F2_COND,"E4_DESCRI"))
         nLin++
      
         nAuxLin:= nLin
         nValBase += nBase
         nValBVen += nBase    
      
         nValLista += nPrcLista
         nValBLst  += nPrcLista
     
         nValCom  += (nCalcCom1 * nBase)/100
         nValCVen += (nCalcCom1 * nBase)/100
         
         nAcreT += nAcreV
         nAcreG += nAcreV
         
      Endif
   Endif        

   U_MsSetOrder("SF4","F4_FILIAL+F4_CODIGO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima
   
   SF4->(dbSeek(xFilial("SF4")+XXX->D2_TES))
   
   //nLin := nAuxLin + 1
      
   cAuxDoc  := XXX->D2_DOC
   cAuxTES  := XXX->D2_CF
   cTes1    := XXX->D2_TES
   cAuxSer  := XXX->D2_SERIE                                       
   cAuxVend := XXX->F2_VEND1 
   
   XXX->(dbSkip()) // Avanca o ponteiro do registro no arquivo

   If cAuxVend <> XXX->F2_VEND1
      nLin++
      @ nLin, 000  PSay __PrtThinLine()
      nLin++                           
      
      nValBDesc := (1-(nValBVen/nValBLst)) * 100
      
      @nLin,002 pSay "TOTAL VENDEDOR: " + Posicione("SA3",1,xFilial("SA3")+AllTrim(cAuxVend),"A3_NOME")         

      @nLin,067 pSay TRANSFORM(nValBVen , "@E 999,999.99")   
      @nLin,079 pSay TRANSFORM(nValBLst , "@E 999,999.99")
      @nLin,091 PSay Transform(nValBDesc,"@E 999.99")+"%" 
      @nLin,101 PSay Transform(nAcreT,"@E 999,999.99")
      @nLin,146 pSay TRANSFORM(nValCVen , "@E 999,999.99")      
      nLin += 2
      
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Impressão das devoluções de vendas    ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      Asort(aDevoluc,,, {|x,y| x[1] < y[1]})
                
      nTotDevV := 0
      
      For i:= 1 to Len(aDevoluc)  
         If aDevoluc[i][1] == cAuxVend
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Impressao do cabecalho do relatorio. . .                            ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            If nLin > 55  
               If nAuxLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
                  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
                  nLin := 9 
                  nAuxLin := 9 
               Endif
            Endif   
            @nLin, 000 PSay aDevoluc[i][2]+" - "+aDevoluc[i][3]
            @nLin, 017 PSay SubStr(aDevoluc[i][4]+" - "+Posicione("SA1",1,xFilial("SA1")+aDevoluc[i][4],"A1_NOME"),1,40)
            @nLin, 067 PSay TRANSFORM(aDevoluc[i][6], "@E 999,999.99")
            @nLin, 113 PSay "DATA VENDA: " + Dtoc(aDevoluc[i][5])
            nLin++
            nAuxLin:= nLin
            nTotDevV += aDevoluc[i][6]
            nTotDevG += aDevoluc[i][6]
         Endif   
      Next
      If nTotDevV > 0
         nLin++
         @nLin,002 pSay "TOTAL DEVOLUCAO FORA PERIODO "  
         @nLin,067 pSay TRANSFORM(nTotDevV, "@E 999,999.99")   
         nLin += 2
         @nLin,002 pSay "TOTAL LIQUIDO VENDEDOR: " + Posicione("SA3",1,xFilial("SA3")+AllTrim(cAuxVend),"A3_NOME")         
         @nLin,067 pSay TRANSFORM(nValBVen-nTotDevV , "@E 999,999.99")   
         //@nLin,079 pSay TRANSFORM(nValBLst-nTotDevV , "@E 999,999.99")
         //@nLin,091 PSay Transform(nValBDesc,"@E 999.99")+"%" 
         //@nLin,101 PSay Transform(nAcreT,"@E 999,999.99")
         //@nLin,146 pSay TRANSFORM(nValCVen , "@E 999,999.99")      
         nLin += 2
      Endif
    
      nValBVen  := 0
      nValCVen  := 0
	  nValBlst  := 0
	  nAcreT    := 0
	  
	  nAuxLin:= nLin   
	  
	  If !(XXX->(Eof()))
	     nLin++
	     @ nLin, 000  PSay __PrtThinLine()
	     nLin++
	     nAuxLin:= nLin
      EndIf
   Endif
Enddo
                                       
If nRegis > 0

   nValDesc := (1-(nValBase/nValLista)) * 100
   
   nlin++
   @ nLin, 000  PSay __PrtThinLine()                    
   nlin++                            
                          
   @nLin,05 pSay "TOTAL: "
 
   @nLin,067 pSay TRANSFORM(nValBase-nTotDevG, "@E 999,999.99")         
   @nLin,079 pSay TRANSFORM(nValLista, "@E 999,999.99")         
   @nLin,091 PSay Transform(nValDesc, "@E 999.99")
   @nLin,101 PSay Transform(nAcreG, "@E 999,999.99")   
   @nLin,146 pSay TRANSFORM(nValCom, "@E 999,999.99")      
   nlin++

   @ nLin, 000  PSay __PrtThinLine()                    
   nlin++                            
   
Endif      

XXX->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


//////////////////////////
Static Function MontaQry()
        
 Local cQuery := ""

 cQuery := " SELECT COUNT(*)SOMA "
 cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
 cQuery +=          RetSQLName("SB1")+" SB1, "
 cQuery +=          RetSQLName("SF2")+" SF2 "
 cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "  
 cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
 cQuery += " AND SF2.D_E_L_E_T_ <> '*' "
 cQuery += " AND F2_DOC = D2_DOC " 
 cQuery += " AND F2_SERIE = D2_SERIE "
 cQuery += " AND D2_COD = B1_COD "
 cQuery += " AND B1_X_COMIS IN(' ','S') "
 cQuery += " AND F2_VEND1 <> '000016' "  
 cQuery += " AND D2_PRCVEN <> 0    
 cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 cQuery += " AND D2_EMISSAO BETWEEN '"+dTos(mv_par03)+"' AND '"+dTos(mv_par04)+"' " 
 cQuery += " AND F2_EMISSAO BETWEEN '"+dTos(mv_par03)+"' AND '"+dTos(mv_par04)+"' " 
 cQuery += " AND D2_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
 cQuery += " AND F2_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "                 
 cQuery += " AND D2_SERIE BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "
 cQuery += " AND F2_SERIE BETWEEN '"+mv_par08+"' AND '"+mv_par09+"' "                 
 cQuery += " AND (F2_VEND1 BETWEEN '"+mv_par10+"' AND '"+mv_par11+"' "  
 cQuery += " OR F2_VEND2 BETWEEN '"+mv_par10+"' AND '"+mv_par11+"') "  
                   
 If mv_par07 == 1 //PEÇA                     
     cQuery += " AND D2_CF IN('5102','6102','5108','6108','5404','6404','5405','6405')"  
     //cQuery += " AND( D2_CF = '"+cCfPeca+"'  
     //cQuery += " OR D2_CF = '6102' OR D2_CF = '6108')"
 Elseif mv_par07 == 2 //SERVIÇO
     cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"' "
     cQuery += " OR D2_CF = '6102')"
 Elseif mv_par07 == 3  //LOCAÇÃO
     cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"' "
     cQuery += " OR D2_CF = '6102')" 
     cQuery += " OR D2_CF = '6933')" 
 Elseif mv_par07 == 4  // Todos
     //cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
     //cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
     //cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
     //cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933')" 
     cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
     cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
     cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
     cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933' OR D2_CF = '5404' OR D2_CF = '6404' OR D2_CF = '5405' OR D2_CF = '6405' OR D2_CF = '5119' OR D2_CF = '6119')"
 EndIf                
 
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
 nRegis := SOMA             
 dbCloseArea()

 cQuery := StrTran(cQuery,"COUNT(*)SOMA", "*")
 cQuery += " ORDER BY F2_VEND1,D2_DOC,D2_SERIE, D2_CF "
 
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
          		
Return	 

////////////////////////////////////////////
Static Function VerifSD1(cDoc,cSerDoc,cItem)
        
 Local cQuery := ""
 Local lRet   := .F.

 cQuery := " SELECT D1_TIPO, D1_NFORI, D1_SERIORI,D1_ITEMORI "
 cQuery += " FROM "+RetSQLName("SD1")+" SD1 "   

 cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "
 cQuery += " AND D1_NFORI = '"+cDoc+"' " 
 cQuery += " AND D1_SERIORI = '"+cSerDoc+"' " 
 cQuery += " AND D1_ITEMORI = '"+cItem+"' "
 cQuery += " AND D1_TES <> '232' "
 cQuery += " AND D1_XABCOMI <> 'N' "
                  
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
 lRet := YYY->(EOF())
 YYY->(dbCloseArea())

Return lRet                       

///////////////////////////////////////////////////////
Static Function QryVend(cNota, cSerie, cCliente, cLoja)
        
 Local cQuery    := ""
 Local cAuxSer   := ""
 Local cAuxDoc   := ""
 Local nPrcLista := 0.00
 Local aVendaCom := {}

 //cQuery := " SELECT * "
 //cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
 //cQuery +=          RetSQLName("SB1")+" SB1, " 
 //cQuery +=          RetSQLName("SF2")+" SF2 "
 //cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "  
 //cQuery += " AND SB1.D_E_L_E_T_ <> '*' " 
 //cQuery += " AND SF2.D_E_L_E_T_ <> '*' "      
 //cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 //cQuery += " AND F2_VEND1 <> '000016' "  
 //cQuery += " AND F2_DOC = D2_FILIAL " 
 //cQuery += " AND F2_DOC = D2_DOC " 
 //cQuery += " AND F2_SERIE = D2_SERIE "
 //cQuery += " AND D2_COD = B1_COD "
 //cQuery += " AND B1_X_COMIS IN(' ','S') "
 //cQuery += " AND D2_PRCVEN <> 0                      
 //cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 //cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
 //cQuery += " AND F2_DOC = '"+cNota+"' "                 
 //cQuery += " AND F2_SERIE = '"+cSerie+"' "
 //cQuery += " AND F2_CLIENTE = '"+cCliente+"' "
 //cQuery += " AND F2_LOJA = '"+cLoja+"' "
 
 //If mv_par07 == 1 //PEÇA    
 //    cQuery += " AND D2_CF IN('5102','6102','5108','6108')"  
 //Elseif mv_par07 == 2 //SERVIÇO
 //    cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"' "
 //    cQuery += " OR D2_CF = '6102')"
 //Elseif mv_par07 == 3  //LOCAÇÃO
 //    cQuery += " AND( D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"' "
 //    cQuery += " OR D2_CF = '6102' )"                                
 //    cQuery += " OR D2_CF = '6933' )"                                
 //Elseif mv_par07 == 4  // Todos
 //    cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
 //    cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
 //    cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
 //    cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933')"
 //EndIf                

 cQuery := " SELECT * "
 cQuery += " FROM "+RetSQLName("SD2")+" SD2 "
 cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "  
 cQuery += " AND D2_DOC = '"+cNota+"' "                 
 cQuery += " AND D2_SERIE = '"+cSerie+"' "
 cQuery += " AND D2_CLIENTE = '"+cCliente+"' "
 cQuery += " AND D2_LOJA = '"+cLoja+"' "
 
 dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
                                            
 AAdd(aVendaCom, {0, 0})

 While !TMP->(Eof())
   	If !VerifSD1(TMP->D2_DOC,TMP->D2_SERIE,TMP->D2_ITEM)
	   TMP->(dbSkip())  	   
	   Loop
	EndIf 
	nPrcLista:= TMP->D2_XPRCTAB //Posicione("SB0",1,xFilial("SB0")+TMP->D2_COD,"B0_PRV1")  //VALOR ATUAL
    nPrcLista:= If(nPrcLista > 0, nPrcLista, Posicione("SB0",1,xFilial("SB0")+TMP->D2_COD,"B0_PRV1"))  
    
    aVendaCom[1][1] += TMP->D2_TOTAL
    aVendaCom[1][2] += TMP->D2_QUANT * nPrcLista //TMP->D2_PRUNIT 
    TMP->(dbSkip()) 
 Enddo
 TMP->(dbCloseArea())
Return aVendaCom 
      
/////////////////////////
Static Function DevForaPrz
  Local cQry := ""
  Local nPos := 0
  cQry := "SELECT F2_VEND1,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_EMISSAO,D1_DTDIGIT,D2_TOTAL "
  cQry += "FROM "+RetSQLName("SF2")+" SF2 "
  cQry += "INNER JOIN "
  cQry += "("
  cQry += "  SELECT D1_DTDIGIT,D1_NFORI,D1_SERIORI,SUM(D2_TOTAL)D2_TOTAL "
  cQry += "  FROM "+RetSQLName("SD1")+" SD1 "
  cQry += "  INNER JOIN "+RetSQLName("SD2")+" SD2 ON D2_FILIAL = D1_FILIAL AND D2_DOC = D1_NFORI AND D2_SERIE = D1_SERIORI AND D2_ITEM = D1_ITEMORI "
  cQry += "  WHERE SD1.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' "
  cQry += "  AND SD1.D1_FILIAL = '"+xFilial("SD1")+"' "
  cQry += "  AND SD1.D1_TES <> '232' "
  cQry += "  AND SD1.D1_XABCOMI <> 'N' "
  cQry += "  AND SD1.D1_DTDIGIT BETWEEN '"+dTos(mv_par03)+"' AND '"+dTos(mv_par04)+"' "
  cQry += "  GROUP BY D1_DTDIGIT,D1_NFORI,D1_SERIORI "
  cQry += ")SD1D ON SF2.F2_DOC = SD1D.D1_NFORI AND SF2.F2_SERIE = SD1D.D1_SERIORI "
  cQry += "WHERE SF2.D_E_L_E_T_ <> '*' "    
  cQry += "AND SF2.F2_FILIAL = '"+xFilial("SF2")+"' "
  cQry += "AND SF2.F2_EMISSAO < '"+dTos(mv_par03)+"' "
  cQry += " AND (SF2.F2_VEND1 BETWEEN '"+mv_par10+"' AND '"+mv_par11+"' "  
  cQry += " OR SF2.F2_VEND2 BETWEEN '"+mv_par10+"' AND '"+mv_par11+"') "   
           
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "DEV", .T., .F. )   
  
  TcSetField("DEV", "F2_EMISSAO", "D", 8, 0)  // Formata para tipo Data
  TcSetField("DEV", "D1_DTDIGIT", "D", 8, 0)  // Formata para tipo Data

  DEV->(DbGotop())     
  
  Do While !DEV->(Eof())                                                                   
     nPos:= aScan(aDevoluc,{|x| x[1]+x[2]+x[3] = DEV->(F2_VEND1+F2_DOC+F2_SERIE) })
     If nPos = 0
        AAdd(aDevoluc,{DEV->F2_VEND1, DEV->F2_DOC, DEV->F2_SERIE, DEV->F2_CLIENTE, DEV->F2_EMISSAO, 0.00})
        nPos:= Len(aDevoluc)
     Endif                 
     aDevoluc[nPos][6] += DEV->D2_TOTAL
     DEV->(DbSkip())
  Enddo
  DEV->(DbCloseArea())
Return

////////////////////////////////
Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs :={}

DbSelectArea("SX1")
DbSetOrder(1)

aAdd(aRegs,{cPerg,"01","Da Filial      ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Filial   ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Da Data        ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate a Data     ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Da Nota        ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","", "","","","","","","","","","","","","","","","","","","","","","SF2",""})
aAdd(aRegs,{cPerg,"06","Ate a nota     ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","", "","","","","","","","","","","","","","","","","","","","","","SF2",""})
aAdd(aRegs,{cPerg,"07","Tipo do Item   ?","","","mv_ch7","N",01,0,0,"C","","mv_par07","Peça","","", "","","Serviço","","","","","Locação","","","","","Todos","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Da Serie       ?","","","mv_ch8","C",03,0,0,"G","","mv_par08","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Ate a Serie    ?","","","mv_ch9","C",03,0,0,"G","","mv_par09","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Do Vendedor    ?","","","mv_cha","C",06,0,0,"G","","mv_par10","","","", "","","","","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cPerg,"11","Ate o Vendedor ?","","","mv_chb","C",06,0,0,"G","","mv_par11","","","", "","","","","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cPerg,"12","Tipo de vendas ?","","","mv_ch7","N",01,0,0,"C","","mv_par12","Com desconto","","", "","","Sem desconto","","","","","Todos","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
Return     