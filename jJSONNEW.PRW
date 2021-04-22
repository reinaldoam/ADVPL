#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'Totvs.ch'

User Function JsonNew()

oJson := JSonObject():New()

oJson['Id'] := 0984
oJson['Nome'] := 'Júlio Wittwer'
oJson['Ok'] := .T.
oJson['Aniversario'] := ctod('03/03/1976')

oJson['Outros'] := JSonObject():New()
oJson['Outros']['Sangue'] := 'A+'
oJson['Outros']['Eleitor'] := .T.
oJson['Outros']['Reservista'] := .T.

conout(oJson:ToJson())

Return