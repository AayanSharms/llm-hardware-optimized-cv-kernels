	.build_version macos, 26, 0	sdk_version 26, 5
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ; -- Begin function main
lCPI0_0:
	.short	16                              ; 0x10
	.short	32                              ; 0x20
	.short	16                              ; 0x10
	.short	32                              ; 0x20
	.short	64                              ; 0x40
	.short	32                              ; 0x20
	.short	16                              ; 0x10
	.short	32                              ; 0x20
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #272
	stp	d9, d8, [sp, #160]              ; 16-byte Folded Spill
	stp	x28, x27, [sp, #176]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #192]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #208]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #224]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #240]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #256]            ; 16-byte Folded Spill
	add	x29, sp, #256
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_offset b8, -104
	.cfi_offset b9, -112
	mov	x19, x1
Lloh0:
	adrp	x8, ___stack_chk_guard@GOTPAGE
Lloh1:
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
Lloh2:
	ldr	x8, [x8]
	stur	x8, [x29, #-112]
	cmp	w0, #2
	b.gt	LBB0_2
; %bb.1:
Lloh3:
	adrp	x8, ___stderrp@GOTPAGE
Lloh4:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh5:
	ldr	x0, [x8]
	ldr	x8, [x19]
	str	x8, [sp]
Lloh6:
	adrp	x1, l_.str@PAGE
Lloh7:
	add	x1, x1, l_.str@PAGEOFF
	b	LBB0_10
LBB0_2:
	mov	x20, x0
	ldr	x0, [x19, #8]
	bl	_atoi
	mov	x27, x0
	ldr	x0, [x19, #16]
	bl	_atoi
	mov	x28, x0
	cmp	w20, #3
	b.ne	LBB0_4
; %bb.3:
	mov	w8, #100                        ; =0x64
	str	w8, [sp, #76]                   ; 4-byte Folded Spill
	b	LBB0_5
LBB0_4:
	ldr	x0, [x19, #24]
	bl	_atoi
	str	w0, [sp, #76]                   ; 4-byte Folded Spill
LBB0_5:
	mul	w22, w28, w27
	add	w19, w22, w22, lsl #1
	sxtw	x20, w19
	mov	x0, x20
	bl	_malloc
	mov	x21, x0
Lloh8:
	adrp	x8, ___stdinp@GOTPAGE
Lloh9:
	ldr	x8, [x8, ___stdinp@GOTPAGEOFF]
Lloh10:
	ldr	x3, [x8]
	mov	w1, #1                          ; =0x1
	mov	x2, x20
	bl	_fread
	cmp	w19, w0
	b.ne	LBB0_9
; %bb.6:
	str	x21, [sp, #48]                  ; 8-byte Folded Spill
	str	x20, [sp, #64]                  ; 8-byte Folded Spill
	sxtw	x20, w22
	mov	x0, x20
	bl	_malloc
	mov	x19, x0
	mov	x0, x20
	bl	_malloc
	str	x0, [sp, #56]                   ; 8-byte Folded Spill
	mov	x0, x20
	bl	_malloc
	mov	x21, x0
	mov	x0, x20
	bl	_malloc
	mov	x24, x0
	mov	x0, x20
	bl	_malloc
	mov	x25, x0
	mov	x0, x20
	bl	_malloc
	mov	x26, x0
	cmp	w22, #1
	mov	x15, x22
	mov	x22, x19
	b.lt	LBB0_23
; %bb.7:
	cmp	w15, #7
	b.hi	LBB0_12
; %bb.8:
	mov	x8, #0                          ; =0x0
	b	LBB0_21
LBB0_9:
Lloh11:
	adrp	x8, ___stderrp@GOTPAGE
Lloh12:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh13:
	ldr	x8, [x8]
	stp	x20, x0, [sp]
Lloh14:
	adrp	x1, l_.str.1@PAGE
Lloh15:
	add	x1, x1, l_.str.1@PAGEOFF
	mov	x0, x8
LBB0_10:
	bl	_fprintf
	mov	w0, #1                          ; =0x1
	ldur	x8, [x29, #-112]
Lloh16:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh17:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh18:
	ldr	x9, [x9]
	cmp	x9, x8
	b.ne	LBB0_87
LBB0_11:
	ldp	x29, x30, [sp, #256]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #240]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #224]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #208]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #192]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #176]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #160]              ; 16-byte Folded Reload
	add	sp, sp, #272
	ret
LBB0_12:
	cmp	w15, #32
	b.hs	LBB0_14
; %bb.13:
	mov	x8, #0                          ; =0x0
	b	LBB0_18
LBB0_14:
	and	x8, x15, #0x7fffffe0
	add	x9, x25, #16
	add	x10, x22, #16
	add	x11, x21, #16
	ldr	x12, [sp, #48]                  ; 8-byte Folded Reload
	mov	x13, x8
LBB0_15:                                ; =>This Inner Loop Header: Depth=1
	mov	x14, x12
	add	x12, x12, #96
	ld3.16b	{ v0, v1, v2 }, [x14], #48
	ld3.16b	{ v3, v4, v5 }, [x14]
	stp	q0, q3, [x10, #-16]
	stp	q1, q4, [x11, #-16]
	stp	q2, q5, [x9, #-16]
	add	x9, x9, #32
	add	x10, x10, #32
	add	x11, x11, #32
	subs	x13, x13, #32
	b.ne	LBB0_15
; %bb.16:
	cmp	x8, x15
	b.eq	LBB0_23
; %bb.17:
	tst	x15, #0x18
	b.eq	LBB0_21
LBB0_18:
	mov	x13, x8
	and	x8, x15, #0x7ffffff8
	sub	x9, x13, x8
	add	x10, x25, x13
	add	x11, x21, x13
	add	x12, x22, x13
	add	x13, x13, x13, lsl #1
	ldr	x14, [sp, #48]                  ; 8-byte Folded Reload
	add	x13, x14, x13
LBB0_19:                                ; =>This Inner Loop Header: Depth=1
	ld3.8b	{ v0, v1, v2 }, [x13], #24
	str	d0, [x12], #8
	str	d1, [x11], #8
	str	d2, [x10], #8
	adds	x9, x9, #8
	b.ne	LBB0_19
; %bb.20:
	cmp	x8, x15
	b.eq	LBB0_23
LBB0_21:
	sub	x9, x15, x8
	add	x10, x22, x8
	add	x11, x8, x8, lsl #1
	ldr	x12, [sp, #48]                  ; 8-byte Folded Reload
	add	x11, x11, x12
	add	x11, x11, #2
	add	x12, x25, x8
	add	x8, x21, x8
LBB0_22:                                ; =>This Inner Loop Header: Depth=1
	ldurb	w13, [x11, #-2]
	strb	w13, [x10], #1
	ldurb	w13, [x11, #-1]
	strb	w13, [x8], #1
	ldrb	w13, [x11], #3
	strb	w13, [x12], #1
	subs	x9, x9, #1
	b.ne	LBB0_22
LBB0_23:
	stp	x21, x15, [sp, #32]             ; 16-byte Folded Spill
Lloh19:
	adrp	x8, lCPI0_0@PAGE
Lloh20:
	ldr	q0, [x8, lCPI0_0@PAGEOFF]
	str	q0, [sp, #112]
	mov	w8, #16                         ; =0x10
	strh	w8, [sp, #128]
	sxtw	x20, w27
	sub	w19, w28, #1
	mul	w8, w19, w27
	sxtw	x21, w8
	ldr	x23, [sp, #56]                  ; 8-byte Folded Reload
	mov	x0, x23
	mov	x1, x22
	mov	x2, x20
	bl	_memcpy
	add	x0, x23, x21
	add	x1, x22, x21
	mov	x2, x20
	bl	_memcpy
	cmp	w28, #2
	b.le	LBB0_27
; %bb.24:
	str	x21, [sp, #24]                  ; 8-byte Folded Spill
	sub	x17, x19, #1
	cmp	x17, #7
	ccmp	w27, #1, #0, hi
	cset	w8, eq
	str	w8, [sp, #20]                   ; 4-byte Folded Spill
	mov	x16, x19
	ldr	x23, [sp, #32]                  ; 8-byte Folded Reload
	b.ne	LBB0_28
; %bb.25:
	cmp	x17, #32
	ldr	x21, [sp, #56]                  ; 8-byte Folded Reload
	b.hs	LBB0_29
; %bb.26:
	mov	x8, #0                          ; =0x0
	b	LBB0_33
LBB0_27:
	mov	x0, x24
	ldr	x23, [sp, #32]                  ; 8-byte Folded Reload
	mov	x1, x23
	mov	x2, x20
	bl	_memcpy
	add	x0, x24, x21
	add	x1, x23, x21
	mov	x2, x20
	bl	_memcpy
	mov	x0, x26
	mov	x1, x25
	mov	x2, x20
	bl	_memcpy
	add	x0, x26, x21
	add	x1, x25, x21
	mov	x2, x20
	bl	_memcpy
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	ldr	x21, [sp, #56]                  ; 8-byte Folded Reload
	b	LBB0_67
LBB0_28:
	mov	w9, #1                          ; =0x1
	ldr	x21, [sp, #56]                  ; 8-byte Folded Reload
	b	LBB0_37
LBB0_29:
	and	x8, x17, #0xffffffffffffffe0
	add	x9, x21, #17
	add	x10, x22, #17
	mov	x11, #4294967296                ; =0x100000000
	mov	x12, #137438953472              ; =0x2000000000
	mov	x13, x8
LBB0_30:                                ; =>This Inner Loop Header: Depth=1
	ldp	q0, q1, [x10, #-16]
	stp	q0, q1, [x9, #-16]
	asr	x14, x11, #32
	add	x15, x22, x14
	ldp	q0, q1, [x15]
	add	x14, x21, x14
	stp	q0, q1, [x14]
	add	x9, x9, #32
	add	x10, x10, #32
	add	x11, x11, x12
	subs	x13, x13, #32
	b.ne	LBB0_30
; %bb.31:
	cmp	x17, x8
	b.eq	LBB0_39
; %bb.32:
	tst	x17, #0x18
	b.eq	LBB0_36
LBB0_33:
	and	x10, x17, #0xfffffffffffffff8
	orr	x9, x10, #0x1
	add	x12, x8, #1
	add	x11, x21, x12
	add	x12, x22, x12
	mov	x15, #4294967296                ; =0x100000000
	sub	x13, x8, x10
	mov	x14, #34359738368               ; =0x800000000
	add	x8, x15, x8, lsl #32
LBB0_34:                                ; =>This Inner Loop Header: Depth=1
	ldr	d0, [x12], #8
	str	d0, [x11], #8
	asr	x15, x8, #32
	ldr	d0, [x22, x15]
	str	d0, [x21, x15]
	add	x8, x8, x14
	adds	x13, x13, #8
	b.ne	LBB0_34
; %bb.35:
	cmp	x17, x10
	b.ne	LBB0_37
	b	LBB0_39
LBB0_36:
	orr	x9, x8, #0x1
LBB0_37:
	madd	w8, w27, w9, w27
	sub	w8, w8, #1
	mul	x10, x9, x20
	sub	x9, x16, x9
LBB0_38:                                ; =>This Inner Loop Header: Depth=1
	ldrb	w11, [x22, x10]
	strb	w11, [x21, x10]
	ldrb	w11, [x22, w8, sxtw]
	strb	w11, [x21, w8, sxtw]
	add	w8, w8, w27
	add	x10, x10, x20
	subs	x9, x9, #1
	b.ne	LBB0_38
LBB0_39:
	mov	x19, x17
	str	x16, [sp, #56]                  ; 8-byte Folded Spill
	mov	x0, x24
	mov	x1, x23
	mov	x2, x20
	bl	_memcpy
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	add	x0, x24, x8
	add	x1, x23, x8
	mov	x2, x20
	bl	_memcpy
	ldr	w8, [sp, #20]                   ; 4-byte Folded Reload
	cbz	w8, LBB0_42
; %bb.40:
	mov	x17, x19
	cmp	x19, #32
	b.hs	LBB0_43
; %bb.41:
	mov	x8, #0                          ; =0x0
	ldr	x16, [sp, #56]                  ; 8-byte Folded Reload
	b	LBB0_47
LBB0_42:
	mov	w9, #1                          ; =0x1
	ldr	x16, [sp, #56]                  ; 8-byte Folded Reload
	b	LBB0_51
LBB0_43:
	and	x8, x17, #0xffffffffffffffe0
	add	x9, x24, #17
	add	x10, x23, #17
	mov	x11, #4294967296                ; =0x100000000
	mov	x12, #137438953472              ; =0x2000000000
	mov	x13, x8
	ldr	x16, [sp, #56]                  ; 8-byte Folded Reload
LBB0_44:                                ; =>This Inner Loop Header: Depth=1
	ldp	q0, q1, [x10, #-16]
	stp	q0, q1, [x9, #-16]
	asr	x14, x11, #32
	add	x15, x23, x14
	ldp	q0, q1, [x15]
	add	x14, x24, x14
	stp	q0, q1, [x14]
	add	x9, x9, #32
	add	x10, x10, #32
	add	x11, x11, x12
	subs	x13, x13, #32
	b.ne	LBB0_44
; %bb.45:
	cmp	x17, x8
	b.eq	LBB0_53
; %bb.46:
	mov	x17, x19
	tst	x19, #0x18
	b.eq	LBB0_50
LBB0_47:
	and	x10, x17, #0xfffffffffffffff8
	orr	x9, x10, #0x1
	add	x12, x8, #1
	add	x11, x24, x12
	add	x12, x23, x12
	mov	x15, #4294967296                ; =0x100000000
	sub	x13, x8, x10
	mov	x14, #34359738368               ; =0x800000000
	add	x8, x15, x8, lsl #32
LBB0_48:                                ; =>This Inner Loop Header: Depth=1
	ldr	d0, [x12], #8
	str	d0, [x11], #8
	asr	x15, x8, #32
	ldr	d0, [x23, x15]
	str	d0, [x24, x15]
	add	x8, x8, x14
	adds	x13, x13, #8
	b.ne	LBB0_48
; %bb.49:
	cmp	x17, x10
	b.ne	LBB0_51
	b	LBB0_53
LBB0_50:
	orr	x9, x8, #0x1
LBB0_51:
	sub	x8, x16, x9
	madd	w10, w27, w9, w27
	sub	w10, w10, #1
	mul	x9, x9, x20
LBB0_52:                                ; =>This Inner Loop Header: Depth=1
	ldrb	w11, [x23, x9]
	strb	w11, [x24, x9]
	ldrb	w11, [x23, w10, sxtw]
	strb	w11, [x24, w10, sxtw]
	add	w10, w10, w27
	add	x9, x9, x20
	subs	x8, x8, #1
	b.ne	LBB0_52
LBB0_53:
	mov	x0, x26
	mov	x1, x25
	mov	x2, x20
	bl	_memcpy
	ldr	x8, [sp, #24]                   ; 8-byte Folded Reload
	add	x0, x26, x8
	add	x1, x25, x8
	mov	x2, x20
	bl	_memcpy
	ldr	w8, [sp, #20]                   ; 4-byte Folded Reload
	cbz	w8, LBB0_56
; %bb.54:
	mov	x17, x19
	cmp	x19, #32
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	b.hs	LBB0_57
; %bb.55:
	mov	x8, #0                          ; =0x0
	ldr	x16, [sp, #56]                  ; 8-byte Folded Reload
	b	LBB0_61
LBB0_56:
	mov	w9, #1                          ; =0x1
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	ldr	x16, [sp, #56]                  ; 8-byte Folded Reload
	b	LBB0_65
LBB0_57:
	and	x8, x17, #0xffffffffffffffe0
	add	x9, x26, #17
	add	x10, x25, #17
	mov	x11, #4294967296                ; =0x100000000
	mov	x12, #137438953472              ; =0x2000000000
	mov	x13, x8
	ldr	x16, [sp, #56]                  ; 8-byte Folded Reload
LBB0_58:                                ; =>This Inner Loop Header: Depth=1
	ldp	q0, q1, [x10, #-16]
	stp	q0, q1, [x9, #-16]
	asr	x14, x11, #32
	add	x15, x25, x14
	ldp	q0, q1, [x15]
	add	x14, x26, x14
	stp	q0, q1, [x14]
	add	x9, x9, #32
	add	x10, x10, #32
	add	x11, x11, x12
	subs	x13, x13, #32
	b.ne	LBB0_58
; %bb.59:
	cmp	x17, x8
	b.eq	LBB0_67
; %bb.60:
	tst	x17, #0x18
	b.eq	LBB0_64
LBB0_61:
	and	x10, x17, #0xfffffffffffffff8
	orr	x9, x10, #0x1
	add	x12, x8, #1
	add	x11, x26, x12
	add	x12, x25, x12
	mov	x15, #4294967296                ; =0x100000000
	sub	x13, x8, x10
	mov	x14, #34359738368               ; =0x800000000
	add	x8, x15, x8, lsl #32
LBB0_62:                                ; =>This Inner Loop Header: Depth=1
	ldr	d0, [x12], #8
	str	d0, [x11], #8
	asr	x15, x8, #32
	ldr	d0, [x25, x15]
	str	d0, [x26, x15]
	add	x8, x8, x14
	adds	x13, x13, #8
	b.ne	LBB0_62
; %bb.63:
	cmp	x17, x10
	b.ne	LBB0_65
	b	LBB0_67
LBB0_64:
	orr	x9, x8, #0x1
LBB0_65:
	sub	x8, x16, x9
	madd	w10, w27, w9, w27
	sub	w10, w10, #1
	mul	x9, x9, x20
LBB0_66:                                ; =>This Inner Loop Header: Depth=1
	ldrb	w11, [x25, x9]
	strb	w11, [x26, x9]
	ldrb	w11, [x25, w10, sxtw]
	strb	w11, [x26, w10, sxtw]
	add	w10, w10, w27
	add	x9, x9, x20
	subs	x8, x8, #1
	b.ne	LBB0_66
LBB0_67:
	sbfiz	x8, x27, #1, #32
	sub	x0, x8, #4
	bl	_malloc
	mov	x20, x0
	add	x4, sp, #112
	mov	x0, x22
	mov	x1, x21
	mov	x2, x27
	mov	x3, x28
	mov	x5, x20
	bl	_blur_interior_ch
	add	x4, sp, #112
	mov	x0, x23
	mov	x1, x24
	mov	x2, x27
	mov	x3, x28
	mov	x5, x20
	bl	_blur_interior_ch
	add	x4, sp, #112
	mov	x0, x25
	mov	x1, x26
	mov	x2, x27
	mov	x3, x28
	mov	x5, x20
	bl	_blur_interior_ch
	ldr	w9, [sp, #76]                   ; 4-byte Folded Reload
	cmp	w9, #1
	b.lt	LBB0_71
; %bb.68:
	movi.2d	v8, #0000000000000000
	mov	x8, #225833675390976            ; =0xcd6500000000
	movk	x8, #16845, lsl #48
	fmov	d9, x8
	mov	x19, x9
LBB0_69:                                ; =>This Inner Loop Header: Depth=1
	add	x1, sp, #96
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	add	x4, sp, #112
	mov	x0, x22
	mov	x1, x21
	mov	x2, x27
	mov	x3, x28
	mov	x5, x20
	bl	_blur_interior_ch
	add	x4, sp, #112
	mov	x0, x23
	mov	x1, x24
	mov	x2, x27
	mov	x3, x28
	mov	x5, x20
	bl	_blur_interior_ch
	add	x4, sp, #112
	mov	x0, x25
	mov	x1, x26
	mov	x2, x27
	mov	x3, x28
	mov	x5, x20
	bl	_blur_interior_ch
	add	x1, sp, #80
	mov	w0, #6                          ; =0x6
	bl	_clock_gettime
	ldp	x8, x9, [sp, #80]
	ldp	x10, x11, [sp, #96]
	sub	x8, x8, x10
	scvtf	d0, x8
	sub	x8, x9, x11
	scvtf	d1, x8
	fmadd	d0, d0, d9, d8
	fadd	d8, d0, d1
	subs	w19, w19, #1
	b.ne	LBB0_69
; %bb.70:
	mov	x8, #60813                      ; =0xed8d
	movk	x8, #41141, lsl #16
	movk	x8, #50935, lsl #32
	movk	x8, #16048, lsl #48
	fmov	d0, x8
	fmul	d0, d8, d0
	ldr	x19, [sp, #40]                  ; 8-byte Folded Reload
	ldr	w9, [sp, #76]                   ; 4-byte Folded Reload
	b	LBB0_72
LBB0_71:
	movi.2d	v0, #0000000000000000
LBB0_72:
Lloh21:
	adrp	x8, ___stderrp@GOTPAGE
Lloh22:
	ldr	x8, [x8, ___stderrp@GOTPAGEOFF]
Lloh23:
	ldr	x0, [x8]
	scvtf	d1, w9
	fdiv	d0, d0, d1
	str	d0, [sp]
Lloh24:
	adrp	x1, l_.str.2@PAGE
Lloh25:
	add	x1, x1, l_.str.2@PAGEOFF
	bl	_fprintf
	ldr	x0, [sp, #64]                   ; 8-byte Folded Reload
	bl	_malloc
	mov	x27, x0
	cmp	w19, #1
	b.lt	LBB0_86
; %bb.73:
	cmp	w19, #7
	b.hi	LBB0_75
; %bb.74:
	mov	x8, #0                          ; =0x0
	b	LBB0_84
LBB0_75:
	cmp	w19, #32
	b.hs	LBB0_77
; %bb.76:
	mov	x8, #0                          ; =0x0
	b	LBB0_81
LBB0_77:
	and	x8, x19, #0x7fffffe0
	add	x9, x21, #16
	add	x10, x26, #16
	add	x11, x24, #16
	mov	x13, x27
	mov	x12, x8
LBB0_78:                                ; =>This Inner Loop Header: Depth=1
	ldp	q0, q3, [x9, #-16]
	ldp	q1, q4, [x11, #-16]
	ldp	q2, q5, [x10, #-16]
	add	x14, x13, #96
	st3.16b	{ v0, v1, v2 }, [x13], #48
	st3.16b	{ v3, v4, v5 }, [x13]
	add	x9, x9, #32
	add	x10, x10, #32
	add	x11, x11, #32
	mov	x13, x14
	subs	x12, x12, #32
	b.ne	LBB0_78
; %bb.79:
	cmp	x8, x19
	b.eq	LBB0_86
; %bb.80:
	tst	x19, #0x18
	b.eq	LBB0_84
LBB0_81:
	mov	x13, x8
	and	x8, x19, #0x7ffffff8
	sub	x9, x13, x8
	add	x10, x26, x13
	add	x11, x24, x13
	add	x12, x13, x13, lsl #1
	add	x12, x27, x12
	add	x13, x21, x13
LBB0_82:                                ; =>This Inner Loop Header: Depth=1
	ldr	d0, [x13], #8
	ldr	d1, [x11], #8
	ldr	d2, [x10], #8
	st3.8b	{ v0, v1, v2 }, [x12], #24
	adds	x9, x9, #8
	b.ne	LBB0_82
; %bb.83:
	cmp	x8, x19
	b.eq	LBB0_86
LBB0_84:
	sub	x9, x19, x8
	add	x10, x21, x8
	add	x11, x8, x8, lsl #1
	add	x11, x11, x27
	add	x11, x11, #2
	add	x12, x26, x8
	add	x8, x24, x8
LBB0_85:                                ; =>This Inner Loop Header: Depth=1
	ldrb	w13, [x10], #1
	sturb	w13, [x11, #-2]
	ldrb	w13, [x8], #1
	sturb	w13, [x11, #-1]
	ldrb	w13, [x12], #1
	strb	w13, [x11], #3
	subs	x9, x9, #1
	b.ne	LBB0_85
LBB0_86:
Lloh26:
	adrp	x8, ___stdoutp@GOTPAGE
Lloh27:
	ldr	x8, [x8, ___stdoutp@GOTPAGEOFF]
Lloh28:
	ldr	x3, [x8]
	mov	x0, x27
	mov	w1, #1                          ; =0x1
	ldr	x2, [sp, #64]                   ; 8-byte Folded Reload
	bl	_fwrite
	mov	x0, x27
	bl	_free
	mov	x0, x20
	bl	_free
	ldr	x0, [sp, #48]                   ; 8-byte Folded Reload
	bl	_free
	mov	x0, x22
	bl	_free
	mov	x0, x21
	bl	_free
	mov	x0, x23
	bl	_free
	mov	x0, x24
	bl	_free
	mov	x0, x25
	bl	_free
	mov	x0, x26
	bl	_free
	mov	w0, #0                          ; =0x0
	ldur	x8, [x29, #-112]
Lloh29:
	adrp	x9, ___stack_chk_guard@GOTPAGE
Lloh30:
	ldr	x9, [x9, ___stack_chk_guard@GOTPAGEOFF]
Lloh31:
	ldr	x9, [x9]
	cmp	x9, x8
	b.eq	LBB0_11
LBB0_87:
	bl	___stack_chk_fail
	.loh AdrpLdrGotLdr	Lloh0, Lloh1, Lloh2
	.loh AdrpAdd	Lloh6, Lloh7
	.loh AdrpLdrGotLdr	Lloh3, Lloh4, Lloh5
	.loh AdrpLdrGotLdr	Lloh8, Lloh9, Lloh10
	.loh AdrpAdd	Lloh14, Lloh15
	.loh AdrpLdrGotLdr	Lloh11, Lloh12, Lloh13
	.loh AdrpLdrGotLdr	Lloh16, Lloh17, Lloh18
	.loh AdrpLdr	Lloh19, Lloh20
	.loh AdrpAdd	Lloh24, Lloh25
	.loh AdrpLdrGotLdr	Lloh21, Lloh22, Lloh23
	.loh AdrpLdrGotLdr	Lloh29, Lloh30, Lloh31
	.loh AdrpLdrGotLdr	Lloh26, Lloh27, Lloh28
	.cfi_endproc
                                        ; -- End function
	.p2align	2                               ; -- Begin function blur_interior_ch
_blur_interior_ch:                      ; @blur_interior_ch
	.cfi_startproc
; %bb.0:
                                        ; kill: def $w2 killed $w2 def $x2
	cmp	w3, #3
	b.lt	LBB1_133
; %bb.1:
	sub	sp, sp, #400
	stp	d13, d12, [sp, #256]            ; 16-byte Folded Spill
	stp	d11, d10, [sp, #272]            ; 16-byte Folded Spill
	stp	d9, d8, [sp, #288]              ; 16-byte Folded Spill
	stp	x28, x27, [sp, #304]            ; 16-byte Folded Spill
	stp	x26, x25, [sp, #320]            ; 16-byte Folded Spill
	stp	x24, x23, [sp, #336]            ; 16-byte Folded Spill
	stp	x22, x21, [sp, #352]            ; 16-byte Folded Spill
	stp	x20, x19, [sp, #368]            ; 16-byte Folded Spill
	stp	x29, x30, [sp, #384]            ; 16-byte Folded Spill
	add	x29, sp, #384
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	.cfi_offset w19, -24
	.cfi_offset w20, -32
	.cfi_offset w21, -40
	.cfi_offset w22, -48
	.cfi_offset w23, -56
	.cfi_offset w24, -64
	.cfi_offset w25, -72
	.cfi_offset w26, -80
	.cfi_offset w27, -88
	.cfi_offset w28, -96
	.cfi_offset b8, -104
	.cfi_offset b9, -112
	.cfi_offset b10, -120
	.cfi_offset b11, -128
	.cfi_offset b12, -136
	.cfi_offset b13, -144
	mov	x19, x5
	sub	w22, w2, #2
	sbfiz	x9, x22, #1, #32
	cmp	w2, #2
	b.le	LBB1_130
; %bb.2:
	mov	x20, x0
	sub	w8, w3, #1
	str	x8, [sp, #128]                  ; 8-byte Folded Spill
	ldrb	w16, [x4]
	and	x13, x22, #0x7fffffc0
	and	x8, x22, #0x38
	str	x8, [sp, #144]                  ; 8-byte Folded Spill
	and	x14, x22, #0x7ffffff8
	ldrb	w17, [x4, #2]
	mov	w15, w2
	ldrb	w6, [x4, #4]
	ldrb	w0, [x4, #6]
	ldrb	w3, [x4, #8]
	add	x5, x20, #32
	add	x8, x19, #64
	stur	x8, [x29, #-152]                ; 8-byte Folded Spill
	ldrb	w21, [x4, #10]
	ldrb	w24, [x4, #12]
	ldrb	w25, [x4, #14]
	ldrb	w4, [x4, #16]
	neg	x26, x14
	add	x7, x20, #33
	add	x23, x20, #1
	add	x30, x20, #34
	add	x27, x20, #2
	add	x28, x5, x15
	add	x8, x15, #33
	add	x10, x20, x8
	stur	x10, [x29, #-184]               ; 8-byte Folded Spill
	add	x10, x30, x15
	str	x10, [sp, #192]                 ; 8-byte Folded Spill
	ubfiz	x10, x2, #1, #32
	add	x11, x5, x10
	stur	x11, [x29, #-160]               ; 8-byte Folded Spill
	add	x11, x7, x10
	dup.8b	v8, w4
	stur	x10, [x29, #-144]               ; 8-byte Folded Spill
	add	x10, x30, x10
	stp	x10, x11, [x29, #-176]          ; 16-byte Folded Spill
	add	x11, x1, x8
	add	x8, x15, x1
	add	x12, x8, #1
	dup.16b	v21, w4
	mov	w10, #1                         ; =0x1
	dup.8b	v9, w25
	dup.16b	v22, w25
	dup.8b	v10, w24
	dup.16b	v23, w24
	dup.8b	v11, w21
	dup.16b	v24, w21
	dup.8b	v12, w3
	dup.16b	v25, w3
	dup.8b	v13, w0
	mov	x1, x9
	str	x9, [sp, #136]                  ; 8-byte Folded Spill
	stp	w0, w17, [sp, #120]             ; 8-byte Folded Spill
	stp	w6, w3, [sp, #112]              ; 8-byte Folded Spill
	stp	w21, w16, [sp, #104]            ; 8-byte Folded Spill
	stp	w25, w24, [sp, #96]             ; 8-byte Folded Spill
	str	w4, [sp, #92]                   ; 4-byte Folded Spill
	str	x26, [sp, #80]                  ; 8-byte Folded Spill
	stp	q22, q21, [sp, #48]             ; 32-byte Folded Spill
	stp	q24, q23, [sp, #16]             ; 32-byte Folded Spill
	str	q25, [sp]                       ; 16-byte Folded Spill
	b	LBB1_4
LBB1_3:                                 ;   in Loop: Header=BB1_4 Depth=1
	ldr	x10, [sp, #152]                 ; 8-byte Folded Reload
	add	x10, x10, #1
	add	x5, x5, x15
	add	x20, x20, x15
	add	x7, x7, x15
	add	x23, x23, x15
	add	x30, x30, x15
	add	x27, x27, x15
	add	x28, x28, x15
	add	x1, x1, x15
	stur	x1, [x29, #-184]                ; 8-byte Folded Spill
	add	x2, x2, x15
	str	x2, [sp, #192]                  ; 8-byte Folded Spill
	ldur	x8, [x29, #-160]                ; 8-byte Folded Reload
	add	x8, x8, x15
	stur	x8, [x29, #-160]                ; 8-byte Folded Spill
	ldur	x8, [x29, #-168]                ; 8-byte Folded Reload
	add	x8, x8, x15
	stur	x8, [x29, #-168]                ; 8-byte Folded Spill
	ldur	x8, [x29, #-176]                ; 8-byte Folded Reload
	add	x8, x8, x15
	stur	x8, [x29, #-176]                ; 8-byte Folded Spill
	add	x11, x11, x15
	add	x12, x12, x15
	ldp	x8, x1, [sp, #128]              ; 16-byte Folded Reload
	cmp	x10, x8
	b.eq	LBB1_132
LBB1_4:                                 ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB1_9 Depth 2
                                        ;     Child Loop BB1_13 Depth 2
                                        ;     Child Loop BB1_15 Depth 2
                                        ;     Child Loop BB1_21 Depth 2
                                        ;     Child Loop BB1_25 Depth 2
                                        ;     Child Loop BB1_27 Depth 2
                                        ;     Child Loop BB1_33 Depth 2
                                        ;     Child Loop BB1_37 Depth 2
                                        ;     Child Loop BB1_39 Depth 2
                                        ;     Child Loop BB1_45 Depth 2
                                        ;     Child Loop BB1_49 Depth 2
                                        ;     Child Loop BB1_52 Depth 2
                                        ;     Child Loop BB1_58 Depth 2
                                        ;     Child Loop BB1_62 Depth 2
                                        ;     Child Loop BB1_65 Depth 2
                                        ;     Child Loop BB1_71 Depth 2
                                        ;     Child Loop BB1_75 Depth 2
                                        ;     Child Loop BB1_78 Depth 2
                                        ;     Child Loop BB1_84 Depth 2
                                        ;     Child Loop BB1_88 Depth 2
                                        ;     Child Loop BB1_91 Depth 2
                                        ;     Child Loop BB1_97 Depth 2
                                        ;     Child Loop BB1_101 Depth 2
                                        ;     Child Loop BB1_104 Depth 2
                                        ;     Child Loop BB1_110 Depth 2
                                        ;     Child Loop BB1_114 Depth 2
                                        ;     Child Loop BB1_117 Depth 2
                                        ;     Child Loop BB1_123 Depth 2
                                        ;     Child Loop BB1_127 Depth 2
                                        ;     Child Loop BB1_129 Depth 2
	stp	x10, x12, [sp, #152]            ; 16-byte Folded Spill
	stp	x11, x28, [sp, #168]            ; 16-byte Folded Spill
	mov	x28, x30
	str	x7, [sp, #184]                  ; 8-byte Folded Spill
	mov	x21, x5
	mov	x24, x15
	mov	x26, x14
	mov	x25, x13
	mov	x0, x19
	bl	_bzero
	cmp	w22, #7
	b.hi	LBB1_6
; %bb.5:                                ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, #0                          ; =0x0
	mov	x13, x25
	mov	x14, x26
	mov	x15, x24
	ldp	w16, w6, [sp, #108]             ; 8-byte Folded Reload
	ldp	w0, w17, [sp, #120]             ; 8-byte Folded Reload
	ldr	w3, [sp, #116]                  ; 4-byte Folded Reload
	mov	x5, x21
	ldp	w24, w21, [sp, #100]            ; 8-byte Folded Reload
	ldp	w4, w25, [sp, #92]              ; 8-byte Folded Reload
	ldr	x26, [sp, #80]                  ; 8-byte Folded Reload
	mov	x30, x28
	ldp	x28, x7, [sp, #176]             ; 16-byte Folded Reload
	ldur	x1, [x29, #-184]                ; 8-byte Folded Reload
	ldr	x2, [sp, #192]                  ; 8-byte Folded Reload
	ldp	q22, q21, [sp, #48]             ; 32-byte Folded Reload
	ldp	q24, q23, [sp, #16]             ; 32-byte Folded Reload
	ldr	q25, [sp]                       ; 16-byte Folded Reload
	b	LBB1_15
LBB1_6:                                 ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #64
	mov	x13, x25
	mov	x30, x28
	ldur	x1, [x29, #-184]                ; 8-byte Folded Reload
	ldr	x2, [sp, #192]                  ; 8-byte Folded Reload
	ldp	q22, q21, [sp, #48]             ; 32-byte Folded Reload
	ldp	q24, q23, [sp, #16]             ; 32-byte Folded Reload
	ldr	q25, [sp]                       ; 16-byte Folded Reload
	b.hs	LBB1_8
; %bb.7:                                ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, #0                         ; =0x0
	mov	x14, x26
	mov	x15, x24
	ldp	w16, w6, [sp, #108]             ; 8-byte Folded Reload
	ldp	w0, w17, [sp, #120]             ; 8-byte Folded Reload
	ldr	w3, [sp, #116]                  ; 4-byte Folded Reload
	mov	x5, x21
	ldp	w24, w21, [sp, #100]            ; 8-byte Folded Reload
	ldp	w4, w25, [sp, #92]              ; 8-byte Folded Reload
	ldr	x26, [sp, #80]                  ; 8-byte Folded Reload
	ldp	x28, x7, [sp, #176]             ; 16-byte Folded Reload
	b	LBB1_12
LBB1_8:                                 ;   in Loop: Header=BB1_4 Depth=1
	ldur	x8, [x29, #-152]                ; 8-byte Folded Reload
	mov	x5, x21
	mov	x9, x21
	mov	x10, x13
	mov	x14, x26
	mov	x15, x24
	ldr	w16, [sp, #108]                 ; 4-byte Folded Reload
	ldr	w25, [sp, #96]                  ; 4-byte Folded Reload
	ldr	x28, [sp, #176]                 ; 8-byte Folded Reload
LBB1_9:                                 ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x9, #-32]
	ldp	q2, q3, [x9], #64
	dup.16b	v4, w16
	ldp	q6, q5, [x8, #-64]
	ldp	q16, q7, [x8, #-32]
	ldp	q18, q17, [x8]
	ldp	q20, q19, [x8, #32]
	umlal.8h	v6, v4, v0
	umlal2.8h	v5, v4, v0
	umlal.8h	v16, v4, v1
	umlal2.8h	v7, v4, v1
	umlal.8h	v18, v4, v2
	umlal2.8h	v17, v4, v2
	umlal.8h	v20, v4, v3
	umlal2.8h	v19, v4, v3
	stp	q6, q5, [x8, #-64]
	stp	q16, q7, [x8, #-32]
	stp	q18, q17, [x8]
	stp	q20, q19, [x8, #32]
	add	x8, x8, #128
	subs	x10, x10, #64
	b.ne	LBB1_9
; %bb.10:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	x13, x22
	ldp	w0, w17, [sp, #120]             ; 8-byte Folded Reload
	ldp	w6, w3, [sp, #112]              ; 8-byte Folded Reload
	ldp	w24, w21, [sp, #100]            ; 8-byte Folded Reload
	ldr	w4, [sp, #92]                   ; 4-byte Folded Reload
	ldr	x26, [sp, #80]                  ; 8-byte Folded Reload
	ldr	x7, [sp, #184]                  ; 8-byte Folded Reload
	b.eq	LBB1_16
; %bb.11:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, x13
	mov	x10, x13
	ldr	x9, [sp, #144]                  ; 8-byte Folded Reload
	cbz	x9, LBB1_15
LBB1_12:                                ;   in Loop: Header=BB1_4 Depth=1
	add	x8, x26, x10
	add	x9, x19, x10, lsl #1
	add	x10, x20, x10
LBB1_13:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	d0, [x10], #8
	dup.8b	v1, w16
	ldr	q2, [x9]
	umlal.8h	v2, v1, v0
	str	q2, [x9], #16
	adds	x8, x8, #8
	b.ne	LBB1_13
; %bb.14:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, x14
	cmp	x14, x22
	b.eq	LBB1_16
LBB1_15:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x20, x8]
	ldrh	w10, [x19, x8, lsl #1]
	madd	w9, w16, w9, w10
	strh	w9, [x19, x8, lsl #1]
	add	x8, x8, #1
	cmp	x22, x8
	b.ne	LBB1_15
LBB1_16:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #8
	b.hs	LBB1_18
; %bb.17:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, #0                          ; =0x0
	b	LBB1_27
LBB1_18:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #64
	b.hs	LBB1_20
; %bb.19:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB1_24
LBB1_20:                                ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, x7
	mov	x9, x13
	ldur	x10, [x29, #-152]               ; 8-byte Folded Reload
LBB1_21:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x8, #-32]
	ldp	q2, q3, [x8], #64
	dup.16b	v4, w17
	ldp	q6, q5, [x10, #-64]
	ldp	q16, q7, [x10, #-32]
	ldp	q18, q17, [x10]
	ldp	q20, q19, [x10, #32]
	umlal.8h	v6, v4, v0
	umlal2.8h	v5, v4, v0
	umlal.8h	v16, v4, v1
	umlal2.8h	v7, v4, v1
	umlal.8h	v18, v4, v2
	umlal2.8h	v17, v4, v2
	umlal.8h	v20, v4, v3
	umlal2.8h	v19, v4, v3
	stp	q6, q5, [x10, #-64]
	stp	q16, q7, [x10, #-32]
	stp	q18, q17, [x10]
	stp	q20, q19, [x10, #32]
	add	x10, x10, #128
	subs	x9, x9, #64
	b.ne	LBB1_21
; %bb.22:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	x13, x22
	b.eq	LBB1_28
; %bb.23:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, x13
	mov	x8, x13
	ldr	x9, [sp, #144]                  ; 8-byte Folded Reload
	cbz	x9, LBB1_27
LBB1_24:                                ;   in Loop: Header=BB1_4 Depth=1
	add	x8, x23, x10
	add	x9, x26, x10
	add	x10, x19, x10, lsl #1
LBB1_25:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	d0, [x8], #8
	dup.8b	v1, w17
	ldr	q2, [x10]
	umlal.8h	v2, v1, v0
	str	q2, [x10], #16
	adds	x9, x9, #8
	b.ne	LBB1_25
; %bb.26:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, x14
	cmp	x14, x22
	b.eq	LBB1_28
LBB1_27:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x23, x8]
	ldrh	w10, [x19, x8, lsl #1]
	madd	w9, w17, w9, w10
	strh	w9, [x19, x8, lsl #1]
	add	x8, x8, #1
	cmp	x22, x8
	b.ne	LBB1_27
LBB1_28:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #8
	b.hs	LBB1_30
; %bb.29:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, #0                          ; =0x0
	b	LBB1_39
LBB1_30:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #64
	b.hs	LBB1_32
; %bb.31:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB1_36
LBB1_32:                                ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, x30
	mov	x9, x13
	ldur	x10, [x29, #-152]               ; 8-byte Folded Reload
LBB1_33:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x8, #-32]
	ldp	q2, q3, [x8], #64
	dup.16b	v4, w6
	ldp	q6, q5, [x10, #-64]
	ldp	q16, q7, [x10, #-32]
	ldp	q18, q17, [x10]
	ldp	q20, q19, [x10, #32]
	umlal.8h	v6, v4, v0
	umlal2.8h	v5, v4, v0
	umlal.8h	v16, v4, v1
	umlal2.8h	v7, v4, v1
	umlal.8h	v18, v4, v2
	umlal2.8h	v17, v4, v2
	umlal.8h	v20, v4, v3
	umlal2.8h	v19, v4, v3
	stp	q6, q5, [x10, #-64]
	stp	q16, q7, [x10, #-32]
	stp	q18, q17, [x10]
	stp	q20, q19, [x10, #32]
	add	x10, x10, #128
	subs	x9, x9, #64
	b.ne	LBB1_33
; %bb.34:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	x13, x22
	b.eq	LBB1_40
; %bb.35:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, x13
	mov	x8, x13
	ldr	x9, [sp, #144]                  ; 8-byte Folded Reload
	cbz	x9, LBB1_39
LBB1_36:                                ;   in Loop: Header=BB1_4 Depth=1
	add	x8, x27, x10
	add	x9, x26, x10
	add	x10, x19, x10, lsl #1
LBB1_37:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	d0, [x8], #8
	dup.8b	v1, w6
	ldr	q2, [x10]
	umlal.8h	v2, v1, v0
	str	q2, [x10], #16
	adds	x9, x9, #8
	b.ne	LBB1_37
; %bb.38:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, x14
	cmp	x14, x22
	b.eq	LBB1_40
LBB1_39:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w9, [x27, x8]
	ldrh	w10, [x19, x8, lsl #1]
	madd	w9, w6, w9, w10
	strh	w9, [x19, x8, lsl #1]
	add	x8, x8, #1
	cmp	x22, x8
	b.ne	LBB1_39
LBB1_40:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #8
	b.hs	LBB1_42
; %bb.41:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB1_51
LBB1_42:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #64
	b.hs	LBB1_44
; %bb.43:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, #0                         ; =0x0
	b	LBB1_48
LBB1_44:                                ;   in Loop: Header=BB1_4 Depth=1
	ldur	x8, [x29, #-152]                ; 8-byte Folded Reload
	mov	x9, x28
	mov	x10, x13
LBB1_45:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x9, #-32]
	ldp	q2, q3, [x9], #64
	dup.16b	v4, w0
	ldp	q6, q5, [x8, #-64]
	ldp	q16, q7, [x8, #-32]
	ldp	q18, q17, [x8]
	ldp	q20, q19, [x8, #32]
	umlal.8h	v6, v4, v0
	umlal2.8h	v5, v4, v0
	umlal.8h	v16, v4, v1
	umlal2.8h	v7, v4, v1
	umlal.8h	v18, v4, v2
	umlal2.8h	v17, v4, v2
	umlal.8h	v20, v4, v3
	umlal2.8h	v19, v4, v3
	stp	q6, q5, [x8, #-64]
	stp	q16, q7, [x8, #-32]
	stp	q18, q17, [x8]
	stp	q20, q19, [x8, #32]
	add	x8, x8, #128
	subs	x10, x10, #64
	b.ne	LBB1_45
; %bb.46:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	x13, x22
	b.eq	LBB1_53
; %bb.47:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, x13
	mov	x10, x13
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	cbz	x8, LBB1_51
LBB1_48:                                ;   in Loop: Header=BB1_4 Depth=1
	add	x8, x26, x11
	add	x9, x19, x11, lsl #1
	add	x10, x15, x11
LBB1_49:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	d0, [x20, x10]
	ldr	q1, [x9]
	umlal.8h	v1, v13, v0
	str	q1, [x9], #16
	add	x10, x10, #8
	adds	x8, x8, #8
	b.ne	LBB1_49
; %bb.50:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, x14
	cmp	x14, x22
	b.eq	LBB1_53
LBB1_51:                                ;   in Loop: Header=BB1_4 Depth=1
	sub	x8, x22, x10
	add	x9, x19, x10, lsl #1
	add	x10, x15, x10
LBB1_52:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w11, [x20, x10]
	ldrh	w12, [x9]
	madd	w11, w0, w11, w12
	strh	w11, [x9], #2
	add	x10, x10, #1
	subs	x8, x8, #1
	b.ne	LBB1_52
LBB1_53:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #8
	b.hs	LBB1_55
; %bb.54:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB1_64
LBB1_55:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #64
	b.hs	LBB1_57
; %bb.56:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, #0                         ; =0x0
	b	LBB1_61
LBB1_57:                                ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, x1
	mov	x9, x13
	ldur	x10, [x29, #-152]               ; 8-byte Folded Reload
LBB1_58:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x8, #-32]
	ldp	q2, q3, [x8], #64
	ldp	q5, q4, [x10, #-64]
	ldp	q7, q6, [x10, #-32]
	ldp	q17, q16, [x10]
	ldp	q19, q18, [x10, #32]
	umlal.8h	v5, v25, v0
	umlal2.8h	v4, v25, v0
	umlal.8h	v7, v25, v1
	umlal2.8h	v6, v25, v1
	umlal.8h	v17, v25, v2
	umlal2.8h	v16, v25, v2
	umlal.8h	v19, v25, v3
	umlal2.8h	v18, v25, v3
	stp	q5, q4, [x10, #-64]
	stp	q7, q6, [x10, #-32]
	stp	q17, q16, [x10]
	stp	q19, q18, [x10, #32]
	add	x10, x10, #128
	subs	x9, x9, #64
	b.ne	LBB1_58
; %bb.59:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	x13, x22
	b.eq	LBB1_66
; %bb.60:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, x13
	mov	x10, x13
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	cbz	x8, LBB1_64
LBB1_61:                                ;   in Loop: Header=BB1_4 Depth=1
	add	x8, x15, x11
	add	x9, x26, x11
	add	x10, x19, x11, lsl #1
LBB1_62:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	d0, [x23, x8]
	ldr	q1, [x10]
	umlal.8h	v1, v12, v0
	str	q1, [x10], #16
	add	x8, x8, #8
	adds	x9, x9, #8
	b.ne	LBB1_62
; %bb.63:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, x14
	cmp	x14, x22
	b.eq	LBB1_66
LBB1_64:                                ;   in Loop: Header=BB1_4 Depth=1
	add	x8, x15, x10
	sub	x9, x22, x10
	add	x10, x19, x10, lsl #1
LBB1_65:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w11, [x23, x8]
	ldrh	w12, [x10]
	madd	w11, w3, w11, w12
	strh	w11, [x10], #2
	add	x8, x8, #1
	subs	x9, x9, #1
	b.ne	LBB1_65
LBB1_66:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #8
	b.hs	LBB1_68
; %bb.67:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB1_77
LBB1_68:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #64
	b.hs	LBB1_70
; %bb.69:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, #0                         ; =0x0
	b	LBB1_74
LBB1_70:                                ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, x2
	mov	x9, x13
	ldur	x10, [x29, #-152]               ; 8-byte Folded Reload
LBB1_71:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x8, #-32]
	ldp	q2, q3, [x8], #64
	ldp	q5, q4, [x10, #-64]
	ldp	q7, q6, [x10, #-32]
	ldp	q17, q16, [x10]
	ldp	q19, q18, [x10, #32]
	umlal.8h	v5, v24, v0
	umlal2.8h	v4, v24, v0
	umlal.8h	v7, v24, v1
	umlal2.8h	v6, v24, v1
	umlal.8h	v17, v24, v2
	umlal2.8h	v16, v24, v2
	umlal.8h	v19, v24, v3
	umlal2.8h	v18, v24, v3
	stp	q5, q4, [x10, #-64]
	stp	q7, q6, [x10, #-32]
	stp	q17, q16, [x10]
	stp	q19, q18, [x10, #32]
	add	x10, x10, #128
	subs	x9, x9, #64
	b.ne	LBB1_71
; %bb.72:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	x13, x22
	b.eq	LBB1_79
; %bb.73:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, x13
	mov	x10, x13
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	cbz	x8, LBB1_77
LBB1_74:                                ;   in Loop: Header=BB1_4 Depth=1
	add	x8, x15, x11
	add	x9, x26, x11
	add	x10, x19, x11, lsl #1
LBB1_75:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	d0, [x27, x8]
	ldr	q1, [x10]
	umlal.8h	v1, v11, v0
	str	q1, [x10], #16
	add	x8, x8, #8
	adds	x9, x9, #8
	b.ne	LBB1_75
; %bb.76:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, x14
	cmp	x14, x22
	b.eq	LBB1_79
LBB1_77:                                ;   in Loop: Header=BB1_4 Depth=1
	add	x8, x15, x10
	sub	x9, x22, x10
	add	x10, x19, x10, lsl #1
LBB1_78:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w11, [x27, x8]
	ldrh	w12, [x10]
	madd	w11, w21, w11, w12
	strh	w11, [x10], #2
	add	x8, x8, #1
	subs	x9, x9, #1
	b.ne	LBB1_78
LBB1_79:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #8
	b.hs	LBB1_81
; %bb.80:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB1_90
LBB1_81:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #64
	b.hs	LBB1_83
; %bb.82:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, #0                         ; =0x0
	b	LBB1_87
LBB1_83:                                ;   in Loop: Header=BB1_4 Depth=1
	ldp	x9, x8, [x29, #-160]            ; 16-byte Folded Reload
	mov	x10, x13
LBB1_84:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x9, #-32]
	ldp	q2, q3, [x9], #64
	ldp	q5, q4, [x8, #-64]
	ldp	q7, q6, [x8, #-32]
	ldp	q17, q16, [x8]
	ldp	q19, q18, [x8, #32]
	umlal.8h	v5, v23, v0
	umlal2.8h	v4, v23, v0
	umlal.8h	v7, v23, v1
	umlal2.8h	v6, v23, v1
	umlal.8h	v17, v23, v2
	umlal2.8h	v16, v23, v2
	umlal.8h	v19, v23, v3
	umlal2.8h	v18, v23, v3
	stp	q5, q4, [x8, #-64]
	stp	q7, q6, [x8, #-32]
	stp	q17, q16, [x8]
	stp	q19, q18, [x8, #32]
	add	x8, x8, #128
	subs	x10, x10, #64
	b.ne	LBB1_84
; %bb.85:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	x13, x22
	b.eq	LBB1_92
; %bb.86:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, x13
	mov	x10, x13
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	cbz	x8, LBB1_90
LBB1_87:                                ;   in Loop: Header=BB1_4 Depth=1
	add	x8, x26, x11
	add	x9, x19, x11, lsl #1
	ldur	x10, [x29, #-144]               ; 8-byte Folded Reload
	add	x10, x10, x11
LBB1_88:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	d0, [x20, x10]
	ldr	q1, [x9]
	umlal.8h	v1, v10, v0
	str	q1, [x9], #16
	add	x10, x10, #8
	adds	x8, x8, #8
	b.ne	LBB1_88
; %bb.89:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, x14
	cmp	x14, x22
	b.eq	LBB1_92
LBB1_90:                                ;   in Loop: Header=BB1_4 Depth=1
	sub	x8, x22, x10
	add	x9, x19, x10, lsl #1
	ldur	x11, [x29, #-144]               ; 8-byte Folded Reload
	add	x10, x11, x10
LBB1_91:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w11, [x20, x10]
	ldrh	w12, [x9]
	madd	w11, w24, w11, w12
	strh	w11, [x9], #2
	add	x10, x10, #1
	subs	x8, x8, #1
	b.ne	LBB1_91
LBB1_92:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #8
	b.hs	LBB1_94
; %bb.93:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB1_103
LBB1_94:                                ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #64
	b.hs	LBB1_96
; %bb.95:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, #0                         ; =0x0
	b	LBB1_100
LBB1_96:                                ;   in Loop: Header=BB1_4 Depth=1
	ldur	x8, [x29, #-168]                ; 8-byte Folded Reload
	mov	x9, x13
	ldur	x10, [x29, #-152]               ; 8-byte Folded Reload
LBB1_97:                                ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x8, #-32]
	ldp	q2, q3, [x8], #64
	ldp	q5, q4, [x10, #-64]
	ldp	q7, q6, [x10, #-32]
	ldp	q17, q16, [x10]
	ldp	q19, q18, [x10, #32]
	umlal.8h	v5, v22, v0
	umlal2.8h	v4, v22, v0
	umlal.8h	v7, v22, v1
	umlal2.8h	v6, v22, v1
	umlal.8h	v17, v22, v2
	umlal2.8h	v16, v22, v2
	umlal.8h	v19, v22, v3
	umlal2.8h	v18, v22, v3
	stp	q5, q4, [x10, #-64]
	stp	q7, q6, [x10, #-32]
	stp	q17, q16, [x10]
	stp	q19, q18, [x10, #32]
	add	x10, x10, #128
	subs	x9, x9, #64
	b.ne	LBB1_97
; %bb.98:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	x13, x22
	b.eq	LBB1_105
; %bb.99:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, x13
	mov	x10, x13
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	cbz	x8, LBB1_103
LBB1_100:                               ;   in Loop: Header=BB1_4 Depth=1
	ldur	x8, [x29, #-144]                ; 8-byte Folded Reload
	add	x8, x8, x11
	add	x9, x26, x11
	add	x10, x19, x11, lsl #1
LBB1_101:                               ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	d0, [x23, x8]
	ldr	q1, [x10]
	umlal.8h	v1, v9, v0
	str	q1, [x10], #16
	add	x8, x8, #8
	adds	x9, x9, #8
	b.ne	LBB1_101
; %bb.102:                              ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, x14
	cmp	x14, x22
	b.eq	LBB1_105
LBB1_103:                               ;   in Loop: Header=BB1_4 Depth=1
	ldur	x8, [x29, #-144]                ; 8-byte Folded Reload
	add	x8, x8, x10
	sub	x9, x22, x10
	add	x10, x19, x10, lsl #1
LBB1_104:                               ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w11, [x23, x8]
	ldrh	w12, [x10]
	madd	w11, w25, w11, w12
	strh	w11, [x10], #2
	add	x8, x8, #1
	subs	x9, x9, #1
	b.ne	LBB1_104
LBB1_105:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #8
	b.hs	LBB1_107
; %bb.106:                              ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB1_116
LBB1_107:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #64
	b.hs	LBB1_109
; %bb.108:                              ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, #0                         ; =0x0
	b	LBB1_113
LBB1_109:                               ;   in Loop: Header=BB1_4 Depth=1
	ldur	x8, [x29, #-176]                ; 8-byte Folded Reload
	mov	x9, x13
	ldur	x10, [x29, #-152]               ; 8-byte Folded Reload
LBB1_110:                               ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q0, q1, [x8, #-32]
	ldp	q2, q3, [x8], #64
	ldp	q5, q4, [x10, #-64]
	ldp	q7, q6, [x10, #-32]
	ldp	q17, q16, [x10]
	ldp	q19, q18, [x10, #32]
	umlal.8h	v5, v21, v0
	umlal2.8h	v4, v21, v0
	umlal.8h	v7, v21, v1
	umlal2.8h	v6, v21, v1
	umlal.8h	v17, v21, v2
	umlal2.8h	v16, v21, v2
	umlal.8h	v19, v21, v3
	umlal2.8h	v18, v21, v3
	stp	q5, q4, [x10, #-64]
	stp	q7, q6, [x10, #-32]
	stp	q17, q16, [x10]
	stp	q19, q18, [x10, #32]
	add	x10, x10, #128
	subs	x9, x9, #64
	b.ne	LBB1_110
; %bb.111:                              ;   in Loop: Header=BB1_4 Depth=1
	cmp	x13, x22
	b.eq	LBB1_118
; %bb.112:                              ;   in Loop: Header=BB1_4 Depth=1
	mov	x11, x13
	mov	x10, x13
	ldr	x8, [sp, #144]                  ; 8-byte Folded Reload
	cbz	x8, LBB1_116
LBB1_113:                               ;   in Loop: Header=BB1_4 Depth=1
	ldur	x8, [x29, #-144]                ; 8-byte Folded Reload
	add	x8, x8, x11
	add	x9, x26, x11
	add	x10, x19, x11, lsl #1
LBB1_114:                               ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	d0, [x27, x8]
	ldr	q1, [x10]
	umlal.8h	v1, v8, v0
	str	q1, [x10], #16
	add	x8, x8, #8
	adds	x9, x9, #8
	b.ne	LBB1_114
; %bb.115:                              ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, x14
	cmp	x14, x22
	b.eq	LBB1_118
LBB1_116:                               ;   in Loop: Header=BB1_4 Depth=1
	ldur	x8, [x29, #-144]                ; 8-byte Folded Reload
	add	x8, x8, x10
	sub	x9, x22, x10
	add	x10, x19, x10, lsl #1
LBB1_117:                               ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldrb	w11, [x27, x8]
	ldrh	w12, [x10]
	madd	w11, w4, w11, w12
	strh	w11, [x10], #2
	add	x8, x8, #1
	subs	x9, x9, #1
	b.ne	LBB1_117
LBB1_118:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #7
	b.hi	LBB1_120
; %bb.119:                              ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, #0                          ; =0x0
	ldp	x12, x11, [sp, #160]            ; 16-byte Folded Reload
	b	LBB1_129
LBB1_120:                               ;   in Loop: Header=BB1_4 Depth=1
	cmp	w22, #64
	ldp	x12, x11, [sp, #160]            ; 16-byte Folded Reload
	b.hs	LBB1_122
; %bb.121:                              ;   in Loop: Header=BB1_4 Depth=1
	mov	x10, #0                         ; =0x0
	b	LBB1_126
LBB1_122:                               ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, x11
	mov	x9, x13
	ldur	x10, [x29, #-152]               ; 8-byte Folded Reload
LBB1_123:                               ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldp	q1, q0, [x10, #-64]
	ldp	q3, q2, [x10, #-32]
	ldp	q5, q4, [x10]
	ldp	q7, q6, [x10, #32]
	uzp2.16b	v0, v1, v0
	uzp2.16b	v1, v3, v2
	uzp2.16b	v2, v5, v4
	uzp2.16b	v3, v7, v6
	stp	q0, q1, [x8, #-32]
	stp	q2, q3, [x8], #64
	add	x10, x10, #128
	subs	x9, x9, #64
	b.ne	LBB1_123
; %bb.124:                              ;   in Loop: Header=BB1_4 Depth=1
	cmp	x13, x22
	b.eq	LBB1_3
; %bb.125:                              ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, x13
	mov	x10, x13
	ldr	x9, [sp, #144]                  ; 8-byte Folded Reload
	cbz	x9, LBB1_129
LBB1_126:                               ;   in Loop: Header=BB1_4 Depth=1
	add	x8, x12, x10
	add	x9, x26, x10
	add	x10, x19, x10, lsl #1
LBB1_127:                               ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldr	q0, [x10], #16
	shrn.8b	v0, v0, #8
	str	d0, [x8], #8
	adds	x9, x9, #8
	b.ne	LBB1_127
; %bb.128:                              ;   in Loop: Header=BB1_4 Depth=1
	mov	x8, x14
	cmp	x14, x22
	b.eq	LBB1_3
LBB1_129:                               ;   Parent Loop BB1_4 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	add	x9, x19, x8, lsl #1
	ldrb	w9, [x9, #1]
	strb	w9, [x12, x8]
	add	x8, x8, #1
	cmp	x22, x8
	b.ne	LBB1_129
	b	LBB1_3
LBB1_130:
	mov	x0, x19
	mov	x1, x9
	mov	x19, x3
	bl	_bzero
	sub	w8, w19, #2
LBB1_131:                               ; =>This Inner Loop Header: Depth=1
	subs	w8, w8, #1
	b.ne	LBB1_131
LBB1_132:
	ldp	x29, x30, [sp, #384]            ; 16-byte Folded Reload
	ldp	x20, x19, [sp, #368]            ; 16-byte Folded Reload
	ldp	x22, x21, [sp, #352]            ; 16-byte Folded Reload
	ldp	x24, x23, [sp, #336]            ; 16-byte Folded Reload
	ldp	x26, x25, [sp, #320]            ; 16-byte Folded Reload
	ldp	x28, x27, [sp, #304]            ; 16-byte Folded Reload
	ldp	d9, d8, [sp, #288]              ; 16-byte Folded Reload
	ldp	d11, d10, [sp, #272]            ; 16-byte Folded Reload
	ldp	d13, d12, [sp, #256]            ; 16-byte Folded Reload
	add	sp, sp, #400
LBB1_133:
	ret
	.cfi_endproc
                                        ; -- End function
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"Usage: %s <width> <height> [num_runs]\n"

l_.str.1:                               ; @.str.1
	.asciz	"Expected %d bytes, got %zu\n"

l_.str.2:                               ; @.str.2
	.asciz	"%.4f\n"

.subsections_via_symbols
