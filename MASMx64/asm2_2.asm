include C:\masm64\include64\masm64rt.inc

.data
    mas1    dq 1, 2, 3, 4, 5, 6, 7, 8, 9, 10; ���������� �������
    len1    equ ($-mas1)/type mas1 ; ����������� ����� mas1

    str1    db ?, 0        ; �������� ������ ��� ������
    str2    db ?, 0

    m       db 3
    l       db 2

    txt1    db "����������: %d", 0      ; ���������� ����� ��� ������
    txt2    db "�����: %d", 0Ah, "%d", 0Ah, "%d", 0Ah, "%d", 0
    txt3    db "�����, ��� ��� ������� ����� �� �������: %d", 0

    titl1   db "�������� ������, Y2438 �� �2 ����� 2", 0

.code
main    proc
    xor     rdi, rdi        ; ��������� �������� ��� ������������� ��� � �������� ��������
    lea     rbx, mas1       ; ������ � ������� rbx ������ ������� (��������) �������� �������
    mov     rcx, len1       ; ������ � ������� rcx ����� �������
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
;       invoke  wsprintf, ADDR txt2, si - �� ����� ���-��, ����� ��� �������� ������ �����
    
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

    invoke  ExitProcess, 0                      ; ������� ���������� �� � ������������ ��������
main    endp                                    ; ��������� ���������
end                                                 