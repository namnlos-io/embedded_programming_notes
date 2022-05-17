;-----------------------------------------------------------------------------;
; Universal decimal string conversion (8/16/32 bit signed)
;
; Register Variables:
;  Call:  var3:0  = 32 bit value to be displayed
;         len     = String length
;         tmp1:0  = <Don't care> (high register must be assigned)
;         tmp2    = <Don't care>
;
;  Result:var3:0  = <Unknown>
;         len     = <Not changed>
;         tmp1:0  = <Unknown>
;         tmp2    = 0
;
; Size:  58 words
; Clock: depends on output routine
; Stack: 11 bytes max (+output routine)
;
; Examples:    var    len    output
;              100      0    "100"
;            -1234      0    "-1234"
;         31450000      0    "31450000"
;                0      7    "      0"
;             -400      5    " -400"
;              100      5    "  100"
;              100      2    "100"

mk_dec8:        clr     var1            ;8 bit entry
                sbrc    var0,7          ;
                dec     var1            ;/
mk_dec16:       clr     var2            ;16 bit entry 
                sbrc    var1,7          ;
                dec     var2            ;/
mk_dec24:       clr     var3            ;24 bit entry
                sbrc    var2,7          ;
                dec     var3            ;/
mk_dec32:                               ;32 bit entry
                clr     tmp2            ;digit counter
                clt                     ;Remove sign
                tst     var3            ;
                brpl    PC+10           ;
                set                     ;
                com     var0            ;
                com     var1            ;
                com     var2            ;
                com     var3            ;
                adc     var0,tmp2       ;
                adc     var1,tmp2       ;
                adc     var2,tmp2       ;
                adc     var3,tmp2       ;/
                inc     tmp2            ;---- decimal string generating loop
                clr     tmp0            ;var1 /= 10;
                ldi     tmp1,32         ;
                lsl     var0            ;
                rol     var1            ;
                rol     var2            ;
                rol     var3            ;
                rol     tmp0            ;
                cpi     tmp0,10         ;
                brcs    PC+3            ;
                subi    tmp0,10         ;
                inc     var0            ;
                dec     tmp1            ;
                brne    PC-10           ;/
                subi    tmp0,-'0'       ;Push the remander (a decimal digit)
                push    tmp0            ;/
                cp      var0,tmp1       ;if(var =! 0)
                cpc     var1,tmp1       ; continue digit loop;
                cpc     var2,tmp1       ;
                cpc     var3,tmp1       ;
                brne    PC-20           ;/
                brtc    PC+4            ;Put sign
                ldi     var0,'-'        ;
                push    var0            ;
                inc     tmp2            ;/
                cp      tmp2,len        ;Adjust string length (this can be removed for auto-length)
                brcc    PC+5            ;
                inc     tmp2            ;
                ldi     var0,' '        ;
                push    var0            ;
                rjmp    PC-5            ;/
                pop     var0            ;Put decimal string
                 rcall  xmit            ;<-- Put a char (var0) to memory, console or any display device
                dec     tmp2            ;
                brne    PC-3            ;/
                ret
