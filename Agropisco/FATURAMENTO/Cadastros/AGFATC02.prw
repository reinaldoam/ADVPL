#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AGFATC02  � Autor � Reinaldo Magalh�es � Data �  13/07/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de contatos                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AGFATC02()  
  Local aArea:= GetArea()
  Local lA030Inclui  
  Local oDlgMain,n
  Local cCliente := Space(6)
  Local cLoja    := Space(2)
  Local cQry:=""    
  Local nOpcA:=0
  
  Private aContato := InicArray()
  
  DEFINE Font oFnt3 Name "Ms Sans Serif" Bold
  DEFINE MSDIALOG oDlgMain Title "Contatos" From 148,5 to 480,700 Pixel //ls,cs,li,ci
                     
  //�������������������������������������������������Ŀ
  //� Verifica se � chamado pela rotina de inclus�o  �
  //���������������������������������������������������                                                         
  lA030Inclui := IsInCallStack( "A030Inclui" )
              
  If lA030Inclui
     cCliente := SA1->A1_COD
     cLoja    := SA1->A1_LOJA
  Else
     cCliente := SA1->A1_COD
     cLoja    := SA1->A1_LOJA
  Endif
  
  cQry := " SELECT * "
  cQry += " FROM "+RetSQLName("SZ1")+" SZ1 "
  cQry += " WHERE SZ1.D_E_L_E_T_<>'*'"
  cQry += " AND Z1_CLIENTE = '"+cCliente+"'"
  cQry += " AND Z1_LOJA = '"+cLoja+"'"

  dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"XXX",.T.,.T.)

  n:=0
  Do While !XXX->(EOF())
     n++     
     aContato[n][1]:= XXX->Z1_CONTATO
     aContato[n][2]:= XXX->Z1_CELULAR
     aContato[n][3]:= XXX->Z1_EMAIL
     aContato[n][4]:= XXX->Z1_CELULAR
     aContato[n][5]:= XXX->Z1_ORDEM
     XXX->(DbSkip())
  Enddo             
  XXX->(dbCloseArea())
  
  // Cria Browse
  oBrowse := TCBrowse():New( 05, 05, 345, 130,,{"Contato","Celular","E-mail","Setor","Ordem"}, {40,40,40,40,10},oDlgMain,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, ) //ls,cs,ci,li
 
  // Seta vetor para a browse                            
  oBrowse:SetArray(aContato) 
 
  // Monta a linha a ser exibida no Browse
  oBrowse:bLine := {||{aContato[oBrowse:nAt,01],;
                       aContato[oBrowse:nAt,02],; 
                       aContato[oBrowse:nAt,03],;
                       aContato[oBrowse:nAt,04],;
                       aContato[oBrowse:nAt,05]}}    
 
  // Evento de duplo click na celula
  oBrowse:bLDblClick := {|| EdtContato(oBrowse:nAt),oBrowse:Refresh() }

  // Evento na mudan�a de linha
  //oBrowse:bDrawSelect := {|| VerTabela(oBrowse:nAt),oBrowse:Refresh() }

  @ 150, 150 BMPBUTTON TYPE 1 ACTION (nOpcA := 1,oDlgMain:End()) //- Confirma 
  @ 150, 180 BMPBUTTON TYPE 2 ACTION (nOpcA := 2,oDlgMain:End()) //- Cancela

  ACTIVATE MSDIALOG oDlgMain Centered
  
  If nOpcA = 1 //- Grava dados
     //- Lista de contatos
     DbSelectArea("SZ1")
     DbSetOrder(1)

     For i:= 1 to Len(aContato)
        If !Empty(aContato[i][1])
           If !SZ1->(DbSeek(xFilial("SZ1")+cCliente+cLoja+aContato[i][5]))
              Reclock("SZ1",.T.)
              SZ1->Z1_FILIAL  := xFilial("SZ1")
              SZ1->Z1_CLIENTE := cCliente
              SZ1->Z1_LOJA    := cLoja
           Else
              Reclock("SZ1",.F.)
           Endif            
           SZ1->Z1_CONTATO := aContato[i][1]
           SZ1->Z1_CELULAR := aContato[i][2]
           SZ1->Z1_EMAIL   := aContato[i][3]
           SZ1->Z1_CELULAR := aContato[i][4]
           SZ1->Z1_ORDEM   := aContato[i][5]
           SZ1->(MsUnlock())
        Endif
     Next      
  Endif
  RestArea( aArea ) // Restaura a area atual
Return

/////////////////////////////// 
Static Function EdtContato(nPos)
  Local oDlgContato,oContato,oCelular,oEmail,oSetor,oOrdem
  Local cContato:= aContato[nPos,1] //- Contato
  Local cCelular:= aContato[nPos,2] //- Celular
  Local cEmail  := aContato[nPos,3] //- E-mail
  Local cSetor  := aContato[nPos,4] //- Setor
  Local cOrdem  := aContato[nPos,5] //- Ordem

  Local nOpc:=0
  
  DEFINE MSDIALOG oDlgContato FROM 12,20 TO 23,100 TITLE "Contatos"
   
     //@ 0.3,1 TO 3.0,30.0 OF oDlgContato
     
     @ 10.0, 15.0 Say "Contato"  Size 65,8 Of oDlgContato Pixel Font oFnt3
     @ 10.0, 65.0 MSGET oContato VAR cContato Picture "@!" RIGHT SIZE 150,07 PIXEL OF oDlgContato
     
     @ 20.0, 15.0 Say "Celular"  Size 65,8 Of oDlgContato Pixel Font oFnt3
     @ 20.0, 65.0 MSGET oCelular VAR cCelular Picture "@!" RIGHT SIZE 50,07 PIXEL OF oDlgContato
     
     @ 30.0, 15.0 Say "E-mail"  Size 65,8 Of oDlgContato Pixel Font oFnt3
     @ 30.0, 65.0 MSGET oEmail VAR cEmail RIGHT SIZE 200,07 PIXEL OF oDlgContato
   
     @ 40.0, 15.0 Say "Setor"  Size 65,8 Of oDlgContato Pixel Font oFnt3
     @ 40.0, 65.0 MSGET oSetor VAR cSetor Picture "@!" RIGHT SIZE 100,07 PIXEL OF oDlgContato

     @ 50.0, 15.0 Say "Ordem"  Size 65,8 Of oDlgContato Pixel Font oFnt3
     @ 50.0, 65.0 MSGET oOrdem VAR cOrdem Picture "@!" RIGHT SIZE 15,07 PIXEL OF oDlgContato Valid ChkOrdem(cOrdem)

     DEFINE SBUTTON FROM 10.0,280.0 TYPE 1 ACTION (nOpc:=1,oDlgContato:End()) ENABLE OF oDlgContato
     DEFINE SBUTTON FROM 20.0,280.0 TYPE 2 ACTION (nOpc:=0,oDlgContato:End()) ENABLE OF oDlgContato

  ACTIVATE MSDIALOG oDlgContato CENTERED                                                  
  
  If nOpc == 1
     aContato[nPos,1]:= cContato //- Contato
     aContato[nPos,2]:= cCelular //- Celular
     aContato[nPos,3]:= cEmail   //- E-mail
     aContato[nPos,4]:= cSetor   //- Setor
     aContato[nPos,5]:= cOrdem   //- Ordem
  Endif
Return
                      
//////////////////////////
Static Function InicArray
  aRet:= {}
  For i:= 1 to 20
     //- Refer�ncia/Tabela
     AADD(aRet,{Space(40),Space(20),Space(60),Space(30),Space(2) } )
  Next
Return aRet

/////////////////////////////////
Static Function ChkOrdem(cOrdem)
  Local nPos := 0
  Local lRet := .t.
  If !Empty(cOrdem)  
     nPos := aScan(aContato,{|x| x[5] = cOrdem })
     lRet := IIF(nPos > 0, .F., .T.)
  Else
     lRet := .F.
  Endif         
  If !lRet
     MsgInfo("Ordem inv�lida ou j� cadastrada !!!","Aten��o")
  Endif
Return lRet