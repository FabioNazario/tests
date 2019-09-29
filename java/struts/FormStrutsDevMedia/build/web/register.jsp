<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@taglib prefix="bean" uri="http://struts.apache.org/tags-bean"%>

<html>
<head>
<title></title>
  
</head>
<body bgcolor="white">
<div align="center">
<h1>New Registration</h1>
<form action="registerpath.do" method="POST">
    Email: <input type="text" name="email" /><br>
    Senha: <input type="password" name="senha"  /><br>
    <input type="submit" value="Enviar" />
</form>
  
</div>
</body>
</html>