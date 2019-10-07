/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package plussoftwsclient;

import java.io.File;
import java.io.IOException;

/**
 *
 * @author fabionazario
 */
public class main {
    public static void main(String[] args) throws IOException {
        
        RequestUploadPlussoft request = new RequestUploadPlussoft(
          "11111111111"
        , "549845"
        , new File("/home/fabionazario/Desktop/images.png")
        ,1);
        
        
        ResponseUploadPlussoft response =  PlusSoftWSClient.gravarAnexo(request);
        
        System.out.println(response.getCodMensagem());
    }
}
