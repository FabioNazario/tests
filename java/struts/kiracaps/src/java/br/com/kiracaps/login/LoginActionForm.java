/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package br.com.kiracaps.login;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

/**
 *
 * @author fabionazario
 */
public class LoginActionForm extends org.apache.struts.action.ActionForm {
    
    private String login;
    private String senha;

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }
    
    public LoginActionForm(){
        super();
    }
    
    /**
     * This is the action called from the Struts framework.
     *
     * @param mapping The ActionMapping used to select this instance.
     * @param request The HTTP Request we are processing.
     * @return
     */
    @Override
    public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
        ActionErrors errors = new ActionErrors();
        if(getLogin().equalsIgnoreCase("") || getLogin() == null){
            errors.add("loginerror", new ActionMessage("error.login.empty"));
        }
        
        if(getSenha().equalsIgnoreCase("") || getSenha() == null){
            errors.add("senhaerror", new ActionMessage("error.senha.empty"));
        }
        
        return errors;
    }

    @Override
    public void reset(ActionMapping mapping, HttpServletRequest request) {
        super.reset(mapping, request); //To change body of generated methods, choose Tools | Templates.
        setLogin("");
        setSenha("");
    }
    
    
}
