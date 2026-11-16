package se.liu.isape817.tetris;

import javax.swing.*;
import java.awt.event.ActionEvent;

public class BoardTester
{
    private Board board = null;
    private final HighScoreList highScoreList;
    private boolean paus;
    private int delay;
    private static final int MIN_DELAY = 200;
    private static final int DECREASE_INTERVAL = 6000;
    // Timer för att snabba upp spelet succsivt
    private Timer speedUpTimer;
    // Timer som kallar på tick
    private final Timer clockTimer;
    public BoardTester() {
	this.highScoreList = new HighScoreList();
	this.paus = false;
	this.delay = 1000;

	// Intitalizar timers
	this.speedUpTimer = new Timer(DECREASE_INTERVAL, new AbstractAction() {
	    @Override
	    public void actionPerformed(final ActionEvent e) {
		decreaseDelay();
	    }
	});

	this.clockTimer = new Timer(delay, new AbstractAction() {
	    @Override
	    public void actionPerformed(final ActionEvent e) {
		if (board != null) {
		    board.tick(board);
		}
	    }
	});
    }

    public void newGame(){ // Börjar ett nytt spel
	board = new Board(9,20); // Har satt width och height till 9 och 20 men kan ändras
	TetrisViewer tetrisViewer = new TetrisViewer(board, this); // skapar en new Terisviewer för detta spel
	tetrisViewer.show();
	startTimers();
    }

    public void startTimers() { // Startar timers
	clockTimer.setCoalesce(true);
	clockTimer.start();
	speedUpTimer.start();
    }

    public void paus() {
	if (paus) { // Om spelet är pausat starta det
	    clockTimer.start();
	    speedUpTimer.start();
	}
	else { // Om spelet inte är pausat pausa det
	    clockTimer.stop();
	    speedUpTimer.stop();
	}
	paus = !paus;
    }
    public void decreaseDelay() {
	if (delay > MIN_DELAY) { // Har en min delay så det inte gåt för snabbt
	    delay -= 50;
	    clockTimer.setDelay(delay); // Minskar delay
	}
    }

    public HighScoreList getHighScoreList() {
	return highScoreList;
    }

    public static void main(String[] args) {
	GUI.main(args);
	BoardTester tester = new BoardTester();
	tester.newGame();
    }
}
