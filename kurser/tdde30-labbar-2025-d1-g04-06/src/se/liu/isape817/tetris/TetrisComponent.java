package se.liu.isape817.tetris;

import javax.swing.*;
import java.awt.*;
import java.util.EnumMap;

public class TetrisComponent extends JComponent implements BoardListener
{
    private final Board board;
    private final static int BLOCK_SIZE = 30; // Har satt Blockens storlek till 30 men kan ändars för att göra spelet större
    private final EnumMap<SquareType, Color> squareColors = createColorMap();

    public TetrisComponent(final Board board) {
	this.board = board;
    }

    public static EnumMap<SquareType, Color> createColorMap() {
	EnumMap<SquareType, Color> colorMap = new EnumMap<>(SquareType.class);
	colorMap.put(SquareType.EMPTY, Color.WHITE);
	colorMap.put(SquareType.I, Color.CYAN);
	colorMap.put(SquareType.J, Color.BLUE);
	colorMap.put(SquareType.L, Color.ORANGE);
	colorMap.put(SquareType.O, Color.YELLOW);
	colorMap.put(SquareType.S, Color.GREEN);
	colorMap.put(SquareType.T, Color.MAGENTA);
	colorMap.put(SquareType.Z, Color.RED);
	colorMap.put(SquareType.OUTSIDE, Color.BLACK);
	return colorMap;
    }

    public void boardChanged(){
	repaint();
    }

    public Dimension getPreferredSize() { // Sätter storlek enligt storlek på brädet och blocks storlek
	return new Dimension(board.getWidth() * BLOCK_SIZE, board.getHeight() * BLOCK_SIZE);
    }

    protected void paintComponent(Graphics g) {
	super.paintComponent(g);
	final Graphics2D g2d = (Graphics2D) g;
	for(int i = 0; i < board.getHeight(); i++){
	    for(int j = 0; j < board.getWidth(); j++){
		// Ritar ut men hjälp av getSquareType och color map
		g2d.setColor(squareColors.get(board.getSquareType(j, i)));
		g2d.fillRect(j * BLOCK_SIZE, i * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
	    }
	}
	// Ritar ut score
	g2d.setFont(new Font("Arial", Font.BOLD, 20));
	g2d.setColor(Color.BLACK);
	g2d.drawString("Score: " + board.getScore(), 0, BLOCK_SIZE/2);
    }
}
