package se.liu.elior637.components.misc;

import java.awt.*;
import java.awt.image.BufferedImage;

/**
 * Handler for converting black icons into specified color.
 */
public class ImageHandler
{
    public BufferedImage flatColor(BufferedImage src, Color color) {
	BufferedImage result = new BufferedImage(src.getWidth(), src.getHeight(), BufferedImage.TYPE_INT_ARGB);
	for (int y = 0; y < src.getHeight(); y++) {
	    for (int x = 0; x < src.getWidth(); x++) {
		int alpha = (src.getRGB(x, y) >> 24) & 0xff;
		int newColor = (alpha << 24) | (color.getRed() << 16) | (color.getGreen() << 8) | color.getBlue();
		result.setRGB(x, y, newColor);
	    }
	}
	return result;
    }
}
