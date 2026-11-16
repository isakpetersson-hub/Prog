package se.liu.elior637.components.assets;

import se.liu.elior637.coregame.Player;

import java.awt.*;
/**
 * Class for implementing the standard catan road type.
 */
public class StandardRoadImplementation implements Road {
    private final Player player;

    public StandardRoadImplementation(final Player player) {
	this.player = player;
    }

    /**
     * Draws a line for the standard road, between the two vertices for the road edge.
     * @param g Graphics to display the road at.
     * @param xStart X-coordinate for the start vertex.
     * @param yStart Y-coordinate for the start vertex.
     * @param xEnd X-coordinate for the end vertex.
     * @param yEnd Y-coordinate for the end vertex.
     */
    @Override public void render(final Graphics g, final int xStart, final int yStart, final int xEnd, final int yEnd) {
	Graphics2D g2d = (Graphics2D) g;
	g2d.setStroke(new BasicStroke(7));
	g2d.setColor(player.getColor());
	g2d.drawLine(xStart, yStart, xEnd, yEnd);
    }

    @Override public Player getPlayer() {
	return player;
    }
}
