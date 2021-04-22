#include "rwmake.ch" 

User Function MA030TOK() 

Local ret := .T. 

If M->A1_PESSOA=="J" 
   If Empty(M->A1_BAIRRO)
      MsgAlert("Informar Bairro do cliente!", "Aviso") 
      ret := .F. 
   ElseIf Empty(M->A1_CEP)
      MsgAlert("Informar CEP do cliente!", "Aviso") 
      ret := .F.             
   ElseIf Empty(M->A1_CONTATO)
      MsgAlert("Informar Contato do cliente!", "Aviso") 
      ret := .F.             
   ElseIf Empty(M->A1_INSCR) 
      MsgAlert("Informar Inscricao Estadual!", "Aviso") 
      ret := .F. 
   ElseIf Empty(M->A1_INSCRM) 
      MsgAlert("Informar Inscricao Municipal!", "Aviso") 
      ret := .F. 
   ElseIf Empty(M->A1_EMAIL) 
      MsgAlert("Informar Email NFE!", "Aviso") 
      ret := .F. 
   ElseIf Empty(M->A1_XEMAIL) 
      MsgAlert("Informar Email Contato!", "Aviso") 
      ret := .F.       
   Endif   
Endif
Return ret