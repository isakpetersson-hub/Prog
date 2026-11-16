package se.liu.isape817.tetris;

public class TetrominoMaker
{
    private SquareType[][] square = null;
    public int getNumberOfTypes() {
	return 7;
    }
    public Poly getPoly(int n) {
	switch (n){
	    case 0:
		return createSquareI();
	    case 1:
		return createSquareO();
	    case 2:
		return createSquareT();
	    case 3:
		return createSquareS();
	    case 4:
		return createSquareZ();
	    case 5:
		return createSquareJ();
	    case 6:
		return createSquareL();
	    default:
		throw new IllegalArgumentException("Invalid index: " + n);
	}
    }

    private Poly createSquareI() {
	square = new SquareType[][]  {  {SquareType.EMPTY,SquareType.EMPTY,SquareType.EMPTY,SquareType.EMPTY},
					{SquareType.I,SquareType.I,SquareType.I,SquareType.I},
					{SquareType.EMPTY,SquareType.EMPTY,SquareType.EMPTY,SquareType.EMPTY},
					{SquareType.EMPTY,SquareType.EMPTY,SquareType.EMPTY,SquareType.EMPTY}
				     };
    	return new Poly(square,0,0);
    }
    private Poly createSquareO() {
	square = new SquareType[][]  {  {SquareType.O,SquareType.O},
					{SquareType.O,SquareType.O},
	};
	return new Poly(square,0,0);
    }
    private Poly createSquareT() {
	square = new SquareType[][]  {  {SquareType.EMPTY,SquareType.T,SquareType.EMPTY},
					{SquareType.T,SquareType.T,SquareType.T},
					{SquareType.EMPTY,SquareType.EMPTY,SquareType.EMPTY}
	};
	return new Poly(square,0,0);
    }
    private Poly createSquareS() {
	square = new SquareType[][]  {  {SquareType.EMPTY,SquareType.S,SquareType.S},
					{SquareType.S,SquareType.S,SquareType.EMPTY},
					{SquareType.EMPTY,SquareType.EMPTY,SquareType.EMPTY}
	};
	return new Poly(square,0,0);
    }
    private Poly createSquareZ() {
	square = new SquareType[][]  {  {SquareType.Z,SquareType.Z,SquareType.EMPTY},
					{SquareType.EMPTY,SquareType.Z,SquareType.Z},
					{SquareType.EMPTY,SquareType.EMPTY,SquareType.EMPTY}
	};
	return new Poly(square,0,0);
    }
    private Poly createSquareJ() {
	square = new SquareType[][]  {  {SquareType.EMPTY,SquareType.EMPTY,SquareType.J},
					{SquareType.J,SquareType.J,SquareType.J},
					{SquareType.EMPTY,SquareType.EMPTY,SquareType.EMPTY}
	};
	return new Poly(square,0,0);
    }
    private Poly createSquareL() {
	square = new SquareType[][]  {  {SquareType.L,SquareType.EMPTY,SquareType.EMPTY},
					{SquareType.L,SquareType.L,SquareType.L},
					{SquareType.EMPTY,SquareType.EMPTY,SquareType.EMPTY}
	};
	return new Poly(square,0,0);
    }
}
