package se.liu.elior637.components.assets;

import se.liu.elior637.coregame.Player;

/**
 * Handler for creating entities that extends Placeable.
 * @param <T> The class object that inherits placeable.
 */
public interface PlaceableHandler<T extends Placeable> {
    T create(Player player);
}
