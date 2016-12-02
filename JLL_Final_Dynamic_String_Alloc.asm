TITLE JoseLaelLouis_Final_Proj.asm

;By: Jose L. Louis
;Date: 5/22/14


INCLUDE Irvine32.INC

HANDLE 		TEXTEQU		<DWORD>

free		MACRO		hHandle
		PUSH		hHandle
		CALL		mfree
		ENDM

new		MACRO		heapSize 
		PUSH		heapSize
		CALL		malloc
		ENDM

getStr 		MACRO		input
		PUSH		EDX
		PUSH		ECX

		printStrPTR	strInput
		
		MOV		EDX, offset input
		MOV		ECX, SIZEOF input
		CALL		ReadString

		POP		ECX	
		POP		EDX	
		ENDM

printStrPTR 	MACRO		text
		PUSH		EDX

		MOV		EDX, offset text
		CALL		WriteString

		POP		EDX
		ENDM

prntStr 	MACRO		text
		PUSH		EDX

		MOV		EDX, text
		CALL		WriteString
		CALL		CRLF

		POP		EDX
		ENDM

strLen		MACRO		text
		PUSH		EDX

		MOV		EDX, offset text
		PUSH		EDX
		CALL		strLenP

		POP		EDX
		ENDM	

strCpy	MACRO			hHandle, text
		PUSH		ECX
		PUSH		EBX

		MOV		ECX, hHandle
		MOV		EBX, offset text

		PUSH		ECX
		PUSH		EBX
		CALL		strCpyP

		POP		EBX
		POP		ECX
		ENDM

strRev		MACRO		hHandle
		PUSH		EAX

		MOV		EAX, hHandle
		PUSH		EAX
		CALL		strRevP

		POP		EAX
		ENDM

swap		MACRO		a,b
		PUSH		EAX

		MOV		AH,a
		MOV		AL,b

		XOR		AH,AL
		XOR		AL,AH
		XOR		AH,AL

		MOV		a,AH
		MOV		b,AL
		POP		EAX
		ENDM

printHeap	MACRO		text
		strLen		text
		new		EAX
		strCpy		EAX, text
		strRev		EAX
		prntStr		EAX
		free		EAX
		ENDM

.data


GetProcessHeap	PROTO
HeapAlloc	PROTO		, hHeap:HANDLE, dwFlags:DWORD, dwBytes:DWORD
HeapFree	PROTO		, hHeap:HANDLE, dwFlags:DWORD, lpMem:DWORD

strInput	BYTE		"Input: ",0		
buffer		BYTE		20 dup(0),0


.code


strRevP		PROC		
		PUSH		EBP
		MOV		EBP, ESP	
		PUSH		EBX
		PUSH		ECX
		PUSH		EDX
	
		MOV		ECX, [EBP+8]
		MOV		EBX, ECX
		MOV		EDX, EBX

		PUSH		EDX
		CALL		strLenP		

		DEC		EAX
		ADD		EBX, EAX
rvrse:
		CMP		EAX,0
		JL		endrev

		swap	        [ECX],[EBX]
		INC		ECX
		DEC		EBX
		SUB		EAX,2
		JMP		rvrse
endrev:		
		MOV		EAX, ECX
		POP		EDX
		POP		ECX
		POP		EBX
		POP		EBP

		RET             4
strRevP		ENDP

strLenP		PROC
		PUSH		EBP
		MOV		EBP, ESP
		PUSH		EBX
		PUSH		ECX
		
		MOV		EBX, [EBP+8]				
		MOV		EAX, 0
countChars:	
		MOV 		ECX, [EBX]
		CMP		ECX, 0
		JZ		endCountChars
		INC 		EBX
		INC		EAX
		jnz		countChars
endCountChars:
		POP		ECX
		POP		EBX
		POP		EBP

		RET		4
strLenP		ENDP

strCpyP	PROC
		PUSH		EBP
		MOV		EBP, ESP		
		PUSH		EDX
		PUSH		EBX
		PUSH		ECX
		
		MOV		EDX, [EBP+8]
		MOV		EBX, [EBP+12]
strCpyFunc:	
		MOV		AL,[EBX]
		CMP		AL,0
		JZ		endStrFunc
		MOV		[EDX],AL
		INC		EDX
		INC		EBX
endStrFunc:
		MOV		EAX, EDX
		POP		ECX
		POP		EBX
		POP		EDX
		POP		EBP		

		RET		8			
strCpyP	ENDP

mfree		PROC
		PUSH		EBP
		MOV		EBP, ESP
		PUSH		EBX
			
		MOV		EBX, [EBP+8]
		
		INVOKE		GetProcessHeap	
		INVOKE		HeapFree, EAX, 0, EBX
			
		POP		EBX
		POP		EBP
		RET	        4
mfree		ENDP	

malloc	PROC
		PUSH		EBP
		MOV		EBP, ESP
		PUSH		EBX
		
		MOV		EBX, [EBP+8]

		INVOKE		GetProcessHeap
		INVOKE		HeapAlloc, EAX, 8, EBX
		
		POP		EBX
		POP		EBP
		RET             4
malloc	ENDP

getStr	PROC
		getStr		buffer

		RET             
getStr	ENDP

main		PROC
		CALL		ClrScr

		MOV		EBX, 0
label0:
		CMP             EBX, 5
		JE		label1
		getStr		buffer
		printHeap	buffer
		INC		EBX
		JMP		label0
label1:	
		exit
main		ENDP
		END 		main