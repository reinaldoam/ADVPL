#include "rwmake.ch"
#include "ap5mail.ch"  
#include "TBICONN.CH" 
#INCLUDE "FILEIO.CH"  
/*______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Programa  ¦  RTBY001   ¦ Autor ¦ Williams Messa       ¦ Data ¦ 11/10/2007 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ WorkFlow de Notificação de emissão de Titulo                  ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
           //Email,           ,Valor do Titulo,Vencimento     ,Emissão do Tit ,Nro do Titulo
//U_WKKSNP01(aDatSacado[1][10],aDadosTit[1][5],aDadosTit[1][4],aDadosTit[1][2],aDadosTit[1][1])
      
User Function WKKSNP01(cMail,nValor,dVencimento,dEmissao,cNum)         

Private cFrom     := "workflow@senpe.com.br"//E-mail do Remetente
Private cServer   := "smtp.senpe.com.br"//Servidor SMTP 
Private cPassword := "senpe1414"//Password do email do remetente
Private cEmail    := cMail //Email destino 
Private cEmailcc  := "cpd@senpe.com.br;financeiro@senpe.com.br;faturamento@senpe.com.br"//Email de Copias
Private lResult   := .F.
Private aDados    :={}
Private cPerg     := "WKKSNP01"
//Private cData     := DTOS(dDataBase)
Private cError    := ""
Private lResult   := .F.
Private _lMsg     := .T. 
Private cLoja     := ""

cMsg := ""
//INICIO DO CORPO DE E-MAIL
cMsg := '<html>'
cMsg += '<head> '
cMsg += '<meta http-equiv="Content-Language" content="pt-br"><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><title>Notificação Emissão de Titulos - SENPE</title>'
cMsg += '<style>'
cMsg += '<!-- p.MsoNormal'
cMsg += '{mso-style-parent:"";'
cMsg += 'margin-bottom:.0001pt;'
cMsg += 'font-size:10.0pt;'
cMsg += 'font-family:"Times New Roman","serif";'
cMsg += 'margin-left:0cm; margin-right:0cm; margin-top:0cm}'
cMsg += '-->'
cMsg += '</style>'
cMsg += '</head>'
cMsg += '<body>'
cMsg += '<p class="MsoNormal" align="justify"><font face="Arial">Prezados Senhores(a),</font></p>'
cMsg += '<p class="MsoNormal" align="justify"><font face="Arial">&nbsp;</font></p>'
cMsg += '<p class="MsoNormal" align="justify"><font face="Arial">Cumpre-nos informar que '
cMsg += 'o BOLETA DE COBRANÇA, referente aos produtos faturados na NOTA FISCAL  '
cMsg += cNum +' em '+ DTOC(dEmissao) +' foram enviados junto com a mesma acompanhando o ' 
cMsg += 'produto. Ratificamos que V.S. não mais receberá pelo correio a cobrança. '
cMsg += 'Qualquer dúvida entre em contado conosco&nbsp;pelo fone 3584 0046 ou email '
cMsg += '<a href="mailto:finaceiro@senpe.com.br">finaceiro@senpe.com.br</a></font>.</p>'
cMsg += '<p class="MsoNormal" align="justify">&nbsp;</p>
cMsg += '<p class="MsoNormal" align="justify"><font face="Arial">Favor não responder este 
cMsg += 'email.</font></p>'
cMsg += '<p class="MsoNormal" align="justify">&nbsp;</p>'
cMsg += '<p class="MsoNormal" align="justify">&nbsp;</p>'
cMsg += '</body>'
//Fecha O HTML
cMsg += '</html>'                                  
		
Conout(" Conectando com o servidor SMTP: " + cServer)	
		
CONNECT SMTP SERVER cServer ACCOUNT cFrom PASSWORD cPassword RESULT lResult
		
//CONNECT SMTP SERVER cServer ACCOUNT cFrom PASSWORD cPassword RESULT lResult
If lResult
   MAILAUTH(cFrom,cPassword)
   SEND MAIL FROM cFrom ;
   TO cEmail  ; 
   CC cEmailcc;
   SUBJECT "Notificação de Emissão de Titulos" ; 
   BODY cMsg ;
   RESULT lResult
EndIf
// Verifica se conectou, caso contrario, exibe o erro e retorna
If lResult
	Conout( "Envio OK" )
Else
	GET MAIL ERROR cSmtpError
    Conout( "Erro de envio : " + cSmtpError)
    Return
Endif
// Desconecta o servidor SMTP
DISCONNECT SMTP SERVER	
Return