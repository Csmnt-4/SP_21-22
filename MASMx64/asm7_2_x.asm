OPTION CASEMAP:none
OPTION DOTNAME ; ���. � ���������� ������� ����������
include C:\masm64\include64\masm64rt.inc

IDI_ICON EQU 1001
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

	array STRUCT
		qviol		dq ?
		ownername	db 20 dup(?)
		aname		db 20 dup(?)
		govnum		db 10 dup(?)
	array ENDS

.data
	first	array <2, "Ivanov", "Kamri", "5012324">			; ��������� "first"
	second	array <7, "Petrov", "Outlander", "2312421">		; ��������� "second"
	third	array <10, "Kotlyarova", "Nogi", "5317912">		; ��������� "third"
	fourth	array <12, "Terehov", "Shevrolet", "2123853">	; ��������� "fourth"

	date	db "CarName GovNomer OwnerName Quantity of violation", 0ah, 0dh,
			"Kamri 5012324 Ivanov 10", 0ah, 0dh,
			"Outlander 2312421 Petrov 2", 0ah, 0dh,
			"Nogi 5317912 Kotlyarova 23", 0ah, 0dh,
			"Shevrolet 2123853 Terehov 34",0ah,0dh,0
	buf		dq 5 dup(?),0
	st1		db "������ ������������������ ��������. ��������� �������� ����: �������� ����������, ���������� �����, ��� ���������, ���������� ���������. ������� �� ����� ��� ��������� � ����������� ������ ���������.", 0
	ifmt	db "��� ���������: %c ", 10,
			   "����� - �������� �.", 0

	sr		dq ?
	fmt		db "%c",0
	res		db ?
.code
main proc
	sub		rsp, 28h; ������������ ����� 28h=32d+8; 32d x 8 = 256; 8 - �������
	mov		rbp, rsp ; ���������� ������������ �������� �����
	invoke MessageBox, 0,addr date,addr st1,MB_ICONQUESTION
	lea		rsi,	first ; �������� ������ ������ ������ ���������
	mov		rax,	[rsi]
	mov		sr,		rax
	lea		rsi,	second ; �������� ������ 2-� ������ ���������
	mov		rax,	[rsi] ; ������ ���� ������ ������ ���������
	cmp		sr,		rax
js fin1

twocmp:
	lea	rsi,	third ; �������� ������ 3-� ������ ���������
	mov	rax,	[rsi] ; ������ ���� ������ ������ ���������
	cmp	sr,		rax
		js		fin2
threecmp:
	lea	rsi,	fourth ; �������� ������ 4-� ������ ���������
	mov	rax,	[rsi] ; ������ ���� 4-� ������ ���������
	cmp	sr,		rax
		js		fin3
	jmp ending
fin1:
	mov	rax,	[rsi]
	mov	sr,		rax
	add	rsi,	4 ; ���������� ������ ������ ��������
	lea	rdi,	res
	invoke wsprintf, ADDR [rdi], ADDR fmt, [rsi]
	jmp	twocmp
fin2:
	mov	rax,[rsi]
	mov	sr, rax
	add	rsi,4 ; ���������� ������ ������ ��������
	lea	rdi, res
	invoke wsprintf,ADDR [rdi],ADDR fmt, [rsi]
	jmp threecmp
fin3:
	mov		rax,	[rsi]
	mov		sr,		rax
	add		rsi,	4 ; ���������� ������ ������ ��������
	lea		rdi,	res
	invoke wsprintf, ADDR [rdi], ADDR fmt, [rsi]
	jmp		ending

ending:
	 invoke wsprintf, ADDR buf, ADDR ifmt, res
	 mov	params.cbSize,SIZEOF MSGBOXPARAMSA		; ������ ���������
	 mov	params.hwndOwner,0						; ���������� ���� ���������
	 invoke GetModuleHandle,0						; ��������� ����������� ���������
	 mov	params.hInstance,rax					; ���������� ����������� ���������
	 lea	rax, buf								; ����� ���������

	 mov	params.lpszText, rax
	 lea	rax,st1									; ����� �������� ����
	 mov	params.lpszCaption,rax
	 mov	params.dwStyle, MB_USERICON				; ����� ����
	 mov	params.lpszIcon, IDI_ICON				; ������ ������
	 mov	params.dwContextHelpId, 0				; �������� �������
	 mov	params.lpfnMsgBoxCallback,0
	 mov	params.dwLanguageId, LANG_NEUTRAL
	 lea	rcx,params

	 invoke MessageBoxIndirect
	 invoke ExitProcess,0
main endp
End
