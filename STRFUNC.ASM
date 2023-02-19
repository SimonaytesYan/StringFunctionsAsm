.code
locals __

;-------------------------------------
;StrLen
;   count length of str excluding '\0'
;------------------------------------
;EXPECTS:   None
;INPUTS:    es - segment in which string located
;           di - offset  start of string
;
;OUTPUT:    ax - length of string
;
;DESTROYS:  df, si
;-------------------------------------
StrLen  proc
    cld             ;move forward along the string    
    mov ax, 0d      ;ax = '\0'
    mov si, di      ;save old value of di

    repne scasb     ;while(es:[di] != ax) di++;
    mov ax, di
    sub ax, si      ;ax = di - si
    dec ax

    ret
        endp

;-------------------------------------
;MemCpy
;-------------------------------------
;EXPECTS:   None
;INPUTS:    es - segment in which source located
;           si - offset of source
;           ds - segment in which distination located
;           di - offset of distination
;           cx - number of bytes
;
;OUTPUTS:   None
;
;DESTROYS:  df, si, di
;-------------------------------------
MemCpy  proc
    cld
    rep movsb
    ret
        endp

;-------------------------------------
;StrCpy     
;-------------------------------------
;
;INPUTS:    es - segment in which source string located
;           si - offset of source string
;           ds - segment in which distination string located
;           di - segment of distination string
;Destroys:  si, di, cx
;-------------------------------------
StrCpy  proc
    xor cx, cx
    cld
    __next:
        movsb
        mov cl, ds:[si]
        cmp cx, 0
    jne __next

    ret
        endp


;-------------------------------------
;MemSet
;-------------------------------------
;EXPECTS:   None
;INPUTS:    al - value to fill
;           cx - number bytes to fill
;           es - segment in which distination located
;           di - offset of distination
;OUTPUT:    None
;DESTROY:   cx, di
;
;-------------------------------------
MemSet  proc 
    cld
    rep stosb
    ret
        endp

;-------------------------------------
;MemCmp
;-------------------------------------
;EXPECTS:   None
;INPUTS:    cx - number bytes to compare
;           ds - segment in which 1-st object located
;           si - offset for 1-st segment
;           es - segment in which 2-st object located
;           di - offset for 2-st segment
;OUTPUT:    al:  <0 if the first object is less
;                0 if they are the same
;                >0 if the first object is bigger
;DESTROY:   cx, di, si
;
;-------------------------------------
MemCmp  proc 
    cld
    repe cmpsb

    dec si          ;
    dec di          ;put pointers to first not equal byte

    mov al, ds:[si] 
    sub al, es:[di] ;return *si - *di
    ret
        endp

;-------------------------------------
;StrCmp
;-------------------------------------
;EXPECTS:   None
;INPUTS:    ds - segment in which 1-st string located
;           si - offset for 1-st segment
;           es - segment in which 2-st string located
;           di - offset for 2-st segment
;OUTPUT:    al:  <0 if the first object is less
;                0 if they are the same
;                >0 if the first object is bigger
;DESTROY:   cx, di, si
;
;-------------------------------------
StrCmp      proc
    cld

    __Next:
        mov al, ds:[si]
        cmp al, 0
        je __break
        
        cmpsb
        jne __break
        jmp __Next

__break:
    dec si          ;
    dec di          ;put pointers to first not equal byte

    mov al, ds:[si] 
    sub al, es:[di] ;return *si - *di
    ret
            endp