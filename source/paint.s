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


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ CODE SECTION                               @
@ Contains subroutines related to drawing.   @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.section	.text


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ DrawTile                          @
@ >r0: X Coordinate (Tile)          @
@ >r1: Y Coordinate (Tile)          @
@ >r2: Asciz Address (Top)          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.global DrawTile
DrawTile: @ Draws a tile on the screen by repeatedly calling DrawPixel.

	push	{r4, r5, r6, r7, r8, lr}
	
	@ Store original contents as local variables.
	mov		r4, r0	
	mov		r5, r1
	mov		r6, r2
	
	@ Multiply tile coordinates by 32 for pixel coordinates.
	lsl		r4, #5
	lsl		r5, #5
	
	@ Pixel drawing counters. Original pixel coordinates + 31.
	add		r7, r4, #32
	add		r8, r5, #32
	
outerTileLoop: @ Repeating loop that calls DrawPixel. (X)

	innerTileLoop: @ Repeating loop that calls DrawPixel. (Y)
	
		@ Draw the pixel. Post increment when finished to next.
		mov		r0, r4
		mov		r1, r5
		ldr		r2, [r6], #4
		bl		DrawPixel
		
		add		r4, #1
		cmp		r4, r7
		blt		innerTileLoop
	
	add		r5, #1
	cmp		r5, r8
	sublt		r4, #32
	blt		outerTileLoop
	
	pop 	{r4, r5, r6, r7, r8, pc}
	

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ DrawPixel                         @
@ >r0: X Coordinate (Pixel)         @
@ >r1: Y Coordinate (Pixel)         @
@ >r2: Colour Address               @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.global DrawPixel
DrawPixel: @ Draws a pixel on the screen. Snipped from lab examples.

	push	{r4, r5}

	offset	.req	r4

	ldr		r5, =frameBufferInfo	

	@ offset = (y * width) + x
	ldr		r3, [r5, #4]			@ r3 = width
	mul		r1, r3
	add		offset,	r0, r1
	
	@ offset *= 4 (32 bits per pixel/8 = 4 bytes per pixel)
	lsl		offset, #2

	@ store the colour (word) at frame buffer pointer + offset
	ldr		r0, [r5]				@ r0 = frame buffer pointer
	str		r2, [r0, offset]

	pop		{r4, r5}
	bx		lr
