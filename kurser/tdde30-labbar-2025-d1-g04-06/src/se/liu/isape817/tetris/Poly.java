package se.liu.isape817.tetris;

public class Poly
{
    private SquareType[][] squares;
    private int x;
    private int y;

    public Poly(final SquareType[][] square, final int x, final int y) {
	this.squares = square;
	this.x = x;
	this.y = y;
    }

    public Poly rotate(Direction dir) {
	int size = squares.length;
	Poly newPoly =  new Poly(new SquareType[size][size],x,y); // Skapar en new poly för att rotera
	if (dir == Direction.ROT_RIGHT) {
	    for (int r = 0; r < size; r++) {
		for (int c = 0; c < size; c++){
		    newPoly.squares[c][size-1-r] = this.squares[r][c];  // Roterar newpolt åt höger
		}
	    }
	    return newPoly;
    	}
	else {
	    for (int r = 0; r < size; r++) {
		for (int c = 0; c < size; c++) {
		    newPoly.squares[size-1-c][r] = this.squares[r][c]; // Roterar newpoly åt vänster
		}
	    }
	}
	return newPoly;
    }

    public int getX() {
	return x;
    }

    public int getY() {
	return y;
    }

    public void setX(final int x) {
	this.x = x;
    }

    public void setY(final int y) {
	this.y = y;
    }

    public SquareType[][] getSquare() {
	return squares;
    }
}
