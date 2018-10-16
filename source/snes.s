@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CPSC 359  - Computing Machinery II         @
@ Spring 2018 - Raymond Tran (30028473)      @
@             - Ace Saspa    (30027956)      @
@ Assignment 2 - Arkanoid (SNES File)        @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.balign		2

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CODE SECTION                               @
@ Contains subroutines related to the SNES.  @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.section	.data
gBase		.req	r10		@ Saves the GPIO base address as a local variable.

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ SNESInit                          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.global SNESInit
SNESInit: @ Initializes SNES controller input.

	push		{lr}

	@ Set Latch (Pin 09) to Output (0b001) from bits 27-30.
	mov		r0, #9
	mov		r1, #0b001
	bl		Init_GPIO
	
	@ Set Clock (Pin 11) to Output (0b001) from bits 03-05.
	mov		r0, #11
	mov		r1, #0b001
	bl		Init_GPIO
	
	@ Set Data (Pin 10) to Input (0b000) from bits 00-02.
	mov		r0, #10
	mov		r1, #0b000
	bl		Init_GPIO

	pop		{pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Init_GPIO                         @
@ >r0: GPIO Pin Number (9, 10, 11)  @
@ >r1: Function Code (0b000, 0b001) @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Init_GPIO:	@ Sets a given GPIO pin to a given function code.

	push	{r4, r5, r6, lr}
	
	mov		r4, r0
	mov		r5, r1

	@ Calculate GPFSEL register.
	mov		r1, r4
	mov		r2, #10
	udiv	r1, r2
	lsl		r1, #2
	
	@ Calculate bit numbers for alignment.
	mov		r3, r4
	mov		r6, r4
	mov		r2, #10
	udiv	r3, r2
	mul		r3, r2
	sub		r6, r3
	add		r6, r6, LSL #1
	
	@ Set function code.
	mov		r3, #0b111
	lsl		r3, r6
	bic		r4, r3
	lsl		r5, r6
	orr		r4, r5
	str		r4, [gBase, r1]

	pop		{r4, r5, r6, pc}

Init_Data:
	ldr		r0, [gBase, #4]			@ Pull current code out of gBase + 4.
	mov		r1, #0b111
	bic		r0, r1, lsl #0			@ Bit Clear gBase + 4.
	mov		r1, r5
	orr		r0, r1, lsl #0			@ Insert new function code into gBase + 4.
	str		r0, [gBase, #4]			
	b		End_Init				@ Save and exit.
	
End_Init:
	pop		{r4, r5, pc}
	

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Write_Latch                       @
@ >r0: Set/Clear Code (0, 1)        @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Write_Latch:@ Enables/Disables the latch line from sending a voltage.

	push	{r4, lr}
	
	mov		r4, r0

Chk_Latch:
	cmp		r4, #0
	beq		L_Writer
	cmp		r4, #1
	beq		L_Writer
	@ldr		r0, =writeMsg		@ Error handling from old file.
	@bl		printf
	@b		Quit
	
L_Writer:
	mov		r0, #1
	lsl		r0, #9
	teq		r4, #0
	streq	r0, [gBase, #40]
	strne	r0, [gBase, #28]
	
	pop		{r4, pc}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Write_Clock                       @
@ >r0: Set/Clear Code (0, 1)        @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Write_Clock:@ Enables/Disables the clock line from sending a voltage.

	push	{r4, lr}
	
	mov		r4, r0

Chk_Clock:
	cmp		r4, #0
	beq		C_Writer
	cmp		r4, #1
	beq		C_Writer
	@ldr		r0, =writeMsg		@ Error handling from old file.
	@bl		printf
	@b		Quit
	
C_Writer:
	mov		r0, #1
	lsl		r0, #11
	teq		r4, #0
	streq	r0, [gBase, #40]
	strne	r0, [gBase, #28]

	pop		{r4, pc}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Read_Data                         @
@ <r0: Value of Bit Read (0, 1)     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Read_Data:	@ Reads a single bit from the data line when called.

	push	{lr}

	ldr		r0, [gBase, #52]
	
	mov		r1, #1
	lsl		r1, #10
	and		r0, r1
	teq		r0, #0
	
	moveq	r0, #0
	movne	r0, #1
	
	pop		{pc}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Read_SNES                         @
@ <r0: 16-bit I/O (0xFFFF, 0xF000)  @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.global Read_SNES
Read_SNES:	@ The primary loop that reads the SNES controller for input.

	push	{r4, r5, lr}			@ Preserve Registers
	
	mov		r5, #0					@ Register sampling buttons.

	mov		r0, #1
	bl		Write_Latch

	mov		r0, #1
	bl		Write_Clock
	
	mov		r0, #12
	bl		delayMicroseconds
	
	mov		r0, #0
	bl		Write_Latch

	mov		r4, #0		@ i = 0

	pulseLoop:
		mov		r0, #6
		bl		delayMicroseconds
			
		mov		r0, #0
		bl		Write_Clock
			
		mov		r0, #6
		bl		delayMicroseconds
			
		bl		Read_Data
			
		mov		r1, r0				@ buttons[i] = b
		lsl		r1, r4				@ If read 0, 0 OR 0 is 0.
		orr		r5, r1				@ If read 1, 1 OR 0 is 1. (and vice versa.)
			
		mov		r0, #1
		bl		Write_Clock
	
		add		r4, #1				@ i++; Next button.
	
		cmp		r4, #16
		blt		pulseLoop

	@ Return the filled up register of inputs to caller.
	mov		r0, r5
	
	pop		{r4, r5, pc}			@ Release Registers
