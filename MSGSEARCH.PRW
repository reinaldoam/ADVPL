USER Function MsgSearch()

Local oNetIZap 
Local cResponse

// Cria o objeto client usando uma chave de demmostração
oNetIZap := NETIZAP():New("5527981049976",'Voz5dWkr5EEhBAbYuwJ2')

// Informa o protococolo da mensagem a ser pesquisada
oNetIZap:SetProtocol("E8891831-2FF4-43B2-8388-2C6D01C7D0A6")

If oNetIZap:MessageSearch()

  cResponse := oNetIZap:GetResponse()
  MsgInfo(cResponse,"MessageSearch() - Retorno da Requisição")

Else

  MsgStop(oNetIZap:GetLastError(),'MessageSearch() - Falha no envio da requisição')

Endif

Return