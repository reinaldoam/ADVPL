#include "Rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AGFINP02 º Autor ³ Reinaldo Magalhães º Data ³ 09/01/16    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para liberar titulos para baixa.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                                          
User Function AGFINP02()
   Local aCores  := { {"E1_XLIBBX == 'S'" ,"ENABLE" },; // Liberado para baixa
                      {"E1_XLIBBX == ' '","DISABLE"}}   // Bloqueado para baixa

   Private cCadastro := "Liberação de Titulo para baixa" 

   Private aRotina := { {"Pesquisar" ,"AxPesqui",0,1} ,;
                        {"Visualizar","AxVisual",0,2} ,;
                        {"Liberar"   ,"u_FIN02Libera",0,3}}

   dbSelectArea("SE1")
   dbSetOrder(1)
   mBrowse( 6,1,22,75,"SE1",,,,,,aCores)

Return

///////////////////////////
User Function FIN02Libera()
   Local cUsr := Upper(GetMv("MV_XLIBBX"))
   Local nDias, dDtLib                           

   dbSelectArea("SE1")
   
   If !(UPPER(Trim(SubStr(cUsuario,7,15))) $ cUsr)
      MsgBox("Usuario não autorizado!")
      Return
   Endif     
   
   If E1_SALDO > 0 .And. (Alltrim(E1_NATUREZ)=='31101001' .Or. Alltrim(E1_NATUREZ)=='31101001A' .Or. Alltrim(E1_NATUREZ)=='DEPOSITO')
      If Empty(E1_XLIBBX)  
         If MsgYesNo("Confirma a liberação do título ?")
            RecLock("SE1",.F.)
            SE1->E1_XLIBBX:= "S"
            SE1->E1_XDTLIB := dDataBase
            MsUnLock()
         Endif
      Else                                              
         If MsgYesNo("Esse título já está liberado. Cancela liberação ?")
            RecLock("SE1",.F.)
            SE1->E1_XLIBBX:= " "
            SE1->E1_XDTLIB := Ctod(Space(6))
            MsUnLock()
         Endif   
      Endif
   Else
      Aviso("INVÁLIDO","Esse título não pode ser liberado !",{"OK"},1)
   Endif
Return