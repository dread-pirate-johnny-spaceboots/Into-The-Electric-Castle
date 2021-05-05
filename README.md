Into the Electric Castle 
========================

![Gameplay](https://github.com/dread-pirate-johnny-spaceboots/Into-The-Electric-Castle/blob/master/ITEC.gif)

From a station on the moon of the planet Neptune you, FUTUREMAN, have been launched into a time beyond time, a space beyond space.

Betwixt stygian skies spied through the cranial vistas of psychogenesis atop wind torn ramparts that survey a thousand futures lay the electric edifice of a star tower.

"You have a task! To release yourself from this web of wisdom, this knotted maze of delerium you must enter the nuclear portals of the Electric Castle!"

How to Play
-----------
#### Hardware
* Insert cassette tape into Commodore 64 tape drive
* LOAD "ITEC",8,1
* RUN

#### Emulator
* Open & run itec.prg

Controls
--------
*This game requires two joysticks*

### Left Stick
* Directions - Guide FUTUREMANs movements
* Action - Switch between FUTUREMANs available actions (TALK, PSYCOPHASER and ???)

### Right Stick
* Action Specific
	* PSYCOPHASER
		* Directions - Guide the phaser bolts movement
		* Action - Fire a phaser bolt
	* TALK
		* Directions - Focus attention in direction
		* Action - Try speaking in focused direction
	* ???
		* Directions - ???
		* Action - ???

Project Structure
-----------------
* Main.asm
	* Program entry point and main structure
* Subroutines.asm & Macros.asm
	* Reusable code for things like checking joystick input, updating animations, moving sprites, collision detection, etc.
* MemoryMap.asm
	* Memory locations for all the things we care about
* Data.asm
	* Animation data and some constants
		
### Credit
Made in loving homage to the 1998 album [Into the Electric Castle](https://www.youtube.com/watch?v=XEnE_BR3A6Q&list=PLDp_PtuyOwCalC93Dfbj5LR-aN-WrDl2d&index=1) by [Arjen Lucassen / Ayreon](https://www.arjenlucassen.com/content/arjens-projects/ayreon/)