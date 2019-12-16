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

        if ( not(reqObj.cpf = "11111111111" and reqObj.senha = "CHAVEíííí") ) then
            call retornaJsonResponseErro("Cpf e/ou senha inválidos", "4")
        end if
		
		dim conexao : set conexao = JSON.parse("{}")
		conexao.set "operacao"			, "retorno"
		conexao.set "codigo_retorno"	, reqObj.cpf
		conexao.set "chave_retorno"		, reqObj.chave_validacao
		conexao.set "chave_validacao"	, reqObj.cpf
		
		dim dados : set dados = JSON.parse("{}")
		dados.set "dado1"			, reqObj.dados.dado1
		dados.set "dado2"			, reqObj.dados.dado2
		dados.set "dado3"			, reqObj.dados.dado3
		dados.set "dado4"			, reqObj.dados.dado4
		
		dim resp : set resp = JSON.parse("{}")
		resp.set "conexao"		, conexao
		resp.set "dados"        , dados

		retornaRespostaWs(JSON.stringify(resp))
	end function

'''''
    private function operacaoOutraOperacao(reqJson) 
        if Session("tratarErros")  then On Error resume next

        Set reqObj = JSON.parse(reqJson)
		
		'Apenas um exemplo de uso do WS
		dim resp : set resp = JSON.parse("{}")
	    resp.set "respostaDiferente1" , "Sucesso"
		resp.set "respostaDiferente2" , "0"
		resp.set "respostaDiferente3" , reqObj.operacao 		
		resp.set "respostaDiferente4" , reqObj.chave_validacao 
		resp.set "respostaDiferente5" , reqObj.cpf		      	
		resp.set "respostaDiferente6" , reqObj.senha

		retornaRespostaWs(JSON.stringify(resp))
		
		set resp = nothing
	end function
%>

