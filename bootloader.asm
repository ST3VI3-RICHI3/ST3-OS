	BITS 16

start:
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096
	
	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax

	call cls
	;call CursorOff
	
	mov si, _Intro
	call print_string
	mov si, _Version
	call print_string

	mov si, _Load
	call print_string
	mov si, _Loadinit
	call print_string
	
	mov ah, 0x02
	mov bh, 0x00
	mov dh, 0x01
	mov dl, 0x9
	int 10h
	
	mov si, equal
	call print_string
	
	mov si, _ProtecMode
	call print_string
	
	mov ah, 89h
	int 15
	
	jmp $			; Jump here - infinite loop!


	_Intro db 'ST3 OS Bootloader version: ', 0
	_Version db 'DEV-0.0.02', 13, 10 , 0
	_Load db 'Loading [           ]' ,0
	_Loadinit db 13,10,'Initalizing load.',0
	_ProtecMode db 13, 10, 13, 10, 'Enter protected mode', 0
	dot db '.' ,0
	equal db '=',0
	straightline db '| ',0
	forwardslash db '/' ,0
	horozontalline db '-' ,0
	backslash db '\' ,0
	_Done db 'Done!', 13, 10, 0

cls:
	mov ah, 0x00
	mov al, 0x03  ; text mode 80x25 16 colours
	int 10h
	ret

CursorOff:
	pushf
	push eax
	push edx
 
	mov dx, 0x3D4
	mov al, 0xA	; low cursor shape register
	out dx, al
 
	inc dx
	mov al, 0x20	; bits 6-7 unused, bit 5 disables the cursor, bits 0-4 control the cursor shape
	out dx, al
 
	pop edx
	pop eax
	popf
	ret

CursorOn:
	mov  ah, 1
	mov  cx, 4          ;◄■■ BIG CURSOR.
	int  10h
	ret

print_string:			; Routine: output string in SI to screen
	mov ah, 0Eh		; int 10h 'print char' function

.repeat:
	lodsb			; Get character from string
	cmp al, 0
	je .done		; If char is zero, end of string
	int 10h			; Otherwise, print it
	jmp .repeat

.done:
	ret


	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signature