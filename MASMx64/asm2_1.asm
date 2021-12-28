include C:\masm64\include64\masm64rt.inc
    
.data
    a1  dq 4
    b1  dq 3
    c1  dq 1
    d1  dq 3
    e1  dq 2
    f1  dq 4

    titl1   db "Анисимов Виктор, Y2438 ЛР №2 часть 1", 0
    buf1    dq  ?, 0
    txt1    db "Результат: %d", 0

.code
main    proc
    mov     rax, a1
    mul     c1
    mov     rbx, rax

    mov     rax, b1
    div     d1
    add     rax, rbx

    mov     rbx, f1
    div     e1

    add     rax, rbx 
                
    invoke  wsprintf, ADDR buf1, ADDR txt1, rax
    invoke  MessageBox, 0, ADDR buf1, ADDR titl1, MB_ICONINFORMATION
    invoke  ExitProcess, 0
main endp
end                                            