[BITS 16]
[ORG 0]

start:
	mov ax, 07C0h		; Set up 4K stack space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096
	
	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax

	call cls
	call CursorOff
	
	mov si, _Intro
	call print_string
	mov si, _Version
	call print_string
	
	call wait1s
	
	mov ax,0200h
	mov es,ax
	
	jmp 0200h
	
	jmp $			; Jump here - infinite loop!
	cli
	mov si, _Err1
	call print_string
	hlt ;emergency stop.
	

	_Intro db 'ST3 OS Bootloader version: ', 0
	_Version db 'DEV-0.0.03', 13, 10 , 0
	dot db '.' ,0
	equal db '=',0
	_Done db 'Done!', 13, 10, 0
	_Err1 db 13, 10, 'WARNING: Code overrun detected, entering halt (hlt) mode, error code: 1.', 0

cls:
	mov ah, 0x00
	mov al, 0x03  ; text mode 80x25 16 colors
	int 10h
	ret

wait1s:
	MOV     CX, 0FH
	MOV     DX, 4240H
	MOV     AH, 86H
	INT     15H

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


TIMES 502 - ($ - $$) db 0 ;fill resting bytes with zero
DW 0xAA55 ;end of bootloader (2 bytes)