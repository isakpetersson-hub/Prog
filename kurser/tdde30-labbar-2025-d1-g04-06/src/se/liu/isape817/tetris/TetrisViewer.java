package se.liu.isape817.tetris;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.io.IOException;

public class TetrisViewer {
    private Board board;
    private BoardTester tester;

    public TetrisViewer(final Board board, BoardTester tester) {
	this.board = board;
	this.tester = tester;
    }

    public void show() {
	JFrame frame = new JFrame("Tetris Viewer");
	JPanel mainPanel = new JPanel(new BorderLayout());
	try {
	    tester.getHighScoreList().loadHighScores();
	} catch (IOException ex) { // Visar fel med en JOptionPane
	    JOptionPane.showMessageDialog(frame, ex.getMessage(), "Failed to load highscores", JOptionPane.ERROR_MESSAGE);
	}

	// Skapar menun
	final JMenuBar menuBar = new JMenuBar();
	final JMenu fileMenu = new JMenu("File");
	final JMenuItem newGame = new JMenuItem("New Game");
	final JMenuItem exitGame = new JMenuItem("Avsluta");
	fileMenu.add(newGame);
	fileMenu.add(exitGame);
	menuBar.add(fileMenu);
	frame.setJMenuBar(menuBar);

	// ActionEvent för att skapa ett nytt spel
	newGame.addActionListener(e ->  {
	    String name = JOptionPane.showInputDialog("Namn:");
	    HighScore highScore = new HighScore(board.getScore(),name); // Skapar ett nytt highscore med namnet och score
	    try {
		tester.getHighScoreList().addHighScores(highScore);
	    } catch (IOException ex) { // Visar fel med en JOptionPane
		JOptionPane.showMessageDialog(frame, ex.getMessage(), "Failed to add highscores", JOptionPane.ERROR_MESSAGE);
	    }
	    // Visar upp alla highscores
	    JOptionPane.showConfirmDialog(null, tester.getHighScoreList().toString(), "Highscores", JOptionPane.DEFAULT_OPTION);
	    // Tar bort denna frame och skapar en ny BoardTester och får den att skapa ett nytt spel
	    frame.dispose();
	    tester.newGame();
	});
	// ActionEvent för att lämna spelet
	exitGame.addActionListener(e -> {
	    if (JOptionPane.showConfirmDialog(null, ("Vill du avsluta spelet?")) == JOptionPane.OK_OPTION) {
		System.exit(0);
	    }
	});

	// Skapar keybinds
	JComponent pane = frame.getRootPane();
	final InputMap in = pane.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW);
	in.put(KeyStroke.getKeyStroke("LEFT"), "Left");
	in.put(KeyStroke.getKeyStroke("RIGHT"), "Right");
	in.put(KeyStroke.getKeyStroke("DOWN"), "RotateRight");
	in.put(KeyStroke.getKeyStroke("UP"), "RotateLeft");
	in.put(KeyStroke.getKeyStroke("S"), "Down");
	in.put(KeyStroke.getKeyStroke("P"), "Paus");

	final ActionMap act = pane.getActionMap();
	act.put("Right", new MoveAction(Direction.RIGHT, board));
	act.put("Left", new MoveAction(Direction.LEFT, board));
	act.put("RotateRight", new RotateAction(Direction.ROT_RIGHT, board));
	act.put("RotateLeft", new RotateAction(Direction.ROT_LEFT, board));
	act.put("Down", new MoveAction(Direction.DOWN, board));
	act.put("Paus",new AbstractAction()
	{
	    @Override public void actionPerformed(final ActionEvent e) {
		tester.paus();
	    }
	});

	// Skapar TetrisComponent och lägger till den som boardlistenr och lägger till den i panel
	TetrisComponent tetrisComponent = new TetrisComponent(board);
	board.addBoardListener(tetrisComponent);
	mainPanel.add(tetrisComponent, BorderLayout.CENTER);

	// Configurear frame
	frame.setFocusable(true);
	frame.requestFocusInWindow();
	frame.setLayout(new BorderLayout());
	frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	frame.add(mainPanel);
	frame.pack();
	frame.setVisible(true);
    }
}
