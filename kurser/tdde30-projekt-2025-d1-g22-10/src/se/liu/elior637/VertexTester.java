package se.liu.elior637;

import se.liu.elior637.components.assets.Building;
import se.liu.elior637.components.assets.BuildingType;
import se.liu.elior637.components.tile.Edge;
import se.liu.elior637.components.tile.EdgeHandler;
import se.liu.elior637.components.tile.Hex;
import se.liu.elior637.components.assets.RoadType;
import se.liu.elior637.components.tile.Vertex;
import se.liu.elior637.components.tile.VertexHandler;
import se.liu.elior637.coregame.Board;
import se.liu.elior637.coregame.logic.GameLogic;

import java.util.List;
import java.util.Map;

/**
 * Test Class for testing Vertices and their implementations. Used for verifying overlapping vertices and core logic.
 */
public class VertexTester
{
    public static void main(String[] args) {
	Board test = new Board(2);
	test.createDefaultBoard();

	VertexHandler vertexHandler = test.getVertexHandler();
	EdgeHandler edgeHandler = test.getEdgeHandler();

	Vertex v1 = vertexHandler.getOrCreateVertex(new Hex(0, 0), 0);
	System.out.println(v1);
	Vertex v2 = vertexHandler.getOrCreateVertex(new Hex(0,-1),2);
	System.out.println(v2);
	Vertex v3 = vertexHandler.getOrCreateVertex(new Hex(1,-1),4);
	System.out.println(v3);

	Vertex v4 = vertexHandler.getOrCreateVertex(new Hex(0,-1),0);

	GameLogic g = new GameLogic(test);
	g.placeBuilding(v1, BuildingType.SETTLEMENT);
	test.getBuildings().values().forEach(System.out::println);
	g.placeBuilding(v2,BuildingType.CITY);
	test.getBuildings().values().forEach(System.out::println);
	g.placeBuilding(v4,BuildingType.SETTLEMENT);

	Edge e1 = edgeHandler.getOrCreateEdge(new Hex(0, 0), 0);
	Edge e2 = edgeHandler.getOrCreateEdge(new Hex(0,0),1);

	System.out.println("Placing roads");

	g.placeRoad(e1, RoadType.STANDARD_ROAD);
	g.placeRoad(e2,RoadType.STANDARD_ROAD);

	test.getRoads().values().forEach(System.out::println);

	Vertex v5 = vertexHandler.getOrCreateVertex(new Hex(-1,1),4);
	System.out.println(v5);

	g.placeBuilding(v5,BuildingType.SETTLEMENT); //OK
	test.getBuildings().values().forEach(System.out::println);
	g.placeBuilding(v5,BuildingType.CITY); //OK

	System.out.println("Innan getedges");

	List<Edge> l1 = edgeHandler.getEdgesForVertex(v5, test);
	for (Edge e : l1){
	    System.out.println(e);
	}

	List<Vertex> l2 = edgeHandler.getVerticesForEdge(e1);
	for (Vertex v : l2){
	    System.out.println(v.getHex()+" direction: "+v.getDirection());
	}

	test.endInitialSetupPhase();

	Edge wrong = edgeHandler.getOrCreateEdge(new Hex(0,1),2);
	System.out.println("innan validate");
	List<Edge> l = g.validateRoadEdges(RoadType.STANDARD_ROAD);
	System.out.println("efter validate");
	for (Edge e : l){
	    System.out.println("valid: "+e);
	}

	for (Map.Entry<Vertex, Building> entry : test.getBuildings().entrySet()) {
		System.out.println("building: hex " + entry.getKey().getHex() + " direction: "+entry.getKey().getDirection());
	}

	System.out.println(test.getCurrentPlayer().getScore());

	g.placeRoad(wrong,RoadType.STANDARD_ROAD);

    }
}
