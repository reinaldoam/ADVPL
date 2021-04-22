#Include "Rwmake.ch"

/*_______________________________________________________________________________
���������������������������������������������������������������������������������
��+-----------+------------+-------+----------------------+------+------------+��
��� Fun��o    � M410GET    � Autor � Ronilton O. Barros   � Data � 12/07/2006 ���
��+-----------+------------+-------+----------------------+------+------------+��
��� Descri��o � Ponto de Entrada antes de exibir a tela de altera��o          ���
��+-----------+---------------------------------------------------------------+��
��� Fonte incluido neste projeto por Ulisses Jr em 09/10/07 para manuten��o   ���
��� das formas de pagamento pelo faturamento.                                 ���
��+-----------+---------------------------------------------------------------+��
���������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
User Function M410GET()
   Local x, y
   Local nPVen := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_VENCTO"  })
   Local nPVal := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_VALOR"   })
   Local nPFor := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_FORMAPG" })
   Local nPDes := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_DESCFOR" })

   If Type("a_Cols") == "U"  // Caso a vari�vel n�o exista, cria a mesma
      Public a_Cols
   Endif
   a_Cols := {}

   ASort( aColsFor ,,, {|x,y| Dtos(x[nPVen])+x[nPFor] < Dtos(y[nPVen])+y[nPFor] })  // Ordena por data

   // Preenche o vetor de parcelas com as parcelas gravadas no SCV
   For x:=1 To Len(aColsFor)
      AAdd( a_Cols , { aColsFor[x,nPVen], aColsFor[x,nPVal], aColsFor[x,nPFor], 1, SC5->C5_CONDPAG})
   Next

Return