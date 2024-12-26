/*

BlipBlopMenu 2 - Compatible with EN Yellow ONLY


Description

BlipBlopMenu 2 allows the TimOS selector to be accessed simply by pressing the Select button while in the overworld.
This eliminates the need to use a glitch item and restores the functionality of the Daycare.

In addition, three scripts are installed, providing the following effects:
#3. Repeller: When active, it permanently avoids any wild battle.
#4. Trespasser: By holding B button, all collisions are disabled.
#5. Motorbike: New! By holding A button, super speed is activated.


Prerequirements
- TimoVM's gen 1 ACE setup with a clean TimOS installation from: 
  https://glitchcity.wiki/wiki/Guides:SRAM_Glitch_ACE_Setups_(EN_Yellow)

Instructions
1) 	- Installation on actual hardware or emulator: You can use TimoVM's NicknameConverter and NicknameWriter from the above page.
	- Installation on emulator with debugging features: Just copy and paste the HEX code into address $d8b4.
2) Run the code from NicknameWriter.
3) While in overworld, by pressing Select button TimOS selector pops up.
4) Confirm everything works correctly by testing the three new scripts and then save the game.

Attention! Activating Trespasser and walking outside the game's borders will guarantee a crash. Proceed with caution!



Code:

3e 02 cd 99 3e 01 41 00 11 57  
c8 21 69 d6 e5 cd b1 00 0e 86  
d1 21 fb d8 cd b1 00 0e 12 11  
9c d4 cd b1 00 0e 18 1e 7a cd  
b1 00 0e 4c 11 11 bb cd b1 00  
0e 08 11 bd c7 cd b1 00 0e 19  
11 98 c8 cd b1 00 3e 05 ea e9  
c6 fa 5c df fe 7c 28 2f f3 3e  
02 cd 99 3e 01 04 00 11 80 ff  
21 11 bb cd b1 00 0e 48 11 15  
df cd b1 00 cd a9 3e 21 5d d3  
7e fe 0b 20 09 36 76 04 21 83  
5c cd 84 3e fb cd 15 df c3 ed  
d6 21 6e d3 11 a4 d6 7a be 28  
1a 01 5d d3 0a fe 76 20 09 fa  
57 d3 a7 20 0c 3e 0b 02 3a 12  
1b 7e 12 3e 69 22 72 21 ee d6  
cb 46 28 04 7d ea 3b d1 cb 4e  
28 03 cd 9c d4 cb 56 28 0a 2e  
ff af be 20 01 34 cd 7a d4 0e  
46 3e c3 c9 00 fa 2f d7 a7 c0  
f0 b4 cb 4f 3e 00 28 01 3c ea  
38 cd c9 fa 5d d3 fe 1c c8 f0  
b4 cb 47 c8 fa c4 cf fe 07 d0  
a7 c8 cd 7f 0b 18 f3 cd a5 d6  
e2 f0 b3 cb 57 c8 f0 b8 f5 cd  
2d df 21 27 df e5 cd d8 28 f1  
e0 b8 c3 6b 21 cd 0f 37 21 90  
cf 36 94 af ea 93 cf cd 33 22  
0e 1f 3e 9d cd 11 22 21 39 6f  
cd 17 39 3e 1c cd 92 3e 06 03  
21 53 ba 11 e8 c6 e5 d5 c5 d5  
cd 58 7c 57 c8 a1 c8 98 c8 ad  
c8 06 02 21 ee d6 7e a8 77 c9  
06 01 cd 9a c8 a0 c0 af ea 3b  
d1 c9 06 04 18 e9  
 
Total Bytes: 356


Extra Scripts for BlipBlopMenu 2 for Pokemon Yellow EN also available here:
https://pastebin.com/r2LNqbGp


************ Logic ************

Part 1 - Installer ($d8b4-$da17)
After the code is written and executed, installer manages to transfer:
- NicknameWriter from unused WRAM ($d669) to TimOS area ($c857).
- Main payload (MSP Manipulator and OAM payloads) to unused memory ($d669).
- Script payloads to unused memory ($d47a and $d49c).
- OAM DMA hijack and TimOS Loader splitted payload to SRAM Bank 2 ($bb11)
- Script pointers in TimOS selector ($c7bd).
- Script enablers inside TimOS area ($c898).

Part 2 - Map Script payload ($d669-$d6a4)
After installation and every time the game starts, MSP targets custom MSP payload.
- MSP payload checks for active TimOS payload ($df5c).
- If stack corrupts payload or OAM is not hijacked, it sets up the hijack ($ff80) and copies TimOS Loader payload at the top of the stack ($df15).
- After setting up OAM hijack, current active room is checked. If unused room $0b is detected, manual map reset is performed to get out of HoF. 
- TimOS Loader payload's check is executed ($df15).
- Jump to original MSP happens and the game continues to its normal state.

Part 3 - OAM DMA payloads ($d6a5-$d6ee)
After OAM DMA hijack is set, the following routine is executed in every frame.
- MapScriptPointer manipulator payload is executed, which checks if MSP is hijacked.
- If not, current room is checked. If HoF is detected, it waits for the active dialogs to close and replaces room id with an unused one.
- Afterwards, original MSP is copied to the end of this routine, and a custom one replaces it.
- OAM DMA payloads are execuded, according to the payload bits set from TimOS.
- Proper registers are set and OAM DMA routine continues its normal execution.

Part 4 - TimOS Loader payload ($df15)
- In every non moving overworld frame, Select button is checked (hJoyPressed - $ffb3).
- If the above checks are true, TimOS Loader is triggered, setting up some environment values and launching TimOS payload.
- After TimOS closes, execution continues from a payload closer to the top of the stack, so to avoid any potential crash caused by a stack overflow.
- In case stack overflows and destrys TimOS payload, the check in MS payload rebuilts it during the next overworld frame. 



************ Memory map ************

SRAM2
bb11-bb14: OAM DMA hijack payload
bb15-bb5c: TimOS Loader

WRAM0
d47a-d491: Motorbike payload
d49c-d4ad: Trespasser payload
d669-d6a2: MSP payload
d6a3-d6a4: MSP backup address
d6a5-d6ed: OAM DMA payloads
d6ee: OAM DMA payload flags
df15-df5c: TimOS loader copied from SRAM2 $bb15

HRAM
ff80-ff83: OAM DMA hijack, copies from $bb11



Source to be compiled with RGBDS
*/


SECTION "BlipBlopMenu2Y", ROM0

start:

;;;;;;;;;;;; Installer payload ;;;;;;;;;;;; 

ld a, $02
call $3e99			; Open SRAM2

; move NicknameWriter into TimOS
ld bc, $0041		; 65 bytes
ld de, $c857		; destination
ld hl, $d669		; origin
push hl
call $00b1			; CopyData

; move main payload in unused memory $d669
ld c, $86			; 134 bytes
pop de
ld hl, $d8fb		; origin
call $00b1			; CopyData

; move scripts in unused memory
; copy trespassing to d49c
ld c, $12			; 18 bytes
ld de, $d49c		; to unused memory
call $00b1			; CopyData - due to previous copyData, de points correctly
; copy motorbike to d47a
ld c, $18			; 24 bytes
ld e, $7a			; to unused memory
call $00b1			; CopyData - due to previous copyData, de points correctly

; move OAM hijack + TimOS Loader into SRAM Bank 2
ld c, $4c			; 76 bytes
ld de, $bb11		; destination
call $00b1			; CopyData

; move TimOS pointer
ld c, $08			; 8 bytes
ld de, $c7bd		; destination
call $00b1			; CopyData

; move TimOS enablers
ld c, $19			; 25 bytes
ld de, $c898		; destination
call $00b1			; CopyData

ld a, $05			; set no of scripts
ld [$c6e9], a


;;;;;;;;;;;; Executed by MSP hijack ;;;;;;;;;;;;

; $d669 - executed by MapScript after loading the game
; it checks if TimOS Loader payload is present
ld a, [$df5c]		; last byte of TimOS payload, so if it gets corrupted to be rebuilt together with OAM DMA hijack
cp a, $7c
jr z, .timoscheck

; if DMA is unset
di
; opens SRAM2
ld a, $02
call $3e99			; OpenSRAM to bank 02

; copy 4 bytes to hijack dma
ld bc, $0004		; 4 bytes to be copied to ff80 earlier set to de
ld de, $ff80		; destination
ld hl, $bb11		; from SRAM 2
call $00b1			; CopyData - the stored version of .OAMDMApayload. 

; copy timos loader to df15
ld c, $48			; 72 bytes
ld de, $df15		; to the top of the stack
call $00b1			; CopyData - due to previous copyData, de points towards TimOS loader payload

; closes SRAM
call $3ea9			; CloseSRAM

; checks and initialises map if unused room is detected in place of HoF
ld hl, $d35d		; wCurMap: 00=Pallet town, 76=HoF room, 0b=unused
ld a, [hl]
cp a, $0b			; if unused room is detected
jr nz, .endcp 	
ld [hl], $76		; set room back to HoF
inc b				; bank 1 : b=0 from previous use
ld hl, $5c83		; run MainMenu.pressedA, as it is intended by the game
call $3e84			; Bankswitch

.endcp
ei

.timoscheck
call $df15			; TimOS loader checks

.curmsp	
jp $d6ed			; a safe address to be replaced automatically by msp manipulator
	
	
	
;;;;;;;;;;;; Executed by OAM DMA hijack ;;;;;;;;;;;; 

; $d6a5
; MSP Manipulator - It checks and sets Map Script Pointer after backing up the original one

; Preload addresses
ld hl, $d36e		; wCurMapScriptPtr+1
ld de, $d6a4		; Original MSP backup address+1

; checks if MSP is hijacked
ld a, d				; Custom wCurMapScriptPtr high byte check
cp a, [hl]			; Compares current to custom pointer
jr z, .payload1

; room checking to bypass HoF reset
ld bc, $d35d		; wCurMap: 00=Pallet town, 76=HoF room, 0b=unused
ld a, [bc]
cp a, $76			; if wCurMap = HoF
jr nz, .backup
ld a, [$d357]		; wLetterPrintingDelayFlags
and a				; check if text is active
jr nz, .payload1	; if 0 do following
ld a, $0b			; set wCurMap to unused id
ld [bc], a

; hijacks MSP
.backup
ld a, [hl-]
ld [de], a
dec de
ld a, [hl]
ld [de], a
ld a, $69
ld [hl+], a
ld [hl], d			; d669

; if scriptflag's bit0=0, skip leavemealone script
.payload1			; Always ignore encounters
ld hl, $d6ee
bit 0, [hl]
jr z, .payload2
ld a, l			 	; a!=0
ld [$d13b], a		; wNumberOfNoRandomBattleStepsLeft

; if scriptflag's bit1=0, skip trespassing script
.payload2
bit 1, [hl]
jr z, .payload3 	
call $d49c			; trespassing script

; if scriptstate's bit2=0, skip parkour script
.payload3
bit 2, [hl]
jr z, .endoam 
; if walking activates bike
ld l, $ff			; hl = d6ff [wWalkBikeSurfState]
xor a
cp a, [hl]
jr nz, .checkb
inc [hl]
.checkb	
call $d47a			; Motorbike script

; setting return values for OAM DMA routine
.endoam
ld c, $46
ld a, $c3
ret	


;;;;;;;;;;;; Temporary data ;;;;;;;;;;;; 
db $00				;  Flags initialisation



;;;;;;;;;;;; Trespassing payload ;;;;;;;;;;;;
; -> d49c - 18 bytes
ld a, [$d72f]		; spin check
and a
ret nz
ldh a, [$b4] 		; If Pressed
bit 1, a 			; B Button
ld a, $00			; we cannot use xor a, since it will reset z
jr z, .trespass
inc a
.trespass
ld [$cd38], a 		; Loads Walk Type
ret

;;;;;;;;;;;; Splitted Motorbike payload ;;;;;;;;;;;;
; -> d47a - 24 bytes
; checks for cycling road
ld a, [$d35d]
cp a, $1c
ret z

; checks button A pressed
ldh a, [$b4]
bit 0, a
ret z

; script activates at 6th moving frame and loops until it hits 0
.loop
ld a, [$cfc4]		; wWalkCounter
cp a, $07
ret nc
and a
ret z
call $0b7f			; AdvancePlayerSprite
jr .loop



;;;;;;;;;;;; OAM hijack payload ;;;;;;;;;;;;
call $d6a5			; if initial payload changes, change address acordingly
ld [c], a			; setup to trigger stock OAM payload


;;;;;;;;;;;; TimOS Loader payload ;;;;;;;;;;;;
; timos loader - 74
; Loaded from $bb15 to $df15 automatically with map script pointer

; Read select button state - It automatically skips false positives like it happens in start menu
ldh a, [$b3]		; Read buttons [hJoyPressed]
bit 2, a			; Compare to select button [bit2]
ret z 				; If select not pressed, stop executing

ldh a, [$b8]		; Saves hLoadedROMBank
push af

call $df2d 			; .tempdata

;;;;;;;;;;;; After TimOS loader ;;;;;;;;;;;;
; safedata - this part should not be overwritten while timos is active, otherwise it will crash
ld hl, $df27		; We set hl to static address to continue execution after CloseTextDisplay
push hl
call $28d8			; CloseTextDisplay

pop af				; Restores saved rom bank
ldh [$b8], a 

jp $216b			; PlayDefaultMusic

;;;;;;;;;;;; TimOS loader ;;;;;;;;;;;;
; tempdata ($df32) - - this part can be overwritten safely while timos is active
call $370f			; SaveScreenTilesToBuffer1

ld hl, $cf90		; wCurPartySpecies
ld [hl], $94		; Change nickname pokemon to Abra, so we avoid random missigno names crashing the game
xor a
ld [$cf93], a		; wListMenuID

call $2233      	; StopMusic
ld c, $1f       	; Bank with sound
ld a, $9d       	; BlipBlop sound
call $2211      	; PlayMusic

ld hl, $6f39		; To execute DisplayTextIDInit.drawTextBoxBorder after bankswitch
call $3917			; Bankswitch hardcoded to bank 1

;;;;;;;;;;;; TimOS payload ;;;;;;;;;;;;
; timos - 20 bytes 
ld a, $1c			; ROM bank number
call $3e92			; Bankswitch+14
ld b, $03			; SRAM bank number
ld hl, $ba53		; Origin/destination
ld de, $c6e8		; Destination/origin
push hl
push de
push bc
push de
call $7c58			; CopyBoxToOrFromSRAM+1



;;;;;;;;;;;; Payload pointers ;;;;;;;;;;;;
db $57, $c8, $a1, $c8, $98, $c8, $ad, $c8


;;;;;;;;;;;; Bit Enablers pointers ;;;;;;;;;;;;
; Trespasser - 2 bytes
ld b, $02

; common function - 7 bytes
.common
ld hl, $d6ee
ld a, [hl]
xor a, b
ld [hl], a
ret

; Repeller - 12 bytes
ld b, $01
call $c89a		; .common
and a, b
ret nz
xor a
ld [$d13b], a		; wNumberOfNoRandomBattleStepsLeft
ret

; Motorbike - 4 bytes
ld b, $04
jr .common		; .common

