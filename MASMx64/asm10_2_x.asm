OPTION DOTNAME ; ��������� � ���������� ������� ����������
	include C:\masm64\include64\win64.inc
	include C:\masm64\include64\kernel32.inc
	includelib C:\masm64\lib\kernel32.lib
	include C:\masm64\include64\user32.inc
	includelib C:\masm64\lib\user32.lib
OPTION PROLOGUE:none
OPTION EPILOGUE:none
	include C:\masm64\include64\temphls.inc

.data
	titl db "#10.2 AVX-comands",0 
	szInf db "OK",0 ; 
	szInf2 db "Error",0; 
.code
main proc ; ��� ������������� 64-��������� ��
	sub		rsp,28h					; ������������ ����� 28h=32d+8; 8 - �������
	mov		rbp,rsp					; ���������� ������������ �������� �����
	mov		eax,1
	cpuid							; �� eax ������������ ������������� ���������������
	and		ecx, 10000000h			; e�x:= e�x v 1000 0000h (28 ������)
	jnz		exit1					; ������� �� exit, ���� �� ����
	invoke MessageBox, 0, ADDR szInf2, ADDR titl, MB_ICONINFORMATION 
	jmp		exit2

exit1: 
	invoke MessageBox, 0, ADDR szInf, ADDR titl, MB_OK

exit2:
	invoke ExitProcess, 0 
main endp
end

lab10avx.asm
OPTION CASEMAP:none
OPTION DOTNAME 
include C:\masm64\include64\win64a.inc

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
	align	8 ; ������������ ������ �� �������, ������� 8 ������
	params MSGBOXPARAMSA <>
	mas2	dq 4.0, 2.1, 3.8
	mas1	dq 3.9, 2.0, 3.54
	len		equ ($-mas2)/ type mas2 ; ���������� ����� ������� mas2
	ifmt	db	"��������� ������������ ��������� �������� �� 3-� 64-��������� ������������ �����. ���� ��� ����� ������� ������� ������ �������, �� ��������� ����� ������������� ��������, � ���� �������� � �� ������������.", 10, 10,
				"��������� = %d", 10,
				"����� - �������� �.",0
	tit1	db "#10.2 AVX-comands",0
	buf1	dq 0,0

.code
main proc
	sub		rsp,28h; c���: 28h=40d=32d+8; 8 - �������
	mov		rbp,rsp
	vmovupd		xmm1, mas1 ; ��������� mas1 � ������� xmm1
	vmovupd		xmm2, mas2 ; ��������� mas2 � ������� xmm2
	vpcmpgtb	xmm3, xmm1,xmm2 ; ��������� �������� � ��������� ��� ���������� � ������� xmm3
	vpextrd		r10d, xmm3,0 ; ���������� 0-�� ����� � xmm
	cmp r10d, 0
		jz mb
	vpextrd r11d, xmm3, 1 ; ���������� 1-�� ����� � xmm
	cmp r11d, 0
		jz mb
	vpextrd r12d, xmm3, 2 ; ���������� 2-�� ����� � xmm
	cmp r12d, 0
		jz mb
	minpd xmm1,xmm2 
	jmp final

mb:
	maxpd xmm1,xmm2 ;maxx

final:
	cvtpd2pi MM0, xmm0 ; ����������� � 32-��������� �����
	movd dword ptr eax, mm0 ; ��������� ����������� ��0 � ebx

	movsxd r15, eax
	invoke wsprintf, ADDR buf1, ADDR ifmt, r15
	mov params.cbSize,SIZEOF MSGBOXPARAMSA	; ������ ���������
	mov params.hwndOwner, 0					; ���������� ���� ���������
	invoke GetModuleHandle, 0				; ��������� ����������� ���������
	mov params.hInstance, rax				; ���������� ����������� ���������
	lea rax, buf1							; ����� ���������

	mov params.lpszText, rax
	lea rax, tit1							; ����� �������� ����
	mov params.lpszCaption,rax
	mov params.dwStyle, MB_USERICON			; ����� ����
	mov params.lpszIcon, IDICON				; ������ ������
	mov params.dwContextHelpId, 0			; �������� �������
	mov params.lpfnMsgBoxCallback, 0
	mov params.dwLanguageId, LANG_NEUTRAL
	lea rcx, params

	invoke MessageBoxIndirect
	invoke ExitProcess,0
main endp
end

