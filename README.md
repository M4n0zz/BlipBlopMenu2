# BlipBlopMenu2

This hack targets English Pokemon Red, Blue and Yellow versions and enables the use of TimOS environment, originally created by TimoVM from glitchcity.wiki.
By pressing Select button the menu selector appears enabling the installation/execution of custom code.
BlipBlopMenu2 comes with a small series of preinstalled scripts, giving a new feel in game's plot.


----


### Installation

There are two methods to install BlipBlopMenu2 on your current savegame.

Method 1:

**By patching an already existing .sav file.**

This is the simplest method in case you are using an emulator or actual hardware with a gameboy cart reader.
To do so, you can use one of the following files:
- [bbm2.exe](https://github.com/M4n0zz/BlipBlopMenu2/releases/download/patcher-v1.0/bbm2.exe) (Windows): Drag and drop your .sav file onto bbm.exe. Your savegame will automatically be patched.
- [bbm2.py](https://github.com/M4n0zz/BlipBlopMenu2/blob/main/bbm2.py) (Python): Download bbm2.py and run the following command: py bbm2.py [filename].sav


Method 2:

**By injecting HEX code inside the game.**

This method requires a special proceedure that allows the player to build a bootstrap from glitching the game to the point where he is allowed to manipulate game's code by using ACE.

To use this method, you can follow [TimoVM's gen 1 ACE setups](https://glitchcity.wiki/wiki/Guides:TimoVM%27s_gen_1_ACE_setups) tutorial and then follow the instructions included in the corresponding .asm file.

