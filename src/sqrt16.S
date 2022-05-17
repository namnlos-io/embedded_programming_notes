;-----------------------------------------------------------------------------:
; 16bit squareroot
;
; Register Variables
;  Call:  var[1:0] = Source (16bit)
;         var[6:2] = <work area>       * var4 and var6 must be high-regs.
;
;  Result:var[0]   = Result (8bit)
;         var[6:1] = <broken>
;
; Size  = 33 words
; Clock = 177..185 cycles (+ret)
; Stack = 0 byte

sqrt16:		clr	var2
		clr	var3
		ldi	var4,1
		clr	var5
		ldi	var6,8
sqrt16l:	lsl	var0
		rol	var1
		rol	var2
		rol	var3
		lsl	var0
		rol	var1
		rol	var2
		rol	var3
		brpl	PC+4
		add	var2,var4
		adc	var3,var5
		rjmp	PC+3
		sub	var2,var4
		sbc	var3,var5
		lsl	var4
		rol	var5
		andi	var4,0b11111000
		ori	var4,0b00000101
		sbrc	var3,7
		subi	var4,2
		dec	var6
		brne	sqrt16l
		lsr	var5
		ror	var4
		lsr	var5
		ror	var4
		mov	var0, var4
		ret

