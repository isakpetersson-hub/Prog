package se.liu.elior637.components.assets;

import java.awt.*;

/**
 * Interface for requirements for Building objects.
 */
public interface Building extends Placeable
{
    BuildingType getBuildingType();
    int getVictoryPoints();
    int getResourceProduction();
    void render(Graphics g, int x, int y);
}
