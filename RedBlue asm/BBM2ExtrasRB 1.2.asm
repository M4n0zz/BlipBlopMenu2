/*

BBM2 Extras - Compatible with EN Red and Blue ONLY


Description

Extra scripts for BlipBlopMenu 2 or TimOS. After installation TimOS scripts are incresed by five having the following effects:

#+1 ItemGiver: It gives any item, based on the selected internal ID.
#+2 MonGiver: It gives any pokemon, based on the selected pokedex ID.
#+3 MonEncounter: It encounters any pokemon, based on the selected pokedex ID.
#+4 TrainerEncounter: It encounters any trainer, based on the selected pokedex ID.
#+5 PokeDuplicator: It duplicates the pokemon in the first party slot to the second party slot.


Prerequirements
- TimoVM's gen 1 ACE setup with a clean TimOS installation from: 
  https://glitchcity.wiki/wiki/Guides:SRAM_Glitch_ACE_Setups_(EN)

- BlipBlopMenu 2 (optional): 
  https://pastebin.com/H7v1fP2s
  
  
Instructions
1) 	- Installation on actual hardware or emulator: You can use TimoVM's NicknameConverter and NicknameWriter from the given page.
	- Installation on emulator with debugging features: Just copy and paste the HEX code into address $d8b4.
2) Run the code from NicknameWriter.
3) Verify new scripts are intalled and work correctly.

Warning! Scripts are stored in addresses $c8c3-$c975 inside TimOS region.
Make sure you are not using this area before installation!



Code:

21 e9 c6 46 3e 05 86 77 11 c2  
c7 1c 1c 05 20 fb 0e 0a 21 d5  
d8 cd b5 00 0e b3 11 c3 c8 c3  
b5 00 db c8 24 c9 2e c9 3b c9  
5d c9 ea 97 cf cd 57 2d a7 fa  
96 cf c9 21 09 c4 11 6d cd cd  
29 38 2b 36 7f c9 cd 0f 19 3e  
ff cd c3 c8 c0 f5 ea 1e d1 cd  
cf 2f cd ce c8 3e 63 cd c3 c8  
c1 20 e5 4f cd 2e 3e 18 df cd  
0f 19 3e 97 cd c3 c8 28 01 c9  
11 1e d1 12 06 10 21 f9 4f cd  
d6 35 1a f5 cd 9e 2f cd ce c8  
3e 64 cd c3 c8 c1 20 d9 c9 cd  
fc c8 c0 4f cd 48 3e 18 f6 cd  
fc c8 c0 ea 2e cd fa 1e d1 c3  
da 32 cd 0f 19 3e 2f cd c3 c8  
c0 ea 31 d0 f5 cd 9e 35 cd ce  
c8 f1 c6 c8 ea 1e d1 3e 01 cd  
c3 c8 20 e0 18 d5 21 64 d1 2a  
77 01 2c 00 11 97 d1 2e 6b cd  
b5 00 11 b5 d2 21 c0 d2 c3 29  
38  
 
Total Bytes: 221 





Source is compiled with RGBDS

*/


SECTION "BlipBlopMenu2ExtrasRB", ROM0

start:

; ----------- Installer payload ------------ 

; increse no of scripts by 5
ld hl, $c6e9
ld b, [hl]
ld a, $05
add a, [hl]
ld [hl], a

; write pointers to the correct position
ld de, $c7c2		; destination - script #1
.pointerloop
inc e
inc e
dec b
jr nz, .pointerloop

; Copy pointers
ld c, 10			; 10 bytes: b = 0 from previous operation
ld hl, $d8d5		; origin
call $00b5			; CopyData

; Copy payloads
ld c, $b3			; 179 bytes
ld de, $c8c3		; destination
jp $00b5			; CopyData


; ----------- Payload pointers ------------

db $db, $c8, $24, $c9, $2e, $c9, $3b, $c9, $5d, $c9


selector:			; 11 bytes - common function
ld [$cf97], a 		; wMaxItemQuantity write
call $2d57 			; DisplayChooseQuantityMenu
and a, a			; if a is 0, z flag is set
ld a, [$cf96] 		; wItemQuantity read
ret

copyname:			; 13 bytes - common function
ld hl, $c409		; destination
ld de, $cd6d		; origin - wNameBuffer
call $3829			; CopyString
dec hl
ld [hl], $7f		; blank last name byte
ret

itemgiver:			; 33 bytes
call $190f 			; ClearScreen
ld a, 255			; total item IDs
call $c8c3			; .selector
ret nz 				; if B pressed, then ret
push af
ld [$d11e], a		; wPokedexNum
call $2fcf 			; GetItemName
call $c8ce			; .copyname
ld a, 99
call $c8c3			; .selector
pop bc
jr nz, itemgiver	; if B pressed go to the beginning, ln0
ld c, a				; bc = id, quantity
call $3e2e 			; GiveItem
jr itemgiver		; jp to start, ln0

pokecommon:			; 41 bytes - common function
call $190f 			; ClearScreen
ld a, 151			; total species IDs
call $c8c3			; .selector
jr z, .continue 	; if B pressed, then ret
ret
.continue
ld de, $d11e		; wPokedexNum
ld [de], a			; pokemon id is stored in wPokedexNum
ld b, $10			; select bank 16
ld hl, $4ff9 		; PokedexToIndex
call $35d6			; Bankswitch
ld a, [de]			; wPokedexNum
push af
call $2f9e			; GetMonName
call $c8ce			; .copyname
ld a, 100
call $c8c3			; .selector
pop bc
jr nz, pokecommon		; if B pressed go to the beginning, ln0
ret

dexgiver:			; 10 bytes
call $c8fc			; .pokecommon
ret nz
ld c, a				; bc = id, level
call $3e48 			; GivePokemon
jr dexgiver			; jp to start, ln0


letsgetwild:		; 5 bytes
call $c8fc			; .pokecommon
ret nz
encounter:			; 9 bytes - common function
ld [$cd2e], a		; wEnemyMonAttackMod - [wCurEnemyLevel]/[wTrainerNo]
ld a, [$d11e]		; wPokedexNum - pokemon/trainer id
jp $32da 			; InitBattleEnemyParameters+$03


hitrainer:			; 34 bytes
call $190f 			; ClearScreen
ld a, 47			; total encounter IDs
call $c8c3			; .selector
ret nz 				; if B pressed, then ret
ld [$d031], a		; wTrainerClass
push af
call $359e			; GetTrainerName
call $c8ce			; .copyname
pop af
add a, $c8
ld [$d11e], a		; id is stored in wNamedObjectIndex
ld a, 01
call $c8c3			; .selector
jr nz, hitrainer	; if B pressed go to the beginning, ln0
jr encounter


duplicator:			; 25 bytes
; transfer pokemon id
ld hl, $d164		; poke 1 id
ld a, [hli]
ld [hl], a			; hl = $d165
; transfer pokemon data
ld bc, $002c		; poke data length
ld de, $d197		; poke 2 data
ld l, $6b			; poke 1 data
call $00b5			; CopyData
; transfer pokemon nickname
ld de, $d2b5		; poke 1 nickname
ld hl, $d2c0		; poke 2 nickname
jp $3829			; CopyString

