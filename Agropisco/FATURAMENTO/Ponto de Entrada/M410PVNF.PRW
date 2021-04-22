#include "rwmake.ch" 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ M410PVNF ³ Autor ³                          ³ Data ³       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE para analise financeira na prep. de ped. de venda       ³±±
±±³Modifi‡…o ³ Criado paramatro MV_XAVALC para definir se avalia LC       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M410PVNF
  Local lRet:= .T.             
  Local cCodCli,cLojCli,cPedido,cCondPag
                                             
  nVlTitVenc:= 0
  nSaldoFin := 0

  If SC5->C5_NUM == "N" .And. !SC5->C5_CONDPAG $ "994\"                           
     cPedido  := SC5->C5_NUM                     
     cCodCli  := SC5->C5_CLIENTE
     cLojCli  := SC5->C5_LOJACLI
     cCondPag := SC5->C5_CONDPAG

     //- Condição de pagamento
     U_MsSetOrder("SE4","E4_FILIAL+E4_CODIGO")
     SE4->(dbSeek(xFilial("SE4")+cCondPag))

     //- Cadastro do Cliente
     U_MsSetOrder("SA1","A1_FILIAL+A1_COD+A1_LOJA")
     SA1->(dbSeek(xFilial("SA1")+cCodCli+cLojCli))                    

     nVlLimite := SA1->A1_LC
     cRisco    := SA1->A1_RISCO
  
     If !(TRIM(SE4->E4_FORMA) $ "R$#CC#CD#CH") .And. cRisco <> "A"             
        lRet:= VerFinanceiro(cCodCli, cLojCli, nVlLimite, cPedido)
     Endif   
  Endif   
Return lRet  
                                                        
////////////////////////////////////////////////////////////////////
Static Function VerFinanceiro(cCodCli, cLojCli, nVlLimite, cPedido)

  Local nVlLimite, nValorPV, nVlTitVenc, nSaldoFin, lRet:= .T.
  Local lLimite := GetMV("MV_XAVALC") 
    
  nValorPV  := ValorDaCompra (cPedido)  
  nVlTitVenc:= SomaTitulos(cCodCli,cLojCli,"V")   
  nSaldoFin := SomaTitulos(cCodCli,cLojCli,"")   
  
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Verificando situação financeira do cliente  ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  If nVlTitVenc > 0
     lRet:= .F.
  Endif     
  If (nSaldoFin+nValorPV) > nVlLimite .And. lLimite
     lRet:= .F.
  Endif   
  If !lRet
     If Msgbox("Venda não autorizada!!! Deseja visualizar situação do cliente ?","Liberaçao de vendas","YESNO")
        Fc010Con()
     Endif
  Endif  
  //lRet:= .T.      
Return lRet  

/////////////////////////////////////
Static Function ValorDaCompra (cPedido)  
  Local cQry, nValorPV
  cQry := "SELECT SUM(C6_VALOR)C6_VALOR "
  cQry += "FROM "+RetSQLName("SC6")+" A "
  cQry += "WHERE A.D_E_L_E_T_ <> '*' "
  cQry += "AND C6_FILIAL = '"+xFilial("SC6")+"' "
  cQry += "AND C6_NUM = '"+cPedido+"'"

  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
  dbSelectArea("TRAB")
                          
  TRAB->(dbGotop())
  
  nValorPV:= TRAB->C6_VALOR
  
  TRAB->(dbCloseArea())
                                           
Return nValorPV

//////////////////////////////////////////////////
Static Function SomaTitulos(cCodCli,cLojCli,cTipo) 
  Local cQry, nValorFin 
  cQry := "SELECT SUM(E1_SALDO)E1_SALDO "
  cQry += "FROM "+RetSQLName("SE1")+" A "
  cQry += "WHERE A.D_E_L_E_T_ <> '*' "
  cQry += "AND E1_FILIAL = '"+xFilial("SE1")+"' "
  cQry += "AND E1_CLIENTE = '"+cCodCli+"' "
  cQry += "AND E1_LOJA = '"+cLojCli+"' "
  cQry += "AND E1_SALDO > 0 "          
  
  If cTipo = "V"
     cQry += "AND E1_VENCREA < '"+Dtos(dDataBase)+"'"       
  Endif
     
  cQry += "AND E1_TIPO NOT IN ('RA ','NCC') "            

  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TRAB",.T.,.T.)
  dbSelectArea("TRAB")
                          
  TRAB->(dbGotop())
  
  nValorFin:= TRAB->E1_SALDO
  
  TRAB->(dbCloseArea())

Return nValorFin

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Fc010Con  ³ Autor ³ Eduardo Riera         ³ Data ³31.12.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Consunta a Posicao de Clientes                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Alias                                              ³±±
±±³          ³ ExpN2 : Recno                                              ³±±
±±³          ³ ExpN3 : nOpc da MBrowse      l                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fc010Con(cAlias,nRecno,nOpcx)

Local aParam := {}

Private Inclui := .F.
Private Altera := .F.

//FC010AjSx1("FIC010")
                       
If Pergunte("FIC010")
   Aadd(aParam,MV_PAR01)
   Aadd(aParam,MV_PAR02)
   Aadd(aParam,MV_PAR03)
   Aadd(aParam,MV_PAR04)
   Aadd(aParam,MV_PAR05)
   Aadd(aParam,MV_PAR06)
   Aadd(aParam,MV_PAR07)
   Aadd(aParam,MV_PAR08)
   Aadd(aParam,MV_PAR09)
   Aadd(aParam,MV_PAR10)
   Aadd(aParam,MV_PAR11)
   Aadd(aParam,MV_PAR12)
   Aadd(aParam,MV_PAR13)
   Aadd(aParam,MV_PAR14)
   Aadd(aParam,MV_PAR15)
   Aadd(aParam,MV_PAR16)

   If VerSenha(104) //Permite consulta a Posicao de Cliente
      Fc010Cli(aParam)
   Else
	  Help(" ",1,"SEMPERM")
   EndIf
EndIf
Return(Nil)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FC010AjSx1   ³ Autor ³ Nilton Pereira     	³ Data ³ 30/12/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Siga                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FC010AjSx1(cPerg)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local nj       := 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local aPergs := {}

Aadd(aPergs,{	"Considera Lojas?","¨Incluir Sucursales?",;
					"Consider Units ?","mv_chc","N",1,0,1,"C","",;
					"mv_par13","Sim","Si","Yes","","","Nao","No","No",;
					"","","","","","","","","","","","","","","","","","S","","",;                  
					{"Informe se deseja que seja considerada","a loja na apresentacao da consulta"},;
					{"Informe se deseja que seja considerada","a loja na apresentacao da consulta"},;
					{"Informe se deseja que seja considerada","a loja na apresentacao da consulta"}})

Aadd(aPergs,{	"TES gera duplicata?","¨TES genera financiero?",;
					"TES gera duplicata?","mv_chd","N",1,0,1,"C","",;
					"mv_par14","Todas","Todas","Todas","","","Gera Duplicatas","Gera Duplicatas","Gera Duplicatas",;
					"","","Não Gera Duplicatas","Não Gera Duplicatas","Não Gera Duplicatas","","","","","","","","","","","","","S","","",;                  
					{"considera os pedidos de venda com a TES ","configurada para gerar duplicadas, "," não gerar ou ambas."},;
					{"considera los pedidos de venta con el TES ","configurado para generar financiero, "," no generar o ambos."},;
					{"considera os pedidos de venda com a TES ","configurada para gerar duplicadas, "," não gerar ou ambas."}})   
					                                        
Aadd(aPergs,{	"Considera RA ?","Considera RA ?",;
					"Considera RA ?","mv_che","N",1,0,2,"C","",;
					"mv_par15","Sim","Si","Yes","","","Nao","No","No",;
					"","","","","","","","","","","","","","","","","","S","","",;                  
					{"Informe se deseja considerar RA's "},;
					{"Informe se deseja considerar RA's "},;
					{"Informe se deseja considerar RA's "}})   
		
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
			aHelpEng := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpSpa := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif                                                                                   
Next
Return(Nil)