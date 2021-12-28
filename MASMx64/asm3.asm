include C:\masm64\include64\masm64rt.inc

.data
	a1		dq 8
	b1		dq 2
	c1		dq 2
	d1		dq 1
	e1		dq 4
	f1		dq 2

	res1	dq ?, 0
	res2	dq ?, 0
	res3	dq ?, 0
	res4	dq ?, 0

	titl1	db "Анисимов Виктор, Y2438 ЛР №3", 0
	txt1	db "a/c — e/f – ad", 0Ah, "Результат: %d", 0Ah, "Количество тактов: %d", 0Ah, 0Ah,
			   "При использовании команд сдвига: %d", 0Ah, "Количество тактов: %d", 0Ah, 0

    ;str1    db ?, 0
    ;txt2    db "Посмотрим... у нас тут %d", 0 ; - это для логирования

	buf1	dq ?, 0

.code
count1	proc arg_1:QWORD, arg_2:QWORD, arg_3:QWORD, arg_4:QWORD, arg_5:QWORD, arg_6:QWORD
	rdtsc					; получение числа тактов с момента сброса
	xchg	rdi,	rax		; обмен значениями
	xor		rdx,	rdx		; обнуление регистра

	mov		rax,	arg_1
	div		arg_3
	mov		rbx,	rax

	mov		rax,	arg_5
	div		arg_6

	sub		rbx,	rax

	mov		rax,	arg_1
	mul		arg_4

	sub		rbx,	rax

	mov		res1,	rbx		; сохранение результата
	rdtsc					; получение числа тактов с момента сброса
	sub		rax,	rdi		; вычитание текущего числа тактов из предыдущего 
	mov		res2,	rax
ret
count1	endp

count2 proc	arg_1:QWORD, arg_2:QWORD, arg_3:QWORD, arg_4:QWORD, arg_5:QWORD, arg_6:QWORD
	
	rdtsc
	xchg	rdi,	rax
	sar		rcx,	1
	
	mov		res3,	rcx		; сохранение промежуточного результата

	sar		rcx,	1		; сдвиг вправо
	sub		res3,	rcx

	sal		rcx,	2		; сдвиг влево
	sub		res3,	rcx
	
	mov		rbx, res3

	rdtsc
	sub		rax,	rdi
	mov		res4,	rax
ret
count2	endp

main	proc
	invoke  count1, a1, b1, c1, d1, e1, f1
	invoke	count2, a1, b1, c1, d1, e1, f1

	invoke	wsprintf, ADDR buf1, ADDR txt1, res1, res2, res3, res4
	invoke	MessageBox, 0, ADDR buf1, ADDR titl1, MB_ICONINFORMATION
	invoke	ExitProcess, 0
main	endp
end
