;-----------------------------------------------;
; Generate/Check CRC(-CCITT)
;
; Register Variables
;  Call:  crc[1:0]    = CRC working register
;         src         = Source data to be checked
;         lc,tmp[1:0] = <don't care> (high register must be allocated)
;
;  Result:crc[1:0]    = Updated
;         src         = 0
;         lc,tmp[1:0] = broken
;
; Size  = 12 words
; Clock = 66..74 cycles (+ret)
; Stack = 0 byte
;
; To generate a CRC:
; 1. Clear CRC working register.
; 2. Process all data bytes in the block.
; 3. Process two bytes of zero.
; 4. The CRC will be found in the working register.
; 5. Append crc1 and crc0 to the block data.
;
; To check block:
; 1. Clear CRC working register.
; 2. Process all data bytes in the block and following CRCs.
; 3. The block is correct if the working register is zero.


crc:
	ldi	tmp1,0b00010000	;CRC-CCITT (2^16+2^12+2^5+2^0)
	ldi	tmp0,0b00100001	;/
	ldi	lc,8		; Loop count = 8
	lsl	src		;--- bit processing loop
	rol	crc0		;Shift-in a bit into working reg.
	rol	crc1		;/
	brcc	PC+3		;If pushed out a bit "1", divide it.
	eor	crc1,tmp1	;
	eor	crc0,tmp0	;/
	dec	lc		;Repeat until end of loop
	brne	PC-7		;/
	ret

