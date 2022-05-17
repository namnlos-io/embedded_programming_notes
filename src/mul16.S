;-----------------------------------------------------------------------------:
; 16bit x 16bit unsigned multiply
;
; Register Variables
;  Call:  var1[1:0] = 16bit multiplicand
;         var1[3:2] = <don't care>
;         var2[1:0] = 16bit multiplier
;         lc        = <don't care> (high register must be allocated)
;
;  Result:var1[3:0] = 32bit result of var1[1:0] * var2[1:0]
;         var2[1:0] = <not changed>
;         lc        = 0
;
; Size  = 13 words
; Clock = 157..172 cycles (+ret)
; Stack = 0 byte


mul16u:		sub	var13,var13	;initialize variables
		sub	var12,var12	;
		ldi	lc,17		; lc = 17;
		brcc	PC+3		;---- calcurating loop
		add	var12,var20	;
		adc	var13,var21	;
		ror	var13		;
		ror	var12		;
		ror	var11		;
		ror	var10		;
		dec	lc		;if (--lc > 0)
		brne	PC-8		; continue loop;
		ret



mul16s:		clr	lc		; Optional fast signed helper
		clr	var12		;  process with fast unsinged routine
		tst	var11
		brpl	PC+6
		inc	var12
		com	var10
		com	var11
		adc	var10,lc
		adc	var11,lc
		tst	var21
		brpl	PC+6
		inc	var12
		com	var20
		com	var21
		adc	var20,lc
		adc	var21,lc
		bst	var12,0
		rcall	mul16u
		brtc	PC+9
		com	var10
		com	var11
		com	var12
		com	var13
		adc	var10,lc
		adc	var11,lc
		adc	var12,lc
		adc	var13,lc
		ret

