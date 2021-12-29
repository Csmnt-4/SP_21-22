include C:\masm64\include64\masm64rt.inc
.data
	x1 dq 2.0

	op1 dq 7.0
	op2 dq 0.3
	
	z dq 0.0
	step1 dq 3.5

	res1 dd 0
	res2 dd 0
	res3 dd 0
	res4 dd 0
	res5 dd 0

	titl1	db "Анисимов Виктор, Y2438 ЛР №4", 0

	buf1 dq 5 dup(0)
	inf1 db "Y = 7(x + 0,3)",10,10,"Ответ: %d, %d, %d, %d, %d",0ah,0ah

.code
WinMain proc
sub rsp,28h
mov rbp,rsp
finit
lea esi,res1
mov ecx, 5
m1: fld _x
fadd _op2
fmul _op1
fld _x
fadd _step
fstp _x
loop m1
  fisttp res1
  fisttp res2
  fisttp res3
  fisttp res4
  fisttp res5
movsxd r10,res1
movsxd r11,res2
movsxd r12,res3
movsxd r13,res4
movsxd r14,res5

invoke wsprintf,ADDR buf,ADDR ifmt,r10,r11,r12,r13,r14
invoke MessageBox,0,addr buf,addr tit1,MB_ICONINFORMATION;
invoke ExitProcess,0
WinMain endp
End
