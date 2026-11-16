package se.liu.elior637.coregame;

import se.liu.elior637.components.tile.Resource;

import javax.swing.*;
import java.awt.*;
import java.util.EnumMap;
import java.util.Map;

/**
 * A dialog that choose up for trade and robber where you can select resources the player has a then returns a Map of those resources
 */
public class ResourceSelectorDialog extends JDialog
{
    private final Map<Resource, Integer> selectedWithAmounts = new EnumMap<>(Resource.class);

    public ResourceSelectorDialog(Frame frame, Player player) {
	super(frame,frame.getTitle(), true);
	setSize(350, 350);
	setLayout(null);

	JLabel label = new JLabel("Välj resource and mängd");
	final int spacing = 20;
	label.setBounds(spacing, spacing/2, spacing*15, spacing);
	add(label);

	Resource[] resources = { Resource.LUMBER, Resource.BRICK, Resource.WOOL, Resource.GRAIN, Resource.ORE };
	Map<Resource, JSpinner> spinners = new EnumMap<>(Resource.class);

	for (int i = 0; i < resources.length; i++) {
	    Resource res = resources[i];
	    int playerHas = player.getResources().getOrDefault(res, 0);

	    JLabel labelResource = new JLabel(res.toString());
	    labelResource.setBounds(spacing, spacing*2 + i * spacing*2, spacing*5, spacing);
	    add(labelResource);

	    JLabel labelAmount = new JLabel("You have: " + playerHas);
	    labelAmount.setBounds(spacing*5, spacing*2 + i * spacing*2, spacing*5, spacing);
	    add(labelAmount);
	    JSpinner spinner = new JSpinner(new SpinnerNumberModel(0, 0, playerHas, 1));
	    spinner.setBounds(spacing*10, spacing*2 + i * spacing*2, spacing*3, spacing);
	    add(spinner);
	    spinners.put(res, spinner);
	}

	JButton confirmButton = new JButton("Confirm");
	confirmButton.setBounds(spacing*5, spacing*12, spacing*6, spacing*2);
	add(confirmButton);

	confirmButton.addActionListener(e -> {
	    for (Resource res : resources) {
		int amount = (int) spinners.get(res).getValue();
		selectedWithAmounts.put(res, amount);
	    }
	    dispose();
	});

	setLocationRelativeTo(frame);
    }

    public Map<Resource, Integer> showDialog() {
	setVisible(true);
	return selectedWithAmounts;
    }
}