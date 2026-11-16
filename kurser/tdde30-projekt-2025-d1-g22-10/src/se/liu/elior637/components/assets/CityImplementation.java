package se.liu.elior637.components.assets;

import se.liu.elior637.components.misc.ImageHandler;
import se.liu.elior637.coregame.Player;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;

/**
 * Implementation Class for the buildingType: City. Implements all necessary building methods.
 */
public class CityImplementation implements Building {

    private final Player player;

    public CityImplementation(final Player player) {
	this.player = player;
	try {
	    BufferedImage image = ImageIO.read(getClass().getResource("/images/city.png"));
	    ImageHandler i = new ImageHandler();
	    BufferedImage tintedImage = i.flatColor(image, player.getColor());
	} catch (IOException e) {
	    JOptionPane.showMessageDialog(new Frame(), e.getMessage(), "Failed to load image", JOptionPane.ERROR_MESSAGE);
	}
    }

    /**
     *
     * @return Enum value for the building. This is used to access relevant info via the enumType.
     */
    @Override public BuildingType getBuildingType() {
	return BuildingType.CITY;
    }

    @Override public int getVictoryPoints() {
	return 2;
    }

    /**
     *
     * @return Amount of resources that the building produces for nearby tiles.
     */
    @Override public int getResourceProduction() {
	return 2;
    }

    /**
     * Renders the City using its own icon,
     * @param g graphics to display the building in the game window
     * @param x coordinate to place the building along the x-axis
     * @param y coordinate to place the building along the y-axis
     */
    @Override public void render(final Graphics g, final int x, final int y) {

    }

    /**
     *
     * @return player that owns the building.
     */
    @Override public Player getPlayer() {
	return player;
    }
}
