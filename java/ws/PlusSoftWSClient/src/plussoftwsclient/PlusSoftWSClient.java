/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package plussoftwsclient;

import com.google.gson.Gson;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import static org.apache.http.HttpHeaders.USER_AGENT;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;

/**
 *
 * @author fabionazario
 */
public class PlusSoftWSClient {

    /**
     * @param args the command line arguments
     * @return 
     * @throws java.io.IOException
     */
    public static ResponseUploadPlussoft gravarAnexo(RequestUploadPlussoft fileUploadRequest) throws IOException {

	HttpClient client = HttpClientBuilder.create().build();
	HttpPost post = new HttpPost("url");

	// add header
	post.setHeader("User-Agent", USER_AGENT);
        post.setHeader("Authorization", "");
        post.setHeader("Content-type", "application/json");

        String json = fileUploadRequest.serialize();
        
        System.out.println("Body:");
        System.out.println(json);
        System.out.println("\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n");
        
	StringEntity entity = new StringEntity(json);
        post.setEntity(entity);

	HttpResponse response = client.execute(post);
	System.out.println("Response Code : " 
                + response.getStatusLine().getStatusCode());

	BufferedReader rd = new BufferedReader(
	        new InputStreamReader(response.getEntity().getContent()));

	StringBuilder result = new StringBuilder();
	String line;
	while ((line = rd.readLine()) != null) {
		result.append(line);
	}
        
        Gson gson = new Gson();
        return gson.fromJson(result.toString(),ResponseUploadPlussoft.class);
        
         
    }
    
}


