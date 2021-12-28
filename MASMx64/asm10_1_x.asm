OPTION DOTNAME 
	include		C:\masm64\include64\win64a.inc

IDICON EQU 1001
MSGBOXPARAMSA STRUCT
	cbSize				DWORD ?, ?
	hwndOwner			QWORD ?
	hInstance			QWORD ?
	lpszText			QWORD ?
	lpszCaption			QWORD ?
	dwStyle				DWORD ?, ?
	lpszIcon			QWORD ?
	dwContextHelpId		QWORD ?
	lpfnMsgBoxCallback	QWORD ?
	dwLanguageId		DWORD ?, ?
MSGBOXPARAMSA ENDS

.data
	align	16
	params	MSGBOXPARAMSA <>

	mas2	dq	4.0, 2.1, 3.8
	mas1	dq	3.9, 2.0, 3.54

	len1		equ ($-mas2) / type mas2 ; ���������� ����� ������� mas2
	desc1	db	"If the second array is larger than the first, then find the maximum value,",10,"otherwise find the minimum value",10,
			"Result of the program = %d",10,10,"Author: Anisimov Victor",0
	tit1	db	"#10.1. SSE-comands",0
	buf1	dq	0,0

.code
main proc
	sub		rsp, 28h; c���: 28h=32d+8; 8 - �������
	mov		rbp, rsp
	mov		eax, len 
	mov		ebx, 2			; ���������� 64-��������� ����� � 128-��������� ��������
	div		ebx				; ����������� ���������� ������ ��� ������������� ���������� � �������
	mov		ecx, eax		; ������� ������ ��� ������������� ����������

	lea		rsi, mas1
	lea		rdi, mas2

next:
	movupd		XMM0, xmmword ptr [rsi]		; 2- 64 ����� �� mas1
	movupd		XMM1,[rdi]					; 2- 64 ����� �� mas2
	cmpltpd		XMM0, XMM1					; ���������: ���� ������, �� ����	
	movmskpd	ebx, XMM0					; ����������� �������� �����
	cmp		ebx,0
	jz		minend
	dec		ecx
	jz		maxend
	add		rsi, 16
	add		rdi, 16
	jmp		next
	
minend:
	movupd	Xmm0, mas1 ; ��������� masl � ����
	movupd	Xmm1, mas2 ; ��������� mas2 � ���1
	minpd	Xmm0, xmm1 
	jmp		fin
	
maxend:
	movupd	Xmm0, mas1 ; ��������� masl � ����
	movupd	Xmm1, mas2 ; ��������� mas2 � ���1
	maxpd	Xmm0, xmm1 ; maxx
	
fin:
	cvtpd2pi	MM0, xmm0							; ����������� � 32-��������� �����
	movd		dword ptr eax, mm0					; ��������� ����������� ��0 � ebx
	movsxd		r15, eax
	invoke		wsprintf, ADDR buf1, ADDR desc1, r15
	mov			params.cbSize, SIZEOF MSGBOXPARAMSA ; ������ ���������
	mov			params.hwndOwner, 0					; ���������� ���� ���������
	invoke		GetModuleHandle, 0					; ��������� ����������� ���������
	mov			params.hInstance, rax				; ���������� ����������� ���������
	lea			rax, buf1							; ����� ���������
	mov			params.lpszText, rax
	lea			rax, tit1							; ����� �������� ����
	mov			params.lpszCaption, rax
	mov			params.dwStyle, MB_USERICON			; ����� ����
	mov			params.lpszIcon, IDICON				; ������ ������
	mov			params.dwContextHelpId, 0			; �������� �������
	mov			params.lpfnMsgBoxCallback, 0
	mov			params.dwLanguageId, LANG_NEUTRAL	; ���� ���������
	lea			rcx, params
	invoke		MessageBoxIndirect
	invoke		ExitProcess, 0
	
main endp
end