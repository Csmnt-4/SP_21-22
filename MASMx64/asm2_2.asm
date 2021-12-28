include C:\masm64\include64\masm64rt.inc

.data
    mas1    dq 1, 2, 3, 4, 5, 6, 7, 8, 9, 10; объявление массива
    len1    equ ($-mas1)/type mas1 ; определение длины mas1

    str1    db ?, 0        ; создание буфера для ответа
    str2    db ?, 0

    m       db 3
    l       db 2

    txt1    db "Количество: %d", 0      ; объявление строк для вывода
    txt2    db "Числа: %d", 0Ah, "%d", 0Ah, "%d", 0Ah, "%d", 0
    txt3    db "Сумма, так как вывести числа не выходит: %d", 0

    titl1   db "Анисимов Виктор, Y2438 ЛР №2 часть 2", 0

.code
main    proc
    xor     rdi, rdi        ; обнуление регистра для использования его в качестве счётчика
    lea     rbx, mas1       ; запись в регистр rbx адреса первого (нулевого) элемента массива
    mov     rcx, len1       ; запись в регистр rcx длины массива
    mov     rsi, 0

m2:
    push    rdx
    push    rcx

    mov     ax, [rbx]
    push    rbx
    
    mov     bl, m
    div     bl

    cmp     ah, l
    
    jnz     next
        pop     rbx
        mov     ax, [rbx]
        push    rbx
        add     si, ax
        inc     rdi
;       invoke  wsprintf, ADDR txt2, si - не вышло что-то, думаю это делается совсем иначе
    
next:
    pop     rbx
    add     rbx, type mas1
    pop     rcx
    pop     rdx
        loop    m2
    
    invoke  wsprintf,   ADDR str1, ADDR txt1, rdi
    invoke  MessageBox, 0, ADDR str1, ADDR titl1, MB_ICONINFORMATION
    
    invoke  wsprintf,   ADDR str2, ADDR txt3, si
    invoke  MessageBox, 0, ADDR str2, ADDR titl1, MB_ICONINFORMATION 

    invoke  ExitProcess, 0                      ; возврат управления ОС и освобождение ресурсов
main    endp                                    ; окончание процедуры
end                                                 