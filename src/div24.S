;-----------------------------------------------------------------------------:
; 24bit/24bit Unsigned Division
;
; Register Variables
;  Call:  var1[2:0] = dividend (0x000000..0xffffff)
;         var2[2:0] = divisor (0x000001..0x7fffff)
;         mod[2:0]  = <don't care>
;         lc        = <don't care> (high register must be allocated)
;
;  Result:var1[2:0] = var1[2:0] / var2[2:0]
;         var2[2:0] = <not changed>
;         mod[2:0]  = var1[2:0] % var2[2:0]
;         lc        = 0
;
; Size  = 21 words
; Clock = 348..412 cycles (+ret)
; Stack = 0 bytes


div24u:		clr	mod0		;initialize variables
		clr	mod1		;  mod = 0;
		clr	mod2		;  lc = 24;
		ldi	lc,24		;/
					;---- calcurating loop
		lsl	var10		;var1 = var1 << 1;
		rol	var11		;
		rol	var12		;/
		rol	mod0		;mod = mod << 1 + carry;
		rol	mod1		;
		rol	mod2		;/
		cp	mod0,var20	;if (mod => var2) {
		cpc	mod1,var21	; mod -= var2; var1++;
		cpc	mod2,var22	; }
		brcs	PC+5		;
		inc	var10		;
		sub	mod0,var20	;
		sbc	mod1,var21	;
		sbc	mod2,var22	;
		dec	lc		;if (--lc > 0)
		brne	PC-15		; continue loop;
		ret

