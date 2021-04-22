#INCLUDE "RWMAKE.CH"

/*_________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ Função    ¦ AGPLOJP003  ¦ Autor ¦ Reinaldo            ¦ Data ¦ 19.02.15      ¦¦¦
¦¦+-----------+-------------+-------+---------------------+------+---------------+¦¦
¦¦¦ Descriçäo ¦ Planilha com folha de pagamento                                  ¦¦¦
¦¦+-----------+------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦*/

User Function AGLOJP003 
//***********************************//
// Função de geração de Plainha CSV
// Analista : Raul Capeleti
//***********************************//
 
//- Arquivo temporario de consulta
aStru:= { {"RA_FILIAL" , "C", 2 , 0 },;
          {"RA_MAT"    , "C", 6 , 0 },;
          {"RA_NOME"   , "C", 45, 0 },;
          {"RA_SALARIO", "N", 9 , 2 },;	          
          {"FIM", "N", 9 , 2 } }
	
cFile:= CriaTrab(aStru,.t.)
dbUseArea(.t.,,cFile,"TEMP1",.F.,.F.)

dbSelectArea("TEMP1") // arquivo temporario de exemplo
TEMP1->( dbGoTop() )
 
// Chamada da função para geração co Arq. CSV
If ApMsgYesNO('Gerar Planilha em Excel agora ?')
   MsAguarde({||GeraExcel()},"Aguarde","Gerando dados para a Planilha",.F.)                                          
Endif
 
DbSelectArea("TEMP1")
dbCloseArea()
Ferase(cFile+GetDBExtension())
 
Return
           
/***********************************/
  Static Function GeraExcel()
/***********************************/    
// Cria arquivo temporario
local cArqTrb1 := CriaTrab(NIL,.F.) 
local aStru 	:= {}
Local aHeader := {}	
_cAlias := "TEMP1"
// array com os campos para a planilha
aadd(aHeader, {"EMP    "   ,"RA_FILIAL"   ,"@!",02,0,"","","C","TEMP1","R"})
aadd(aHeader, {"Matricula" ,"RA_MAT"	  ,"@!",06,0,"","","C","TEMP1","R"})
aadd(aHeader, {"Nome"      ,"RA_NOME"	  ,"@!",45,0,"","","C","TEMP1","R"})
aadd(aHeader, {"Salario"	,"RA_SALARIO" ,"@E 999,999.99",09,2,"","","N","TEMP1","R"})
aadd(aHeader, {"    "      ,"FIM"  	      ,"@!",02,2,"","","N","TEMP1","R"}) // COLUNA DE CONTROLE DO ENCHOICE ( DELETADO OU NÃO )
// Este último campo é o marcador de registro deletado, se não for criado a última coluna será utilizada para tal e perdida na planilha gerada...
 
// Chamada da função de conversão para a planilha
MsAguarde({||GeraCSV(_cAlias,,aHeader)},"Aguarde","Gerando Planilha",.F.) 
 
Return 
 
/******************************************************/
	Static Function geraCSV(_cAlias,_cFiltro,aHeader)                
/******************************************************/	
local cDirDocs  := MsDocPath()
Local cArquivo 	:= CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX
local _cArq		:= ""
	
_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)
	
if !empty(_cFiltro)
		(_cAlias)->(dbsetfilter({|| &(_cFiltro)} , _cFiltro))
endif
	
nHandle := MsfCreate(cDirDocs+""+cArquivo+".CSV",0)
	
If nHandle > 0
		
		// Grava o cabecalho do arquivo
		aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
		fWrite(nHandle, cCrLf ) // Pula linha
		
		(_cAlias)->(dbgotop())
		while (_cAlias)->(!eof())
			
			for _ni := 1 to len(aHeader)
				
				_uValor := ""
				
				if aHeader[_ni,8] == "D" // Trata campos data
					_uValor := dtoc(&(_cAlias + "->" + aHeader[_ni,2]))
				elseif aHeader[_ni,8] == "N" // Trata campos numericos
					_uValor := transform(&(_cAlias + "->" + aHeader[_ni,2]),aHeader[_ni,3])
				elseif aHeader[_ni,8] == "C" // Trata campos caracter
					_uValor := &(_cAlias + "->" + aHeader[_ni,2])
				endif
				
				if _ni <> len(aHeader)
					fWrite(nHandle, _uValor + ";" )
				endif
				
			next _ni
			
			fWrite(nHandle, cCrLf )
			
			(_cAlias)->(dbskip())
			
		enddo
		
		fClose(nHandle)
		CpyS2T( cDirDocs+""+cArquivo+".CSV" , cPath, .T. )
		
		If ! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado')
			Return
		EndIf
		
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
Else
		MsgAlert("Falha na criação do arquivo")
Endif
	
(_cAlias)->(dbclearfil())
	
Return