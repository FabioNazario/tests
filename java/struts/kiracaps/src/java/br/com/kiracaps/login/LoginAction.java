/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package br.com.kiracaps.login;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 *
 * @author fabionazario
 */
public class LoginAction extends org.apache.struts.action.Action {

    /* forward name="success" path="" */
    private static final String SUCCESS = "success";
    private static final String FAILURE = "failure";

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
        
        HttpSession hs = request.getSession(true);
        LoginActionForm obj = (LoginActionForm) form;
        
        System.out.println(obj.getLogin());
        
        String login = "fabio.nazario";
        String senha = "Pirulitaopop";
        
        if ((obj.getLogin().equals(login)) && (obj.getSenha().equals(senha)))
        {
            return mapping.findForward(SUCCESS);
        }else
        {
            return mapping.findForward(FAILURE);
        }
    }
}
