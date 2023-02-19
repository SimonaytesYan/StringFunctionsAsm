.model tiny
.code

org 100h

Start:
    push ds
    pop es
    lea si, s1
    lea di, s2
    call StrCmp
    
    mov bx, 0b800h
    mov es, bx

    mov bx, 160d*5 + 80d
    mov ch, 1
    call OutputNum10

    ;mov bx, 0b800h
    ;mov es, bx

    ;mov bx, 160d*5 + 80d
    ;mov ch, 1
    ;mov bp, 30
    ;lea si, s4
    ;call OutputStr
    ret


include STRFUNC.ASM
include SMALLIB.ASM

.data
    s1 db '0123656789', 0               ;length = 10
    s2 db '0123456789', 0               ;length = 10
    s3 db '4215dgajjg33tkaGOFdpsafd', 0 ;length = 24
    s4 db 30 dup(0)

end Start