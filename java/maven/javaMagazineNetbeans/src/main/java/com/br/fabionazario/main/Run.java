/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.br.fabionazario.main;

/**
 *
 * @author fabionazario
 */
public class Run {
    
    public static void main(String[] args) {
        String[] resultado = ResultadoMegasena.obtemUltimoResultado();
        System.out.println("O Resultado é: ");
        for (String dezena: resultado) {
              System.out.print(dezena + " ");
        }
        System.out.println("\n");
    }
}
