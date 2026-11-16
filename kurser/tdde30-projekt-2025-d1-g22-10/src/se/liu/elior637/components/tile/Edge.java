package se.liu.elior637.components.tile;

import java.util.Objects;

/**
 * Class that defines all edges on the board. The edges are tied to a hex and direction.
 * Edge 0 for a hex is top-right and counts upwards clockwise.
 */
public class Edge
{
    private final Hex hex;
    private final int direction;

    public Edge(final Hex hex, final int direction) {
	this.hex = hex;
	final int maxEdges = 6;
	this.direction = direction % maxEdges;
    }

    /**
     * Get hex for an edge. Is only used to divide an edge into hex and direction. Use Edgehandler to properly get an Edge.
     * @return Hex for the edge.
     */
    public Hex getHex() {
	return hex;
    }

    /**
     * Get direction for an edge
     * @return Direction for the edge. Direction 0 is the top rightmost edge. Direction increases clockwise.
     */
    public int getDirection() {
	return direction;
    }

    @Override public boolean equals(final Object o) {
	if (!(o instanceof Edge)) {
	    return false;
	}
	final Edge edge = (Edge) o;
	return direction == edge.direction && Objects.equals(hex, edge.hex);
    }

    @Override public int hashCode() {
	return Objects.hash(hex, direction);
    }

    @Override public String toString() {
	return "Edge{" + "hex=" + hex + ", direction=" + direction + '}';
    }

}
