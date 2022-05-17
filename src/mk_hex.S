;-----------------------------------------------------------------------------;
; Universal hexdecimal string conversion (8/16/32 bit)
;
; Register Variables:
;  Call:   var3:0 = 8/16/24/32 bit value to be converted
;
;  Result: var3:0 = <Unknown>
;
; Size:  23 words
; Clock: depends on output routine
; Stack: 2 (+output routine)

mk_h32:         push     var0
                mov      var0, var3
                 rcall   mk_h08
                pop      var0
mk_h24:         push     var0
                mov      var0, var2
                 rcall   mk_h08
                pop      var0
mk_h16:         push     var0
                mov      var0, var1
                 rcall   mk_h08
                pop      var0
mk_h08:         push     var0
                swap     var0
                 rcall   PC+2
                pop      var0
                andi     var0,0x0f
                cpi      var0,10
                brcs     PC+2
                subi     var0,-7
                subi     var0,-'0'
                 rcall   xmit
                ret
