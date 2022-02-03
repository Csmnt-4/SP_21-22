OPTION CASEMAP:none
OPTION DOTNAME ; вкл. и отключение функции ассемблера
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
	first	array <2, "Ivanov", "Kamri", "5012324">			; структура "first"
	second	array <7, "Petrov", "Outlander", "2312421">		; структура "second"
	third	array <10, "Kotlyarova", "Nogi", "5317912">		; структура "third"
	fourth	array <12, "Terehov", "Shevrolet", "2123853">	; структура "fourth"

	date	db "CarName GovNomer OwnerName Quantity of violation", 0ah, 0dh,
			"Kamri 5012324 Ivanov 10", 0ah, 0dh,
			"Outlander 2312421 Petrov 2", 0ah, 0dh,
			"Nogi 5317912 Kotlyarova 23", 0ah, 0dh,
			"Shevrolet 2123853 Terehov 34",0ah,0dh,0
	buf		dq 5 dup(?),0
	st1		db "Задана последовательность структур. Структура содержит поля: название автомобиля, порядковый номер, имя владельца, количество нарушений. Вывести на экран имя владельца с минимальным числом нарушений.", 0
	ifmt	db "Имя владельца: %c ", 10,
			   "Автор - Анисимов В.", 0

	sr		dq ?
	fmt		db "%c",0
	res		db ?
.code
main proc
	sub		rsp, 28h; выравнивание стека 28h=32d+8; 32d x 8 = 256; 8 - возврат
	mov		rbp, rsp ; сохранение выровненного значения стека
	invoke MessageBox, 0,addr date,addr st1,MB_ICONQUESTION
	lea		rsi,	first ; загрузка адреса первой строки структуры
	mov		rax,	[rsi]
	mov		sr,		rax
	lea		rsi,	second ; загрузка адреса 2-й строки структуры
	mov		rax,	[rsi] ; первое поле второй строки структуры
	cmp		sr,		rax
js fin1

twocmp:
	lea	rsi,	third ; загрузка адреса 3-й строки структуры
	mov	rax,	[rsi] ; первое поле третей строки структуры
	cmp	sr,		rax
		js		fin2
threecmp:
	lea	rsi,	fourth ; загрузка адреса 4-й строки структуры
	mov	rax,	[rsi] ; первое поле 4-й строки структуры
	cmp	sr,		rax
		js		fin3
	jmp ending
fin1:
	mov	rax,	[rsi]
	mov	sr,		rax
	add	rsi,	4 ; подготовка адреса нового элемента
	lea	rdi,	res
	invoke wsprintf, ADDR [rdi], ADDR fmt, [rsi]
	jmp	twocmp
fin2:
	mov	rax,[rsi]
	mov	sr, rax
	add	rsi,4 ; подготовка адреса нового элемента
	lea	rdi, res
	invoke wsprintf,ADDR [rdi],ADDR fmt, [rsi]
	jmp threecmp
fin3:
	mov		rax,	[rsi]
	mov		sr,		rax
	add		rsi,	4 ; подготовка адреса нового элемента
	lea		rdi,	res
	invoke wsprintf, ADDR [rdi], ADDR fmt, [rsi]
	jmp		ending

ending:
	 invoke wsprintf, ADDR buf, ADDR ifmt, res
	 mov	params.cbSize,SIZEOF MSGBOXPARAMSA		; размер структуры
	 mov	params.hwndOwner,0						; дескриптор окна владельца
	 invoke GetModuleHandle,0						; получение дескриптора программы
	 mov	params.hInstance,rax					; сохранение дескриптора программы
	 lea	rax, buf								; адрес сообщения

	 mov	params.lpszText, rax
	 lea	rax,st1									; адрес заглавия окна
	 mov	params.lpszCaption,rax
	 mov	params.dwStyle, MB_USERICON				; стиль окна
	 mov	params.lpszIcon, IDI_ICON				; ресурс значка
	 mov	params.dwContextHelpId, 0				; контекст справки
	 mov	params.lpfnMsgBoxCallback,0
	 mov	params.dwLanguageId, LANG_NEUTRAL
	 lea	rcx,params

	 invoke MessageBoxIndirect
	 invoke ExitProcess,0
main endp
End
