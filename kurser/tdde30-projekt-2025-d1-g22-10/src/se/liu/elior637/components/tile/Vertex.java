package se.liu.elior637.components.tile;

/**
 * Class to represent Vertices in the board.
 * A vertex is a corner for a tile, which represents a HEX position. All tiles have 6 vertices.
 * A vertex is represented by a hex, and direction. Uses VertexHandler to get or create vertices.
 */
public class Vertex
{
    private int direction;
    private Hex hex;

    protected Vertex(final Hex hex, final int direction) {
	this.direction = direction;
        this.hex = hex;
    }

    @Override
    public int hashCode() {
	return System.identityHashCode(this);
    }

    /**
     * Get hex for a vertex. Is only used to divide a vertex into hex and direction to provide into the VertexHandler.
     * @return
     */
    public Hex getHex() {
        return hex;
    }

    /**
     * Get direction for a Vertex
     * @return Int direction. Direction 0 is topmost vertex, and then increments clockwise e.g. vertex 3 is bottom vertex.
     */
    public int getDirection() {
        return direction;
    }


    @Override public String toString() {
        return "Vertex{" + "direction=" + direction + ", hex=" + hex + '}';
    }
}
