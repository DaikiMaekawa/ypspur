! Startup routine of SH7045 for YPSpur
!  Written by Atsushi Watanabe
!  Robot Platform Project of Intelligent Robot Laboratory, University of Tsukuba


! Copyright 2011 Intelligent Robot Laboratory, University of Tsukuba. 
!  All rights reserved.
!
! Redistribution and use in source and binary forms, with or without 
! modification, are permitted provided that the following conditions are met:
!
! * Redistributions of source code must retain the above copyright notice, this 
!   list of conditions and the following disclaimer.
! * Redistributions in binary form must reproduce the above copyright notice, 
!   this list of conditions and the following disclaimer in the documentation 
!   and/or other materials provided with the distribution.
!
! THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR 
! IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
! MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO 
! EVENT SHALL THE FREEBSD PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
! INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
! (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
! LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND 
! ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
! (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
! SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


! NOTE:
!  This startup routine does not clear the global variables


	.section .text
	.global  _reset_vector
	.extern  _data_begin
	.extern  _data_end
	.extern  _data_img_begin

_reset_vector:
	MOV      #0,           r15       ! Reset stack pointer

! Copying default value from ROM to RAM
	MOV.L    DATA_BGN,     r0
	MOV.L    DATA_END,     r1
	MOV.L    DATA_IMG_BGN, r2
	CMP/EQ   r0,           r1
	BF       END_MEMCPY1
	NOP
LOOP_MEMCPY1:
	MOV.B    @r2,          r3
	MOV.B    r3,           @r0
	ADD      #1,           r0
	CMP/EQ	 r0,           r1
	BF/S     END_MEMCPY1             ! Delayed branch
	ADD      #1,           r2
END_MEMCPY1:

	MOV.L    MAIN_FUNC,    r0
	JSR      @r0
	NOP
STOP:
	BRA      STOP
	NOP



	.align   4

! Address of .data section
DATA_BGN:
	.long    _data_begin
DATA_END:
	.long    _data_end

! Address of the image of .data section
DATA_IMG_BGN:
	.long    _data_img_begin


	.align   4
	.global	 _setIntMask
_setIntMask:
	SHLL2    r4
	SHLL2    r4
	STC      sr,           r1
	OR       r4,           r1
	MOV.L    INT_MASK,     r4
	AND      r4,           r1
	LDC      r1,           sr
	RTS
	NOP

	.align  4
	.global	_getIntMask
_getIntMask:
	STC      sr,           r0
	SHLR2    r0
	SHLR2    r0
	AND      #0xF,         r0
	RTS
	NOP

    .align  4
INT_MASK:
	.long    0xFFFFFF0F

MAIN_FUNC:
	.long    _main

	.align   4
	.global  ___main
___main:
	RTS
	NOP

	.end
