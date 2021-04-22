#INCLUDE "rwmake.ch" 
 
/*/
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � LJ7050GRV � Autor � Reinaldo/Frankimar      � Data � 15/09/17  ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Gera lancamento de ajuste no fechamento automatico do caixa    ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                             ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������           
���������������������������������������������������������������������������������
/*/
User Function LJ7050GRV
  Local nRecnoSE5 := PARAMIXB[1] // Recno do registro na tabela SE5 Return Nil
  Local cNumMov	  := AllTrim(LjNumMov())								                   //- Retorno o numero do movimento atual
  Local nTamCod   := TamSX3("A6_COD")[1]								                   //- Tamanho do campo A6_COD
  Local nTamAg    := TamSX3("A6_AGENCIA")[1]							                   //- Tamanho do campo A6_AGENCIA
  Local nTamConta := TamSX3("A6_NUMCON")[1]							                       //- Tamanho do campo A6_NUMCON
  Local cCodBanco := Substr(SuperGetMV("MV_CXLOJA",.F.,""),1,nTamCod)                      //- Codigo do banco		
  Local cCodAgen  := Substr(SuperGetMV("MV_CXLOJA",.F.,""),nTamCod + 2,nTamAg)             //- Codigo do agencia
  Local cNumCon   := Substr(SuperGetMV("MV_CXLOJA",.F.,""),nTamCod + nTamAg + 3,nTamConta) //- Numero do conta	
  Local nValor := 0
  
  //- Posiciona no registro correto do SA6
  SA6->(dbSeek(xFilial("SA6")+cCodBanco+cCodAgen+cNumCon))

  If SE5->(DbSeek(xFilial("SE5")+DtoS(dDataBase)+cCodBanco+cCodAgen+cNumCon))
     
     Do While !SE5->(Eof()) .And. SE5->E5_DATA == dDataBase .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA) == cCodBanco+cCodAgen+cNumCon
        If SE5->E5_RECPAG = "R" .And. SE5->E5_TIPODOC = "TR" .And.  SE5->E5_MOEDA$"CH/CC/CD/FI/CO/VA/OU"
           nValor += SE5->E5_VALOR
        Endif
	    SE5->(DbSkip())
     Enddo			
     If nValor > 0
        //- Gravando movimento para anular a entrada no caixa CX1
        Reclock("SE5",.T.)
	    SE5->E5_FILIAL	:= xFilial("SE5")    
	    SE5->E5_DATA	:= dDataMovto
	    SE5->E5_MOEDA	:= "NC"
	    SE5->E5_VALOR	:= nValor
	    SE5->E5_NATUREZ := "AJUSTE"
	    SE5->E5_BANCO	:= SA6->A6_COD
	    SE5->E5_AGENCIA := SA6->A6_AGENCIA
	    SE5->E5_CONTA	:= SA6->A6_NUMCON
 	    SE5->E5_VENCTO	:= dDataBase
	    SE5->E5_RECPAG	:= cRecPag
	    SE5->E5_BENEF	:= "AJUSTE SANGRIA CAIXA"
	    SE5->E5_HISTOR	:= "AJUSTE SANGRIA CAIXA"
	    SE5->E5_DTDIGIT := dDataBase
        SE5->E5_RATEIO  := "N"	 
   	    SE5->E5_DTDISPO := dDataBase
	    SE5->E5_FILORIG := cFilAnt           
        SE5->E5_CODORCA := ""     	 
        SE5->E5_NUMMOV  := cNumMov
	    SE5->(MsUnLock())
        //- Atualiza saldo banc�rio
        AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DATA,SE5->E5_VALOR,"-")
     Endif
  Endif
  SE5->(DbGoto(nRecnoSE5))
Return  