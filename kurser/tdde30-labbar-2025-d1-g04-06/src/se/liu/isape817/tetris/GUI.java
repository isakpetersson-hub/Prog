package se.liu.isape817.tetris;

import javax.swing.*;
import java.awt.*;

public class GUI extends JComponent {
    // Loadar in bilden
    private final static ImageIcon IMAGE_ICON = new ImageIcon(ClassLoader.getSystemResource("images/Tetris_logo.png"));

    public static void main(String[] args) {
	// Skapar en frame och lägger till bilden till den
	final JFrame logoFrame = new JFrame("Tetris Logo");
	logoFrame.setLayout(new GridLayout(1,1));
	logoFrame.add(new GUI());
	logoFrame.setSize(IMAGE_ICON.getIconWidth(), IMAGE_ICON.getIconHeight());
	logoFrame.setVisible(true);
	try {
	    Thread.sleep(1000);
	} catch (InterruptedException e) {
	    Thread.currentThread().interrupt();
	    e.printStackTrace();
	}	logoFrame.dispose(); // Tar bort framen
    }

    @Override
    protected void paintComponent(Graphics g) {
	final Graphics2D g2d = (Graphics2D) g;
	IMAGE_ICON.paintIcon(this, g2d, 0, 0);
   }
}
