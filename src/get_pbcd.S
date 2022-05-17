;-----------------------------------------------------------------------------;
; Get value of Packed BCD (32 bit)
;
; Register Variables:
;
;  Call:   X      -> Packed BCD (big endian, right stored)
;          len    =  Number of BCD digits
;          var3:0 =  <Don't care>
;          tmp1:0 =  <Don't care> (high register must be assigned)
;
;  Result: var3:0 = 32 bit result
;
; Size:  28 words
; Clock: 687 * len + 3 cycles (+ret)
; Stack: 0 byte

get_pbcd:
		clr	var0		;var = 0;
		clr	var1		;
		clr	var2		;
		clr	var3		;/
					;--- decimal digit loop
		clr	tmp0		;var1 *= 10;
		ldi	tmp1, 33	;
		brcc	PC+2		;
		subi	tmp0,-10	;
		lsr	tmp0		;
		ror	var3		;
		ror	var2		;
		ror	var1		;
		ror	var0		;
		dec	tmp1		;
		brne	PC-8		;/
		ld	tmp0, X+	;Pick a decimal digit
		sbrc	len, 0		;
		rjmp	PC+3		;
		sbiw	XL, 1		;
		swap	tmp0		;
		andi	tmp0, 0x0f	;/
		add	var0, tmp0	;var += decimal digit;
		adc	var1, tmp1	;
		adc	var2, tmp1	;
		adc	var3, tmp1	;/
		dec	len		;while(--len != 0)
		brne	PC-22		;/
		ret

