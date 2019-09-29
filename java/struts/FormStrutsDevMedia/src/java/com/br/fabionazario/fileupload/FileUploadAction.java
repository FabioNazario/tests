/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.br.fabionazario.fileupload;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

/**
 *
 * @author fabionazario
 */
public class FileUploadAction extends org.apache.struts.action.Action {

    /* forward name="success" path="" */
    private static final String SUCCESS = "success";
    
    
            
    /**
     * This is the action called from the Struts framework.
     *
     * @param mapping The ActionMapping used to select this instance.
     * @param form The optional ActionForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     * @throws java.lang.Exception
     * @return
     */
    @Override
    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        FileUploadActionForm fuaf = (FileUploadActionForm) form;
        
        for (FormFile f: fuaf.getDoc0()){
            System.out.println(f.getContentType());
            System.out.println(f.getInputStream());
            System.out.println("");
        }
        
        fuaf.getDoc0().get(0).getContentType();
        
        System.out.println(fuaf.getDoc0().toString());
        
        System.out.println();
        return mapping.findForward(SUCCESS);
    }
}
