package se.liu.elior637.coregame;

import se.liu.elior637.components.tile.Resource;
import se.liu.elior637.components.assets.BuildingType;
import se.liu.elior637.components.tile.Edge;
import se.liu.elior637.components.tile.Hex;
import se.liu.elior637.components.assets.RoadType;
import se.liu.elior637.components.tile.Vertex;
import se.liu.elior637.coregame.logic.GameLogic;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.IOException;
import java.util.Map;

/**
 * Manges the logic around the frames, buttons and mouseclicks
 */
public class CatanViewer
{
    private Board board;
    private CatanGame game;
    private GameLogic gameLogic;

    private JLabel buildLabel = new JLabel();
    private JLabel playerLabel = new JLabel();

    private boolean isSetupPhase = false;
    private JLabel diceLabel = null;

    public CatanViewer(final Board board, final CatanGame game) {
	this.board = board;
	this.game = game;
	gameLogic = new GameLogic(board);
    }

    /**
     * Initilzes the frame, buttons and mouseclick handeling
     * @throws IOException
     */
    public void show() throws IOException {
	JFrame frame = new JFrame("Settlers of Catan");

	JPanel topPanel = new JPanel();
	topPanel.setLayout(new BoxLayout(topPanel, BoxLayout.Y_AXIS));

	JPanel topRow = new JPanel(new BorderLayout());
	JPanel playerPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
	JPanel rollPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
	JPanel bottomLeftRow = new JPanel(new FlowLayout(FlowLayout.LEFT));
	JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));

	frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	frame.setLayout(new BorderLayout());

	BoardComponent b = new BoardComponent(board,game);
	b.addMouseListener(new MouseAdapter() {
	    @Override
	    public void mouseClicked(MouseEvent e) {
		Point clickPoint = e.getPoint();

		if (isSetupPhase) {
		    if (board.getSetUpBuildStatus() == 2) {
			handleSetupSettlement(clickPoint, b);
		    } else if (board.getSetUpBuildStatus() == 1) {
			handleSetupRoad(clickPoint, b);
		    }
		} else {
		    if (board.isMovingRobber()){
			handleBoardClickHex(clickPoint, b);
		    }
		    else if (board.getBuildStatus() == 1) {
			handleBoardClickRoad(clickPoint, b);
		    }
		    else if (board.getBuildStatus() == 2) {
			handleBoardClickSettlement(clickPoint, b);
		    }
		    else if (board.getBuildStatus() == 3){
			handleBoardClickCity(clickPoint, b);
		    }
		}
	    }

	});

	frame.add(b, BorderLayout.CENTER);

	Container pane = frame.getContentPane();

	playerLabel = new JLabel(board.getCurrentPlayer().getName());
	buildLabel = new JLabel("Normal");

	JLabel rollTextLabel = new JLabel("Roll:");
	JLabel playerTextLabel = new JLabel("Current Player:");
	diceLabel = new JLabel("0");
	diceLabel.setHorizontalAlignment(SwingConstants.CENTER);

	JButton buttonSettlement = new JButton("Build Settlement");
	JButton buttonRoad = new JButton("Build Road");
	JButton buttonEnd = new JButton("End Turn");
	JButton buttonCity = new JButton("Build City");
	JButton buttonTrade = new JButton("Trade Players");
	JButton buttonTradeBank = new JButton("Trade Bank");

	buttonSettlement.addActionListener(e -> {
	    if (buttonsAreActive()){
		if (board.getBuildStatus() == 2) {
		    changeStatus(0,"Normal");
		    b.repaint();
		}else{
		    changeStatus(2,"Settlment");
		    b.repaint();
		}
	    }
	});
	buttonEnd.addActionListener(e -> {
	    if (buttonsAreActive()){
		game.endTurn();
		playerLabel.setText(board.getCurrentPlayer().getName());
		changeStatus(0,"Normal");
		diceLabel.setText(String.valueOf(board.rollDice()));
		b.repaint();
	    }
	});
	buttonRoad.addActionListener(e -> {
	    if (buttonsAreActive()){
		if (board.getBuildStatus() == 1) {
		    changeStatus(0,"Normal");
		    b.repaint();
		}else{
		    changeStatus(1,"Road");
		    b.repaint();
		}
	    }
	});
	buttonCity.addActionListener(e -> {
	    if (buttonsAreActive()){
		if (board.getBuildStatus() == 3) {
		    changeStatus(0,"Normal");
		    b.repaint();
		}else{
		    changeStatus(3,"City");
		    b.repaint();
		}
	    }
	});
	buttonTrade.addActionListener(e -> {
	    if (buttonsAreActive()){
		board.tradePlayer();
		b.repaint();
	    }
	});
	buttonTradeBank.addActionListener(e -> {
	    if (buttonsAreActive()){
		board.tradeBank(b::repaint);
	    }
	});

	playerPanel.add(playerTextLabel);
	playerPanel.add(playerLabel);

	rollPanel.add(rollTextLabel);
	rollPanel.add(diceLabel);

	topRow.add(playerPanel,BorderLayout.WEST);
	topRow.add(rollPanel,BorderLayout.CENTER);

	bottomLeftRow.add(buildLabel);

	topPanel.add(topRow);
	topPanel.add(bottomLeftRow);

	buttonPanel.add(buttonTradeBank);
	buttonPanel.add(buttonTrade);
	buttonPanel.add(buttonCity);
	buttonPanel.add(buttonSettlement);
	buttonPanel.add(buttonRoad);
	buttonPanel.add(buttonEnd);

	pane.add(buttonPanel, BorderLayout.SOUTH);
	pane.add(topPanel,BorderLayout.NORTH);

	frame.pack();
	frame.setVisible(true);

    }

    /**
     * Used to know if buttons can be pressed, are deacticated when placeing robber, during setp phase and when game is over
     * @return is robber can not move, setphase is over and game is not over
     */
    private boolean buttonsAreActive() {
	return !board.isMovingRobber() && !isSetupPhase && !board.isGameOver();
    }

    /**
     * Help funtion to change the current build status and change the displayed message
     * @param status
     * @param message
     */
    private void changeStatus(int status, String message) {
	board.setBuildStatus(status);
	buildLabel.setText(message);
    }

    /**
     * Used to know what hex is clicked and move the robber there
     * @param point where the player clicked
     * @param b boardComponent
     */
    private void handleBoardClickHex(Point point, BoardComponent b) {
	Hex clickedHex = b.getHexAt(point);
	if (clickedHex != null && board.isMovingRobber() && !clickedHex.equals(board.getRobber().getPosition())){
	    if (board.getTiles().containsKey(clickedHex)){
		board.setBuildStatus(0);
		board.getRobber().setPosition(clickedHex);
		board.endRobberMovingPhase();
		b.repaint();
	    }
	}
    }

    /**
     * Used to know what vertex is clicked and build and settelment there if possible
     * @param point where the player clicked
     * @param b boardComponent
     */
    private void handleBoardClickSettlement(Point point, BoardComponent b) {
	Vertex clickedVertex = b.getVertexAt(point);
	if (clickedVertex != null) {
	    final Map<Resource, Integer> playerResources = board.getCurrentPlayer().getResources();
	    if(board.containsResource(BuildingType.SETTLEMENT.getCost(), playerResources)) {
		gameLogic.placeBuilding(clickedVertex, BuildingType.SETTLEMENT);
		board.removeResource(BuildingType.SETTLEMENT.getCost(), playerResources);
		b.repaint();
	    }
	    b.repaint();
	    board.setBuildStatus(0);
	    buildLabel.setText("Normal");
	}
    }
    /**
     * Used to know what vertex is clicked and build and City there if possible
     * @param point where the player clicked
     * @param b boardComponent
     */
    private void handleBoardClickCity(Point point, BoardComponent b) {
	Vertex clickedVertex = b.getVertexAt(point);
	if (clickedVertex != null) {
	    final Map<Resource, Integer> playerResources = board.getCurrentPlayer().getResources();
	    if (board.getBuildings().containsKey(clickedVertex) && board.containsResource(BuildingType.CITY.getCost(), playerResources)) {
		gameLogic.placeBuilding(clickedVertex, BuildingType.CITY);
		board.removeResource(BuildingType.CITY.getCost(), playerResources);
		b.repaint();
	    }
	}
	b.repaint();
	board.setBuildStatus(0);
	buildLabel.setText("Normal");
    }
    /**
     * Used to know what Edge is clicked and build and road there if possible
     * @param point where the player clicked
     * @param b boardComponent
     */
    private void handleBoardClickRoad(Point point, BoardComponent b) {
	Edge clickedEdge = b.getEdgeAt(point);
	final Map<Resource, Integer> playerResources = board.getCurrentPlayer().getResources();
	if (clickedEdge != null && board.containsResource(RoadType.STANDARD_ROAD.getCost(), playerResources)) {
	    gameLogic.placeRoad(clickedEdge,RoadType.STANDARD_ROAD);
	    board.removeResource(RoadType.STANDARD_ROAD.getCost(), playerResources);
	    b.repaint();
	    board.setBuildStatus(0);
	    buildLabel.setText("Normal");
	}
    }

    /**
     * Starts setup phase, start music and changes status so building can be done
     */
    public void startSetupPhase() {
	board.startBackgroundMusic();
	isSetupPhase = true;
	buildLabel.setText("Setup: Place Settlement");
	playerLabel.setText(board.getCurrentPlayer().getName());
	Player currentSetupPlayer = game.getSetupPlayer();
	board.setCurrentPlayer(currentSetupPlayer);
	board.setSetUpBuildStatus(2);
    }

    /**
     * Used to know what hex is clicked and build a Settelment there during setup
     * @param point where the player clicked
     * @param b boardComponent
     */
    private void handleSetupSettlement(Point point, BoardComponent b) {
	Vertex v = b.getVertexAt(point);
	if (v != null) {
	    gameLogic.placeBuilding(v, BuildingType.SETTLEMENT);
	    b.repaint();
	    board.setSetUpBuildStatus(1);
	    buildLabel.setText("Setup: Place Road");
	}
    }
    /**
     * Used to know what edge is clicked and build a road there during setup
     * @param point where the player clicked
     * @param b boardComponent
     */
    private void handleSetupRoad(Point point, BoardComponent b) {
	Edge e = b.getEdgeAt(point);
	if (e != null) {
	    gameLogic.placeRoad(e, RoadType.STANDARD_ROAD);
	    b.repaint();
	    game.advanceSetup();
	    if (game.isSetupDone()) {
		isSetupPhase = false;
		buildLabel.setText("Normal");
		board.endInitialSetupPhase();
		board.setSetUpBuildStatus(0);
		diceLabel.setText(String.valueOf(board.rollDice()));
	    } else {
		startSetupPhase();
	    }
	}
    }
}
