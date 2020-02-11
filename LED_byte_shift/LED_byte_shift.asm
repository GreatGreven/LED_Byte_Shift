;
; Analog-digital-converter.asm
;
; Created: 2020-01-23 20:19:06
; Author : Eric Grevillius
;

;==============================================================================
; Definitions of registers, etc. ("constants")
;==============================================================================
	.EQU			RESET		 =	0x0000			; reset vector
	.EQU			ADC_VECTOR	 =	0x002A			; Analog-to-digital-conversion vector
	.EQU			PM_START	 =	0x0072			; start of program
	.DEF			TEMP		 = R16
	.DEF			DELAY_INPUT	 = R24

;==============================================================================
; Start of program
;==============================================================================
	.CSEG
	.ORG			RESET
	RJMP			init

	.ORG			PM_START
	.INCLUDE		"delay.inc"
	
;==============================================================================
; Basic initializations of stack pointer, etc.
;==============================================================================
init:
	LDI				TEMP,			LOW(RAMEND)		; Set stack pointer
	OUT				SPL,			TEMP			; at the end of RAM.
	LDI				TEMP,			HIGH(RAMEND)
	OUT				SPH,			TEMP
	RCALL			init_pins						; Initialize pins
	LDI				TEMP,			0
	RJMP			main							; Jump to main

;==============================================================================
; Initialise I/O pins
;==============================================================================
init_pins:

	SBI		DDRB,	5		; set on-board LED to output
	LDI		TEMP,	0xFF
	OUT		DDRD,	TEMP	; set all pins on PORTD to output
	RET

main:
	LDI		TEMP,	0b10000000
L1:
	OUT		PORTD,	TEMP
	LDI		DELAY_INPUT,	250
	RCALL	delay_ms
	LSR		TEMP
	BRNE	L1

	RJMP	main

