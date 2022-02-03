OPTION CASEMAP:none
OPTION DOTNAME ; ���. � ���������� ������� ����������
include C:\masm64\include64\masm64rt.inc

	IDI_ICON EQU 1001 ; ��� ������
	MSGBOXPARAMSA STRUCT
		cbSize		DWORD ?, ?
		hwndOwner	QWORD ?
		hInstance	QWORD ?
		lpszText	QWORD ?
		lpszCaption QWORD ?
		dwStyle		DWORD ?, ?
		lpszIcon	QWORD ?
		dwContextHelpId		QWORD ?
		lpfnMsgBoxCallback	QWORD ?
		dwLanguageId		DWORD ?,?
	MSGBOXPARAMSA ENDS
	MATR STRUCT
		elem1 dq ?
		elem2 dq ?
		elem3 dq ?
		elem4 dq ?
		elem5 dq ?
		elem6 dq ?
	MATR ENDS

.data
	params MSGBOXPARAMSA <>
	row1	MATR <1, 2, 3, 4, 5, 6>
	row2	MATR <1, 2, 3, 4, 5, 6>
	
	tit1	db	"�������� ������, Y2438 �� �7; ��������� 1", 0
	buf1	dq	1 dup(0)
	ifmt	db	"������ ������� 2 � 6. � ������ ������ ������� ���������� ����� �������� ���������, � �� 2-� ������ - ������.", 10,
				"��������: %d", 10,
				"׸����: %d", 10,
				"����� - �������� �.", 0
	
	res1	dq ?
	res2	dq ?

.code
main proc

	sub rsp, 28h		; ������������ ����� 28h=32d+8; 8 - �������
	mov rbp, rsp		; ���������� ������������ �������� �����
	xor r10, r10		; ������� ����������
	xor r11, r11		; ������� ����������
	mov rdx, 2			; �������� ���������� �����
	lea rsi, row1		; �������� ������ ������ ������ ���������

row_len:
	 mov rcx, 6

the_odd_loop: 
	 mov rax, [rsi]		; �������� �������� �� ������ ���������
	 jpo odd_add		; ������� �� odd_add, ���� ������� �� ����
	 jmp pre_end		; ����������� �������

the_even_loop: 
	 mov rax, [rsi]		; �������� �������� �� ������ ���������
	 jpe even_add		; ������� �� even_add, ���� ������� �����
	 jmp not_end		; ����������� �������

odd_add:
	 add r10, rax 

even_add:
	 add r11, rax

pre_end:
	 add rsi, type row1		; ���������� ������ ������ ��������
	 loop the_odd_loop 
	 dec rcx				; ebx := ebx � 1
	 lea rsi, row2			; �������� ������ ����� ������
	 jmp the_even_loop		; ������� �� ����� ���� 

not_end:
	 add rsi, type row1		; ���������� ������ ������ ��������
	 loop the_even_loop
	 dec rcx
	 jz ending

ending:
	 invoke wsprintf, ADDR buf1, ADDR ifmt, r10, r11
	 mov	params.cbSize, SIZEOF MSGBOXPARAMSA		; ������ ���������
	 mov	params.hwndOwner, 0						; ���������� ���� ���������
	 invoke GetModuleHandle, 0						; ��������� ����������� ���������
	 mov	params.hInstance, rax					; ���������� ����������� ���������

	 lea	rax, buf1 ; ����� ���������
	 mov	params.lpszText, rax
	 lea	rax, tit1 
	 mov	params.lpszCaption, rax
	 mov	params.dwStyle, MB_USERICON			; ����� ����
	 mov	params.lpszIcon, IDI_ICON			; ������ ������
	 mov	params.dwContextHelpId, 0			; �������� �������
	 mov	params.lpfnMsgBoxCallback, 0
	 mov	params.dwLanguageId, LANG_NEUTRAL	; ���� ���������
	 lea	rcx, params

	 invoke MessageBoxIndirect
	 invoke ExitProcess,0
main endp
End
