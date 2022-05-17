;-----------------------------------------------------------------------------:
; 32bit/32bit Unsigned Division
;
; Register Variables
;  Call:  var1[3:0] = dividend (0x00000000..0xffffffff)
;         var2[3:0] = divisor (0x00000001..0x7fffffff)
;         mod[3:0]  = <don't care>
;         lc        = <don't care> (high register must be allocated)
;
;  Result:var1[3:0] = var1[3:0] / var2[3:0]
;         var2[3:0] = <not changed>
;         mod[3:0]  = var1[3:0] % var2[3:0]
;         lc        = 0
;
; Size  = 26 words
; Clock = 549..677 cycles (+ret)
; Stack = 0 bytes


div32u:		clr	mod0		;initialize variables
		clr	mod1		;  mod = 0;
		clr	mod2		;  lc = 32;
		clr	mod3		;
		ldi	lc,32		;/
					;---- calcurating loop
		lsl	var10		;var1 = var1 << 1;
		rol	var11		;
		rol	var12		;
		rol	var13		;/
		rol	mod0		;mod = mod << 1 + carry;
		rol	mod1		;
		rol	mod2		;
		rol	mod3		;/
		cp	mod0,var20	;if (mod => var2) {
		cpc	mod1,var21	; mod -= var2; var1++;
		cpc	mod2,var22	; }
		cpc	mod3,var23	;
		brcs	PC+6		;
		inc	var10		;
		sub	mod0,var20	;
		sbc	mod1,var21	;
		sbc	mod2,var22	;
		sbc	mod3,var23	;/
		dec	lc		;if (--lc > 0)
		brne	PC-19		; continue loop;
		ret

