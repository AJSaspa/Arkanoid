@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CPSC 359  - Computing Machinery II         @
@ Spring 2018 - Raymond Tran (30028473)      @
@             - Ace Saspa    (30027956)      @
@ Assignment 2 - Arkanoid (Mapping File)     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.balign		2


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ DATA SECTION                               @
@ Constants, variables, etc. go here.        @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.section	.data

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Game Screen                       @
@ Logical map of each tile by code.*@
@ 00 = num0	01 = num1           @
@ 02 = num2	03 = num3           @
@ 04 = num4	05 = num5           @
@ 06 = num6	07 = num7           @
@ 08 = num8	09 = num9           @
@                                   @
@ 10 = empty	11 = wall           @
@ 12 = blue	13 = green          @
@ 14 = red	15 = read nothing   @
@                                   @
@ 16 = paddleL	17 = paddleR        @
@ 18 = score	19 = lives          @
@                                   @
@ 20 = L	21 = I              @
@ 22 = V	23 = E              @
@ 24 = S	25 = C              @
@ 26 = O	27 = R              @
@ 28 = Y	29 = U              @
@ 30 = W	31 = N              @
@ 32 = 		33 = A              @
@ 34 = M	35 = V              @
@                                   @
@ * Field Ball, Life is not listed. @
@   Nor are unused sprites.         @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.global gameMap
gameMap: @ This map is modified while the game is being played.
.int	10, 18, 24, 25, 26, 27, 23, 15, 15, 10, 19, 20, 21, 22, 23, 24, 00, 15, 10, 10
.int	11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 14, 10, 14, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 14, 14, 14, 14, 14, 10, 11
.int	11, 10, 10, 10, 12, 10, 12, 10, 10, 10, 10, 10, 10, 10, 14, 14, 14, 10, 10, 11
.int	11, 10, 10, 12, 10, 12, 10, 12, 10, 10, 10, 10, 10, 10, 10, 14, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 12, 10, 10, 10, 10, 10, 10, 10, 13, 13, 13, 13, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 13, 13, 13, 13, 13, 13, 10, 11
.int	11, 10, 10, 10, 12, 12, 12, 12, 12, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 12, 12, 12, 12, 12, 12, 10, 10, 10, 12, 10, 12, 10, 10, 10, 11
.int	11, 10, 10, 12, 10, 12, 10, 12, 12, 12, 12, 10, 10, 10, 12, 10, 10, 10, 10, 11
.int	11, 10, 10, 12, 12, 12, 12, 12, 12, 12, 12, 12, 10, 10, 12, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11

.global defaultMap
defaultMap: @ This map is reserved for restarting the game to reset its state.
.int	10, 18, 24, 25, 26, 27, 23, 15, 15, 10, 19, 20, 21, 22, 23, 24, 00, 15, 10, 10
.int	11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 14, 10, 14, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 14, 14, 14, 14, 14, 10, 11
.int	11, 10, 10, 10, 12, 10, 12, 10, 10, 10, 10, 10, 10, 10, 14, 14, 14, 10, 10, 11
.int	11, 10, 10, 12, 10, 12, 10, 12, 10, 10, 10, 10, 10, 10, 10, 14, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 12, 10, 10, 10, 10, 10, 10, 10, 13, 13, 13, 13, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 13, 13, 13, 13, 13, 13, 10, 11
.int	11, 10, 10, 10, 12, 12, 12, 12, 12, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 12, 12, 12, 12, 12, 12, 10, 10, 10, 12, 10, 12, 10, 10, 10, 11
.int	11, 10, 10, 12, 10, 12, 10, 12, 12, 12, 12, 10, 10, 10, 12, 10, 10, 10, 10, 11
.int	11, 10, 10, 12, 12, 12, 12, 12, 12, 12, 12, 12, 10, 10, 12, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11
.int	11, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 11

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CODE SECTION                               @
@ Contains subroutines related to the menu.  @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ MapReader                         @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.global MapReader
MapReader: @ Reads the map in memory and places tiles accordingly.

	push		{r4, r5, r6, r7, lr}

	mov		r4, #0
	mov		r5, #0
	ldr		r6, =gameMap

vertRead:

	horzRead:
		ldr	r7, [r6], #4
		cmp	r7, #15
		beq	skipRead
		mov	r0, r7
		bl	ElementDictionary	@ Obtains the address associated with a number.
		mov	r0, r4
		mov	r1, r5
		bl	DrawTile
	skipRead:				@ If a '15' is read, it'll skip that tile. (So score/lives doesn't flicker.)
		add	r4, #1
		cmp	r4, #20
		blt	horzRead

	add	r5, #1
	cmp	r5, #21
	sublt	r4, #20
	blt	vertRead
	bl	UpdatePlayerStats
	
	pop		{r4, r5, r6, r7, pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ UpdatePlayerStats                 @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
UpdatePlayerStats: @ Overwrites the loop with a score and life printer.

	push	{lr}

	@ 28, first digit. 32 second digit of score, 68 for lives
	@ Updates the board's first score digit.
	ldr	r0, =playerScore
	ldr	r1, [r0]
	mov	r2, #10
	udiv	r1, r1, r2
	ldr	r0, =gameMap
	str	r1, [r0, #28]

	@ Update the board's second score digit.
	ldr	r0, =playerScore
	ldr	r1, [r0]
	ldr	r3, [r0]
	mov	r2, #10
	udiv	r1, r1, r2
	mul	r1, r2
	sub	r3, r1
	ldr	r0, =gameMap
	str	r3, [r0, #32]

	@ Update the board's life count.
	ldr	r0, =playerLives
	ldr	r1, [r0]
	ldr	r2, =gameMap
	str	r1, [r2, #68]

	pop	{pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ DrawLoss                          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.global DrawLoss
DrawLoss:

	push		{lr}

	@ YOU
	ldr		r0, =gameMap
	mov		r1, #28
	str		r1, [r0, #584]
	mov		r1, #26
	str		r1, [r0, #588]
	mov		r1, #29
	str		r1, [r0, #592]

	@ LOSE
	mov		r1, #20
	str		r1, [r0, #604]
	mov		r1, #26
	str		r1, [r0, #608]
	mov		r1, #24
	str		r1, [r0, #612]
	mov		r1, #23
	str		r1, [r0, #616]

	pop		{pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ DrawWin                           @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.global DrawWin
DrawWin:

	push		{lr}

	@ YOU
	ldr		r0, =gameMap
	mov		r1, #28
	str		r1, [r0, #584]
	mov		r1, #26
	str		r1, [r0, #588]
	mov		r1, #29
	str		r1, [r0, #592]

	@ WIN (<3)
	mov		r1, #30
	str		r1, [r0, #604]
	mov		r1, #21
	str		r1, [r0, #608]
	mov		r1, #31
	str		r1, [r0, #612]
	mov		r1, #19
	str		r1, [r0, #616]

	pop		{pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ ElementDictionary                 @
@ >r0: The map code received.       @
@ <r2: Corresponding tile address.  @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ElementDictionary: @ Translates map code to corresponding tile address.
	
	push		{r4, lr}
	
	mov		r4, r0	
	
	@ Begin checking it against dictionary.

	@ Checking against common tiles. (Wall, empty, brick.)
	cmp		r4, #10
	ldreq		r2, =bgEmpty
	beq		EndDictionary
	cmp		r4, #11
	ldreq		r2, =bgWall
	beq		EndDictionary
	cmp		r4, #12
	ldreq		r2, =brickBlue
	beq		EndDictionary
	cmp		r4, #13
	ldreq		r2, =brickGreen
	beq		EndDictionary
	cmp		r4, #14
	ldreq		r2, =brickRed

	@ Checking against UI tiles and paddles. (Life/Score icons)
	cmp		r4, #18
	ldreq		r2, =gaugeScore
	beq		EndDictionary
	cmp		r4, #19
	ldreq		r2, =gaugeLives
	beq		EndDictionary
	cmp		r4, #16
	ldreq		r2, =fieldPaddleL
	beq		EndDictionary
	cmp		r4, #17
	ldreq		r2, =fieldPaddleR
	beq		EndDictionary

	@ Checking against number tiles 0-9.
	cmp		r4, #0
	ldreq		r2, =num0
	beq		EndDictionary
	cmp		r4, #1
	ldreq		r2, =num1
	beq		EndDictionary
	cmp		r4, #2
	ldreq		r2, =num2
	beq		EndDictionary
	cmp		r4, #3
	ldreq		r2, =num3
	beq		EndDictionary
	cmp		r4, #4
	ldreq		r2, =num4
	beq		EndDictionary
	cmp		r4, #5
	ldreq		r2, =num5
	beq		EndDictionary
	cmp		r4, #6
	ldreq		r2, =num6
	beq		EndDictionary
	cmp		r4, #7
	ldreq		r2, =num7
	beq		EndDictionary
	cmp		r4, #8
	ldreq		r2, =num8
	beq		EndDictionary
	cmp		r4, #9
	ldreq		r2, =num9
	beq		EndDictionary

	@ Checking against alphanumeric tiles.
	cmp		r4, #20
	ldreq		r2, =letL
	beq		EndDictionary
	cmp		r4, #21
	ldreq		r2, =letI
	beq		EndDictionary
	cmp		r4, #22
	ldreq		r2, =letV
	beq		EndDictionary
	cmp		r4, #23
	ldreq		r2, =letE
	beq		EndDictionary
	cmp		r4, #24
	ldreq		r2, =letS
	beq		EndDictionary
	cmp		r4, #25
	ldreq		r2, =letC
	beq		EndDictionary
	cmp		r4, #26
	ldreq		r2, =letO
	beq		EndDictionary
	cmp		r4, #27
	ldreq		r2, =letR
	beq		EndDictionary
	cmp		r4, #28
	ldreq		r2, =letY
	beq		EndDictionary
	cmp		r4, #29
	ldreq		r2, =letU
	beq		EndDictionary
	cmp		r4, #30
	ldreq		r2, =letW
	beq		EndDictionary
	cmp		r4, #31
	ldreq		r2, =letN
	beq		EndDictionary
	@cmp		r4, #32
	@ldreq		r2, =letG
	@beq		EndDictionary
	cmp		r4, #33
	ldreq		r2, =letA
	beq		EndDictionary
	cmp		r4, #34
	ldreq		r2, =letM
	beq		EndDictionary
	cmp		r4, #35
	ldreq		r2, =letV
	beq		EndDictionary


EndDictionary:
	pop		{r4, pc}
