;-----------------------------------------------------------------------------:
; 32bit squareroot
;
; Register Variables
;  Call:  var[03:00] = Source (32bit)
;         var[12:04] = <work area>       *var08 and var12 must be high-regs.
;
;  Result:var[01:00] = Result (16bit)
;         var[12:02] = <broken>
;
; Size  = 53 words
; Clock = 528..544 cycles (+ret)
; Stack = 0 byte

sqrt32:		clr	var04
		clr	var05
		clr	var06
		clr	var07
		ldi	var08,1
		clr	var09
		clr	var10
		clr	var11
		ldi	var12,16
sqrt32l:	lsl	var00
		rol	var01
		rol	var02
		rol	var03
		rol	var04
		rol	var05
		rol	var06
		rol	var07
		lsl	var00
		rol	var01
		rol	var02
		rol	var03
		rol	var04
		rol	var05
		rol	var06
		rol	var07
		brpl	PC+6
		add	var04,var08
		adc	var05,var09
		adc	var06,var10
		adc	var07,var11
		rjmp	PC+5
		sub	var04,var08
		sbc	var05,var09
		sbc	var06,var10
		sbc	var07,var11
		lsl	var08
		rol	var09
		rol	var10
		andi	var08,0b11111000
		ori	var08,0b00000101
		sbrc	var07,7
		subi	var08,2
		dec	var12
		brne	sqrt32l
		lsr	var10
		ror	var09
		ror	var08
		lsr	var10
		ror	var09
		ror	var08
		mov	var00,var08
		mov	var01,var09
		ret

