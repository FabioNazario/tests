<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@taglib prefix="bean" uri="http://struts.apache.org/tags-bean"%>



<html:form action="/loginpath" method='POST'>
    <table>
        <tr>
            <td>
                <label>Login:</label>
            </td>
            <td>
                <html:text property="login"/><td><html:errors property="loginerror"/></td>
            </td>
        <tr/>
        <tr>
            <td>
                <label>Senha:</label>
            </td>
            <td>                
            <html:password property="senha"/><td><html:errors property="senhaerror"/></td>
            </td>
        </tr>
        <tr>
            <td>
                <html:submit value="submit"/>
            </td>
        
            <td>
                <html:reset value="reset"/>
            </td>
        </tr>
    </table>
    
    
    

</html:form>