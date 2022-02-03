include C:\masm64\include64\masm64rt.inc
.const
    title0 db "Анисимов Виктор, Y2438 ЛР №6", 0
    fmt0 db "Y = 25X^2 - 2.1; X0 = 1", 10,
            "Шаг = 0.2", 10,
            "Y0 = %s", 10,
            "Y1 = %s", 10,
            "Y2 = %s", 10,
            "Y3 = %s", 0

    const0  dq -25.0
    const1  dq -2.1
    step0   dq 0.2
    loop_count0 dq 4

.data
    x0      dq 1.0
    res0    dq 4 dup(0.0)           ; массив результатов
    text0   db 256 dup(0)
    res1    db 32 dup(0)
    res2    db 32 dup(0)
    res3    db 32 dup(0)
    res4    db 32 dup(0)

.code
main proc
    lea     rdi,    res0           ; адрес массива
    mov     rcx,    loop_count0    ; количество итераций
    finit
m0:
    fld     const1
    fld     x0

    mov     rax,    x0
    fmul    st(0),  st(0)          ; X^2

    fld     const0
    fmulp   st(1),  st(0)          ; 25 * X^3
    fsubp   st(1),  st(0)          ; 25 * X^3 - 2.1
    fstp    qword ptr [rdi]        ; st0 -> array[i]
    add     rdi,    type res0      ; i += размер элемента

    fld x0
    fld step0
    faddp st(1), st(0)
    fstp qword ptr [x0]

loop m0
    invoke  fptoa, qword ptr[res0], ADDR res1
    invoke  fptoa, qword ptr[res0 + 8h], ADDR res2
    invoke  fptoa, qword ptr[res0 + 10h], ADDR res3
    invoke  fptoa, qword ptr[res0 + 18h], ADDR res4
    invoke  wsprintf, ADDR text0, ADDR fmt0, ADDR res1, ADDR res2, ADDR res3, ADDR res4
    invoke  MessageBox, 0, ADDR text0, ADDR title0, MB_OK
    invoke  ExitProcess, 0
main endp
end