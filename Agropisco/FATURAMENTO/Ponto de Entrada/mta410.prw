#Include "Protheus.ch"

/*_______________________________________________________________________________
���������������������������������������������������������������������������������
��+-----------+------------+-------+----------------------+------+------------+��
��� Fun��o    � MTA410     � Autor � Ronilton O. Barros   � Data � 09/06/2006 ���
��+-----------+------------+-------+----------------------+------+------------+��
��� Descri��o � Ponto de Entrada de validacao do Pedido de Venda              ���
��+-----------+---------------------------------------------------------------+��
��� Fonte incluido neste projeto por Ulisses Jr em 09/10/07 para manuten��o   ���
��� das formas de pagamento pelo faturamento.                                 ���
��+-----------+---------------------------------------------------------------+��
���������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
User Function MTA410()
   Local lret:= .T.
   Local x, y
   Local nTotSCV := 0
   Local nTotSC6 := 0
   Local nDelSC6 := Len(aCols[1])
   Local nPVen   := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_VENCTO"  })
   Local nPFor   := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_FORMAPG" })
   Local nPVal   := Ascan( aHeadFor , {|x| Trim(x[2]) == "CV_VALOR"   })
   Local nPItem  := Ascan( aHeader  , {|x| Trim(x[2]) == "C6_VALOR"   })
   Local nPDesc  := Ascan( aHeader  , {|x| Trim(x[2]) == "C6_DESCONT" })
   Local nPValD  := Ascan( aHeader  , {|x| Trim(x[2]) == "C6_VALDESC" })

   SetKey( VK_F6 , {|| Nil })  // Desabilita a tecla de atalho da busca do produto
   SetKey( VK_F8 , {|| Nil })  // Desabilita a tecla de atalho da consulta de estoque

   //���������������������������������������������������������������������Ŀ
   //� Declaracao de Variaveis                                             �
   //�����������������������������������������������������������������������
   //If ALLTRIM(Upper(SubStr(cUsuario, 7, 15))) == "CAIXA" .And. ( aCols[n,nPDesc] > 0 .Or. aCols[n,nPValD] > 0)
   //   Alert("Usu�rio n�o autorizado a conceder descontos!")
   //   lret:= .F.
   //Endif
   
   If lret
      // Se o vetor de parcelas estiver vazio ou n�o existir, ent�o monta o aColsFor para grava��o no SCV
      // Isso � necess�rio pois caso o vetor exista, ent�o ser� gravado as altera��es do usu�rio
      If Type("a_Cols") == "U" .Or. Empty(a_Cols)
         u_ParcFat(.T.) // Era .F. no original
      Else  // Sen�o verifica se o valor dos itens bate com o valor das parcelas
         aEval( aCols    , {|x| nTotSC6 += If( !x[nDelSC6] , x[nPItem], 0) })  // Totaliza os itens do pedido
         aEval( aColsFor , {|x| nTotSCV += x[nPVal ]                       })  // Totaliza as parcelas

   //      If nTotSC6 <> nTotSCV  // Caso o valor esteja diferente
             u_ParcFat(.T.)
   //      Endif
      Endif

      ASort( aColsFor ,,, {|x,y| Dtos(x[nPVen])+x[nPFor] < Dtos(y[nPVen])+y[nPFor] })  // Ordena por data
      a_Cols := {}    // Zera conte�do da variavel para n�o ser visualizado num novo acesso a rotina
   Endif
Return lret   
                            
Static Function ValidaPedido
  Local lret:= .T.
Return lret