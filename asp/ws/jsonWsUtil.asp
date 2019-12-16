<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' JSON WS UTIL  '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''	
	'Tratamento caso ocorra um erro inesperado
	function errorHandler()
		if err.number <> 0 then
			call retornaJsonResponseErro("Erro Interno: " & err.description , cStr(err.number))
			response.end
		end if
	end function

''''''		
	function verificaAtributosEsperadosExistem(arrAttrEsperados, strJson) 
        if Session("tratarErros") then On Error resume next	
        For Each attr In arrAttrEsperados
			if inStr(uCase(strJson), """"&uCase(attr)&"""") = 0 then
				call retornaJsonResponseErro("Atributo '" & attr & "' não encontrado","3")
			end if
		Next
        errorHandler()
	end function
	
''''''	
	function retornaJsonResponseErro(mensagem, codigo) 
        if Session("tratarErros") then On Error resume next
		
		dim resp : set resp = JSON.parse("{}")
		resp.set "mensagem"		, mensagem
		resp.set "codigo"        , codigo
		
		retornaRespostaWs(JSON.stringify(resp))
	end function 	
''''''	
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
		
		errorHandler()
	end function
''''''	
	function retornaRespostaWs(json)
        errorHandler()
		response.write ConvertFromUTF8(json)
		response.end
	end function
''''''	
	function isJsonOK(jsonInput) if Session("tratarErros") then On Error resume next
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
%>
