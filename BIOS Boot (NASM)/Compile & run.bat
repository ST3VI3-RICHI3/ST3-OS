@echo off

"C:\Users\%username%\AppData\Local\bin\NASM\NASM.exe" -f bin "%~dp0\includes.asm" -o "%~dp0\os.bin"
"C:\Program Files\qemu\qemu-system-x86_64.exe" "%~dp0\os.bin"