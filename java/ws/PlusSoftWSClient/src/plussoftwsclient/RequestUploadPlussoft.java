/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package plussoftwsclient;

import org.apache.commons.io.FileUtils;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import org.apache.commons.codec.binary.Base64;
        

/**
 *
 * @author fabionazario
 */


public class RequestUploadPlussoft{
    
    private String cpfCnpj;
    private String numeroSinistro;
    private String arquivo; //base64 exigido pelo servico
    private String nomeArquivo;
    private int idEmpresa;
    private transient File arquivoObj;

    public RequestUploadPlussoft() {
    }

    public RequestUploadPlussoft(String cpfCnpj, String numeroSinistro, File arquivoObj, int idEmpresa) throws IOException {
        this.cpfCnpj = cpfCnpj;
        this.numeroSinistro = numeroSinistro;
        this.arquivoObj = arquivoObj;
        this.arquivo = convertFileToBase64(arquivoObj);        
        this.nomeArquivo = arquivoObj.getName();
        this.idEmpresa = idEmpresa;
    }
    
    public String serialize(){
        
        //necessario pois a string Base64 fica com ""
        Gson gson = new GsonBuilder().disableHtmlEscaping().create();
        
        //Gson g = new GsonBuilder().setPrettyPrinting().create();
        return gson.toJson(this).replace("\\\\", "\\");
    }
    
    
    
    public static String convertFileToBase64(File file) throws IOException{
        
        byte[] encoded = Base64.encodeBase64(FileUtils.readFileToByteArray(file));
        return new String(encoded, StandardCharsets.ISO_8859_1);
    
    }

    public String getCpfCnpj() {
        return cpfCnpj;
    }

    public void setCpfCnpj(String cpfCnpj) {
        this.cpfCnpj = cpfCnpj;
    }

    public String getNumeroSinistro() {
        return numeroSinistro;
    }

    public void setNumeroSinistro(String numeroSinistro) {
        this.numeroSinistro = numeroSinistro;
    }

    public String getArquivo() {
        return arquivo;
    }

    public String getNomeArquivo() {
        return nomeArquivo;
    }

    /*public void setNomeArquivo(String nomeArquivo) {
        this.nomeArquivo = nomeArquivo;
    }*/

    public int getIdEmpresa() {
        return idEmpresa;
    }

    public void setIdEmpresa(int idEmpresa) {
        this.idEmpresa = idEmpresa;
    }
    
    public File getArquivoObj() {
        return arquivoObj;
    }

    public void setArquivoObj(File arquivoObj) throws IOException {
        this.arquivoObj = arquivoObj;
        this.arquivo = convertFileToBase64(arquivoObj);
        this.nomeArquivo =  arquivoObj.getName();
    }
    
}
