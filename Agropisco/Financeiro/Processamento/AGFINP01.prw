#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "AP5Mail.ch"
#include "TBICONN.ch"
/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Função    ¦ AGFINP01   ¦ Autor ¦ Reinaldo Magalhães     ¦ Data ¦ 09/05/14   ¦¦¦
¦¦+-----------+------------+-------+------------------------+-------------------+¦¦
¦¦¦ Descriçäo ¦ Email de títulos baixados                                       ¦¦¦
¦¦+-----------+-----------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function AGFINP01(cFilSE5,cPref,cNum,cParc,cBanco,cAgencia,cConta)

Local _aArea

//Prepare Environment Empresa "01" Filial "01" //Tables "SC1,SZJ,SD1,SA2"

_aArea := GetArea()

lContinua:= fGetBaixasCR(cFilSE5,cPref,cNum,cParc,cBanco,cAgencia,cConta)

If lContinua
	SendEMail()
EndIf

QRY->(dbCloseArea())

RestArea(_aArea)

//Reset Environment

Return .T.

//////////////////////////////
Static Function SendEmail()
Local cMsgA      := "" //email para cEmailV e cEmailG
Local cAccount   := "workflow@potencial.inf.br" //Trim(GetMv("MV_RELACNT"))  
Local cServer    := "mail.potencial.inf.br:587"     //Trim(GetMv("MV_RELSERV"))  
Local cPass      := "workflow007"               //Trim(GetMv("MV_RELPSW"))  
//Local cEmailV    := 'thiciana.siqueira@riosolimoes.org.br,helenasarkis@riosolimoes.org.br,processoestagios@riosolimoes.org.br,estagios@riosolimoes.org.br,patricia@riosolimoes.org.br,rosalina@riosolimoes.org.br'
Local cEmailV    := 'reinaldo.magalhaes@potencial.inf.br'
Local lRet       := .T.
Local lResult    := .T.
Private cSubject   := "Recebimentos de títulos" //assunto do email

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
                 
	//If GetMv('MV_RELAUTH')
	//	lRet := MailAuth(cAccount, AllTrim(cPass)) 
	//Else        
	//	lRet := .T.
	//EndIf
	
	SEND MAIL FROM cAccount TO ;
	               cEmailV ;
	               SUBJECT cSubject ;
	               BODY cMsgA ;
	               RESULT lResult
	
	If !lResult
		GET MAIL ERROR CERROR
	Else
	    Alert("E-mail enviado para " + cEmailV)	
	EndIf
	DISCONNECT SMTP SERVER
Else
	GET MAIL ERROR CERROR
EndIf
Return lRet

/////////////////////////
Static Function fRodape()
Local cMsg  := " "
cMsg += ' <br />'
cMsg += ' </body>'
cMsg += ' </html>'
Return cMsg

//////////////////////////////////////////////////////////////////////////////
Static function fGetBaixasCR(cFilSE5,cPref,cNum,cParc,cBanco,cAgencia,cConta)
Local cQuery:= ""

cQuery := "SELECT * "
cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
cQuery += "	E5_FILIAL = '" + cFilSE5 + "'" + " AND "
cQuery += " D_E_L_E_T_ <> '*' "
cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','BA') "
cQuery += " AND E5_PREFIXO = '"   + cPref   + "'"
cQuery += " AND E5_NUMERO = '" + cNum + "'"
cQuery += " AND E5_PARCELA = '"   + cParc  + "'"
cQuery += " AND E5_BANCO = '"   + cBanco   + "'"
cQuery += " AND E5_AGENCIA = '" + cAgencia + "'"
cQuery += " AND E5_CONTA = '"   + cConta   + "'"
cQuery += " AND E5_SITUACA <> 'C' "
cQuery += " AND E5_VALOR <> 0 "
cQuery += " AND E5_NUMCHEQ NOT LIKE '*%' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"QRY",.T.,.T.)

If !QRY->(Eof())
	lRet :=.T.
	TCSetField("QRY","E5_DTDISPO" ,"D",8,0)
EndIf
Return lRet   

///////////////////////////
Static Function InicioMsg()
	Local cMsg   
	Local nExpiraEm
	Local nCountL
	
	cMsg := ' <html> '
	cMsg += ' <head> '
	cMsg += ' <title>' + cSubject + '</title> '
	cMsg += ' </head>'
	cMsg += ' <body> ' 
	
    //nExpiraEm := QRY->EXPIRA_EM
	nCountL := 0
	//cMsg += ' <b>Expiram em : </b>' + AllTrim(Str(nExpiraEm)) + ' dias <br /> '
		
	//incio da tabela
	cMsg += ' <table width="100%" border="1" cellspacing="0" cellpadding="5">'
	cMsg += ' <caption><h2>' + cSubject + '</h2></caption>'
	cMsg += ' <tr>'
	cMsg += ' <th scope="col">Item</th>'
	cMsg += ' <th scope="col">Cliente</th>'
	cMsg += ' <th scope="col">Projeto</th>'
	cMsg += ' <th scope="col">Data Credito</th>'
	cMsg += ' <th scope="col">Valor Liquido</th>'
	//cMsg += ' <th scope="col">Nome do Cliente</th>'
	cMsg += ' </tr>'
		
	While !QRY->(Eof())
	   cMsg += ' <tr>'
	   cMsg += ' <td>' + AllTrim(Str(++nCountL)) + '</td>'
	   cMsg += ' <td>' + AllTrim(QRY->E5_BENEF) + '</td>'
	   cMsg += ' <td>' + AllTrim(QRY->E5_CCD) + '</td>'
	   cMsg += ' <td align="center">' + AllTrim(QRY->E5_DTDISPO) + '</td>'
	   cMsg += ' <td align="center">' + Transform(QRY->E5_VALOR,"@E 9,999,999.99") + '</td>'
	   //cMsg += ' <td align="center">' + AllTrim(Posicione("SA1",1,xFilial("SA1")+QRY->CN9_CLIENT,"A1_NOME")) + '</td>'
	   cMsg += ' </tr>'
	   QRY->(dbSkip())
	EndDo
	cMsg += ' </table>'
	//fim da tabela
	cMsg += '<br /><b>Total de Itens: ' + AllTrim(Str(nCountL)) +'</b>'
	cMsg += Repli(' <br />',2)
Return cMsg