[org 0x00]
[bits 16]

section code

.init:
    mov eax, 0x07c0
    mov ds, eax
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

mov eax, text
mov ecx, 3*2*80
push .end
call .print

.end
    mov byte [es:0x00], 'L'
    jmp $

.print:
    mov dl, byte [eax+ebx]
    cmp dl, 0
    je .print_end

    mov byte [es:ecx], dl 
    inc ebx
    inc ecx
    inc ecx
    jmp .print

.print_end
    ret


text: db 'Hello world!', 0
text1: db 'Just another Text', 0


times 510 - ($ - $$) db 0x00 ; fills the file with 0s, to make right size

db 0x55
db 0xaa