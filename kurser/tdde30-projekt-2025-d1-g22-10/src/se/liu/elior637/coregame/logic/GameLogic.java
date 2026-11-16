package se.liu.elior637.coregame.logic;

import se.liu.elior637.components.assets.Building;
import se.liu.elior637.components.assets.BuildingType;
import se.liu.elior637.components.assets.Road;
import se.liu.elior637.components.assets.RoadType;
import se.liu.elior637.components.tile.Edge;
import se.liu.elior637.components.misc.SoundHandler;
import se.liu.elior637.components.tile.Vertex;
import se.liu.elior637.coregame.Board;

import java.net.URL;
import java.util.List;

/**
 * Foundation for the logic of the Catan game.
 */
public class GameLogic {
    private final Board board;
    private SoundHandler buildSoundHandler;
    private SoundHandler roadSoundHandler;
    private SoundHandler upgradeSoundHandler;

    public GameLogic(final Board board) {
	this.board = board;
	URL buildSound = getClass().getResource("/audio/build-sound.wav");
	URL roadSound = getClass().getResource("/audio/road-sound.wav");
	URL upgradeSound = getClass().getResource("/audio/upgrade.wav");
	this.buildSoundHandler = new SoundHandler(buildSound);
	this.upgradeSoundHandler = new SoundHandler(upgradeSound);
	this.roadSoundHandler = new SoundHandler(roadSound);
    }

    /**
     * A method to return all valid placements for a given building.
     * If the building is an Upgrade the only valid position is the prequisite type.
     * @param buildingType The tupe of building to check valid placements for.
     * @return List of all valid vertices to build at.
     */
    public List<Vertex> validateBuildingVertices(BuildingType buildingType) {
	return buildingType.getPlacementRule().validateBuildingVertices(board, buildingType);
    }

    /**
     * A method to return all of the valid placements for a given roadType.
     * If the road is an upgrade the only valid placement is the prequisite road type.
     * @param roadType The type of road to check valid placements for.
     * @return List of all Edges that are valid to build on.
     */
    public List<Edge> validateRoadEdges(RoadType roadType) {
	return roadType.getPlacementRule().validateRoadEdges(board);
    }

    /**
     * A method to place a building. Only places the building if there are any valid placements.
     * Also removes the score for the previous building if the chosen BuildingType is an upgrade.
     * @param vertex The vertex to place the building at.
     * @param buildingType The type of building to place on the vertex.
     */
    public void placeBuilding(Vertex vertex, BuildingType buildingType) {
	List<Vertex> validBuildingVertices = validateBuildingVertices(buildingType);
	if (!validBuildingVertices.contains(vertex)) {
	    throw new IllegalStateException("Cannot place " + buildingType.getDisplayName() + " at vertex: " + vertex);
	}

	Building existing = board.getBuildings().get(vertex);
	if (existing != null) {
	    board.getCurrentPlayer().removeScore(existing.getVictoryPoints());
	    upgradeSoundHandler.playSound();
	}else{
	    buildSoundHandler.playSound();
	}
	Building newBuilding = buildingType.getHandler().create(board.getCurrentPlayer());


	board.addBuilding(vertex, newBuilding);
	board.getCurrentPlayer().addScore(newBuilding.getVictoryPoints());
	board.checkIfPlayerHasWon(board.getCurrentPlayer());
    }

    /**
     * A method to place a road on an edge. Places the road on the edge if the edge is a valid placement.
     * @param edge The edge to place the road at.
     * @param roadType The type of road to place at the edge.
     */
    public void placeRoad(Edge edge, RoadType roadType) {
	List<Edge> validRoadEdges = validateRoadEdges(roadType);
	if (!validRoadEdges.contains(edge)) {
	    throw new IllegalStateException("Cannot place "+roadType.getDisplayName()+" at edge: "+edge);
	}

	roadSoundHandler.playSound();

	Road road = roadType.getHandler().create(board.getCurrentPlayer());
	board.addRoad(edge,road);
    }
}
