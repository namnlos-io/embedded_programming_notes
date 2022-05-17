;-----------------------------------------------------------------------------;
; First-In First-Out buffer

.dseg

.equ	L_FIFO	= 64		; FIFO length can be 16,32,64,128 or 256.

Fifo:	.byte	3+N_FIFO	; Number of data, Read pointer, Write pointer and Data buffer

.cseg


write_fifo:			;Call: Y = Pointer to FIFO
	ld	r17, Y		;      r16 = Data to be stored
	cpi	r17, L_FIFO-1	;Ret:  Z=1:FIFO full (not stored)
	breq	PC+12
	inc	r17
	st	Y, r17
	ldd	r17, Y+2
	inc	r17
	std	Y+2, r17
	dec	r17
	andi	r17, L_FIFO-1
	add	YL, r17
	adc	YH, _0
	ori	r17, 1
	std	Y+3, r16
	ret

read_fifo:			;Call: Y = Pointer to FIFO
	ld	r16, Y		;Ret:  r16 = Read data, Z=1:FIFO empty
	cpi	r16, 0
	breq	PC+12
	dec	r16
	st	Y, r16
	ldd	r16, Y+1
	inc	r16
	std	Y+1, r16
	dec	r16
	andi	r16, L_FIFO-1
	add	YL, r16
	adc	YH, _0
	ori	r16, 1
	ldd	r16, Y+3
	ret

init_fifo:			;Call: Y = Pointer to FIFO
	std	Y+0, _0
	std	Y+1, _0
	std	Y+2, _0
	ret


; Note: _0 is a permanent zero register defined by user.
