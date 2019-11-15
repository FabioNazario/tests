package br.com.fabionazario.test;
  
import com.br.fabionazario.main.ResultadoMegasena;
import junit.framework.TestCase;
  
/**
 * Classe de teste unitário para ResultadoMegasena
 */
public class ResultadoMegasenaTest extends TestCase {
  
    /** Número de dezenas esperadas no resultado da mega-sena. */
    private final static int NUMERO_DE_DEZENAS = 6;
    private final static int DEZENA_SIZE = 2;
    
     
       /**
        * Teste do método obtemUltimoResultado()
        */
       public void testObtemUltimoResultado()  {
            String[] ultimoResultado = ResultadoMegasena.obtemUltimoResultado();

            assertNotNull(ultimoResultado);
            assertTrue( ultimoResultado.length == NUMERO_DE_DEZENAS );
       }
       
       public void testHasLenghtTwo(){
           
           boolean isWrongSize = false;
           String[] lastResult = ResultadoMegasena.obtemUltimoResultado();
           
           for (String dezena : lastResult) {
               if(dezena.length() != DEZENA_SIZE){
                   isWrongSize = true;
                   
                   System.out.println("testing " +  dezena + "..."); 
                   
                   break;
               }
           }
           
           assertFalse(isWrongSize);
           
       }
       
       
     
}