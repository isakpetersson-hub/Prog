package se.liu.elior637.coregame;

import se.liu.elior637.components.tile.Resource;
import se.liu.elior637.components.assets.Building;
import se.liu.elior637.components.assets.BuildingType;
import se.liu.elior637.components.tile.Edge;
import se.liu.elior637.components.tile.EdgeHandler;
import se.liu.elior637.components.tile.Hex;
import se.liu.elior637.components.assets.Road;
import se.liu.elior637.components.assets.RoadType;
import se.liu.elior637.components.tile.ResourceTile;
import se.liu.elior637.components.tile.TileType;
import se.liu.elior637.components.tile.Vertex;
import se.liu.elior637.coregame.logic.GameLogic;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Handels graphics drawing and image handeling
 */
public class BoardComponent extends JComponent
{
    private static final int HEX_ANGLE = 60;
    private final CatanGame game;
    private final Board board;

    private final static int TILE_SIZE = 60;

    private final BufferedImage desertImage;
    private final BufferedImage fieldImage;
    private final BufferedImage forestImage;
    private final BufferedImage hillImage;
    private final BufferedImage mountainImage;
    private final BufferedImage pastureImage;
    private final BufferedImage brickCard;
    private final BufferedImage grainCard;
    private final BufferedImage oreCard;
    private final BufferedImage woolCard;
    private final BufferedImage lumberCard;
    private final BufferedImage buildingCostsCard;
    private final BufferedImage cardBack;
    private final BufferedImage robber;

    public BoardComponent(final Board board,CatanGame game) throws IOException {
	this.board = board;
	this.game = game;
	setPreferredSize(new Dimension(800, 600));

	final Class<? extends BoardComponent> getClass = getClass();
	desertImage = ImageIO.read(getClass.getResource("/images/desertTile.png"));
	fieldImage = ImageIO.read(getClass.getResource("/images/fieldTile.png"));
	forestImage = ImageIO.read(getClass.getResource("/images/forestTile.png"));
	hillImage = ImageIO.read(getClass.getResource("/images/hillTile.png"));
	mountainImage = ImageIO.read(getClass.getResource("/images/mountainTile.png"));
	pastureImage = ImageIO.read(getClass.getResource("/images/pastureTile.png"));
	brickCard = ImageIO.read(getClass.getResource("/images/Resource_Brick.png"));
	grainCard = ImageIO.read(getClass.getResource("/images/Resource_Grain.png"));
	oreCard = ImageIO.read(getClass.getResource("/images/Resource_Ore.png"));
	woolCard = ImageIO.read(getClass.getResource("/images/Resource_Sheep.png"));
	lumberCard = ImageIO.read(getClass.getResource("/images/Resource_Wood.png"));
	buildingCostsCard = ImageIO.read(getClass.getResource("/images/BuildingCosts.png"));
	cardBack = ImageIO.read(getClass.getResource("/images/CardBack.png"));
	robber = ImageIO.read(getClass.getResource("/images/robber.png"));
    }

    /**
     * The main method that handel drawing
     * @param g the <code>Graphics</code> object to protect
     */
    protected void paintComponent(final Graphics g) {
	super.paintComponent(g);

	drawTiles(g);
	drawResourceCards(g);
	drawRoads(g);
	drawBuildings(g);
	drawPlayerOrder(g);
	drawValidBuildPlace(g);
	drawValidRobberPosition(g);
	drawRobber(g);
	final int buildCostCardSize = 130;
	g.drawImage(buildingCostsCard, g.getClipBounds().width - buildCostCardSize, 0, buildCostCardSize, buildCostCardSize*2, null);
	if(board.isGameOver()){
	    g.setColor(Color.WHITE);
	    g.drawString("Game Over " + board.getCurrentPlayer().getName() + " van",getWidth()/2,getHeight()/2);
	}
    }

    /**
     * Handels the logic of where to draw the tiles
     * @param g
     */
    private void drawTiles(final Graphics g) {
	for (ResourceTile resourceTile : board.getTiles().values()) {
	    Hex hex = resourceTile.getPosition();
	    Point pixel = hexToPixel(hex.getQCoordinate(), hex.getRCoordinate(), TILE_SIZE);
	    drawHex(g, pixel.x, pixel.y, TILE_SIZE, resourceTile);
	    drawNumberMarkers(g, pixel.x, pixel.y);
	    drawNumber(resourceTile, g, pixel.x, pixel.y);
	}
    }

    /**
     * Handels the logic of where to draw the valid build places
     * @param g
     */
    private void drawValidBuildPlace(final Graphics g) {
	GameLogic gameLogic = new GameLogic(board);
	final Map<Resource, Integer> playerResources = board.getCurrentPlayer().getResources();
	if ((board.getBuildStatus() == 1 && board.containsResource(RoadType.STANDARD_ROAD.getCost(), playerResources)) || board.getSetUpBuildStatus() == 1) {
	    List<Edge> validEdge = gameLogic.validateRoadEdges(RoadType.STANDARD_ROAD);
	    for(Edge edge : validEdge){
		if (board.getAllEdges().contains(edge)) {
		    g.setColor(Color.WHITE);
		    Point point = edgeToPixel(edge);
		    final int size = 10;
		    g.fillOval(point.x - size/2, point.y - size/2, size, size);
		}
	    }
	}
	else if((board.getBuildStatus() == 2 && board.containsResource(BuildingType.SETTLEMENT.getCost(), playerResources)) || board.getSetUpBuildStatus() == 2){
	     drawValidBuildPlaceBuildings(g, BuildingType.SETTLEMENT, gameLogic);
	}
	else if((board.getBuildStatus() == 3 && board.containsResource(BuildingType.CITY.getCost(), playerResources)) || board.getSetUpBuildStatus() == 3) {
	    drawValidBuildPlaceBuildings(g, BuildingType.CITY, gameLogic);
	}
    }

    /**
     * Draw the white dot on the valid builing places
     * @param g
     * @param building
     * @param gameLogic
     */
    private void drawValidBuildPlaceBuildings(Graphics g, BuildingType building, GameLogic gameLogic) {
	List<Vertex> validVertex = gameLogic.validateBuildingVertices(building);
	for(Vertex vertex : validVertex){
	    g.setColor(Color.WHITE);
	    Point point = vertexToPixel(vertex);
	    final int size = 10;
	    g.fillOval(point.x - size/2, point.y - size/2, size, size);
	}
    }

    /**
     * Draws white circels around the numbers when robber can be moved
     * @param g
     */
    private void drawValidRobberPosition(final Graphics g){
	if (board.isMovingRobber()&&!board.isInitialSetupPhase()){
	    for (ResourceTile resourceTile : board.getTiles().values()) {
		Hex hex = resourceTile.getPosition();
		if (Objects.equals(hex, board.getRobber().getPosition())) continue;
		Point point = hexToPixel(hex.getQCoordinate(), hex.getRCoordinate(), TILE_SIZE);
		Graphics2D g2d = (Graphics2D) g;
		g2d.setStroke(new BasicStroke(3));
		g2d.setColor(Color.WHITE);
		final int size = 40;
		g.drawOval(point.x - size/2, point.y - size/2, size, size);
	    }
	}
    }

    /**
     * Draws the players name and score with the color they are
     * @param g
     */
    private void drawPlayerOrder(final Graphics g) {
	int i = 0;
	for(Player player: game.getPlayers()) {
	    g.setColor(player.getColor());
	    String name = player.getName();
	    FontMetrics fm = g.getFontMetrics();
	    final int nameOffset = 50;
	    final int drawStart = 20;
	    g.drawString(name, 0, drawStart + i * nameOffset);
	    final int drawOffset = 10;
	    g.drawString("" + player.getScore(), fm.stringWidth(name) + drawOffset, drawStart + i * nameOffset);
	    int h = 0;
	    final int cardSize = 30;
	    for (Map.Entry<Resource, Integer> entry : player.getResources().entrySet()) {
		int amount = entry.getValue();
		for (int j = 0; j < amount; j++) {
		    g.drawImage(cardBack, h * drawOffset, cardSize + i * drawOffset, cardSize/2, cardSize, null);
		    h++;
		}
	    }
	    i++;
	}
    }

    /**
     * Draw the amount of reocource cards all the players have
     * @param g
     */
    private void drawResourceCards(final Graphics g) {
	int i = 0;
	for (Map.Entry<Resource, Integer> entry : board.getCurrentPlayer().getResources().entrySet()) {
	    Resource type = entry.getKey();
	    int amount = entry.getValue();

	    for (int j = 0; j < amount; j++) {
		BufferedImage image = null;
		switch (type){
		    case ORE:
			image = oreCard;
			break;
		    case WOOL:
			image = woolCard;
			break;
		    case BRICK:
			image = brickCard;
			break;
		    case GRAIN:
			image = grainCard;
			break;
		    case LUMBER:
			image = lumberCard;
			break;
		}
		final int imageSize = 80;
		g.drawImage(image, i * 25, g.getClipBounds().height - imageSize, imageSize/2, imageSize, null);
		i++;
	    }
	}
    }

    /**
     * Draws the robber
     * @param g
     */
    private void drawRobber(final Graphics g){
	Hex robberHex = board.getRobber().getPosition();
	Point p = hexToPixel(robberHex.getQCoordinate(), robberHex.getRCoordinate(), TILE_SIZE);
	final int imageSize = 50;
	g.drawImage(robber, p.x - imageSize/2, p.y - imageSize/2, imageSize, imageSize, null);
    }
    private void drawHex(Graphics g, int x, int y, int size, ResourceTile resourceTile) {
	final int dir = board.getDirections().length;
	int[] xPoints = new int[dir];
	int[] yPoints = new int[dir];

	for (int i = 0; i < dir; i++) {
	    double angle = Math.toRadians(HEX_ANGLE * i - ((double) HEX_ANGLE / 2));
	    xPoints[i] = (int)(x+size*Math.cos(angle));
	    yPoints[i] = (int)(y+size*Math.sin(angle));
	}
	TileType tileType = resourceTile.getTileType();
	BufferedImage image = new BufferedImage(size, size, BufferedImage.TYPE_INT_ARGB);
	switch (tileType){
	    case DESERT:
		image = desertImage;
		break;
	    case MOUNTAINS:
		image = mountainImage;
		break;
	    case PASTURES:
		image = pastureImage;
		break;
	    case HILLS:
		image = hillImage;
		break;
	    case FIELDS:
		image = fieldImage;
		break;
	    case FORESTS:
		image = forestImage;
		break;
	}
	g.drawImage(image, x - TILE_SIZE, y - TILE_SIZE, TILE_SIZE * 2, TILE_SIZE * 2, null);

	g.setColor(Color.black);
	g.drawPolygon(xPoints, yPoints, dir);
    }

    /**
     * Draws the number of the tile on the tile
     * @param tile
     * @param g
     * @param x
     * @param y
     */
    private void drawNumber(ResourceTile resourceTile, Graphics g, int x, int y) {
	String number = String.valueOf(resourceTile.getNumber());

	Font biggerFont = new Font("Arial", Font.BOLD, 20);
	g.setFont(biggerFont);

	FontMetrics fm = g.getFontMetrics();
	int textWidth = fm.stringWidth(number);
	int textHeight = fm.getAscent();
	int textX = x-textWidth/2;
	int textY = y+textHeight/2;

	if (board.getHotNumbers().contains(resourceTile.getNumber())) {
	    g.setColor(Color.red);
	}else{
	    g.setColor(Color.black);
	}

	g.drawString(number, textX, textY);
    }

    /**
     * Draws the number marker in the center of the tile
     * @param g
     * @param x
     * @param y
     */
    private void drawNumberMarkers(Graphics g,int x, int y){
	g.setColor(Color.decode("#e8c79b"));
	final int numberMarkerSize = 30;
	g.fillOval(x - numberMarkerSize/2, y - numberMarkerSize/2, numberMarkerSize, numberMarkerSize);
    }

    /**
     * Draws out the buildings of each player
     * @param g
     */
    private void drawBuildings(Graphics g) {
	for (Map.Entry<Vertex, Building> entry : board.getBuildings().entrySet()) {
	    Vertex vertex = entry.getKey();
	    Building b = entry.getValue();

	    Point pixel = vertexToPixel(vertex);
	    b.render(g,pixel.x,pixel.y);
	}
    }

    /**
     * Draws out the roads of each player
     * @param g
     */
    private void drawRoads(Graphics g) {
	EdgeHandler edgeHandler = board.getEdgeHandler();
	for (Map.Entry<Edge, Road> entry : board.getRoads().entrySet()) {
	    Edge edge = entry.getKey();
	    Road r = entry.getValue();

	    List<Vertex> edgeVertices = edgeHandler.getVerticesForEdge(edge);

	    Point start = vertexToPixel(edgeVertices.get(0));
	    Point end = vertexToPixel(edgeVertices.get(1));

	    r.render(g, start.x, start.y, end.x, end.y);
	}
    }

    /**
     * Coverts specified hex to a point
     * @param q
     * @param r
     * @param size
     * @return point of the hex choosen
     */
    private Point hexToPixel(int q,int r, int size) {
	double x= getX(q, r, size);
	double y = getADouble(r, size);
	return new Point((int)x, (int)y);
    }

    /**
     * Help function to get tje x coordinate
     * @param q
     * @param r
     * @param size
     * @return
     */
    private double getX(final int q, final int r, final int size) {
	return size * Math.sqrt(3) * (q + r / 2.0) + getWidth() / 2.0;
    }

    /**
     * Helper function to get y cooordinate
     * @param q
     * @param r
     * @param size
     * @return
     */
    private double getADouble(final int r, final int size) {
	return size * 1.5 * r + getHeight() / 2.0;
    }

    /**
     * @param p
     * @return closest hex to point choosen
     */
    public Hex getHexAt(Point p) {
	double px = p.x - getWidth() / 2.0;
	double py = p.y - getHeight() / 2.0;

	double q = getQ(TILE_SIZE, px, py);
	double r = (2.0/3.0 * py) / TILE_SIZE;

	return hexRound(q, r);
    }

    /**
     * @param size
     * @param px
     * @param py
     * @return double that is q coordinate
     */
    private static double getQ(final int size, final double px, final double py) {
	return (Math.sqrt(3.0) / 3.0 * px - 1.0 / 3.0 * py) / size;
    }

    /**
     * @param q
     * @param r
     * @return a new hex that is closest to selected q and r
     */
    private Hex hexRound(double q, double r) {
	double s = -q - r;

	int rq = (int)Math.round(q);
	int rr = (int)Math.round(r);
	int rs = (int)Math.round(s);

	double qDiff = Math.abs(rq - q);
	double rDiff = Math.abs(rr - r);
	double sDiff = Math.abs(rs - s);

	if (qDiff > rDiff && qDiff > sDiff) {
	    rq = -rr - rs;
	} else if (rDiff > sDiff) {
	    rr = -rq - rs;
	}

	return new Hex(rq, rr);
    }

    /**
     * Converts the selected vertex to a point
     * @param vertex
     * @return point where vertex is
     */
    private Point vertexToPixel(Vertex vertex) {
	Vertex standardVertex = board.getVertexHandler().getOrCreateVertex(vertex.getHex(),vertex.getDirection());
	Hex baseHex = standardVertex.getHex();
	int cornerIndex = standardVertex.getDirection();

	Point pixel = hexToPixel(baseHex.getQCoordinate(), baseHex.getRCoordinate(), TILE_SIZE);

	double angle = Math.toRadians((HEX_ANGLE * (cornerIndex - 1) - (double) HEX_ANGLE / 2));
	double x = pixel.x + TILE_SIZE * Math.cos(angle);
	double y = pixel.y + TILE_SIZE * Math.sin(angle);

	return new Point((int)x, (int)y);
    }

    /**
     * @param point
     * @return closest vertex to point
     */
    public Vertex getVertexAt(final Point point) {
	Vertex closestVertex = null;
	double minDistance = Double.MAX_VALUE;

	for (Vertex v : board.getAllVertices()) {
	    Point vertexPixel = vertexToPixel(v);
	    double distance = point.distance(vertexPixel);

	    if (distance < minDistance) {
		minDistance = distance;
		closestVertex = v;
	    }
	}
	return closestVertex;
    }

    /**
     * Converts edge to point
     * @param edge
     * @return point of edge choosen
     */
    private Point edgeToPixel(Edge edge) {
	EdgeHandler edgeHandler = board.getEdgeHandler();
	Edge standardEdge = edgeHandler.getOrCreateEdge(edge.getHex(),edge.getDirection());
	Hex baseHex = standardEdge.getHex();
	final int cornerIndex = edge.getDirection();
	final int roadStrokeSize = 7;

	Point pixel = hexToPixel(baseHex.getQCoordinate(), baseHex.getRCoordinate(), TILE_SIZE);

	double angle = Math.toRadians(HEX_ANGLE * (cornerIndex - 1));
	double x = pixel.x+ (TILE_SIZE - roadStrokeSize) * Math.cos(angle);
	double y = pixel.y+ (TILE_SIZE - roadStrokeSize) * Math.sin(angle);

	return new Point((int)x, (int)y);

    }

    /**
     * @param point
     * @return closest edge to point
     */
    public Edge getEdgeAt(final Point point) {
	Edge closestEdge = null;
	double minDistance = Double.MAX_VALUE;

	for (Edge e : board.getAllEdges()) {
	    Point edgePixel = edgeToPixel(e);
	    double distance = point.distance(edgePixel);

	    if (distance < minDistance) {
		minDistance = distance;
		closestEdge = e;
	    }
	}
	return closestEdge;
    }
}
