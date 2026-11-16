package se.liu.elior637.components.assets;

import java.awt.*;

/**
 * Interface for requirements for Road objects.
 */
public interface Road extends Placeable
{
    void render(Graphics g, int xStart, int yStart,int xEnd,int yEnd);
}
