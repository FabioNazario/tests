<!--#include file="json2.asp"-->
<!--#include file="jsonWsUtil.asp"-->
       
<%	
	'Se false, mostra os erros na tela sem tratamento
    Session("tratarErros") = true
	
	Response.AddHeader "Content-Type", "application/json;charset=UTF-8"
    Response.CodePage = 65001
    Response.CharSet = "UTF-8"

    if Session("tratarErros")  then On Error resume next
	
	'Configuracao dos atributos esperados no request do WS
	arrAttrEsperados = Array( "operacao" )
	 
	reqJson = recuperaJson()

	'Verifica se a mensagem do request eh um json
	call isJsonOk(reqJson)
	
    
    set reqObj = JSON.parse(reqJson)

    'Roda a rotina dependendo do conteudo do atributo 'OPERACAO'
    select case uCase(pegaAtributo(reqObj,"operacao"))
        case "RECUPERA_USUARIO"
            call operacaoRecuperaUsuario(reqJson)
        case "OUTRA_OPERACAO"
            call operacaoOutraOperacao(reqJson)       
        case else 'Default
            call retornaJsonResponseErro("Não existe rotina para essa operação", "5")
	End Select
    errorHandler()

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' FUNCTIONS ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

    function operacaoRecuperaUsuario(reqJson)
		'EXEMPLO DE CHAMADA E RESPOSTA COM "SUB OBJETOS"
			'{
			'	"operacao": "recupera_usuario",
			'	"chave_validacao": "chave_validacao",
			'	"cpf": "12345678910",
			'	"senha":"123mudar",
			'		"dados": {
			'			"dado1": "dado de entrada 1",
			'			"dado2": "dado de entrada 2"
			'		}
			'}
	
        if Session("tratarErros")  then On Error resume next
        Set reqObj = JSON.parse(reqJson)

        if ( not(reqObj.cpf = "12345678910" and reqObj.senha = "123mudar") ) then
            call retornaJsonResponseErro("Cpf e/ou senha inválidos", "4")
        end if
		
		dim conexao : set conexao = JSON.parse("{}")
		conexao.set "operacao"			, "retorno"
		conexao.set "codigo_retorno"	, "0"
		conexao.set "chave_retorno"		, "esse é um exemplo de chamada"
		conexao.set "chave_validacao"	, "conteudo da chave_validacao: " & pegaAtributo(reqObj,"chave_validacao")
		
		dim dados : set dados = JSON.parse("{}")
		dados.set "dado1resposta"	, pegaAtributo(reqObj,"dados.dado1")
		dados.set "dado2resposta"	, pegaAtributo(reqObj,"dados.dado2")
		
		dim resp : set resp = JSON.parse("{}")
		resp.set "conexao"		, conexao
		resp.set "dados"        , dados

		retornaRespostaWs(JSON.stringify(resp))
	end function
	
'''''
    function operacaoOutraOperacao(reqJson)
		'EXEMPLO DE CHAMADA E RESPOSTA COM "SUB OBJETOS"
		'{
		'	"operacao": "outra_operacao",
		'	"chave_validacao": "chave_validacao",
		'	"cpf": "12345678910",
		'	"senha":"123mudar"
		'}

        if Session("tratarErros")  then On Error resume next
		
        Set reqObj = JSON.parse(reqJson)
		
		'Apenas um exemplo de uso do WS
		dim resp : set resp = JSON.parse("{}")
	    resp.set "cpf_da_requisicao" , pegaAtributo(reqObj,"cpf")
		resp.set "chave_validacao_da_requisicao" , pegaAtributo(reqObj,"chave_validacao")
		resp.set "senha_da_requisicao" 			 , pegaAtributo(reqObj,"senha")
		resp.set "operacao_da_requisicao" , pegaAtributo(reqObj,"operacao")
		resp.set "atributo1" , "exemplo de atributo fixo"	      	
		resp.set "atributo2" , "outro atributo com conteúdo fixo"

		retornaRespostaWs(JSON.stringify(resp))
		
		set resp = nothing
	end function
%>

