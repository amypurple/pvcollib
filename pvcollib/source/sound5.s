;---------------------------------------------------------------------------------
;
;	Copyright (C) 2018-2019
;		Alekmaul 
;
;	This software is provided 'as-is', without any express or implied
;	warranty.  In no event will the authors be held liable for any
;	damages arising from the use of this software.
;
;	Permission is granted to anyone to use this software for any
;	purpose, including commercial applications, and to alter it and
;	redistribute it freely, subject to the following restrictions:
;
;	1.	The origin of this software must not be misrepresented; you
;		must not claim that you wrote the original software. If you use
;		this software in a product, an acknowledgment in the product
;		documentation would be appreciated but is not required.
;	2.	Altered source versions must be plainly marked as such, and
;		must not be misrepresented as being the original software.
;	3.	This notice may not be removed or altered from any source
;		distribution.
;
;---------------------------------------------------------------------------------
; Music routines by Amy Purple, last update 2013
	.module pvclsound5

	; global from external entries / code

	; global from this module
    .globl  _snd_nextmusic
    .globl  _snd_startmusic
    .globl  _snd_stopmusic
    .globl  _snd_updatemusic

    .area _DATA
    
pointer:
    .ds 2
counter:
    .ds 2
	
	.area _CODE
    
;---------------------------------------------------------------------------------
; Here begin routines that can't be call from programs
;---------------------------------------------------------------------------------

nomusic_track:
    .dw 0

;---------------------------------------------------------------------------------
; Here begin routines that can be call from programs
;---------------------------------------------------------------------------------

_snd_nextmusic:
    pop bc
    pop de
    push de
    push bc
snd_nextmusic:
    ld hl,#pointer
    ld (hl),e
    inc hl
    ld (hl),d
    ret
_snd_startmusic:
    pop bc
    pop de
    push de
    push bc
    call snd_nextmusic
    jp trigger_sounds
_snd_updatemusic:
    ld hl,#counter+1
    ld a,(hl)
    dec hl
    or a
    jr nz,update_counter
    ld a,(hl)
    or a
    jp z,trigger_sounds
update_counter:
    ld a,(hl)
    sub #1
    ld (hl),a
    inc hl
    ld a,(hl)
    sbc a,#0
    ld (hl),a
    ret
trigger_sounds:
    ld hl,#pointer
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    xor a
    ;; CASE == 0000 -> it's END OF DATA marker
    sub d
    jr nz, trigger_sounds1
    sub e
    ret z
trigger_sounds1:
    ;; CASE >= 8000 -> it's a new pointer
    bit 7,d
    jr z, trigger_sounds2
    ld hl,#pointer
    ld (hl),e
    inc hl
    ld (hl),d
    jr trigger_sounds
trigger_sounds2:
    ;; counter = (uint) data[pointer];
    dec de
    ld hl,#counter
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#pointer
    ld e,(hl)
    inc hl
    ld d,(hl)

    call snd_stopmusic
    
    ex de,hl
    ;; hl = address;
    inc hl
    inc hl
    ld a,(hl)
    rlca
    rlca
    and #3
    inc a
    ld b,a
    ;; b is element of {1,2,3,4}
trigger_sounds3:
    ld a,(hl)
    inc hl
    and #0x3f
    ;; MISSING : start sound #a
    
    push bc
    push de
    push hl
    
    push af
    sub #1
    ld c,a
    ld b,#0
    ld hl,(#0x7020)
    rlc c
    rlc c
    add hl,bc
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    pop hl ;; de = @ Sound Area, hl = @ sound data
    ld a,(hl)
    inc hl
    ld c,a
    and #0xc0
    ld b,a
    pop af
    and #0x3f
    or b
    ld (de),a
    inc de
    inc de
    inc de ;; de = @ Sound Area + 3
    
    ld a,c
    bit 5,a
    jr z, trigger_sounds4
    inc de
    inc de
    and #0x1f
    ld (de),a
    jr trigger_sounds8    

trigger_sounds4:
    cp #0x02 ; case noise with volumen sweep
    jr nz, trigger_sounds5
    dec hl
trigger_sounds5:
    ldi
    ldi
    ldi
    bit 0,a
    jr z,trigger_sounds9
    ldi
    ldi
trigger_sounds6:
    bit 1,a
    jr z,trigger_sounds7
    ldi
    ldi
    dec de
    dec de
trigger_sounds7:
    dec de
    dec de
    dec de
    dec de
trigger_sounds8:
    dec de
    dec de
    ex de,hl
    ld (hl),d
    dec hl
    ld (hl),e
    ex de, hl

    pop hl
    pop de
    pop bc
    
    djnz trigger_sounds3
    ex de,hl
    ;; update pointer
    ld hl,#pointer
    ld (hl),e
    inc hl
    ld (hl),d

    jp 0x0295 ;; NOT AN APPROVED COLECO BIOS ENTRY, BUT DONE ANYWAY

trigger_sounds9:
    inc de
    inc de
    jr trigger_sounds6

_snd_stopmusic:
    ld hl,#pointer
    ld de,#nomusic_track
    ld (hl),e
    inc hl
    ld (hl),d
    ; inc hl
    ; xor a
    ; ld (hl),a
    ; inc hl
    ; ld (hl),a    
    call snd_stopmusic
    jp 0x0295 ;; NOT AN APPROVED COLECO BIOS ENTRY, BUT DONE ANYWAY

snd_stopmusic:
    ;; Inactive All 4 Sound Areas
    ld b,#4
    xor a
    ld hl,#0x702b ; Address for the 1st Sound Area
snd_stopmusic1:
    ld (hl),#0xff
    inc hl
    inc hl
    inc hl
    inc hl
    ld (hl),#0xf0
    inc hl
    ld (hl),a
    inc hl
    inc hl
    ld (hl),a
    inc hl
    ld (hl),a
    inc hl
    inc hl
    djnz snd_stopmusic1
    ret
    
; _+_ WHAT IS THIS ? _+_
;
; Hello,
; I've created this routine a long time ago.
; I wanted a way to play sounds (music parts) in sequences to create elaborated musics.
; And to avoid adding extra code, each music part is a sound data in the CV bios sounds table.
; Code your music to be played in the first 4 CV sound areas in RAM, that makes the music to play in the background.
;
; First, initialize by calling snd_stopmusic() which makes sure no attempt to play invalid music sequence starts.
; Second, add snd_updatemusic() in the nmi() routine.
; Third, create a sequence of sounds to trigger from the CV sounds table according to MUSIC TABLE format.
; Fourth, use snd_startmusic(sequence) whenever you want the music to start.
; Fifth, call snd_stopmusic() whenever you want the music to stop.
; Sixth, use snd_nextmusic(next_sequence) only to let the previous music continue a little before it changes to the next_sequence.
;
; MUSIC TABLE
; ----------
; DURATION, [NBR-1 sounds to start | sound_no in 6 bits ], sound_no2*, sound_no2*, sound_no2*
; * these sound_no are not essential, it depends on the value of NBR.
; IF DURATION = 0000, END MARKER
; IF DURATION > 7FFF, SET MUSIC TABLE POINTER TO THIS NEW LOCATION TO CONTINUE
