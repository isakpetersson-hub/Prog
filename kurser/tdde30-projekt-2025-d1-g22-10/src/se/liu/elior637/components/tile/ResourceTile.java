package se.liu.elior637.components.tile;

/**
 * Class that represents a Resource tile.
 */
public class ResourceTile
{
    private final Hex position;
    private final TileType tileType;
    private final int number;
    private final Resource resources;

    public ResourceTile(final Hex position, final TileType tileType, final int number, final Resource resources) {
	this.position = position;
	this.tileType = tileType;
	this.number = number;
	this.resources = resources;
    }

    /**
     * Get hex position for the tile.
     * @return Hex where the tile is located.
     */
    public Hex getPosition() {
	return position;
    }

    /**
     * Get Type of tile.
     * @return TileType type of tile.
     */
    public TileType getTileType() {
	return tileType;
    }

    /**
     * Get resources for the tile.
     * @return
     */
    public Resource getResources() {
	return resources;
    }

    /**
     * Get tile number
     * @return Dice number of the tile
     */
    public int getNumber() {
	return number;
    }

    @Override public String toString() {
	return "Tile{" + "position=" + position + ", resource=" + tileType + ", number=" + number + '}';
    }
}
