<!-- #include file="json2.asp"-->
<!-- #include file="jsonWsUtil.asp"-->
<!-- #Include Virtual="/aafbb/permissao/iniciarpaginapublica.asp"-->
<!-- #Include file="hexadecimalFUN.asp"-->
<!-- #Include Virtual="/aafbb/util/banco/executarfunsql.asp"-->
<!-- #Include Virtual="/aafbb/util/criptografia/MD5/CalcularMD5FUN.asp"-->
       
<%	
	'Se false, mostra os erros na tela sem tratamento
    Session("tratarErros") = true
	
	Response.AddHeader "Content-Type", "application/json;charset=UTF-8"
    Response.CodePage = 65001
    Response.CharSet = "UTF-8"
	
	Set conexao = IniciarPaginaPublicaFun("CRM_AAFBB", "", "")

    if Session("tratarErros")  then On Error resume next
	 
	reqJson = recuperaJson()

	'Verifica se a mensagem do request eh um json
	call isJsonOk(reqJson)
	
    
    set reqObj = JSON.parse(reqJson)
	
	
	if (len(pegaAtributo(reqObj,"CPF")) <> 11) then
		call retornaJsonResponseErro("O CPF deve ter 11 números", "6")
	end if

    'Roda a rotina dependendo do conteudo do atributo 'OPERACAO'
    select case uCase(pegaAtributo(reqObj,"operacao"))
		case "VERIFICAR_USUARIO"
			call operacaoVerificarUsuario(reqJson)
		case "LEITURA_DADOS"
			call operacaoLeituraDados(reqJson)
		case "ALTERACAO_DADOS"
			call operacaoAlteracaoDados(reqJson)
		
		'EXEMPLOS
		case "EXEMPLO_1"
            call operacaoExemploUm(reqJson)
        case "EXEMPLO_2"
            call operacaoExemploDois(reqJson)
        case else 'Default
            call retornaJsonResponseErro("Não existe rotina para essa operação", "5")
	End Select
    call errorHandler(err.number, err.description)

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' FUNCTIONS ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

	function operacaoVerificarUsuario(reqJson)
		if Session("tratarErros")  then On Error resume next
		
		Set reqObj = JSON.parse(reqJson)
		
		sql = "select * from crm_socio where CPF = '" & pegaAtributo(reqObj,"CPF") & "' and pwd_socio = '" & pegaAtributo(reqObj,"SENHA") & "' "
		
		call gravaLog("\aafbb\ws\log\wsAppAafbb-"&pegaAtributo(reqObj,"OPERACAO"),_
												 "SQL:"& vbcrlf & sql &_
												vbcrlf & vbcrlf &_
												"JSON:"& vbcrlf & reqJson)
		
		Set rsSocio = ExecutarFunSql(conexao, sql)
				
		if rsSocio.eof then
			call retornaJsonResponse("404", "VERIFICAR_USUARIO", pegaAtributo(reqObj,"CPF"), pegaAtributo(reqObj,"SENHA"), "DADOS NÃO ENCONTRADOS")	
		end if
		
		'Necessario pois Asc2Hex(rsSocio("NOME")) nao funciona
		strNOME 			= rsSocio("NOME")                         
		strEND_CEP 			= rsSocio("END_CEP")                      
		strEND_LOGR_TIPO 	= cstr(rsSocio("END_LOGR_TIPO"))          
		strEND_LOGR_NOME 	= rsSocio("END_LOGR_NOME")                
		strEND_NUMERO 		= rsSocio("END_NUMERO")                   
		strEND_COMPLEMENTO	= rsSocio("END_COMPLEMENTO")              
		strEND_BAIRRO 		= rsSocio("END_BAIRRO")                   
		strEND_MUNICIPIO 	= rsSocio("END_MUNICIPIO")                
		strCD_UF 			= rsSocio("CD_UF")                        
		strDDD 				= rsSocio("DDD")                          
		strTELEFONE1 		= rsSocio("TELEFONE1")                    
		strDDD_CEL 			= rsSocio("DDD_FAX")	                  
		strTEL_CEL 			= rsSocio("FAX")                          
		strEMAIL 			= rsSocio("EMAIL")	                      
		strMATRICULA 		= rsSocio("MATRICULA")	                  
		strMATRICULA_AAFBB 	= rsSocio("MATRICULA_AAFBB")	          
		strID_SOCIO 		= rsSocio("ID_SOCIO")                     
		strFLAG_ATIVO		= rsSocio("FLAG_ATIVO")                                                                          
				 
		dim reg : set reg = JSON.parse("{}")
		reg.set "NOME"				,Asc2Hex(strNOME)
		reg.set "CEP"				,Asc2Hex(strEND_CEP)
		reg.set "TIPO_LOGRADOURO"	,Asc2Hex(strEND_LOGR_TIPO)
		reg.set "NOME_LOGRADOURO"	,Asc2Hex(strEND_LOGR_NOME)
		reg.set "NUMERO_ENDERECO"	,Asc2Hex(strEND_NUMERO)
		reg.set "COMPLEMENTO"		,Asc2Hex(strEND_COMPLEMENTO)
		reg.set "BAIRRO"			,Asc2Hex(strEND_BAIRRO)
		reg.set "MUNICIPIO"			,Asc2Hex(strEND_MUNICIPIO)
		reg.set "UF"				,Asc2Hex(strCD_UF)
		reg.set "DDD"				,Asc2Hex(strDDD)
		reg.set "TELEFONE"			,Asc2Hex(strTELEFONE1)
		reg.set "DDD_CEL"			,Asc2Hex(strDDD_CEL)
		reg.set "TEL_CEL"			,Asc2Hex(strTEL_CEL)
		reg.set "EMAIL"				,Asc2Hex(strEMAIL)
		reg.set "MATRICULA"			,Asc2Hex(strMATRICULA)
		reg.set "MATRICULA_AAFBB"	,Asc2Hex(strMATRICULA_AAFBB)
		reg.set "ID_SOCIO"			,Asc2Hex(strID_SOCIO)
		reg.set "FLAG_ATIVO"	    ,Asc2Hex(strFLAG_ATIVO)
		
		dim listaReg(0) 
		set listaReg(0) = reg
		
		dim retorno : set retorno = JSON.parse("{}")
		retorno.set "RETORNO"	, "0"
		retorno.set "OPERACAO"	, "VERIFICAR_USUARIO"
		retorno.set "USUARIO"	, pegaAtributo(reqObj,"CPF")
		retorno.set "SENHA"		, pegaAtributo(reqObj,"SENHA")
		retorno.set "REG"		, listaReg

		call errorHandler(err.number, err.description)
		
		retornaRespostaWs(JSON.stringify(retorno))
		
	end function
	
	function operacaoLeituraDados(reqJson)
		if Session("tratarErros")  then On Error resume next
		Set reqObj = JSON.parse(reqJson)
		
		sql = _
			"select * "&_
			"from crm_socio "&_
			"where (" &_
            "id_socio 		= '"& pegaAtributo(reqObj,"CPF") & "'" &_
			" or CPF		= '"& pegaAtributo(reqObj,"CPF") &_
			"') " &_ 
			" and pwd_socio = '"& pegaAtributo(reqObj,"SENHA") & "'"	
		
		call gravaLog("\aafbb\ws\log\wsAppAafbb-"&pegaAtributo(reqObj,"OPERACAO"),_
										 "SQL:"& vbcrlf & sql &_
										vbcrlf & vbcrlf &_
										"JSON:"& vbcrlf & reqJson)
		
		Set rsSocio = ExecutarFunSql(conexao, sql)
		
		'Se retorno da query for vazio
		if rsSocio.eof then
			call retornaJsonResponse("404", "LEITURA_DADOS", pegaAtributo(reqObj,"CPF"), pegaAtributo(reqObj,"SENHA"), "DADOS NÃO ENCONTRADOS")	
		end if
		
		strNOME 			= rsSocio("NOME")
		strEND_CEP 			= rsSocio("END_CEP")
		strEND_LOGR_TIPO 	= cstr(rsSocio("END_LOGR_TIPO"))
		strEND_LOGR_NOME 	= rsSocio("END_LOGR_NOME")
		strEND_NUMERO 		= rsSocio("END_NUMERO")
		strEND_COMPLEMENTO	= rsSocio("END_COMPLEMENTO")
		strEND_BAIRRO 		= rsSocio("END_BAIRRO")
		strEND_MUNICIPIO 	= rsSocio("END_MUNICIPIO")
		strCD_UF 			= rsSocio("CD_UF")
		strDDD 				= rsSocio("DDD")
		strTELEFONE1 		= rsSocio("TELEFONE1")
		strDDD_CEL 			= rsSocio("DDD_FAX")	
		strTEL_CEL 			= rsSocio("FAX")
		strEMAIL 			= rsSocio("EMAIL")	
		strMATRICULA 		= rsSocio("MATRICULA")	
		strMATRICULA_AAFBB 	= rsSocio("MATRICULA_AAFBB")
		strCD_TIPOSOCIO     = cStr(rsSocio("CD_TIPOSOCIO"))
		strID_SOCIO 		= rsSocio("ID_SOCIO")
		strFLAG_ATIVO		= rsSocio("FLAG_ATIVO")	
		
		IF strCD_TIPOSOCIO = 1 THEN
		    str_TIPOSOCIO = "APOSENTADO"
			str_TIPOCATEGRIA = "EFETIVO"
		ELSEIF strCD_TIPOSOCIO = 2 THEN
			str_TIPOSOCIO = "PENSIONISTA"
			str_TIPOCATEGRIA = "PENSIONISTA"
		ELSEIF strCD_TIPOSOCIO = 3 THEN
			str_TIPOSOCIO = "EM EXERCICIO"
			str_TIPOCATEGRIA = "COLABORADOR"
		ELSEIF strCD_TIPOSOCIO = 4 THEN
			str_TIPOSOCIO = "FAMILIA"
			str_TIPOCATEGRIA = "FAMILIA"
		ELSEIF strCD_TIPOSOCIO = 5 THEN
			str_TIPOSOCIO = "COMUNITARIO"
			str_TIPOCATEGRIA = "OUTROS"
		ELSEIF strCD_TIPOSOCIO = 6 THEN
			str_TIPOSOCIO = "COLABORADOR"
			str_TIPOCATEGRIA = "COLABORADOR"
		ELSEIF strCD_TIPOSOCIO = 7 THEN
			str_TIPOSOCIO = "EX-FUNCIONARIO BB/BCB/PREVI/CASSI"
			str_TIPOCATEGRIA = "EFETIVO"
		ELSEIF strCD_TIPOSOCIO = 8 THEN
			str_TIPOSOCIO = "AFINIDADE"
			str_TIPOCATEGRIA = "OUTROS"
		ELSEIF strCD_TIPOSOCIO = 9 THEN
			str_TIPOSOCIO = "APOSENTADO I"
			str_TIPOCATEGRIA = "EFETIVO I"
		ELSEIF strCD_TIPOSOCIO = 10 THEN
			str_TIPOSOCIO = "PENSIONISTA I"
			str_TIPOCATEGRIA = "PENSIONISTA I"
		ELSEIF strCD_TIPOSOCIO = 11 THEN
			str_TIPOSOCIO = "FAMILIA I"
			str_TIPOCATEGRIA = "FAMILIA I"
		ELSEIF strCD_TIPOSOCIO = 12 THEN
			str_TIPOSOCIO = "EM EXERCICIO I"
			str_TIPOCATEGRIA = "COLABORADOR I"
		ELSEIF strCD_TIPOSOCIO = 13 THEN
			str_TIPOSOCIO = "EX-FUNCIONARIO BB/BCB/PREVI/CASSI I"
			str_TIPOCATEGRIA = "EFETIVO I"
		END IF
		
		dim reg : set reg = JSON.parse("{}")
		reg.set "NOME"				,Asc2Hex(strNOME)
		reg.set "CEP"				,Asc2Hex(strEND_CEP)
		reg.set "TIPO_LOGRADOURO"	,Asc2Hex(strEND_LOGR_TIPO)
		reg.set "NOME_LOGRADOURO"	,Asc2Hex(strEND_LOGR_NOME)
		reg.set "NUMERO_ENDERECO"	,Asc2Hex(strEND_NUMERO)
		reg.set "COMPLEMENTO"		,Asc2Hex(strEND_COMPLEMENTO)
		reg.set "BAIRRO"			,Asc2Hex(strEND_BAIRRO)
		reg.set "MUNICIPIO"			,Asc2Hex(strEND_MUNICIPIO)
		reg.set "UF"				,Asc2Hex(strCD_UF)
		reg.set "DDD"				,Asc2Hex(strDDD)
		reg.set "TELEFONE"			,Asc2Hex(strTELEFONE1)
		reg.set "DDD_CEL"			,Asc2Hex(strDDD_CEL)
		reg.set "TEL_CEL"			,Asc2Hex(strTEL_CEL)
		reg.set "EMAIL"				,Asc2Hex(strEMAIL)
		reg.set "MATRICULA"			,Asc2Hex(strMATRICULA)
		reg.set "MATRICULA_AAFBB"	,Asc2Hex(strMATRICULA_AAFBB )
		reg.set "TIPO_SOCIO"		,Asc2Hex(str_TIPOSOCIO)
		reg.set "CATEGORIA_SOCIO"	,Asc2Hex(str_TIPOCATEGRIA)
		reg.set "ID_SOCIO"			,Asc2Hex(strID_SOCIO)
		reg.set "FLAG_ATIVO"	    ,Asc2Hex(strFLAG_ATIVO)

		dim retorno : set retorno = JSON.parse("{}")
		retorno.set "RETORNO"	, "0"
		retorno.set "OPERACAO"	, "LEITURA_DADOS"
		retorno.set "USUARIO"	, pegaAtributo(reqObj,"CPF")
		retorno.set "SENHA"		, pegaAtributo(reqObj,"SENHA")
		retorno.set "REG"		, reg
		
		retornaRespostaWs(JSON.stringify(retorno))
	end function 
	
	
	
	function operacaoAlteracaoDados(reqJson)
		if Session("tratarErros")  then On Error resume next
		
		Set reqObj = JSON.parse(reqJson)
		
		Set reg = reqObj.reg.get(0)
		
		sql = _
			"Update CRM_SOCIO set " &_                                                         	
			"	END_CEP 			= nvl('"& Hex2Asc(pegaAtributo(reg,"CEP"))				& "',END_CEP), " &_  
			"	END_LOGR_TIPO 		= nvl('"& Hex2Asc(pegaAtributo(reg,"TIPO_LOGRADOURO"))	& "',END_LOGR_TIPO), " &_ 
			"	END_LOGR_NOME 		= nvl('"& Hex2Asc(pegaAtributo(reg,"NOME_LOGRADOURO"))	& "',END_LOGR_NOME), " &_ 
			"	END_NUMERO 			= nvl('"& Hex2Asc(pegaAtributo(reg,"NUMERO_ENDERECO"))	& "',END_NUMERO), " &_ 
			"	END_BAIRRO 			= nvl('"& Hex2Asc(pegaAtributo(reg,"BAIRRO"))			& "',END_BAIRRO), " &_ 
			"	END_COMPLEMENTO 	= nvl('"& Hex2Asc(pegaAtributo(reg,"COMPLEMENTO"))		& "',END_COMPLEMENTO), " &_ 
			"	END_MUNICIPIO 		= nvl('"& Hex2Asc(pegaAtributo(reg,"MUNICIPIO"))		& "',END_MUNICIPIO), " &_ 
			"	CD_UF 				= nvl('"& Hex2Asc(pegaAtributo(reg,"UF"))				& "',CD_UF), " &_ 
			"	DDD 				= nvl('"& Hex2Asc(pegaAtributo(reg,"DDD"))				& "',DDD), " &_ 
			"	TELEFONE1 			= nvl('"& Hex2Asc(pegaAtributo(reg,"TELEFONE"))			& "',TELEFONE1), " &_ 
			"	DDD_FAX 			= nvl('"& Hex2Asc(pegaAtributo(reg,"DDD_CEL"))			& "',DDD_FAX), " &_ 
			"	FAX 				= nvl('"& Hex2Asc(pegaAtributo(reg,"TEL_CEL"))			& "',FAX), " &_ 
			"	EMAIL 				= nvl('"& Hex2Asc(pegaAtributo(reg,"EMAIL"))			& "',EMAIL) " &_ 
			"where CPF 				= '"& pegaAtributo(reqObj,"CPF") &_
			"' and PWD_SOCIO 		= '"& pegaAtributo(reqObj,"SENHA") & "'"	  
		
		call gravaLog("\aafbb\ws\log\wsAppAafbb-"&pegaAtributo(reqObj,"OPERACAO"),_
								 "SQL:"& vbcrlf & sql &_
								vbcrlf & vbcrlf &_
								"JSON:"& vbcrlf & reqJson)
		
		ExecutarBeginTransPrc conexao, null, null, null
		Set rsSocio = ExecutarFunSql(conexao, sql) 
		Set rsSocio = nothing
		ConfirmarTransacaoPrc conexao

		call errorHandler(err.number, err.description)
		
		call retornaJsonResponse("0", "ALTERACAO_DADOS", pegaAtributo(reqObj,"CPF"), pegaAtributo(reqObj,"SENHA"), "ALTERACAO EFETUADA COM SUCESSO")	
	end function
	
	'EXEMPLO 1
    function operacaoExemploUm(reqJson)
		'EXEMPLO DE CHAMADA E RESPOSTA COM "SUB OBJETOS"
			'{
			'	"operacao": "EXEMPLO_1",
			'	"chave_validacao": "chave_validacao",
			'	"cpf": "12345678910",
			'	"senha":"123mudar",
			'		"dados": {
			'			"dado1": "um dado com caracter especial áéóú",
			'			"dado2": ""
			'		}
			'}
	
        if Session("tratarErros")  then On Error resume next
        Set reqObj = JSON.parse(reqJson)

        if ( not( pegaAtributo(reqObj,"cpf") = "12345678910" and pegaAtributo(reqObj,"senha") = "123mudar") ) then
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
		dados.set "resposta_objeto_da_rquisicao", pegaAtributo(reqObj,"dados")
		
		
		dim resp : set resp = JSON.parse("{}")
		resp.set "conexao"		, conexao
		resp.set "dados"		, dados

		retornaRespostaWs(JSON.stringify(resp))
	end function
	
'''''
	'EXEMPLO 2
    function operacaoExemploDois(reqJson)
		'EXEMPLO DE CHAMADA E RESPOSTA
		'{
		'	"operacao": "EXEMPLO_2",
		'	"chave_validacao": "chave_validacao",
		'	"cpf": "12345678910",
		'	"senha":"123mudar"
		'}

        if Session("tratarErros")  then On Error resume next
		
        Set reqObj = JSON.parse(reqJson)
		
		dim resp : set resp = JSON.parse("{}")
	    resp.set "cpf_da_requisicao"				, pegaAtributo(reqObj,"cpf")
		resp.set "chave_validacao_da_requisicao"	, pegaAtributo(reqObj,"chave_validacao")
		resp.set "senha_da_requisicao"				, pegaAtributo(reqObj,"senha")
		resp.set "operacao_da_requisicao"			, pegaAtributo(reqObj,"operacao")
		resp.set "atributo1"						, "exemplo de atributo fixo"	      	
		resp.set "atributo2"						, "outro atributo com conteúdo fixo"

		retornaRespostaWs(JSON.stringify(resp))
		
		set resp = nothing
	end function 
%>

