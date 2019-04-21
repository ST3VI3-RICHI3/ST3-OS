MBALIGN  equ  1 << 0
MEMINFO  equ  1 << 1
MAGIC    equ  0x1BADB002
FLAGS    equ  MBALIGN | MEMINFO
CHECKSUM equ -(MAGIC + FLAGS)
section .multiboot
align 4
    dd MAGIC
    dd FLAGS
    dd CHECKSUM
section .bss
align 16
stack_bottom:
resb 16384
stack_top:
section .text
global _start:function (_start.end - _start)
_start:
    mov esp, stack_top
    extern kernel_main
    call kernel_main
    cli
.e: hlt
    jmp .e
.end: