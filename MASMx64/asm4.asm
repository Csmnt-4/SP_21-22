include C:\masm64\include64\masm64rt.inc
count PROTO arg_1:QWORD

.data
	titl1	db "�������� ������, Y2438 �� �4", 0
	inf1	db "����� ���������:", 0Ah, "Res1: %d", 0Ah , "Res2: %d", 0Ah , "Res3: %d",
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
	lea rbx, arr1			; ��������� ����� ������� �������� � �������

a0:
	mov		rax, [rbx]		; ������ �������� ������� � rax

	bt		rax, 0			; �������� 0-�� ��� �� rax (�������� ������������ �� ���� CF)
		jc		a1			; ���� CF=1, �� ������� �� ����� a1
		jnc		a2			; ���� CF=0, �� ������� �� ����� a2

a1:
	bt		rax, 1			; �������� 1-�� ��� �� eax (�������� ������������ �� ���� CF)
		jc		a3			; ���� CF=1, �� ������� �� ����� a3
		jnc		a4			; ���� CF=0, �� ������� �� ����� a4
a2:
	bt		rax, 1			; �������� 1-�� ��� �� eax (�������� ������������ �� ���� CF)
		jnc		a5			; ���� CF=0, �� ������� �� ����� a5
		jc		a6			; ���� CF=1, �� ������� �� ����� a6

a3:
	bt		rax, 4			; �������� 4-�� ��� �� eax (�������� ������������ �� ���� CF)
		jc		a7			; ���� CF=1, �� ������� �� ����� a7
		jnc		a8			; ���� CF=0, �� ������� �� ����� a8
a4:
	bt		rax, 4			; �������� 4-�� ��� �� eax (�������� ������������ �� ���� CF)
		jnc		a9			; ���� CF=0, �� ������� �� ����� a9
		jc		a10			; ���� CF=1, �� ������� �� ����� a10
a5:
	bt		rax, 4			; �������� 4-�� ��� �� eax (�������� ������������ �� ���� CF)
		jc		a11			; ���� CF=1, �� ������� �� ����� a11
		jnc		a12			; ���� CF=0, �� ������� �� ����� a12
a6:
	bt		rax, 4			; �������� 4-�� ��� �� eax (�������� ������������ �� ���� CF)
		jnc		a13			; ���� CF=0, �� ������� �� ����� a13
		jc		a14			; ���� CF=1, �� ������� �� ����� a14

a7: 
	add		res1, rax		; ������� ����� ��������� c ����������� ������
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
	add		rbx, type arr1	; ���������� �����, ���� �� ���������� ��������
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
