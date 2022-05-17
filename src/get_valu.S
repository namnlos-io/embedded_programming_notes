;-----------------------------------------------------------------------------;
; Get value of decimal string (16 bit unsigned)
;
; Register Variables:
;
;  Call:  X        -> Decimal strings (Space separated, EOL (<0x20) terminated)
;         var1:0   = <Don't care>
;         tmp2:0   = <Don't care> (high register must be assigned)
;
;  Result: ne,cc: Successful
;                 var1:0 = 16bit result
;                 X -> Space or EOL
;          eq,cc: No data (EOL)
;                 var1:0 = 0
;                 X -> EOL
;          eq,cs: Invalid character is detected
;                 var1:0 = <Unknown>
;                 X -> Error character
;
; Size:  37 words
; Clock: depends on the source
; Stack: 0 byte


get_valu:
		clr	var0		;var = 0;
		clr	var1		;/
		ld	tmp0, X		;Skip " "
		cpi	tmp0, ' '	;
		brcc	PC+4		;
		clc	;no data	;
		sez	;		;
		ret	;/		;
		brne	PC+3		;
		adiw	XL, 1		;
		rjmp	PC-8		;/
					;--- digit processing loop
		cpi	tmp0, ' '+1	;convert a numeric char into its value
		brcc	PC+4		;
		clz	;successful	;
		clc	;		;
		ret	;		;
		subi	tmp0, '0'	;
		brcc	PC+4		;
		sec	;error		;
		sez	;		;
		ret	;/		;
		cpi	tmp0, 10	;
		brcc	PC-4		;/
		ldi	tmp1, 17	;var = var * 10 + tmp0;
		sub	tmp2, tmp2	;
		brcc	PC+2		;
		subi	tmp2, -10	;
		lsr	tmp2		;
		ror	var1		;
		ror	var0		;
		dec	tmp1		;
		brne	PC-6		;
		add	var0, tmp0	;
		adc	var1, tmp1	;/
		adiw	XL, 1		;Next character
		ld	tmp0, X		;
		rjmp	PC-25		;/

