# BlipBlopMenu2

This mod menu targets original Pokemon Red, Blue and Yellow English versions and enables the activation of TimOS environment, originally created by TimoVM from glitchcity.wiki.

By pressing Select button the menu selector appears enabling the installation/execution of custom code, without altering any of the game's functionality.

BlipBlopMenu2 comes with a series of preinstalled scripts, giving a new feel in game's plot.
<ol> 
<li> TimoVM's RAM Writer: It allows the direct manipulation of any RAM value.</li>
<li> TimoVM's Nickname Writer: You can run any compatible nickname code provided by <a href="https://glitchcity.wiki/wiki/Guides:Nickname_Writer_Codes">here</a>.</li>
<li> Repeller: When active, it permanently repels any wild pokemon.</li>
<li> Trespasser: By holding B button, all collisions are disabled.</li>
<li> Motorbike: By holding A button, super bike speed is activated.</li>
<li> ItemGiver: It gives any item, based on the selected internal ID.</li>
<li> MonGiver: It gives any pokemon, based on the selected pokedex ID.</li>
<li> MonEncounter: It encounters any pokemon, based on the selected pokedex ID.</li>
<li> TrainerEncounter: It encounters any trainer, based on the selected internal ID.</li>
<li> PokeTeacher: Teaches any move on the selected party pokemon.</li>
<li> PokeDuplicator: It duplicates the pokemon in the first party slot to the second party slot.</li>
<li> PokeHealer: Party heal on demand.</li>
</ol>

----


### Installation

There are two methods to install BlipBlopMenu2 on your current savegame.

Method 1 (Easy):

**By patching an already existing .sav file.**

This is the simplest method in case you are using an emulator or actual Gameboy hardware with a gameboy cart reader.
To do so, you can use one of the following files:
- [bbm2.exe](https://github.com/M4n0zz/BlipBlopMenu2/releases/download/patcher-v1.1/bbm2.exe) (Windows): Drag and drop your .sav file onto bbm.exe. Your savegame will automatically be patched.
- [bbm2.py](https://github.com/M4n0zz/BlipBlopMenu2/releases/download/patcher-v1.1/bbm2.py) (Python): Download bbm2.py and run the following command: py bbm2.py [filename].sav



Method 2 (Hardcore):

**By injecting HEX code inside the game.**

This method is compatible with both VC and non VC versions and requires a special procedure which allows the player to build a bootstrap from glitching the game to the point where he is allowed to manipulate game's code by using ACE.

To use this method, you need to perform the following steps:
- [TimoVM's gen 1 ACE setups](https://glitchcity.wiki/wiki/Guides:TimoVM%27s_gen_1_ACE_setups): Follow this tutorial up to the point where you have a functional TimOS environment.
- [Assembly Files](https://github.com/M4n0zz/BlipBlopMenu2/tree/main/Assembly%20files): Follow the included instructions to install hex codes using Nickname Writer in the correct order (first file 1, then file 2).


In case you want to go beyond the limits and get glitch items, pokemon, moves or trainers, you can input the 23 byte code provided inside the corresponding "2.BlipBlopMenuExtras.asm" file.

