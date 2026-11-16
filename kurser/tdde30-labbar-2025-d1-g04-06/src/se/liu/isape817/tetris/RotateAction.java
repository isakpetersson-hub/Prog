package se.liu.isape817.tetris;

import javax.swing.*;
import java.awt.event.ActionEvent;

public class RotateAction extends AbstractAction {
    private Direction direction;
    private Board board;

    public RotateAction(Direction direction, Board board) {
	this.direction = direction;
	this.board = board;
    }

    @Override public void actionPerformed(final ActionEvent e) {
	board.rotate(direction);
    }
}
