#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
 /*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦¦
¦¦¦ Programa  ¦  GERACOM   ¦ Autor ¦ Reinaldo Magalhaes   ¦ Data ¦ 10/12/07   ¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦¦
¦¦¦ Descriçäo ¦ Grava o SE3 com as vendas realizadas e seu % Comissao         ¦¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function GERACOM()
   Local cQuery, cCampo, nRegis, cDTINI, cDTFIM
   Local cPerg   := "GER0"+SM0->M0_CODFIL
   Local cAlias  := Alias()
   Local aSay    := {}
   Local aButton := {}
   Local nOpc    := 0
   Local cTitulo := "Geracao da Comissao"
   Local cDesc1  := "Essa rotina ira a gerar a comissao do vendedor"
   Local cDesc2  := "de acordo com parametro de datas definido pelo usuario."

   Private cFilSA3 := xFilial("SA3")
   Private cFilSA6 := xFilial("SA6")
   Private cFilSB1 := XFILIAL("SB1")
   Private cFilSC6 := XFILIAL("SC6")
   Private cFilSD1 := xFilial("SD1")
   Private cFilSD2 := xFilial("SD2")
   Private cFilSE3 := xFilial("SE3")
   Private cFilSF2 := xFilial("SF2")
   Private cFilSL1 := XFILIAL("SL1")
   Private cFilSL2 := XFILIAL("SL2")

   CriaSx1(cPerg)
   
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

   cDTINI := DTOS(MV_PAR01)
   cDTFIM := DTOS(MV_PAR02)

   //- Gera a comissao da rotina de venda assistida
   cCampo := "L2_VEND, L1_DOC, L1_EMISNF, L1_SERIE, L1_CLIENTE, L1_LOJA, L2_DESCRI, L1_OPERADO, "+;
             "L1_VALMERC, L1_CREDITO, L1_SERIE, L2_ITEM, L2_PRODUTO "
   
   cQuery := "SELECT COUNT(*)SOMA FROM "+RetSQLName("SL1")+" A, "+RetSQLName("SL2")+" B WHERE A.D_E_L_E_T_=' ' "
   cQuery += "AND B.D_E_L_E_T_=' ' AND L1_FILIAL=L2_FILIAL AND L1_NUM=L2_NUM AND L1_EMISNF >= '"+cDTINI+"' AND "
   cQuery += "L1_EMISNF <= '"+cDTFIM+"' AND L1_CLIENTE <> '002727' AND L2_VENDIDO = 'S' AND "
   cQuery += "L1_FILIAL = '"+XFILIAL("SL1")+"' AND NOT(L1_VEND IN ('000001','000010','      ')) AND "
   cQuery += "L2_TES IN ('501','502','505')"  // Considera apenas TES de venda

   MsgRun("     Filtrando Vendas       ","Aguarde...",{|| nRegis := CriaTemp(cQuery,cCampo,"L1_EMISNF","L1_DOC, L1_SERIE, L2_ITEM") })
   
   Processa( {|| ProcCom1(nRegis,"V ") } , "Gerando Comissao")  // Processa as vendas

   /** --------------------------------------------------------------------------------------------- **/

   // Gera o desconto da comissao sobre as devolucoes
   cCampo := StrTran(cCampo,"L1_EMISNF", "D1_DTDIGIT")
   cCampo += ", D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_ITEM, (D1_TOTAL-D1_VALDESC)D1_TOTAL "
   
   cQuery := "SELECT COUNT(*)SOMA FROM "+RetSQLName("SD1")+" A, "+RetSQLName("SL1")+" B, "+RetSQLName("SL2")+" C "
   cQuery += "WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_=' ' AND C.D_E_L_E_T_=' ' AND D1_FILIAL=L1_FILIAL AND "
   cQuery += "D1_NFORI=L1_DOC AND D1_SERIORI=L1_SERIE AND SUBSTRING(D1_ITEMORI,1,2)=L2_ITEM AND D1_TIPO='D' AND "
   cQuery += "L1_FILIAL=L2_FILIAL AND L1_NUM=L2_NUM AND D1_DTDIGIT >= '"+cDTINI+"' AND "
   cQuery += "D1_DTDIGIT <= '"+cDTFIM+"' AND L1_CLIENTE <> '002727' AND L2_VENDIDO = 'S' AND "
   cQuery += "D1_FILIAL = '"+XFILIAL("SD1")+"' AND NOT(L1_VEND IN ('000001','000010','      '))"

   MsgRun("     Filtrando Devolucoes   ","Aguarde...", {|| nRegis := CriaTemp(cQuery,cCampo,"D1_DTDIGIT","L1_DOC, L1_SERIE, L2_ITEM") })
   
   Processa( {|| ProcCom1(nRegis,"D ") } , "Gerando Comissao")  //- Processa as devolucoes

   //- Gera a comissao das vendas do faturamento
   cCampo := "F2_VEND1, F2_VEND2, F2_DOC, F2_EMISSAO, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_VALBRUT, D2_ITEM, D2_COD, D2_PEDIDO"
   
   cQuery := "SELECT COUNT(*)SOMA FROM "+RetSQLName("SF2")+" A, "+RetSQLName("SD2")+" B WHERE A.D_E_L_E_T_=' ' "
   cQuery += "AND B.D_E_L_E_T_=' ' AND F2_FILIAL=D2_FILIAL AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE AND "
   cQuery += "F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA AND "
   cQuery += "F2_EMISSAO >= '"+cDTINI+"' AND F2_EMISSAO <= '"+cDTFIM+"' AND F2_FILIAL = '"+XFILIAL("SF2")+"' AND "
   cQuery += "F2_CLIENTE <> '002727' AND F2_VEND1 NOT IN ('000001','0000010','      ') AND D2_ORIGLAN<>'LO' AND "
   cQuery += "D2_TES IN ('501','502','505')"  // Considera apenas TES de venda

   MsgRun("     Filtrando Vendas       ","Aguarde...", {|| nRegis := CriaTemp(cQuery,cCampo,"F2_EMISSAO","F2_DOC, F2_SERIE, D2_ITEM") })
   
   Processa( {|| ProcCom2(nRegis,"V ") } , "Gerando Comissao")  //- Processa as vendas

   /** --------------------------------------------------------------------------------------------- **/

   // Gera o desconto da comissao sobre as devolucoes
   cCampo := StrTran(cCampo,"F2_EMISSAO", "D1_DTDIGIT")
   cCampo += ", D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_ITEM, (D1_TOTAL-D1_VALDESC)D1_TOTAL"
   
   cQuery := "SELECT COUNT(*)SOMA FROM "+RetSQLName("SD1")+" A, "+RetSQLName("SF2")+" B, "+RetSQLName("SD2")+" C "
   cQuery += "WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_=' ' AND C.D_E_L_E_T_=' ' AND D1_FILIAL=F2_FILIAL AND "
   cQuery += "D1_NFORI=F2_DOC AND D1_SERIORI=F2_SERIE AND SUBSTRING(D1_ITEMORI,1,2)=D2_ITEM AND D1_TIPO='D' AND "
   cQuery += "F2_FILIAL=D2_FILIAL AND F2_DOC=F2_DOC AND F2_SERIE=D2_SERIE AND F2_CLIENTE=D2_CLIENTE AND "
   cQuery += "F2_LOJA=D2_LOJA AND D1_DTDIGIT >= '"+cDTINI+"' AND "
   cQuery += "D1_DTDIGIT <= '"+cDTFIM+"' AND F2_CLIENTE <> '002727' AND D2_ORIGLAN<>'LO' AND "
   cQuery += "D1_FILIAL = '"+XFILIAL("SD1")+"' AND NOT(F2_VEND1 IN ('000001','000010','      '))"

   MsgRun("     Filtrando Devolucoes   ","Aguarde...", {|| nRegis := CriaTemp(cQuery,cCampo,"D1_DTDIGIT","F2_DOC, F2_SERIE, D2_ITEM") })
   
   Processa( {|| ProcCom2(nRegis,"D ") } , "Gerando Comissao")  // Processa as devolucoes

   dbSelectArea(cAlias)
   
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ProcCom1   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 04/05/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa as vendas e devolucoes para calculo da comissao-LOJ  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ProcCom1(nRegis,cVD)
   Local cItem, cNumDoc, cSerie, vDados, vDevTrc
   Local cParc := Space(Len(SE3->E3_PARCELA))

   dbSelectArea("COM")
   COM->(dbGoTop())
   ProcRegua(nRegis)
   While !COM->(Eof())

      IncProc("Processando "+If( cVD == "V " , "Vendas...", "Devolucoes..."))
      
      // Posiciona no Cadastro do Vendedor
      //SA3->(dbSetOrder(1))
      U_MsSetOrder("SA3","A3_FILIAL+A3_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
      SA3->(dbSeek(cFilSA3+COM->L2_VEND))

      // Posiciona no Cadastro de Bancos (Caixas)
      //SA6->(dbSetOrder(1))
      U_MsSetOrder("SA6","A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
      SA6->(dbSeek(cFilSA6+COM->L1_OPERADO))

      // Posiciona nos Itens da Nota Fiscal de Saida
      //SD2->(dbSetOrder(3))
      U_MsSetOrder("SD2","D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
      SD2->(dbSeek(cFilSD2+COM->(L1_DOC+L1_SERIE+L1_CLIENTE+L1_LOJA+L2_PRODUTO+L2_ITEM)))

      // Verifica se eh troca ou devolucao
      If cVD == "D "
         // Posiciona no Cabeçalho da Nota Fiscal de Entrada
         //SF1->(dbSetOrder(1))
         U_MsSetOrder("SF1","F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
         SF1->(dbSeek(cFilSD2+COM->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))

         vDevTrc := PesqDevTrc()
         
         // Se for TROCA e diferenca for pra maior, ignora pois ja processou na venda
         If vDevTrc[1] == "T" .And. vDevTrc[4] >= 0
            dbSkip()
            Loop
         Endif
      Else
         vDevTrc := { "V" , L2_VEND, "", SD2->D2_TOTAL}
         // Acerta valor conforme L1_VLRLIQ ou Zerado caso o L1_CREDITO tenha o mesmo valor
         vDevTrc[4] := Round((SD2->D2_TOTAL / L1_VALMERC) * (L1_VALMERC-L1_CREDITO),2)
      Endif

      // Define a gravacao dos dados da nota, ou devolucao, ou saida
      If cVD == "D " .Or. vDevTrc[4] < 0
         vDados := COM->({ D1_FORNECE, D1_LOJA, D1_SERIE, D1_DOC, SubStr(D1_ITEM,1,2)})
      Else
         vDados := COM->({ L1_CLIENTE, L1_LOJA, L1_SERIE, L1_DOC, L2_ITEM})
      Endif

      // Calcula e grava a comissao
      Begin Transaction
         //dbSelectArea("SE3")
         //dbSetOrder(3) //- E3_FILIAL+E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM
         U_MsSetOrder("SE3","E3_FILIAL+E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM+E3_PARCELA+E3_TIPO+E3_SEQ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
         If SE3->(dbSeek(cFilSE3+vDevTrc[2]+vDados[1]+vDados[2]+vDados[3]+vDados[4]))
            RecLock("SE3",.F.)
         Else
            RecLock("SE3",.T.)
            SE3->E3_FILIAL  := cFilSE3
            SE3->E3_VEND    := vDevTrc[2]
            SE3->E3_CODCLI  := vDados[1]
            SE3->E3_LOJA    := vDados[2]
            SE3->E3_SERIE   := vDados[3]
            SE3->E3_PREFIXO := vDados[3]
            SE3->E3_NUM     := vDados[4]
            SE3->E3_PARCELA := cVD
            SE3->E3_TIPO    := "NF"
            SE3->E3_EMISSAO := If( cVD == "V " , COM->L1_EMISNF, COM->D1_DTDIGIT)  // Se for V(Venda) ou D(Devolucao)
            SE3->E3_DATA    := dDataBase
            SE3->E3_AJUSTE  := vDevTrc[1]
            SE3->E3_ORIGEM  := "L"   
            SE3->E3_PORC    := SA3->A3_COMIS
         Endif
         SE3->E3_BASE  += vDevTrc[4]
         SE3->E3_COMIS += Round(vDevTrc[4] * E3_PORC    / 100 ,2)
         
         // Se na troca nao houve diferenca, zera o percentual da comissao
         If vDevTrc[4] == 0
           SE3->E3_PORC := 0
         Endif
         SE3->(MsUnLock())
      End Transaction
      dbSelectArea("COM")
      COM->(dbSkip())
   Enddo
   COM->(dbCloseArea())
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ ProcCom2   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 10/07/2006 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Processa as vendas e devolucoes para calculo da comissao - FAT¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function ProcCom2(nRegis,cVD)
   Local cItem, cNumDoc, cSerie, vDados, vDevTrc
   Local cParc := Space(Len(SE3->E3_PARCELA))

   dbSelectArea("COM")
   COM->(dbGoTop())
   ProcRegua(nRegis)
   While !COM->(Eof())

      IncProc("Processando "+If( cVD == "V " , "Vendas...", "Devolucoes..."))

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Comissao para vendedor-1  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
      //SA3->(dbSetOrder(1))
	  U_MsSetOrder("SA3","A3_FILIAL+A3_COD")      
      SA3->(dbSeek(cFilSA3+COM->F2_VEND1))

      // Posiciona nos Itens da Nota Fiscal de Saida
      //SB1->(dbSetOrder(1))
      U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
      SB1->(dbSeek(cFilSB1+COM->D2_COD))

      // Posiciona nos Itens da Nota Fiscal de Saida
      //SD2->(dbSetOrder(3))
      U_MsSetOrder("SD2","D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
      SD2->(dbSeek(cFilSD2+COM->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+D2_COD+D2_ITEM)))

      // Posiciona nos Itens do Pedido de Venda
      //SC6->(dbSetOrder(1))
      U_MsSetOrder("SC6","C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
      SC6->(dbSeek(cFilSC6+COM->(D2_PEDIDO+D2_ITEM+D2_COD)))

      vDevTrc := { cVD , F2_VEND1, Space(06), If( cVD == "V " , SD2->D2_TOTAL, D1_TOTAL)}

      // Define a gravacao dos dados da nota, ou devolucao, ou saida
      If cVD == "D " .Or. vDevTrc[4] < 0
         vDados := COM->({ D1_FORNECE, D1_LOJA, D1_SERIE, D1_DOC, SubStr(D1_ITEM,1,2)})
      Else
         vDados := COM->({ F2_CLIENTE, F2_LOJA, F2_SERIE, F2_DOC, D2_ITEM})
      Endif

      // Calcula e grava a comissao
      Begin Transaction
         //dbSelectArea("SE3")
         //dbSetOrder(3) //- E3_FILIAL+E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM 
         U_MsSetOrder("SE3","E3_FILIAL+E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM+E3_PARCELA+E3_TIPO+E3_SEQ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
         If SE3->(dbSeek(cFilSE3+vDevTrc[2]+vDados[1]+vDados[2]+vDados[3]+vDados[4]))
            RecLock("SE3",.F.)
         Else
            RecLock("SE3",.T.)
            SE3->E3_FILIAL  := cFilSE3
            SE3->E3_VEND    := vDevTrc[2]
            SE3->E3_CODCLI  := vDados[1]
            SE3->E3_LOJA    := vDados[2]
            SE3->E3_SERIE   := vDados[3]
            SE3->E3_PREFIXO := vDados[3]
            SE3->E3_NUM     := vDados[4]
            SE3->E3_PARCELA := cVD
            SE3->E3_TIPO    := "NF"
            SE3->E3_EMISSAO := If( cVD == "V " , COM->F2_EMISSAO, COM->D1_DTDIGIT)  // Se for V(Venda) ou D(Devolucao)
            SE3->E3_DATA    := dDataBase
            SE3->E3_AJUSTE  := vDevTrc[1]
            SE3->E3_ORIGEM  := "L"
            SE3->E3_PORC    := SA3->A3_COMIS
         Endif
         SE3->E3_BASE  += vDevTrc[4]
         SE3->E3_COMIS += Round(vDevTrc[4] * E3_PORC / 100 ,2)
         COM->(MsUnLock())
      End Transaction 

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Comissao para vendedor-2  ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
      If !Empty(COM->F2_VEND2)
         dbSelectArea("COM")
         COM->(dbSkip())
      Endif

      //SA3->(dbSetOrder(1))
      U_MsSetOrder("SA3","A3_FILIAL+A3_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
      SA3->(dbSeek(cFilSA3+COM->F2_VEND2))

      // Posiciona nos Itens da Nota Fiscal de Saida
      //SB1->(dbSetOrder(1))
      U_MsSetOrder("SB1","B1_FILIAL+B1_COD")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
      SB1->(dbSeek(cFilSB1+COM->D2_COD))

      // Posiciona nos Itens da Nota Fiscal de Saida
      //SD2->(dbSetOrder(3))
      U_MsSetOrder("SD2","D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima       
      SD2->(dbSeek(cFilSD2+COM->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+D2_COD+D2_ITEM)))

      // Posiciona nos Itens do Pedido de Venda
      //SC6->(dbSetOrder(1))
	  U_MsSetOrder("SC6","C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima             
      SC6->(dbSeek(cFilSC6+COM->(D2_PEDIDO+D2_ITEM+D2_COD)))

      vDevTrc := { cVD , COM->F2_VEND2, Space(06), If( cVD == "V " , SD2->D2_TOTAL, D1_TOTAL)}

      // Define a gravacao dos dados da nota, ou devolucao, ou saida
      If cVD == "D " .Or. vDevTrc[4] < 0
         vDados := COM->({ D1_FORNECE, D1_LOJA, D1_SERIE, D1_DOC, SubStr(D1_ITEM,1,2)})
      Else
         vDados := COM->({ F2_CLIENTE, F2_LOJA, F2_SERIE, F2_DOC, D2_ITEM})
      Endif

      // Calcula e grava a comissao
      Begin Transaction
         //dbSelectArea("SE3")
         //dbSetOrder(3) //- E3_FILIAL+E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM 
         U_MsSetOrder("SE3","E3_FILIAL+E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM+E3_PARCELA+E3_TIPO+E3_SEQ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                
         If SE3->(dbSeek(cFilSE3+vDevTrc[2]+vDados[1]+vDados[2]+vDados[3]+vDados[4]))
            RecLock("SE3",.F.)
         Else
            RecLock("SE3",.T.)
            SE3->E3_FILIAL  := cFilSE3
            SE3->E3_VEND    := vDevTrc[2]
            SE3->E3_CODCLI  := vDados[1]
            SE3->E3_LOJA    := vDados[2]
            SE3->E3_SERIE   := vDados[3]
            SE3->E3_PREFIXO := vDados[3]
            SE3->E3_NUM     := vDados[4]
            SE3->E3_PARCELA := cVD
            SE3->E3_TIPO    := "NF"
            SE3->E3_EMISSAO := If( cVD == "V " , COM->F2_EMISSAO, COM->D1_DTDIGIT)  // Se for V(Venda) ou D(Devolucao)
            SE3->E3_DATA    := dDataBase
            SE3->E3_AJUSTE  := vDevTrc[1]
            SE3->E3_ORIGEM  := "L"
            SE3->E3_PORC    := SA3->A3_COMIS2
         Endif
         SE3->E3_BASE  += vDevTrc[4]
         SE3->E3_COMIS += Round(vDevTrc[4] * E3_PORC    / 100 ,2)
         SE3->(MsUnLock())
      End Transaction 
      dbSelectArea("COM")
      COM->(dbSkip())
   Enddo
   COM->(dbCloseArea())
Return

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PesqDevTrc ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 12/05/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Pesquisa troca ou devolucao para a venda                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PesqDevTrc()
   Local nReg
   Local cAlias  := Alias()
   Local cBusca  := XFILIAL("SE5")+D1_SERIE+D1_DOC+"A"+"NCC"+D1_FORNECE+D1_LOJA  
   Local cBusca2 := XFILIAL("SE5")+D1_SERIE+D1_DOC+" "+"NCC"+D1_FORNECE+D1_LOJA  

   Local vRet    := { "D" , L2_VEND, "", D1_TOTAL}

   //dbSelectArea("SE5")
   //dbSetOrder(7)
   U_MsSetOrder("SE5","E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
   If !SE5->(dbSeek(cBusca,.T.))
      cBusca:= cBusca2   
      SE5->(dbSeek(cBusca,.T.))
   Endif   
   
   While !SE5->(Eof()) .And. cBusca == SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)

      nReg := SE5->(Recno())
      If !Empty(SE5->E5_DOCUMEN) .And. SE5->(dbSeek(SE5->E5_FILIAL+SubStr(SE5->E5_DOCUMEN,1,13))) //+E5_CLIFOR+E5_LOJA)
         //dbSelectArea("SL1")
         //dbSetOrder(2)
         U_MsSetOrder("SL1","L1_FILIAL+L1_SERIE+L1_DOC+L1_PDV")//Incluído por Ulisses Jr em 24/04/08 em substituição a linha acima                   
         If SL1->(dbSeek(cFilSL1+SE5->E5_PREFIXO+SE5->E5_NUMERO))
            vRet := { "T", vRet[2], "", vRet[4] - (SL1->L1_VALBRUT*(vRet[4]/SF1->F1_VALBRUT))}
            Exit
         Endif
         dbSelectArea("SE5")
      Endif
      SE5->(dbGoTo(nReg))
      SE5->(dbSkip())
   Enddo
   dbSelectArea(cAlias)
Return(vRet)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaTemp   ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 13/05/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria arquivo temporario referente as vendas ou as trocas      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaTemp(cQuery,cCampo,cData,cOrder)
   Local nRegis

   // Calcula o total de registros
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "COM", .T., .F. )
   nRegis := COM->SOMA
   COM->(dbCloseArea())

   cQuery := StrTran(cQuery,"COUNT(*)SOMA", cCampo)
   cQuery += If( ValType(cOrder) == "C" , " ORDER BY "+cOrder,"")
   dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "COM", .T., .F. )

   TcSetField("COM" , cData, "D", 8, 0)  // Formata para tipo Data
Return(nRegis)

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ CriaSX1    ¦ Autor ¦ Williams Messa       ¦ Data ¦ 24/03/2004 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Cria parametros de perguntas da rotina                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function CriaSx1(cPerg)

   PutSX1(cPerg,"01","Data "    ,"","","mv_ch1","D",8,0,0,"G","","","","","mv_par01")
   PutSX1(cPerg,"02","Ate Data ","","","mv_ch2","D",8,0,0,"G","","","","","mv_par02")

Return Nil