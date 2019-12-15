
<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="JSON_2.0.4.asp"-->
<!--#include file="json2.asp"-->
<!--#include file="jsonWsUtil.asp"-->
       
<%	
    Session("tratarErros") = true
	Response.AddHeader "Content-Type", "json/application;charset=UTF-8"
    Response.CodePage = 65001
    Response.CharSet = "UTF-8"
   
    'Se false, mostra os erros na tela sem tratamento
    if Session("tratarErros")  then On Error resume next

	'Configuracao dos atributos esperados no request do WS
	arrAttrEsperados = Array( "operacao"_
					         ,"chave_validacao"_
					         ,"cpf"_
					         ,"senha")
	 
	reqJson = recuperaJson()

	'Verifica se a mensagem do request eh um json
	call isJsonOk(reqJson)
	
	'Verifica se existem os atributos esperados pelo ws
	call verificaAtributosEsperadosExistem (arrAttrEsperados, reqJson)
	

    
    set reqObj = JSON.parse(reqJson)

    'Roda a rotina dependendo do conteudo do atributo 'OPERACAO'
    select case uCase(reqObj.operacao)
        case "RECUPERA_USUARIO"
            call operacaoRecuperaUsuario(reqJson)
        case "OUTRA_OPERACAO"
            call operacaoOutraOperacao(reqJson)
        
        case else 'Default
            call retornaJsonResponseErro("Não existe rotina para essa operação", "5")
	End Select
    errorHandler()

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' FUNCTIONS '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	

    private function operacaoRecuperaUsuario(reqJson) 
        if Session("tratarErros")  then On Error resume next

        Set reqObj = JSON.parse(reqJson)
		Set resp = jsObject()
        
        if ( not(reqObj.cpf = "11111111111" and reqObj.senha = "senha esperada") ) then
            call retornaJsonResponseErro("Cpf e/ou senha inválidos", "4")
        end if
		
		'Apenas um exemplo de uso do WS
	    resp("mensagem")  = "Sucesso"
		resp("codigo")    = "0"
		resp("resposta1") = reqObj.operacao & "ãããã"		
		resp("resposta2") = reqObj.chave_validacao 
		resp("res")       = reqObj.cpf		      	
		resp("bayblade")  = reqObj.senha

		retornaRespostaWs(toJSON(resp))
		
		set resp = nothing
	end function

'''''
    private function operacaoOutraOperacao(reqJson) 
        if Session("tratarErros")  then On Error resume next

        Set reqObj = JSON.parse(reqJson)
		Set resp = jsObject()
		
		'Apenas um exemplo de uso do WS
	    resp("respostaDiferente1")  = "Sucesso"
		resp("respostaDiferente2")  = "0"
		resp("respostaDiferente3")  = reqObj.operacao 		
		resp("respostaDiferente4")  = reqObj.chave_validacao 
		resp("respostaDiferente5")  = reqObj.cpf		      	
		resp("respostaDiferente6")  = reqObj.senha

		retornaRespostaWs(toJSON(resp))
		
		set resp = nothing
	end function
%>

