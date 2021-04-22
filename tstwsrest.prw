#include "PROTHEUS.ch"
#include "RESTFUL.ch"

#xtranslate @{Header <(cName)>} => ::GetHeader( <(cName)> )
#xtranslate @{Param <n>} => ::aURLParms\[ <n> \]
#xtranslate @{EndRoute} => EndCase
#xtranslate @{Route} => Do Case
#xtranslate @{When <path>} => Case NGIsRoute( ::aURLParms, <path> )
#xtranslate @{Default} => Otherwise

Static aUsers := {{'1','Vitor','27'},{'2','Joao','40'},{'3','Jackson','25'}}

WsRestful tstwsrest Description "WebService REST para testes"

    WsMethod GET Description "Sincronização de dados via GET"    WsSyntax "/GET/{method}"
    WsMethod POST Description "Sincronização de dados via POST"    WsSyntax "/POST/{method}"
    WsMethod DELETE Description "Sincronização de dados via DELETE"    WsSyntax "/DELETE/{method}"

End WsRestful

WsMethod GET WsService tstwsrest
	Local cUser  := ''
    Local nUser

    ::SetContentType( 'application/json' )

    @{Route}
        @{When '/users'}
            cUser := '['
            For nUser := 1 to Len(aUsers)
                cUser += '{"id":'+ aUsers[nUser][1]+;
			    ',"name":"'+aUsers[nUser][2]+;
			    '","age":'+aUsers[nUser][3]+'}'
                cUser += if(nUser < Len(aUsers),',','')
            Next nUser
            cUser += ']'
            ::SetResponse(cUser)
        @{When '/users/{id}'}
            nUser := aScan(aUsers,{|x| x[1] == @{Param 2} })
            If nUser > 0
                cUser := '{"id":'+ aUsers[nUser][1]+;
                            ',"name":"'+aUsers[nUser][2]+;
                            '","age":'+aUsers[nUser][3]+'}'
                ::SetResponse(cUser)
            Else
                SetRestFault(400,'Ops')
                Return .F.
            EndIf
        @{Default}
            SetRestFault(400,"Ops")
            Return .F.    
	@{EndRoute}

Return .T.

WsMethod POST WsService tstwsrest
    Local cJson := ::GetContent()
    Local oParser
    Local cUser, nUser

    ::SetContentType( 'application/json' )

    @{Route}
        @{When '/user'}
            If FwJsonDeserialize(cJson,@oParser)
                aAdd(aUsers,{cValToChar(oParser:id),oParser:name,cValToChar(oParser:age)})
                nUser := Len(aUsers)
                cUser := '{"id":'+ aTail(aUsers)[1]+;
                            ',"name":"'+aUsers[nUser][2]+;
                            '","age":'+aUsers[nUser][3]+'}'
                ::SetResponse(cUser)
            Else
                SetRestFault(400,'Ops')
                Return .F.
            EndIf
        @{Default}
            SetRestFault(400,"Ops")
            Return .F.
    @{EndRoute}
Return .T.

WsMethod DELETE WsService tstwsrest
    Local nUser
    ::SetContentType( 'application/json' )

    @{Route}
        @{When '/user/{id}'}
            nUser := aScan(aUsers,{|x| x[1] == @{Param 2} })
            If nUser > 0
                aDel(aUsers, nUser)
                aSize(aUsers, Len(aUsers) - 1)
            Else
                SetRestFault(400,"Ops")
                Return .F.
            EndIf
        @{Default}
            SetRestFault(400,"Ops")
            Return .F.
    @{EndRoute}
Return .T.