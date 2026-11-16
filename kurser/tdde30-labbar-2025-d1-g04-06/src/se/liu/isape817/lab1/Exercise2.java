package se.liu.isape817.lab1;

import javax.swing.*;

public class Exercise2
{

    public static void sumFor(int min, int max){
	int summa = 0;
	for (int i = min; i <= max; i++){
	    summa += i;
	    System.out.println("Nu har summa värdet " + summa);
	}
    }

    public static void sumWhile(int min, int max) {
	int summa = 0;
	while (min <= max) {
	    summa += min;
	    System.out.println("Nu har summa " + summa);
	    min++;
	}
    }

    public static void main(String[] args) {
	String type = JOptionPane.showInputDialog("Please input type of loop");
	final int min = 10;
	final int max = 20;
	switch (type) {
	    case "while":
		sumWhile(min, max);
		break;
	    case "for":
		sumFor(min, max);
		break;
	    default:
		System.out.println("Wrong input");
	}
	sumFor(min, max);
	sumWhile(min, max);
    }
}
