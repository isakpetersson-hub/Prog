package se.liu.elior637.components.assets;

import se.liu.elior637.components.misc.ImageHandler;
import se.liu.elior637.coregame.Player;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;

/**
 * Implementation Class for the buildingType: Settlement. Implements all necessary building methods.
 */
public class SettlementImplementation implements Building {

    private final Player player;
    private BufferedImage tintedImage;

    public SettlementImplementation(Player player) {

	this.player=player;
	this.tintedImage = null;
	try {
	    BufferedImage image = ImageIO.read(getClass().getResource("/images/settlement.png"));
	    ImageHandler i = new ImageHandler();
	    tintedImage = i.flatColor(image, player.getColor());
	} catch (IOException e) {
	    JOptionPane.showMessageDialog(new Frame(), e.getMessage(), "Failed to load image", JOptionPane.ERROR_MESSAGE);
	}
    }

    /**
     *
     * @return Enum value for the building. This is used to access relevant info via the enumType.
     */
    @Override public BuildingType getBuildingType() {
	return BuildingType.SETTLEMENT;
    }

    /**
     * Get amount of victorypoints for the building
     * @return
     */
    @Override public int getVictoryPoints() {
	return 1;
    }

    /**
     * Get amount of resource the buillding produces.
     * @return
     */
    @Override public int getResourceProduction() {
	return 1;
    }

    /**
     * Renders the Settlement using its own icon,
     * @param g graphics to display the building in the game window
     * @param x coordinate to place the building along the x-axis
     * @param y coordinate to place the building along the y-axis
     */
    @Override public void render(final Graphics g, final int x, final int y) {
	final int imageSize = 40;
	final int offset = 5;
	g.drawImage(tintedImage, x - imageSize/2, y - offset - imageSize/2, imageSize, imageSize, null);
    }

    /**
     * Get player Owner for building.
     * @return
     */
    @Override public Player getPlayer() {
	return player;
    }
}
