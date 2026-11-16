package se.liu.elior637.components.tile;

import se.liu.elior637.coregame.Board;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Singleton class to handle edges.
 * The class is mainly used to get and create edges, to ensure overlapping edges are treated as the same object.
 * Use: EdgeHandler.getInstance() to ensure proper function.
 */
public class EdgeHandler {
    private final Map<String, Edge> edgeMap = new HashMap<>();
    private Board board;

    public EdgeHandler(Board board) {
	this.board = board;
    }

    /**
     * Get or create an Edge using hex and direction. Uses canonical key to ensure overlapping edges are treated as one.
     * @param hex object for the edge
     * @param direction of the edge. 0 is top right, clockwise. 5 is top right.
     * @return Edge object if it exists, otherwise creates an edge.
     */
    public Edge getOrCreateEdge(Hex hex, int direction) {
	if (direction < 0 || direction >= board.getDirections().length) {
	    throw new IllegalStateException("Unexpected direction: " + direction);
	}
	String key = getCanonicalEdgeKey(hex, direction);
	return edgeMap.computeIfAbsent(key, k -> new Edge(hex, direction));
    }

    /**
     * Returns a String "Map" of the shared Edges.
     * @param hex object for the edge.
     * @param direction of the edge. 0 is top right, clockwise. 5 is top right.
     * @return String key for overlapping edge based on hex and direction.
     */
    private String getCanonicalEdgeKey(Hex hex, int direction) {
	int q = hex.getQCoordinate();
	int r = hex.getRCoordinate();
	return switch (direction) {
	    case 0 -> canonical(q, r, 0, q+1,r-1,3);
	    case 1 -> canonical(q, r, 1,q+1,r,4);
	    case 2 -> canonical(q,r,2,q,r+1,5);
	    case 3 -> canonical(q, r, 3,q-1,r+1,0);
	    case 4 -> canonical(q, r, 4,q-1,r,1);
	    case 5 -> canonical(q,r,5,q,r-1,2);
	    default -> throw new IllegalStateException("Unexpected direction: " + direction);
	};
    }

    /**
     * Method to compute and compare two edges and return the same object.
     * @param q1 hex 1: column cordinate
     * @param r1 hex 1: row cordinate
     * @param d1 hex 1: direction
     * @param q2 hex 2: column cordinate
     * @param r2 hex 2: row cordinate
     * @param d2 hex 2: direction
     * @return Formatted string "key" for the edge object the inputs refer to.
     */
    private String canonical(int q1, int r1, int d1, int q2, int r2, int d2) {
	String s1 = "h" + q1 + "," + r1 + "e" + d1;
	String s2 = "h" + q2 + "," + r2 + "e" + d2;
	return Stream.of(s1, s2).min(String::compareTo).orElse(s1);
    }

    /**
     * Returns a list of all edges touching a given vertex.
     * @param vertex the vertex to get all edges for.
     * @param board the board object to look in
     * @return
     */
    public List<Edge> getEdgesForVertex(Vertex vertex, Board board) {
	List<Edge> edges = new ArrayList<>();

	for (ResourceTile resourceTile : board.getTiles().values()) {
	    Hex hex = resourceTile.getPosition();
	    Map<Integer, Vertex> vertexMap = board.getTileVertices(hex);
	    if (vertexMap == null) continue;

	    for (int dir = 0; dir < board.getDirections().length; dir++) {
		if (vertex.equals(vertexMap.get(dir))) {
		    int q = hex.getQCoordinate();
		    int r = hex.getRCoordinate();
		    int prevDir = (dir-1+board.getDirections().length) % board.getDirections().length;

		    Edge prevEdge = getOrCreateEdge(hex, prevDir);
		    Edge nextEdge = getOrCreateEdge(hex, dir);

		    if (prevEdge!=null) {
			edges.add(prevEdge);
		    }
		    if (nextEdge!=null) {
			edges.add(nextEdge);
		    }

		    switch (dir) {
			case 0: // Top
			    edges.add(getOrCreateEdge(new Hex(q, r-1),1));
			    edges.add(getOrCreateEdge(new Hex(q+1, r-1),4));
			    break;
			case 1: // Top-right
			    edges.add(getOrCreateEdge(new Hex(q + 1, r-1), 2));
			    edges.add(getOrCreateEdge(new Hex(q+1, r),5));
			    break;
			case 2: // Bottom-right
			    edges.add(getOrCreateEdge(new Hex(q+1, r), 3));
			    edges.add(getOrCreateEdge(new Hex(q, r+1),0));
			    break;
			case 3: // Bottom
			    edges.add(getOrCreateEdge(new Hex(q, r + 1), 4));
			    edges.add(getOrCreateEdge(new Hex(q-1, r+1),1));
			    break;
			case 4: // Bottom-left
			    edges.add(getOrCreateEdge(new Hex(q - 1, r), 2));
			    edges.add(getOrCreateEdge(new Hex(q-1, r+1),5));
			    break;
			case 5: // Top-left
			    edges.add(getOrCreateEdge(new Hex(q-1, r), 0));
			    edges.add(getOrCreateEdge(new Hex(q, r-1),3));
			    break;
		    }
		}
	    }
	}

	return edges.stream().filter(Objects::nonNull).collect(Collectors.toList());
    }

    /**
     * A method to get a list of the two vertices that a road is touching.
     * @param edge the edge we are referring to.
     * @return a list of the two vertices on both sides of the edge.
     */
    public List<Vertex> getVerticesForEdge(Edge edge) {
	Hex hex = edge.getHex();
	int dir = edge.getDirection();

	Vertex v1 = board.getVertexHandler().getOrCreateVertex(hex, dir);
	Vertex v2 = board.getVertexHandler().getOrCreateVertex(hex, (dir + 1) % 6);

	return Arrays.asList(v1, v2);
    }
}