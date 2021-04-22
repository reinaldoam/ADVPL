/*/
����������������������������������������������������������������������������?
�������������������������������������������������������������������������Ŀ�?
���Fun��o    �FTVD7033  ?Autor ?Reinaldo Magalh�es    ?Data ?09.07.18 ��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Ponto de entrada para grava��o de pre�o de custo ��?
���no ato da venda                                             ��?��?
�������������������������������������������������������������������������Ĵ�?
��?Uso      ?Especifico Agropisco                                       ��?
��������������������������������������������������������������������������ٱ?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
/*/

User Function FTVD7033
  Local _lValid := ParamIxb[1]    //.T. = Se est� realizando a gravacao de dados
  Local _nTpOp  := ParamIxb[2]    //Op�ao do Menu
  Local lRet    := .T.
  Local _cAlias := ALIAS()
  Local _aAlias := GetArea()

  If _lValid                           
      
     //���������������������������Ŀ
     //� Gravando lista de pre�os �
     //����������������������������
     SD2->(dbSetOrder(3)) //- Item nota fiscal
     SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE),.t.))

     Do While !SD2->(Eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE) == SD2->(D2_FILIAL+D2_DOC+D2_SERIE)
        Reclock("SD2",.F.)
        SD2->D2_XPRCTAB := Posicione("SB0",1,xFilial("SB0")+SD2->D2_COD,"B0_PRV1")
        SD2->D2_XCODFAB := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_XCODFAB")
        SD2->(MsUnlock())
        SD2->(DbSkip())
     Enddo
  Endif
  RestArea(_aAlias)
  dbSelectArea(_cAlias)
Return