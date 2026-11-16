package se.liu.isape817.shapes;

import java.awt.*;
import java.util.ArrayList;

public class ShapeTest
{
    public static void main(String[] args) {
	final ArrayList<Shape> shapes = new ArrayList<>();
	shapes.add(new Circle(0, 0, 2, Color.BLUE));
	shapes.add(new Circle(3, 4, 4, Color.RED));
	shapes.add(new Rectangle(2,6,3,5, Color.GREEN));
	shapes.add(new Text(1,44,4,Color.BLACK,"Test"));
	for (Shape shape : shapes){
	    //shape.draw();
	}
    }
}
