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

	len1		equ ($-mas2) / type mas2 ; количество чисел массива mas2
	desc1	db	"If the second array is larger than the first, then find the maximum value,",10,"otherwise find the minimum value",10,
			"Result of the program = %d",10,10,"Author: Anisimov Victor",0
	tit1	db	"#10.1. SSE-comands",0
	buf1	dq	0,0

.code
main proc
	sub		rsp, 28h; cтек: 28h=32d+8; 8 - возврат
	mov		rbp, rsp
	mov		eax, len 
	mov		ebx, 2			; количество 64-разрядных чисел в 128-разрядном регистре
	div		ebx				; определение количества циклов для параллельного считывания и остатка
	mov		ecx, eax		; счетчик циклов для параллельного считывания

	lea		rsi, mas1
	lea		rdi, mas2

next:
	movupd		XMM0, xmmword ptr [rsi]		; 2- 64 числа из mas1
	movupd		XMM1,[rdi]					; 2- 64 числа из mas2
	cmpltpd		XMM0, XMM1					; сравнение: если меньше, то нули	
	movmskpd	ebx, XMM0					; перенесение знаковых битов
	cmp		ebx,0
	jz		minend
	dec		ecx
	jz		maxend
	add		rsi, 16
	add		rdi, 16
	jmp		next
	
minend:
	movupd	Xmm0, mas1 ; занесение masl к ХММО
	movupd	Xmm1, mas2 ; занесение mas2 к Хмм1
	minpd	Xmm0, xmm1 
	jmp		fin
	
maxend:
	movupd	Xmm0, mas1 ; занесение masl к ХММО
	movupd	Xmm1, mas2 ; занесение mas2 к Хмм1
	maxpd	Xmm0, xmm1 ; maxx
	
fin:
	cvtpd2pi	MM0, xmm0							; превращение в 32-разрядное число
	movd		dword ptr eax, mm0					; занесение содержимого ММ0 в ebx
	movsxd		r15, eax
	invoke		wsprintf, ADDR buf1, ADDR desc1, r15
	mov			params.cbSize, SIZEOF MSGBOXPARAMSA ; размер структуры
	mov			params.hwndOwner, 0					; дескриптор окна владельца
	invoke		GetModuleHandle, 0					; получение дескриптора программы
	mov			params.hInstance, rax				; сохранение дескриптора программы
	lea			rax, buf1							; адрес сообщения
	mov			params.lpszText, rax
	lea			rax, tit1							; адрес заглавия окна
	mov			params.lpszCaption, rax
	mov			params.dwStyle, MB_USERICON			; стиль окна
	mov			params.lpszIcon, IDICON				; ресурс значка
	mov			params.dwContextHelpId, 0			; контекст справки
	mov			params.lpfnMsgBoxCallback, 0
	mov			params.dwLanguageId, LANG_NEUTRAL	; язык сообщения
	lea			rcx, params
	invoke		MessageBoxIndirect
	invoke		ExitProcess, 0
	
main endp
end