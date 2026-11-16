package se.liu.isape817.lab1;

import javax.swing.*;
import java.util.Scanner;

public class Exercise3
{
    public static void main(String[] arg){
	String input = JOptionPane.showInputDialog("Please input a value");
	int tabell = Integer.parseInt(input);
	for (int i = 1; i <= 12; i++){
	    System.out.println(i + " * "+ tabell + " = " + (i*tabell));
	}
    }
}
