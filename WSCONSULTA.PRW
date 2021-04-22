#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#Include 'RestFul.CH'
#Include 'TbiConn.CH'
#Include 'TopConn.CH'

*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | WSCONSULTA  | Autor | Jader Berto                          |*
*+------------+------------------------------------------------------------+*
*|Data        | 21.12.2017                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Consulta Dinâmica para Tabelas do Protheus                 |*
*+------------+------------------------------------------------------------+*
*|Solicitante |                                                            |*
*+------------+------------------------------------------------------------+*
*|Partida     | WebService                                                 |*
*+------------+------------------------------------------------------------+*
*|Arquivos    |                                                            |*
*+------------+------------------------------------------------------------+*
*|             ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            |*
*+-------------------------------------------------------------------------+*
*| Programador       |   Data   | Motivo da alteracao                      |*
*+-------------------+----------+------------------------------------------+*
*|                   |          |                                          |*
*+-------------------+----------+------------------------------------------+*
*****************************************************************************

User Function WSCONSULTA()
Return

WSRESTFUL WSCONSULTA DESCRIPTION "Serviço REST para manipulação de WSCONSULTA"

WSDATA FIL As String
WSDATA FILTRO  As String
WSDATA TABELA  As String

WSMETHOD GET DESCRIPTION "Retorna a Consulta no Protheus informada na URL" WSSYNTAX "/WSCONSULTA || /WSCONSULTA/{}"

END WSRESTFUL





WSMETHOD GET WSRECEIVE FILTRO  WSSERVICE WSCONSULTA
Local oObjProd := Nil
Local cStatus  := ""
Local cJson    := "{"
Local aCabNom  := {}
Local aDados   := {}
Local xAlias
Local TotCol   := 0
Local aLinha   := {}
Local aParam   := {}
Local cQuery   := ""
Local xRecno   := 0
Local cFilCmp  := ""
Local nExts    := 1
Private aFilt  := {}
Private aFilInt  := {}


        xAlias  := Self:TABELA


        aFilt := StrTokArr( Self:FILTRO, "@" )

        cFilAnt := UPPER(Self:FIL)

        ::SetContentType("application/json;  charset=iso-8859-1")

        SX2->( dbGoTop())
        dbSelectArea('SX2')
        If !SX2->( dbSeek( xAlias ) )
            ::SetResponse('{"erro":"Tabela:' +xAlias+'  não foi encontrada na Empresa '+cEmpAnt+' do Protheus."}')
            Return .T.
        EndIf    
        SX2->( dbCloseArea())




        DbSelectArea("SX3")
        DbSetOrder(1)

        SX3->(DbSeek(xAlias))          
        While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == xAlias
            If ( SX3->X3_CONTEXT <> "V" )
                TotCol++
            Endif
        SX3->(DbSkip())
        End

        SX3->(DbGoTop())


        aCabNom := ARRAY(TotCol)

        TotCol := 0
        SX3->(DbSeek(xAlias))          
        While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == xAlias
            If "FILIAL" $ SX3->X3_CAMPO
                cFilCmp := SX3->X3_CAMPO
            EndIF
            If ( SX3->X3_CONTEXT <> "V" )
                TotCol++
                aCabNom[TotCol]    := Alltrim(SX3->X3_CAMPO)
            Endif
        SX3->(DbSkip())
        End        



        /*
        //Título dos campos
        aCab   :=  {"Codigo", "Descricao" , "UM" }
        */


        cQuery := "SELECT * FROM "+RetSqlName(xAlias)
        cQuery += "  WHERE 1=1 "

        For n1 := 1 to Len(aFilt)

            If "$$" $ aFilt[n1]
                aFilInt := ACLONE(StrTokArr(aFilt[n1], "$$" ))
                cQuery += " AND "+aFilInt[1]+" LIKE '%"+aFilInt[2]+"%'"
            Else
                aFilInt := ACLONE(StrTokArr(aFilt[n1], "$" ))
                cQuery += " AND "+aFilInt[1]+"='"+aFilInt[2]+"'"
            EndIf
        Next n1

        If !Empty(xFilial(xAlias))
            cQuery += "  AND "+cFilCmp+" = '"+xFilial(xAlias)+"' "
        EndIf
        cQuery += "  AND D_E_L_E_T_ <> '*' "        


        cQuery := ChangeQuery(cQuery)

        //Antes de criar a tabela, verificar se a mesma já foi aberta
        If (Select("TMP") <> 0)
            dbSelectArea("TMP")
            TMP->(dbCloseArea ())
        Endif

        TCQUERY cQuery Alias TMP NEW

        //Item, Produto, Executado nao medido, executado, valor unitário

        If TMP->(EOF())

            ::SetResponse('{"erro":"Registro nao encontrado na Tabela:' +xAlias+' da Empresa/Filial '+cEmpAnt+cFilAnt+'."}') 
            Return .T.
        EndIF

        While TMP->(!EOF())    

            aLinha := ARRAY(TotCol)

            For n := 1 to TotCol
                If Type("TMP->"+aCabNom[n]) # "U"
                    aLinha[n] := Alltrim(&("TMP->"+aCabNom[n]))
                Else 
                    aLinha[n] := ""
                EndIf
            Next n

            AADD(aDados, aLinha)
        TMP->(DBSkip())
        End
        TMP->(DBCloseArea())





        cJson    += U_JSON( { xAlias , aCabNom, aDados} )

        cJson += "}"

        ::SetResponse(cJson)



Return(.T.)



//Função para Gerar Formato Json
User function JSON(aGeraXML)
Local cJSON  := ""                   
Local cTable := aGeraXML[1]                    
Local aCab   := aGeraXML[2]  
Local aLin   := aGeraXML[3]  

cJSON += '"'+cTable+'": [' 

FOR L:= 1 TO LEN( aLin )

    cJSON += '{'

    for C:= 1 to Len( aCab ) 

        IF VALTYPE(aLin[L][C]) = "C"  
           cConteudo := '"'+U_TIRACENTO(aLin[L][C])+'" '
        ELSEIF VALTYPE(aLin[L][C]) = "N"
            cConteudo := ALLTRIM(STR(aLin[L][C]))
        ELSEIF VALTYPE(aLin[L][C]) = "D"
            cConteudo := '"'+DTOC(aLin[L][C])+'"'
        ELSEIF VALTYPE(aLin[L][C]) = "L"
            cConteudo := IF(aLin[L][C], '"true"' , '"false"') 
        ELSE
            cConteudo := '"'+U_TIRACENTO(aLin[L][C])+'"'
        ENDIF               

        cJSON += '"'+aCab[C]+'":' + cConteudo

        IF C < LEN(aCab)
           cJSON += ','
        ENDIF

    Next C
    cJSON += '}'
    IF L < LEN(aLin)
       cJSON += ','
    ENDIF

Next

cJSON += ']'

Return cJSON