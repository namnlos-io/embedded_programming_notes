;---------------------------------------------------------------------------;
; Simple time functions                                     (C)ChaN,2005
;
; mktime() and gmtime() are sub-set of the functions defined in ANSI C.
; tm_isdst member is not returned and assumed as zero.
; mktime() does not change given tm structure and each members must be
; normalized or it returns -1.

.nolist
#include <avr/io.h>

#ifdef SPM_PAGESIZE	// The device has "lpm Rd,Z+" and "movw".
.macro	_MOVW	dh,dl, sh,sl
	movw	\dl, \sl
.endm
#else			// The device does not have "lpm Rd,Z+" nor "movw".
.macro	_MOVW	dh,dl, sh,sl
	mov	\dl, \sl
	mov	\dh, \sh
.endm
#endif
.list


.section .bss
.global time_tm
time_tm:		; Static tm structure
	.ds.w	9	; { sec, min, hour, mday, mon, year, wday, yday, isdst }


.section .text
samurai:
	.dc.b	31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31


;---------------------------------------------------------------------------;
; time_t mktime( struct tm *timeptr );
;
;Size: 89/88 words

.global mktime
.func mktime
mktime:
	push	YL
	push	YH
	_MOVW	YH,YL, r25,r24
	adiw	YL, 12

	ldi	r20, 138	; (365..366) * tm_year
	rcall	ldcp16
	clr	r22
	clr	r23
	ldi	r19, 70
0:	ldi	XL, lo8(366)
	ldi	XH, hi8(366)
	mov	r21, r19
	andi	r21, 3
	breq	1f
	sbiw	XL, 1
1:	cp	r19, r18
	breq	2f
	brcc	91f
	add	r22, XL
	adc	r23, XH
	inc	r19
	rjmp	0b
2:
	ldi	r20, 12		; + (28..31) * tm_mon
	rcall	ldcp16
	ldi	ZL, lo8(samurai)
	ldi	ZH, hi8(samurai)
	ldi	r19, 0
3:	lpm
	adiw	ZL, 1
	cpi	r19, 1
	brne	4f
	cpse	r21, r1
	dec	r0
4:	cp	r19, r18
	brcc	5f
	add	r22, r0
	adc	r23, r1
	inc	r19
	rjmp	3b
5:
	mov	r20, r0		; + tm_mday
	inc	r20
	rcall	ldcp16
	subi	r18, 1
	brcs	91f
	add	r22, r18
	adc	r23, r1
	clr	r24
	clr	r25
	; r25:r22 = days from orign

	ldi	r20, 24		; * 24 + tm_hour
	rcall	ldcp16
	rcall	muladd3208

	ldi	r20, 60		; * 60 + tm_min
	rcall	ldcp16
	rcall	muladd3208

	ldi	r18, 60		; * 60 + tm_sec
	rcall	ldcp16
	rcall	muladd3208
	rjmp	92f

ldcp16:	ld	r19, -Y		; Load an item with error check (< r20)
	ld	r18, -Y
	cp	r18, r20
	cpc	r19, r1
	brcs	93f
	pop	r0
	pop	r0

91:	ldi	r22, -1		; parameter error
	ldi	r23, -1
	ldi	r24, -1
	ldi	r25, -1

92:	pop	YH
	pop	YL
93:	ret

muladd3208:
	ldi	r21, 33		; r25:r22 *= r20;
	sub	r26, r26
0:	brcc	1f
	add	r26, r20
1:	ror	r26
	ror	r25
	ror	r24
	ror	r23
	ror	r22
	dec	r21
	brne	0b
	add	r22, r18	; r25:r22 += r18;
	adc	r23, r1
	adc	r24, r1
	adc	r25, r1
	ret
.endfunc



;---------------------------------------------------------------------------;
; struct tm *gmtime( const time_t *timer );
;
;Size: 93/89 words

.global gmtime
.func gmtime
gmtime:
	push	YL
	push	YH

	_MOVW	ZH,ZL, r25,r24		;r21:r18 = utc
	ldd	r18, Z+0		;
	ldd	r19, Z+1		;
	ldd	r20, Z+2		;
	ldd	r21, Z+3		;/
	clr	YL			;Invalid time?
	clr	YH			;
	sbrc	r21, 7			;
	rjmp	99f			;/
	ldi	YL, lo8(time_tm)
	ldi	YH, hi8(time_tm)
	; r21:r18 = seconds from origin

	ldi	r22, 60			;tm_sec = % 60
	rcall	div3208			;
	std	Y+0, r0			;
	std	Y+1, r1			;/
	rcall	div3208			;tm_min = % 60
	std	Y+2, r0			;
	std	Y+3, r1			;/
	ldi	r22, 24			;tm_hour = % 24
	rcall	div3208			;
	std	Y+4, r0			;
	std	Y+5, r1			;/
	; r19:r18 = days from origin

	_MOVW	ZH,ZL, r19,r18
	subi	r18, lo8(-4)		;tm_wday
	sbci	r19, hi8(-4)		;
	ldi	r22, 7			;
	rcall	div3208			;
	std	Y+12, r0		;
	std	Y+13, r1		;/
	_MOVW	r19,r18, ZH,ZL

	ldi	XL, 70			;tm_year
0:	ldi	ZL, lo8(366)		;
	ldi	ZH, hi8(366)		;
	mov	XH, XL			;
	andi	XH, 3			;
	breq	1f			;
	sbiw	ZL, 1			;
1:	cp	r18, ZL			;
	cpc	r19, ZH			;
	brcs	2f			;
	sub	r18, ZL			;
	sbc	r19, ZH			;
	inc	XL			;
	rjmp	0b			;
2:	std	Y+10, XL		;
	std	Y+11, r1		;/
	std	Y+14, r18		;tm_yday
	std	Y+15, r19		;/
	; r19:r18 = days in year

	ldi	ZL, lo8(samurai)	;tm_mon
	ldi	ZH, hi8(samurai)	;
	clr	XL			;
3:	lpm				;
	adiw	ZL, 1			;
	cpi	XL, 1			;
	brne	4f			;
	cpse	XH, r1			;
	dec	r0			;
4:	cp	r18, r0			;
	cpc	r19, r1			;
	brcs	5f			;
	sub	r18, r0			;
	sbc	r19, r1			;
	inc	XL			;
	rjmp	3b			;
5:	std	Y+8, XL			;
	std	Y+9, r1			;/
	inc	r18			;tm_mday
	std	Y+6, r18		;
	std	Y+7, r19		;/

99:	_MOVW	r25,r24, YH,YL		;Return pointer to internal tm buffer
	pop	YH
	pop	YL
	ret

div3208:			; r0 = r21:r18 % r22;
	clr	r0		; r21:r18 /= r22;
	ldi	r23, 32
1:	lsl	r18
	rol	r19
	rol	r20
	rol	r21
	rol	r0
	cp	r0, r22
	brcs	2f
	sub	r0, r22
	inc	r18
2:	dec	r23
	brne	1b
	ret
.endfunc

