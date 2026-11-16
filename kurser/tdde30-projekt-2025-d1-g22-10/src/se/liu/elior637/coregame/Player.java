package se.liu.elior637.coregame;

import se.liu.elior637.components.tile.Resource;

import java.awt.*;
import java.util.EnumMap;
import java.util.Map;

/**
 * A class representing a player for a catan board.
 */
public class Player
{
    private Map<Resource,Integer> resources = new EnumMap<>(Resource.class);
    private int score;
    private String name;
    private Color color;

    public Player(final String name, final Color color) {
	this.name = name;
	this.color = color;

    }

    /**
     * Gets all resources a player has.
     * @return Map of type of Resources and Amount.
     */
    public Map<Resource,Integer> getResources() {
	return resources;
    }

    /**
     * @return Current score for the player.
     */
    public int getScore() {
	return score;
    }

    /**
     * @return Name of the player.
     */
    public String getName() {
	return name;
    }

    /**
     * Adds a resource to the players inventory.
     * @param resourse The type of resource to add to the player.
     */
    public void addResource(Resource resource) {
	resources.put(resource, resources.getOrDefault(resource, 0) + 1);
    }

    /**
     * Adds a Resource map to the resource map for the Player.
     * @param getAmount
     */
    public void addResourceMap(Map<Resource, Integer> getAmount) {
	for (Map.Entry<Resource, Integer> entry : getAmount.entrySet()) {
	    Resource type = entry.getKey();
	    int addAmount = entry.getValue();
	    resources.put(type, addAmount + resources.getOrDefault(type, 0));
	}
    }

    /**
     * Add score to the player
     * @param addScore Score to add to the player
     */
    public void addScore(int addScore) {
	score += addScore;
    }

    /**
     * Removes the score from the player.
     * @param removeScore Amount to remove.
     */
    public void removeScore(int removeScore) {
	score -= removeScore;
    }

    /**
     * Get the color for the player.
     * @return Player Color.
     */
    public Color getColor() {
	return color;
    }
}
