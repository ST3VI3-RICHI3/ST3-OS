[bits 16]
[org 0x7c00]

section .text
	global Main

Main:
cli
jmp 0x00:Segment_Zero
Segment_Zero:
	xor ax, ax
	mov ss, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov sp, Main
	cld
sti

push ax
xor ax, ax
int 0x13
pop ax

mov al, 1 ;Sectors to read
mov cl, 2 ;Sector to read, bootloader is 1, not 0!
call disk_read_hdd

jmp S2_Test

jmp $

_Read_err: db "There was an error reading from disk, halting to prevent disk damage.", 0
_S2_Test: db "loaded second sector.", 0

%include "./Bootloader_resource/text_print.asm"
%include "./Bootloader_resource/disk_reading.asm"

times 510 - ($ - $$) db 0
dw 0xaa55

S2_Test:
	mov si, _S2_Test
	call print_str
times 512 db 0
