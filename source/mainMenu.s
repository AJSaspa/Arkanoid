@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CPSC 359  - Computing Machinery II         @
@ Spring 2018 - Raymond Tran (30028473)      @
@             - Ace Saspa    (30027956)      @
@ Assignment 2 - Arkanoid (Main Menu File)   @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.balign		2


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CODE SECTION                               @
@ Contains subroutines related to the menu.  @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ DrawMenu                          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.global DrawMenu
DrawMenu: @ Draws the main menu. (20x21)

	push		{r4, r5, lr}

void:	@ Draws a void where no tiles are placed.


@ Space between wall and Arkanoid logo.
	mov		r4, #1
	mov		r5, #1
vertVoidLoop1:
	horzVoidLoop1:
		mov		r0, r4
		mov		r1, r5
		ldr		r2, =bgEmpty
		bl		DrawTile
		add		r4, #1
		cmp		r4, #19
		blt		horzVoidLoop1
	add	r5, #1
	cmp	r5, #3
	sublt	r4, #18
	blt	vertVoidLoop1


@ Space left of Arkanoid logo.
	mov		r4, #1
	mov		r5, #3
vertVoidLoop2:
	horzVoidLoop2:
		mov		r0, r4
		mov		r1, r5
		ldr		r2, =bgEmpty
		bl		DrawTile
		add		r4, #1
		cmp		r4, #6
		blt		horzVoidLoop2
	add	r5, #1
	cmp	r5, #8
	sublt	r4, #5
	blt	vertVoidLoop2


@ Space right of Arkanoid logo.
	mov		r4, #14
	mov		r5, #3
vertVoidLoop3:
	horzVoidLoop3:
		mov		r0, r4
		mov		r1, r5
		ldr		r2, =bgEmpty
		bl		DrawTile
		add		r4, #1
		cmp		r4, #19
		blt		horzVoidLoop3
	add	r5, #1
	cmp	r5, #8
	sublt	r4, #5
	blt	vertVoidLoop3


@ Space between Arkanoid logo and credits.
	mov		r4, #6
lineVoidLoop1:
	mov		r0, r4
	mov		r1, #5
	ldr		r2, =bgEmpty
	bl		DrawTile
	add		r4, #1
	cmp		r4, #14
	blt		lineVoidLoop1


@ Single tile after 'Credits'
	mov		r0, #13
	mov		r1, #6
	ldr		r2, =bgEmpty
	bl		DrawTile


@ Space between credits and names.
	mov		r4, #6
lineVoidLoop2:
	mov		r0, r4
	mov		r1, #7
	ldr		r2, =bgEmpty
	bl		DrawTile
	add		r4, #1
	cmp		r4, #15
	blt		lineVoidLoop2


@ Space before first name.
	mov		r4, #1
lineVoidLoop3:
	mov		r0, r4
	mov		r1, #8
	ldr		r2, =bgEmpty
	bl		DrawTile
	add		r4, #1
	cmp		r4, #4
	blt		lineVoidLoop3


@ Single tile between first first name and last name.
	mov		r0, #11
	mov		r1, #8
	ldr		r2, =bgEmpty
	bl		DrawTile


@ Space after first name.
	mov		r4, #16
lineVoidLoop4:
	mov		r0, r4
	mov		r1, #8
	ldr		r2, =bgEmpty
	bl		DrawTile
	add		r4, #1
	cmp		r4, #19
	blt		lineVoidLoop4


@ Space between first and second names.
	mov		r4, #1
lineVoidLoop5:
	mov		r0, r4
	mov		r1, #9
	ldr		r2, =bgEmpty
	bl		DrawTile
	add		r4, #1
	cmp		r4, #19
	blt		lineVoidLoop5


@ Space before second name.
	mov		r4, #1
lineVoidLoop6:
	mov		r0, r4
	mov		r1, #10
	ldr		r2, =bgEmpty
	bl		DrawTile
	add		r4, #1
	cmp		r4, #4
	blt		lineVoidLoop6


@ Space between second first name and last name.
	mov		r4, #7
lineVoidLoop7:
	mov		r0, r4
	mov		r1, #10
	ldr		r2, =bgEmpty
	bl		DrawTile
	add		r4, #1
	cmp		r4, #12
	blt		lineVoidLoop7


@ Space after second name.
	mov		r4, #17
lineVoidLoop8:
	mov		r0, r4
	mov		r1, #10
	ldr		r2, =bgEmpty
	bl		DrawTile
	add		r4, #1
	cmp		r4, #19
	blt		lineVoidLoop8


@ Space between names and menu options.
	mov		r4, #1
	mov		r5, #11
vertVoidLoop4:
	horzVoidLoop4:
		mov		r0, r4
		mov		r1, r5
		ldr		r2, =bgEmpty
		bl		DrawTile
		add		r4, #1
		cmp		r4, #19
		blt		horzVoidLoop4
	add	r5, #1
	cmp	r5, #14
	sublt	r4, #18
	blt	vertVoidLoop4


@ Space left of the menu pointer.
	mov		r4, #1
	mov		r5, #14
vertVoidLoop5:
	horzVoidLoop5:
		mov		r0, r4
		mov		r1, r5
		ldr		r2, =bgEmpty
		bl		DrawTile
		add		r4, #1
		cmp		r4, #6
		blt		horzVoidLoop5
	add	r5, #1
	cmp	r5, #16
	sublt	r4, #5
	blt	vertVoidLoop5


@ Space between menu pointer and options.
	mov		r4, #7
	mov		r5, #14
vertVoidLoop6:
	horzVoidLoop6:
		mov		r0, r4
		mov		r1, r5
		ldr		r2, =bgEmpty
		bl		DrawTile
		add		r4, #1
		cmp		r4, #8
		blt		horzVoidLoop6
	add	r5, #1
	cmp	r5, #16
	sublt	r4, #1
	blt	vertVoidLoop6


@ Single tile after 'Quit'
	mov		r0, #12
	mov		r1, #15
	ldr		r2, =bgEmpty
	bl		DrawTile


@ Space after options.
	mov		r4, #13
	mov		r5, #13
vertVoidLoop7:
	horzVoidLoop7:
		mov		r0, r4
		mov		r1, r5
		ldr		r2, =bgEmpty
		bl		DrawTile
		add		r4, #1
		cmp		r4, #19
		blt		horzVoidLoop7
	add	r5, #1
	cmp	r5, #16
	sublt	r4, #6
	blt	vertVoidLoop7


@ Remaining uncovered space. (Below options.)
	mov		r4, #1
	mov		r5, #16
vertVoidLoop8:
	horzVoidLoop8:
		mov		r0, r4
		mov		r1, r5
		ldr		r2, =bgEmpty
		bl		DrawTile
		add		r4, #1
		cmp		r4, #19
		blt		horzVoidLoop8
	add	r5, #1
	cmp	r5, #20
	sublt	r4, #18
	blt	vertVoidLoop8


	mov		r4, #0
row1:	@ Covers the first row in grey walls.
	mov		r0, r4
	mov		r1, #0
	ldr		r2, =bgWall
	bl		DrawTile
	add		r4, #1
	cmp		r4, #20
	blt		row1

	mov		r4, #0
row21:	@ Covers the last row in grey walls.
	mov		r0, r4
	mov		r1, #20
	ldr		r2, =bgWall
	bl		DrawTile
	add		r4, #1
	cmp		r4, #20
	blt		row21
	
	mov		r5, #0
col1:	@ Covers the first column in grey walls.
	mov		r0, #0
	mov		r1, r5
	ldr		r2, =bgWall
	bl		DrawTile
	add		r5, #1
	cmp		r5, #21
	blt		col1

	mov		r5, #0
col20:	@ Covers the last column in grey walls.
	mov		r0, #19
	mov		r1, r5
	ldr		r2, =bgWall
	bl		DrawTile
	add		r5, #1
	cmp		r5, #21
	blt		col20

drawTitle: @ Draws the game logo from (6, 2) to (13, 3)
	mov		r0, #6
	mov		r1, #3
	ldr		r2, =tile1
	bl		DrawTile

	mov		r0, #7
	mov		r1, #3
	ldr		r2, =tile3
	bl		DrawTile

	mov		r0, #8
	mov		r1, #3
	ldr		r2, =tile5
	bl		DrawTile

	mov		r0, #9
	mov		r1, #3
	ldr		r2, =tile7
	bl		DrawTile

	mov		r0, #10
	mov		r1, #3
	ldr		r2, =tile9
	bl		DrawTile

	mov		r0, #11
	mov		r1, #3
	ldr		r2, =tile11
	bl		DrawTile

	mov		r0, #12
	mov		r1, #3
	ldr		r2, =tile13
	bl		DrawTile

	mov		r0, #13
	mov		r1, #3
	ldr		r2, =tile15
	bl		DrawTile

	mov		r0, #6
	mov		r1, #4
	ldr		r2, =tile2
	bl		DrawTile

	mov		r0, #7
	mov		r1, #4
	ldr		r2, =tile4
	bl		DrawTile

	mov		r0, #8
	mov		r1, #4
	ldr		r2, =tile6
	bl		DrawTile

	mov		r0, #9
	mov		r1, #4
	ldr		r2, =tile8
	bl		DrawTile

	mov		r0, #10
	mov		r1, #4
	ldr		r2, =tile10
	bl		DrawTile

	mov		r0, #11
	mov		r1, #4
	ldr		r2, =tile12
	bl		DrawTile

	mov		r0, #12
	mov		r1, #4
	ldr		r2, =tile14
	bl		DrawTile

	mov		r0, #13
	mov		r1, #4
	ldr		r2, =tile16
	bl		DrawTile

drawMade: @ Draws the word 'Credits'
	mov		r0, #6
	mov		r1, #6
	ldr		r2, =letC
	bl		DrawTile

	mov		r0, #7
	mov		r1, #6
	ldr		r2, =letR
	bl		DrawTile

	mov		r0, #8
	mov		r1, #6
	ldr		r2, =letE
	bl		DrawTile

	mov		r0, #9
	mov		r1, #6
	ldr		r2, =letD
	bl		DrawTile

	mov		r0, #10
	mov		r1, #6
	ldr		r2, =letI
	bl		DrawTile

	mov		r0, #11
	mov		r1, #6
	ldr		r2, =letT
	bl		DrawTile

	mov		r0, #12
	mov		r1, #6
	ldr		r2, =letS
	bl		DrawTile

drawNames: @ Draws the names of the creators: RAYMOND TRAN and ACE SASPA
	@ First Name: Raymond Tran
	mov		r0, #4
	mov		r1, #8
	ldr		r2, =letR
	bl		DrawTile

	mov		r0, #5
	mov		r1, #8
	ldr		r2, =letA
	bl		DrawTile

	mov		r0, #6
	mov		r1, #8
	ldr		r2, =letY
	bl		DrawTile

	mov		r0, #7
	mov		r1, #8
	ldr		r2, =letM
	bl		DrawTile

	mov		r0, #8
	mov		r1, #8
	ldr		r2, =letO
	bl		DrawTile

	mov		r0, #9
	mov		r1, #8
	ldr		r2, =letN
	bl		DrawTile

	mov		r0, #10
	mov		r1, #8
	ldr		r2, =letD
	bl		DrawTile

	mov		r0, #12
	mov		r1, #8
	ldr		r2, =letT
	bl		DrawTile

	mov		r0, #13
	mov		r1, #8
	ldr		r2, =letR
	bl		DrawTile

	mov		r0, #14
	mov		r1, #8
	ldr		r2, =letA
	bl		DrawTile

	mov		r0, #15
	mov		r1, #8
	ldr		r2, =letN
	bl		DrawTile

	@ Second Name: Ace Saspa
	mov		r0, #4
	mov		r1, #10
	ldr		r2, =letA
	bl		DrawTile

	mov		r0, #5
	mov		r1, #10
	ldr		r2, =letC
	bl		DrawTile

	mov		r0, #6
	mov		r1, #10
	ldr		r2, =letE
	bl		DrawTile

	mov		r0, #12
	mov		r1, #10
	ldr		r2, =letS
	bl		DrawTile

	mov		r0, #13
	mov		r1, #10
	ldr		r2, =letA
	bl		DrawTile

	mov		r0, #14
	mov		r1, #10
	ldr		r2, =letS
	bl		DrawTile

	mov		r0, #15
	mov		r1, #10
	ldr		r2, =letP
	bl		DrawTile

	mov		r0, #16
	mov		r1, #10
	ldr		r2, =letA
	bl		DrawTile

drawOpt: @ Draw screen options.
	@ Start
	mov		r0, #8
	mov		r1, #14
	ldr		r2, =letS
	bl		DrawTile

	mov		r0, #9
	mov		r1, #14
	ldr		r2, =letT
	bl		DrawTile

	mov		r0, #10
	mov		r1, #14
	ldr		r2, =letA
	bl		DrawTile

	mov		r0, #11
	mov		r1, #14
	ldr		r2, =letR
	bl		DrawTile

	mov		r0, #12
	mov		r1, #14
	ldr		r2, =letT
	bl		DrawTile

	@ Quit
	mov		r0, #8
	mov		r1, #15
	ldr		r2, =letQ
	bl		DrawTile

	mov		r0, #9
	mov		r1, #15
	ldr		r2, =letU
	bl		DrawTile

	mov		r0, #10
	mov		r1, #15
	ldr		r2, =letI
	bl		DrawTile

	mov		r0, #11
	mov		r1, #15
	ldr		r2, =letT
	bl		DrawTile

drawMPtr: @ Draw the menu pointer based on its current position.
	ldr		r4, =menuChoice
	ldr		r5, [r4]
	cmp		r5, #0
	bne		drawQuit

drawStart: @ If menuPointer = 0, then mousing over Start. Draw pointer by start.
	mov		r0, #6
	mov		r1, #14
	ldr		r2, =menuPointer
	bl		DrawTile
	mov		r0, #6
	mov		r1, #15
	ldr		r2, =bgEmpty
	bl		DrawTile
	b		menuEnd

drawQuit: @ If menuPointer = 1, then mousing over Quit. Draw pointer by quit.
	mov		r0, #6
	mov		r1, #14
	ldr		r2, =bgEmpty
	bl		DrawTile
	mov		r0, #6
	mov		r1, #15
	ldr		r2, =menuPointer
	bl		DrawTile

menuEnd:
	pop		{r4, r5, pc}
