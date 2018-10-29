@echo off

"C:\Users\%username%\AppData\Local\bin\NASM\NASM.exe" -f bin "%~dp0\bootloader.asm" -o "%~dp0\bootloader.iso"
"C:\Program Files\qemu\qemu-system-x86_64.exe" "%~dp0\bootloader.iso"