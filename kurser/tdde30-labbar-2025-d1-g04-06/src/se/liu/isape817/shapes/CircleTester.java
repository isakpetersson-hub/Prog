package se.liu.isape817.shapes;

import java.awt.*;
import java.util.ArrayList;

public class CircleTester
{
    public static void main(String[] args) {
	final ArrayList<Circle> circles = new ArrayList<>();
	circles.add(new Circle(0, 0, 2, Color.BLUE));
	circles.add(new Circle(3, 4, 4, Color.RED));
	for (Circle circle : circles){
	    System.out.println(circle.getX() + " " + circle.getY());
	}
    }
}
