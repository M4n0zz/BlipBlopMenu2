/*

BlipBlopMenu 2 - Compatible with EN Red and Blue ONLY


Description

BlipBlopMenu 2 allows the TimOS selector to be accessed simply by pressing the Select button while in the overworld.
This eliminates the need to use a glitch item and restores the functionality of the Daycare.

In addition, three scripts are installed, providing the following effects:
#3. Repeller: When active, it permanently avoids any wild battle.
#4. Trespasser: By holding B button, all collisions are disabled.
#5. Motorbike: New! By holding A button, super speed is activated.


Prerequirements
- TimoVM's gen 1 ACE setup with a clean TimOS installation from: 
  https://glitchcity.wiki/wiki/Guides:SRAM_Glitch_ACE_Setups_(EN)

Instructions
1) 	- Installation on actual hardware or emulator: You can use TimoVM's NicknameConverter and NicknameWriter from the above page.
	- Installation on emulator with debugging features: Just copy and paste the HEX code into address $d8b5.
2) Run the code from NicknameWriter.
3) While in overworld, by pressing Select button TimOS selector pops up.
4) Confirm that everything works correctly by testing the three new scripts and then save the game.

Attention! Activating Trespasser and walking outside the game's borders will guarantee a crash. Proceed with caution!



Code:

26 0a 74 26 40 36 02 01 41 00  
11 51 c8 21 6a d6 e5 cd b5 00  
0e 80 d1 21 ff d8 cd b5 00 0e  
32 11 30 d4 cd b5 00 0e 4c 11  
11 bb cd b5 00 0e 08 11 c4 c7  
cd b5 00 0e 1f 11 92 c8 cd b5  
00 3e 05 ea e9 c6 21 03 c7 3e  
92 22 36 c8 fa 5c df fe 79 28  
30 f3 26 0a 74 26 40 36 02 01  
04 00 11 80 ff 21 11 bb cd b5  
00 0e 48 11 15 df cd b5 00 26  
00 74 21 5e d3 7e fe 0b 20 08  
36 76 21 d1 5b cd 22 39 fb cd  
15 df c3 b4 00 21 6f d3 11 a6  
d6 7a be 28 1a 01 5e d3 0a fe  
76 20 09 fa 58 d3 a7 20 0c 3e  
0b 02 3a 12 1b 7e 12 3e 6a 22  
72 21 e9 d6 cb 46 28 04 7d ea  
3c d1 cb 4e 28 03 cd 30 d4 cb  
56 28 03 cd 42 d4 0e 46 3e c3  
c9 00 fa 30 d7 a7 c0 f0 b4 cb  
4f 3e 00 28 01 3c ea 38 cd c9  
21 00 d7 af be 20 01 34 fa 5e  
d3 fe 1c c8 f0 b4 cb 47 c8 fa  
c5 cf fe 07 d0 a7 c8 cd 27 0d  
18 f3 cd a7 d6 e2 f0 b4 cb 57  
c8 f0 b8 f5 cd 2d df 21 27 df  
e5 cd e8 29 f1 e0 b8 c3 07 23  
cd 19 37 21 91 cf 36 94 af ea  
94 cf cd 51 09 0e 1f 3e 9d cd  
a1 23 21 c4 70 cd 22 39 3e 1c  
cd e6 35 06 03 21 53 ba 11 e8  
c6 e5 d5 c5 d5 cd 0f 79 51 c8  
a1 c8 98 c8 ad c8 fa 5e d3 c3  
bc 12 06 02 21 e9 d6 7e a8 77  
c9 06 01 cd 9a c8 a0 c0 af ea  
3c d1 c9 06 04 18 e9  
 
Total Bytes: 367 


Extra Scripts for BlipBlopMenu 2 for Pokemon Red and Blue EN also available here:
https://pastebin.com/LXpuWNYB

For directly patching your .sav file just use the patcher from the link below:
https://github.com/M4n0zz/BlipBlopMenu2/



************ Logic ************

Part 1 - Installer ($d8b5-$da23)
After the code is written and executed, installer manages to transfer:
- NicknameWriter from unused WRAM ($d66a) to TimOS area ($c851).
- Main payload (MSP Manipulator and OAM payloads) to unused memory ($d66a).
- Script payloads to unused memory ($d430).
- OAM DMA hijack and TimOS Loader splitted payload to SRAM Bank 2 ($bb11)
- Script pointers in TimOS selector ($c7c4).
- Script enablers inside TimOS area ($c898).

Part 2 - Map Script payload ($d66a-$d6a6)
- After installation and every time the game starts, MSP targets custom MSP payload.
- MSP payload checks for active TimOS payload ($df5c).
- If stack corrupts payload or OAM is not hijacked, it sets up the hijack ($ff80) and copies TimOS Loader payload at the top of the stack ($df15).
- After setting up OAM hijack, current active room is checked. If unused room $0b is detected, manual map reset is performed to get out of HoF. 
- TimOS Loader payload's check is executed ($df15).
- Jump to original MSP happens and the game continues to its normal state.

Part 3 - OAM DMA payloads ($d6a7-$d6e8)
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
d430-d441: Trespasser payload
d442-d461: Motorbike payload
d66a-d6a4: MSP payload
d6a5-d6a6: MSP backup address
d6a7-d6e8: OAM DMA payloads
d6e9: OAM DMA payload flags
df15-df5c: TimOS loader copied from SRAM2 $bb15

HRAM
ff80-ff83: OAM DMA hijack, copies from $bb11



Source is compiled with QuickRGBDS
https://github.com/M4n0zz/QuickRGBDS
*/


DEF CopyData EQU $00b5

SECTION "BlipBlopMenu2RB", ROM0

start:
LOAD "Installer", WRAMX[$D8B5]
;;;;;;;;;;;; Installer payload ;;;;;;;;;;;; 
Installer:
; Opens SRAM bank 2
ld h, $0a
ld [hl], h
ld h, $40
ld [hl], $02

; move NicknameWriter into TimOS
ld bc, $0041		; 65 bytes
ld de, $c851		; destination
ld hl, MSPhijack	; origin - $d66a
push hl
call CopyData

; move main payload in unused memory $d66a
ld c, DMAhijack.end - MSPhijack	; 128 bytes
pop de
ld hl, .end		; origin - $d8ff
call CopyData

; move scripts in unused memory
; copy trespassing and motorbike payloads to d430
ld c, $32		; 50 bytes
ld de, $d430		; to unused memory
call CopyData		; due to previous copyData, de points correctly

; move OAM hijack + TimOS Loader into SRAM Bank 2
ld c, $4c			; 76 bytes
ld de, $bb11		; destination
call CopyData

; move TimOS pointer
ld c, $08		; 8 bytes
ld de, $c7c4		; destination
call CopyData

; move TimOS enablers + patch
ld c, $1f		; 49 bytes
ld de, patch		; destination - $c892
call CopyData

ld a, $05		; set no of scripts
ld [$c6e9], a

ld hl, $c703		; patches timos return
ld a, $92
ld [hli], a
ld [hl], $c8

.end
ENDL

LOAD "MSP_hijack", WRAMX[$d66a]
;;;;;;;;;;;; Executed by MSP hijack ;;;;;;;;;;;;
MSPhijack:
; $d66a - executed by MapScript after loading the game
; it checks if TimOS Loader payload is present
ld a, [$df5c]		; last byte of TimOS payload, so if it gets corrupted to be rebuilt together with OAM DMA hijack
cp a, $79
jr z, .timoscheck

; if DMA is unset
di
; Opens SRAM bank 2
ld h, $0a
ld [hl], h
ld h, $40
ld [hl], $02

; copy 4 bytes to hijack dma
ld bc, $0004		; 4 bytes to be copied to ff80 earlier set to de
ld de, $ff80		; destination
ld hl, $bb11		; from SRAM 2
call CopyData		; the stored version of .OAMDMApayload. 

; copy timos loader to df15
ld c, $48		; 72 bytes
ld de, $df15		; to the top of the stack
call CopyData		; due to previous copyData, de points towards TimOS loader payload

; closes SRAM
ld h, $00
ld [hl], h

; checks and initialises map if unused room is detected in place of HoF
ld hl, $d35e		; wCurMap: 00=Pallet town, 76=HoF room, 0b=unused
ld a, [hl]
cp a, $0b		; if unused room is detected
jr nz, .endcp 	
ld [hl], $76		; set room back to HoF
ld hl, $5bd1		; run MainMenu.pressedA, as it is intended by the game
call $3922		; Bankswitch with preset bank 1

.endcp
ei

.timoscheck
call timosloader	; TimOS loader checks - $df15

.curmsp	
jp $00b4		; a safe jump address to be replaced automatically by msp manipulator
	
.end	
	
;;;;;;;;;;;; Executed by OAM DMA hijack ;;;;;;;;;;;; 
DMAhijack:
; $d6a6
; MSP Manipulator - It checks and sets Map Script Pointer after backing up the original one

; Preload addresses
ld hl, $d36f		; wCurMapScriptPtr+1
ld de, MSPhijack.curmsp+2	; Original MSP backup address+1 - $d6a5

; checks if MSP is hijacked
ld a, d			; Custom wCurMapScriptPtr high byte check
cp a, [hl]		; Compares current to custom pointer
jr z, .payload1

; room checking to bypass HoF reset
ld bc, $d35e		; wCurMap: 00=Pallet town, 76=HoF room, 0b=unused
ld a, [bc]
cp a, $76		; if wCurMap = HoF
jr nz, .backup
ld a, [$d358]		; wLetterPrintingDelayFlags
and a			; check if text is active
jr nz, .payload1	; if 0 do following
ld a, $0b		; set wCurMap to unused id
ld [bc], a

; hijacks MSP
.backup
ld a, [hl-]
ld [de], a
dec de
ld a, [hl]
ld [de], a
ld a, $6a
ld [hl+], a
ld [hl], d		; d66a

; if scriptflag's bit0=0, skip leavemealone script
.payload1		; Always ignore encounters
ld hl, DMAhijack.bits	; $d6e9
bit 0, [hl]
jr z, .payload2
ld a, l			; a!=0
ld [$d13c], a		; wNumberOfNoRandomBattleStepsLeft

; if scriptflag's bit1=0, skip trespassing script
.payload2
bit 1, [hl]
jr z, .payload3 	
call trespass		; $d430	- trespassing script

; if scriptstate's bit2=0, skip parkour script
.payload3
bit 2, [hl]
jr z, .endoam 
call motorbike		; $d442	- Motorbike script

; setting return values for OAM DMA routine
.endoam
ld c, $46
ld a, $c3
ret	


;;;;;;;;;;;; Temporary data ;;;;;;;;;;;; 
.bits
db $00			;  Flags initialisation

.end
ENDL
	  
LOAD "payloads", WRAMX[$d430]

;;;;;;;;;;;; Trespassing payload ;;;;;;;;;;;;
; -> d430 - 18 bytes
trespass:
ld a, [$d730]		; spin check [wStatusFlags5]
and a
ret nz
ldh a, [$b4] 		; If Pressed
bit 1, a 		; B Button
ld a, $00		; we cannot use xor a, since it will reset z
jr z, .skip
inc a
.skip
ld [$cd38], a 		; Loads Walk Type
ret

;;;;;;;;;;;; Motorbike payload ;;;;;;;;;;;;
; -> d442 - 24 bytes
; if walking activates bike
motorbike:
ld hl, $d700		; hl = d700
xor a
cp a, [hl]
jr nz, .checkb
inc [hl]
.checkb	
; checks for cycling road
ld a, [$d35e]
cp a, $1c
ret z

; checks button A pressed
ldh a, [$b4]
bit 0, a
ret z

; script activates at 6th moving frame and loops until it hits 0
.loop
ld a, [$cfc5]		; wWalkCounter
cp a, $07
ret nc
and a
ret z
call $0d27		; AdvancePlayerSprite
jr .loop

ENDL

;;;;;;;;;;;; OAM hijack payload ;;;;;;;;;;;;
call DMAhijack		; if initial payload changes, change address acordingly - $d6a8
ld [c], a		; setup to trigger stock OAM payload


LOAD "timos_loader", WRAMX[$df15]

;;;;;;;;;;;; TimOS Loader payload ;;;;;;;;;;;;
; timos loader - 76
; Loaded from $bb15 to $df15 automatically with map script pointer
timosloader:
; Read select button state - It automatically skips false positives like it happens in start menu
ldh a, [$b4]		; Read buttons [hJoyPressed]
bit 2, a		; Compare to select button [bit2]
ret z 			; If select not pressed, stop executing

ldh a, [$b8]		; Saves hLoadedROMBank
push af

call tempdata 		; .tempdata - $df2d

;;;;;;;;;;;; After TimOS loader ;;;;;;;;;;;;
; safedata - this part should not be overwritten while timos is active, otherwise it will crash
ld hl, hljump		; We set hl to static address to continue execution after CloseTextDisplay - $df27
push hl
call $29e8		; CloseTextDisplay

hljump:
pop af			; Restores saved rom bank
ldh [$b8], a 

jp $2307		; PlayDefaultMusic

;;;;;;;;;;;; TimOS loader ;;;;;;;;;;;;
; tempdata ($df32) - - this part can be overwritten safely while timos is active
tempdata:
call $3719		; SaveScreenTilesToBuffer1

ld hl, $cf91		; wCurPartySpecies
ld [hl], $94		; Change nickname pokemon to Abra, so we avoid random missigno names crashing the game
xor a
ld [$cf94], a		; wListMenuID

call $0951      	; StopMusic
ld c, $1f       	; Bank with sound
ld a, $9d       	; BlipBlop sound
call $23a1      	; PlayMusic

ld hl, $70c4		; To execute DisplayTextIDInit.drawTextBoxBorder after bankswitch
call $3922		; Bankswitch to bank 01

;;;;;;;;;;;; TimOS payload ;;;;;;;;;;;;
; timos - 22 bytes 
ld a, $1c		; bank number
call $35e6		; Bankswitch+16
ld b, $03		; SRAM bank number
ld hl, $ba53		; Origin/destination
ld de, $c6e8		; Destination/origin
push hl
push de
push bc
push de
call $790f		; CopyBoxToOrFromSRAM+1

ENDL

;;;;;;;;;;;; Payload pointers ;;;;;;;;;;;;
db $51, $c8, $a1, $c8, $98, $c8, $ad, $c8

LOAD "timos_patch", WRAM0[$c892]
patch:
;;;;;;;;;;;; TimOS return patch ;;;;;;;;;;;;
ld a, [$d35e]		; wCurMap
jp $12bc		; SwitchToMapRomBank

ENDL

LOAD "timos_payloads", WRAM0[$c898]
timospayloads:
;;;;;;;;;;;; Bit Enablers pointers ;;;;;;;;;;;;
; Trespasser - 2 bytes
ld b, $02

; common function - 7 bytes
common:
ld hl, DMAhijack.bits	; $d6e9
ld a, [hl]
xor a, b
ld [hl], a
ret

; Repeller - 12 bytes
ld b, $01
call common		; $c89a
and a, b
ret nz
xor a
ld [$d13c], a		; wNumberOfNoRandomBattleStepsLeft
ret

; Motorbike - 4 bytes
ld b, $04
jr common		; .common

ENDL


