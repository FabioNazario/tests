<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@taglib prefix="bean" uri="http://struts.apache.org/tags-bean"%>

<html:form action="/registerpath" method='POST'>
    <table>
        <tr>
            <td>
                <label>Email:</label>
            </td>
            <td>
                <html:text property="email"/>
            </td>
        <tr/>
        <tr>
            <td>
                <label>Senha:</label>
            </td>
            <td>                
            <html:password property="senha"/>
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