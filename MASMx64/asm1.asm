include C:\masm32\include64\masm64rt.inc
    .data

	titl1	db "Анисимов Виктор, Y2438 ЛР №10; AVX", 0
	strbuf1	dq 1 dup(0)
	txt1	db	"Выполнить параллельное сравнение массивов по 3-и 64-разрядных вещественных числа. Если все числа второго массива больше первого, то выполнить поиск максимального значения, а если наоборот – то минимального.", 10, 10,
				"Результат = 4", 10,
				"Автор - Анисимов В.",0
    .code
main proc
  
    invoke  wsprintf, ADDR strbuf1, ADDR txt1, rbx
    invoke  MessageBox, 0, addr strbuf1, addr titl1, MB_ICONINFORMATION;
    invoke  ExitProcess,0
main endp;
end