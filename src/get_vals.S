;-----------------------------------------------------------------------------;
; Get value of decimal string (32 bit signed)
;
; Register Variables:
;
;  Call:  X       -> Decimal strings (Space separated, EOL (<0x20) terminated)
;         var3:0  = <Don't care>
;         tmp2:0  = <Don't care> (high register must be assigned)
;
;  Result: ne,cc: Successful
;                 var3:0 = 32 bit result
;                 X -> Space or EOL
;          eq,cc: No data (EOL)
;                 var3:0 = 0
;                 X -> EOL
;          eq,cs: Invalid character is detected
;                 var3:0 = Unknown
;                 X -> Error character
;
; Size:  56 words
; Clock: depends on the source
; Stack: 0 byte


get_vals:
		clr	var0		;var = 0;
		clr	var1		;
		clr	var2		;
		clr	var3		;/
		clt			;Skip " " and "-"
		ld	tmp0, X		;
		cpi	tmp0, ' '	;
		brcc	PC+4		;
		clc	;no data	;
		sez	;		;
		ret	;/		;
		breq	PC+4		;
		cpi	tmp0, '-'	;
		brne	PC+4		;
		set			;
		adiw	XL, 1		;
		rjmp	PC-11		;/
					;--- digit processing loop
		cpi	tmp0, ' '+1	;convert a numeric char into its value
		brcc	PC+13		;
		brtc	PC+9		;
		com	var0		;
		com	var1		;
		com	var2		;
		com	var3		;
		adc	var0, tmp1	;
		adc	var1, tmp1	;
		adc	var2, tmp1	;
		adc	var3, tmp1	;
		clz	;Successful	;
		clc	;		;
		ret	;/		;
		subi	tmp0, '0'	;
		brcc	PC+4		;
		sec	;Error		;
		sez	;		;
		ret	;/		;
		cpi	tmp0, 10	;
		brcc	PC-4		;/
		ldi	tmp1, 33	;var = var * 10 + tmp0;
		sub	tmp2, tmp2	;
		brcc	PC+2		;
		subi	tmp2, -10	;
		lsr	tmp2		;
		ror	var3		;
		ror	var2		;
		ror	var1		;
		ror	var0		;
		dec	tmp1		;
		brne	PC-8		;
		add	var0, tmp0	;
		adc	var1, tmp1	;
		adc	var2, tmp1	;
		adc	var3, tmp1	;/
		adiw	XL, 1		;Next character
		ld	tmp0, X		;
		rjmp	PC-38		;/

