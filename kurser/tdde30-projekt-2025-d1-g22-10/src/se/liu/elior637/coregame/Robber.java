package se.liu.elior637.coregame;

import se.liu.elior637.components.tile.Hex;

/**
 * Class to represent robber. Stores Board and position.
 */
public class Robber {
    private Hex position;

    public Robber(final Hex startPosition) {
	this.position = startPosition;
    }

    /**
     * Get position for the robber.
     * @return Hex where the robber is located.
     */
    public Hex getPosition() {
	return position;
    }

    /**
     * Set the position for the robber.
     * @param position Current position where the robber is located.
     */
    public void setPosition(final Hex position) {
	this.position = position;
    }
}
