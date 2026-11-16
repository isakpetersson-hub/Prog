package se.liu.elior637.coregame.logic;

import se.liu.elior637.components.assets.Building;
import se.liu.elior637.components.assets.BuildingType;
import se.liu.elior637.components.assets.PlacementRule;
import se.liu.elior637.components.assets.Road;
import se.liu.elior637.components.tile.Edge;
import se.liu.elior637.components.tile.EdgeHandler;
import se.liu.elior637.coregame.Player;
import se.liu.elior637.components.tile.Vertex;
import se.liu.elior637.components.tile.VertexHandler;
import se.liu.elior637.coregame.Board;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Placementrule implementation for standard catan build rules.
 */
public class UnifiedPlacementRuleImplementation implements PlacementRule
{

    /**
     * Validates all Vertices in the board and returns a list of possible build locations.
     * Also checks for building upgrades and verifies the locations of those.
     * @param board The Catan board to look in.
     * @param buildingType The buildingtype to check valid placements for.
     * @return List of valid Vertices for the Building type.
     */
    @Override public List<Vertex> validateBuildingVertices(final Board board, final BuildingType buildingType) {
	List<Vertex> validVertices = new ArrayList<>();
	Player currentPlayer = board.getCurrentPlayer();
	boolean isUpgrade = false;
	List<BuildingType> prerequisiteTypes = new ArrayList<>();
	VertexHandler vertexHandler = board.getVertexHandler();
	EdgeHandler edgeHandler = board.getEdgeHandler();
	Map<Edge, Road> roads = board.getRoads();
	List<Vertex> playerRoadVertices = new ArrayList<>();

	for (Map.Entry<BuildingType, List<BuildingType>> entry : BuildingType.getUpgradePaths().entrySet()) {
	    if (entry.getValue().contains(buildingType)) {
		isUpgrade = true;
		prerequisiteTypes.add(entry.getKey());
	    }
	}

	for (Map.Entry<Edge,Road> entry : roads.entrySet()) {
	    if (entry.getValue().getPlayer().equals(currentPlayer)) {
		 List <Vertex> verticesForEdge= edgeHandler.getVerticesForEdge(entry.getKey());
		 playerRoadVertices.addAll(verticesForEdge);
	    }
	}

	for (Vertex vertex : board.getAllVertices()) {
	    if (isUpgrade) {
		Building existing = board.getBuildings().get(vertex);
		if (existing != null && prerequisiteTypes.contains(existing.getBuildingType())&&existing.getPlayer().equals(currentPlayer)) {
		    validVertices.add(vertex);
		}
	    }
	    else {
		if (board.getBuildings().containsKey(vertex)) {
		    continue;
		}

		List<Vertex> adjacentVertices = vertexHandler.getAdjacentVertices(vertex,board);
		boolean isValid = true;
		for (Vertex adjacent : adjacentVertices) {
		    if (adjacent!=null) {
//			System.out.println("Checking adjacent vertex for " + vertex.getCoord() + ": " + adjacent.getCoord());
		    }

		    if (board.getBuildings().containsKey(adjacent)) {
//			System.out.println("Vertex " + vertex.getCoord() + " is invalid due to adjacent building at " + adjacent.getCoord());
			isValid = false;
			break;
		    }
		}

		if (!isValid){
		    continue;
		}

		if (board.isInitialSetupPhase()){
		    validVertices.add(vertex);
		}else{
		    if (playerRoadVertices.contains(vertex)) {
			validVertices.add(vertex);
		    }
		}
	    }
	}

	return validVertices;

    }

    /**
     * Validates all Road placements and returns a list of all valid build locations.
     * @param board The Catan board to look in.
     * @param roadType The type of road to verify placement locations for.
     * @return List of all valid Edges to place the type of Road on.
     */
    @Override public List<Edge> validateRoadEdges(final Board board) {
	List<Edge> validEdges = new ArrayList<>();
	List<Vertex> validVertices = new ArrayList<>();

	EdgeHandler edgeHandler = board.getEdgeHandler();
	Player currentPlayer = board.getCurrentPlayer();

	Map<Vertex,Building> buildings = board.getBuildings();
	Map<Edge,Road> roads = board.getRoads();

	for (Map.Entry<Vertex,Building> entry : buildings.entrySet()) {
	    if (entry.getValue().getPlayer().equals(currentPlayer)) {
		validVertices.add(entry.getKey());
	    }
	}

	for (Map.Entry<Edge,Road> entry : roads.entrySet()) {
	    if (entry.getValue().getPlayer().equals(currentPlayer)) {
		List<Vertex> roadVertices = edgeHandler.getVerticesForEdge(entry.getKey());
		validVertices.addAll(roadVertices);
	    }
	}

	for (Vertex vertex : validVertices) {
	    List<Edge> edgesForVertex = edgeHandler.getEdgesForVertex(vertex,board);

	    for (Edge edge : edgesForVertex) {
		if (!roads.containsKey(edge)) {
		    validEdges.add(edge);
		}
	    }
	}

	return new ArrayList<>(validEdges);
    }
}
