[org 0x07c00]
[bits 16]

section code

.init:
    mov eax, 0xb800
    mov es, eax
    mov eax, 0
    mov ebx, 0; index of character we are printing
    mov ecx, 0; actual address of character on the screen
    mov dl, 0; actual value that we are printing to the screen

    
.clear:
    mov byte [es:eax], 0
    inc eax
    mov byte [es:eax], 0x70
    inc eax
    cmp eax, 2*25*80
    jl .clear

mov eax, welcome
mov ecx, 3*2*80
call .print



.print:
    mov dl, byte [eax+ebx]
    cmp dl, 0
    je .print_end

    mov byte [es:ecx], dl 
    inc ebx
    inc ecx
    inc ecx
    jmp .print

.print_end:
    ret

.switch:
    cli; turn off interrupts
    lgdt [gdt_descriptor]; load the gdt table
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax; make the switch

    jmp protected_start

welcome: db 'Welcome BroOS', 0

[bits 32]
protected_start:
   mov ax, data_seg 
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp
    jmp $

gdt_begin:
gdt_null_descriptor:
    dd 0x00
    dd 0x00
gdt_code_seg:
    dw 0xffff
    dw 0x00
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00
gdt_data_seg:
    dw 0xffff
    dw 0x00
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_begin -1
    dd gdt_begin

code_seg equ gdt_code_seg - gdt_begin
data_seg equ gdt_data_seg - gdt_begin

times 510 - ($ - $$) db 0x00 ; fills the file with 0s, to make right size

db 0x55
db 0xaa