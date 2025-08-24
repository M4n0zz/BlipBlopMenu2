/*

BBM2 Extras - Compatible with EN Yellow ONLY


Description

Extra scripts for BlipBlopMenu 2 or TimOS. After installation TimOS scripts are incresed by 7 having the following effects:

#+1 ItemGiver: It gives any item, based on the selected internal ID.
#+2 MonGiver: It gives any pokemon, based on the selected pokedex ID.
#+3 MonEncounter: It encounters any pokemon, based on the selected pokedex ID.
#+4 TrainerEncounter: It encounters any trainer, based on the selected internal ID.
#+5 MoveTeacher: Teaches any move on the selected party pokemon.
#+6 PokeDuplicator: It duplicates the pokemon in the first party slot to the second party slot.
#+7 HealOnTheGo: Party heal on demand.


Prerequirements
- TimoVM's gen 1 ACE setup with a clean TimOS installation from: 
  https://glitchcity.wiki/wiki/Guides:SRAM_Glitch_ACE_Setups_(EN_Yellow)

- BlipBlopMenu 2 (optional): 
  https://pastebin.com/PhWgT7kY
  
  
Instructions
1) 	- Installation on actual hardware or emulator: You can use TimoVM's NicknameConverter and NicknameWriter from the given page.
	- Installation on emulator with debugging features: Just copy and paste the HEX code into address $d8b4.
2) Run the code from NicknameWriter.
3) Verify new scripts are installed and work correctly.

Warning! Scripts are stored in addresses $c8c3++ inside TimOS region.
Make sure you are not using this area before installation!



Code:

21 e9 c6 46 3e 07 86 77 11 c0  
c7 1c 1c 05 20 fb 0e 0e 21 d4  
d8 cd b1 00 0e f0 11 c3 c8 c3  
b1 00 e1 c8 2a c9 34 c9 41 c9  
63 c9 94 c9 ad c9 cd dd 16 c3  
1c 23 ea 96 cf cd 51 2c a7 fa  
95 cf c9 21 09 c4 11 6d cd cd  
16 38 2b 36 7f c9 cd c3 c8 3e  
ff cd c9 c8 c0 f5 ea 1d d1 cd  
c4 2e cd d4 c8 3e 63 cd c9 c8  
c1 20 e5 4f cd 3f 3e 18 df cd  
c3 c8 3e 97 cd c9 c8 28 01 c9  
11 1d d1 12 06 10 21 86 50 cd  
84 3e 1a f5 cd 93 2e cd d4 c8  
3e 64 cd c9 c8 c1 20 d9 c9 cd  
02 c9 c0 4f cd 59 3e 18 f6 cd  
02 c9 c0 ea 2e cd fa 1d d1 c3  
76 32 cd c3 c8 3e 2f cd c9 c8  
c0 ea 30 d0 f5 cd bb 35 cd d4  
c8 f1 c6 c8 ea 1d d1 3e 01 cd  
c9 c8 20 e0 18 d5 cd c3 c8 3e  
a5 cd c9 c8 c0 ea df d0 ea 1d  
d1 cd 4d 2f cd d4 c8 21 4a cf  
1e 6d cd 16 38 fa 62 d1 cd c9  
c8 20 db 3d ea 91 cf 21 c8 6b  
cd 17 39 18 cf 21 63 d1 2a 77  
01 2c 00 11 96 d1 2e 6a cd b1  
00 11 b4 d2 21 bf d2 c3 16 38  
21 2b 75 c3 4b 07  
 
Total Bytes: 286   



In case you want to go beyond the limits and get glitch items, pokemon, moves or trainers, you can input the following code afterwards:

af ea e5 c8 ea f5 c8 ea 06 c9  
ea 22 c9 ea 45 c9 ea 5b c9 ea  
67 c9 c9  

Total Bytes: 23


Source is compiled with QuickRGBDS
https://github.com/M4n0zz/QuickRGBDS

*/


SECTION "BlipBlopMenu2ExtrasY", ROM0

start:
LOAD "Installer", WRAMX[$D8B4]
; ----------- Installer payload ------------ 
Installer:
; increse no of scripts by 5
ld hl, $c6e9
ld b, [hl]
ld a, (pointers.end-pointers)/2
add a, [hl]
ld [hl], a

; write pointers to the correct position
ld de, $c7c0		; destination - script #1
.pointerloop
inc e
inc e
dec b
jr nz, .pointerloop

; Copy pointers
ld c, pointers.end-pointers	; b = 0 from previous operation
ld hl, pointers		; $d8d4	- origin
call $00b1		; CopyData

; Copy payloads
ld c, end-emptyscreen
ld de, $c8c3		; destination
jp $00b1		; CopyData


; ----------- Payload pointers ------------
pointers:           	; it automatically calculates every script's starting point offsets
db LOW(itemgiver),      HIGH(itemgiver)
db LOW(dexgiver),       HIGH(dexgiver)
db LOW(letsgetwild),    HIGH(letsgetwild)
db LOW(hitrainer),      HIGH(hitrainer)
db LOW(teachmemaster),  HIGH(teachmemaster)
db LOW(duplicator),     HIGH(duplicator)
db LOW(healer),         HIGH(healer)
.end
ENDL


LOAD "payloads", WRAM0[$c8c3]

emptyscreen:
call $16dd 		; ClearScreen
jp $231c 		; UpdateSprites

selector:		; 11 bytes - common function
ld [$cf96], a 		; wMaxItemQuantity write
call $2c51 		; DisplayChooseQuantityMenu
and a, a		; if a is 0, z flag is set
ld a, [$cf95] 		; wItemQuantity read
ret

copyname:		; 13 bytes - common function
ld hl, $c409		; destination
ld de, $cd6d		; origin - wNameBuffer
call $3816		; CopyString
dec hl
ld [hl], $7f		; blank last name byte
ret

itemgiver:		; 33 bytes
call emptyscreen
ld a, 255		; total item IDs
call selector
ret nz 			; if B pressed, then ret
push af
ld [$d11d], a		; wPokedexNum
call $2ec4 		; GetItemName
call copyname
ld a, 99
call selector
pop bc
jr nz, itemgiver	; if B pressed go to the beginning, ln0
ld c, a			; bc = id, quantity
call $3e3f 		; GiveItem
jr itemgiver		; jp to start, ln0

pokecommon:		; 41 bytes - common function
call emptyscreen
ld a, 151		; total species IDs
call selector
jr z, .continue 	; if B pressed, then ret
ret
.continue
ld de, $d11d		; wPokedexNum
ld [de], a		; pokemon id is stored in wPokedexNum
ld b, $10		; select bank 16
ld hl, $5086 		; PokedexToIndex
call $3e84		; Bankswitch
ld a, [de]		; wPokedexNum
push af
call $2e93		; GetMonName
call copyname
ld a, 100
call selector
pop bc
jr nz, pokecommon	; if B pressed go to the beginning, ln0
ret


dexgiver:		; 10 bytes
call pokecommon
ret nz
ld c, a			; bc = id, level
call $3e59 		; GivePokemon
jr dexgiver		; jp to start, ln0


letsgetwild:		; 5 bytes
call pokecommon
ret nz
encounter:		; 9 bytes - common function
ld [$cd2e], a		; wEnemyMonAttackMod - [wCurEnemyLevel]/[wTrainerNo]
ld a, [$d11d]		; wPokedexNum - pokemon/trainer id
jp $3276 		; InitBattleEnemyParameters+$03


hitrainer:		; 34 bytes
call emptyscreen
ld a, 47		; total encounter IDs
call selector
ret nz 			; if B pressed, then ret
ld [$d030], a		; wTrainerClass
push af
call $35bb		; GetTrainerName
call copyname
pop af
add a, $c8
ld [$d11d], a		; id is stored in wNamedObjectIndex
ld a, 01
call selector
jr nz, hitrainer	; if B pressed go to the beginning, ln0
jr encounter


teachmemaster:
call emptyscreen 	; ClearScreen
ld a, 165		; total move IDs
call selector
ret nz 			; if B pressed, then ret
ld [$d0df], a		; wMoveNum 
ld [$d11d], a		; wNamedObjectIndex
call $2f4d 		; GetMoveName
call copyname
ld hl, $cf4a		; destination (wStringBuffer)
ld e, $6d		; origin (wNameBuffer)
call $3816		; CopyString
ld a, [$d162]		; wPartyCount
call selector
jr nz, teachmemaster	; if B pressed go to the beginning
dec a
ld [$cf91], a	    	; wWhichPokemon
ld hl, $6bc8	    	; LearnMove
call $3917		; bankswitch bank1
jr teachmemaster


duplicator:		; 25 bytes
; transfer pokemon id
ld hl, $d163		; poke 1 id
ld a, [hli]
ld [hl], a		; hl = $d164
; transfer pokemon data
ld bc, $002c		; poke data length
ld de, $d196		; poke 2 data
ld l, $6a		; poke 1 data
call $00b1		; CopyData
; transfer pokemon nickname
ld de, $d2b4		; poke 1 nickname
ld hl, $d2bf		; poke 2 nickname
jp $3816		; CopyString


healer:			; 6 bytes
ld hl, $752b        	; HealParty
jp $074b            	; hardcoded rombankswitch 3

end:
ENDL


