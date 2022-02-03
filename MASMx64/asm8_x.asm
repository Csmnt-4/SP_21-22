OPTION DOTNAME ; вкл. и отключение функции ассемблера
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

	mDiv macro a,b			; макрос с именем mDiv
	fld a					; загрузка a
	fld b					; загрузка b
	fdiv					; a/b
	endm					; окончание макроса

.data
	align	8						; выравнивание памяти по адресам, кратным 8 байтам
	params	MSGBOXPARAMSA <>
	tit1	db "Macros",0
	buf1	dq 1 dup(0)
	ifmt	db "(2a/b) + a/(3.1b), где a = 3.1, b = 2 ", 10,
	"Результат программы = %d ", 10, 10,
	"Автор - Анисимов В.", 0
	
	a		real4 3.1
	b		real4 2.0
	res1	dd 0,0
	res2	dd 0,0
	res3	dd 0,0
	const1	real4 2.0
	const2	real4 3.1

.code
	WinMain proc
	sub		rsp, 28h; выравнивание стека 28h=32d+8; 32d x 8 = 256/16=16 байт;8 — возврат
	mov		rbp, rsp
	finit					; инициализация сопроцессора
	fld		const1
	mDiv	[a],[b] ; вызов макроса
	fmul
	mDiv	[a],[b]; вызов макроса
	fld		const2 
	fdiv
	fadd
	fisttp	res1
	movsxd	r10, res1

	invoke	wsprintf,ADDR buf1,ADDR ifmt,r10
	mov		params.cbSize, SIZEOF MSGBOXPARAMSA			; размер структуры
	mov		params.hwndOwner,0							; дескриптор окна владельца
	invoke	GetModuleHandle,0							; получение дескриптора программы
	mov		params.hInstance,rax						; сохранение дескриптора программы
	lea		rax, buf1									; адрес сообщения

	mov		params.lpszText, rax
	lea		rax,tit1									; адрес заглавия окна
	mov		params.lpszCaption, rax
	mov		params.dwStyle, MB_USERICON					; стиль окна
	mov		params.lpszIcon, IDICON						; ресурс значка
	mov		params.dwContextHelpId,0					; контекст справки
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
