include C:\masm32\include64\masm64rt.inc
    .data

a1      dq 5
c1      dq 1
d1      dq 3

titl1   db "Анисимов Виктор, Y2438 ЛР №1", 0
strbuf1 dq  ?, 0
txt1    db "Результат: %d", 0

    .code
main proc

    mov     rax, 2
    mul     d1
    div     c1

    mov     rbx, rax
    mov     rax, a1
    mul     d1

    sub     rbx, rax 
                
    invoke  wsprintf, ADDR strbuf1, ADDR txt1, rbx
    invoke  MessageBox, 0, addr strbuf1, addr titl1, MB_ICONINFORMATION;
    invoke  ExitProcess,0

main endp;
end