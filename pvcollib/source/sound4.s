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
; From original devkit by Amy Purple, last update 2013

	.module pvclsound4

	; global from external entries / code
	.globl _snd_table

	; global from this module
	.globl _snd_play_dsound
	
	.area _CODE
    
;---------------------------------------------------------------------------------
; Here begin routines that can't be call from programs
;---------------------------------------------------------------------------------


;---------------------------------------------------------------------------------
; Here begin routines that can be call from programs
;---------------------------------------------------------------------------------
_snd_play_dsound:
		pop	de	; return address 
		pop	hl	; hl = pointer to sound table
		pop	bc	; c = delay in "donothing" loop
		push	bc
		push	hl
		push	de
		inc	bc
		push	bc
		push	de
		call	quiet	; sound_off
		pop	de
		pop	bc
loop1:
		ld	a,(hl)
		or	a
		jr	z,special
		rrca
		rrca
		rrca
		rrca
		call	volumeall
		ld	a,(hl)
		inc	hl
		ld	b,#1	; to slowdown the code
		ld	b,#1	; to slowdown the code
		ld	b,#1	; to slowdown the code
		nop		; to slowdown the code
		nop		; to slowdown the code
		nop		; to slowdown the code
		call	volumeall
		jp	loop1
special:
		inc	hl
		ld	d,(hl)
		ld	a,d
		cp	#0
		jp	nz,smallloop2
		ret
loop2:
		ld	b,#5	; to slowdown the code
		nop		; to slowdown the code
donothing1:
		djnz	donothing1
smallloop2:
		ld	b,#2	; to slowdown the code
donothing2:
		djnz	donothing2
		ld	b,#2	; to slowdown the code
		nop		; to slowdown the code
		nop		; to slowdown the code
		nop		; to slowdown the code
		ld	b,c
donothing3:
		djnz	donothing3
		dec	d
		jr	nz,loop2
		inc	hl
		jp	loop1
volumeall:	
		and	#0x0F
		or	#0x90
		out	(0xFF),a
		or	#0xB0
		out	(0xFF),a
		xor	#0x60
		out	(0xFF),a
		ld	b,c
donothing4:
		djnz	donothing4
		ret
quiet:	
		ld	bc,#0x0381
loop3:	
		ld	a,c
		out	(0xFF),a
		add	a,#0x20
		ld	c,a
		ld	a,#0
		out	(0xFF),a
		djnz	loop3
		ld	a,#0xFF
		out	(0xFF),a
		ret
