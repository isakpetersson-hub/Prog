package se.liu.elior637.components.tile;

import java.util.Objects;

/**
 * A class representing a hex, which the grid system consists of.
 */
public class Hex
{
    private final int qCoordinate;
    private final int rCoordinate;

    public Hex(final int qCoordinate, final int rCoordinate) {
	this.qCoordinate = qCoordinate;
	this.rCoordinate = rCoordinate;
    }

    /**
     * Column value for the hex. Increases to the right.
     * Is 0 for middle tile, and stays 0 for all tiles top left and bottom right from the middle tile.
     * @return integer for the column value.
     */
    public int getQCoordinate() {
	return qCoordinate;
    }

    /**
     * Row value for the hex. Increases downwards below the middle line.
     * @return integer for the row value.
     */
    public int getRCoordinate() {
	return rCoordinate;
    }

    @Override public boolean equals(final Object o) {
	if (!(o instanceof Hex)) {
	    return false;
	}
	final Hex hex = (Hex) o;
	return qCoordinate == hex.qCoordinate && rCoordinate == hex.rCoordinate;
    }

    @Override public int hashCode() {
	return Objects.hash(qCoordinate, rCoordinate);
    }

    @Override public String toString() {
	return "Hex{" + "q=" + qCoordinate + ", r=" + rCoordinate + '}';
    }
}
