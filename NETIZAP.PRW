#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'Totvs.ch'

USER Function NETIZAP()
Local oNetIZap 
Local cResponse

// Cria o objeto client usando a chave de demostração
oNetIZap := NETIZAP():New("5527981049976",'Voz5dWkr5EEhBAbYuwJ2',13005)

// Define as propriedades minimas para envio de mensagem 
// *** Número do Celular (WhatsApp) no formato internacional, apenas nímeros
// por exemplo para um telefone celular de São Paulo, 
// utilize "5511" seguido pelo número da linha a enviar a mensagem
oNetIZap:SetDestiny("5511xxxxxxxxx")

// Informa o texto da mensagem 
// 
oNetIZap:SetText(EncodeUTF8("*Olá!*\nEsta é uma mensagem de _teste_ enviada pelo Protheus."))

// Realiza o envio da mensagem 

If oNetIZap:MessageSend()

  // Pega o JSON de retorno da requisiçao 
  // Cada mensagem enviada retorna um identificador de protocolo 
  // no formato "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX".   
  cResponse := oNetIZap:GetResponse()

  // Mostra na inteface 
  MsgInfo(cResponse,"MessageSend() - Retorno da Requisição")

Else

  // Em caso de falha no envio, recupera o erro 
  MSgStop(oNetIZap:GetLastError(),'MessageSend() - Falha no envio da requisição')

Endif

Return