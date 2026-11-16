package se.liu.isape817.tetris;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class Board
{
    private boolean gameOver = false;
    private final static int MARGIN = 2;
    private final static int DOUBLE_MARGIN = MARGIN*2;
    private SquareType[][] squares;
    private Poly falling = null;
    private int width;
    private int height;
    private final static Random RAND = new Random();
    private List<BoardListener> listeners = new ArrayList<>();
    private Map<Integer,Integer> pointMap = Map.of(0, 0, 1, 100, 2, 300, 3, 500, 4, 800);
    private int score = 0;

    public Board(final int width, final int height) {
	this.height = height;
	this.width = width;
	squares = new SquareType[height+DOUBLE_MARGIN][width+DOUBLE_MARGIN];
	for(int i = 0; i < height+DOUBLE_MARGIN; i++){ // Sätter Outside blocks på margin och allt annat blir Empty
	    for (int j = 0; j < width+DOUBLE_MARGIN; ++j) {
		if (i < MARGIN || i >= height+MARGIN || j < MARGIN || j >= width+MARGIN ) {
		    squares[i][j] = SquareType.OUTSIDE;
		}
		else {
		    squares[i][j] = SquareType.EMPTY;
		}
	    }
	}
    }

    public void addBoardListener(BoardListener bl){
	listeners.add(bl);
    }

    public void tick(Board board) {
	if (!gameOver) {
	    if (falling == null) {
		spawnNewPoly(board);
	    } else {
		int y = falling.getY();
		falling.setY(y + 1);
		if (hasCollided()) {
		    falling.setY(y); // Sätter tillbaka falling då den har kolliderat med något
		    SquareType[][] fallingSquares = falling.getSquare(); // Läger sedan till falling i squares
		    int fallingX = falling.getX();
		    int fallingY = falling.getY();
		    for (int i = 0; i < fallingSquares.length; i++) {
			for (int j = 0; j < fallingSquares[i].length; j++) {
			    if (fallingSquares[i][j] != SquareType.EMPTY) {
				squares[fallingY + i][fallingX + j] = fallingSquares[i][j];
			    }
			}
		    }
		    clearFullRows();
		    falling = null;
		}
	    }
	}
	notifyListeners();
    }

    public void spawnNewPoly(Board board) {
	TetrominoMaker tetrominoMaker = new TetrominoMaker();
	int squareType = RAND.nextInt(0,tetrominoMaker.getNumberOfTypes());
	falling = tetrominoMaker.getPoly(squareType);
	falling.setY(MARGIN);
	falling.setX(MARGIN+width/2-falling.getSquare()[0].length/2); // Sätter X så den är i mitten av boardet
	if(hasCollided()){
	    gameOver = true;
	}
	notifyListeners();
    }

    public boolean hasCollided() {
	SquareType[][] fallingSquares = falling.getSquare();
	int fallingX = falling.getX();
	int fallingY = falling.getY();
	for (int i = 0; i < fallingSquares.length; i++) {
	    for (int j = 0; j < fallingSquares[i].length; j++) {
		if (fallingSquares[i][j] != SquareType.EMPTY && squares[fallingY + i][fallingX + j] != SquareType.EMPTY) {
		    return true;
		}
	    }
	}
	return false;
    }

    public void clearFullRows() {
	int rowsCleared = 0;
	for (int y = height + MARGIN - 1; y >= MARGIN; y--) { // Kollar all rader men börjar nedfrån upp
	    if (isRowFull(y)) {
		removeRow(y);
		rowsCleared++;
		y++;
	    }
	}
	increasePoints(rowsCleared);
	notifyListeners(); // Update the board display
    }

    private boolean isRowFull(int y) {
	for (int x = MARGIN; x < width + MARGIN; x++) {
	    if (squares[y][x] == SquareType.EMPTY) { // Kollar alla rutor på denna rad som inte är i margin
		return false; // Hittade en rom ruta så denna rad är inte full
	    }
	}
	return true;
    }

    private void removeRow(int row) {
	for (int y = row; y > MARGIN; y--) { // Flyttar ner allt en rad
	    System.arraycopy(squares[y - 1], MARGIN, squares[y], MARGIN, width);
	}
	for (int x = MARGIN; x < width + MARGIN; x++) { // Sätter den översta raden i squares till empty
	    squares[MARGIN][x] = SquareType.EMPTY;
	}
    }

    private void increasePoints(int rows){
	score += pointMap.get(rows);
    }

    public void move(Direction direction) {
	if (falling == null) return; // Om falling inte finns gå ur funktionen
	int oldX = falling.getX();
	int oldY = falling.getY();

	// Flyttar falling beroende på vilket direction som kommer in
	if (direction == Direction.RIGHT) {
	    falling.setX(oldX + 1);
	} else if (direction == Direction.LEFT) {
	    falling.setX(oldX - 1);
	} else if(direction == Direction.DOWN) {
	    falling.setY(oldY + 1);
	}

	if (hasCollided()) {
	    // Sätter tillbaka falling då den har kolliderat med något
	    falling.setX(oldX);
	    falling.setY(oldY);
	}
	notifyListeners();
    }

    public void rotate(Direction dir){
	if (falling == null) return; // Om falling inte finns gå ur funktionen
	Poly testPoly = falling; // Sparar falling i en temp om rotate inte går
	falling = falling.rotate(dir); // Kallar på rotate som roterar falling
	if (hasCollided()) {
	    // Sätter tillbaka falling till temp då den har kolliderat med något
	    falling = testPoly;
	}
	notifyListeners();
    }

    private void notifyListeners() {
	for (BoardListener bl : listeners){
	    bl.boardChanged();
	}
    }

    public int getScore() {
	return score;
    }

    public int getHeight() {
	return height;
    }

    public int getWidth() {
	return width;
    }

    public SquareType getSquareType(int x, int y) {
	int adjustedX = x + MARGIN;
	int adjustedY = y + MARGIN;
	if (falling != null) { // Om falling finns måste vi kolla om den squaren frågas om
	    SquareType[][] fallingSquares = falling.getSquare();
	    int fallingX = falling.getX();
	    int fallingY = falling.getY();

	    for (int i = 0; i < fallingSquares.length; i++) { //
		for (int j = 0; j < fallingSquares[i].length; j++) {
		    if (fallingSquares[i][j] != SquareType.EMPTY &&  // Går igenom falling och kollar om den frågas om
			adjustedX == fallingX + j && adjustedY == fallingY + i) {
			return fallingSquares[i][j]; // Om den gör returna fallings square
		    }
		}
	    }
	}
	// Om falling inte finns är det bara att returna värdet i squares
	return squares[adjustedY][adjustedX];
    }
}
