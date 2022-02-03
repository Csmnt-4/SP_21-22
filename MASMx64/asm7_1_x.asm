OPTION CASEMAP:none
OPTION DOTNAME ; вкл. и отключение функции ассемблера
include C:\masm64\include64\masm64rt.inc

	IDI_ICON EQU 1001 ; моя иконка
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
	
	tit1	db	"Анисимов Виктор, Y2438 ЛР №7; Структура 1", 0
	buf1	dq	1 dup(0)
	ifmt	db	"Задана матрица 2 х 6. В первой строке матрицы определить сумму нечетных элементов, а во 2-й строке - четных.", 10,
				"Нечётные: %d", 10,
				"Чётные: %d", 10,
				"Автор - Анисимов В.", 0
	
	res1	dq ?
	res2	dq ?

.code
main proc

	sub rsp, 28h		; выравнивание стека 28h=32d+8; 8 - возврат
	mov rbp, rsp		; сохранение выравненного значения стека
	xor r10, r10		; регистр результата
	xor r11, r11		; регистр результата
	mov rdx, 2			; загрузка количества строк
	lea rsi, row1		; загрузка адреса первой строки структуры

row_len:
	 mov rcx, 6

the_odd_loop: 
	 mov rax, [rsi]		; загрузка элемента из строки структуры
	 jpo odd_add		; перейти на odd_add, если элемент не четён
	 jmp pre_end		; безусловный переход

the_even_loop: 
	 mov rax, [rsi]		; загрузка элемента из строки структуры
	 jpe even_add		; перейти на even_add, если элемент чётен
	 jmp not_end		; безусловный переход

odd_add:
	 add r10, rax 

even_add:
	 add r11, rax

pre_end:
	 add rsi, type row1		; подготовка адреса нового элемента
	 loop the_odd_loop 
	 dec rcx				; ebx := ebx – 1
	 lea rsi, row2			; загрузка адреса новой строки
	 jmp the_even_loop		; переход на новый цикл 

not_end:
	 add rsi, type row1		; подготовка адреса нового элемента
	 loop the_even_loop
	 dec rcx
	 jz ending

ending:
	 invoke wsprintf, ADDR buf1, ADDR ifmt, r10, r11
	 mov	params.cbSize, SIZEOF MSGBOXPARAMSA		; размер структуры
	 mov	params.hwndOwner, 0						; дескриптор окна владельца
	 invoke GetModuleHandle, 0						; получение дескриптора программы
	 mov	params.hInstance, rax					; сохранение дескриптора программы

	 lea	rax, buf1 ; адрес сообщения
	 mov	params.lpszText, rax
	 lea	rax, tit1 
	 mov	params.lpszCaption, rax
	 mov	params.dwStyle, MB_USERICON			; стиль окна
	 mov	params.lpszIcon, IDI_ICON			; ресурс значка
	 mov	params.dwContextHelpId, 0			; контекст справки
	 mov	params.lpfnMsgBoxCallback, 0
	 mov	params.dwLanguageId, LANG_NEUTRAL	; язык сообщения
	 lea	rcx, params

	 invoke MessageBoxIndirect
	 invoke ExitProcess,0
main endp
End
