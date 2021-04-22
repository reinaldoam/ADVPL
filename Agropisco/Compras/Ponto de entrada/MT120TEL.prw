#include "rwmake.ch"
#include "protheus.ch"
/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa � MT120TEL � Mauro Nunes � Data � 20/01/14 ���
������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada p/ incluir campo no cabecalho do pedido ���
������������������������������������������������������������������������Ĵ��
���Sintaxe � Chamada padrao para programas em RDMake. ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function MT120TEL()
  Local oNewDialog := PARAMIXB[1]
  Local aPosGet    := PARAMIXB[2]
  Local aObj	   := PARAMIXB[3]
  Local nOpcx      := PARAMIXB[4]
  Public _cTransp  := Space(06)
  Public _nVlrFre  := 0.00
  
  If nOpcx = 3
     _cTransp := Space(06)
     _nVlrFre := 0.00
  Else
     _cTransp := SC7->C7_XTRANSP
     _nVlrFre := SC7->C7_XVLRFRE
  Endif
  @ 043,022 SAY "Transportadora" OF oNewDialog PIXEL SIZE 060,006
  @ 044,101-12 MSGET _cTransp PICTURE PesqPict("SC7","C7_XTRANSP") F3 CpoRetF3("C7_XTRANSP",'SA4') OF oNewDialog PIXEL SIZE 060,006
  //@ 043,022 SAY "Vlr Frete" OF oNewDialog PIXEL SIZE 050, 008 // 055
  //@ 044,101-12 MSGET _nVlrFre PICTURE PesqPict("SC7", "C7_XVLRFRE") OF oNewDialog PIXEL SIZE 060, 006 // 055
Return(.t.)
  
User Function MTA120G3()
  Local aInformacoes := PARAMIXB
  SC7->C7_XTRANSP	 := AllTrim(_cTransp)
  SC7->C7_XVLRFRE	 := _nVlrFre
Return