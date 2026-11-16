package se.liu.isape817.lab1;

import javax.swing.*;

public class Exercise8
{
    public static void main(String[] args){
	while(true){
	    if (askUser("Quit?") && askUser("Really?")) {
		System.exit(0);
	    }
	    else System.out.println("Programet forsätter köra");
	}
    }

    public static boolean askUser(String question){
	if (JOptionPane.showConfirmDialog(null, question, "", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION){
	    return true;
	}
	return false;
    }
}
