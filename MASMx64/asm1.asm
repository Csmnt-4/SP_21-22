include C:\masm32\include64\masm64rt.inc
    .data

	titl1	db "�������� ������, Y2438 �� �10; AVX", 0
	strbuf1	dq 1 dup(0)
	txt1	db	"��������� ������������ ��������� �������� �� 3-� 64-��������� ������������ �����. ���� ��� ����� ������� ������� ������ �������, �� ��������� ����� ������������� ��������, � ���� �������� � �� ������������.", 10, 10,
				"��������� = 4", 10,
				"����� - �������� �.",0
    .code
main proc
  
    invoke  wsprintf, ADDR strbuf1, ADDR txt1, rbx
    invoke  MessageBox, 0, addr strbuf1, addr titl1, MB_ICONINFORMATION;
    invoke  ExitProcess,0
main endp;
end