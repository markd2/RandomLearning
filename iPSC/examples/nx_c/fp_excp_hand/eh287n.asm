%metachar(#)
;***********************************************************************;
;									;
;		INTEL CORPORATION PROPRIETARY INFORMATION		;
;									;
;	This software is supplied under the terms of a license		;
;	agreement or nondisclosure agreement with Intel Corporation	;
;	and may not be copied or disclosed except in accordance		;
;	with the terms of that agreement.				;
;									;
;	eh287n.asm 1.2 86/10/07 11:08:01
;
;
;
; .{ TEXT
; .H 4 eh287n.asm
;
; This module contains the default floating point exception handler.
;
; .} TEXT
; .{ DETAIL
;
;***********************************************************************;
		name	eh287n

HANDLER_MODULE_DATA		segment rw public


estate		db	144 dup (?)

errors		dw	?
		db	?

HANDLER_MODULE_DATA		ends

		public	_ieee_handler

		extrn	decode: far
		extrn	encode: far
		extrn	normal: far

HANDLER_MODULE_CODE		segment	er public
		assume ds:HANDLER_MODULE_DATA

;***********************************************************************;
;.{ TEXT
;.ne 30
;.H 5 "ieee_handler"
;.DS
;	
;	Calling Sequence:
;	      N/A
;	
;	Description:
;	      Interrupt handler for floating point exceptions.
;	      Normalizes unnormals, retries all others with exceptions
;	      masked.
;	
;	Parameters:
;	      none
;	
;	Returns:
;	      none
;	
;	Called by:
;	      TBD
;
;.DE
;.} TEXT
;***********************************************************************;


_IEEE_HANDLER	PROC FAR

	PUSHA					; save registers
	PUSH	ES				;
	PUSH	DS				;
	MOV	CX,HANDLER_MODULE_DATA		; load DS
	MOV	DS,CX				;
	PUSH	BP				; set up frame
	MOV	BP,SP				;
	FNSTSW	ERRORS				; get error word
	FNCLEX 					; clear exceptions
						;
	MOV	CX,OFFSET(ESTATE)		; CALL DECODE(&ESTATE, ERRORS)
	PUSH	DS				;
	PUSH	CX				;
	PUSH	ERRORS				;
	CALL	DECODE				;
						;
	MOV	AX,OFFSET(ESTATE)		; CALL NORMAL(&ESTATE, ERRORS)
	PUSH	DS				;
	PUSH	AX				;
	PUSH	ERRORS				;
	CALL	NORMAL				;
						;
	RCR	AX,1				; done if it returns true
	JNB	next				;
	JMP	done				;
next:						;
	CMP	ESTATE,0FH			; check for store op
	JZ	$+5H				;
	JMP	done				; jump away if not
	TEST	ERRORS, 01H			; check for Invalid Op error
	JNZ	$+5H				;
	JMP	done				; jump away if not
	MOV	AX,WORD PTR ESTATE+3H		; check if need to normalize
	MOV	CX,7FFFH			;
	AND	AX,CX				;
	CMP	AX,CX				;
	JNZ	$+5H				;
	JMP	done				; jump away if not
						;
	MOV	AX, WORD PTR ESTATE+3H		; get arg1 in registers
	MOV	BX, WORD PTR ESTATE+5H		;
	MOV	CX, WORD PTR ESTATE+7H		;
	MOV	DX, WORD PTR ESTATE+9H		;
	MOV	DI, WORD PTR ESTATE+0BH		;
	MOV	SI, AX				; check for zero fraction
	OR	SI, BX				;
	OR	SI, CX				;
	OR	SI, DX				;
	JZ	copy				; jump if zero
norm:						;
	TEST	DX, 8000H			; check MSB
	JNZ	restore				; jump when it becomes 1
	SHL	AX, 1				; shift it all left
	RCL	BX, 1				;
	RCL	CX, 1				;
	RCL	DX, 1				;
	DEC	DI				; decrement exponent
	JMP	norm				; loop til done
						;
restore:					;
	MOV	WORD PTR ESTATE+3H,AX		; copy registers back to arg1
	MOV	WORD PTR ESTATE+5H,BX		;
	MOV	WORD PTR ESTATE+7H,CX		;
	MOV	WORD PTR ESTATE+9H,DX		;
	MOV	WORD PTR ESTATE+0BH,DI		;
copy:						;
	MOV	WORD PTR ESTATE+1AH,AX		; copy arg1 to result
	MOV	WORD PTR ESTATE+1CH,BX		;
	MOV	WORD PTR ESTATE+1EH,CX		;
	MOV	WORD PTR ESTATE+20H,DX		;
	MOV	WORD PTR ESTATE+22H,DI		;
done:						;
	MOV	AX,OFFSET(ESTATE)		; CALL ENCODE(
	PUSH	DS				;	ESTATE,
	PUSH	AX				;
	PUSH	ERRORS				;	ERRORS,
	MOV	AX,WORD PTR ESTATE+32H		;	CONTROL_WORD | 003FH,
	OR	AX,3FH				;
	PUSH	AX				;
	PUSH	0FFH				;	TRUE)
	CALL	ENCODE				;
						;
	POP	BP				;
	POP	DS				;
	POP	ES				;
	POPA					;
	RET					;

_IEEE_HANDLER	ENDP

HANDLER_MODULE_CODE		ends

; .} DETAIL

		end
