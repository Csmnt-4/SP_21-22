include C:\masm64\include64\masm64rt.inc
count PROTO arg_1:QWORD

.data
	titl1	db "Анисимов Виктор, Y2438 ЛР №4", 0
	inf1	db "Сумма элементов:", 0Ah, "Res1: %d", 0Ah , "Res2: %d", 0Ah , "Res3: %d",
				0Ah , "Res4: %d",  0Ah, "Res5: %d", 0Ah , "Res6: %d", 0Ah , "Res7: %d", 
				0Ah , "Res8: %d",  0

	arr1	dq 1, 2, 3, 4, 5, 5, 4, 3, 2, 1
	len1	equ ($-arr1)/type arr1

	res1	dq 0
	res2	dq 0
	res3	dq 0
	res4	dq 0
	res5	dq 0
	res6	dq 0
	res7	dq 0
	res8	dq 0

	buf1	dq 0, 0

.code
count proc arg_1:QWORD
	mov rcx, arg_1
	lea rbx, arr1			; начальный адрес первого элемента в массиве

a0:
	mov		rax, [rbx]		; запись элемента массива в rax

	bt		rax, 0			; выделяем 0-ой бит из rax (значение записывается во флаг CF)
		jc		a1			; если CF=1, то перейти на метку a1
		jnc		a2			; если CF=0, то перейти на метку a2

a1:
	bt		rax, 1			; выделяем 1-ый бит из eax (значение записывается во флаг CF)
		jc		a3			; если CF=1, то перейти на метку a3
		jnc		a4			; если CF=0, то перейти на метку a4
a2:
	bt		rax, 1			; выделяем 1-ый бит из eax (значение записывается во флаг CF)
		jnc		a5			; если CF=0, то перейти на метку a5
		jc		a6			; если CF=1, то перейти на метку a6

a3:
	bt		rax, 4			; выделяем 4-ый бит из eax (значение записывается во флаг CF)
		jc		a7			; если CF=1, то перейти на метку a7
		jnc		a8			; если CF=0, то перейти на метку a8
a4:
	bt		rax, 4			; выделяем 4-ый бит из eax (значение записывается во флаг CF)
		jnc		a9			; если CF=0, то перейти на метку a9
		jc		a10			; если CF=1, то перейти на метку a10
a5:
	bt		rax, 4			; выделяем 4-ый бит из eax (значение записывается во флаг CF)
		jc		a11			; если CF=1, то перейти на метку a11
		jnc		a12			; если CF=0, то перейти на метку a12
a6:
	bt		rax, 4			; выделяем 4-ый бит из eax (значение записывается во флаг CF)
		jnc		a13			; если CF=0, то перейти на метку a13
		jc		a14			; если CF=1, то перейти на метку a14

a7: 
	add		res1, rax		; считаем сумму элементов c одинаковыми битами
	jmp		fin
a8: 
	add		res2, rax
	jmp		fin
a9: 
	add		res3, rax
	jmp		fin
a10: 
	add		res4, rax
	jmp		fin
a11: 
	add		res5, rax
	jmp		fin
a12: 
	add		res6, rax
	jmp		fin
a13: 
	add		res7, rax
	jmp		fin
a14: 
	add		res8, rax
	jmp		fin

fin: 
	add		rbx, type arr1	; повторение цикла, пока не закончатся элементы
		dec		rcx
		jnz		a0
ret
count endp

main proc
	invoke	count,	len1
	invoke	wsprintf, ADDR buf1, ADDR inf1, res1, res2, res3, res4, res5, res6, res7, res8
	invoke	MessageBox, 0, ADDR buf1, ADDR titl1, MB_ICONINFORMATION
	invoke	ExitProcess, 0
main endp
end
