#INCLUDE "Rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ UNFINA02 º Autor ³ Ronilton Barros    º Data ³  13/02/06   º±±
±±º Alterado por Marcio Macedo   Data  07/12/06                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                                          
User Function UNFINA02()
   Local aCores  := { {"E2_BLQBAI $ ' N'" ,"ENABLE" },;  // TITULO EM ABERTO
                      {"E2_BLQBAI == 'S'","DISABLE"}}   // TITULO PAGO

   Private cCadastro := "Cadastro de Protocolo de Entrega" 

   Private aRotina := { {"Pesquisar" ,"AxPesqui",0,1} ,;
                        {"Visualizar","AxVisual",0,2} ,;
                        {"Liberar"   ,"u_FIN02Libera",0,3},;
                        {"Automatico","u_FIN02Grupo",0,4}}

   dbSelectArea("SE2")
   dbSetOrder(1)
   mBrowse( 6,1,22,75,"SE2",,,,,,aCores)

Return
******************************************************************************************************************
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FIN02Libera¦ Autor ¦ Ronilton O. Barros   ¦ Data ¦ 13/02/2006 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Efetua liberação de bloqueio do título                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FIN02Libera()
   Local nDias, dDtLib

   dbSelectArea("SE2")
   If E2_SALDO > 0
      nDias  := GetMv("MV_APRPAG")
      dDtLib := If( E2_VENCREA > E2_DATALIB , E2_VENCREA, E2_DATALIB)

      // Caso a data de liberação tenha ultrapassado o máximo de dias permitido.
      If E2_BLQBAI == "S" .Or. nDias > 0 .And. (Date()-dDtLib) > nDias
         If MsgYesNo("Confirma a liberação do título ?")
            RecLock("SE2",.F.)
            SE2->E2_BLQBAI  := "N"
            SE2->E2_DATALIB := dDataBase
            MsUnLock()
         Endif
      Else
         Aviso("INVÁLIDO","Esse título não está bloqueado !",{"OK"},1)
      Endif
   Else
      Aviso("INVÁLIDO","Esse título já foi totalmente baixado !",{"OK"},1)
   Endif
Return                
******************************************************************************************************************
/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ FIN02Grupo¦ Autor ¦ Marcio Macedo        ¦ Data ¦ 07/12/2006 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Efetua liberação de bloqueio do título                        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function FIN02Grupo()
Local cPerg        := PADR("UNFINA02",len(SX1->X1_GRUPO))
Local lInverte     := .F.
Local aPergs       := {} 
Local nDias
Private lExec      := .F.
Private cIndexName := ''
Private cIndexKey  := ''
Private cFilter    := ''

ValidPerg(cPerg)
if !Pergunte(cPerg,.T.)
  Return
Endif

nDias  := GetMv("MV_APRPAG")
aTmp   := TabTemp()
cMarca := GetMark()

DbSelectArea("TRAB")
dbGoTop()

DEFINE MSDIALOG oDlg TITLE "Seleção de Titulos" FROM 00,00 TO 400,700 PIXEL

oMark := MsSelect():New( "TRAB", "E2_OK",,aTmp,@lInverte, cMarca, { 001, 001, 170, 350 } ,,, )

oMark:oBrowse:Refresh()
oMark:bMark               := { || ( Marcar( cMarca ), oMark:oBrowse:Refresh(.T.) ) }
oMark:bAval               := { || ( Marcar( cMarca ), oMark:oBrowse:Refresh(.T.) ) }
oMark:oBrowse:lHasMark    := .T.
oMark:oBrowse:lCanAllMark := .T.
oMark:oBrowse:bAllMark    := { || ( MarcaTudo( cMarca ), oMark:oBrowse:Refresh(.T.) ) }

DEFINE SBUTTON oBtn1 FROM 180,310 TYPE 1 ACTION (lExec := .T.,oDlg:End()) ENABLE
DEFINE SBUTTON oBtn2 FROM 180,280 TYPE 2 ACTION (lExec := .F.,oDlg:End()) ENABLE

ACTIVATE MSDIALOG oDlg CENTERED

dbGoTop()
If lExec
	Processa({||FIN02LibGrupo()})
Endif

TRAB->(dbCloseArea())
Return Nil  

******************************************************************************************************************
         
Static Function TabTemp()
Local aDbf := {}
Local cArq := ""
Local cInd := ""
Local cQry := ""
Local aTmp := { {"E2_OK", NIL, "", }}
Local nDias  := GetMv("MV_APRPAG")
aDbf := SE2->( dbStruct() )

// Preenche o vetor aTmp para exibição dos campos no MarkBrowse
SX3->(dbSetOrder(2))
For x:=1 To Len(aDbf)
   SX3->(dbSeek(aDbf[x,1]))
   If X3USO(SX3->x3_usado) .And. cNivel >= SX3->x3_nivel .And. SX3->X3_BROWSE=="S"
      AAdd( aTmp , { aDbf[x,1], NIL, X3Titulo(), })
   Endif
Next

cArq := CriaTrab( aDbf , .T. )
Use &cArq Alias TRAB New Exclusive
cInd := CriaTrab( NIL , .F. )
IndRegua("TRAB",cInd,"E2_NUMBOR+E2_PREFIXO+E2_NUM+E2_FORNECE",,,"Selecionando Registros...")

cQry  := "SELECT * "
cQry  += "FROM "+RetSQLName("SE2")+" "
cQry  += "WHERE D_E_L_E_T_ <> '*' "
cQry  += "AND E2_FILIAL='  ' AND E2_SALDO>0 "
cQry  += "AND E2_NUMBOR>='"+MV_PAR01+"' AND E2_NUMBOR<='"+MV_PAR02+"' "
cQry  += "AND E2_PREFIXO>='"+MV_PAR03+"'AND E2_PREFIXO<='"+MV_PAR04+"' "
cQry  += "AND E2_NUM>='"+MV_PAR05+"' AND E2_NUM<='"+MV_PAR06+"' "
cQry  += "AND E2_FORNECE>='"+MV_PAR07+"'AND E2_FORNECE<='"+MV_PAR08+"' "
cQry  += "AND E2_PREFIXO<>'PA'"
cQry  += "AND (E2_BLQBAI='S' OR ((E2_VENCREA>E2_DATALIB AND (DATEDIFF(DAY,E2_VENCREA,'"+DTOS(Date())+"'))>'"+Alltrim(str(nDias))+"') "
cQry  += "OR (E2_VENCREA<=E2_DATALIB AND (DATEDIFF(DAY,E2_DATALIB,'"+DTOS(Date())+"'))>'"+Alltrim(str(nDias))+"'))) "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQry)),"TMP",.F.,.T.)
   
   For nX:=1 To Len(aDbf)
      If aDbf[nX,2] != "C"
         TCSetField("TMP",aDbf[nX,1],aDbf[nX,2],aDbf[nX,3],aDbf[nX,4])
      Endif
   Next nX 
   
dbSelectArea("TMP")
while !TMP->(EOF())
   RecLock("TRAB",.T.)
   For nX:=1 To TMP->(fCount())
     FieldPut(FieldPos(TMP->(FieldName(nx))),TMP->(FieldGet(nx)))
   Next
   MSUnlock()
  TMP->(dbSkip())
Enddo
TMP->(dbCloseArea())
dbSelectArea("TRAB")

Return(aTmp)

******************************************************************************************************************

Static Function FIN02LibGrupo()
   Local nDias, dDtLib
   nDias  := GetMv("MV_APRPAG")
   SE2->(dbSetOrder(1))
   dbSelectArea("TRAB")
   TRAB->(dbGoTop())
   While !TRAB->(Eof())
      if TRAB->E2_OK == cMarca
		 SE2->(dbSeek(xFilial("SE2")+TRAB->E2_PREFIXO+TRAB->E2_NUM+TRAB->E2_PARCELA+TRAB->E2_TIPO+TRAB->E2_FORNECE+TRAB->E2_LOJA))
         
         RecLock("SE2",.F.)
            SE2->E2_BLQBAI  := "N"
            SE2->E2_DATALIB := dDataBase
         MsUnLock()	       
	    
      Endif      
      TRAB->(dbSkip())
   Enddo

Return 

******************************************************************************************************************

Static Function Marcar(cMarca)
   RecLock("TRAB",.F.)
   TRAB->E2_OK := If( E2_OK <> cMarca , cMarca, Space(Len(E2_OK)))
   MsUnLock()
Return .T.

******************************************************************************************************************

Static Function MarcaTudo(cMarca)
   Local nReg := TRAB->(Recno())

   dbSelectArea("TRAB")
   dbGoTop()
   While !Eof()
      Marcar(cMarca)
      dbSkip()
   Enddo
   dbGoTo(nReg)

Return .T.

******************************************************************************************************************                          

Static Function ValidPerg(cPerg)
   Local nTam := TamSX3("E2_NUM")[1]

   PutSX1(cPerg,"01",PADR("Do Bordero      ",29)+"?","","","mv_ch1","C",  06,0,0,"G","","      ","","","mv_par01")
   PutSX1(cPerg,"02",PADR("Ate o Bordero   ",29)+"?","","","mv_ch2","C",  06,0,0,"G","","      ","","","mv_par02")
   PutSX1(cPerg,"03",PADR("Do Prefixo      ",29)+"?","","","mv_ch3","C",  03,0,0,"G","","      ","","","mv_par03")
   PutSX1(cPerg,"04",PADR("Ate o Prefixo   ",29)+"?","","","mv_ch4","C",  03,0,0,"G","","      ","","","mv_par04")
   PutSX1(cPerg,"05",PADR("Do Titulo       ",29)+"?","","","mv_ch5","C",nTam,0,0,"G","","      ","","","mv_par05")
   PutSX1(cPerg,"06",PADR("Ate o Titulo    ",29)+"?","","","mv_ch6","C",nTam,0,0,"G","","      ","","","mv_par06")
   PutSX1(cPerg,"07",PADR("Do Fornecedor   ",29)+"?","","","mv_ch7","C",  06,0,0,"G","","SA2   ","","","mv_par07")
   PutSX1(cPerg,"08",PADR("Ate o Fornecedor",29)+"?","","","mv_ch8","C",  06,0,0,"G","","SA2   ","","","mv_par08")
Return