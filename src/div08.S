;-----------------------------------------------------------------------------:
; 8bit/8bit Unsigned Division
;
; Register Variables
;  Call:  var1 = dividend (0x00..0xff)
;         var2 = divisor (0x01..0x7f)
;         mod  = <don't care>
;         lc   = <don't care> (high register must be allocated)
;
;  Result:var1 = var1 / var2
;         var2 = <not changed>
;         mod  = var1 % var2
;         lc   = 0
;
; Size  = 11 words
; Clock = 66..74 cycles  (+ret)
; Stack = 0 byte

div08u:		clr	mod		;initialize variables
		ldi	lc,8		;  mod = 0; lc = 8;
					;---- calcurating loop
		lsl	var1		;var1 = var1 << 1;
		rol	mod		;mod = mod << 1 + carry;
		cp	mod,var2	;if (mod => var2) {
		brcs	PC+3		; mod -= var2; var1++;
		inc	var1		; }
		sub	mod,var2	;/
		dec	lc		;if (--lc > 0)
		brne	PC-7		; continue loop;
		ret

