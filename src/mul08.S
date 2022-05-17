;-----------------------------------------------------------------------------:
; 8bit x 8bit unsigned multiply
;
; Register variables:
;  Call:  var10 = 8bit multiplicand
;         var11 = <don't care>
;         var20 = 8bit multiplier
;         lc    = <don't care> (high register must be allocated)
;
;  Result:var1[1:0] = 16bit result of var10 * var20
;         var20     = <not changed>
;         lc        = 0
;
; Size  = 9 words
; Clock = 64 cycles (+ret)
; Stack = 0 byte


mul08u:		sub	var11,var11	;initialize variables
		ldi	lc,9		; lc = 9;
		brcc	PC+2		;---- calcurating loop
		add	var11,var20	;
		ror	var11		;
		ror	var10		;
		dec	lc		;if (--lc > 0)
		brne	PC-5		; continue loop;
		ret



mul08s:		clr	lc		; Optional fast signed helper
		tst	var10		;  process with fast unsinged routine
		brpl	PC+3
		inc	lc
		neg	var10
		tst	var20
		brpl	PC+3
		inc	lc
		neg	var20
		bst	lc,0
		rcall	mul08u
		brtc	PC+5
		com	var10
		com	var11
		adc	var10,lc
		adc	var11,lc
		ret

