#INCLUDE "PROTHEUS.CH"                                         

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � AGFINR03 � Autor � Microsiga             � Data � 29/08/16 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO BANCO DO BRASIL COM CODIGO DE BARRAS   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
���Uso       �Alterado por Marcel Robinson Grosselli  data 22-04-10       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AGFINR03(lCallMe,xNil,cPref)
  LOCAL	aPergs := {} 
  PRIVATE lExec    := .F.
  PRIVATE cIndexName := ''
  PRIVATE cIndexKey  := ''
  PRIVATE cFilter    := ''

  Tamanho  := "M"  
  titulo   := "Boleto do Banco do Brasil"
  cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
  cDesc2   := ""
  cDesc3   := ""
  cString  := "SE1"
  wnrel    := "AGFINR03"
  lEnd     := .F.
  cPerg    := PADR("AGFINR03",Len(SX1->X1_GRUPO))
  aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
  nLastKey := 0

  lCallMe  := If( lCallMe == Nil , .F., lCallMe)
  
  Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
  Aadd(aPergs,{"De Numero","","","mv_ch3","C",9,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",9,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
  Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
  Aadd(aPergs,{"De Emissao","","","mv_ch7","D",8,0,0,"G","","MV_PAR07","","","","01/01/00","","","","","","","","","","","","","","","","","","","","","","","","",""})
  Aadd(aPergs,{"Ate Emissao","","","mv_ch8","D",8,0,0,"G","","MV_PAR08","","","","31/12/06","","","","","","","","","","","","","","","","","","","","","","","","",""})

  AjustaSx1(cPerg,aPergs)

  Pergunte(cPerg,.F.)

  If !lCallMe
     Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,) //- Chamado pelo menu
  Else 
     Wnrel := SetPrint(cString,Wnrel,"",@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)    //- Chamado pela rotina de vendas
  Endif   
  
  If nLastKey == 27
     Set Filter to
	 Return
  Endif
  SetDefault(aReturn,cString)

  If nLastKey == 27
     Set Filter to
	 Return
  Endif

  If lCallMe //- Chamado pela rotina de vendas
     MV_PAR01:= SE1->E1_PREFIXO  //- De Prefixo     
     MV_PAR02:= SE1->E1_PREFIXO  //- Ate Prefixo    
     MV_PAR03:= SE1->E1_NUM      //- De Numero      
     MV_PAR04:= SE1->E1_NUM      //- Ate Numero     
     MV_PAR05:= " "              //- De Parcela     
     MV_PAR06:= "Z"              //- Ate Parcela    
     MV_PAR07:= Ctod("01/01/80") //- De Emissao     
     MV_PAR08:= Ctod("31/12/19") //- Ate Emissao    
  Endif

  cIndexName := Criatrab(Nil,.F.)
  cIndexKey  := "E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA+E1_TIPO+E1_PARCELA+DTOS(E1_EMISSAO)"
  
  cFilter    += "E1_FILIAL=='"+SE1->(xFilial())+"'.And.E1_SALDO>0.And."
  cFilter    += "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And." 
  cFilter    += "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
  cFilter    += "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
  cFilter    += "DTOS(E1_EMISSAO)>='"+DTOS(mv_par07)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par08)+"'"//.And."

  IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")

  cMarca:= GetMark()

  DbSelectArea("SE1")
  dbGoTop()

  DEFINE MSDIALOG oDlg TITLE "Sele��o de Titulos" FROM 00,00 TO 400,700 PIXEL

  oMark := MsSelect():New( "SE1", "E1_OK",,  ,, cMarca, { 001, 001, 170, 350 } ,,, )

  oMark:oBrowse:Refresh()
  oMark:bAval               := { || ( Marcar( cMarca ), oMark:oBrowse:Refresh() ) }
  oMark:oBrowse:lHasMark    := .T.
  oMark:oBrowse:lCanAllMark := .T.
  oMark:oBrowse:bAllMark    := { || ( MarcaTudo( cMarca ), oMark:oBrowse:Refresh(.T.) ) }

  DEFINE SBUTTON oBtn1 FROM 180,310 TYPE 1 ACTION (lExec := .T.,oDlg:End()) ENABLE
  DEFINE SBUTTON oBtn2 FROM 180,280 TYPE 2 ACTION (lExec := .F.,oDlg:End()) ENABLE

  ACTIVATE MSDIALOG oDlg CENTERED
	
  dbGoTop()

  If lExec
     Processa({|lEnd|MontaRel()})
  Endif

  DbSelectArea("SE1")
  Set Filter to

  RetIndex("SE1")
  Ferase(cIndexName+OrdBagExt())

Return Nil
                
/////////////////////////////////
Static Function MarcaTudo(cMarca)
  
  Local nReg := SE1->(Recno())

  dbSelectArea("SE1")
  dbGoTop()
  
  Do while !Eof()
     Marcar(cMarca)
     dbSkip()
  Enddo
  dbGoTo(nReg)
Return .T.

///////////////////////////////////
Static Function Marcar(cMarca,oSom)
  RecLock("SE1",.F.)
  SE1->E1_OK := If( E1_OK <> cMarca , cMarca, Space(Len(E1_OK)))
  MsUnLock()
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  MontaRel� Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER COM CODIGO DE BARRAS			     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MontaRel()
  Local oPrint, cMaxPar, cQuery, cDocumen, dDataIni
  Local aDadosEmp := {	Alltrim(SM0->M0_NOMECOM)                                                  ,; //[1]Nome da Empresa
    			  	    Alltrim(SM0->M0_ENDCOB)                                                   ,; //[2]Endere�o
	  					AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
						"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+              ; //[6]
						Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
						Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)}                          //[7]I.E

  Local aDadosBanco
  Local aDatPagador
  Local aBolText := {"","","","","",""}

  Local aCB_RN_NN    := {}
  Local nVlrAbat     := 0

  Private cNroDoc :=  " "
  Private aDadosTit
  
  oPrint:= TMSPrinter():New( "Boleto Laser" ) 
  oPrint:SetPortrait()
  oPrint:StartPage()   // Inicia uma nova p�gina

  dbGoTop()
  
  ProcRegua(RecCount()) 
  
  Do while !EOF()
     dDataIni := mv_par11
     cDocumen := E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA
     
     Do while !EOF() .And. cDocumen == E1_PREFIXO+E1_NUM+E1_CLIENTE+E1_LOJA
        IncProc()

        If E1_OK <> cMarca
           dbSkip()
           Loop
        Endif

        // Calcula o total de parcelas geradas para o titulo
        cQuery := "SELECT MAX(E1_PARCELA)E1_PARCELA FROM "+RetSQLName("SE1")+" WHERE D_E_L_E_T_=' ' AND E1_FILIAL='"
        cQuery += SE1->(XFILIAL())+"' AND E1_NUM='"+E1_NUM+"' AND E1_PREFIXO='"+E1_PREFIXO+"' AND E1_CLIENTE='"
        cQuery += E1_CLIENTE+"' AND E1_LOJA='"+E1_LOJA+"'"
        dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "YYY", .T., .F. )
        cMaxPar := E1_PARCELA
        dbCloseArea()
        dbSelectArea("SE1")

        //- Parametros banco,agencia, conta
        cBanco   := Substr(GetMv("MV_XBCBB"),01,03)   
        cAgencia := Substr(GetMv("MV_XAGBB"),01,05)   
        cConta   := Substr(GetMv("MV_XCCBB"),01,10)      
        cSbConta := Substr(GetMv("MV_XSBBB"),01,03)

        //- Posiciona o SA6 (Bancos) 
        DbSelectArea("SA6")
        DbSetOrder(1)
        DbSeek(xFilial("SA6")+cBanco+PadR(cAgencia,05)+PadR(cConta,10),.T.)

        //- Posiciona na Arq de Parametros CNAB
        DbSelectArea("SEE")
        DbSetOrder(1)
        DbSeek(xFilial("SEE")+cBanco+PadR(cAgencia,05)+PadR(cConta,10)+PadR(cSbConta,03),.T.)
	
        //- Posiciona o SA1 (Cliente)
        DbSelectArea("SA1")
        DbSetOrder(1)
        DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
        DbSelectArea("SE1")
        aDadosBanco := {SA6->A6_COD,;                                                             // [1]Codigo do Banco
                        SA6->A6_NREDUZ,;                                                          // [2]Nome do Banco
                        SUBSTR(SA6->A6_AGENCIA, 1, 5),;                                           // [3]Ag�ncia
                        StrTran(SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),"-",""),; // [4]Conta Corrente
                        SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1),;                   // [5]D�gito da conta corrente
                        "17",;                                                                    // [6]Codigo da Carteira
                        SA6->A6_NUMBCO}                                                           // [7]Numero do Banco
      
        If Empty(SA1->A1_ENDCOB) 
           aDatPagador:= {AllTrim(SA1->A1_NOME)  ,;  // [1]Raz�o Social
           AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA,;  // [2]C�digo
           AllTrim(SA1->A1_END )                 ,;  // [3]Endere�o
           AllTrim(SA1->A1_MUN )                 ,;  // [4]Cidade
           SA1->A1_EST                           ,;  // [5]Estado
           SA1->A1_CEP                           ,;  // [6]CEP
           SA1->A1_CGC							 ,;  // [7]CGC
           SA1->A1_PESSOA						 ,;  // [8]PESSOA
           AllTrim(SA1->A1_BAIRRO) }                 // [9]Bairro   
        Else
           aDatPagador:= {AllTrim(SA1->A1_NOME)  ,;  // [1]Raz�o Social
           AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA,;  // [2]C�digo
           AllTrim(SA1->A1_END)                  ,;  // [3]Endere�o
           AllTrim(SA1->A1_MUN)	                 ,;  // [4]Cidade
           SA1->A1_EST	                         ,;  // [5]Estado
           SA1->A1_CEP                           ,;  // [6]CEP
           SA1->A1_CGC							 ,;	 // [7]CGC
           SA1->A1_PESSOA						 ,;  // [8]PESSOA
           AllTrim(SA1->A1_BAIRRO) }                 // [9]Bairro   
        Endif

        nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
        nDescFin := Round(SE1->E1_SALDO * SE1->E1_DESCFIN / 100,2)

        //Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo. 
        //Abaixo apenas uma sugestao
        cNroDoc := Strzero(Val(Alltrim(SE1->E1_NUM)),Len(SE1->E1_NUM))+StrZERO(Val(Alltrim(SE1->E1_PARCELA)),Len(SE1->E1_PARCELA))
        cNroDoc := STRZERO(Val(cNroDoc),11)

        aCB_RN_NN := Ret_cBarra( SE1->E1_PREFIXO , SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO,;
                     Subs(aDadosBanco[1],1,3), aDadosBanco[3], aDadosBanco[4], aDadosBanco[5],;
                     aDadosBanco[7], cNroDoc , (SE1->E1_SALDO - (nVlrAbat/*+nDescFin*/)+SE1->E1_ACRESC - SE1->E1_DECRESC), "18", "9") 

        aDadosTit := {E1_NUM+If(Empty(E1_PARCELA),"","-"+E1_PARCELA)+;
                      If(Empty(cMaxPar),"","/"+cMaxPar)  ,;  // [1] N�mero do t�tulo
                      E1_EMISSAO                         ,;  // [2] Data da emiss�o do t�tulo
                      dDataBase                          ,;  // [3] Data da emiss�o do boleto
                      E1_VENCTO                         ,;  // [4] Data do vencimento
                      (E1_SALDO - nVlrAbat + E1_ACRESC - E1_DECRESC)  ,;  // [5] Valor do t�tulo
                      aCB_RN_NN[3]                       ,;  // [6] Nosso n�mero (Ver f�rmula para calculo)
                      E1_PREFIXO                         ,;  // [7] Prefixo da NF
                      "DM"                               ,;  // [8] Tipo do Titulo  // Antes -> E1_TIPO
                      nDescFin							}  // [9] Decrescimo    

	    aBolText := {"","","","","",""}

	    aBolText[1]:= "Juros de mora de R$ "+Transform((SE1->E1_SALDO - nVlrAbat - SE1->E1_DECRESC + SE1->E1_ACRESC) / 300, "@E 99.99")+" por dia corrido"
        aBolText[2]:= "Multa de 2%"
        aBolText[3]:= "Protestar apos 7 dias corridos apos o vencimento" 
        aBolText[4]:= "Deposito em conta somente com identifica��o" 
        aBolText[5]:= "A partir de 01/03/12 n�o aceitaremos pagamento de boletos em nossas lojas"
        aBolText[6]:= "" 
      
        Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatPagador,aBolText,aCB_RN_NN)

        dbSkip()
     Enddo
  Enddo
  oPrint:EndPage()     // Finaliza a p�gina
  oPrint:Preview()     // Visualiza antes de imprimir
Return nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  Impress � Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatPagador,aBolText,aCB_RN_NN)
LOCAL oFont7
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0
Local cStartPath := GetSrvProfString("StartPath","")
Local cBmp := 030

cBmp := cStartPath + "BBRASIL.BMP" //Logo do Banco do Brasil

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont7   := TFont():New("Arial"      ,9, 7,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8   := TFont():New("Arial"      ,9, 8,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8n  := TFont():New("Arial"      ,9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial"      ,9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial"      ,9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial"      ,9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont18  := TFont():New("Arial"      ,9,18,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial"      ,9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial"      ,9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial"      ,9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial"      ,9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial"      ,9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial"      ,9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial"      ,9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova p�gina

/******************/
/* PRIMEIRA PARTE */
/******************/
cString01 := Alltrim(Substr(aDadosBanco[3],1,4)+"-"+substr(aDadosBanco[3],5,1)+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]) // Agencia/codigo benefici�rio
cString02 := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4) // Vencimento

If Len(AllTrim(aDadosTit[6])) < 13
   cString03 := Transform(aDadosTit[6],"@R 99999999999-9")
Else
   cString03 := Transform(aDadosTit[6],"@R 99999999999999999")
Endif
cString04 := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))

nRow1 := 0

If File(cBmp)
   oPrint:SayBitmap(nRow1+0080,100,cBmp,75,65)
Endif

oPrint:Say  (nRow1+0080,180 ,"BANCO DO BRASIL" ,oFont14 )     // [2]Nome do Banco

oPrint:Say  (nRow1+0084,1900,"Comprovante de Entrega",oFont10)

oPrint:Line (nRow1+0150,100,nRow1+0150,2300)

oPrint:Say  (nRow1+0150,100, "Benefici�rio",oFont8)
oPrint:Say  (nRow1+0200,100, aDadosEmp[1], oFont8n) //Nome + CNPJ

oPrint:Say  (nRow1+0150,1060,"Ag�ncia/C�digo Benefici�rio",oFont8)
oPrint:Say  (nRow1+0200,1060, cString01, oFont8) 

oPrint:Say  (nRow1+0150,1510,"Nro.Documento",oFont8)
oPrint:Say  (nRow1+0200,1510,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela  

oPrint:Say  (nRow1+0250,100 ,"Nome Pagador",oFont8)
oPrint:Say  (nRow1+0300,100 ,aDatPagador[1],oFont10) //Nome pagador

oPrint:Say  (nRow1+0250,1060,"Vencimento",oFont8)
oPrint:Say  (nRow1+0300,1060, cString02, oFont8)

oPrint:Say  (nRow1+0250,1220,"Nosso N�mero",oFont8)

oPrint:Say  (nRow1+0300,1220,cString03,oFont8) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0250,1510,"Valor do Documento",oFont8)
oPrint:Say  (nRow1+0300,1550, cString04, oFont10)

oPrint:Say  (nRow1+0400,0100,"Recebi(emos) o bloqueto/t�tulo",oFont10)
oPrint:Say  (nRow1+0450,0100,"com as caracter�sticas acima.",oFont10)
oPrint:Say  (nRow1+0350,1060,"Data",oFont8)
oPrint:Say  (nRow1+0350,1410,"Assinatura",oFont8)
oPrint:Say  (nRow1+0450,1060,"Data",oFont8)
oPrint:Say  (nRow1+0450,1410,"Entregador",oFont8)

oPrint:Line (nRow1+0250, 100,nRow1+0250,1900 ) 
oPrint:Line (nRow1+0350, 100,nRow1+0350,1900 )   
oPrint:Line (nRow1+0450,1050,nRow1+0450,1900 ) //---
oPrint:Line (nRow1+0550, 100,nRow1+0550,2300 )

oPrint:Line (nRow1+0550,1050,nRow1+0150,1050 )
oPrint:Line (nRow1+0550,1400,nRow1+0350,1400 )
oPrint:Line (nRow1+0350,1500,nRow1+0150,1500 ) //--
oPrint:Line (nRow1+0550,1900,nRow1+0150,1900 )

oPrint:Say  (nRow1+0165,1910,"(  )Mudou-se"                                	,oFont8)
oPrint:Say  (nRow1+0205,1910,"(  )Ausente"                                  ,oFont8)
oPrint:Say  (nRow1+0245,1910,"(  )N�o existe n� indicado"                  	,oFont8)
oPrint:Say  (nRow1+0285,1910,"(  )Recusado"                                	,oFont8)
oPrint:Say  (nRow1+0325,1910,"(  )N�o procurado"                            ,oFont8)
oPrint:Say  (nRow1+0365,1910,"(  )Endere�o insuficiente"                  	,oFont8)
oPrint:Say  (nRow1+0405,1910,"(  )Desconhecido"                            	,oFont8)
oPrint:Say  (nRow1+0445,1910,"(  )Falecido"                                 ,oFont8)
oPrint:Say  (nRow1+0485,1910,"(  )Outros(anotar no verso)"                  ,oFont8)

/*****************/
/* SEGUNDA PARTE */
/*****************/
nRow1 := nRow1 + 625
 
If File(cBmp)
   oPrint:SayBitmap(nRow1+0080,100,cBmp,75,65)
Endif
oPrint:Say  (nRow1+0080,180 ,"BANCO DO BRASIL" ,oFont14 )     // [2]Nome do Banco

nRow1 += 20
oPrint:Say  (nRow1+0080,1750,"Cobran�a Integrada BB" ,oFont14 )     // Legenda do Cabecalho

oPrint:Line (nRow1+0250,100,nRow1+0250,2300 ) //- 1a. Linha horizontal
oPrint:Line (nRow1+0350,100,nRow1+0350,2300 ) //- 2a. Linha horizontal
oPrint:Line (nRow1+0450,100,nRow1+0450,2300 ) //- 3a. Linha horizontal

oPrint:Line (nRow1+0250, 620,nRow1+0450, 620) //- 1a. coluna vertical
oPrint:Line (nRow1+0250,1060,nRow1+0350,1060) //- 2a. coluna vertical
oPrint:Line (nRow1+0150,1700,nRow1+0450,1700) //- 3a. coluna vertical
oPrint:Line (nRow1+0150,2040,nRow1+0350,2040) //- 4a. coluna vertical
           
oPrint:Say  (nRow1+0150,100 ,"Benefici�rio",oFont8n)
oPrint:Say  (nRow1+0195,100 ,aDadosEmp[1]+" "+aDadosEmp[6]+" - "+aDadosEmp[2]+" - "+aDadosEmp[3],oFont8n) //Nome + CNPJ

oPrint:Say  (nRow1+0150,1710,"Vencimento",oFont8n)

cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	:= 1710 + Int((380-(len(cString)*22))/2)
oPrint:Say  (nRow1+0195,nCol,cString,oFont8n)

oPrint:Say  (nRow1+0150,2050,"Valor do Documento",oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	:= 1810+(374-(len(cString)*22))
oPrint:Say  (nRow1+0195,nCol,cString,oFont8n)

oPrint:Say  (nRow1+0260,100,"(-)Desconto"                                  ,oFont8n)
cString := Alltrim(Transform(aDadosTit[9],"@EZ 99,999,999.99"))
nCol := 250+(374-(len(cString)*22))
oPrint:Say  (nRow1+0260,nCol,cString ,oFont11c)

oPrint:Say  (nRow1+0260, 630,"(-)Outras Dedu��es"                          ,oFont8n)
oPrint:Say  (nRow1+0260,1070,"(+)Mora / Multa"                             ,oFont8n)

oPrint:Say  (nRow1+0260,1710,"(+)Outros Acr�scimos"                        ,oFont8n)

oPrint:Say  (nRow1+0260,2050,"(=)Valor Cobrado"                            ,oFont8n)

oPrint:Say  (nRow1+0360,100 ,"Data de Emiss�o"                             ,oFont8n)
cString  := StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4)
nCol 	 := 100 + Int((430-(len(cString)*22))/2)
oPrint:Say  (nRow1+0400,nCol, cString , oFont10)

oPrint:Say  (nRow1+0360, 630,"Ag�ncia / C�digo Benefici�rio",oFont8n)
cString  := Alltrim(substr(aDadosBanco[3],1,4)+"-"+substr(aDadosBanco[3],5,1)+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol 	 := 630+(374-(len(cString)*22))
oPrint:Say  (nRow1+0400,nCol,cString ,oFont10)

oPrint:Say  (nRow1+0360,1710,"Nosso N�mero"                                ,oFont8n)

If Len(AllTrim(aDadosTit[6])) < 13
   cString  := Transform(aDadosTit[6],"@R 99999999999-9")
Else
   cString  := Transform(aDadosTit[6],"@R 99999999999999999")
Endif
nCol 	 := 2300 - (len(cString)*26)
oPrint:Say  (nRow1+0400,nCol,cString,oFont10)

oPrint:Say  (nRow1+0500, 100,"Dados do Pagador" ,oFont10)

oPrint:Line (nRow1+0640,100,nRow1+0640,2300 ) //- 4a. Linha horizontal
oPrint:Line (nRow1+0740,100,nRow1+0740,2300 ) //- 5a. Linha horizontal
oPrint:Line (nRow1+0840,100,nRow1+0840,2300 ) //- 6a. Linha horizontal

oPrint:Line (nRow1+0540,1900,nRow1+0640,1900 )
oPrint:Line (nRow1+0640,1700,nRow1+0840,1700)
oPrint:Line (nRow1+0740,1900,nRow1+0840,1900 )
              
oPrint:Say  (nRow1+0540,100 ,"Nome do Pagador"  ,oFont8n)
oPrint:Say  (nRow1+0585,145 ,aDatPagador[1]+" CPF/CNPJ:"+aDatPagador[7]      ,oFont10)

oPrint:Say  (nRow1+0540,1910,"N�mero.Documento"                             ,oFont8n)
oPrint:Say  (nRow1+0585,1910,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow1+0650,100 ,"Endere�o"                                     ,oFont8n)
oPrint:Say  (nRow1+0695,145 ,aDatPagador[3]                                  ,oFont10)

oPrint:Say  (nRow1+0650,1710,"Bairro / Distrito"                            ,oFont8n)
oPrint:Say  (nRow1+0695,1750,aDatPagador[9]                                  ,oFont10)

oPrint:Say  (nRow1+0750,100 ,"Munic�pio"                                    ,oFont8n)
oPrint:Say  (nRow1+0795,145 ,aDatPagador[4]                                  ,oFont10)

oPrint:Say  (nRow1+0750,1710,"UF"                                           ,oFont8n)
oPrint:Say  (nRow1+0795,1750,aDatPagador[5]                                  ,oFont10)

oPrint:Say  (nRow1+0750,1910,"CEP"                                          ,oFont8n)
oPrint:Say  (nRow1+0795,1950,Transform(aDatPagador[6],"@R 99999-999")        ,oFont10)

oPrint:Say  (nRow1+0870,100 ,"Mensagem"                                     ,oFont8n)

oPrint:Line (nRow1+1470-470,100,nRow1+1470-470,2300 ) //nRow1+1840  - alterei para 1340

oPrint:Say  (nRow1+1480-470,1480,"Autentica��o Mec�nica"                        ,oFont8n)
oPrint:Say  (nRow1+1480-470,1810,"Recibo do Pagador" ,oFont10)

oPrint:Line (nRow1+1490-470,1280,nRow1+1490-470,1380 )
oPrint:Line (nRow1+1490-470,2200,nRow1+1490-470,2300 )
oPrint:Line (nRow1+1490-470,1280,nRow1+1550-470,1280 )
oPrint:Line (nRow1+1490-470,2300,nRow1+1550-470,2300 )

vMens    := Array(4)
vMens[1] := "Este recibo somente ter� validade com a autentica��o mec�nica ou acompanhado do"
vMens[2] := "recibo de pagamento emitido pelo Banco."
vMens[3] := "Recebimento atrav�s do cheque n.                                             do banco"
vMens[4] := "Esta quita��o s� ter� validade ap�s o pagamento do cheque pelo banco pagador."

oPrint:Say  (nRow1+1570-470,100 , vMens[1]                                     ,oFont8n)
oPrint:Say  (nRow1+1600-470,100 , vMens[2]                                     ,oFont8n)
oPrint:Say  (nRow1+1630-470,100 , vMens[3]                                     ,oFont8n)
oPrint:Say  (nRow1+1660-470,100 , vMens[4]                                     ,oFont8n)

/*****************/
/* SEGUNDA PARTE */
/*****************/

nRow2 := nRow1 + 725-470 //1025 - alterei para 525

/******************/
/* TERCEIRA PARTE */
/******************/

nRow3 := nRow2 +  1085 - 120

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+0030, nI, nRow3+0030, nI+30)
Next nI

oPrint:Line (nRow3+0150,100,nRow3+0150,2300)
oPrint:Line (nRow3+0080,660,nRow3+0150, 660)
oPrint:Line (nRow3+0080,850,nRow3+0150, 850)

If File(cBmp)
   oPrint:SayBitmap(nRow3+0080,100,cBmp,75,65)
Endif
oPrint:Say  (nRow3+0080,180,"BANCO DO BRASIL" ,oFont14 )  // [2]Nome do Banco

oPrint:Say  (nRow3+0075,673,aDadosBanco[1]+"-9",oFont18 )  // [1]Numero do Banco
oPrint:Say  (nRow3+0084,890,aCB_RN_NN[2],oFont14)          // Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+0250,100,nRow3+0250,2300 )
oPrint:Line (nRow3+0350,100,nRow3+0350,2300 )
oPrint:Line (nRow3+0420,100,nRow3+0420,2300 )
oPrint:Line (nRow3+0490,100,nRow3+0490,2300 )

oPrint:Line (nRow3+0350,500 ,nRow3+0490,500 )
oPrint:Line (nRow3+0420,750 ,nRow3+0490,750 )
oPrint:Line (nRow3+0350,1000,nRow3+0490,1000)
oPrint:Line (nRow3+0350,1300,nRow3+0420,1300)
oPrint:Line (nRow3+0350,1480,nRow3+0490,1480)

oPrint:Say  (nRow3+0150,100 ,"Local de Pagamento",oFont8n)
oPrint:Say  (nRow3+0190,100 ,"Pag�vel em qualquer banco at� o vencimento. Ap�s, atualize o boleto no site bb.com.br.",oFont10)
           
oPrint:Say  (nRow3+0150,1810,"Vencimento",oFont8n)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0190,nCol,cString,oFont11c)

oPrint:Say  (nRow3+0250,100 ,"Benefici�rio",oFont8n)
oPrint:Say  (nRow3+0290,100 ,aDadosEmp[1]+" "+aDadosEmp[6]+" - "+aDadosEmp[2]+" - "+aDadosEmp[3],oFont8n) //Nome + CNPJ

oPrint:Say  (nRow3+0250,1810,"Ag�ncia / C�digo Benefici�rio",oFont8n)
cString  := Alltrim(substr(aDadosBanco[3],1,4)+"-"+substr(aDadosBanco[3],5,1)+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0290,nCol,cString ,oFont11c)

oPrint:Say  (nRow3+0350,100 ,"Data do Documento"                              ,oFont8n)
oPrint:Say  (nRow3+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+0350,505 ,"N�mero.Documento"                             ,oFont8n)
oPrint:Say  (nRow3+0380,605 ,aDadosTit[7]+aDadosTit[1]                      ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+0350,1005,"Esp�cie Documento"                            ,oFont8n)
oPrint:Say  (nRow3+0380,1050,aDadosTit[8]                                   ,oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+0350,1305,"Aceite"                                       ,oFont8n)
oPrint:Say  (nRow3+0380,1400,"N"                                            ,oFont10)

oPrint:Say  (nRow3+0350,1485,"Data do Processamento"                        ,oFont8n)
oPrint:Say  (nRow3+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+0350,1810,"Nosso N�mero"                                 ,oFont8n)
If Len(AllTrim(aDadosTit[6])) < 13
   cString  := Transform(aDadosTit[6],"@R 99999999999-9")
Else
   cString  := Transform(aDadosTit[6],"@R 99999999999999999")
Endif
nCol 	 := 1880+(374-(len(cString)*22))
oPrint:Say  (nRow3+0380,nCol,cString,oFont11c)

oPrint:Say  (nRow3+0420,100 ,"Uso do Banco"                                 ,oFont8n)
oPrint:Say  (nRow3+0450,150 ,"           "                                  ,oFont10)

oPrint:Say  (nRow3+0420,505 ,"Carteira"                                     ,oFont8n)
oPrint:Say  (nRow3+0450,555 ,aDadosBanco[6]+"/027"                          ,oFont10)

oPrint:Say  (nRow3+0420,755 ,"Moeda"                                        ,oFont8n)
oPrint:Say  (nRow3+0450,805 ,"R$"                                           ,oFont10)

oPrint:Say  (nRow3+0420,1005,"Quantidade"                                   ,oFont8n)
oPrint:Say  (nRow3+0420,1485,"Valor"                                        ,oFont8n)

oPrint:Say  (nRow3+0420,1810,"Valor do Documento"                          	,oFont8n)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0450,nCol,cString,oFont11c)

oPrint:Say  (nRow3+0490,100 ,"Instru��es (texto de responsabilidade do benefici�rio)",oFont8n)
oPrint:Say  (nRow3+0530,100 ,aBolText[1]  ,oFont10)
oPrint:Say  (nRow3+0570,100 ,aBolText[2]  ,oFont10)
oPrint:Say  (nRow3+0610,100 ,aBolText[3]  ,oFont10)
oPrint:Say  (nRow3+0660,100 ,aBolText[4]  ,oFont10)
oPrint:Say  (nRow3+0710,100 ,aBolText[5]  ,oFont10)
//oPrint:Say  (nRow3+0760,100 ,aBolText[6]  ,oFont10)

oPrint:Say  (nRow3+0490,1810,"(-)Desconto / Abatimento"                    ,oFont8n)
cString :=  ""
nCol := 1810+(374-(len(cString)*22))
oPrint:Say  (nRow3+0520,nCol,cString ,oFont11c)

oPrint:Say  (nRow3+0560,1810,"(-)Outras Dedu��es"                          ,oFont8n)
oPrint:Say  (nRow3+0630,1810,"(+)Mora / Multa"                             ,oFont8n)
oPrint:Say  (nRow3+0700,1810,"(+)Outros Acr�scimos"                        ,oFont8n)
oPrint:Say  (nRow3+0770,1810,"(=)Valor Cobrado"                            ,oFont8n)

oPrint:Say  (nRow3+0840,100 ,"Pagador"                                     ,oFont8n)
oPrint:Say  (nRow3+0870,200 ,aDatPagador[1]+" CPF/CNPJ:"+aDatPagador[7]     ,oFont10)

oPrint:Say  (nRow3+0840,1810,"Ficha de Compensa��o"                        ,oFont11)

oPrint:Say  (nRow3+0923,200 ,aDatPagador[3]+" - "+aDatPagador[9]           ,oFont10)
oPrint:Say  (nRow3+0976,200 ,Transform(aDatPagador[6],"@R 99999-999")+"    "+aDatPagador[4]+" - "+aDatPagador[5],oFont10) // CEP+Cidade+Estado

oPrint:Say  (nRow3+0976,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4),oFont10)

oPrint:Say  (nRow3+1025,1700,"Autentica��o Mec�nica",oFont8n)

oPrint:Line (nRow3+0150,1800,nRow3+0840,1800 )
oPrint:Line (nRow3+0560,1800,nRow3+0560,2300 )
oPrint:Line (nRow3+0630,1800,nRow3+0630,2300 )
oPrint:Line (nRow3+0700,1800,nRow3+0700,2300 )
oPrint:Line (nRow3+0770,100 ,nRow3+0770,2300 )
oPrint:Line (nRow3+0840,100 ,nRow3+0840,2300 )

oPrint:Line (nRow3+1020,100 ,nRow3+1020,2300 )

//MSBAR2("INT25",  12.5,      1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.014   ,1.0    ,Nil,Nil,"A",.F.,100,100)
MSBAR2("INT25",24.7,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.7,Nil,Nil,"A",.F.,100,100)

DbSelectArea("SE1")

oPrint:EndPage() // Finaliza a p�gina

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �RetDados  �Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera SE1                        					          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Ret_cBarra(	cPrefixo,cNumero,cParcela,cTipo,cBanco,cAgencia,cConta,;
                            cDacCC,cNumBco,cNroDoc,nValor,cCart,cMoeda)
  Local cDigNosso  := ""
  Local cCampoL	   := ""
  Local cFatorValor:= ""
  Local cLivre	   := ""
  Local cDigBarra  := ""
  Local cBarra	   := ""
  Local cParte1	   := ""
  Local cDig1	   := ""
  Local cParte2	   := ""
  Local cDig2	   := ""
  Local cParte3	   := ""
  Local cDig3	   := ""
  Local cParte4	   := ""
  Local cParte5	   := ""
  Local cDigital   := ""
  Local aRet	   := {}
  Local cNumTmp    := ""
  Local lConv6Dig  := (Len(AllTrim(SEE->EE_CODEMP)) == 6)   // Conv�nio 6 d�gitos
  Local cNosso	   := SE1->E1_NRDOC // SE1->E1_NUMBCO

  cAgencia := Left(Alltrim(cAgencia),4)

  If Empty(cNosso)   // Se ainda n�o foi calculado o nosso n�mero  
   
     cNumTmp:= NossoNum()

     If lConv6Dig   // Conv�nio 6 d�gitos 
        cNumTmp := Str(Val(cNumTmp),5) 
        cNosso := PADR(StrTran(StrTran(StrTran(SEE->EE_CODEMP,"/",""),"-",""),".",""),6) + strzero(Val(cNumTmp),5)
        cNosso += CALC_5p( cNosso ,.T.) 
     Else 
        // Conv�nio com 07 digitos      
        cNumTmp := Str(Val(cNumTmp),10)
        cNosso := PADR(StrTran(StrTran(StrTran(SEE->EE_CODEMP,"/",""),"-",""),".",""),7) + strzero(Val(cNumTmp),10)
        //cNosso += u_CALC_5p( cNosso ,.T.)        
     Endif
  Endif

  If lConv6Dig   // Conv�nio 6 d�gitos
     cCampoL := PADR(cNosso,11) + cAgencia + StrZero(Val(Left(cConta,5)),8)  + "17"
  Else
     //Campo Livre
     cCampoL := StrZero(0,6)+SubStr(cNosso,1,17) + "17"
  Endif

  // Campo livre do codigo de barra e verificar a conta
  If nValor <= 0
     nValor := SE1->E1_SALDO
  Endif

  cFatorValor := Fator(SE1->E1_VENCTO) + StrZero(nValor * 100,10)

  cLivre := cBanco+cMoeda+cFatorValor+cCampoL

  // campo do codigo de barra
  cDigBarra := CALC_5p( cLivre )
  cBarra    := SubStr(cLivre,1,4)+cDigBarra+SubStr(cLivre,5,39)

  // composicao da linha digitavel
  cParte1  := cBanco + cMoeda + SubStr(cCampoL,1,5)
  cDig1    := DIGIT001( cParte1 )
  cParte2  := SUBSTR(cCampoL,6,10)
  cDig2    := DIGIT001( cParte2 )
  cParte3  := SUBSTR(cCampoL,16,10)
  cDig3    := DIGIT001( cParte3 )
  cParte4  := cDigBarra
  cParte5  := cFatorValor

  cDigital := substr(cParte1,1,5)+"."+substr(cParte1,6,4)+cDig1+" "+;
    		  substr(cParte2,1,5)+"."+substr(cParte2,6,5)+cDig2+" "+;
			  substr(cParte3,1,5)+"."+substr(cParte3,6,5)+cDig3+" "+;
			  cParte4+" "+;
			  cParte5

  Aadd(aRet,cBarra)
  Aadd(aRet,cDigital)
  Aadd(aRet,cNosso)

  DbSelectArea("SE1")
  RecLock("SE1",.F.)
  //SE1->E1_NUMBCO := cNosso //- Nosso n�mero
  SE1->E1_NRDOC := cNosso   //- Nosso n�mero
  MsUnlock()

Return aRet

/*/
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSx1    � Autor � Microsiga            	� Data � 13/10/03 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica/cria SX1 a partir de matriz para verificacao          ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                    	  		���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next 
return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CALC_5p   �Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do digito do nosso numero do                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CALC_5p(cVariavel,lNosso)
   Local cBase, nBase, nAux, nSumDig, nDig
   Local nCli := If( Upper(TCGetDB()) == "MSSQL" , 1, 2)   // 1=Unisol, 2=Muraki

   cBase   := cVariavel
   nBase   := 2
   nSumDig := 0
   nAux    := 0
   For nDig:=Len(cBase) To 1 Step -1
      nAux    := Val(SubStr(cBase, nDig, 1)) * nBase
      nSumDig += nAux
      nBase   += If( nBase == 9 , -7, 1)
   Next

   If nCli == 1
      nAux := Mod(nSumDig * 10,11)
      If nAux == 0 .Or. nAux == 10
         If lNosso
            nAux := 0
         Else
            nAux := 1
         Endif
      Endif
   Else
      nAux := 11 - Mod(nSumDig,11)
      If nAux >= 10
         nAux := 1
      Endif
   EndIf

Return(Str(nAux,1))
                                                                  
                                                                  /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �FATOR		�Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do FATOR  de vencimento para linha digitavel.       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fator(dVencto)
   Local cData  := DTOS(dVencto)
   Local cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
Return(cFator) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �DIGIT001  �Autor  �Microsiga           � Data �  02/13/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Para calculo da linha digitavel do Unibanco                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � BOLETOS                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DIGIT001(cVariavel)
   Local cBase, nUmDois, nSumDig, nDig, nAux, cValor, nDezena

   cBase   := cVariavel
   nUmDois := 2
   nSumDig := 0
   nAux    := 0
   For nDig:=Len(cBase) To 1 Step -1
      nAux    := Val(SubStr(cBase, nDig, 1)) * nUmDois
      nSumDig += (nAux - If( nAux < 10 , 0, 9))
      nUmDois := 3 - nUmDois
   Next
   cValor := AllTrim(Str(nSumDig,12))
   nAux   := 10 - Val(SubStr(cValor,Len(cValor),1))
   //nDezena := Val(AllTrim(Str(Val(SubStr(cValor,1,1))+1,12))+"0")
   //nAux    := nDezena - nSumDig

   If nAux == 10
      nAux := 0
   EndIf

Return(Str(nAux,1))        