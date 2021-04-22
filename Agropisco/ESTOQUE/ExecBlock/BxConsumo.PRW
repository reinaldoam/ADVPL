#Include "rwmake.ch"
/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ Função    ¦ BxConsumo   ¦ Autor ¦ Reinaldo Magalhaes  ¦ Data ¦ 10/12/07      ¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ Descriçäo ¦ Valida se o usuario está autorizado a utilizar TES para baixar   ¦¦¦
¦¦¦           ¦ estoque a preco de custo.                                        ¦¦¦
¦¦+-----------+------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
USER FUNCTION BxConsumo
  Local cTes := M->C6_TES
  Local cUsr := Upper(GetMv("MV_USRPRC"))

  If cTes == "534" .And. !(UPPER(Trim(SubStr(cUsuario,7,15))) $ cUsr)
     Alert("Usuario não autorizado a utilizar esta TES!!!")
     cTes:= Space(3)
  Endif     

Return cTes