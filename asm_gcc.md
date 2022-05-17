# How to write an assembler function (avr-gcc)

Normally, I don't think I have a chance to write assembler functions, but I think it's common to read the code spit out by the compiler, so it's worth knowing. On the contrary, if you can't do that, you're out of luck if you run into deep-rooted bugs. Here, I will briefly explain how to write an assembler function in avr-gcc. The benefits of assembler are reduced memory consumption and increased speed. It's more specific and easier to understand than an inline assembler embedded directly in C source, so I think it's suitable for beginners from AVRASM. If the function is solid and frequently used, it is a good idea to assemble it.

## Source list format

```m68k
;-------------------------------------------------------;
; Assembler function sum
;
; Prototype: int16_t sum (int16_t a, int16_t b)
; Function: Returns a plus b

.global sum       ; expose symbol sum to other modules
.func sum         ; start of function sum () (.func / .endfunc can be omitted)
sum:              ; Definition of symbol sum
  add r24, r22    ; add b (r23: r22) to a (r25: r24)
  adc r25, r23    ; /
  ret             ; Return by putting the return value in r25: r24
.endfunc


;-------------------------------------------------------;
; Assembler function Timer 0 Overflow interrupt
; (Note that the symbol name varies depending on the device)
;
; Prototype: None
; Function: Interrupt occurs every 100 counts

.global TIMER0_OVF_vect
.func TIMER0_OVF_vect
TIMER0_OVF_vect:
  push  r0                    ; Save flags and registers to use
  in  r0, _SFR_IO_ADDR(SREG)  ;
  push  r24                   ;/

  ldi r24, -100               ; Next interrupt after 100 counts
  out _SFR_IO_ADDR(TCNT0), r24;/

  pop r24                     ; Restore flags and used registers
  out _SFR_IO_ADDR(SREG), r0  ;
  pop r0                      ;/
  reti
.endfunc
```

```m68k
;-------------------------------------------------------;
; Definition of other data

.section .data  ; ↓ Data RAM area (static variable initialized with significant value)

val1: .dc.w 1000            ; int16_t val1 = 1000;
tbl1: .dc.b 1,2,3,4         ; int8_t tbl1[] = {1,2,3,4};
tbl2: .dc.w 1,2,3,4         ; int16_t tbl2[] = {1,2,3,4};

.section .bss   ; ↓ Data RAM area (static variable initialized with zero)

tbl0: .ds.b 5     ; int8_t tbl0[5];


.section .text  ; ↓ Program memory area

tbl1_P: .dc.b 0,1,2,3,4,5   ; const uint8_t tbl1_P[] PROGMEM = {0,1,2,3,4,5};
tbl2_P: .dc.w 0,1,2,3,4,5   ; const uint16_t tbl2_P[] PROGMEM = {0,1,2,3,4,5};
str1_P: .ascii  "STRING\0"  ; const char str1_P[] PROGMEM = "STRING";

  .align  2   ; Align to word boundaries as needed

  ldi ZL, lo8(tbl1_P) ; 16 / 32bit value division is hhi8, hlo8, hi8, lo8 in order from the top
  ldi ZH, hi8(tbl1_P) ;/  (



; * Auto variables are reserved in registers and stack frames.


;-------------------------------------------------------;
; Local label (numeric label)

1:
  cpi r24, 100
  brne  2f          ;to 2 ahead
  inc r24
2:
  add r24, r23
  rjmp  1b          ; to 1 behind

1:  ; * Numerical values ​​may be duplicated


;-------------------------------------------------------;
; Reference to special function registers

#include <avr/io.h> / * ← Target device specific information can be obtained with io.h * /

  in  r24, _SFR_IO_ADDR(PORTB)  ; I/O address reference

  sts _SFR_MEM_ADDR(PORTF), r22 ; Refer to memory address



; Assembler style comment (cannot be on c directive line?)
// C++ style comment
/* C style comment */
```

## How registers are used

When writing assembler functions, the **instruction table** and **function calling convention** (ABI) are important. As specified by the ABI, the usage of registers is fixed, and the assembler function must follow it in the interface with the C function. Registers marked as saved are guaranteed not to be modified by a function call. If you want to use it, you need to save the value and return before returning to the caller. What is marked as destroyed is destroyed by a function call. Of course, the interrupt function also saves all the registers used and SREG.

|Register|Use|
|------|---|
|R0|Work (destruction)|
|R1|Zero register (save)|
|R2-R17|Variable / work (save)|
|R18-R25|Argument / Return value (destroy)|
|R26-R27 (X)|Variable / work (destruction)|
|R28-R29 (Y)|Frame pointer (save)|
|R30-R31 (Z)|Variable / work (destruction)|

### Z (r31:r30), X (r27:r26), r25:r18

Used as a work in a C function. There is no need to store the value and the caller will save it if necessary. Also, when calling C functions, you should treat them as destroyed.

### r17:r2

Used as a local variable in a C function. The value must be saved and the callee will save/return when using it.

### Y (r29:r28)

Used as a frame pointer in C functions. The value must be saved and the callee will save/return when using it.

### r1:r0

It is used as a work for special purposes such as flash memory reference and multiplication. `r1` is also used as a zero register (always considered 0), so it must always be zero on function calls / returns.

## How to pass arguments

```c
Example of how arguments are passed

func (int16_t a, int32_t b, char* c);

      |   a   |       b       |   c   |
      |r25:r24|r23:r22:r21:r20|r19:r18|


func (int8_t a, int16_t b);

      |   | a |   b   |
      |r25|r24|r23:r22|


func (char a*, b, ...);  (variadic argument)

      | PC | a, b, ...
   SP^
```

The argument is passed by register. It is stored in order from the first argument to `r25:r8`, and the overflow is put on the stack. Since the structure is also passed according to this and is inefficient, it is usually passed by a pointer. Also, when calling a function declared with variable length arguments such as `printf(char *, ...);`, all registers are put on the stack without using registers. In this case, the address indicated by SP + 3 is the beginning of the argument (because AVR is a post-decrement push).

The size of the argument is char = 8bit, int = 16bit, long = 32bit, long long = 64bit, float = 32bit, double = 32bit, pointer = 16bit. Odd-length arguments are aligned to the size of the int (= 16bit). This seems to have been changed so that the movw instruction can be used efficiently when mega appeared. Register allocation is explained in the default settings of avr-gcc 3.4.1.

## Passing the return value

```text
How to pass the return value

int8_t func ();          |r24|
int16_t func ();     |r25:r24|
int32_t func ();     |r25:r24:r23:r22|
```

The return value is set in the register and returned in the same procedure as the argument.
