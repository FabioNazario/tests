<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' JSON WS UTIL  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	
	'Tratamento caso ocorra um erro inesperado
	function errorHandler(erroNum, erroDescricao)	
		if erroNum <> 0 then
			dim resp : set resp = JSON.parse("{}")
			resp.set "mensagem"		,  erroDescricao
			resp.set "codigo"        , cStr(erroNum)
			response.write JSON.stringify(resp)
			response.end
		end if
	end function
	
''''''
	'Retorno de erro customizado
	function retornaJsonResponseErro(mensagem, codigo) 
        if Session("tratarErros") then On Error resume next
		dim resp : set resp = JSON.parse("{}")
		resp.set "mensagem"		, mensagem
		resp.set "codigo"        , codigo
		retornaRespostaWs(JSON.stringify(resp))
	end function
''''''
	'Retorno de erro padrao customizado
	function retornaJsonResponse(retorno, operacao, usuario, senha, mensagem) 
        if Session("tratarErros") then On Error resume next
		
		dim resp : set resp = JSON.parse("{}")
		resp.set "RETORNO"		, retorno
		resp.set "OPERACAO"		, operacao
		resp.set "USUARIO"		, usuario
		resp.set "SENHA"		, senha
		resp.set "MENSAGEM"     , mensagem
		
		retornaRespostaWs(JSON.stringify(resp))
	end function
''''''
	'Resgata o Json do corpo do request
	function recuperaJson() 
        if Session("tratarErros") then On Error resume next

		bytecount = Request.TotalBytes
		bytes = Request.BinaryRead(bytecount)
		if bytecount = 0 then
			call retornaJsonResponseErro("Requisição precisa ter um corpo.", "1")
			response.end
		end if
		Set stream = Server.CreateObject("ADODB.Stream")
		stream.Type = 1 'adTypeBinary              
		stream.Open()                                   
			stream.Write(bytes)
			stream.Position = 0                             
			stream.Type = 2 'adTypeText                
			stream.Charset = "ISO-8859-1"                      
			recuperaJson = stream.ReadText() 'String Json            
		stream.Close()
		Set stream = nothing
		
		call errorHandler(err.number, err.description)
	end function
''''''
	'Envia a resposta do webservice
	function retornaRespostaWs(json)
        call errorHandler(err.number, err.description)
		response.write ConvertFromUTF8(json)
		call errorHandler(err.number, err.description)
		response.end
	end function
''''''
	'Testa se o Json esta ok
	function isJsonOK(jsonInput) 
		if Session("tratarErros") then On Error resume next
		set obj = JSON.parse(jsonInput)
		if err.number <> 0 then
			call retornaJsonResponseErro("Json inválido." , "2")
		end if
	end function
''''''
	function ConvertFromUTF8(sIn)

	   Dim oIn: Set oIn = CreateObject("ADODB.Stream")

	   oIn.Open
	   oIn.CharSet = "WIndows-1252"
	   oIn.WriteText sIn
	   oIn.Position = 0
	   oIn.CharSet = "UTF-8"
	   
	   ConvertFromUTF8 = oIn.ReadText
	   oIn.Close

	end function
''''''
	'Funcao personalizada para resgatar atributos dos objetos. 
	'Caso o atributo nao exista, o erro e tratado.
	function pegaAtributo(objIn,att)
		
		if Session("tratarErros")  then On Error resume next
		set obj = objIn
		
		atributo = split(att,".")
		qtdAtributos = uBound(atributo)
		
		for i = 0 To qtdAtributos -1
			set obj = obj.get(atributo(i))
		next
		
		pegaAtributo = obj.get(lcase(atributo(qtdAtributos)))
		
		'Caso o atributo seja um objeto, retorna o objeto.
		if pegaAtributo = "[object Object]" then
			set pegaAtributo = nothing
			set pegaAtributo = obj.get(atributo(qtdAtributos))
		end if
		
		'Caso nao encontre o atributo em minusculo, tenta maiusculo
		if (varType(pegaAtributo) = vbEmpty) then
			pegaAtributo = obj.get(ucase(atributo(qtdAtributos)))
		end if
		
		'Se atrubuto nao foi encontrado no corpo do json, retorna erro tratado.
		if (varType(pegaAtributo) = vbEmpty) then
			call retornaJsonResponseErro("Atributo '" & att & "' não encontrado." , "3")
		end if
		
	end function
''''''
	'Gravacao simples de log
	function gravaLog(caminho,dadosLog)
		timesTemp =  cstr(year(now)) & cstr(month(now)) & cstr(day(now)) & replace(cstr(time),":","-")
		arquivo   = server.MapPath("/") & caminho & "-" & timesTemp & ".txt"
		set confile = createObject("scripting.filesystemobject")
		set fich = confile.CreateTextFile(arquivo)
		fich.write(dadosLog)
		fich.close()
		set confile = nothing 								
		err.clear
	end function
%>
