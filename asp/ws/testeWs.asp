<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="JSON_2.0.4.asp"-->
<!--#include file="json2.asp"-->

<%	
	On Error resume next
	
	response.ContentType = "application/json"
	response.Charset = "utf-8"
	
	errorHandler()
	'Configuracao dos atributos esperados no request do WS
	arrAttrEsperados = Array( "operacao"_
					         ,"chave_validacao"_
					         ,"cpf"_
					         ,"senha")
	
	strJson = recuperaJson()
	
	'Verifica se a mensagem do request eh um json
	isJsonOk(strJson)
	
	'Verifica se existem os atributos esperados pelo ws
	atributosEsperadosExistem arrAttrEsperados, strJson
	
	
	''''Aqui fica a regra para montagem da resposta
	retornaRespostaWs(montaJsonResponse(strJson))
	
	'Caso ocorra um erro inesperado

' FUNCTIONS '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	
	
	'Tratamento caso ocorra um erro inesperado
	function errorHandler()
		if err.number <> 0 then
			retornaRespostaWs(montaJsonResponseErro(err.description , cStr(err.number)))
			response.end
		end if
	end function

	
	function atributosEsperadosExistem(arrAttrEsperados, strJson) On Error resume next
		
		For Each attr In arrAttrEsperados
			if inStr(strJson, attr) = 0 then
				retornaRespostaWs(montaJsonResponseErro("Atributo '" & attr & "' não encontrado","3"))
			end if
		Next
		
		errorHandler()
	end function
	
	
	function montaJsonResponseErro(mensagem, codigo) On Error resume next
		Set jsonObj = jsObject()
		jsonObj("mensagem") = mensagem
		jsonObj("codigo") = codigo
		montaJsonResponseErro = toJSON(jsonObj)
		set jsonObj = nothing
		errorHandler()
	end function 
	

	function montaJsonResponse(strJson)
		On Error resume next
		Set req = JSON.parse(strJson)
		Set resp = jsObject()
		
		'Apenas um exemplo de uso do WS
	    resp("mensagem")  = "Sucesso"
		resp("codigo")    = "0"
		resp("resposta1") = req.operacao 		
		resp("resposta2") = req.chave_validacao 
		resp("res")       = req.cpf		      	
		resp("bayblade")  = req.senha
	
		montaJsonResponse = toJSON(resp)
		
		set resp = nothing
		
		errorHandler()
	end function

	
	function recuperaJson() On Error resume next
		bytecount = Request.TotalBytes
		bytes = Request.BinaryRead(bytecount)
		if bytecount = 0 then
			retornaRespostaWs(montaJsonResponseErro("Requisição precisa ter um corpo.", "1"))
			response.end
		end if
		Set stream = Server.CreateObject("ADODB.Stream")
		stream.Type = 1 'adTypeBinary              
		stream.Open()                                   
			stream.Write(bytes)
			stream.Position = 0                             
			stream.Type = 2 'adTypeText                
			stream.Charset = "utf-8"                      
			recuperaJson = stream.ReadText() 'here is your json as a string                
		stream.Close()
		Set stream = nothing
		
		errorHandler()
	end function
	
	
	function retornaRespostaWs(json)
		response.write json
		response.end
	end function
	
	
	function isJsonOK(jsonInput) On Error resume next
		set obj = JSON.parse(jsonInput)
		if err.number <> 0 then
			retornaRespostaWs(montaJsonResponseErro("Json inválido." , "3"))
		end if
	end function
%>