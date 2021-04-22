#include "ap5mail.ch"
#include "Protheus.ch"
#include  "TbiConn.ch"
 
User Function AGWKF06
  Local _aArea

  //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

  //ConOut("ENTROU!")
 
  _aArea := GetArea()

  lContinua:= .T. //fGetBaixasCR(cFilSE5,cPref,cNum,cParc,cBanco,cAgencia,cConta)

  If lContinua
     ResumoCX()
  Endif
  RestArea(_aArea)

  //ConOut("FUNCIONOU!")
 
  //RESET ENVIRONMENT
 
Return .T.
                
/////////////////////////
Static Function ResumoCX  
  Local cMsgA      := ""
  Local cAccount   := "vendas1@agropisco.com.br"            // "workflow@potencial.inf.br" -> Trim(GetMv("MV_RELACNT"))  
  Local cServer    := "smtp.office365.com:587"              // "mail.potencial.inf.br:587" -> Trim(GetMv("MV_RELSERV"))  
  Local cPass      := "Agro@123"                            // "workflow007"               -> Trim(GetMv("MV_RELPSW"))  
  Local cEmailV    := "reinaldo.magalhaes2014@gmail.com"    // "reinaldo.magalhaes@potencial.inf.br,michelle@agropisco.com.br,aline@agropisco.com.br" -> Trim(GetMv("MV_EMAILV"))
  Local lRet       := .T.
  Local lResult    := .T.
  Local aOrd           := {}
  
  Private cSubject := "Resumo de Caixa dia " + Dtoc(dDatabase) //assunto do email

  cMsgA := InicioMsg()
  cMsgA += fRodape()

  LjMsgRun("Conectando com o servidor SMTP: " + cServer)

  CONNECT SMTP SERVER cServer ;
          ACCOUNT cAccount ;
          PASSWORD cPass ; 
          RESULT lResult
                                    
  //Se a conexao com o SMPT esta ok
  If lResult .And. GetMv("MV_RELAUTH")
      //Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
  	  lResult := MailAuth(cAccount, AllTrim(cPass))
  	  //Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
  	  If !lResult
  	      nAt 	:= At("@",cAccount)
  		  cUser 	:= If(nAt>0,Subs(cAccount,1,nAt-1),cAccount)
  		  lResult := MailAuth(cUser, AllTrim(cPass))
  	  Endif
  Endif
  If lResult
      SEND MAIL FROM cAccount TO ;
	               cEmailV ;
	               SUBJECT cSubject ;
	               BODY cMsgA ;
	               RESULT lResult
	
	  If !lResult
	      GET MAIL ERROR cSmtpError
	      MsgSTop( "Erro de envio 01: " + cSmtpError)
	  Else
	      MsgSTop("E-mail enviado para " + cEmailV)	
	  EndIf
	 DISCONNECT SMTP SERVER
  Else
     GET MAIL ERROR cSmtpError
     MsgSTop( "Erro de envio 02: " + cSmtpError)
	 //GET MAIL ERROR CERROR
  EndIf
Return lRet

/////////////////////////
Static Function fRodape()
  Local cMsg  := " "
  cMsg += ' <br />'
  cMsg += ' </body>'
  cMsg += ' </html>'
Return cMsg

///////////////////////////
Static Function InicioMsg()
  Local cFilia := xFilial("SE1")
  Local cData  := Dtos(dDatabase)

  Private nDinheiro := 0, nChequeAv := 0, nChequePr := 0, nCCAura   := 0, nCCDebito := 0, nCCVisa   := 0, nCCMaster := 0, nCCAmeric := 0, nCCDinner := 0
  Private nCCVisaEl := 0, nCCRedeSh := 0, nCCCheque := 0, nBolBanco := 0, nNotaProm := 0, nDepConta := 0, nCarteira := 0, nSaldo    := 0, nDuplicat := 0
  Private nCrediari := 0, nEmpenho  := 0, nChequeLi := 0, nBoletoLi := 0, nTransfer := 0, nEntrada  := 0, nSaida    := 0, nOutrosPg := 0, nSemClien := 0
  Private nTotNotas := 0, nTotDesco := 0, nTotCredi := 0, nTotTroca := 0, nTotDevol := 0, nTotBrind := 0, nTotConsu := 0, nTotBruto := 0, nSubTotal := 0
  Private nTotLiqui := 0, nTotApoli := 0  
  
  Private cMinApoli := ""
  Private cMaxApoli := ""
  Private nTotFatur := 0

  //- Bancos
  DbSelectArea("SA6")
  DbSetOrder(1)
  
  //- Saldo bancarios
  DbSelectArea("SE8")
  DbSetOrder(1)

  PegaResumo()
 
  nTotLiqui := nDinheiro + nChequeAv + nChequePr + nCCVisa   + nCCMaster + nCCAmeric + nCCDinner + nCCVisaEl
  nTotLiqui += nCCRedeSh + nCCCheque + nBolBanco + nDepConta + nNotaProm + nCarteira + nDuplicat + nCrediari + nEmpenho + nCCDebito +  nCCAura + nChequeLi + nBoletoLi + nTotFatur
  nTotLiqui += nOutrosPg + nSemClien - nTotDevol

  nSubTotal := nTotLiqui + nTotDevol
  nTotBruto := nSubTotal + nTotDesco + nTotTroca  + nTotCredi

    //-- Inicio de envio do email
  cMsg := ' <html> '
  cMsg += ' <head> '
  cMsg += ' <title>' + cSubject + '</title> '
  cMsg += ' </head>'
  cMsg += ' <body> ' 
	
  cMsg += ' <b>Caixa </b>' + 'C01,C02,C03,C04,C05' + ' <br /> '
  cMsg += ' <b>Data : </b>' + Dtoc(dDatabase) + ' <br /> '  

  //--- Inicio da tabela
  cMsg += ' <table width="100%" border="1" cellspacing="0" cellpadding="5">'
  cMsg += ' <caption><h2>' + cSubject + '</h2></caption>'
  
  cMsg += ' <tr>'
  cMsg += ' <td>' + "TOTAL BRUTO EM NOTAS      : "+Transform(nTotBruto,"@E 999,999,999.99") + '</td>'
  cMsg += ' </tr>'        
  
  cMsg += ' <tr>'
  cMsg += ' <td>' + "DESCONTOS CONCEDIDOS      : "+Transform(nTotDesco,"@E 999,999,999.99") + '</td>'
  cMsg += ' </tr>'        

  If nTotCredi <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CREDITOS CONCEDIDOS       : "+Transform(nTotCredi,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif
  
  If nTotTroca <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "TROCAS                    : "+Transform(nTotTroca,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif
  
  cMsg += ' <tr>'
  cMsg += ' <td>' + "SUB-TOTAL                 : "+Transform(nSubTotal,"@E 999,999,999.99") + '</td>'
  cMsg += ' </tr>'        
  
  cMsg += ' <tr>'
  cMsg += ' <td>' + "DEVOLUCOES                : "+Transform(nTotDevol,"@E 999,999,999.99") + '</td>'
  cMsg += ' </tr>'        
  
  cMsg += ' <tr>'
  cMsg += ' <td>' + "TOTAL LIQUIDO             : "+Transform(nTotLiqui,"@E 999,999,999.99") + '</td>'
  cMsg += ' </tr>'        

  If nTotBrind <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "BRINDES                   : "+Transform(nTotBrind,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nTotConsu <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CONSUMOS                  : "+Transform(nTotConsu,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  cMsg += ' <tr>'
  cMsg += ' <td>' + "NUMERO DE DOCUMENTOS EMITIDOS  : "+Transform(nTotNotas,"@E 999999,999,999") + '</td>'
  cMsg += ' </tr>'        

  If nTotApoli > 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "NUMERO DE APOLICES        : "+Transform(nTotApoli,"@E 999999,999,999") + '</td>'
     cMsg += ' </tr>'        
  Endif

  cMsg += ' <tr>'
  cMsg += ' <td>' + "TESOURARIA:" + '</td>'
  cMsg += ' </tr>'        
		
  If nEntrada  <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + " + ENTRADA NO CAIXA       : "+Transform(nEntrada ,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        

  Endif
		
  If nDinheiro <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + " + VENDAS EM DINHEIRO     : "+Transform(nDinheiro,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif
		
  If nSaida    <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + " - SAIDA DO CAIXA         : "+Transform(nSaida   ,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  cMsg += ' <tr>'
  cMsg += ' <td>' + " (=) DINHEIRO NO CAIXA      : "+Transform((nEntrada+nDinheiro)-nSaida,"@E 999,999,999.99") + '</td>'
  cMsg += ' </tr>'        
  	
  If nChequeAv <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CHEQUE                    : "+Transform(nChequeAv+nChequePr,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nCCaura <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CARTAO AURA               : "+Transform(nCCAura  ,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif
		
  If nCCVisa   <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CARTAO VISA               : "+Transform(nCCVisa  ,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nCCDebito   <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CARTAO DE DEBITO          : "+Transform(nCCDebito  ,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nCCMaster <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CARTAO MASTERCARD         : "+Transform(nCCMaster,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nCCAmeric <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CARTAO AMERICAN           : "+Transform(nCCAmeric,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nCCDinner <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CARTAO DINNERS            : "+Transform(nCCDinner,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nCCVisaEl <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "VISA ELECTRON             : "+Transform(nCCVisaEl,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nCCRedeSh <> 0
    cMsg += ' <tr>'
    cMsg += ' <td>' + "REDESHOP/MAESTRO          : "+Transform(nCCRedeSh,"@E 999,999,999.99") + '</td>'
    cMsg += ' </tr>'        
  Endif

  If nCCCheque <> 0 
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CHEQUE ELETRONICO         : "+Transform(nCCCheque,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nDepConta <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "DEPOSITO EM CONTA         : "+Transform(nDepConta,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nBolBanco <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "BOLETO BANCARIO           : "+Transform(nBolBanco,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nNotaProm <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "NOTA PROMISSORIA          : "+Transform(nNotaProm,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nCarteira <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CARTEIRA                  : "+Transform(nCarteira,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nDuplicat <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "DUPLICATA                 : "+Transform(nDuplicat,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nCrediari <> 0                                                      
     cMsg += ' <tr>'
     cMsg += ' <td>' + "FINANCIAMENTO             : "+Transform(nCrediari,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nEmpenho  <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "EMPENHO                   : "+Transform(nEmpenho ,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nChequeLi <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "CHEQUE A LIQUIDAR         : "+Transform(nChequeLi ,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  EndIf

  If nBoletoLi <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' +  "BOLETO A LIQUIDAR         : "+Transform(nChequeLi ,"@E 999,999,999.99")+ '</td>'
     cMsg += ' </tr>'        
  EndIf

  If nOutrosPg <> 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "OUTROS PAGAMENTOS         : "+Transform(nOutrosPg,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif

  If nSemClien > 0
     cMsg += ' <tr>'
     cMsg += ' <td>' + "RECEBIMENTO DIVERSOS      : "+Transform(nSemClien,"@E 999,999,999.99") + '</td>'
     cMsg += ' </tr>'        
  Endif
        
  If nTotFatur > 0
    cMsg += ' <tr>'
    cMsg += ' <td>' + "FATURAMENTO SERVICOS      : "+Transform(nTotFatur,"@E 999,999,999.99")  + '</td>'
    cMsg += ' </tr>'        
  Endif

  cMsg += ' </table>'
  //--- Fim da tabela                                         

  cMsg += Repli(' <br />',2)
  
Return cMsg
		
////////////////////////////
Static Function PegaResumo()
  Local cQry, nPerc, nValDev
  
  Local cCX1    := 'C01'
  Local cCX2    := 'C02'
  Local cCX3    := 'C03'
  Local cCX4    := 'C05'
  
  Local cFilSD2 := XFILIAL("SD2")
  Local cFilSL4 := XFILIAL("SL4")
  Local cFilSE5 := XFILIAL("SE5")

  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verificando creditos concedidos  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
  cQry := "SELECT L1_DOC, L1_SERIE, L1_CLIENTE, L1_LOJA, L1_CREDITO FROM "+RetSQLName("SL1")+" WHERE "
  cQry += "L1_EMISSAO = '"+Dtos(dDataBase)+"' AND L1_FILIAL = '"+XFILIAL("SL1")+"' AND D_E_L_E_T_ <> '*' AND "
  cQry += "L1_TIPO = 'V' AND L1_OPERADO IN ('"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"') AND L1_CREDITO <> 0"
		
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
		
  Do while !TRB->(Eof())
     //- Movimento bancario
	 dbSelectArea("SE5")
	 dbSetOrder(7)
	 If !SE5->(dbSeek(cFilSE5+TRB->(L1_SERIE+L1_DOC+"A"+"CR "+L1_CLIENTE+L1_LOJA)))
	    nTotCredi += TRB->L1_CREDITO
	 Endif
	 dbSelectArea("TRB")
	 TRB->(dbSkip())
  Enddo
  TRB->(dbCloseArea())
		
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verificando as vendas por forma de pagamento  ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
  cQry := "SELECT L1_CLIENTE, L1_LOJA, L1_SERIE, L1_DOC, L4_FORMA, L4_DATA, L4_VALOR, L4_ADMINIS, L4_TROCO "
  cQry += "FROM "+RetSQLName("SL1")+" A, "+RetSQLName("SL4")+" B WHERE "
  cQry += "L1_EMISNF = '"+Dtos(dDatabase)+"' AND L1_FILIAL = '"+XFILIAL("SL1")+"' AND A.D_E_L_E_T_ <> '*' AND "
  cQry += "B.D_E_L_E_T_ <> '*' AND L1_FILIAL = L4_FILIAL AND L1_NUM = L4_NUM AND L1_TIPO = 'V' AND "
  cQry += "L1_OPERADO IN ('"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"')"
		
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
		
  TcSetField("TRB" , "L4_DATA", "D", 8, 0)  // Formata para tipo Data
		
  dbSelectArea("TRB")
  TRB->(dbGoTop())
		
  Do While !TRB->(Eof())
     // Posiciona nos Itens da Nota Fiscal de Saida
	 SD2->(dbSetOrder(3))
	 SD2->(dbSeek(cFilSD2+TRB->(L1_DOC+L1_SERIE+L1_CLIENTE+L1_LOJA)))
	
	 // Acumula por Forma de Pagamento
	 SomaForma(SubStr(L4_FORMA,1,2),L4_DATA,SubStr(L4_ADMINIS,1,3),L4_VALOR-L4_TROCO,L4_VALOR-L4_TROCO,1)
	 TRB->(dbSkip())
  Enddo
  TRB->(dbCloseArea())
		
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verificando as vendas feitas pelo faturamento ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
  cQry := "SELECT ISNULL(SUM(D2_TOTAL),0)TOTAL FROM "+RetSQLName("SD2")+" SD2 "
  cQry += " WHERE D2_FILIAL = '"+XFILIAL("SD2")+"' AND D2_EMISSAO = '"+Dtos(dDatabase)+"' "
  cQry += "AND D2_TIPO ='N' AND D2_PEDIDO <> ' ' AND SD2.D_E_L_E_T_ <> '*' "
  //cQry += "AND D2_CF IN('5102','6102') "
		
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
  nTotFatur += TOTAL
  TRB->(dbCloseArea())
		
  //- Quantidade de notas fiscais emitidas
  cQry := "SELECT ISNULL(COUNT(*),0)TOTAL FROM "+RetSQLName("SF2")+" SF2 "
  cQry += "WHERE F2_FILIAL = '"+XFILIAL("SF2")+"' AND F2_EMISSAO = '"+Dtos(dDatabase)+"' AND F2_TIPO ='N' AND "
  cQry += "SF2.D_E_L_E_T_ <> '*'"
  //cQry += "AND D2_CF IN('5102','6102') "
  				
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
  nTotNotas += TOTAL
  TRB->(dbCloseArea())
		
  //- Soma o total dos descontos concedidos
  cQry := "SELECT ISNULL(SUM(D2_DESCON),0)TOTAL FROM "+RetSQLName("SD2")+" SD2, "+RetSQLName("SL1")+" SL1 "
  cQry += "WHERE D2_FILIAL = '"+XFILIAL("SD2")+"' AND D2_EMISSAO = '"+Dtos(dDatabase)+"' AND D2_TIPO ='N' AND "
  cQry += "SD2.D_E_L_E_T_ <> '*' AND SL1.D_E_L_E_T_ <> '*' AND D2_FILIAL = L1_FILIAL AND D2_DOC = L1_DOC AND "
  cQry += "D2_SERIE = L1_SERIE AND D2_CLIENTE = L1_CLIENTE AND D2_LOJA = L1_LOJA AND L1_OPERADO IN "
  cQry += "('"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"')"
  //cQry += "AND D2_CF IN('5102','6102') "
		
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
  nTotDesco += TOTAL
  TRB->(dbCloseArea())
		
  //- Trocas e devolucoes
  cQry := "SELECT D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_TOTAL, D1_VALDESC, L1_NUM, L1_VLRLIQ "
  cQry += "FROM "+RetSQLName("SD1")+" A, "+RetSQLName("SL1")+" B "
  cQry += "WHERE A.D_E_L_E_T_=' ' AND B.D_E_L_E_T_=' ' AND D1_FILIAL=L1_FILIAL AND D1_TES = '132' AND "
  cQry += "D1_NFORI=L1_DOC AND D1_SERIORI=L1_SERIE AND D1_TIPO='D' AND D1_DTDIGIT = '"+Dtos(dDatabase)+"' AND "
  cQry += "L1_TIPO = 'V' AND D1_FILIAL = '"+XFILIAL("SD1")+"' AND "
  cQry += "SUBSTRING(D1_NUMCQ,1,3) IN ('"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"') AND D1_LOCAL = '01'"
		
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry)), "TRB", .T., .F. )
		
  dbSelectArea("TRB")
  TRB->(dbGoTop())

  While !TRB->(EOF())
     If PesqDevTrc() == "T"
		nTotTroca += TRB->D1_TOTAL - TRB->D1_VALDESC
	 Else
		nTotDevol += TRB->D1_TOTAL - TRB->D1_VALDESC
	 Endif
	 TRB->(dbSkip())
  Enddo
  TRB->(dbCloseArea())
		
  //- Entradas no Caixa
  cQry1 := "SELECT ISNULL(SUM(E5_VALOR),0)ENTRADA FROM "+RetSQLName("SE5")
  cQry1 += " WHERE E5_DATA = '"+Dtos(dDatabase)+"' "
  cQry1 += " AND ((E5_RECPAG='R' AND E5_TIPODOC ='TR') OR (E5_RECPAG='R' AND E5_TIPODOC IN ('','VL','ES'))) AND "
  cQry1 += " E5_HISTOR <> 'Estorno de transferencia.                              ' AND "
  cQry1 += " E5_SITUACA <> 'C' AND "
  cQry1 += " D_E_L_E_T_ <> '*' AND "
  cQry1 += " E5_BANCO IN ("
  cQry1 += " '"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"')"
		
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry1)), "TRB", .T., .F. )
  nEntrada += TRB->ENTRADA
  TRB->(dbCloseArea())
		
  //- Saidas no Caixa
  cQry2 := "SELECT ISNULL(SUM(E5_VALOR),0)SAIDA FROM "+RetSQLName("SE5")
  cQry2 += " WHERE E5_DATA = '"+Dtos(dDatabase)+"' "
  cQry2 += " AND ((E5_RECPAG='P' AND E5_TIPODOC ='TR') OR (E5_RECPAG='P' AND E5_TIPODOC IN ('','VL','ES','LJ') )) AND "
  cQry2 += " E5_HISTOR <> 'Estorno de transferencia.                              ' AND "
  cQry2 += " E5_SITUACA <> 'C' AND "
  cQry2 += " D_E_L_E_T_ <> '*' AND "
  cQry2 += " E5_BANCO IN ( "
  cQry2 += "'"+cCX1+"','"+cCX2+"','"+cCX3+"','"+cCX4+"')"
		
  dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQry2)), "TRB", .T., .F. )
  nSaida += TRB->SAIDA
  TRB->(dbCloseArea())
Return
		
////////////////////////////////////////////////////////////////////////
Static Function SomaForma(cTipo,dVencto,cCodCli,nValor,nVlrReal,nSinal)
  Do Case
     Case cTipo == "R$"
		nDinheiro += (nValor * nSinal)                //- Dinheiro
	 Case cTipo == "CH" .And. dVencto == dDatabase
		nChequeAv += (nValor * nSinal)                //- Cheque a vista
	 Case cTipo == "CH" .And. dVencto <> dDatabase
		nChequePr += (nValor * nSinal)                //- Cheque pre-datado
	 Case cTipo == "CC" .And. cCodCli $ "001#002"
		nCCMaster += (nVlrReal * nSinal)              //- Cartao Mastecard
	 Case cTipo == "CD" .And. cCodCli == "003"
		nCCRedeSh += (nVlrReal * nSinal)              //- Redeshop
	 Case cTipo == "CC" .And. cCodCli $ "005#009"
		nCCVisa   += (nVlrReal * nSinal)              //- Cartao Visa
	 Case cTipo == "CC" .And. cCodCli $ "006#007"
		nCCDinner += (nVlrReal * nSinal)              //- Dinners
	 Case cTipo == "CD" .And. cCodCli == "004"
		nCCVisaEl += (nVlrReal * nSinal)              //- Visa Eletron
	 Case cTipo == "BO"
		nBolBanco += (nValor * nSinal)                //- Boleto
	 Case cTipo == "FI"
		nCrediari += (nValor * nSinal)
	 Case Empty(cCodCli)
		nSemClien += (nValor * nSinal)
	 OtherWise  //Case cTipo <> "CR"
		nOutrosPg += (nValor * nSinal)
  EndCase
Return
		
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ PesqDevTrc ¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 23/05/2005 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Pesquisa troca ou devolucao para a venda                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function PesqDevTrc()
  Local nReg
  Local cAlias := Alias()
  Local cBusca := XFILIAL("SE5")+D1_SERIE+D1_DOC+"A"+"NCC"+D1_FORNECE+D1_LOJA  
  Local cRet   := "D"
		
  dbSelectArea("SE5")
  dbSetOrder(7)
  
  SE5->(dbSeek(cBusca,.T.))

  Do while !SE5->(Eof()) .And. cBusca == SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
     nReg := SE5->(Recno())

	 If !Empty(SE5->E5_DOCUMEN) .And. SE5->(dbSeek(SE5->E5_FILIAL+SubStr(SE5->E5_DOCUMEN,1,13))) //+E5_CLIFOR+E5_LOJA)

		dbSelectArea("SL1")
		dbSetOrder(2)
		
		If SL1->(dbSeek(XFILIAL("SL1")+SE5->E5_PREFIXO+SE5->E5_NUMERO))
			cRet := "T"
			Exit
		Endif
		dbSelectArea("SE5")
	 Endif
	 SE5->(dbGoTo(nReg))
	 SE5->(dbSkip())
  Enddo
  dbSelectArea(cAlias)
Return(cRet)                    

