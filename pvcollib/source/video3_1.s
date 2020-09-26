;---------------------------------------------------------------------------------
;
;	vdpwrite
;	Definition:
;	To start writing at a destination (DE) offset in VRAM.
;	Note:
;	A further optimization might be to make this routine a software interupt in the cart header
;
;---------------------------------------------------------------------------------

	.module pvclvideo3_1
	
	; global from external entries / code
	
	; global from this module
	.globl vdpwrite
	
	.area  _CODE
		
;---------------------------------------------------------------------------------
; Here begin routines that can't be call from programs
;---------------------------------------------------------------------------------
vdpwrite:
    ld      c,#0xbf
    out     (c),e
    set     6,d
    out     (c),d
	ret
	