#include "totvs.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � AGLOJP03 � Autor � Reinaldo Magalh�es    � Data � 03/04/17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta de comiss�o de vendedores                         ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Agropisco                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AGLOJP03(lCallMe)
  Local cQuery, cCampo, nRegis, cDTINI, cDTFIM
  Local cPerg:= PADR("AGLOJA03",Len(SX1->X1_GRUPO))
                                    
  Local nOpc    := 0 
  Local cAlias  := Alias()
  Local aSay    := {}
  Local aButton := {}
  Local cTitulo := "Consulta de comiss�o de vendedores"
  Local cDesc1  := "Essa rotina ira consultar todas as vendas do vendedor em um "
  Local cDesc2  := "determinado periodo.                                        "

  lCallMe:= If( lCallMe == Nil, .F., lCallMe)  // Verifica se foi chamado pelo menu ou traves de alguma rotina

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
    
  MsAguarde({|lFim| GeraCom(@lFim,lCallMe)},"Processamento","Aguarde...Calculando comissao...")

  dbSelectArea(cAlias)
   
Return

//////////////////////////////////////
Static Function GeraCom(lFim,lCallMe)
  Local aVendaCom := {}
  Local aFolha    := {}                                           
  Local nOpc      := 0

  Local nVgPeca   := 0.00 //- Pe�as
  Local nVgEquipa := 0.00 //- Equipamento
  Local nVgServic := 0.00 //- Servi�o
  Local nVgLocaca := 0.00 //- Loca��o
  Local nVgTotal  := 0.00 //- Total
  Local nCgPeca   := 0.00 //- Comiss�o Pe�as
  Local nCgEquipa := 0.00 //- Comiss�o Equipamento 
  Local nCgServic := 0.00 //- Comiss�o Servi�o 
  Local nCgLocaca := 0.00 //- Comiss�o Loca��o
  Local nCgExtra  := 0.00 //- Valores extra
  Local nCgPagar  := 0.00 //- Valor de comiss�o a pagar 
  Local nValFat   := 0.00 //- Faturamento mensal de pe�as e 

  Local aPeca  :={} //- Array com as pecas vendidas
  Local aEquip :={} //- Array com os equipamentos vendidos
  Local aServ  :={} //- Array com os servicos
  Local aLoca  :={} //- Array com as locacoes
  Local aNCla  :={} //- Array com os produtos nao classificados

  Private nRegis   := 0
  Private cAuxDoc  := ""
  Private cAuxSer  := ""
  Private cAuxTES  := ""
  Private cAuxVend := ""
  Private nType    := 0
  
  Private nLin     := 180 

  Private cCfPeca  := getmv("MV_CFPECA")
  Private cCfServ  := getmv("MV_CFSERV")
  Private cTesLoca := getmv("MV_TESLOCA")
  Private lImp 	   := .F.

  Private nMETPC   := getmv("MV_XMETPC")  //- Meta de pe�as -> R$ 50.000
  Private nMETEQ   := getmv("MV_XMETEQ")  //- Meta de equipamentos -> R$ 100.000
  Private nMINPC   := getmv("MV_XMINPC")  //- Percentual de comiss�o de pe�as < meta -> 2%
  Private nMAXPC   := getmv("MV_XMAXPC")  //- Percentual de comiss�o de pe�as > meta -> 2,5%
  Private nMINEQ   := getmv("MV_XMINEQ")  //- Percentual de comiss�o equipamentos > meta -> 0,5%
  Private nMAXEQ   := getmv("MV_XMAXEQ")  //- Percentual de comiss�o equipamentos < meta -> 1%
  Private nCOMSER  := getmv("MV_XCOMSER") //- Percentual de comiss�o sobre servi�os -> 0,5%
  Private nCOMLOC  := getmv("MV_XCOMLOC") //- Percentual de comiss�o sobre loca��o -> 3% 
  Private nCOMEXT  := getmv("MV_XCOMEXT") //- Percentual de comiss�o extra sobre pe�as + equipamentos -> 0,1%
  
  Private cComGer := getmv("MV_XCOMGER") //- Vendedores que geram comiss�o para o gerente da loja.  
                     
  Private nValBase := 0
  Private nValCom  := 0
  Private nValLista:= 0 
  Private nValDesc := 0 

  Private nBase    := 0

  Private nDesc  := 0
  Private nAcreT := 0
  Private nAcreP := 0
  Private nAcreV := 0

  DEFINE FONT oFont NAME "Arial" SIZE 5,15
  DEFINE FONT oFnt3 NAME "Ms Sans Serif" Bold

  //�����������������������������������Ŀ
  //� Carregando matriz de vendedores  �
  //������������������������������������
  SA3->(DbGotop())
  Do While !SA3->(Eof())
     If SA3->A3_MSBLQL <> "1"               
        //1=VEND*2=NOME*3=FAT.PECAS*4=FAT.EQUIP*5=FAT.SERVICOS*6=FAT.LOCACAO*7=TOTAL FATURADO*8=COMISSAO PECAS*9=(%)*10=COMISSAO EQUIPAMENTO*11=(%)*12=COMISSAO SERVICO*13=(%)*14=COMISSAO LOCACAO*15=(%)*16=VALOR EXTRA*17=COMISSAO EXTRA*18=SEGMENTO
        AADD(aFolha, {SA3->A3_COD,SA3->A3_NREDUZ, 0.00, 0.00, 0.00,	0.00, 0.00,	0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, SA3->A3_XSEGMEN })
     Endif
     SA3->(DbSkip())
  Enddo   

  AAdd(aVendaCom, {0, 0, 0, 0, 0})
 
  MontaQry() //- Monta query com as vendas no periodo informado
  
  //��������������������������������������������Ŀ
  //� Carregando array com o detalhe das vendas �
  //���������������������������������������������
  aPeca  := CarregaArray("P")
  aEquip := CarregaArray("E")
  aServ  := CarregaArray("S")

  aNCla  := CarregaArray(" ")

  DbSelectArea("TRB")
  dbGoTop()

  Do While !TRB->(EOF())
     If cAuxDoc <> TRB->D2_DOC .Or. cAuxSer <> TRB->D2_SERIE

        SA3->(DbSeek(xFilial("SA3")+TRB->F2_VEND1))
        
        aVendaCom := QryVend(TRB->F2_DOC,TRB->F2_SERIE,TRB->F2_CLIENTE,TRB->F2_LOJA,SA3->A3_XSEGMEN)  
        
        //�������������������������������������������������������������������Ŀ
        //� Regra para c�lculo de percentual de comiss�o baseado em acrescimo �
        //���������������������������������������������������������������������
        If !Empty(TRB->F2_VEND1)
	       nPos:= aScan(aFolha,{|x| x[1] = TRB->F2_VEND1 })
	       If nPos > 0 
	          aFolha[nPos][3] += aVendaCom[1][1] //- Pe�as
	          aFolha[nPos][4] += aVendaCom[1][2] //- Equipamentos
	          aFolha[nPos][5] += aVendaCom[1][3] //- Servi�os
	          aFolha[nPos][6] += aVendaCom[1][4] //- Loca��o                
	          aFolha[nPos][7] += aVendaCom[1][5] //- Total                
	       Endif   
        Endif
     Endif        
     cAuxDoc  := TRB->D2_DOC
     cAuxTES  := TRB->D2_CF
     cAuxSer  := TRB->D2_SERIE                                       
     cAuxVend := TRB->F2_VEND1 
     TRB->(dbSkip()) // Avanca o ponteiro do registro no arquivo
  Enddo
  TRB->(dbCloseArea())
        
  nValFat:= 0
  
  aEval( aFolha, {|x| nValFat += IIF(x[1]$cComGer, x[3]+x[4]+x[5], 0) }) //Vendedores que geram comiss�o para o Diego
  
  For i:= 1 to Len(aFolha)     
     //���������������������������Ŀ
     //� Comiss�o sobre servi�os   �
     //�����������������������������
     If aFolha[i][18] == "S" //- Tipo do vendedor E=Equipamento*P=pe�as*L=Loca��o*S=Servi�o
        aFolha[i][13]:= nCOMSER
        aFolha[i][12]:= (aFolha[i][3]+aFolha[i][5]) * (nCOMSER/100) //- C�lculo de comiss�o sobre [Total = Pe�as + Servi�os]
     Else                   
        //����������������������������������������������������������������������Ŀ
        //� Comiss�o sobre servi�os para vendedores de P=pe�as e E=equipamentos  �
        //�����������������������������������������������������������������������
        If aFolha[i][5] > 0 .And. aFolha[i][18]$"PE"
           If aFolha[i][1] == "000056" //- Diego Barroso
              aFolha[i][13]:= 1.00
              aFolha[i][12]:= aFolha[i][5] * (1/100) //- C�lculo de comiss�o sobre servi�os
           Else
              aFolha[i][13]:= nCOMSER
              aFolha[i][12]:= aFolha[i][5] * (nCOMSER/100) //- C�lculo de comiss�o sobre servi�os
           Endif   
        Endif   
        //���������������������������Ŀ
        //� Comiss�o sobre Pe�as     �
        //�����������������������������
        If aFolha[i][18] == "P" //- Vendedor de pe�as
           If aFolha[i][3] > nMETPC //- Meta de pe�as -> 50k 
              aFolha[i][9]:= nMAXPC //- Percentual de comiss�o sobre vendas de pe�as > 50K -> 2,5%
           Else                
              aFolha[i][9]:= nMINPC //- Percentual de comiss�o sobre vendas de pe�as < 50k -> 2% 
           Endif 
        Else 
           If aFolha[i][1] == "000056" //- Diego Barroso
              aFolha[i][9]:= 1.00
           Else   
              aFolha[i][9]:= 0.5
           Endif   
        Endif   
        aFolha[i][8]:= aFolha[i][3] * (aFolha[i][9]/100) //- C�lculo de comiss�o sobre vendas
        
        //�����������������������������������������Ŀ
        //� Comiss�o sobre vendas de equipamentos  �
        //�������������������������������������������
        If aFolha[i][18] == "E" //- Vendedor de equipamento
           If aFolha[i][4] > nMETEQ
              aFolha[i][11]:= nMAXEQ //- Percentual de comiss�o sobre vendas de equipamentos > 100k    
           Else
              If aFolha[i][1] == "000056" //- Diego Barroso
                 aFolha[i][11]:= 1.00
              Else   
                 aFolha[i][11]:= nMINEQ //- Percentual de comiss�o sobre vendas de equipamentos < 100k
              Endif   
           Endif
        Else 
           aFolha[i][11]:= 0.5
        Endif   
        aFolha[i][10]:= aFolha[i][4] * (aFolha[i][11]/100) //- C�lculo de comiss�o sobre vendas        
        //���������������������������Ŀ
        //� Comiss�o sobre locacao   �
        //����������������������������
        If aFolha[i][6] > 0 //- Loca��o  
           aFolha[i][15]:= nCOMLOC
           aFolha[i][14]:= aFolha[i][6] * (nCOMLOC/100) //- C�lculo de comiss�o sobre vendas          
           //- Tratamento diferenciado na comiss�o do Diego referente a loca��o
           //If aFolha[i][1] $ "000056#002045"
           //   aFolha[i][15]:= 1
           //   aFolha[i][14]:= aFolha[i][6] * 0.01 //- C�lculo de comiss�o sobre vendas          
           //Endif
        Endif                           
     Endif

     //����������������������������������������������������Ŀ
     //� Verificando se o vendedor recebe comiss�o extra   �
     //������������������������������������������������������
     SA3->(DbSeek(xFilial("SA3")+aFolha[i][1]))     

     If SA3->A3_XCOMEXT="1"  // Caso o vendedor receba comiss�o extra.
        aFolha[i][16] += nValFat * (nCOMEXT/100)
     Endif 
     aFolha[i][17] += aFolha[i][8]+aFolha[i][10]+aFolha[i][12]+aFolha[i][14]+aFolha[i][16] //- Total de comiss�o  
  Next  

  //����������������������������������������Ŀ
  //� Montando tela para exibi��o dis dados �
  //������������������������������������������
  DEFINE DIALOG oDlg TITLE "Vendas por vendedor" FROM 180,180 TO 550,1100 PIXEL
  
  oBrowse := TCBrowse():New( 01 , 01, 455, 156,,{"Codigo","Nome","Pe�as","Equipamento","Servi�o","Locacao","Total"}, {30,100,50,50,50,50,50},oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
 
  // Seta vetor para a browse                            
  oBrowse:SetArray(aFolha) 
 
  // Monta a linha a ser exibida no Browse
  oBrowse:bLine := {||{aFolha[oBrowse:nAt,01],;
                       aFolha[oBrowse:nAt,02],;
                       Transform(aFolha[oBrowse:nAt,03],"@E 999,999.99"),;
                       Transform(aFolha[oBrowse:nAt,04],"@E 999,999.99"),;
                       Transform(aFolha[oBrowse:nAt,05],"@E 999,999.99"),;
                       Transform(aFolha[oBrowse:nAt,06],"@E 999,999.99"),;
                       Transform(aFolha[oBrowse:nAt,07],"@E 999,999.99") }}    
 
  // Evento de duplo click na celula
  oBrowse:bLDblClick := {|| U_TFolder(oBrowse:nAt,aPeca,aEquip,aServ,aLoca,aNCla),oBrowse:Refresh() }
 
  TButton():New( 172, 052, "Sair", oDlg,{|| oDlg:End(), nlin := oBrowse:nAt, nOpc := 0   },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
 
  ACTIVATE DIALOG oDlg CENTERED 
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
  cQuery += " AND F2_VEND1 = '"+mv_par03+"'"
  cQuery += " AND D2_PRCVEN <> 0    
  cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"'"
  cQuery += " AND F2_FILIAL = '"+xFilial("SF2")+"'"
  cQuery += " AND D2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "  
  cQuery += " AND F2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "  
  cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
  cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
  cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
  cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933' OR D2_CF = '5404' OR D2_CF = '6404' OR D2_CF = '5405' OR D2_CF = '6405')"
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TRB", .T., .F. )
  nRegis := SOMA             
  dbCloseArea()

  cQuery := StrTran(cQuery,"COUNT(*)SOMA", "*")
  cQuery += " ORDER BY F2_VEND1,D2_DOC,D2_SERIE, D2_CF "
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TRB", .T., .F. )
          		
Return	 

//////////////////////////
Static Function VerifSD1()
  Local cQuery := ""
  Local lRet   := .F.

  cQuery := " SELECT D1_TIPO, D1_NFORI, D1_SERIORI,D1_ITEMORI "
  cQuery += " FROM "+RetSQLName("SD1")+" SD1 "   
  cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "
  cQuery += " AND D1_NFORI = '"+TMP->D2_DOC+"' " 
  cQuery += " AND D1_SERIORI = '"+TMP->D2_SERIE+"' " 
  cQuery += " AND D1_ITEMORI = '"+TMP->D2_ITEM+"' "
  cQuery += " AND D1_TES <> '232' "
                  
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
  lRet := YYY->(EOF())
  YYY->(dbCloseArea())

Return lRet                       

/////////////////////////////////////////////////////////////
Static Function QryVend(cNota, cSerie, cCliente, cLoja, cSeg)
  Local cQuery    := ""
  Local nPrcLista := 0.00
  Local aVendaCom := {}
                                                       
  //- Criar campo B1_XTIPO C(1) onde 1=Pe�a/ 2=Equipamento/ 3=Outros
  cQuery := " SELECT D2_DOC,D2_SERIE,D2_COD,D2_ITEM,D2_XPRCTAB,D2_QUANT,D2_TOTAL,D2_CF,D2_TES,B1_XTPPROD "
  cQuery += " FROM "+RetSQLName("SD2")+" SD2, "
  cQuery +=          RetSQLName("SB1")+" SB1 "
  cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' "
  cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
  cQuery += " AND D2_DOC = '"+cNota+"' "                 
  cQuery += " AND D2_SERIE = '"+cSerie+"' "
  cQuery += " AND D2_CLIENTE = '"+cCliente+"' "
  cQuery += " AND D2_LOJA = '"+cLoja+"' "
  cQuery += " AND D2_COD = B1_COD "
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP", .T., .F. )
                                            
  // aVendaCom[1][1] //- Pe�as
  // aVendaCom[1][2] //- Equipamentos
  // aVendaCom[1][3] //- Servi�os
  // aVendaCom[1][4] //- Loca��o                
  // aVendaCom[1][5] //- Total                

  AADD(aVendaCom, {0, 0, 0, 0, 0})

  Do while !TMP->(Eof())
     If !VerifSD1()
	    TMP->(dbSkip())  	   
	    Loop
 	 EndIf 
     //������������������������������������������Ŀ
     //� Validar se � venda, servi�o ou loca��o  �
     //�������������������������������������������
     If cSeg = "S"      //- Vendedor do segmento de servi�os
        //If TMP->D2_SERIE = "SR1" .Or. TMP->D2_SERIE = 'RPS'
        If Alltrim(TMP->D2_COD) == '11'
           aVendaCom[1][3] += TMP->D2_TOTAL // Servi�os
        Else 
           aVendaCom[1][1] += TMP->D2_TOTAL // Pe�as
        Endif   
     ElseIf cSeg = "L"  //- Vendedor do segmento de loca��o	 
        aVendaCom[1][4] += TMP->D2_TOTAL
     Else // vendedor do segmento de pe�as ou equipamentos    	 
	    If TMP->B1_XTPPROD = "P" 
	       aVendaCom[1][1] += TMP->D2_TOTAL
	    ElseIf TMP->B1_XTPPROD = "E"
	       aVendaCom[1][2] += TMP->D2_TOTAL
	    Else
           //If TMP->D2_SERIE = "SR1" .Or. TMP->D2_SERIE = 'RPS'
           If Alltrim(TMP->D2_COD) == '11'
              aVendaCom[1][3] += TMP->D2_TOTAL // Servi�os
	       Else
	          aVendaCom[1][4] += TMP->D2_TOTAL // Colocado pra ver a diferen�a no relorio 
	       Endif   
	    Endif
	 Endif
     aVendaCom[1][5] += TMP->D2_TOTAL
     TMP->(dbSkip()) 
  Enddo
  TMP->(dbCloseArea())
Return aVendaCom 

/////////////////////////////////////////////////////////////
User Function TFolder(nPosAt,aPeca,aEquip,aServ,aLoca,aNCla)
  Local oDlg,oBrowse  
  Local cVar, oDlg, oLbx1,oLbx2, oLbx3, oLbx4, oLbx5
  
  AAdd(aServ, {"", "", "", 0 }) 
  AAdd(aLoca, {"", "", "", 0 }) 
  AAdd(aNCla, {"", "", "", 0 }) 
 
  DEFINE DIALOG oDlg TITLE "Detalhe das Vendas" FROM 180,180 TO 550,700+200 PIXEL
  
  //- Cria a Folder
  aTFolder := { 'Pe�as', 'Equipamentos', 'Servi�os', 'Locacao', 'N�o Classificado' }
  oTFolder := TFolder():New( 0,0,aTFolder,,oDlg,,,,.T.,,350,184) //Col1,Lin1,Col2,Lin2
 
  //����������������������Ŀ
  //� 01-Folder de pe�as  �
  //�����������������������
  @ 01,01 LISTBOX oLbx1 VAR cVar FIELDS HEADER "Codigo",;
                                               "Descricao",;
                                               "Nota",;
                                               "Valor" SIZE 350,155 OF oTFolder:aDialogs[1] PIXEL //Col,Lin
                                               //; ON dblClick( MudaParc(oLbx:nAt,@aParcelas,cSimbCheq),oLbx:Refresh(.F.) )
  oLbx1:SetArray(aPeca)
  oLbx1:bLine := {|| {aPeca[oLbx1:nAt,1],;
                      aPeca[oLbx1:nAt,2],;
                      aPeca[oLbx1:nAt,3],;
                      Transform(aPeca[oLbx1:nAt,4],"@E 999,999,999.99")}}
  //�����������������������������Ŀ
  //� 02-Folder de equipamentos  �
  //�������������������������������
  @ 01,01 LISTBOX oLbx2 VAR cVar FIELDS HEADER "Codigo",;
                                               "Descricao",;
                                               "Nota",;
                                               "Valor" SIZE 350,155 OF oTFolder:aDialogs[2] PIXEL //Col,Lin
  oLbx2:SetArray(aEquip)
  oLbx2:bLine := {|| { aEquip[oLbx2:nAt,1],;
                       aEquip[oLbx2:nAt,2],;
                       aEquip[oLbx2:nAt,3],;
                       Transform(aEquip[oLbx2:nAt,4],"@E 999,999,999.99")}}
  //�������������������������Ŀ
  //� 03-Folder de Servi�o     �
  //���������������������������
  @ 01,01 LISTBOX oLbx3 VAR cVar FIELDS HEADER "Codigo",;
                                               "Descricao",;
                                               "Nota",;
                                               "Valor" SIZE 350,155 OF oTFolder:aDialogs[3] PIXEL //Col,Lin
  oLbx3:SetArray(aServ)
  oLbx3:bLine := {|| { aServ[oLbx3:nAt,1],;
                       aServ[oLbx3:nAt,2],;
                       aServ[oLbx3:nAt,3],;
                       Transform(aServ[oLbx3:nAt,4],"@E 999,999,999.99")}}
  //������������������������Ŀ
  //� 04-Folder de Locacao  �
  //��������������������������
  @ 01,01 LISTBOX oLbx4 VAR cVar FIELDS HEADER "Codigo",;
                                               "Descricao",;
                                               "Nota",;
                                               "Valor" SIZE 350,155 OF oTFolder:aDialogs[4] PIXEL //Col,Lin
  oLbx4:SetArray(aLoca)
  oLbx4:bLine := {|| { aLoca[oLbx4:nAt,1],;
                       aLoca[oLbx4:nAt,2],;
                       aLoca[oLbx4:nAt,3],;
                       Transform(aLoca[oLbx4:nAt,4],"@E 999,999,999.99")}}
  //����������������������������������Ŀ
  //� 05-Folder de N�o Classificados  �
  //�����������������������������������
  @ 01,01 LISTBOX oLbx5 VAR cVar FIELDS HEADER "Codigo",;
                                               "Descricao",;
                                               "Nota",;
                                               "Valor" SIZE 350,155 OF oTFolder:aDialogs[5] PIXEL //Col,Lin
  oLbx5:SetArray(aNCla)
  oLbx5:bLine := {|| { aNCla[oLbx5:nAt,1],;
                       aNCla[oLbx5:nAt,2],;
                       aNCla[oLbx5:nAt,3],;
                       Transform(aNCla[oLbx5:nAt,4],"@E 999,999,999.99")}}
  ACTIVATE DIALOG oDlg CENTERED
Return

///////////////////////////////////
Static Function CarregaArray(cTipo)
  Local aVet:={}

  DbSelectArea("TRB")
  dbGoTop()

  Do While !TRB->(EOF())
     If TRB->B1_XTPPROD = cTipo     
        AAdd(aVet, {TRB->D2_COD, TRB->B1_DESC, TRB->F2_DOC+"-"+TRB->F2_SERIE, TRB->D2_TOTAL }) 
     Endif
     TRB->(DbSkip())
  Enddo   
Return aVet  

/////////////////////////////////
Static Function ValidPerg(cPerg)
  PutSX1(cPerg,"01",PADR("Da Data" ,29)+"?","","","mv_ch1","D",08,0,0,"G","","   ","","",mv_par01)
  PutSX1(cPerg,"02",PADR("Ate a Data" ,29)+"?","","","mv_ch2","D",08,0,0,"G","","   ","","",mv_par02)
  PutSX1(cPerg,"03",PADR("Do Vendedor",29)+"?","","","mv_ch3","C",06,0,0,"G","","SA3","","",mv_par03)
Return