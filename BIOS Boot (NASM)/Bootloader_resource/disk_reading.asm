disk_read_usb:
	pusha
	mov ah, 0x02
	mov dl, 0x00 ;Drive number, Selected drive: 0 = floppy (inc. USB, CD, etc.), 80 = Hard disk (NOT FLASH DRIVE!!!)
	mov ch, 0
	mov dh, 0
	
	;Below is prep for reading, it sets the memory location 512 bytes from orig (0x7c00)
	push bx
	mov bx, 0
	mov es, bx
	pop bx
	mov bx, 0x7c00 + 0x200

	int 0x13

	jc disk_err_usb
	popa
	ret

disk_read_hdd:
	pusha
	mov ah, 0x02
	mov dl, 0x80 ;Drive number, Selected drive: 0 = floppy (inc. USB, CD, etc.), 80 = Hard disk (NOT FLASH DRIVE!!!)
	mov ch, 0
	mov dh, 0
	
	;Below is prep for reading, it sets the memory location 512 bytes from orig (0x7c00)
	push bx
	mov bx, 0
	mov es, bx
	pop bx
	mov bx, 0x7c00 + 0x200
	
	int 0x13

	jc disk_err
	popa
	ret

disk_err:
	call disk_read_usb
	ret

disk_err_usb:
	mov si, _Read_err
	call print_str

	hlt ;Halts execution
