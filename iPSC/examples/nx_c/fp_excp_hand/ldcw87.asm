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
; This module allows you to load the control word of the 80287.  It 
; can be called from C and has one parameter, the control word 
; to load.
;
; A sample of how you can call this program from C followes:
;
;	define cw 0x13bc
;      		int cdum;  /* status of fldcw, returned from 287 */
;      		cdum=ldcw87(cw); 
;
;  In this case the last byte c of 13bc unmasks both interrupts.
;
;***********************************************************************;
		name		ldcw87

ldcw87_txt	segment		er public

		public		_ldcw87
_ldcw87		proc		far
		
		enter		2,0

		fninit
		fldcw		[bp+6]

		leave
		ret

_ldcw87		endp
ldcw87_txt	ends
		end
