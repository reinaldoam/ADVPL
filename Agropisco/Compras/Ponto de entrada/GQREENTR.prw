#Include "Rwmake.ch"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ GQREENTR   ¦ Autor ¦ Reinaldo Magalhães   ¦ Data ¦ 13/03/2015 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de Entrada de gravacao da nota fiscal de entrada        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function GQREENTR
  Local nReg
  Local cFilSE2 := SE2->(XFILIAL())
  Local cBusca1 := cFilSE2+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)
  Local cBusca2 := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
  
  SE2->(dbSetOrder(6))
  SE2->(dbSeek(cBusca1))
  
  Do while !SE2->(Eof()) .And. cBusca1 == SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
     dbSelectArea("SE2")
     RecLock("SE2",.F.)
     SE2->E2_LA:= "" 
     MsUnLock()              
     SE2->(DbSkip())
  Enddo 

  SD1->(dbSetOrder(1))
  SD1->(dbSeek(xFilial("SD1")+cBusca2)) //Pesquisa o titulo gerador para gravar as alteracoes

  nReg:= SD1->(Recno())
  
  Do while !SD1->(Eof()) .And. xFilial("SD1")+cBusca2 == SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
     RecLock("SD1",.F.)
     SD1->D1_XNCM:= Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_POSIPI")
     MsUnLock()
     SD1->(dbSkip())
  Enddo
  SD1->(dbGoTo(nReg))
Return  