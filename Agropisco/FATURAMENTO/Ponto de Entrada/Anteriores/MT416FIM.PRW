//ExecBlock: 	MT416FIM 
//Ponto:	Após a Confirmação do Orçamento de Venda.	 
//Retorno Esperado:      Nenhum. 

USER FUNCTION MT416FIM     
   SC5->C5_COMIS1:= Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_VEND1,"A3_COMIS")
   SC5->C5_COMIS2:= Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_VEND2,"A3_COMIS2")
   SC5->C5_OBS1:= SCJ->CJ_YOBS1
   SC5->C5_OBS2:= SCJ->CJ_YOBS2
Return 
