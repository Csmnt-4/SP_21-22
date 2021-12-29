include C:\masm64\include64\masm64rt.inc

.data
    mas1    dq 100, 132, 20, 134, 200,  845, 173, 139, 93, 1,  -134, -13, 0, -245, -39
    mas2    dq 2 dup(?)
    
    sum1    dq 0
    sum2    dq 0

    len1    equ ($-mas1)/type mas1
    buf1    dq 0, 0
    buf2    dq ?, 0
    buf3    dq ?, 0

    titl1   db "�������� ������, Y2438 �� �5", 0

    msg0    db "������ � ���� �����������.", 0
    msg1    db "Num eq: %d", 0Ah, "Num !eq: %d", 0
    msg3    db "%d", 0Ah, 0

    fName       BYTE "�������� ������ Y2438 �� �5.txt", 0
    fHandle     dq ?                ; ���������� �������� ������
    cWritten    dq ?                ; ������ ��� ������ �������� ������
    BSIZE1      equ 104             ; ���������� ������, ������� ������������ � ����

.code
main proc
    lea     rbx, mas1       ; ������ � ������� rbx ������ ������� (��������) �������� �������
    mov     rcx, len1       ; ������ � ������� rcx ����� �������

 reiterate:
    mov     ax, [rbx]
    cmp     ax, 132
        jnz     notequal
        inc     sum1
            loop    reiterate
            jmp     fin
notequal:
    inc     sum2
        loop    reiterate

fin:
    mov     fHandle, rax                                ; ���������� �����
    invoke  CreateFile, ADDR fName, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_ARCHIVE, 0
    
    mov     rdx, sum1
    mov     rbx, sum2
    lea     rcx, mas2
    
    invoke  wsprintf, ADDR [rcx], ADDR msg1, rdx        ; ������ �������� �� ������ ������
    add     rcx, type mas2
    invoke  wsprintf, ADDR [rcx], ADDR msg1, rbx        ; ������ �������� �� ������ ������
    
                                                        ; �������� ����� � ����������� �� ����������� ������
    invoke  WriteFile, fHandle, ADDR mas2, BSIZE1, ADDR cWritten, 0
    invoke  CloseHandle, fHandle                        ; ������� ���������� �����

    invoke  MessageBox, 0, ADDR buf1, ADDR titl1, MB_ICONQUESTION
    clc
    invoke  MessageBox, 0, ADDR msg0, ADDR titl1, MB_ICONQUESTION
    invoke  ExitProcess, 0
main endp
end                                                 