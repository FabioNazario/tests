/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.br.fabionazario.fileupload;

import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.upload.FormFile;

/**
 *
 * @author fabionazario
 */
public class FileUploadActionForm extends org.apache.struts.action.ActionForm {
    
    private ArrayList<FormFile> doc0;

    public ArrayList<FormFile> getDoc0() {
        return doc0;
    }

    public void setDoc0(ArrayList<FormFile> doc0) {
        this.doc0 = doc0;
    }

    

    /**
     *
     */
    public FileUploadActionForm() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * This is the action called from the Struts framework.
     *
     * @param mapping The ActionMapping used to select this instance.
     * @param request The HTTP Request we are processing.
     * @return
     */
    public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
    ActionErrors errors = new ActionErrors();
    
    for (FormFile file : doc0){
        if (file.getFileSize() == 0) {
            errors.add("doc0", new ActionMessage("error.file.required"));
        }

        if (!file.getContentType().equals("application/vnd.ms-excel")) {
            errors.add("doc0", new ActionMessage("error.file.type"));
        }
        /**
        * If the file size is greater than 20kb.
        */
        if (file.getFileSize() > 100) {
            errors.add("doc0", new ActionMessage("error.file.size"));
        }
    }
    return errors;
}
}
