---
source: http://elm-chan.org/docs/dev/avr.html
---
# About Atmel AVR

AVR stands for [Atmel](http://www.atmel.com/)'s 8-bit RISC architecture. In addition to a general-purpose microcontroller, it is also the core processor of the company's FPGA. Since the first announcement of the AVR series was around 1996, it can be said that it is a much later microcomputer than the industry standard 8051 and the popular PIC.

The biggest feature of AVR is that it is easy to use. It's a very straightforward and sophisticated architecture, so the hurdles to get started are extremely low. It took me a few hours to understand the PIC, but I could understand the AVR in 3.5 seconds. Well, both are difficult for beginners of microcomputers, but if you have mastered other microcomputers, you can clearly see the difference.

All development environments are free. C source level debugging is possible by linking Atmel's AVR Studio and WinAVR (gcc). You don't even need to have a device programmer ready to get started. It is enough to make a simple ISP cable or divert the JTAG cable for FPGA of each company ([related page](http://elm-chan.org/works/avrx/report.html)).

Below is a brief overview of the features of the AVR architecture and each device.

- [About Atmel AVR](#about-atmel-avr)
  - [Features of AVR architecture](#features-of-avr-architecture)
    - [8-bit RISC architecture](#8-bit-risc-architecture)
    - [Abundant general-purpose registers](#abundant-general-purpose-registers)
    - [Load / store architecture](#load--store-architecture)
    - [Built-in flash memory on all devices](#built-in-flash-memory-on-all-devices)
  - [Devices announced to date](#devices-announced-to-date)
    - [Classification by pin function](#classification-by-pin-function)
  - [Overview of the AVR family](#overview-of-the-avr-family)
    - [90S series](#90s-series)
    - [mega series](#mega-series)
    - [tiny series](#tiny-series)
  - [Features of each device (number of pins of DIP product in parentheses)](#features-of-each-device-number-of-pins-of-dip-product-in-parentheses)
    - [90S1200 (20pin)](#90s1200-20pin)
    - [90S2313 (20pin)](#90s2313-20pin)
    - [90S8515 (40pin)](#90s8515-40pin)
    - [90S8535 (40pin)](#90s8535-40pin)
    - [90S4433 (28pin)](#90s4433-28pin)
    - [90C8534 (48pin (TQFP))](#90c8534-48pin-tqfp)
    - [90S2323/2343 (8pin)](#90s23232343-8pin)
    - [tiny11 / 12 (8pin)](#tiny11--12-8pin)
    - [tiny13 (8pin)](#tiny13-8pin)
    - [tiny15 (8pin)](#tiny15-8pin)
    - [tiny25 / 45/85 (8pin)](#tiny25--4585-8pin)
    - [tiny28 (28pin)](#tiny28-28pin)
    - [mega103 (64pin (TQFP))](#mega103-64pin-tqfp)
    - [mega64/128 (64pin (TQFP))](#mega64128-64pin-tqfp)
    - [mega161 (40pin)](#mega161-40pin)
    - [mega162 (40pin)](#mega162-40pin)
    - [mega8515 (40pin)](#mega8515-40pin)
    - [mega163 (40pin)](#mega163-40pin)
    - [mega323 (40pin)](#mega323-40pin)
    - [mega8 (28pin)](#mega8-28pin)
    - [mega48 / 88/168 (28pin)](#mega48--88168-28pin)
    - [mega16 (40pin)](#mega16-40pin)
    - [mega32 (40pin)](#mega32-40pin)
    - [tiny2313 (20pin)](#tiny2313-20pin)
    - [tiny26 (20pin)](#tiny26-20pin)
    - [tiny261/461/861 (20pin)](#tiny261461861-20pin)
    - [mega169 (64pin (TQFP))](#mega169-64pin-tqfp)
    - [mega165 (64pin (TQFP))](#mega165-64pin-tqfp)
    - [mega325/645/3250/6450 (64 / 100pin (TQFP))](#mega32564532506450-64--100pin-tqfp)
    - [mega329/649/3290/6490 (64/100pin (TQFP))](#mega32964932906490-64100pin-tqfp)

## Features of AVR architecture

### 8-bit RISC architecture

The instruction code is fixed at 16 bits, and most operations are executed in one clock cycle. The number of instructions is quite large for RISC, and there are 118 (actual code is 79) in mnemonic (90S series).

### Abundant general-purpose registers

Like RISC, there are 32 general-purpose registers (8 bits). Registers are sufficient for a little control, and even large programs can be executed at high speed by using register variables well.

### Load / store architecture

This is also a feature of RISC, but arithmetic instructions are intended only between registers (immediate values). The AVR architecture has a linear data memory space of up to 64KB and allows direct and indirect addressing with load / store instructions. Indirect addressing uses some general-purpose register pairs (there are 3 pairs) as pointers, and you can use a variety of addressing modes such as with displacement, post-increment, and pre-decrement.

### Built-in flash memory on all devices

AVR has a built-in flash memory as program memory. Therefore, the program can be rewritten and used as many times as you like. It's a nice specification for small-lot, high-mix production and amateur applications. It also has a built-in data EEPROM except for some devices. There are two types of programming methods: a parallel method that writes at high speed using a writer, and an ISP method that writes while mounted on the board (the latter is the mainstream).

## Devices announced to date

|Device|Package|ROM (word)|RAM (byte)|EEP (byte)|PIO|T/C|PWM|SIO|ADC (10bit)|Comp|Note|
|------|-------|---|---|---|---|---|---|---|---|----|----|
|*90S1200*|DIP20,SOP20,SSOP20|512|-|64|15|1|-|-|-|1|Int.Osc|
|*90S2313*|DIP20,SOP20|1K|128|128|15|2|1|UART|-|1|-|
|tiny2313|DIP20,SSOP20,MLF32|1K|128|128|18|2|4|USART,USI,SPI|-|1|BOD,Int.Osc|
|tiny26|DIP20,SOP20,MLF32|1K|128|128|16|2|2|USI|11|1|BOD,Int.Osc|
|tiny261/461/861|DIP20,SOP20,MLF32|1K/2K/4K|128/256/512|128/256/512|16|2|5|USI|11|1|BOD,Int.Osc|
|*90S2333 / 4433*|DIP28,TQFP32|1K/2K|128|128/256|20|2|1|UART,SPI|6|1|BOD|
|mega8|DIP28,TQFP32,MLF32|4K|1K|512|23|3|3|USART,IIC,SPI|6|1|BOD,RTC,Int.Osc|
|mega48/88/168|DIP28,TQFP32,MLF32|2k/4K/8K|512/1K/1K|256/512/512|23|3|6|USART,IIC,SPI|6|1|BOD,RTC,Int.Osc|
|tiny28|DIP28,TQFP32,MLF32|1K|-|-|20|1|-|-|-|1|Int.Osc|
|*90S2323*|DIP8,SOP8|1K|128|128|3|1|-|-|-|-|-|
|*90S2343*|DIP8,SOP8|1K|128|128|5|1|-|-|-|-|Int.Osc|
|*tiny10 / 11*|DIP8,SOP8|512|-|-|6|1|-|-|-|1|-|
|tiny12|DIP8,SOP8|512|-|64|6|1|-|-|-|1|BOD,Int.Osc|
|*tiny22*|DIP8,SOP8|1K|128|128|5|1|-|-|-|-|-|
|tiny13|DIP8,SOP8,MLF20|512|64|64|6|1|1|-|4|1|BOD,Int.Osc|
|tiny15|DIP8,SOP8|512|-|64|6|2|1|-|4|1|BOD,Int.Osc|
|tiny25/45/85|DIP8,SOP8,MLF20|1K/2K/4K|128/256/512|128/256/512|6|2|3|IIC|4|1|BOD,Int.Osc|
|tiny24/44/84|DIP14,SOP14,MLF20|1K/2K/4K|128/256/512|128/256/512|12|2|4|USI|8|1|BOD,Int.Osc|
|*90S4414 / 8515*|DIP40,TQFP44,PLCC44|2K/4K|256/512|256/512|32|2|2|UART,SPI|-|1|8051pin-out,Ext.Mem|
|mega8515|DIP40,TQFP44,MLF44|4K|512|512|35|3|3|USART,SPI|-|1|BOD,Int.Osc,8051pin-out,Ext.Mem|
|*mega161*|DIP40,TQFP44,PLCC44|8K|1K|512|35|3|3|2UART,SPI|-|1|BOD,Int.Osc,8051pin-out,Ext.Mem|
|mega162|DIP40,TQFP44,MLF44|8K|1K|512|35|4|6|2USART,SPI|-|1|BOD,Int.Osc,8051pin-out,Ext.Mem,JTAG|
|*90C8534*|TQFP48|4K|256|512|7|2|-|-|6|-|-|
|*90S4434 / 8535*|DIP40,TQFP44,PLCC44,MLF44|2K/4K|256/512|256/512|32|3|2|UART,SPI|8|1|RTC|
|mega8535|DIP40,TQFP44,PLCC44,MLF44|4K|512|512|32|3|3|USART,IIC,SPI|8|1|BOD,RTC,Int.Osc|
|*mega163*|DIP40,TQFP44|8K|1K|512|32|3|3|UART,IIC,SPI|8|1|BOD,RTC,Int.Osc|
|*mega323*|DIP40,TQFP44|16K|2K|1K|32|3|3|USART,IIC,SPI|8|1|BOD,RTC,Int.Osc,JTAG|
|mega16/32|DIP40,TQFP44,MLF44|8K/16K|1K/2K|512/1K|32|3|4|USART,IIC,SPI|8|1|BOD,RTC,Int.Osc,JTAG|
|mega644|DIP40,TQFP44,MLF44|32K|4K|2K|32|3|6|USART,IIC,SPI|8|1|BOD,RTC,Int.Osc,JTAG|
|mega164P/324P/644P|DIP40,TQFP44,MLF44|8K/16K/32K|1K/2K/4K|512/1K/2K|32|3|6|2USART,IIC,SPI|8|1|BOD,RTC,Int.Osc,JTAG|
|*mega603 / 103*|TQFP64|32K/64K|4K|2K/4K|48|3|4|UART,SPI|8|1|RTC,Ext.Mem|
|mega64/128|TQFP64,MLF64|32K/64K|4K|2K/4K|53|4|8|2USART,IIC,SPI|8|1|BOD,RTC,Int.Osc,Ext.Mem,JTAG|
|mega165/325/645|TQFP64,MLF64|8K/16K/32K|1K/2K/4K|512/1K/2K|53|3|4|USART,IIC,SPI|8|1|BOD,RTC,Int.Osc|
|mega169/329/649|TQFP64,MLF64|8K/16K/32K|1K/2K/4K|512/1K/2K|53|3|4|USART,IIC,SPI|8|1|LCD,BOD,RTC,Int.Osc,JTAG|
|mega3250/6450|TQFP100|16K/32K|2K/4K|1K/2K|69|3|4|USART,IIC,SPI|8|1|BOD,RTC,Int.Osc|
|mega3290/6490|TQFP100|16K/32K|2K/4K|1K/2K|69|3|4|USART,IIC,SPI|8|1|LCD,BOD,RTC,Int.Osc|

*Items in italic* are discontinued.

### Classification by pin function

|8pin|14pin|20pin (1200 series)|20pin (26 series)|28pin|40pin (8515 series)|40pin (8535 series)|64pin|100pin|
|----|-----|-----|-----|-----|-----|------|-----|------|
|*90S2323*, *90S2343*, *tiny11*, *tiny12*, *tiny22*, *tiny15*, tiny13, tiny25, tiny45, tiny85|tiny24, tiny44, tiny84|*90S1200*, *90S2313*, tiny2313, tiny4313|tiny26, tiny261, tiny461, tiny861|*90S2333*, *90S4433*, mega8, mega48, mega88, mega168, mega328, tiny28|*90S4414*, *90S8515*, *mega161*, mega8515, mega162|*90S4434*, *90S8535*, *mega163*, *mega323*, mega8535, mega16, mega32, mega644, mega164P, mega324P, mega644P, mega1284|*mega603*, *mega103*, *mega165*, *mega169*, mega64, mega128, mega1281, mega2561, mega325, mega645, mega329, mega649|mega640, mega1280, mega2560, mega3250, mega6450, mega3290, mega6490|

## Overview of the AVR family

The AVR family is broadly divided into three series according to size. However, unlike the PIC microcomputer, the basic architecture does not change, and the core processor is common to all low-end to high-end products. This is a sign of the flexibility of the AVR architecture.

Recently, devices with similar functions have been announced one after another, and it has become difficult to understand what it is. If you try to put together similar pin arrangements and functions, it will look like the table above.

### 90S series

It is the core series of the AVR family and is the basis of many AVR chips. Currently, mega conversion is progressing based on these devices, so this series is expected to disappear in the future.

### mega series

This series has expanded memory capacity and built-in peripherals. It has multiplication instructions (6 types) and self-programming functions. In particular, the chip of the new process is the second generation mega, and the built-in peripheral has dramatically improved functionality, making it a highly complete microcomputer.

### tiny series

Contrary to the mega series, it is a series that supports small scale and low power, such as reducing the number of I/O and deleting SRAM.

## Features of each device (number of pins of DIP product in parentheses)

### 90S1200 (20pin)

AVR first announced as a microcomputer chip. Since it does not have SRAM, it is a little difficult to use for complicated control. It can be said that it belongs to the tiny series in the current classification. → tiny2313

### 90S2313 (20pin)

90S1200 and pin compatible, with SRAM and surroundings added. The 20-pin class is quite sophisticated and very easy to use. → tiny2313

### 90S8515 (40pin)

Aiming to replace the industry standard i8051. Since it is almost pin compatible, it can be replaced in terms of hardware. It is also suitable for processing large amounts of data, such as supporting a 64K byte external data memory space. This kind is the most affordable in the 40-pin class. → mega8515

### 90S8535 (40pin)

A type like the 90S8515 with a 10-bit ADC added (not pin compatible). Other peripheral functions are also substantial, and it is the most advanced in the 90S series. There are many mega devices based on this. → mega8535

### 90S4433 (28pin)

With a built-in 10-bit ADC, it seems to be a scaled-down version of the 90S8535. → mega8

### 90C8534 (48pin (TQFP))

A device that is unlikely to be usable because it has only 7 bits of I/O despite the large number of pins. There is no DIP product. It seems to be some kind of custom product.

### 90S2323/2343 (8pin)

The 2323 is exclusively for external oscillators and has no merit of 8pin. Therefore, I/O has only 3 pins, and it is not very useful (although I can see it quite a bit). 2343 can use 5pin I/O when using built-in OSC. Also, 2343 is the same as tiny22 (so tiny22 seems to be abolished).

### tiny11 / 12 (8pin)

A device with features unique to the tiny series, such as 1.8V operation. Up to 6 pins other than the power pin can be used as I/O. tiny11 does not have an ISP function and is very cheap. → tiny13

### tiny13 (8pin)

tiny12 with ADC and a little RAM added. 20MHz operation.

### tiny15 (8pin)

It had the highest functionality among the 8-pins, including a built-in 10-bit ADC and high-speed PWM. → tiny25/45/85

### tiny25 / 45/85 (8pin)

Increased ROM capacity of tiny15, added RAM, and enhanced peripheral functions. 20MHz operation.

### tiny28 (28pin)

Specialized for incorporation into infrared remote controls. It operates at 1.8V and has no ISP function. Very cheap.

### mega103 (64pin (TQFP))

64K word program memory, 4K bytes of SRAM, 48bit I/O port, support for external data memory space, etc., the largest AVR chip at the time. It is the first device in the mega series and has no multiplication instruction. Already a discon. → mega64/128

### mega64/128 (64pin (TQFP))

Replacement product of mega603/103. Further enhancement of peripheral functions and new processes. The strongest in the AVR family. 16MHz operation.

### mega161 (40pin)

Enhanced memory and peripheral functions of 90S8515. → mega162

### mega162 (40pin)

Replacement product of mega161. 16MHz operation.

### mega8515 (40pin)

Enhanced peripheral functions of 90S8515. 16MHz operation.

### mega163 (40pin)

An extension of the 90S8535's memory and peripheral functions. → mega16

### mega323 (40pin)

A further expansion of the mega163's memory and peripheral functions. → mega32

### mega8 (28pin)

An extension of the 90S4433's memory and peripheral functions. 16MHz operation.

### mega48 / 88/168 (28pin)

Expanded operating power supply voltage range, speed, and memory variation of mega8. The mega8 series seems to be popular. 20MHz operation.

### mega16 (40pin)

A replacement product that expands the area around mega163. 16MHz operation.

### mega32 (40pin)

A replacement product that expands the area around mega323. 16MHz operation.

### tiny2313 (20pin)

An extension of the peripheral functions of the 90S2313. 20MHz operation.

### tiny26 (20pin)

It feels like a subset of mega8. Since it has a built-in PWM for bridge drive and 11-channel ADC, it is suitable for servo control. 16MHz operation. → tiny261/461/861

### tiny261/461/861 (20pin)

An extension of the peripheral functions of tiny26. 20MHz operation.

### mega169 (64pin (TQFP))

Built-in LCD driver for the first time in the AVR family for portable devices. 16MHz operation.

### mega165 (64pin (TQFP))

The LCD driver is taken from ↑. 16MHz operation.

### mega325/645/3250/6450 (64 / 100pin (TQFP))

It feels like increasing only the number of I/O of mega16/32. 16MHz operation.

### mega329/649/3290/6490 (64/100pin (TQFP))

LCD driver added to ↑. 16MHz operation.
