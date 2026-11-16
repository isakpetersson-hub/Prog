package se.liu.isape817.tetris;

import javax.swing.*;
import java.awt.*;

public class TetrisViewerOld
{
    private Board board;
    private BoardToTextConverter converter = new BoardToTextConverter();

    public TetrisViewerOld(final Board board) {
	this.board = board;
    }

    public void show() {
	JFrame frame = new JFrame("Tetris Viewer");
	JTextArea textArea = new JTextArea(board.getWidth(), board.getHeight());
	textArea.setText(converter.convertToText(board));
	frame.setLayout(new BorderLayout());
	frame.add(textArea, BorderLayout.CENTER);
	textArea.setFont(new Font("Monospaced", Font.PLAIN, 20));
	frame.pack();
	frame.setVisible(true);
    }
}
