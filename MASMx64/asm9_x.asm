include     C:\masm64\include64\win64.inc
OPTION DOTNAME 

IDICON EQU 1001
MSGBOXPARAMSA STRUCT
    cbSize              DWORD ?, ?
    hwndOwner           QWORD ?
    hInstance           QWORD ?
    lpszText            QWORD ?
    lpszCaption         QWORD ?
    dwStyle             DWORD ?, ?
    lpszIcon            QWORD ?
    dwContextHelpId     QWORD ?
    lpfnMsgBoxCallback  QWORD ?
    dwLanguageId        DWORD ?, ?
MSGBOXPARAMSA ENDS

.data
    params MSGBOXPARAMSA <>
    
    mas1    dd 2, 1, 1
    mas2    dd 4, 2, 3

    a       dd 2.5
    b       dd 4.0
    c       dd 1.1
    e       dd 4.4

    res     dd 0
    
    desc1   db "Result of the program = %d", 0
    tit1    db "#9. MMX-comands", 0
    buf1    dq ?, 0

.code
main proc
    sub     rsp, 28h                ; cтек: 28h=32d+8 8 - возврат
    movd    MM0, dword ptr mas1    ;
    pcmpgtb MM0, qword ptr mas2 ; сравнение массивов на больше, если первый массив больше второго, то в MM0 запишется 1, нет 0
    movd    qword ptr res, MM0
    
    cmp     res, 0
    jz      ab
    
    fld     e
    fld     c
    fdiv

    fld     a
    fsub st(0), st(1)
    
    fld a
    fmul b
    fsub
        jmp fin

ab:
    fld a
    fmul b

fin:
    invoke wsprintf, ADDR buf1, ADDR desc1, res
    
    mov params.cbSize, SIZEOF MSGBOXPARAMSA ; размер структуры
    mov params.hwndOwner, 0     ; дескриптор окна владельца

    invoke GetModuleHandle, 0   ; получение дескриптора программы
    mov params.hInstance, rax   ; сохранение дескриптора программы
    
    lea rax, buf1 ; адрес сообщения
    mov params.lpszText, rax
    
    lea rax, tit1 ;Caption ; адрес заглавия окна
    mov params.lpszCaption, rax
    mov params.dwStyle, MB_USERICON ; стиль окна
    mov params.lpszIcon, IDICON  ; ресурс значка
    mov params.dwContextHelpId, 0 ; контекст справки
    mov params.lpfnMsgBoxCallback, 0 ;
    mov params.dwLanguageId, LANG_NEUTRAL ; язык сообщения
    lea rcx, params

    invoke MessageBoxIndirect
    invoke ExitProcess, 0

main endp
end


la.rc
#define IDI_ICON 1001
IDI_ICON ICON DISCARDABLE "vlabico.ico"
                

makeitest.bat
@echo off

set appname=lab10
\masm64\bin\ml64.exe /c %appname%.asm
\masm64\bin\rc.exe la.rc
\masm64\bin\link /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:WinMain /nologo /LARGEADDRESSAWARE %appname%.obj la.RES
pause 

del %appname%.obj 
start %appname%.exe
dir %appname%.*

pause
        