print_str:
	pusha
	print_loop:
		mov al, [si]
		cmp al, 0
		jne print_char
		popa
		ret

print_char:
	mov ah, 0x0e
	int 0x10
	add si, 1
	jmp print_loop

print_hex:
	mov si, _HEX_TEMPLATE

	;Char 1:
	mov bx, dx
	shr bx, 12 ;Shift right by 12
	mov bx, [bx + _HEX_TABLE]
	mov [_HEX_TEMPLATE + 2], bl ;Combine the two and store the result of the shift + 2 from the str.

	;Char 2:
	mov bx, dx
	shr bx, 8
	and bx, 0x000f
	mov bx, [bx + _HEX_TABLE]
	mov [_HEX_TEMPLATE + 3], bl

	;Char 3:
	mov bx, dx
	shr bx, 4
	and bx, 0x000f
	mov bx, [bx + _HEX_TABLE]
	mov [_HEX_TEMPLATE + 4], bl
	
	;Char 4:
	mov bx, dx
	and bx, 0x000f
	mov bx, [bx + _HEX_TABLE]
	mov [_HEX_TEMPLATE + 5], bl

	call print_str
	ret
_HEX_TEMPLATE: db "0x****", 0x0a, 0xd, 0
_HEX_TABLE: db "0123456789abcedf"