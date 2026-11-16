package se.liu.elior637.coregame;

import se.liu.elior637.components.tile.Resource;
import se.liu.elior637.components.assets.Building;
import se.liu.elior637.components.misc.BackgroundMusic;
import se.liu.elior637.components.misc.SoundHandler;
import se.liu.elior637.components.tile.Edge;
import se.liu.elior637.components.tile.EdgeHandler;
import se.liu.elior637.components.tile.Hex;
import se.liu.elior637.components.assets.Road;
import se.liu.elior637.components.tile.ResourceTile;
import se.liu.elior637.components.tile.TileType;
import se.liu.elior637.components.tile.Vertex;
import se.liu.elior637.components.tile.VertexHandler;

import javax.swing.*;
import java.awt.*;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Random;

/**
 * Handels the logic releated to the board, hexes and resource handeling
 */
public class Board
{
    private boolean gameOver = false;
    private CatanGame game = null;
    private final int radius;

    private final static int END_SCORE = 10;
    private int buildStatus = 0;
    private int setUpBuildStatus = 0;
    private int bankTradeAmount = 4;

    private Map<Hex, ResourceTile> tiles;

    private static final Hex[] DIRECTIONS = new Hex[] {
	    new Hex(1,0),new Hex(1,-1), new Hex(0,-1),new Hex(-1,0),new Hex(-1,1),new Hex(0,1),
    };
    private List<Integer> hotNumbers = new ArrayList<>();

    private static final Random RND = new Random();

    private final Map<Vertex, Building> buildings;
    private final Map<Edge, Road> roads;
    private final Map<Hex, Map<Integer, Vertex>> vertices;
    private final Map<Hex, Map<Integer, Edge>> edges;

    private Player currentPlayer;
    private Robber robber;
    private boolean movingRobber;

    private boolean initialSetupPhase = true;

    private final URL getCardSound;
    private final URL rollDiceSound;
    private final URL winSound;
    private final BackgroundMusic bg;

    private VertexHandler vertexHandler = new VertexHandler();
    private EdgeHandler edgeHandler = new EdgeHandler(this);

    public Board(int radius) {
	this.radius = radius;
	this.tiles = new HashMap<>();
	this.buildings = new HashMap<>();
	this.roads = new HashMap<>();
	this.vertices = new HashMap<>();
	this.edges = new HashMap<>();
	this.currentPlayer = new Player("Default", Color.RED);
	this.movingRobber=false;
	this.robber = null;
	this.getCardSound = getClass().getResource("/audio/resource-gained.wav");
	this.rollDiceSound = getClass().getResource("/audio/dice-throw.wav");
	this.winSound = getClass().getResource("/audio/game-win.wav");
	URL bgMusic = getClass().getResource("/audio/game-bg.wav");
	this.bg = new BackgroundMusic(bgMusic, -15.0f);
	hotNumbers.add(6);
	hotNumbers.add(8);
    }

    /**
     * @return vertex handeler
     */
    public VertexHandler getVertexHandler() {
	return vertexHandler;
    }

    /**
     * @return edge handeler
     */
    public EdgeHandler getEdgeHandler() {
	return edgeHandler;
    }

    /**
     * @return Map of all Tiles
     */
    public Map<Hex, ResourceTile> getTiles() {
	return tiles;
    }

    /**
     * @return Map of buildings with Vertex as key
     */
    public Map<Vertex, Building> getBuildings() {
	return buildings;
    }

    /**
     * @return Map of roads with Edge as key
     */
    public Map<Edge, Road> getRoads() {
	return roads;
    }

    /**
     * @return current player
     */
    public Player getCurrentPlayer() {
	return currentPlayer;
    }

    /**
     * @return robber
     */
    public Robber getRobber() {
	return robber;
    }

    /**
     * @return buildStatus
     */
    public int getBuildStatus() {
	return buildStatus;
    }

    /**
     * @return setUpBuildStatus
     */
    public int getSetUpBuildStatus() {
	return setUpBuildStatus;
    }


    /**
     * @param hex
     * @return Map och all Vertecies for the hex with Interger has key that is the direction
     */
    public Map<Integer, Vertex> getTileVertices(Hex hex) {
	return vertices.get(hex);
    }


    /**
     * @return Collecction of all roads in board
     */
    public Collection<Edge> getAllEdges() {
	Collection<Edge> allEdges = new ArrayList<>();
	for (Map<Integer, Edge> innerMap : edges.values()) {
	    allEdges.addAll(innerMap.values());
	}
	return allEdges;
    }

    /**
     * @return Collection of all vertices in board
     */
    public Collection<Vertex> getAllVertices() {
	Collection<Vertex> allVertices = new ArrayList<>();
	for (Map<Integer, Vertex> innerMap : vertices.values()) {
	    allVertices.addAll(innerMap.values());
	}
	return allVertices;
    }

    /**
     * @return Directions
     */
    public Hex[] getDirections() {
	return DIRECTIONS;
    }

    /**
     * @return highest propeblity numbers
     */
    public List<Integer> getHotNumbers() {
	return hotNumbers;
    }

    /**
     * @return true if is in Setup phase
     */
    public boolean isInitialSetupPhase() {
	return initialSetupPhase;
    }

    /**
     * @return true if robber can be placed
     */
    public boolean isMovingRobber() {
	return movingRobber;
    }

    /**
     * Sets the game to gains acces to Catangame
     */
    public void setGame(CatanGame game) {
	this.game = game;
    }

    /**
     * Sets current player to the param player
     * @param currentPlayer
     */
    public void setCurrentPlayer(final Player currentPlayer) {
	this.currentPlayer = currentPlayer;
    }

    public void setBuildStatus(final int buildStatus) {
	this.buildStatus = buildStatus;
    }

    /**
     * Sets Building status to param
     * @param setUpBuildStatus
     */
    public void setSetUpBuildStatus(final int setUpBuildStatus) {
	this.setUpBuildStatus = setUpBuildStatus;
    }

    /**
     * Sets movingRobber to false
     */
    public void endRobberMovingPhase() {
	movingRobber = false;
    }

    /**
     * Sets endInitialSetupPhase to false
     */
    public void endInitialSetupPhase() {
	initialSetupPhase = false;
    }

    /**
     * Adds to buildings map with vertex as key and building as object
     * @param vertex
     * @param building
     */
    public void addBuilding(Vertex vertex, Building building) {
	buildings.put(vertex, building);
    }

    /**
     * Adds to roads map with edge as and road as object
     * @param edge
     * @param road
     */
    public void addRoad(Edge edge, Road road) {
	roads.put(edge, road);
    }

    /**
     * @param buildCost the List you want to see if it exist in the other
     * @param playerResources the List you wnat to see if it has the other List as a sub List
     * @return if all buildCost Resources exist in playerResouces
     */
    public boolean containsResource(Map<Resource, Integer> buildCost, Map<Resource, Integer> playerResources) {
	for (Map.Entry<Resource, Integer> entry : buildCost.entrySet()) {
	    Resource type = entry.getKey();
	    int requiredAmount = entry.getValue();
	    int playerAmount = playerResources.getOrDefault(type, 0);
	    if (playerAmount < requiredAmount) {
		return false;
	    }
	}
	return true;
    }

    /**
     * Removes the resources of first list from the second list
     * @param removeAmount
     * @param playerResources
     */
    public void removeResource(Map<Resource, Integer> removeAmount, Map<Resource, Integer> playerResources){
	for (Map.Entry<Resource, Integer> entry : playerResources.entrySet()) {
	    Resource type = entry.getKey();
	    int currentAmount = entry.getValue();
	    playerResources.put(type, currentAmount - removeAmount.getOrDefault(type,0));
	}
    }

    /**
     * Startar background music
     */
    public void startBackgroundMusic(){
	bg.play();
    }

    /**
     * Checks if the player has over the score requirment to win if it does change gameOver to true and play sound
     * @param player the player that is check if it has won
     */
    public void checkIfPlayerHasWon(Player player){
	if(player.getScore() >= END_SCORE){
	    SoundHandler soundHandler = new SoundHandler(winSound);
	    soundHandler.playSound();
	    bg.stop();
	    bg.close();
	    gameOver = true;
	}
    }

    /**
     * @return true if gameOver
     */
    public boolean isGameOver() {
	return gameOver;
    }

    /**
     * Creats the Normal board for Catan with 5 wide and 5 tall hex grid. It creates it according to the standard Catan rules for board creation
     */
    public void createDefaultBoard() {
	List<Integer> priorityNumbers = new ArrayList<>();
	List<Integer> otherNumbers = new ArrayList<>();

	for (int num : List.of(2, 3, 3, 4, 4, 5, 5, 6, 6, 8, 8, 9, 9, 10, 10, 11, 11, 12)){
	    if (hotNumbers.contains(num)){
		priorityNumbers.add(num);
	    }else {
		otherNumbers.add(num);
	    }
	}

	Collections.shuffle(priorityNumbers);
	Collections.shuffle(otherNumbers);

	List<TileType> mutableTileTypes = new ArrayList<>(List.of(TileType.HILLS, TileType.HILLS, TileType.HILLS, TileType.FORESTS, TileType.FORESTS, TileType.FORESTS,
								  TileType.FORESTS, TileType.PASTURES, TileType.PASTURES, TileType.PASTURES, TileType.PASTURES,
								  TileType.FIELDS, TileType.FIELDS, TileType.FIELDS, TileType.FIELDS, TileType.MOUNTAINS,
								  TileType.MOUNTAINS, TileType.MOUNTAINS));
	List<Hex> hexPositions = generateHexGrid(radius);
	Collections.shuffle(mutableTileTypes);
	Collections.shuffle(hexPositions);

	Hex desertHex = new Hex(0, 0);
	hexPositions.remove(desertHex);
	tiles.put(desertHex, new ResourceTile(desertHex, TileType.DESERT, 0, Resource.NONE));
	robber = new Robber(desertHex);

	for (Iterator<Hex> it = hexPositions.iterator(); it.hasNext()&&!priorityNumbers.isEmpty(); ) {
	    Hex hex = it.next();
	    if (isAdjacentToSixOrEight(hex)){
		continue;
	    }

	    int num = priorityNumbers.removeFirst();
	    TileType type = mutableTileTypes.removeFirst();
	    Resource resource = getResourceForType(type);
	    tiles.put(hex,new ResourceTile(hex, type, num, resource));

	    it.remove();
	}

	if(!priorityNumbers.isEmpty()){
	    throw new IllegalStateException("Couldnt place all 6s and 8s without adjacency.");
	}

	for (int i = 0; i < hexPositions.size(); i++) {
	    Hex hexPosition = hexPositions.get(i);
	    TileType hexTileType = mutableTileTypes.get(i);
	    int number = otherNumbers.get(i);
	    Resource resource = getResourceForType(hexTileType);
	    tiles.put(hexPosition, new ResourceTile(hexPosition, hexTileType, number, resource));
	}

	for (ResourceTile resourceTile : tiles.values()) {
	    Hex hex = resourceTile.getPosition();
	    Map<Integer, Vertex> dirMap = new HashMap<>();
	    for (int dir = 0; dir < DIRECTIONS.length; dir++) {
		dirMap.put(dir, vertexHandler.getOrCreateVertex(hex, dir));
	    }
	    vertices.put(hex, dirMap);
	}

	for (ResourceTile resourceTile : tiles.values()) {
	    Hex hex = resourceTile.getPosition();
	    Map<Integer, Edge> dirMap = new HashMap<>();
	    for (int dir = 0; dir < DIRECTIONS.length; dir++) {
		dirMap.put(dir, new Edge(hex, dir));
	    }
	    edges.put(hex, dirMap);
	}
    }

    /**
     * @param hex
     * @return true if hex is next to a tile with the numbers 6 or 8
     */
    private boolean isAdjacentToSixOrEight(Hex hex) {
	for (ResourceTile neighbor : getTileNeighbors(hex)){
	    int number = neighbor.getNumber();
	    if (hotNumbers.contains(number)) {
		return true;
	    }
	}
	return false;
    }

    /**
     * Gets the neighbors of the hex
     * @param hex
     * @return List of all Neighbor tiles
     */
    public List<ResourceTile> getTileNeighbors(Hex hex) {
	List<ResourceTile> neighbors = new ArrayList<>();
	for (Hex dir : DIRECTIONS) {
	    Hex neighborPos = new Hex(hex.getQCoordinate() + dir.getQCoordinate(), hex.getRCoordinate() + dir.getRCoordinate());
	    ResourceTile neighborResourceTile = tiles.get(neighborPos);
	    if (neighborResourceTile != null) {
		neighbors.add(neighborResourceTile);
	    }
	}
	return neighbors;
    }

    /**
     * Generates the hex Coordnate System which is made with a List of Hexes
     * @param radius
     * @return List of Hex
     */
    private List<Hex> generateHexGrid(int radius) {
	List<Hex> grid = new ArrayList<>();
	for (int i = -radius; i <= radius; i++) {
	    int r1 = Math.max(-radius, -i - radius);
	    int r2 = Math.min(radius, -i + radius);
	    for (int r = r1; r <= r2; r++) {
		grid.add(new Hex(i, r));
	    }
	}
	return grid;
    }

    /**
     * Gives the Resource that tile gives
     * @param TileType
     * @return	Resource
     */
    private static Resource getResourceForType(final TileType type) {
	switch (type) {
	    case FIELDS:
		return Resource.GRAIN;
	    case HILLS:
		return Resource.BRICK;
	    case FORESTS:
		return Resource.LUMBER;
	    case MOUNTAINS:
		return Resource.ORE;
	    case PASTURES:
		return Resource.WOOL;
	    default:
		return Resource.NONE;
	}
    }

    /**
     * Rolls 2d6 and adds them to get the rolled value triggers the robber if a 7 is rolled other wise call giveResourceAfterRoll
     * @return the value of the rolled dices
     */
    public int rollDice() {
	SoundHandler soundHandler = new SoundHandler(rollDiceSound);
	soundHandler.playSound();
	final int diceSides = 6;
	final int robberNumber = 7;
	int result = RND.nextInt(1, diceSides + 1) + RND.nextInt(1, diceSides + 1);
	if (result == robberNumber) {
	    for (Player player : game.getPlayers()) {
		Collection<Integer> amount = player.getResources().values();
		int totalAmount = 0;
		for (int integer : amount) {
		    totalAmount += integer;
		}
		int cardsToRemove = (int)Math.ceil((double) totalAmount / 2);
		while (totalAmount > robberNumber) {
		    JFrame remove = new JFrame(player.getName()+ " hade " + totalAmount + " ta bort " + cardsToRemove + " kort");
		    remove.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		    Map<Resource, Integer> resultRemove = new ResourceSelectorDialog(remove, player).showDialog();
		    removeResource(resultRemove,player.getResources());
		    Collection<Integer> newAmount = player.getResources().values();
		    int newTotalAmount = 0;
		    for (int integer : newAmount) {
			newTotalAmount += integer;
		    }
		    cardsToRemove -= (totalAmount - newTotalAmount);
		    if(totalAmount/2 >= newTotalAmount) {
			totalAmount = 0;
		    }
		}
	    }

	    movingRobber=true;

	}else {
	    tiles.values().forEach(resourceTile -> giveResourceAfterRoll(resourceTile, result));
	}
	return result;
    }

    /**
     * Gives resources to player that have a building next to a hex with that value.
     * @param resourceTile the tile that is checked
     * @param result the value of the dice rolls
     */
    private void giveResourceAfterRoll(final ResourceTile resourceTile, final int result) {
	if (resourceTile.getNumber() == result && !Objects.equals(robber.getPosition(), resourceTile.getPosition())) {
	    Hex hex = resourceTile.getPosition();

	    for (int i=0; i < DIRECTIONS.length; i++) {
		Vertex canonical = vertexHandler.getVertex(hex,i);
		if (buildings.containsKey(canonical)) {
		    Building building = buildings.get(canonical);
		    Player player = building.getPlayer();
		    Map<Resource,Integer> getResources = new EnumMap<>(Resource.class);
		    getResources.put(resourceTile.getResources(), building.getResourceProduction());
		    player.addResourceMap(getResources);
		}
	    }
	}
    }

    /**
     * Trade funtion, the player chooses what resources the want to give away then what they want and how many times. Then the other players can accept or decline if all trades are done or no player accepts return
     */
    public void tradePlayer() {
	JFrame tradeAwayFrame = new JFrame("Välj vilka hur många resources du vill bytta bort");
	tradeAwayFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
	Map<Resource, Integer> resultAway = new ResourceSelectorDialog(tradeAwayFrame,currentPlayer).showDialog();
	if(resultAway.isEmpty() || !containsResource(resultAway,currentPlayer.getResources())) {
	    return;
	}
	JFrame tradeGetFrame = new JFrame("Välj vilka hur många resources du vill få");
	tradeGetFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
	Map<Resource, Integer> resultGet = new ResourceSelectorDialog(tradeGetFrame, game.getBank()).showDialog();
	int tradeAmount = 0;
	try{
	    tradeAmount = Integer.parseInt(JOptionPane.showInputDialog("Hur många sånda trades vill du göra?:"));
	} catch (NumberFormatException e){
	    JOptionPane.showMessageDialog(new Frame(), e.getMessage(), "Failed to add tradeAmount", JOptionPane.ERROR_MESSAGE);
	}
	while(tradeAmount > 0) {
	    boolean hasTraded = false;
	    for (Player player : game.getPlayers()) {
		if (!player.equals(currentPlayer) && containsResource(resultGet, player.getResources())) {
		    int svar = JOptionPane.showConfirmDialog(null, "Accepterar " + player.getName() + " detta bytte?", "Handels förfrågan", JOptionPane.YES_NO_OPTION);
		    if (svar == JOptionPane.YES_OPTION) {
			SoundHandler soundHandler = new SoundHandler(getCardSound);
			soundHandler.playSound();
			currentPlayer.addResourceMap(resultGet);
			removeResource(resultGet, player.getResources());
			player.addResourceMap(resultAway);
			removeResource(resultAway, currentPlayer.getResources());
			tradeAmount--;
			hasTraded = true;
		    }
		}
		if(tradeAmount == 0){
		    return;
		}
	    }
	    if(!hasTraded) {
		return;
	    }
	}
    }

    /**
     * Starts trade with Bank, player chooses what reources to trade away, the goes to TradeBankRecive
     * @param onTradeFinished used to return to called place at the end
     */
    public void tradeBank(Runnable onTradeFinished) {
	JDialog tradeAwayFrame = new JDialog();
	tradeAwayFrame.setTitle("Välj vilken resources du vill byta bort");
	tradeAwayFrame.setLayout(new FlowLayout());

	for (Resource resource : currentPlayer.getResources().keySet()) {
	    if (currentPlayer.getResources().getOrDefault(resource, 0) >= bankTradeAmount) {
		JButton button = new JButton("" + resource);
		tradeAwayFrame.add(button);
		button.addActionListener(e -> {
		    tradeBankReceive(resource, onTradeFinished);
		    tradeAwayFrame.dispose();
		});
	    }
	}

	tradeAwayFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
	tradeAwayFrame.pack();
	tradeAwayFrame.setLocationRelativeTo(null);
	tradeAwayFrame.setVisible(true);
    }

    /**
     * Second funtion in tradeBank, player selects what resource to get, then calls TradeFinilizedBank
     * @param resourceAway Resource from TradeBank
     * @param onTradeFinished used to return to called place when funtion is done
     */
    private void tradeBankReceive(Resource resourceAway, Runnable onTradeFinished) {
	JDialog tradeAwayFrame = new JDialog();
	tradeAwayFrame.setTitle("Välj vilken resources du vill byta till");
	tradeAwayFrame.setLayout(new FlowLayout());

	for (Resource resource : Resource.values()) {
	    if(!resource.equals(Resource.NONE)) {
		JButton button = new JButton("" + resource);
		tradeAwayFrame.add(button);
		button.addActionListener(e -> {
		    tradeFinalizedBank(resource, resourceAway);
		    tradeAwayFrame.dispose();
		    if (onTradeFinished != null) {
			onTradeFinished.run();
		    }
		});
	    }
	}

	tradeAwayFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
	tradeAwayFrame.pack();
	tradeAwayFrame.setLocationRelativeTo(null);
	tradeAwayFrame.setVisible(true);
    }

    /**
     * Final function in TradeBank, removes and adds the selected resources
     * @param resourceGet resource player gets
     * @param resourceAway resource player losses
     */
    private void tradeFinalizedBank(Resource resourceGet, Resource resourceAway) {
	currentPlayer.getResources().put(resourceAway, currentPlayer.getResources().get(resourceAway) - bankTradeAmount);
	currentPlayer.addResource(resourceGet);
    }
}
