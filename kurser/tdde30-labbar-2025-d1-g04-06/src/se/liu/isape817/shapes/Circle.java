package se.liu.isape817.shapes;

import java.awt.*;

public class Circle extends AbstractShape
{
    private int radius;

    public Circle(final int x, final int y, final int radius, final Color color) {
	super(x, y, color);
	if (radius < 0) {
	    throw new IllegalArgumentException("Negativ radie!");
	}
	this.radius = radius;
    }

    @Override public String toString() {
	return "Circle{" + "x=" + getX() + ", y=" + getY() + ", radius=" + radius + ", color=" + getColor() + '}';
    }

    @Override public void draw(final Graphics g) {
	g.setColor(color);
	final int width = radius * 2;
	final int height = radius * 2;
	g.drawOval(x, y, width, height);
    }

    public int getRadius() {
	return radius;
    }

}
