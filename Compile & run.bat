@echo off

"C:\Users\Alex\AppData\Local\bin\NASM\NASM.exe" -f bin "C:\Users\Alex\Desktop\ST3OS\bootloader.asm" -o "C:\Users\Alex\Desktop\ST3OS\bootloader.iso"
"C:\Program Files\qemu\qemu-system-x86_64.exe" "C:\Users\Alex\Desktop\ST3OS\bootloader.iso"