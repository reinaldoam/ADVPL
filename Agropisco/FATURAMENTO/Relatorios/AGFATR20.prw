#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AGFATR20  � Autor � REINALDO MAGALHAES � Data �  20/02/15   ���
�������������������������������������������������������������������������͹��
���Descricao � FOLHA DE PAGAMENTO DE VENDEDORES                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AGFATR20()
  //���������������������������������������������������������������������Ŀ
  //� Declaracao de Variaveis                                             �
  //�����������������������������������������������������������������������
  Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
  Local cDesc2     := "de acordo com os parametros informados pelo usuario."
  Local cDesc3     := "FOLHA DE VENDEDORES"
  Local cPict      := ""
  Local titulo     := ""
  Local nLin       := 180
  Local Cabec1     := ""  
  Local Cabec2     := ""
  Local imprime    := .T.
  Local aOrd       := {}
  Local aVendaCom  := {}

  Private lEnd       := .F.
  Private lAbortPrint:= .F.
  Private CbTxt      := ""
  Private limite     := 80
  Private tamanho    := "G"
  Private nomeprog   := "AGFATR20" // Coloque aqui o nome do programa para impressao no cabecalho
  Private nTipo      := 18
  Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
  Private nLastKey   := 0
  Private cbtxt      := Space(10)
  Private cbcont     := 00
  Private CONTFL     := 01
  Private m_pag      := 01
  Private wnrel      := "AGFATR20" // Coloque aqui o nome do arquivo usado para impressao em disco
  Private cPerg      := "FATR20" 

  Private cString   := "SD2"                         
 
  //alert("NOVO")
  
  dbSelectArea("SA3")
  U_MsSetOrder("SA3","A3_FILIAL+A3_COD")

  dbSelectArea("SD2")
  U_MsSetOrder("SD2","D2_FILIAL+D2_COD+D2_LOCAL+D2_NUMSEQ")//Inclu�do por Ulisses Jr em 24/04/08 em substitui��o a linha acima

  Pergunte(cPerg,.F.)  
  
  //���������������������������������������������������������������������Ŀ
  //� Monta a interface padrao com o usuario...                           �
  //�����������������������������������������������������������������������
  wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
  If nLastKey == 27
     Return                               
  Endif
  SetDefault(aReturn,cString)

  titulo:= "FOLHA DE VENDEDORES DE " + Dtoc(mv_par03) + " A " +  Dtoc(mv_par04)
             
  //          0	        1		  2		    3	      4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19
  //		  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567
  Cabec1 := "VEND    NOME                           FAT. -----  FAT. ----   FAT. -----  FAT. -----  TOTAL-----  COMISSAO    (%)   COMISSAO--   (%)    COMISSAO--   (%)    COMISSAO     (%)    VALOR----   COMISSAO--"
  Cabec2 := "                                       PECAS-----  EQUIPAMEN.  SERVICOS--  LOCACAO---  FATURADO--  PECAS             EQUIPAMENT          SERVICO---          LOCACAO---          EXTRA----   A PAGAR---"
  //          999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXX  999,999.99  999,999.99  999,999.99  999,999.99  999,999.99  999,999.99 999.99 999,999.99  999.99  999,999.99  999.99  999,999.99  999.99  999,999.99  999,999.99

  If nLastKey == 27
     Return
  Endif

  nTipo := If(aReturn[4]==1,15,18)

  //���������������������������������������������������������������������Ŀ
  //� Processamento. RPTSTATUS monta janela com a regua de processamento. �
  //�����������������������������������������������������������������������
  RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
  
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  02/01/08   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLinII)
  Local aVendaCom := {}
  Local aFolha    := {}                                           

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

  //�����������������������������������Ŀ
  //� Carregando matriz de vendedores  �
  //������������������������������������
  SA3->(DbGotop())
  Do while !SA3->(Eof())
     If SA3->A3_MSBLQL <> "1"               
        //1=VEND*2=NOME*3=FAT.PECAS*4=FAT.EQUIP*5=FAT.SERVICOS*6=FAT.LOCACAO*7=TOTAL FATURADO*8=COMISSAO PECAS*9=(%)*10=COMISSAO EQUIPAMENTO*11=(%)*12=COMISSAO SERVICO*13=(%)*14=COMISSAO LOCACAO*15=(%)*16=VALOR EXTRA*17=COMISSAO EXTRA*18=SEGMENTO
        AADD(aFolha, {SA3->A3_COD,SA3->A3_NREDUZ, 0.00, 0.00, 0.00,	0.00, 0.00,	0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, SA3->A3_XSEGMEN })
     Endif
     SA3->(DbSkip())
  Enddo   

  AAdd(aVendaCom, {0, 0, 0, 0, 0})
 
  dbSelectArea(cString)
  dbSetOrder(1)

  U_MontaQry()

  //���������������������������������������������������������������������Ŀ
  //� SETREGUA -> Indica quantos registros serao processados para a regua �
  //�����������������������������������������������������������������������
      
  SetRegua(XXX->(Lastrec()))

  dbGoTop()

  Do while !XXX->(EOF())

     IncRegua()    
      
     If cAuxDoc <> XXX->D2_DOC .Or. cAuxSer <> XXX->D2_SERIE

        SA3->(DbSeek(xFilial("SA3")+XXX->F2_VEND1))
        
        aVendaCom := QryVend(XXX->F2_DOC,XXX->F2_SERIE,XXX->F2_CLIENTE,XXX->F2_LOJA,SA3->A3_XSEGMEN)  
        
        //�������������������������������������������������������������������Ŀ
        //� Regra para c�lculo de percentual de comiss�o baseado em acrescimo �
        //���������������������������������������������������������������������
        If !Empty(XXX->F2_VEND1)
	       nPos:= aScan(aFolha,{|x| x[1] = XXX->F2_VEND1 })
	       If nPos > 0 
	          aFolha[nPos][3] += aVendaCom[1][1] //- Pe�as
	          aFolha[nPos][4] += aVendaCom[1][2] //- Equipamentos
	          aFolha[nPos][5] += aVendaCom[1][3] //- Servi�os
	          aFolha[nPos][6] += aVendaCom[1][4] //- Loca��o                
	          aFolha[nPos][7] += aVendaCom[1][5] //- Total                
	       Endif   
        Endif
     Endif        
     cAuxDoc  := XXX->D2_DOC
     cAuxTES  := XXX->D2_CF
     cAuxSer  := XXX->D2_SERIE                                       
     cAuxVend := XXX->F2_VEND1 
     XXX->(dbSkip()) // Avanca o ponteiro do registro no arquivo
  Enddo
  XXX->(dbCloseArea())
        
  //����������������������������������Ŀ
  //� Regra para c�lculo de comiss�o  �
  //�����������������������������������
  //nValFat:= 0
  //aEval( aFolha, {|x| nValFat += x[3]+x[4] })
  
  //aFolha->1=VEND*2=NOME*3=FAT.PECAS*4=FAT.EQUIP*5=FAT.SERVICOS*6=FAT.LOCACAO*7=TOTAL FATURADO*8=COMISSAO PECAS*9=(%)*10=COMISSAO EQUIPAMENTO*11=(%)*12=COMISSAO SERVICO*13=(%)*14=COMISSAO LOCACAO*15=(%)*16=VALOR EXTRA*17=COMISSAO EXTRA*18=SEGMENTO VENDEDOR
  
  nValFat:= 0
  
  //aEval( aFolha, {|x| nValFat += IIF(x[1]$"000056#000079#000092#000093#000094#000095", x[3]+x[4]+x[5], 0) }) //Vendedores que geram comiss�o para o Diego
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

  //����������������������Ŀ
  //� Inicio da impress�o �
  //������������������������
  SetRegua(Len(aFolha))
                                       
  For i:= 1 to Len(aFolha)
     IncRegua()    
     //���������������������������������������������������������������������Ŀ
     //� Verifica o cancelamento pelo usuario...                             �
     //�����������������������������������������������������������������������
     If lAbortPrint
        @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
        Exit
     Endif
     //���������������������������������������������������������������������Ŀ
     //� Impressao do cabecalho do relatorio. . .                            �
     //�����������������������������������������������������������������������
     If nLin > 55  
        Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
        nLin := 9 
     Endif
     @nLin,000 PSay aFolha[i][1]
     @nLin,008 PSay aFolha[i][2] Picture "@!" 
     @nLin,039 PSay aFolha[i][3] Picture "@E 999,999.99" // Pe�as
     @nLin,051 PSay aFolha[i][4] Picture "@E 999,999.99" // Equipamento
     @nLin,063 PSay aFolha[i][5] Picture "@E 999,999.99" // Servi�o
     @nLin,075 PSay aFolha[i][6] Picture "@E 999,999.99" // Locacao
     @nLin,087 PSay aFolha[i][7] Picture "@E 999,999.99" // Total
     //-
     @nLin,098 PSay aFolha[i][8]  Picture "@E 999,999.99" // Valor comiss�o pe�as
     @nLin,109 PSay aFolha[i][9]  Picture "@E 999.99"     // % Comiss�o pe�as
     @nLin,116 PSay aFolha[i][10] Picture "@E 999,999.99" // Valor comiss�o equipamentos
     @nLin,128 PSay aFolha[i][11] Picture "@E 999.99"     // % Comiss�o equipamentos
     @nLin,136 PSay aFolha[i][12] Picture "@E 999,999.99" // Valor comiss�o servi�os
     @nLin,148 PSay aFolha[i][13] Picture "@E 999.99"     // % Comiss�o servi�os
     @nLin,156 PSay aFolha[i][14] Picture "@E 999,999.99" // Valor comiss�o loca��o
     @nLin,168 PSay aFolha[i][15] Picture "@E 999.99"     // % Comiss�o loca��o
     @nLin,176 PSay aFolha[i][16] Picture "@E 999,999.99" // Valores de comiss�o extra          
     @nLin,188 PSay aFolha[i][17] Picture "@E 999,999.99" // Valor comiss�o total     
     nLin++
    
     nVgPeca   += aFolha[i][3] 
     nVgEquipa += aFolha[i][4]
     nVgServic += aFolha[i][5]
     nVgLocaca += aFolha[i][6]
     nVgTotal  += aFolha[i][7] 
     //-
     nCgPeca   += aFolha[i][8] 
     nCgEquipa += aFolha[i][10]
     nCgServic += aFolha[i][12]
     nCgLocaca += aFolha[i][14] 
     nCgExtra  += aFolha[i][16]
     nCgPagar  += aFolha[i][17]
  Next
  If nRegis > 0
     nlin++
     @ nLin, 000  PSay __PrtThinLine()                    
     nlin++                            
     @nLin,000 PSay "TOTAL"
     @nLin,038 PSay nVgPeca   Picture "@E 999,999.99" // Pe�as
     @nLin,051 PSay nVgEquipa Picture "@E 999,999.99" // Equipamento
     @nLin,063 PSay nVgServic Picture "@E 999,999.99" // Servi�o
     @nLin,075 PSay nVgLocaca Picture "@E 999,999.99" // Locacao
     @nLin,087 PSay nVgTotal  Picture "@E 999,999.99" // Total
     //-
     @nLin,098 PSay nCgPeca   Picture "@E 999,999.99" // Valor comiss�o pe�as
     @nLin,116 PSay nCgEquipa Picture "@E 999,999.99" // Valor comiss�o equipamentos
     @nLin,136 PSay nCgServic Picture "@E 999,999.99" // Valor comiss�o servi�os
     @nLin,156 PSay nCgLocaca Picture "@E 999,999.99" // Valor comiss�o loca��o
     @nLin,176 PSay nCgExtra  Picture "@E 999,999.99" // Valores extra 
     @nLin,188 PSay nCgPagar  Picture "@E 999,999.99" // Valor a pagar 
     nlin++
     @ nLin, 000  PSay __PrtThinLine()                    
     nlin++                            
  Endif      
  //���������������������������������������������������������������������Ŀ
  //� Finaliza a execucao do relatorio...                                 �
  //�����������������������������������������������������������������������
  SET DEVICE TO SCREEN
  //���������������������������������������������������������������������Ŀ
  //� Se impressao em disco, chama o gerenciador de impressao...          �
  //�����������������������������������������������������������������������
  If aReturn[5]==1
     dbCommitAll()
     SET PRINTER TO
     OurSpool(wnrel)
  Endif
  MS_FLUSH()
Return

//////////////////////////
User Function MontaQry()
  Local aVet:={}
  Local cQuery := ""
  //���������������������������������������������Ŀ
  //� Gera matriz com todos os vendedores ativos �
  //�����������������������������������������������
  SA3->(DbGotop())
  Do while !SA3->(Eof())
     If SA3->A3_MSBLQL <> "1"               
        //1=VEND*2=NOME*3=FAT.PECAS*4=FAT.EQUIP*5=FAT.SERVICOS*6=FAT.LOCACAO*7=TOTAL FATURADO*8=COMISSAO PECAS*9=(%)*10=COMISSAO EQUIPAMENTO*11=(%)*12=COMISSAO SERVICO*13=(%)*14=COMISSAO LOCACAO*15=(%)*16=VALOR EXTRA*17=COMISSAO EXTRA*18=SEGMENTO
        AADD(aVet, {SA3->A3_COD,SA3->A3_NREDUZ, 0.00, 0.00, 0.00,	0.00, 0.00,	0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, SA3->A3_XSEGMEN })
     Endif
     SA3->(DbSkip())
  Enddo   
  //���������������������������������������������Ŀ
  //� Gera matriz com todos os vendedores ativos �
  //�����������������������������������������������
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
  cQuery += " AND B1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND F2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D2_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' "  
  cQuery += " AND F2_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' "  
  cQuery += " AND ((D2_CF = '"+cCfPeca+"' "
  cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES <> '"+cTesLoca+"') "
  cQuery += " OR (D2_CF = '"+cCfServ+"' AND D2_TES = '"+cTesLoca+"')) "
  cQuery += " OR D2_CF = '6102' OR D2_CF = '6929' OR D2_CF = '6108' OR D2_CF = '6933' OR D2_CF = '5404' OR D2_CF = '6404' OR D2_CF = '5405' OR D2_CF = '6405')"
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
  nRegis := SOMA             
  dbCloseArea()

  cQuery := StrTran(cQuery,"COUNT(*)SOMA", "*")
  cQuery += " ORDER BY F2_VEND1,D2_DOC,D2_SERIE, D2_CF "
 
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "XXX", .T., .F. )
          		
Return	 

//////////////////////////
Static Function VerifSD1()
        
  Local cQuery := ""
  Local lRet   := .F.

  cQuery := " SELECT D1_TIPO, D1_NFORI, D1_SERIORI,D1_ITEMORI "
  cQuery += " FROM "+RetSQLName("SD1")+" SD1 "   
  cQuery += " WHERE SD1.D_E_L_E_T_ <> '*' "
  cQuery += " AND D1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
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
  cQuery += " AND B1_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
  cQuery += " AND D2_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
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
        If Alltrim(TMP->D2_COD) == '11' .Or. Alltrim(TMP->D2_COD) == '001364'
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
           If Alltrim(TMP->D2_COD) == '11' .Or. Alltrim(TMP->D2_COD) == '001364'
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

////////////////////////////////                              
Static Function ValidPerg(cPerg)
  Local _sAlias := Alias()
  Local aRegs :={}

  DbSelectArea("SX1")
  DbSetOrder(1)

  aAdd(aRegs,{cPerg,"01","Da Filial            ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg,"02","Ate a Filial         ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg,"03","Da data              ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","", "","","","","","","","","","","","","","","","","","","","","","",""})
  aAdd(aRegs,{cPerg,"04","Ate a data           ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","", "","","","","","","","","","","","","","","","","","","","","","",""})

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