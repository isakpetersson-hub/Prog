package se.liu.elior637.coregame;

import se.liu.elior637.components.tile.Resource;

import javax.swing.*;
import java.awt.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * The main class that is run to start the game, handels creating players, board, boardcomponent and also handels turn order
 */
public class CatanGame
{
    private int setupStep = 0; // 0 = first round, 1 = reverse round
    private int setupPlayerIndex = 0;
    private int currentPlayerIndex = 0;

    private Map<Color, String> colorNamesMap = new HashMap<>();
    private List<Player> setupOrder = new ArrayList<>();
    private List<Player> players = new ArrayList<>();
    private Player bank = null;

    private final Board board;

    private CatanGame(Board board) {
	this.board = board;
    }

    /**
     * Creats an new board in a CatanGame instance, gives board Catangame and then starts the game
     * @param args
     */
    public static void main(String[] args){
	CatanGame game = new CatanGame(new Board(2));
	game.board.setGame(game);
	game.startGame(game);
    }

    /**
     * Let's the player choose how many people are playing form 1 to 4 then gets there names and what coler they want the creates the players a starts the game. Also handels exceptions and creats the bank for tradeing.
     * @param game
     */
    private void startGame(CatanGame game){
	board.createDefaultBoard();
	bank = new Player("bank", Color.BLACK);
	Map<Resource, Integer> addResourceTest = new EnumMap<>(Resource.class);
	colorNamesMap.put(Color.RED, "Red");
	colorNamesMap.put(Color.BLUE, "Blue");
	colorNamesMap.put(Color.GREEN, "Green");
	colorNamesMap.put(Color.ORANGE, "Yellow");
	final int maxResources = 99;
	for (Resource r : Resource.values()) {
	    addResourceTest.put(r, maxResources);
	}
	bank.addResourceMap(addResourceTest);
	int playerAmount = 0;
	final int maxPlayers = 4;
	while(playerAmount < 1 || playerAmount > maxPlayers){
	    try{
		playerAmount = Integer.parseInt(JOptionPane.showInputDialog("Hur många ska spela?: 1-4 spelare"));
	    } catch (NumberFormatException e){
		JOptionPane.showMessageDialog(new Frame(), e.getMessage(), "Failed to add playerAmount", JOptionPane.ERROR_MESSAGE);
	    }
	}
	for (int i = 0; i < playerAmount; i++) {
	    String name = JOptionPane.showInputDialog("Namn:");

	    JDialog colorDialog = new JDialog((Frame) null, "Välj vilken färg du vill vara", true);
	    colorDialog.setLayout(new FlowLayout());

	    final Color[] selectedColor = { null };

	    for (Color color : colorNamesMap.keySet()) {
		String colorName = colorNamesMap.getOrDefault(color, "Unknown");
		JButton button = new JButton(colorName);
		button.setBackground(color);

		button.addActionListener(e -> {
		    selectedColor[0] = color;
		    colorNamesMap.remove(color);
		    colorDialog.dispose();
		});

		colorDialog.add(button);
	    }

	    colorDialog.pack();
	    colorDialog.setLocationRelativeTo(null);
	    colorDialog.setVisible(true);

	    if (selectedColor[0] != null) {
		players.add(new Player(name, selectedColor[0]));
	    }
	}

	board.setCurrentPlayer(players.get(currentPlayerIndex));
	setupOrder.addAll(players);

	CatanViewer catanViewer = new CatanViewer(board,game);
	try {
	    catanViewer.show();
	} catch (IOException e) {
	    JOptionPane.showMessageDialog(new Frame(), e.getMessage(), "Failed to load image", JOptionPane.ERROR_MESSAGE);
	}
	catanViewer.startSetupPhase();
    }

    /**
     * @return List of all players
     */
    public List<Player> getPlayers() {
	return players;
    }

    /**
     * @return the player object bank which has max of all resources
     */
    public Player getBank() {
	return bank;
    }

    /**
     * @return the player next up in the setup order
     */
    public Player getSetupPlayer() {
	return setupOrder.get(setupPlayerIndex);
    }

    /**
     *  Setup is done if setup is in step 1 which is revers and we are at the end of the list so all players have taken there turn
     * @return true if setup is done
     */
    public boolean isSetupDone() {
    	return setupStep == 1 && setupPlayerIndex < 0;
    }

    /**
     * Handels the logic for reversing the order in step 1
     */
    public void advanceSetup() {
	if (setupStep == 0) {
	    setupPlayerIndex++;
	    if (setupPlayerIndex >= setupOrder.size()) {
		setupStep = 1;
		setupPlayerIndex = setupOrder.size() - 1;
	    }
	} else {
	    setupPlayerIndex--;
	}
	if (!isSetupDone()) {
	    board.setCurrentPlayer(getSetupPlayer());
	}
    }

    /**
     * Ends currentplayers turn
     */
    public void endTurn() {
	currentPlayerIndex = (currentPlayerIndex + 1) % players.size();
	board.setCurrentPlayer(players.get(currentPlayerIndex));
    }

}