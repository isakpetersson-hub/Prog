# Car City Boom 3

En idé är att efterlikna goat simulator där det inte finns något tydligt mål. Man gör saker och det leder till unlocks som man kan använda (som i goat simulator eller alla legospel) t.ex drunk mode, big car eller flying car.  

# LORE
Your goal as the player (John Boom) is to find all the engine parts to the "Boom-engine" which will make you extremly cool. Throuout your journey you will find items and  collect boomcoins.  

# Milestone 1 #40
- Main character done
- Item pickup
- Item wizard (automation)
- Animation system (animaitonPlayer and -Tree and load from json)

# Milestone 2 #41
- City done
- Shop NPC system
- Money system

# Milestone 3 #42
- Game goal, collect all the "Boom-engine" parts (lore) (or something else) <- number UI system
- Dialouge system

# Milestone 4 #43
- Tutorials for creating items, Npc, shops and more
- Essential terrain assets for building the world

# Milestone X
- **Steam integration**

## Spreadsheet
[spreadsheet](https://docs.google.com/spreadsheets/d/14mtulKJSoJHasO_fVGd-izaA_5CYlCLxygMKNdmAqFo/edit?usp=sharing)

## Controls
### Car
- WASD - Drive and turn
- WASDQE - Rotate in air
- Space - Brake
- F - Exit car
- J - Jump
- K - Kickflip left
- L - Kickflip right
- Tab - Open inventory
- Arrows - Tilt camera

### Inventory
- If hovering on object:
	- 1234 - switch inventory slot with hovered object
- if not hovering on object:
	- 1234 - Drop item in slot
- Tab - Close inventory
- Left click (on item) - pickup (to empty slot)
- Left click (on hotbar) - drop item
- Right drag - move item

### Player (John Boom)
- WASD - walk
- Mouse - look around
- Shift - Run
- Space - Jump
- F - interact
- Q - Drop item
- E - empty hand
- Tab - open/close wallet
- 1234 - Select hotbar slot

## Systems
### Car 
Är en vehicleBody3D med 4 hjul. W, S sätter engine_force till 1 och -1 * en variabel. A, D sätter streering på samma sätt. 

### Player
Är i grunden en CharacterBody3D, moving with wasd and gravity.  
Animaions with IK.  
Arms: animated  
Feet: math + code [desmos](https://www.desmos.com/calculator/ycrvpv2dx2?lang=sv-SE)  


## Modifier list
(Ska vara) Är en lista med chekboxes för olika saker man kan aktivera. Förhopningsvis kan det vara en egen scen så att man kan ändra i den i både menyn och in game.  
