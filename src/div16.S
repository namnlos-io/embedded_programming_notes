;-----------------------------------------------------------------------------:
; 16bit/16bit Unsigned Division
;
; Register Variables
;  Call:  var1[1:0] = dividend (0x0000..0xffff)
;         var2[1:0] = divisor (0x0001..0x7fff)
;         mod[1:0]  = <don't care>
;         lc        = <don't care> (high register must be allocated)
;
;  Result:var1[1:0] = var1[1:0] / var2[1:0]
;         var2[1:0] = <not changed>
;         mod[1:0]  = var1[1:0] % var2[1:0]
;         lc        = 0
;
; Size  = 16 words
; Clock = 179..211 cycles (+ret)
; Stack = 0 byte


div16u:		clr	mod0		;initialize variables
		clr	mod1		;  mod = 0;
		ldi	lc,16		;  lc = 16;
					;---- calcurating loop
		lsl	var10		;var1 = var1 << 1;
		rol	var11		;/
		rol	mod0		;mod = mod << 1 + carry;
		rol	mod1		;/
		cp	mod0,var20	;if (mod => var2) {
		cpc	mod1,var21	; mod -= var2; var1++;
		brcs	PC+4		; }
		inc	var10		;
		sub	mod0,var20	;
		sbc	mod1,var21	;/
		dec	lc		;if (--lc > 0)
		brne	PC-11		; continue loop;
		ret

