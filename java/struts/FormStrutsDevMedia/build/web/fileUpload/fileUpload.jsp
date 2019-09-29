<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/tlds/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/tlds/struts-logic.tld" prefix="logic" %>
<html>
<head>
<title>fileUpload</title>
<html:errors />
<form action="fileupload.do" method="post" enctype="multipart/form-data">
   <input type="file" name="doc0" multiple/><br/>
   <input type="file" name="doc0" multiple/>
   <input type="submit" value="submit">  
</form>
 
</body>
</html>