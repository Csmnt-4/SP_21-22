OPTION DOTNAME ; включение и отключение функции ассемблера
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
main proc ; при использования 64-разрядной ОС
	sub		rsp,28h					; выравнивание стека 28h=32d+8; 8 - возврат
	mov		rbp,rsp					; сохранение выровненного значения стека
	mov		eax,1
	cpuid							; по eax производится идентификация микропроцессора
	and		ecx, 10000000h			; eсx:= eсx v 1000 0000h (28 разряд)
	jnz		exit1					; перейти на exit, если не нуль
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
	align	8 ; выравнивание памяти по адресам, кратным 8 байтам
	params MSGBOXPARAMSA <>
	mas2	dq 4.0, 2.1, 3.8
	mas1	dq 3.9, 2.0, 3.54
	len		equ ($-mas2)/ type mas2 ; количество чисел массива mas2
	ifmt	db	"Выполнить параллельное сравнение массивов по 3-и 64-разрядных вещественных числа. Если все числа второго массива больше первого, то выполнить поиск максимального значения, а если наоборот – то минимального.", 10, 10,
				"Результат = %d", 10,
				"Автор - Анисимов В.",0
	tit1	db "#10.2 AVX-comands",0
	buf1	dq 0,0

.code
main proc
	sub		rsp,28h; cтек: 28h=40d=32d+8; 8 - возврат
	mov		rbp,rsp
	vmovupd		xmm1, mas1 ; занесение mas1 в регистр xmm1
	vmovupd		xmm2, mas2 ; занесение mas2 в регистр xmm2
	vpcmpgtb	xmm3, xmm1,xmm2 ; сравнение массивов и занесение его результата в регистр xmm3
	vpextrd		r10d, xmm3,0 ; извлечение 0-го числа з xmm
	cmp r10d, 0
		jz mb
	vpextrd r11d, xmm3, 1 ; извлечение 1-го числа з xmm
	cmp r11d, 0
		jz mb
	vpextrd r12d, xmm3, 2 ; извлечение 2-го числа з xmm
	cmp r12d, 0
		jz mb
	minpd xmm1,xmm2 
	jmp final

mb:
	maxpd xmm1,xmm2 ;maxx

final:
	cvtpd2pi MM0, xmm0 ; превращение в 32-разрядное число
	movd dword ptr eax, mm0 ; занесение содержимого ММ0 в ebx

	movsxd r15, eax
	invoke wsprintf, ADDR buf1, ADDR ifmt, r15
	mov params.cbSize,SIZEOF MSGBOXPARAMSA	; размер структуры
	mov params.hwndOwner, 0					; дескриптор окна владельца
	invoke GetModuleHandle, 0				; получение дескриптора программы
	mov params.hInstance, rax				; сохранение дескриптора программы
	lea rax, buf1							; адрес сообщения

	mov params.lpszText, rax
	lea rax, tit1							; адрес заглавия окна
	mov params.lpszCaption,rax
	mov params.dwStyle, MB_USERICON			; стиль окна
	mov params.lpszIcon, IDICON				; ресурс значка
	mov params.dwContextHelpId, 0			; контекст справки
	mov params.lpfnMsgBoxCallback, 0
	mov params.dwLanguageId, LANG_NEUTRAL
	lea rcx, params

	invoke MessageBoxIndirect
	invoke ExitProcess,0
main endp
end

