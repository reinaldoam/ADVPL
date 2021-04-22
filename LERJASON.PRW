#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'Totvs.ch'

User Function LERJASON()
Local cFile := '\teste\exemplo1.json'
Local cJsonStr,oJson
Local nId, cNome, lDepend, aAlerg
Local oOutros, cTipoS, lEleitor, lReserv

// Le a string JSON do arquivo do disco 
cJsonStr := readfile(cFile)

// Cria o objeto JSON e popula ele a partir da string
oJson := JSonObject():New()
cErr  := oJSon:fromJson(cJsonStr)

If !empty(cErr)
  MsgStop(cErr,"JSON PARSE ERROR")
  Return
Endif

// Agora vamos ler as propriedades com GetJSonObject()

nId := oJson:GetJSonObject('Id')
cNome := oJson:GetJSonObject('Nome')
lDepend := oJson:GetJSonObject('Dependentes')

// Aqui será retornado um array de strings
aAlerg := oJson:GetJSonObject('Alergias')
cAlerg1 := aAlerg[1]
cAlerg2 := aAlerg[2]

// Objeto dentro de uma propriedade
oOutros := oJson:GetJSonObject('Outros')

cTipoS := oOutros:GetJSonObject('Sangue')
lEleitor := oOutros:GetJSonObject('Eleitor')
lReserv := oOutros:GetJSonObject('Reservista')

// Descarta o objeto 
FreeObj(oJson)

Return

STATIC Function ReadFile(cFile)
Local cBuffer := ''
Local nH , nTam
nH := Fopen(cFile)
IF nH != -1
	nTam := fSeek(nH,0,2)
	fSeek(nH,0)
	cBuffer := space(nTam)
	fRead(nH,@cBuffer,nTam)
	fClose(nH)
Else
	MsgStop("Falha na abertura do arquivo ["+cFile+"]","FERROR "+cValToChar(Ferror()))
Endif
Return cBuffer