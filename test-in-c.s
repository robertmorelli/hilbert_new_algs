	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 2
	.globl	_sepBy2Only26Bits               ; -- Begin function sepBy2Only26Bits
	.p2align	2
_sepBy2Only26Bits:                      ; @sepBy2Only26Bits
	.cfi_startproc
; %bb.0:
	mov	w8, #20756
	movk	w8, #261, lsl #16
	and	w0, w0, w8
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_sepBy2Only32Bits               ; -- Begin function sepBy2Only32Bits
	.p2align	2
_sepBy2Only32Bits:                      ; @sepBy2Only32Bits
	.cfi_startproc
; %bb.0:
	orr	w8, w0, w0, lsl #16
Lloh0:
	adrp	x9, _masks@PAGE+4
Lloh1:
	add	x9, x9, _masks@PAGEOFF+4
	ldp	w10, w11, [x9]
	and	w8, w10, w8
	orr	w8, w8, w8, lsl #8
	and	w8, w8, w11
	orr	w8, w8, w8, lsl #4
	ldp	w10, w11, [x9, #8]
	and	w8, w8, w10
	orr	w8, w8, w8, lsl #2
	and	w8, w8, w11
	orr	w8, w8, w8, lsl #1
	ldr	w9, [x9, #16]
	and	w0, w8, w9
	ret
	.loh AdrpAdd	Lloh0, Lloh1
	.cfi_endproc
                                        ; -- End function
	.globl	_time_diff                      ; -- Begin function time_diff
	.p2align	2
_time_diff:                             ; @time_diff
	.cfi_startproc
; %bb.0:
	scvtf	d0, x0
	scvtf	d1, w1
	mov	x8, #145685290680320
	movk	x8, #16686, lsl #48
	fmov	d2, x8
	scvtf	d3, x2
	fmadd	d0, d0, d2, d1
	scvtf	d1, w3
	fmadd	d1, d3, d2, d1
	fsub	d0, d1, d0
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #96
	.cfi_def_cfa_offset 96
	stp	d9, d8, [sp, #48]               ; 16-byte Folded Spill
	stp	x20, x19, [sp, #64]             ; 16-byte Folded Spill
	stp	x29, x30, [sp, #80]             ; 16-byte Folded Spill
	add	x29, sp, #80
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset b8, -40
	.cfi_offset b9, -48
	mov	x0, #0
	bl	_time
                                        ; kill: def $w0 killed $w0 killed $x0
	bl	_srand
	mov	w19, #16960
	movk	w19, #15, lsl #16
LBB3_1:                                 ; =>This Inner Loop Header: Depth=1
	bl	_rand
	subs	w19, w19, #1
	b.ne	LBB3_1
; %bb.2:
	add	x0, sp, #32
	mov	x1, #0
	bl	_gettimeofday
	add	x0, sp, #16
	mov	x1, #0
	bl	_gettimeofday
	ldr	d0, [sp, #32]
	scvtf	d0, d0
	ldr	s1, [sp, #40]
	sshll.2d	v1, v1, #0
	scvtf	d1, d1
	mov	x8, #145685290680320
	movk	x8, #16686, lsl #48
	fmov	d8, x8
	fmadd	d0, d0, d8, d1
	ldr	d1, [sp, #16]
	scvtf	d1, d1
	ldr	s2, [sp, #24]
	sshll.2d	v2, v2, #0
	scvtf	d2, d2
	fmadd	d1, d1, d8, d2
	fsub	d0, d1, d0
	str	d0, [sp]
Lloh2:
	adrp	x0, l_.str@PAGE
Lloh3:
	add	x0, x0, l_.str@PAGEOFF
	bl	_printf
	add	x0, sp, #32
	mov	x1, #0
	bl	_gettimeofday
	add	x0, sp, #16
	mov	x1, #0
	bl	_gettimeofday
	ldr	d0, [sp, #32]
	scvtf	d0, d0
	ldr	s1, [sp, #40]
	sshll.2d	v1, v1, #0
	scvtf	d1, d1
	fmadd	d0, d0, d8, d1
	ldr	d1, [sp, #16]
	scvtf	d1, d1
	ldr	s2, [sp, #24]
	sshll.2d	v2, v2, #0
	scvtf	d2, d2
	fmadd	d1, d1, d8, d2
	fsub	d0, d1, d0
	str	d0, [sp]
Lloh4:
	adrp	x0, l_.str.1@PAGE
Lloh5:
	add	x0, x0, l_.str.1@PAGEOFF
	bl	_printf
	mov	w0, #0
	ldp	x29, x30, [sp, #80]             ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #64]             ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               ; 16-byte Folded Reload
	add	sp, sp, #96
	ret
	.loh AdrpAdd	Lloh4, Lloh5
	.loh AdrpAdd	Lloh2, Lloh3
	.cfi_endproc
                                        ; -- End function
	.section	__DATA,__data
	.globl	_masks                          ; @masks
	.p2align	2, 0x0
_masks:
	.long	4294967295                      ; 0xffffffff
	.long	65535                           ; 0xffff
	.long	16711935                        ; 0xff00ff
	.long	252645135                       ; 0xf0f0f0f
	.long	858993459                       ; 0x33333333
	.long	1431655765                      ; 0x55555555

	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"sepBy2Only26Bits: %f microseconds\n"

l_.str.1:                               ; @.str.1
	.asciz	"sepBy2Only32Bits: %f microseconds\n"

.subsections_via_symbols
