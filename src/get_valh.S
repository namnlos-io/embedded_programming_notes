;-----------------------------------------------------------------------------;
; Get value of hexdecimal string (32 bit)
;
; Register Variables:
;
;  Call:  X        -> Hexdecimal strings (space separated and EOL terminated)
;         var3:0   = <Don't care>
;         tmp1:0   = <Don't care> (high register must be assigned)
;
;  Result: ne,cc: Successful
;                 var3:0 = 32 bit result
;                 X -> Separater character
;          eq,cc: No data (reached EOL)
;                 var3:0 = 0
;                 X -> EOL
;          eq,cs: Invalid character is detected
;                 var3:0 = <Unknown>
;                 X -> Error character
;
; Size:  44 words
; Clock: depends on the string
; Stack: 0 byte


get_valh:
		clr	var0		;var = 0;
		clr	var1		;
		clr	var2		;
		clr	var3		;/
		ld	tmp0, X		;Skip " "
		cpi	tmp0, ' '	;
		brcc	PC+4		;
		clc	;no data	;
		sez	;		;
		ret	;/		;
		brne	PC+3		;
		adiw	XL, 1		;
		rjmp	PC-8		;/
					;--- processing loop
		cpi	tmp0, ' '+1	;convert a hexchar into its value
		brcc	PC+4		;
		clz	;successful	;
		clc	;		;
		ret	;/		;
		cpi	tmp0, 'a'	;
		brcs	PC+2		;
		subi	tmp0, 0x20	;
		subi	tmp0, '0'	;
		brcc	PC+4		;
		sec	;error		;
		sez	;		;
		ret	;/		;
		cpi	tmp0, 10	;
		brcs	PC+6		;
		subi	tmp0, 7		;
		cpi	tmp0, 10	;
		brcs	PC-7		;
		cpi	tmp0, 16	;
		brcc	PC-9		;/
		ldi	tmp1, 4		;var = var << 4 + tmp0;
		lsl	var0		;
		rol	var1		;
		rol	var2		;
		rol	var3		;
		dec	tmp1		;
		brne	PC-5		;
		or	var0, tmp0	;/
		adiw	XL, 1		;Next character
		ld	tmp0, X		;
		rjmp	PC-30		;/

