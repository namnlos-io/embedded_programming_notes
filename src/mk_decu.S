;-----------------------------------------------------------------------------;
; Universal decimal string conversion (8/16 bit unsigned)
;
; Register Variables:
;  Call:   var1:0  = 16 bit value to be converted
;          len     = String length
;          tmp1:0  = <Don't care> (high register must be assigned)
;          tmp2    = <Don't care>
;
;  Result: var1:0  = <Unknown>
;          len     = <Not changed>
;          tmp1:0  = <Unknown>
;          tmp2    = 0
;
; Size:  30 words
; Clock: depends on output routine
; Stack: 10 bytes max (+output routine)
;
; Examples:   var1    len    output
;              100      0    "100"
;             1234      0    "1234"
;                0      7    "      0"
;              100      5    "  100"
;              100      2    "100"


mk_decu8:       clr     var1            ;8 bit entry
mk_decu16:                              ;16 bit entry
                clr     tmp2            ;digit counter
                inc     tmp2            ;---- decimal string generating loop
                clr     tmp0            ;var1 /= 10;
                ldi     tmp1,16         ;
                lsl     var0            ;
                rol     var1            ;
                rol     tmp0            ;
                cpi     tmp0,10         ;
                brcs    PC+3            ;
                subi    tmp0,10         ;
                inc     var0            ;
                dec     tmp1            ;
                brne    PC-8            ;/
                subi    tmp0,-'0'       ;Push the remander (a decimal digit)
                push    tmp0            ;/
                cp      var0,tmp1       ;if(var =! 0)
                cpc     var1,tmp1       ; continue digit loop;
                brne    PC-16           ;/
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



