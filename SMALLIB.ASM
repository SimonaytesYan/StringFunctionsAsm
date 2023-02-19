.code
locals __

;-------------------------------------------
;Get number from cmd
;
;Expects:	label named buffer
;
;Entry:		None
;
;Output:	ax - number
;
;Destroys:	cx, dx, ax, di
;
;-------------------------------------------
GetNum	proc
	
	lea dx, buffer
	mov ah, 0ah
	int 21h			;get number from cml
	
	xor cx, cx
	mov cl, buffer[1]	;get length of number

	xor ax, ax
	mov di, 10d	
	mov si, 2h
	
	__Next:	
		mul di				;ax = ax*10
		mov dl, si + buffer	;put in dl next simbol
		sub dl, '0'			;convert simbol to number
		
		add ax, dx		;ax += dh
		
		inc si
		loop __Next
	ret
	endp

;-------------------------------------------

;-------------------------------------------
;Put number in dec form in videomem
;
;Expects:	es->Videomem
;
;Entry:		bx - offset in videomem
;			ax - number for output
;			ch - color atr for output
;
;Output:	None
;
;Destroys:	ax, dx, bx, di, si
;
;-------------------------------------------
OutputNum10	proc
	mov si, 5        		;max length of number
	mov di, 10d	

	__next:
		xor dx, dx			;dx = 0
		div di				;ax = dxax/10 
							;dx = ax%10
	
		add dl, '0'			;make symbol from num
		mov dh, ch			;set color
		
		mov word ptr es:[bx-2], dx	;put symbol in vmem
		sub bx, 2

		dec si 
		cmp si, 0			
		jne __next				;for(int si = 5; si != 0; si--)
	ret
	endp

;----------------------------------------------
;Put number in hex form in videomem
;
;Expects:	es->VideoMem
;
;Entry:		bx - offset in videomem
;			ax - number to output
;			dh - color atr to output
;
;Output:	None
;
;Destroys:	ax, dx, bx, cx, si
;
;----------------------------------------------
OutputNum16	proc
	mov cx, 4				;length of hex number
	__Next:					;do
		mov si, 000fh
		and si, ax					;get new number

		mov dl, int_to_char_hex[si] ;make char from int

		mov word ptr es:[bx-2], dx	;put symb in vmem
		sub bx, 2					;bx -= 2

		ror ax, 4
		loop __Next
		
	ret
	endp

.data 
	int_to_char_hex	db "0123456789ABCDEF"

.code
;----------------------------------------------

;----------------------------------------------
;Put number in binary form in videomem
;
;Expects:	es->VideoMem
;
;Entry: 	bx - offset in videomem
;		ax - number to output
;		dh - color atr to output
;
;Output: 	None
;
;Destroys:	ax, bx,cx, dl
;----------------------------------------------
OutputNum2	proc
	
	mov cx, 10h		;set number of bits in number

	__Next:
		mov dl, 1
		and dl, al			;get last number
		add dl, '0'			;make char from number

		ror ax, 1
		mov word ptr es:[bx], dx	;print 1 or 0

		add bx, 2
		loop __Next
	
	ret	
	endp
;----------------------------------------------

.data 
	buffer db 5, ?, 5 dup(' ')

.code

;------------------------------------------
;DrawFrame
;------------------------------------------
;Expects: es->videomemory
;
;Entry: bx - offset in vmem
;		ch - height of frame
;		cl - weight of fram
;		dh - color atr
;
;Output: None
;
;Destroys: bx, ax, dx,
;------------------------------------------

DrawFrame	proc

	xor ah, ah	;y offset
	xor al, al	;x offset
	
	mov dl, frame		   ;left upper corner
	mov word ptr es:[bx], dx
	add bx, 2
	
	mov dl, frame[4]	;horisontal border

	next_top: 				;draw top
		mov word ptr es:[bx], dx

		inc al
		add bx, 2
		cmp al, cl
		jl next_top
	
	mov dl, frame[1]		;right top corner
	mov word ptr es:[bx], dx

	add bx, 160d			;new line
	mov dl, frame[5]		;vertical border

	next_right: 			;draw right
		mov word ptr es:[bx], dx

		inc ah
		add bx, 160d
		cmp ah, ch
		jl next_right
	
	mov dl, frame[3]		;right bottom corner
	mov word ptr es:[bx], dx
	sub bx, 2d

	mov dl, frame[4]
	
	next_bottom:			;draw bottom
		mov word ptr es:[bx], dx

		dec al
		sub bx, 2d
		cmp al, 0
		ja next_bottom
	
	mov dl, frame[2]		;left bottom corner
	mov word ptr es:[bx], dx
	sub bx, 160d

	mov dl, frame[5]		;vertical border

	next_left:				;draw left
		mov word ptr es:[bx], dx

		dec ah
		sub bx, 160d
		cmp ah, 0
		ja next_left

	ret
	endp

.data 
frame db 0c9h, 0bbh, 0c8h, 0bch, 0cdh, 0bah
;        _      _      |_    _|   =   ||
;       |        |

.code

;------------------------------------------------
;Put text form var in vmem
;
;Expects: es->videomem
;
;Inputs: bx - offset
;		 ch - color atribut
;		 si - pointer to variable with text
;		 bp - length of string in var
;
;Output: None
;
;Destroys: si, bx, bp, cl
;------------------------------------------------

OutputStr	proc

	add bp, si
	__next:										;
		mov cl, [si]							;
		mov word ptr es:[bx], cx				;
		add bx, 2								;
		inc si									;

		cmp si, bp   							;
		jne __next								;

	ret
	endp
;------------------------------------------------
