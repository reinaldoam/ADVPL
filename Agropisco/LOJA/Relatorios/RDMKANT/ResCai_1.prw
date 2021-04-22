#INCLUDE "rwmake.ch"

User Function ResCai
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Public cDesc1      := "Este programa ir  emitir o Resumo de Caixa de acordo com a"
Public cDesc2      := "data fornecida pelo usuario, utilizando recursos do SIGA Advanced."
Public cDesc3      := ""
Public titulo      := "Fechamento de Caixa - AGROPISCO"
Public Cabec1      := ""
Public Cabec2      := ""
Public imprime     := .T.
Public aOrd        := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "RESCAI" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RESCAI" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "SL1"
Private nTotal
Private aEntrada:={},aSaida:={}

nLin:= 80

ValidPerg()

Pergunte("RESCAI",.F.)

wnrel := SetPrint(cString,NomeProg,"RESCAI",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/////////////////////////////////////////////////////
Static function RunReport(Cabec1,Cabec2,Titulo,nLin)

  Local nOrdem,aCartao,aFatura,cMatriz,nPos,nValor

  //- mv_par01 - Do Fechamento    ?
  //- mv_par02 - Ate o Fechamento ?
  //- mv_par03 - Do Caixa         ?
  //- mv_par04 - Ate o Caixa      ?

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Vendas Agropisco via ECF      ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  SL1->(dbSelectArea(cString))
  SetRegua(SL1->(Reccount()))
  
  SL1->(dbSetOrder(4))  // Filial + Data ECF + PDV + Operado
  SL1->(dbSeek(xFilial()+Dtos(mv_par01)))
  
  While !SL1->(Eof()) .and. SL1->L1_FILIAL == xFilial() .and. SL1->L1_EMISSAO <= mv_par02
     
     IncRegua()                                       
     
     If SL1->L1_OPERADO < mv_par03 .Or. SL1->L1_OPERADO > mv_par04     
        SL1->(dbSkip())
        Loop
     Endif                                                                                    
     //    1     2     3       4      5      6     7      8     9     10        11        12      13
     // Cliente/Prf/Dinheiro/Cheque/Debito/Amex/Redecard/Visa/Boleto/Permuta/Funcionario/Total/Historico
     AADD(aEntrada,{"","",0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 , 0.00, 0.00, 0.00, "" })
     
     nPos:= Len(aEntrada)
     
     aEntrada[nPos,1] := Padr(Posicione("SA1",1,xFilial("SA1")+SL1->L1_CLIENTE+SL1->L1_LOJA,"A1_NREDUZ"),20)
     aEntrada[nPos,2] := SL1->L1_SERIE+" "+SL1->L1_DOC 
     aEntrada[nPos,12]:= SL1->L1_VLRTOT

     //- Recebimentos
     Recebimento(nPos)

     dbSelectArea(cString)
     SL1->(dbSkip())
  Enddo      
  If Len(aEntrada)=0
     AADD(aEntrada,{"","",0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 , 0.00, 0.00, 0.00, "" })
  Endif
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Recebimento de outros valores ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SE5")
  SetRegua(SE5->(Reccount()))
  
  SE5->(dbSetOrder(1)) // Filial + Data + Banco
  SE5->(dbSeek(xFilial()+Dtos(mv_par01)))
  
  While !SE5->(Eof()) .and. SE5->E5_FILIAL == xFilial() .and. SE5->E5_DATA <= mv_par02
     IncRegua()                                       
     If SE5->E5_BANCO < mv_par03 .or. SE5->E5_BANCO > mv_par04 .or. SE5->E5_SITUACA $ "C#X#E"
        SE5->(dbSkip())
        Loop
     Endif                                                                  
     If Trim(SE5->E5_NATUREZ) $ "SANGRIA#TROCO" .Or. SE5->E5_RECPAG <> "R" .Or. !(SE5->E5_TIPODOC$"VL#")
        SE5->(dbSkip())
        Loop
     Endif                                                                  
     nPos:= Ascan(aEntrada,{|x| x[2] == Padr(SE5->E5_DOCUMEN,10) })
     If nPos = 0     
        //    1     2     3       4       5     6       7       8    9      10        11       12     13
        // Cliente/Prf/Dinheiro/Cheque/Debito/Dinner/Redecard/Visa/Boleto/Permuta/Funcionario/Total/Historico
        AADD(aEntrada,{"", "", 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 , 0.00, 0.00, 0.00, "" })
        nPos:= Len(aEntrada)
     Endif   
     aEntrada[nPos,1] := Padr(SE5->E5_BENEF,20)
     aEntrada[nPos,2] := Padr(SE5->E5_DOCUMEN,10)
     aEntrada[nPos,13]:= SE5->E5_HISTOR
     aEntrada[nPos,12] += SE5->E5_VALOR

     If SE5->E5_MOEDA == "R$"     //- Dinheiro
        aEntrada[nPos,3]:= SE5->E5_VALOR
        
     Elseif SE5->E5_MOEDA == "CH" //- Cheque
        aEntrada[nPos,4]:= SE5->E5_VALOR
        
     Elseif SE5->E5_MOEDA == "CD" //- Cartao Debito
        aEntrada[nPos,5]:= SE5->E5_VALOR
        
     //Elseif SE5->E5_MOEDA == "D2" //- Amex
     //   aEntrada[nPos,6]:= SE5->E5_VALOR

     //Elseif SE5->E5_MOEDA == "D1" //- Credicard
     //   aEntrada[nPos,7]:= SE5->E5_VALOR

     //Elseif SE5->E5_MOEDA == "D3" //- Visa
     //   aEntrada[nPos,8]:= SE5->E5_VALOR

     Elseif SE5->E5_MOEDA == "FI" //- Boleto
        aEntrada[nPos,9]:= SE5->E5_VALOR
     
     Endif                                          
     SE5->(dbSkip())
  Enddo   
  If Len(aEntrada) > 0
     //    1     2     3       4      5      6     7      8     9     10        11        12      13
     // Cliente/Prf/Dinheiro/Cheque/Debito/Amex/Redecard/Visa/Boleto/Permuta/Funcionario/Total/Historico
     AADD(aEntrada,{PADR("TOTAL",20),Space(10),0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00 , 0.00, 0.00, 0.00, "" })
  Endif   

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Saidas no periodo - debitos / pagamentos / sangrias ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  dbSelectArea("SE5")
  SetRegua(SE5->(Reccount()))
  
  SE5->(dbSetOrder(1)) // Filial + Data + Banco
  SE5->(dbSeek(xFilial()+Dtos(mv_par01)))
  
  While !SE5->(Eof()) .and. SE5->E5_FILIAL == xFilial() .and. SE5->E5_DATA <= mv_par02
     IncRegua()                                       
     If SE5->E5_BANCO < mv_par03 .or. SE5->E5_BANCO > mv_par04 .or. SE5->E5_SITUACA == "C" // SE5->E5_SITUACA $ "C#X#E"
        SE5->(dbSkip())
        Loop
     Endif                                                    
     cNat:= Trim(SE5->E5_NATUREZ) 
     If Trim(cNat) $ "SANGRIA#TROCO"
        AADD(aSaida,{SE5->E5_NUMCHEQ, PADR(SE5->E5_HISTOR,20), SE5->E5_VALOR, SE5->E5_MOEDA, cNat })        
     Endif   
     SE5->(dbSkip())
  Enddo   

  ImpResumo()  

  SET DEVICE TO SCREEN
  If aReturn[5]==1
     dbCommitAll()
     SET PRINTER TO
     OurSpool(wnrel)
  Endif
  MS_FLUSH()
Return

/////////////////////////////////
Static Function Recebimento(nPos)

  Local cCodCartao

  SL4->(DbSetOrder(1))
  SL4->(DbSeek(xFilial("SL4")+SL1->L1_NUM))
  
  While !SL4->(Eof()) .and. SL4->(L4_FILIAL+L4_NUM) == xFilial("SL4")+SL1->L1_NUM

     //- Dinheiro
     If AllTrim(SL4->L4_FORMA) $ "R$" 
        aEntrada[nPos,3] += SL4->L4_VALOR  //- Dinheiro
     Endif       

     //- Cheque
     If AllTrim(SL4->L4_FORMA) $ "CH"
        aEntrada[nPos,4] += SL4->L4_VALOR  //- Cheque
     Endif   
  
     //- Boleto
     If AllTrim(SL4->L4_FORMA) $ "BO#FI"
        aEntrada[nPos,9] += SL4->L4_VALOR  //- Boleto
     Endif   

     //- Funcionarios
     If AllTrim(SL4->L4_FORMA) $ "VA"
        aEntrada[nPos,11] += SL4->L4_VALOR //- Vales
     Endif   

     //- Cartao de credito/debito
     If AllTrim(SL4->L4_FORMA) $ "CC#CD"
        cCodCartao:= Substr(SL4->L4_ADMINIS,1,3)
        If cCodCartao $ "001#002"  //- Credicard
           aEntrada[nPos,7] += SL4->L4_VALOR
        ElseIf cCodCartao $ "003#004" //- RedeShop/ Visa Eletron
           aEntrada[nPos,5] += SL4->L4_VALOR
        ElseIf cCodCartao $ "005#009" //- Visa
           aEntrada[nPos,8] += SL4->L4_VALOR
        ElseIf cCodCartao $ "006#007" //- Diners
           aEntrada[nPos,6] += SL4->L4_VALOR
        Endif      
     Endif
     
     SL4->(DbSkip())
  Enddo   
Return   

/////////////////////////
Static Function ImpResumo
  Local nDinheiro,nSangria,nTroco,nSaldo
  nLen:= Len(aEntrada)
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Impressao do cabecalho do relatorio. . .                            ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  Cabec1:= "Periodo de " + Dtoc(mv_par01) + " A " + Dtoc(mv_par02)
  Cabec2:= ""
  nLin := 80
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Entradas no periodo - Creditos / Vendas ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  SetRegua(nLen-1)
  For i:= 1 to nLen-1
     If aEntrada[i,12] = 0
        Loop
     Endif   
     If lAbortPrint
        @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
        Exit
     Endif
     If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
        nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
        @nLin, 000 PSay PADC("ENTRADAS NO PERIODO - CREDITOS / VENDAS",220)
        nLin+=2                                                  
        //               0         1         2         3         4         5         6         7         8         9         10       11        12        13        14        15        16        17        18        19
        //               012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
        @nLin, 000 PSay "Cliente                Prefixo          Dinheiro          Cheque          Debito          Dinner        Redecard            Visa          Boleto         Permuta     Funcionario           Total"
        nLin++
        @nLin, 000 PSay "--------------------  ----------  --------------  --------------  --------------  --------------  --------------  --------------  --------------  --------------  --------------  --------------"
        nLin++
     Endif
     @nLin, 000      PSay aEntrada[i,1]  Picture "@!"
     @nLin, Pcol()+2 PSay aEntrada[i,2]  Picture "@!"    
     @nLin, Pcol()+2 PSay aEntrada[i,3]  Picture "@E 999,999,999.99"
     @nLin, Pcol()+2 PSay aEntrada[i,4]  Picture "@E 999,999,999.99"    
     @nLin, Pcol()+2 PSay aEntrada[i,5]  Picture "@E 999,999,999.99"    
     @nLin, Pcol()+2 PSay aEntrada[i,6]  Picture "@E 999,999,999.99"    
     @nLin, Pcol()+2 PSay aEntrada[i,7]  Picture "@E 999,999,999.99"         
     @nLin, Pcol()+2 PSay aEntrada[i,8]  Picture "@E 999,999,999.99"         
     @nLin, Pcol()+2 PSay aEntrada[i,9]  Picture "@E 999,999,999.99"         
     @nLin, Pcol()+2 PSay aEntrada[i,10] Picture "@E 999,999,999.99"         
     @nLin, Pcol()+2 PSay aEntrada[i,11] Picture "@E 999,999,999.99"         
     @nLin, Pcol()+2 PSay aEntrada[i,12] Picture "@E 999,999,999.99"         
     @nLin, Pcol()+2 PSay aEntrada[i,13]  Picture "@!"    
     nLin++
     
     //- Somando valores por modalidade de pagamento
     aEntrada[nLen,3]  += aEntrada[i,3]
     aEntrada[nLen,4]  += aEntrada[i,4]
     aEntrada[nLen,5]  += aEntrada[i,5]
     aEntrada[nLen,6]  += aEntrada[i,6]
     aEntrada[nLen,7]  += aEntrada[i,7]
     aEntrada[nLen,8]  += aEntrada[i,8]
     aEntrada[nLen,9]  += aEntrada[i,9]
     aEntrada[nLen,10] += aEntrada[i,10]
     aEntrada[nLen,11] += aEntrada[i,11]
     aEntrada[nLen,12] += aEntrada[i,12]
  Next
  nDinheiro:= aEntrada[nLen,3]
  
  @ nLin, 000      PSay __PrtThinLine()                    
  nLin++
  @ nLin, 000      PSay aEntrada[nLen,1]  Picture "@!"
  @ nLin, Pcol()+2 PSay aEntrada[nLen,2]  Picture "@!"    
  For i:= 3 to 12
     @ nLin, Pcol()+2 PSay aEntrada[nLen,i]  Picture "@E 999,999,999.99"   
  Next  
  nLin++
  @nLin, 000 PSay __PrtThinLine()                    
  nLin += 2

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Saidas no periodo - Debitos/ Pagamentos/ Sangrias ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
     nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
  Endif   
  @nLin, 000 PSay PADC("SAIDAS NO PERIODO - DEBITOS/ PAGAMENTOS/ SANGRIAS",220)
  nLin+=2                                                  
  
  nSangria:= 0.00
  nTroco  := 0.00
  
  For i:= 1 to Len(aSaida)
     If lAbortPrint
        @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
        Exit
     Endif
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³ Impressao do cabecalho do relatorio. . .                            ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
        nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
        @nLin, 000 PSay "SAIDAS NO PERIODO - DEBITOS/ PAGAMENTOS/ SANGRIAS"
        nLin+=2                                                            
     Endif
     If Trim(aSaida[i,5]) = "SANGRIA"
        @nLin, 000      PSay aSaida[i,2]  Picture "@!"  
        @nLin, Pcol()+2 PSay aSaida[i,1]  Picture "@!"
        @nLin, 178      PSay aSaida[i,3]  Picture "@( 999,999,999.99"
        nSangria += aSaida[i,3]
        nLin++                 
     Else
        nTroco += aSaida[i,3]       
     Endif
  Next
  @ nLin, 000 PSay __PrtThinLine()                    
  nLin++
  @ nLin, 000 PSay "TOTAL"
  @ nLin, 178 PSay nSangria Picture "@E 999,999,999.99"   
  nLin++
  @nLin, 000 PSay __PrtThinLine()                    
  nLin+=2

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Resumo de caixa  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
  nSaldo:= ( nTroco + nDinheiro ) - nSangria
  
  If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
     nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo) + 1
  Endif   
  @nLin, 000 PSay PADC("RESUMO DE CAIXA",220)
  nLin+=2                          
  
  @nLin, 000 PSay "Fundo de Caixa"  
  @nLin, 178 PSay nTroco Picture "@E 999,999,999.99"   
  nLin++

  @nLin, 000 PSay "Saldo em Dinheiro"
  @nLin, 178 PSay nDinheiro Picture "@E 999,999,999.99"   
  nLin++

  @nLin, 000 PSay "Saida em Dinheiro"
  @ nLin, 178 PSay nSangria Picture "@E 999,999,999.99"   
  nLin++

  @ nLin, 000 PSay __PrtThinLine()                    
  nLin++

  @nLin, 000 PSay "Saldo Liquido em Dinheiro"
  @nLin, 178 PSay nSaldo Picture "@E 999,999,999.99"   
  nLin++
  
  @nLin, 000 PSay __PrtThinLine()                    
  nLin += 2
  //               0         1         2         3         4         5         6         7         8         9         10       11        12        13        14        15        16        17        18        19
  //               012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
  @nLin, 000 PSay "Data Emissao                      Responsavel fechamento                      Responsavel Conferencia                      Autorizado por                      Vl p/ abertura                  "
  nLin+=2
  @nLin, 000 PSay dDataBase
  @nLin, 034 PSay "______________________                      _______________________                      ______________                      ______________"
  nLin++
  @nLin, 000 PSay " "
    
Return

////////////////////////////
Static Function ValidPerg()
    _sAlias := Alias()                                                    
    dbSelectArea("SX1")
    dbSetOrder(1)
    cPerg :="RESCAI"
    aRegs :={}
    aAdd(aRegs,{cPerg,"01","Do Fechamento    ?","Do Fechamento    ?","Do Fechamento    ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
    aAdd(aRegs,{cPerg,"02","Ate o Fechamento ?","Ate o Fechamento ?","Ate o Fechamento ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
    aAdd(aRegs,{cPerg,"03","Do Caixa         ?","Do Caixa         ?","Do Caixa         ?","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","",""})
    aAdd(aRegs,{cPerg,"04","Ate o Caixa      ?","Ate o Caixa      ?","Ate o Caixa      ?","mv_ch4","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","",""})
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
    dbSelectArea(_sAlias)
 Return
 
//////////////////////////
Static Function BscOrigem
  Local cAlias :=Alias()       
  Local cRet   := SE5->E5_NATUREZ
  Local cBusca := Substr(SE5->E5_NATUREZ,2,5)
  //- Plano de contas  
  DbSelectArea("CT1")
  DbSetOrder(2)
  If DbSeek(xFilial("CT1")+cBusca) 
     cRet:= IIf(CT1->CT1_NORMAL=="1","SANGRIA",SE5->E5_NATUREZ)
  Endif
  DbSelectArea(cAlias)
Return cRet           