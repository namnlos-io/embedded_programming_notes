;-----------------------------------------------------------------------------;
; 32bit x 32bit unsigned multiply
;
; Register Variables
;  Call:  var1[3:0] = 32bit multiplicand
;         var1[7:4] = <don't care>
;         var2[3:0] = 32bit multiplier
;         lc        = <don't care> (high register must be allocated)
;
;  Result:var1[7:0] = 64bit result of var1[3:0] * var2[3:0]
;         var2[3:0] = <not changed>
;         lc        = 0
;
; Size  = 21 words
; Clock = 436..532 cycles (+ret)
; Stack = 0 byte


mul32u:		sub	var17,var17	;initialize variables
		sub	var16,var16	;
		sub	var15,var15	;
		sub	var14,var14	;
		ldi	lc,33		; lc = 33;
		brcc	PC+5		;---- calcurating loop
		add	var14,var20	;
		adc	var15,var21	;
		adc	var16,var22	;
		adc	var17,var23	;
		ror	var17		;
		ror	var16		;
		ror	var15		;
		ror	var14		;
		ror	var13		;
		ror	var12		;
		ror	var11		;
		ror	var10		;
		dec	lc		;if (--lc > 0)
		brne	PC-14		; continue loop;
		ret



mul32s:		clr	lc		; Optional fast signed helper
		clr	var14		;  process with fast unsinged routine
		tst	var13
		brpl	PC+10
		inc	var14
		com	var10
		com	var11
		com	var12
		com	var13
		adc	var10,lc
		adc	var11,lc
		adc	var12,lc
		adc	var13,lc
		tst	var21
		brpl	PC+10
		inc	var14
		com	var20
		com	var21
		com	var22
		com	var23
		adc	var20,lc
		adc	var21,lc
		adc	var22,lc
		adc	var23,lc
		bst	var14,0

		rcall	mul16u

		brtc	PC+17
		com	var10
		com	var11
		com	var12
		com	var13
		com	var14
		com	var15
		com	var16
		com	var17
		adc	var10,lc
		adc	var11,lc
		adc	var12,lc
		adc	var13,lc
		adc	var14,lc
		adc	var15,lc
		adc	var16,lc
		adc	var17,lc
		ret

