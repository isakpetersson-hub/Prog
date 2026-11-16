package se.liu.isape817.tetris;

public class BoardToTextConverter
{
    public String convertToText(Board board){
	StringBuilder resultat = new StringBuilder();
	for(int i = 0; i < board.getHeight(); ++i){
	    for (int j = 0; j < board.getWidth(); ++j) {
		SquareType squareType = board.getSquareType(i,j);
		switch (squareType){
		    case I:
			resultat.append("#");
			break;
		    case O:
			resultat.append("*");
			break;
		    case T:
			resultat.append("¤");
			break;
		    case S:
			resultat.append("%");
			break;
		    case Z:
			resultat.append("&");
			break;
		    case J:
			resultat.append("+");
			break;
		    case L:
			resultat.append("-");
			break;
		    case EMPTY:
			resultat.append(" ");
			break;
		}
	    }
	    resultat.append("\n");
	}
	return resultat.toString();
    }
}
