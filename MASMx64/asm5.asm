include C:\masm64\include64\masm64rt.inc

.data
    mas1    dq 100, 132, 20, 132, 200, 845, 173, 139, 93, 1, -134, -13, 0, -245, -39
    mas2    dq 2 dup (?)
    
    sum1    dq 0
    sum2    dq 15

    len1    equ ($-mas1)/type mas1

    buf1    dq ?, 0
    buf2    dq ?, 0
    buf3    dq ?, 0

    titl1   db "�������� ������, Y2438 �� �5", 0

    msg0    db "������ � ���� �����������.", 0
    msg1    db "Num eq: %d", 0Ah, "Num !eq: %d", 0
    msg2    db "%d", 0Ah, 0

    fName       BYTE "�������� ������ Y2438 �� �5.txt", 0
    fHandle     dq ?                ; ���������� �������� ������
    cWritten    dq ?                ; ������ ��� ������ �������� ������
    BSIZE1      equ 21            ; ���������� ������, ������� ������������ � ����

.code
main proc
    lea     rsi, mas1       ; ������ � ������� rbx ������ ������� (��������) �������� �������
    mov     r15, len1       ; ������ � ������� rcx ����� �������

 reiterate:
    mov     rax, [rsi]
    add     rsi, type mas1
    cmp     rax, 132
        jnz     notequal
        dec     sum2

notequal:
    dec     r15
        jz     fin
    mov     r11, r15
    jmp     reiterate

fin:
    mov     rax, 15
    sub     rax, sum2
    mov     rbx, sum2
    lea     rcx, mas2

    mov     [rcx], rdx
    add     rcx, type mas2
    mov     [rcx], rbx

    invoke  wsprintf, ADDR buf1, ADDR msg1, rax, rbx        ; ������ ������� �������� � ������
    ;invoke  wsprintf, ADDR [rcx], ADDR msg1, rbx        ; ������ ������� �������� � ������
    
    invoke  CreateFile, ADDR fName, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_ARCHIVE, 0
    mov     fHandle, rax                                ; ���������� �����
    
                                                        ; �������� ����� � ����������� �� ����������� ������
    invoke  WriteFile, fHandle, ADDR buf1, BSIZE1, ADDR cWritten, 0
    invoke  CloseHandle, fHandle                        ; ������� ���������� �����

    invoke  MessageBox, 0, ADDR buf1, ADDR titl1, MB_ICONQUESTION

    invoke  MessageBox, 0, ADDR msg0, ADDR titl1, MB_ICONQUESTION
    invoke  ExitProcess, 0
main endp
end                                                 