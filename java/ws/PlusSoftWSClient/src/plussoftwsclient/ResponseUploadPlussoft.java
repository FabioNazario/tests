/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package plussoftwsclient;

/**
 *
 * @author fabionazario
 */
class ResponseUploadPlussoft {
    private String mensagem;
    private int codMensagem;

    public ResponseUploadPlussoft() {
    }

    public ResponseUploadPlussoft(String mensagem, int codMensagem) {
        this.mensagem = mensagem;
        this.codMensagem = codMensagem;
    }

    public String getMensagem() {
        return mensagem;
    }

    public void setMensagem(String mensagem) {
        this.mensagem = mensagem;
    }

    public int getCodMensagem() {
        return codMensagem;
    }

    public void setCodMensagem(int codMensagem) {
        this.codMensagem = codMensagem;
    }
    
    
}
