#include "rwmake.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AGFINR02³ Autor ³  Reinaldo Magalhaes	    ³ Data ³ 27/02/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Impressao de comprovante de SANGRIA                 	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AGFINR02
 LOCAL cBanco
 LOCAL dEmissao
 LOCAL nHdll 

 cBanco  := "001"
 cFavorec:= "CLIENTE PADRAO"
 cCidade := "MANAUS-AM"
 dEmissao:= dDataBase
 cValor	 := "100"
 nCheque := "0000000001"

 lRet:= MsOpenPort(nHdll,"COM5:9600,N,8,1")            

 If lret
    MsWrite(nHdll,"b" + cBanco+chr(13)+chr(10))
    MsWrite(nHdll,"c" + cCidade + "$" +chr(13)+chr(10))
    MsWrite(nHdll,"d" + DtoC(dEmissao)+chr(13)+chr(10))
    MsWrite(nHdll,"f" + cFavorec + "$" +chr(13)+chr(10))
    MsWrite(nHdll,"P" +chr(13)+chr(10))
    MsWrite(nHdll,"v" + cValor + "$"+chr(13)+chr(10))
 Endif   
 MsClosePort(nHdll)
Return