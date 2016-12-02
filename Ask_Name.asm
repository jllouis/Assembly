TITLE AskName
; Author: J. L. Louis
; Date: Sometime

Include Irvine32.inc

.data

myname		BYTE	100 dup(0),0
prompt1 	BYTE	"Enter your name: ",0
prompt2 	BYTE	"Your name is: ",0
prompt3		BYTE	"The length of your name is: ",0

.code
		

main		PROC

			MOV		EDX, offset prompt1
			CALL	WriteString
			MOV		EDX, offset myname
			MOV		ECX, SIZEOF myname
			CALL	ReadString
			MOV		EDX, offset prompt2
			CALL	WriteString
			MOV		EDX, offset myname
			CALL	WriteString
		
			CALL 	CRLF
		
			XOR 	EAX, EAX
			XOR 	EBX, EBX
			XOR 	EDX, EDX
Looper:
			CMP 	myname[EDX], 0
			JE		endcount
			INC 	EBX
			INC		EDX
			LOOP 	Looper
endcount:
			MOV 	EAX, EBX
			MOV 	EDX, offset prompt3
			CALL	WriteString
			CALL 	WriteDec
		
		exit

main 	ENDP
END main