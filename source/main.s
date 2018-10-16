@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CPSC 359  - Computing Machinery II         @
@ Spring 2018 - Raymond Tran (30028473)      @
@             - Ace Saspa    (30027956)      @
@ Assignment 2 - Arkanoid                    @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.balign		2


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ DATA SECTION                               @
@ Constants, variables, etc. go here.        @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.section	.data


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Strings                           @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
test:	.asciz	"TEST 1 PASS\n"
test2:	.asciz	"TEST 2 PASS\n"
test3:	.asciz	"Game Exited.\n"


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Variables                         @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.global		GpioPtr
GpioPtr:	.int	0				@ Stores the GPIO base address.

.globl frameBufferInfo
frameBufferInfo:
	.int	0					@ Pointer Address
	.int	0					@ Video Display Width
	.int	0					@ Video Display Height
	
movingPixel:	
	.int	320					@ X Position
	.int	607					@ Y Position
	.int	0xFFFFFFFF				@ Color
	.int	1					@ Friction
	.int	0					@ Direction {[0:Inert] [1:NE] [2:NW] [3:SW] [4:SE]}
	
boundaries:
	.int	64					@ Roof Boundary
	.int	32					@ Left Wall Boundary
	.int	608					@ Right Wall Boundary
	.int	671					@ Floor Boundary

paddle:
	.int	288					@ PaddleL X Position
	.int	320					@ PaddleR X Position
	.int	0					@ Direction {[0:Inert] [1:Left]	[2:Right]}
	.int	1					@ Speed {[1:LR] [2:LR+A]}
	.int	608					@ Paddle Y Position (Not used.)
	

.global menuChoice
menuChoice:						@ {0:first (start); 1:second (quit)}
	.int	0

.global playerLives
playerLives:						@ Number of lives the player has remaining.
	.int	3

.global playerScore
playerScore:						@ Number of brick hits the player achieved.
	.int	0

gameState:						@ {0:active; 1:inactive (won/lost)}
	.int	0

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CODE SECTION                               @
@ Main Routine goes here.                    @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.section	.text
.extern		printf
.global		main
main:
	ldr 	r0, =frameBufferInfo 	@ Initialize frame buffer.
	bl		initFbInfo

	@ Set-up GPIO addressing.
	gBase		.req	r10		@ Saves the GPIO base address as a local variable.
	ldr		r0, =GpioPtr
	bl		initGpioPtr
	ldr		r0, =GpioPtr
	ldr		gBase, [r0]

	bl		SNESInit
	b		menuLp

menuLp: @ The cycle the main menu performs 60 times per second.
	@ Game is capped at 60fps.
	mov		r0, #16000 
	bl		delayMicroseconds

	@ Draw the menu and update based on any given input.
	bl		DrawMenu

	@ Read SNES input for interaction.
	bl		Read_SNES
	bl		MenuPress

	@Re-loop for next iteration.
	bl		menuLp


gameLp: @ The cycle the game screen performs 60 times per second.
	@ Game is capped at 60fps.
	mov		r0, #16000
	bl		delayMicroseconds

	@ Loads the game tile based on the map.
	@ Then, updates the location/direction of the ball.
	@ Not to mention the location/direction of the paddle.
	bl		MapReader
	bl		UpdateBall
	bl		UpdatePaddle

	@ Draw the new paddle on-top the game map.
	bl		DrawPaddle

	@ Draw the new ball on-top the game map.
	bl		DrawBall

	@ Bounce off the paddle if necessary.
	bl		CheckPaddleCollision

	@ Update user stats.
	bl		CheckState
	
	@ Read the controller for input.
	bl		Read_SNES
	bl		GamePress

	@ Re-loop for next iteration.
	b		gameLp	


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CheckState                        @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CheckState: @ If Lives == 0, set game to inactive. (Lose)

	push	{lr}

	@ Check Lives
	ldr	r0, =playerLives
	ldr	r1, [r0]
	cmp	r1, #0
	bgt	chkScore
	ldr	r0, =gameState
	mov	r1, #1
	str	r1, [r0]
	bl	DrawLoss
	ldr	r0, =movingPixel
	mov	r1, #0
	str	r1, [r0, #16]
	b	endChkState

	@ Check Score
chkScore:
	ldr	r0, =playerScore
	ldr	r1, [r0]
	cmp	r1, #100
	blt	endChkState
	ldr	r0, =gameState
	mov	r1, #1
	str	r1, [r0]
	bl	DrawWin
	ldr	r0, =movingPixel
	mov	r1, #0
	str	r1, [r0, #16]

endChkState:
	pop	{pc}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ MenuPress                         @
@ >r0: SNES Input                   @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
MenuPress: @ Performs actions for the menu based on SNES input.

	push		{lr}

chkMenuDUP: @ Up is pressed. Select option START.
	mov		r1, #0b1111111111101111
	cmp		r0, r1
	bne		chkMenuDDN
	ldr		r1, =menuChoice
	mov		r2, #0
	str		r2, [r1]
	b		endMenuPress

chkMenuDDN: @ Down is pressed. Select option QUIT.
	mov		r1, #0b1111111111011111
	cmp		r0, r1
	bne		chkMenuA
	ldr		r1, =menuChoice
	mov		r2, #1
	str		r2, [r1]
	b		endMenuPress

chkMenuA: @ A is pressed. Activate selected option.
	mov		r1, #0b1111111011111111
	cmp		r0, r1
	bne		menuLp
	ldr		r1, =menuChoice
	ldr		r2, [r1]
	cmp		r2, #0
	beq		menuInitGame
	cmp		r2, #1
	beq		Quit
	b		endMenuPress

menuInitGame:
	bl		ResetGame
	b		gameLp


endMenuPress:
	pop		{pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ GamePress                         @
@ >r0: SNES Input                   @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
GamePress: @ Performs actions for the game based on SNES input.

	push		{r4, lr}
	mov		r4, r0				@ Create a copy of SNES input that isn't altered to check inputs. (Bitclears, etc.)


inputOnOver: @ If the game is over, and input is received, return to main menu.
	@ If there's no input, skip input checking. (This results in the game resetting when there's no input???)
	mov		r0, r4
	mov		r1, #65535
	cmp		r0, r1
	beq		endGamePress

	@ Otherwise, there is input. If lives = 0, then return to menu on input.
	ldr		r0, =gameState
	ldr		r1, [r0]
	cmp		r1, #0
	bne		menuLp

checkGameL: @ L is pressed. Move the paddle left (if valid). If A is also pressed, move it faster.
	mov		r0, r4
	mov		r1, #1
	lsl		r1, #6
	and		r0, r0, r1
	cmp		r0, #0

	bne		checkGameR
	ldreq		r0, =paddle
	moveq		r1, #1
	streq		r1, [r0, #8]

	mov		r0, r4
	mov		r1, #1
	lsl		r1, #8
	and		r0, r0, r1
	cmp		r0, #0

	bne		checkGameB
	ldreq		r0, =paddle
	moveq		r1, #2
	streq		r1, [r0, #12]


checkGameR: @ R is pressed. Move the paddle right (if valid). If A is also pressed, move it faster.
	mov		r0, r4
	mov		r1, #1
	lsl		r1, #7
	and		r0, r0, r1
	cmp		r0, #0

	bne		checkGameB
	ldreq		r0, =paddle
	moveq		r1, #2
	streq		r1, [r0, #8]

	mov		r0, r4
	mov		r1, #1
	lsl		r1, #8
	and		r0, r0, r1
	cmp		r0, #0

	bne		checkGameB
	ldreq		r0, =paddle
	moveq		r1, #2
	streq		r1, [r0, #12]


checkGameB: @ B is pressed. If ball is inert (0), then set it to 1. Otherwise, check the next button.
	mov		r0, r4				@ Retrieve copy of SNES input.
	mov		r1, #1				@ Move and shift a '1' bit to button being checked.
	lsl		r1, #0
	and		r0, r0, r1			@ Wipe everything but button being check to '0'.
	cmp		r0, #0				@ If the button being checked was '0', then it is '0' now alongside
							@ everything else. Otherwise, it is '1', and therefore greater than 0.
	bne		checkGameStart			@ If != 0, button wasn't pressed. Branch out. Else, perform action.
	ldr		r1, =movingPixel
	ldr		r2, [r1, #16]
	cmp		r2, #0
	moveq		r2, #1
	streq		r2, [r1, #16]
	@ Fall to next button check.


checkGameStart: @ Start is pressed. Stays of game screen, but resets game state.
	mov		r0, r4
	mov		r1, #1
	lsl		r1, #3
	and		r0, r0, r1
	cmp		r0, #0
	bne		checkGameSelect
	bl		ResetGame
	bl		ResetRound


checkGameSelect: @ Select is pressed. Return to main menu. (and reset game state). Last button to be checked.
	mov		r0, r4
	mov		r1, #1
	lsl		r1, #2
	and		r0, r0, r1
	cmp		r0, #0
	beq		menuLp


endGamePress:
	pop		{r4, pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ ResetGame                         @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ResetGame: @ Resets the game state. (Map, score, lives, etc.)

	push		{r4, lr}

	@ Reset game data.
	ldr		r0, =playerLives	@ Reset player lives.
	mov		r1, #3
	str		r1, [r0]
	ldr		r0, =playerScore	@ Reset player score.
	mov		r1, #0
	str		r1, [r0]
	ldr		r0, =gameState		@ Re-activate game.
	mov		r1, #0
	str		r1, [r0]

	@ Reset game map.
	ldr		r0, =gameMap
	ldr		r1, =defaultMap
	mov		r4, #0
resetLoop:
	ldr		r2, [r1], #4
	str		r2, [r0], #4
	add		r4, #1
	cmp		r4, #420
	blt		resetLoop

	pop		{r4, pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ ResetRound                        @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ResetRound: @ Resets round information. (Ball/Paddle conditions.)

	push		{r4, lr}
	
	@ Reset ball conditions.
	ldr		r0, =movingPixel
	mov		r1, #320		@ Reset X Position.
	str		r1, [r0]
	mov		r1, #607		@ Reset Y Position.
	str		r1, [r0, #4]		
	mov		r1, #0			@ Reset Direction.
	str		r1, [r0, #16]

	@ Reset paddle conditions.
	ldr		r0, =paddle
	mov		r1, #288		@ Reset PaddleL X Position.
	str		r1, [r0]
	mov		r1, #320		@ Reset PaddleR X Position.
	str		r1, [r0, #4]
	mov		r1, #0			@ Reset Paddle Direction.
	str		r1, [r0, #8]
	mov		r1, #1			@ Reset Paddle Speed.
	str		r1, [r0, #12]

	pop		{r4, pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ DrawBall                          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
DrawBall: @ Draws the ball on-top the current game map.

	push 		{r4, r5, r6, r7, r8, r9, lr}

	ldr		r4, =movingPixel
	ldr		r5, [r4]		@ Ball X-Position loaded in.
	ldr		r6, [r4, #4]		@ Ball Y-Position loaded in.
	ldr		r7, =fieldNewBall	@ A 4x4 Sprite.

	sub		r5, #2
	sub		r6, #2

	add		r8, r5, #4
	add		r9, r6, #4

drawBallX:

	drawBallY:
		mov	r0, r5
		mov	r1, r6
		ldr	r2, [r7], #4
		bl	DrawPixel

		add	r5, #1
		cmp	r5, r8
		blt	drawBallY

	add	r6, #1
	cmp	r6, r9
	sublt	r5, #4
	blt	drawBallX

	pop		{r4, r5, r6, r7, r8, r9, pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ DrawPaddle                        @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
DrawPaddle: @ Draws the paddle on-top the current game map.

	push		{r4, r5, r6, r7, r8, r9, lr}

	@ Works like a specialized re-write of the DrawTile method.
	@ In this one, instead of in-putting tile coordinates, put in pixel coordinates,
	@ according to the paddle structure.
	ldr		r4, =paddle
	ldr		r5, [r4]		@ PaddleL X-Position loaded in.
	ldr		r6, [r4, #16]		@ PaddleL Y-Position loaded in.
	ldr		r7, =fieldPaddleL	@ PaddleL Sprite loaded in.

	add		r8, r5, #32		@ End range of drawing the paddle. (X)
	add		r9, r6, #32		@ End range of drawing the paddle. (Y)


drawPLX: @ Do the first portion of the paddle.
	
	drawPLY:
		mov	r0, r5
		mov	r1, r6
		ldr	r2, [r7], #4
		bl	DrawPixel

		add	r5, #1
		cmp	r5, r8
		blt	drawPLY

	add	r6, #1
	cmp	r6, r9
	sublt	r5, #32
	blt	drawPLX



	ldr		r5, [r4, #4]		@ PaddleL X-Position loaded in.
	sub		r6, #32
	ldr		r7, =fieldPaddleR	@ PaddleL Sprite loaded in.
	add		r8, r5, #32		@ End range of drawing the paddle. (X)

drawPRX: @ Do the second portion of the paddle.
	
	drawPRY:
		mov	r0, r5
		mov	r1, r6
		ldr	r2, [r7], #4
		bl	DrawPixel

		add	r5, #1
		cmp	r5, r8
		blt	drawPRY

	add	r6, #1
	cmp	r6, r9
	sublt	r5, #32
	blt	drawPRX
	

	pop		{r4, r5, r6, r7, r8, r9, pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ UpdatePaddle                      @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
UpdatePaddle: @ Updates the position of the paddle in memory. (Drawn in a subroutine called by game loop.)
	
	push		{r4, r5, r6, lr}

	mov		r5, #0
	mov		r6, #4

paddleAgain:
	ldr		r4, =paddle

	@ Check the direction of the paddle.
	ldr		r0, [r4, #8]
	cmp		r0, #0
	beq		endUpdatePaddle
	cmp		r0, #1
	beq		movePaddleLeft
	cmp		r0, #2
	beq		movePaddleRight
	b		endUpdatePaddle

movePaddleLeft: @ Paddle is moving. Update depending on whether A is being held or not.
	@ Check if paddle if within boundaries.
	ldr		r0, [r4]
	ldr		r1, =boundaries
	ldr		r2, [r1, #4]
	cmp		r0, r2
	ble		endUpdatePaddle
	
	@ Move paddle left 1px.
	ldr		r0, [r4]
	sub		r0, #2
	str		r0, [r4]
	ldr		r0, [r4, #4]
	sub		r0, #2
	str		r0, [r4, #4]

	@ If ball is inert, move it too.
	ldr		r0, =movingPixel
	ldr		r1, [r0, #16]
	cmp		r1, #0
	bne		movePaddleLeftA
	ldr		r1, [r0]
	sub		r1, #2
	str		r1, [r0]

movePaddleLeftA:
	@ If A is active, do it again before the next gameLp iteration.
	ldr		r0, [r4, #12]
	cmp		r0, #2
	subeq		r0, #1
	streq		r0, [r4, #12]
	beq		movePaddleLeft

	add		r5, #1
	cmp		r5, r6
	blt		movePaddleLeft
	

movePaddleRight: @ Paddle is moving. Update depending on whether A is being held or not.
	@ Check if paddle if within boundaries.
	ldr		r0, [r4, #4]
	add		r0, #31
	ldr		r1, =boundaries
	ldr		r2, [r1, #8]
	cmp		r0, r2
	bge		endUpdatePaddle

	@ Move paddle right 1px.
	ldr		r0, [r4]
	add		r0, #1
	str		r0, [r4]
	ldr		r0, [r4, #4]
	add		r0, #1
	str		r0, [r4, #4]

	@ If ball is inert, move it too.
	ldr		r0, =movingPixel
	ldr		r1, [r0, #16]
	cmp		r1, #0
	bne		movePaddleLeftB
	ldr		r1, [r0]
	add		r1, #1
	str		r1, [r0]


movePaddleLeftB:
	@ If A is active, do it again before the next gameLp iteration.
	ldr		r0, [r4, #12]
	cmp		r0, #2
	subeq		r0, #1
	streq		r0, [r4, #12]
	beq		movePaddleRight


	add		r5, #1
	cmp		r5, r6
	blt		movePaddleRight

endUpdatePaddle:
	ldr		r0, =paddle
	mov		r1, #0
	str		r1, [r4, #8]
	mov		r1, #1
	str		r1, [r4, #12]


	pop		{r4, r5, r6, pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ UpdateBall                        @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
UpdateBall: @ Checks the direction of ball and updates its position.

	push		{r4, r5, r6, lr}

	@ Changes the speed of the game.
	@ The higher the number in r6, the more update calculations
	@ are performed before it returns to the main game loop.
	mov		r5, #0
	mov		r6, #4

ballAgain:	
	ldr		r4, =movingPixel
	ldr		r0, [r4, #16]


	@ If Ball = Inert, check collision right away.
	cmp			r0, #0
	bleq		CheckWallCollision

	
	@ If Ball = NE, move up and right 1 px.
	cmp			r0, #1
	ldreq		r3, [r4]
	addeq		r3, #1
	streq		r3, [r4]
	ldreq		r1, [r4, #4]
	subeq		r1, #1
	streq		r1, [r4, #4]
	bleq		CheckBrickCollision
	bleq		CheckWallCollision

	@ If Ball = NW, move up and left 1 px.
	cmp			r0, #2
	ldreq		r3, [r4]
	subeq		r3, #1
	streq		r3, [r4]
	ldreq		r1, [r4, #4]
	subeq		r1, #1
	streq		r1, [r4, #4]
	bleq		CheckBrickCollision
	bleq		CheckWallCollision
	
	@ If Ball = SW, move down and left 1 px.
	cmp			r0, #3
	ldreq		r3, [r4]
	subeq		r3, #1
	streq		r3, [r4]
	ldreq		r1, [r4, #4]
	addeq		r1, #1
	streq		r1, [r4, #4]
	bleq		CheckBrickCollision
	bleq		CheckWallCollision

	@ If Ball = SE, move down and right 1 px.
	cmp			r0, #4
	ldreq		r3, [r4]
	addeq		r3, #1
	streq		r3, [r4]
	ldreq		r1, [r4, #4]
	addeq		r1, #1
	streq		r1, [r4, #4]
	bleq		CheckBrickCollision
	bleq		CheckWallCollision

	add		r5, #1
	cmp		r5, r6
	blt		ballAgain


	pop 		{r4, r5, r6, pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ AddScore                          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@	
AddScore: @ A subroutine that adds score using local variables. This is because brick collision occupies all registers.
	
	push		{r4, r5, lr}

	ldr	r4, =playerScore
	ldr	r5, [r4]
	add	r5, #1
	str	r5, [r4]	

	pop		{r4, r5, pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CheckPaddleCollision              @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
CheckPaddleCollision: @ Ensures the ball bounces off the paddle.

	push		{r4, r5, r6, lr}

	ldr		r4, =paddle
	ldr		r5, =movingPixel

	@ldr		r0, [r5, #16]
	@cmp		r0, #0
	@beq		chkPCEnd


	
chkPLSC: @ Compare Ball vs. Left (Short) Side of Paddle
	ldr		r0, [r4]		@ Paddle X
	ldr		r1, [r5]		@ Ball X
	cmp		r1, r0
	bne		chkPLC
	ldr		r0, [r4, #16]		@ Paddle Y
	ldr		r1, [r5, #4]		@ Ball Y
	cmp		r1, r0
	blt		chkPLC
	add		r0, #16
	cmp		r1, r0
	bgt		chkPLC
	mov		r0, #2
	str		r0, [r5, #16]
	b		chkPCEnd


	
chkPLC: @ Compare Ball vs. Left Side of Paddle
	ldr		r0, [r4, #16]		@ Paddle Y
	ldr		r1, [r5, #4]		@ Ball Y
	cmp		r1, r0
	blt		chkPRC
	add		r0, #16
	cmp		r1, r0
	bgt		chkPRC
	ldr		r0, [r4]		@ Paddle X
	ldr		r1, [r5]		@ Ball X
	cmp		r1, r0
	blt		chkPRC
	add		r0, #32
	cmp		r1, r0
	bgt		chkPRC

	@ Check conditions: Ball hits paddle SE, SW.
	mov		r0, #2
	str		r0, [r5, #16]

	b		chkPCEnd


	
chkPRC: @ Compare Ball vs. Right Side of Paddle
	ldr		r0, [r4, #16]		@ Paddle Y
	ldr		r1, [r5, #4]		@ Ball Y
	cmp		r1, r0
	blt		chkPRSC
	add		r0, #16
	cmp		r1, r0
	bgt		chkPRSC
	ldr		r0, [r4]		@ Paddle X
	ldr		r1, [r5]		@ Ball X
	add		r0, #32
	cmp		r1, r0
	blt		chkPRSC
	add		r0, #32
	cmp		r1, r0
	bgt		chkPRSC

	@ Check conditions: Ball hits paddle SE, SW.
	mov		r0, #1
	str		r0, [r5, #16]
	b		chkPCEnd


	
chkPRSC: @ Compare Ball vs. Right (Short) Side of Paddle
	ldr		r0, [r4]		@ Paddle X
	add		r0, #64
	ldr		r1, [r5]		@ Ball X
	cmp		r1, r0
	bne		chkPCEnd
	ldr		r0, [r4, #16]		@ Paddle Y
	ldr		r1, [r5, #4]		@ Ball Y
	cmp		r1, r0
	blt		chkPCEnd
	add		r0, #16
	cmp		r1, r0
	bgt		chkPCEnd 
	mov		r0, #1
	str		r0, [r5, #16]
	b		chkPCEnd


chkPCEnd:
	pop		{r4, r5, r6, pc}

		
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CheckWallCollision                @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@	
CheckWallCollision: @ Ensures the new ball position does not overlap into walls.

	push 	{r4, r5, lr}
	
	@ Check X-Related boundaries. (Left/Right)
	ldr		r4, =movingPixel
	ldr		r5, =boundaries
	
	@ X: Compare Ball vs. Left Boundary
	ldr		r0, [r4]
	ldr		r1, [r5, #4]
	cmp		r0, r1
	moveq	r0, #1					@ 1: Left Collision Detected
	beq		endChkWallCollision
	
	@ X: Compare Ball vs. Right Boundary
	ldr		r0, [r4]
	ldr		r1, [r5, #8]
	cmp		r0, r1
	moveq	r0, #2					@ 2: Right Collision Detected
	beq		endChkWallCollision
	
	@ Y: Compare Ball vs. Roof Boundary
	ldr		r0, [r4, #4]
	ldr		r1, [r5]
	cmp		r0, r1
	moveq	r0, #3					@ 3: Roof Collision Detected
	beq		endChkWallCollision
	
	@ Y: Compare Ball vs. Floor Boundary
	ldr		r0, [r4, #4]
	ldr		r1, [r5, #12]
	cmp		r0, r1
	bleq		ResetRound
	ldreq		r0, =playerLives
	ldreq		r1, [r0]
	subeq		r1, #1
	streq		r1, [r0]

endChkWallCollision:
	bl		UpdatePosition

endChkWall:
	pop		{r4, r5, pc}
	

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CheckBrickCollision               @
@ >r1: X-Direction (px)             @
@ >r3: Y-Direction (px)             @
@ <r0: Position			    @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@	
CheckBrickCollision:
	push	{r4-r10,lr}

	mov	r9, #32
	mov	r10, #80

	mov	r4, r1			@ X direction
	mov	r5, r3			@ Y direction

	udiv	r4, r9
	mul	r6, r4, r9
	sub	r6, r1, r6		@ r6 = X remainder

	udiv	r5, r9
	mul	r7, r5, r9
	sub	r7, r3, r7		@ r7 = Y remainder

	mul	r4, r10			@ y tile addr*80
	lsl	r5, #2			@ x tile addr*4
	add	r8, r4, r5 		@ gameMap Address

	ldr	r0, =gameMap		@ Loads gameMap
	ldr	r9, [r0, r8]		

	ldr	r3, =movingPixel	@ Loads movingPixel for direction of the ball
	ldr 	r1, [r3, #16]

	cmp	r9, #14			@ Checks if the ball hits a Red brick
	beq	checkRed

	cmp	r9, #13			@ Checks if the ball hits a Green brick
	beq	checkGreen

	cmp	r9, #12			@ Checks if the ball hits a Blue brick
	beq	checkBlue

	cmp	r9, #10			@ Ball continues if it hits a Black tile
	beq	endBrickCollision

	cmp	r9, #11			@ Ball continues if it hits a Wall tile
	beq	endBrickCollision

	b	endBrickCollision	@ Branch to end of subroutine


checkBlue:
	bl	AddScore
	sub	r9, #2			@ Turns Blue brick into a Black tile
	str	r9, [r0, r8]		@ Stores result into tile address in gameMap

	cmp	r1, #1			@ If ball position is NE branch
	beq	SeNw

	cmp	r1, #2			@ If ball position is NW branch
	beq	SwNe

	cmp	r1, #3			@ If ball position is SW branch
	beq	SeNw

	cmp	r1, #4			@ If ball position is SE branch
	beq	SwNe

	b	endBrickCollision
checkGreen:
	bl	AddScore

	sub	r9, #1			@ Turns a Green brick into a Blue brick
	str	r9, [r0, r8]

	cmp	r1, #1			
	beq	SeNw

	cmp	r1, #2
	beq	SwNe

	cmp	r1, #3
	beq	SeNw

	cmp	r1, #4
	beq	SwNe

	b	endBrickCollision
checkRed:
	bl	AddScore

	sub	r9, #1			@ Turns a Red brick into a Green brick
	str	r9, [r0, r8]

	cmp	r1, #1	@ NE
	beq	SeNw

	cmp	r1, #2	@ NW
	beq	SwNe

	cmp	r1, #3	@ SW
	beq	SeNw

	cmp	r1, #4	@ SE
	beq	SwNe

	b	endBrickCollision

SeNw:

	mov	r4, #2			@ NW
	mov	r5, #4			@ SE

	@ If Y-Remainder <= 3, ball direction is NW
	cmp	r6, #3
	strle	r4, [r3, #16]

	@ If X-Remainder <= 3, ball direction is NW
	cmp	r7, #3
	strle	r4, [r3, #16]

	@ If Y-Remainder >= 29, ball direction is SE
	cmp	r6, #29
	strge	r5, [r3, #16]

	@ If X-Remainder >= 29, ball direction is SE
	cmp	r7, #29
	strge	r5, [r3, #16]

	b	endBrickCollision

SwNe:
	mov	r4, #1
	mov	r5, #3

	@ If X-Remainder <= 3, ball direction is SW
	cmp	r7, #3
	strle	r5, [r3, #16]

	@ If Y-Remainder <= 3, ball direction is NE
	cmp	r6, #3
	strle	r4, [r3, #16]

	@ If X-Remainder >= 29, ball direction is SW
	cmp	r6, #29
	strge	r5, [r3, #16]

	@ If Y-Remainder >= 29, ball direction is NE
	cmp	r7, #29
	strge	r4, [r3, #16]
	b	endBrickCollision

	
endBrickCollision: @ End point of subroutine
	pop	{r4-r10, pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ UpdatePosition                    @
@ >r0: Ball position when colliding.@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
UpdatePosition:

	push		{r4, lr}
	
	ldr			r4, =movingPixel
	
	cmp			r0, #1
	beq			leftColl
	cmp			r0, #2
	beq			rightColl
	cmp			r0, #3
	beq			roofColl
	cmp			r0, #4
	beq			floorColl
	b			endUpdatePos
	
rightColl:
	ldr			r0, [r4, #16]
	cmp			r0, #1					@ If NE (1) -> NW (2)
	moveq		r1, #2
	streq		r1, [r4, #16]
	beq			endUpdatePos
	cmp			r0, #4					@ Elif SE (4) -> SW (3)
	moveq		r1, #3
	streq		r1, [r4, #16]
	beq			endUpdatePos

leftColl:
	ldr			r0, [r4, #16]
	cmp			r0, #2					@ If NW (2) -> NE (1)
	moveq		r1, #1
	streq		r1, [r4, #16]
	beq			endUpdatePos
	cmp			r0, #3					@ Elif SW (3) -> SE (4)
	moveq		r1, #4
	streq		r1, [r4, #16]
	beq			endUpdatePos

roofColl:
	ldr			r0, [r4, #16]
	cmp			r0, #1					@ If SE (4) -> NE (1)
	moveq		r1, #4
	streq		r1, [r4, #16]
	beq			endUpdatePos
	cmp			r0, #2					@ Elif SW (3) -> NW (2)
	moveq		r1, #3
	streq		r1, [r4, #16]
	beq			endUpdatePos

floorColl:
	ldr			r0, [r4, #16]
	cmp			r0, #4					@ If NE (1) -> SE (4)
	moveq		r1, #1
	streq		r1, [r4, #16]
	beq			endUpdatePos
	cmp			r0, #3					@ Elif NW (2) -> SW (3)
	moveq		r1, #2
	streq		r1, [r4, #16]
	beq			endUpdatePos

endUpdatePos:	
	pop			{r4, pc}


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Quit                              @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Quit:	@ A self-calling branch that denotes end of program.
	ldr	r0, =test3
	bl	printf
quitLp:
	b		quitLp
