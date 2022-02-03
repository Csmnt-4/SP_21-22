OPTION DOTNAME ; ���. � ���������� ������� ����������
include C:\masm64\include64\win64a.inc

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

	mDiv macro a,b			; ������ � ������ mDiv
	fld a					; �������� a
	fld b					; �������� b
	fdiv					; a/b
	endm					; ��������� �������

.data
	align	8						; ������������ ������ �� �������, ������� 8 ������
	params	MSGBOXPARAMSA <>
	tit1	db "Macros",0
	buf1	dq 1 dup(0)
	ifmt	db "(2a/b) + a/(3.1b), ��� a = 3.1, b = 2 ", 10,
	"��������� ��������� = %d ", 10, 10,
	"����� - �������� �.", 0
	
	a		real4 3.1
	b		real4 2.0
	res1	dd 0,0
	res2	dd 0,0
	res3	dd 0,0
	const1	real4 2.0
	const2	real4 3.1

.code
	WinMain proc
	sub		rsp, 28h; ������������ ����� 28h=32d+8; 32d x 8 = 256/16=16 ����;8 � �������
	mov		rbp, rsp
	finit					; ������������� ������������
	fld		const1
	mDiv	[a],[b] ; ����� �������
	fmul
	mDiv	[a],[b]; ����� �������
	fld		const2 
	fdiv
	fadd
	fisttp	res1
	movsxd	r10, res1

	invoke	wsprintf,ADDR buf1,ADDR ifmt,r10
	mov		params.cbSize, SIZEOF MSGBOXPARAMSA			; ������ ���������
	mov		params.hwndOwner,0							; ���������� ���� ���������
	invoke	GetModuleHandle,0							; ��������� ����������� ���������
	mov		params.hInstance,rax						; ���������� ����������� ���������
	lea		rax, buf1									; ����� ���������

	mov		params.lpszText, rax
	lea		rax,tit1									; ����� �������� ����
	mov		params.lpszCaption, rax
	mov		params.dwStyle, MB_USERICON					; ����� ����
	mov		params.lpszIcon, IDICON						; ������ ������
	mov		params.dwContextHelpId,0					; �������� �������
	mov		params.lpfnMsgBoxCallback,0
	mov		params.dwLanguageId, LANG_NEUTRAL

	lea		rcx,params
	invoke	MessageBoxIndirect
	invoke	ExitProcess,0
main endp
end

la.rc
#define IDI_ICON 1001
IDI_ICON ICON DISCARDABLE "vlabico.ico"

makeitest.bat
@echo off

set appname=lab8
\masm64\bin\ml64.exe /c %appname%.asm
\masm64\bin\rc.exe la.rc
\masm64\bin\link /SUBSYSTEM:CONSOLE /MACHINE:X64 /ENTRY:WinMain /nologo /LARGEADDRESSAWARE %appname%.obj la.RES
pause 
del %appname%.obj 
start %appname%.exe

dir %appname%.*
pause
