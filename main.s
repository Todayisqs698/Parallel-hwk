	.arch armv8-a
	.file	"main.cc"
	.text
	.section	.text._ZNKSt5ctypeIcE8do_widenEc,"axG",@progbits,_ZNKSt5ctypeIcE8do_widenEc,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNKSt5ctypeIcE8do_widenEc
	.type	_ZNKSt5ctypeIcE8do_widenEc, %function
_ZNKSt5ctypeIcE8do_widenEc:
.LFB1709:
	.cfi_startproc
	mov	w0, w1
	ret
	.cfi_endproc
.LFE1709:
	.size	_ZNKSt5ctypeIcE8do_widenEc, .-_ZNKSt5ctypeIcE8do_widenEc
	.section	.text._ZN7hnswlib17BaseFilterFunctorclEm,"axG",@progbits,_ZN7hnswlib17BaseFilterFunctorclEm,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17BaseFilterFunctorclEm
	.type	_ZN7hnswlib17BaseFilterFunctorclEm, %function
_ZN7hnswlib17BaseFilterFunctorclEm:
.LFB3495:
	.cfi_startproc
	mov	w0, 1
	ret
	.cfi_endproc
.LFE3495:
	.size	_ZN7hnswlib17BaseFilterFunctorclEm, .-_ZN7hnswlib17BaseFilterFunctorclEm
	.text
	.align	2
	.p2align 4,,11
	.type	_ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_, %function
_ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_:
.LFB3537:
	.cfi_startproc
	ldr	x4, [x2]
	cbz	x4, .L7
	movi	v1.2s, #0
	mov	x2, 0
	mov	w3, 0
	.p2align 3,,7
.L6:
	ldr	s2, [x0, x2, lsl 2]
	add	w3, w3, 1
	ldr	s0, [x1, x2, lsl 2]
	uxtw	x2, w3
	fmadd	s1, s2, s0, s1
	cmp	x4, x2
	bhi	.L6
	fmov	s0, 1.0e+0
	fsub	s0, s0, s1
	ret
	.p2align 2,,3
.L7:
	fmov	s0, 1.0e+0
	ret
	.cfi_endproc
.LFE3537:
	.size	_ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_, .-_ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_
	.section	.text._ZN7hnswlib17InnerProductSpace13get_data_sizeEv,"axG",@progbits,_ZN7hnswlib17InnerProductSpace13get_data_sizeEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17InnerProductSpace13get_data_sizeEv
	.type	_ZN7hnswlib17InnerProductSpace13get_data_sizeEv, %function
_ZN7hnswlib17InnerProductSpace13get_data_sizeEv:
.LFB3541:
	.cfi_startproc
	ldr	x0, [x0, 16]
	ret
	.cfi_endproc
.LFE3541:
	.size	_ZN7hnswlib17InnerProductSpace13get_data_sizeEv, .-_ZN7hnswlib17InnerProductSpace13get_data_sizeEv
	.section	.text._ZN7hnswlib17InnerProductSpace13get_dist_funcEv,"axG",@progbits,_ZN7hnswlib17InnerProductSpace13get_dist_funcEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17InnerProductSpace13get_dist_funcEv
	.type	_ZN7hnswlib17InnerProductSpace13get_dist_funcEv, %function
_ZN7hnswlib17InnerProductSpace13get_dist_funcEv:
.LFB3542:
	.cfi_startproc
	ldr	x0, [x0, 8]
	ret
	.cfi_endproc
.LFE3542:
	.size	_ZN7hnswlib17InnerProductSpace13get_dist_funcEv, .-_ZN7hnswlib17InnerProductSpace13get_dist_funcEv
	.section	.text._ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv,"axG",@progbits,_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv
	.type	_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv, %function
_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv:
.LFB3543:
	.cfi_startproc
	add	x0, x0, 24
	ret
	.cfi_endproc
.LFE3543:
	.size	_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv, .-_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv
	.section	.text._ZN7hnswlib17InnerProductSpaceD2Ev,"axG",@progbits,_ZN7hnswlib17InnerProductSpaceD5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17InnerProductSpaceD2Ev
	.type	_ZN7hnswlib17InnerProductSpaceD2Ev, %function
_ZN7hnswlib17InnerProductSpaceD2Ev:
.LFB3545:
	.cfi_startproc
	ret
	.cfi_endproc
.LFE3545:
	.size	_ZN7hnswlib17InnerProductSpaceD2Ev, .-_ZN7hnswlib17InnerProductSpaceD2Ev
	.weak	_ZN7hnswlib17InnerProductSpaceD1Ev
	.set	_ZN7hnswlib17InnerProductSpaceD1Ev,_ZN7hnswlib17InnerProductSpaceD2Ev
	.section	.text._ZN7hnswlib17InnerProductSpaceD0Ev,"axG",@progbits,_ZN7hnswlib17InnerProductSpaceD5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17InnerProductSpaceD0Ev
	.type	_ZN7hnswlib17InnerProductSpaceD0Ev, %function
_ZN7hnswlib17InnerProductSpaceD0Ev:
.LFB3547:
	.cfi_startproc
	mov	x1, 32
	b	_ZdlPvm
	.cfi_endproc
.LFE3547:
	.size	_ZN7hnswlib17InnerProductSpaceD0Ev, .-_ZN7hnswlib17InnerProductSpaceD0Ev
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"void hnswlib::HierarchicalNSW<dist_t>::unmarkDeletedInternal(hnswlib::tableint) [with dist_t = float; hnswlib::tableint = unsigned int]"
	.align	3
.LC1:
	.string	"hnswlib/hnswlib/hnswalg.h"
	.align	3
.LC2:
	.string	"internalId < cur_element_count"
	.text
	.align	2
	.p2align 4,,11
	.type	_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj.part.0, %function
_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj.part.0:
.LFB8589:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	adrp	x3, .LC0
	adrp	x1, .LC1
	mov	x29, sp
	adrp	x0, .LC2
	add	x3, x3, :lo12:.LC0
	add	x1, x1, :lo12:.LC1
	add	x0, x0, :lo12:.LC2
	mov	w2, 916
	bl	__assert_fail
	.cfi_endproc
.LFE8589:
	.size	_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj.part.0, .-_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj.part.0
	.align	2
	.p2align 4,,11
	.type	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0, %function
_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0:
.LFB8636:
	.cfi_startproc
	sub	x4, x1, #1
	add	x4, x4, x4, lsr 63
	asr	x4, x4, 1
	cmp	x1, x2
	ble	.L28
.L17:
	lsl	x5, x4, 4
	add	x6, x0, x5
	ldr	s1, [x0, x5]
	fcmpe	s1, s0
	bmi	.L19
	bgt	.L28
	ldr	x8, [x6, 8]
	cmp	x8, x3
	bcc	.L22
.L28:
	add	x6, x0, x1, lsl 4
.L18:
	str	s0, [x6]
	str	x3, [x6, 8]
	ret
	.p2align 2,,3
.L19:
	ldr	x8, [x6, 8]
.L22:
	lsl	x7, x1, 4
	sub	x5, x4, #1
	add	x9, x0, x7
	mov	x1, x4
	add	x5, x5, x5, lsr 63
	str	s1, [x0, x7]
	str	x8, [x9, 8]
	asr	x4, x5, 1
	cmp	x1, x2
	bgt	.L17
	b	.L18
	.cfi_endproc
.LFE8636:
	.size	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0, .-_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	.section	.rodata.str1.8
	.align	3
.LC3:
	.string	"basic_string::_M_construct null not valid"
	.text
	.align	2
	.p2align 4,,11
	.type	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag.isra.0, %function
_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag.isra.0:
.LFB8606:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	cmp	x2, 0
	ccmp	x1, 0, 0, ne
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	str	x21, [sp, 32]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.cfi_offset 21, -32
	beq	.L40
	sub	x19, x2, x1
	str	x19, [sp, 56]
	mov	x21, x1
	mov	x20, x0
	cmp	x19, 15
	bhi	.L41
	ldr	x0, [x0]
	cmp	x19, 1
	bne	.L33
	ldrb	w1, [x1]
	strb	w1, [x0]
	ldr	x0, [x20]
	ldr	x19, [sp, 56]
	str	x19, [x20, 8]
	strb	wzr, [x0, x19]
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L33:
	.cfi_restore_state
	cbnz	x19, .L32
	str	x19, [x20, 8]
	strb	wzr, [x0, x19]
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L41:
	.cfi_restore_state
	add	x1, sp, 56
	mov	x2, 0
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm
	str	x0, [x20]
	ldr	x1, [sp, 56]
	str	x1, [x20, 16]
.L32:
	mov	x2, x19
	mov	x1, x21
	bl	memcpy
	ldr	x0, [x20]
	ldr	x19, [sp, 56]
	str	x19, [x20, 8]
	strb	wzr, [x0, x19]
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L40:
	.cfi_restore_state
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	_ZSt19__throw_logic_errorPKc
	.cfi_endproc
.LFE8606:
	.size	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag.isra.0, .-_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag.isra.0
	.align	2
	.p2align 4,,11
	.type	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0, %function
_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0:
.LFB8599:
	.cfi_startproc
	sub	x4, x1, #1
	lsr	x9, x3, 32
	mov	w10, w9
	lsr	w3, w3, 0
	add	x4, x4, x4, lsr 63
	fmov	d0, x3
	asr	x4, x4, 1
	cmp	x1, x2
	ble	.L54
.L43:
	lsl	x3, x4, 3
	add	x5, x0, x3
	ldr	s1, [x0, x3]
	fcmpe	s0, s1
	bgt	.L45
	bmi	.L54
	ldr	w7, [x5, 4]
	cmp	w10, w7
	bhi	.L48
.L54:
	add	x5, x0, x1, lsl 3
.L44:
	str	s0, [x5]
	str	w9, [x5, 4]
	ret
	.p2align 2,,3
.L45:
	ldr	w7, [x5, 4]
.L48:
	lsl	x6, x1, 3
	sub	x3, x4, #1
	add	x8, x0, x6
	mov	x1, x4
	add	x3, x3, x3, lsr 63
	str	s1, [x0, x6]
	str	w7, [x8, 4]
	asr	x4, x3, 1
	cmp	x2, x1
	blt	.L43
	b	.L44
	.cfi_endproc
.LFE8599:
	.size	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0, .-_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	.align	2
	.p2align 4,,11
	.type	_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops15_Iter_comp_iterISt4lessIS3_EEEEvT_T0_SF_T1_T2_.isra.0, %function
_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops15_Iter_comp_iterISt4lessIS3_EEEEvT_T0_SF_T1_T2_.isra.0:
.LFB8608:
	.cfi_startproc
	mov	x10, x2
	mov	x2, x1
	sub	x8, x10, #1
	add	x8, x8, x8, lsr 63
	asr	x8, x8, 1
	cmp	x1, x8
	bge	.L56
	mov	x5, x1
	b	.L60
	.p2align 2,,3
.L64:
	mov	w6, w4
	.p2align 3,,7
.L59:
	lsl	x4, x5, 3
	mov	x5, x1
	add	x7, x0, x4
	str	s0, [x0, x4]
	str	w6, [x7, 4]
	cmp	x1, x8
	bge	.L56
.L60:
	add	x4, x5, 1
	lsl	x7, x4, 1
	lsl	x4, x4, 4
	sub	x1, x7, #1
	add	x9, x0, x4
	lsl	x6, x1, 3
	ldr	s1, [x0, x4]
	add	x4, x0, x6
	ldr	s0, [x0, x6]
	fcmpe	s1, s0
	bmi	.L66
	ldr	w6, [x9, 4]
	bgt	.L63
	ldr	w4, [x4, 4]
	cmp	w4, w6
	bhi	.L64
.L63:
	fmov	s0, s1
	lsl	x4, x5, 3
	mov	x1, x7
	add	x7, x0, x4
	mov	x5, x1
	str	s0, [x0, x4]
	str	w6, [x7, 4]
	cmp	x1, x8
	blt	.L60
.L56:
	tbnz	x10, 0, .L61
	sub	x10, x10, #2
	add	x10, x10, x10, lsr 63
	cmp	x1, x10, asr 1
	beq	.L68
.L61:
	b	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	.p2align 2,,3
.L66:
	ldr	w6, [x4, 4]
	b	.L59
	.p2align 2,,3
.L68:
	lsl	x5, x1, 1
	lsl	x4, x1, 3
	add	x1, x5, 1
	add	x6, x0, x4
	lsl	x5, x1, 3
	add	x7, x0, x5
	ldr	s0, [x0, x5]
	ldr	w5, [x7, 4]
	str	s0, [x0, x4]
	str	w5, [x6, 4]
	b	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	.cfi_endproc
.LFE8608:
	.size	_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops15_Iter_comp_iterISt4lessIS3_EEEEvT_T0_SF_T1_T2_.isra.0, .-_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops15_Iter_comp_iterISt4lessIS3_EEEEvT_T0_SF_T1_T2_.isra.0
	.align	2
	.p2align 4,,11
	.type	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0, %function
_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0:
.LFB8597:
	.cfi_startproc
	cbz	x0, .L130
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	mov	x23, x0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
.L87:
	ldr	x24, [x23, 24]
	cbz	x24, .L71
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -24
	.cfi_offset 25, -32
.L86:
	ldr	x25, [x24, 24]
	cbz	x25, .L72
.L85:
	ldr	x26, [x25, 24]
	cbz	x26, .L73
.L84:
	ldr	x19, [x26, 24]
	cbz	x19, .L74
.L83:
	ldr	x20, [x19, 24]
	cbz	x20, .L75
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -56
	.cfi_offset 21, -64
	str	x27, [sp, 80]
	.cfi_offset 27, -16
.L82:
	ldr	x27, [x20, 24]
	cbz	x27, .L76
.L81:
	ldr	x21, [x27, 24]
	cbz	x21, .L77
.L80:
	ldr	x22, [x21, 24]
	cbz	x22, .L78
.L79:
	ldr	x0, [x22, 24]
	bl	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0
	mov	x0, x22
	mov	x1, 40
	ldr	x22, [x22, 16]
	bl	_ZdlPvm
	cbnz	x22, .L79
.L78:
	ldr	x22, [x21, 16]
	mov	x0, x21
	mov	x1, 40
	bl	_ZdlPvm
	cbz	x22, .L77
	mov	x21, x22
	b	.L80
.L131:
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldr	x27, [sp, 80]
	.cfi_restore 27
.L75:
	mov	x0, x19
	ldr	x20, [x19, 16]
	mov	x1, 40
	bl	_ZdlPvm
	cbz	x20, .L74
	mov	x19, x20
	b	.L83
	.p2align 2,,3
.L76:
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 27, -16
	ldr	x21, [x20, 16]
	mov	x0, x20
	mov	x1, 40
	bl	_ZdlPvm
	cbz	x21, .L131
	mov	x20, x21
	b	.L82
.L74:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 27
	ldr	x19, [x26, 16]
	mov	x0, x26
	mov	x1, 40
	bl	_ZdlPvm
	cbz	x19, .L73
	mov	x26, x19
	b	.L84
	.p2align 2,,3
.L77:
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 27, -16
	ldr	x21, [x27, 16]
	mov	x0, x27
	mov	x1, 40
	bl	_ZdlPvm
	cbz	x21, .L76
	mov	x27, x21
	b	.L81
.L73:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 27
	ldr	x19, [x25, 16]
	mov	x0, x25
	mov	x1, 40
	bl	_ZdlPvm
	cbz	x19, .L72
	mov	x25, x19
	b	.L85
.L72:
	ldr	x19, [x24, 16]
	mov	x0, x24
	mov	x1, 40
	bl	_ZdlPvm
	cbz	x19, .L132
	mov	x24, x19
	b	.L86
.L132:
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
.L71:
	mov	x0, x23
	ldr	x19, [x23, 16]
	mov	x1, 40
	bl	_ZdlPvm
	cbz	x19, .L133
	mov	x23, x19
	b	.L87
.L133:
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L130:
	ret
	.cfi_endproc
.LFE8597:
	.size	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0, .-_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0
	.section	.rodata._ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_.str1.8,"aMS",@progbits,1
	.align	3
.LC4:
	.string	"basic_string::append"
	.section	.text._ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_,"axG",@progbits,_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
	.type	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_, %function
_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_:
.LFB6519:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6519
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x2, x0
	add	x0, x8, 16
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	ldr	x20, [x2, 8]
	str	x0, [x8]
	ldr	x22, [x2]
	cmn	x22, x20
	ccmp	x22, 0, 0, ne
	beq	.L148
	str	x20, [sp, 56]
	mov	x19, x8
	mov	x21, x1
	cmp	x20, 15
	bhi	.L149
	cmp	x20, 1
	bne	.L138
	ldrb	w1, [x22]
	strb	w1, [x8, 16]
.L139:
	str	x20, [x19, 8]
	strb	wzr, [x0, x20]
	mov	x0, x21
	bl	strlen
	mov	x2, x0
	ldr	x1, [x19, 8]
	mov	x0, 4611686018427387903
	sub	x0, x0, x1
	cmp	x2, x0
	bhi	.L150
	mov	x1, x21
	mov	x0, x19
.LEHB0:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_appendEPKcm
.LEHE0:
	mov	x0, x19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L138:
	.cfi_restore_state
	cbz	x20, .L139
	b	.L137
	.p2align 2,,3
.L149:
	add	x1, sp, 56
	mov	x0, x8
	mov	x2, 0
.LEHB1:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm
.LEHE1:
	ldr	x1, [sp, 56]
	str	x0, [x19]
	str	x1, [x19, 16]
.L137:
	mov	x2, x20
	mov	x1, x22
	bl	memcpy
	ldr	x0, [x19]
	ldr	x20, [sp, 56]
	b	.L139
.L150:
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
.LEHB2:
	bl	_ZSt20__throw_length_errorPKc
.LEHE2:
.L148:
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
.LEHB3:
	bl	_ZSt19__throw_logic_errorPKc
.L142:
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_disposeEv
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE3:
	.cfi_endproc
.LFE6519:
	.global	__gxx_personality_v0
	.section	.gcc_except_table._ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_,"aG",@progbits,_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_,comdat
.LLSDA6519:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE6519-.LLSDACSB6519
.LLSDACSB6519:
	.uleb128 .LEHB0-.LFB6519
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L142-.LFB6519
	.uleb128 0
	.uleb128 .LEHB1-.LFB6519
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB2-.LFB6519
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L142-.LFB6519
	.uleb128 0
	.uleb128 .LEHB3-.LFB6519
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
.LLSDACSE6519:
	.section	.text._ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_,"axG",@progbits,_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_,comdat
	.size	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_, .-_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
	.section	.text._ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev,"axG",@progbits,_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev
	.type	_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev, %function
_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev:
.LFB6589:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	mov	x21, x0
	ldr	x0, [x0]
	cbz	x0, .L151
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -24
	.cfi_offset 19, -32
	ldr	x20, [x21, 72]
	ldr	x19, [x21, 40]
	add	x20, x20, 8
	cmp	x19, x20
	bcs	.L153
	.p2align 3,,7
.L154:
	ldr	x0, [x19], 8
	mov	x1, 512
	bl	_ZdlPvm
	cmp	x20, x19
	bhi	.L154
	ldr	x0, [x21]
.L153:
	ldr	x1, [x21, 8]
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldr	x21, [sp, 32]
	lsl	x1, x1, 3
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_def_cfa_offset 0
	b	_ZdlPvm
	.p2align 2,,3
.L151:
	.cfi_def_cfa_offset 48
	.cfi_offset 21, -16
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6589:
	.size	_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev, .-_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev
	.weak	_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED1Ev
	.set	_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED1Ev,_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev
	.section	.text._ZN7hnswlib15HierarchicalNSWIfED2Ev,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfED2Ev
	.type	_ZN7hnswlib15HierarchicalNSWIfED2Ev, %function
_ZN7hnswlib15HierarchicalNSWIfED2Ev:
.LFB8370:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	adrp	x1, _ZTVN7hnswlib15HierarchicalNSWIfEE+16
	add	x1, x1, :lo12:_ZTVN7hnswlib15HierarchicalNSWIfEE+16
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x19, x0
	add	x20, x0, 272
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	add	x22, x0, 16
	mov	w21, 0
	ldr	x0, [x0, 256]
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -16
	.cfi_offset 24, -8
	str	x1, [x19]
	bl	free
	str	xzr, [x19, 256]
	.p2align 3,,7
.L160:
	ldar	x1, [x22]
	uxtw	x0, w21
	add	w21, w21, 1
	cmp	x0, x1
	bcs	.L158
.L219:
	ldr	x1, [x20]
	ldr	w1, [x1, x0, lsl 2]
	cmp	w1, 0
	ble	.L160
	ldr	x1, [x19, 264]
	ldr	x0, [x1, x0, lsl 3]
	bl	free
	ldar	x1, [x22]
	uxtw	x0, w21
	add	w21, w21, 1
	cmp	x0, x1
	bcc	.L219
.L158:
	ldr	x0, [x19, 264]
	bl	free
	str	xzr, [x19, 264]
	stlr	xzr, [x22]
	ldr	x24, [x19, 112]
	str	xzr, [x19, 112]
	cbz	x24, .L161
	add	x21, x24, 16
	add	x22, x24, 48
	.p2align 3,,7
.L165:
	ldr	x0, [x21, 24]
	ldr	x1, [x22, 24]
	ldr	x2, [x22]
	sub	x1, x1, x0
	ldr	x0, [x22, 8]
	asr	x1, x1, 3
	ldr	x3, [x21]
	sub	x2, x2, x0
	ldr	x0, [x21, 16]
	sub	x1, x1, #1
	asr	x2, x2, 3
	add	x5, x3, 8
	sub	x4, x0, x3
	add	x1, x2, x1, lsl 6
	sub	x0, x0, #8
	add	x1, x1, x4, asr 3
	cbz	x1, .L162
	ldr	x23, [x3]
	cmp	x3, x0
	beq	.L163
	str	x5, [x24, 16]
	cbz	x23, .L165
.L220:
	ldr	x0, [x23, 8]
	cbz	x0, .L166
	bl	_ZdaPv
.L166:
	mov	x0, x23
	mov	x1, 24
	bl	_ZdlPvm
	b	.L165
	.p2align 2,,3
.L163:
	ldr	x0, [x24, 24]
	mov	x1, 512
	bl	_ZdlPvm
	ldr	x0, [x24, 40]
	add	x1, x0, 8
	ldr	x0, [x0, 8]
	str	x0, [x21, 8]
	str	x1, [x21, 24]
	add	x1, x0, 512
	str	x1, [x21, 16]
	str	x0, [x24, 16]
	cbz	x23, .L165
	b	.L220
	.p2align 2,,3
.L162:
	mov	x0, x24
	bl	_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev
	mov	x0, x24
	mov	x1, 136
	bl	_ZdlPvm
.L161:
	ldr	x21, [x19, 528]
	add	x22, x19, 512
	cbz	x21, .L171
	.p2align 3,,7
.L168:
	mov	x0, x21
	mov	x1, 16
	ldr	x21, [x21]
	bl	_ZdlPvm
	cbnz	x21, .L168
.L171:
	ldr	x2, [x22, 8]
	mov	w1, 0
	ldr	x0, [x19, 512]
	lsl	x2, x2, 3
	bl	memset
	ldr	x0, [x19, 512]
	add	x2, x19, 560
	stp	xzr, xzr, [x22, 16]
	ldr	x1, [x22, 8]
	cmp	x0, x2
	beq	.L169
	lsl	x1, x1, 3
	bl	_ZdlPvm
.L169:
	ldr	x21, [x19, 384]
	add	x22, x19, 368
	cbz	x21, .L175
	.p2align 3,,7
.L172:
	mov	x0, x21
	mov	x1, 24
	ldr	x21, [x21]
	bl	_ZdlPvm
	cbnz	x21, .L172
.L175:
	ldr	x2, [x22, 8]
	mov	w1, 0
	ldr	x0, [x19, 368]
	lsl	x2, x2, 3
	bl	memset
	ldr	x0, [x19, 368]
	add	x2, x19, 416
	stp	xzr, xzr, [x22, 16]
	ldr	x1, [x22, 8]
	cmp	x0, x2
	beq	.L173
	lsl	x1, x1, 3
	bl	_ZdlPvm
.L173:
	ldr	x0, [x19, 272]
	cbz	x0, .L176
	ldr	x1, [x20, 16]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L176:
	ldr	x0, [x19, 192]
	cbz	x0, .L177
	ldr	x1, [x19, 208]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L177:
	ldr	x0, [x19, 120]
	cbz	x0, .L178
	ldr	x1, [x19, 136]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L178:
	ldr	x22, [x19, 112]
	cbz	x22, .L157
	add	x19, x22, 16
	add	x20, x22, 48
	.p2align 3,,7
.L183:
	ldr	x2, [x19, 24]
	ldr	x0, [x20, 24]
	ldr	x1, [x20]
	sub	x0, x0, x2
	ldr	x2, [x20, 8]
	asr	x0, x0, 3
	ldr	x3, [x19]
	sub	x1, x1, x2
	ldr	x2, [x19, 16]
	sub	x0, x0, #1
	asr	x1, x1, 3
	add	x5, x3, 8
	sub	x4, x2, x3
	add	x0, x1, x0, lsl 6
	sub	x2, x2, #8
	add	x0, x0, x4, asr 3
	cbz	x0, .L180
	ldr	x21, [x3]
	cmp	x3, x2
	beq	.L181
	str	x5, [x22, 16]
	cbz	x21, .L183
.L221:
	ldr	x0, [x21, 8]
	cbz	x0, .L184
	bl	_ZdaPv
.L184:
	mov	x0, x21
	mov	x1, 24
	bl	_ZdlPvm
	b	.L183
	.p2align 2,,3
.L181:
	ldr	x0, [x22, 24]
	mov	x1, 512
	bl	_ZdlPvm
	ldr	x0, [x22, 40]
	add	x1, x0, 8
	ldr	x0, [x0, 8]
	str	x0, [x19, 8]
	str	x1, [x19, 24]
	add	x1, x0, 512
	str	x1, [x19, 16]
	str	x0, [x22, 16]
	cbz	x21, .L183
	b	.L221
	.p2align 2,,3
.L180:
	mov	x0, x22
	bl	_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev
	mov	x0, x22
	mov	x1, 136
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	b	_ZdlPvm
	.p2align 2,,3
.L157:
	.cfi_restore_state
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE8370:
	.size	_ZN7hnswlib15HierarchicalNSWIfED2Ev, .-_ZN7hnswlib15HierarchicalNSWIfED2Ev
	.weak	_ZN7hnswlib15HierarchicalNSWIfED1Ev
	.set	_ZN7hnswlib15HierarchicalNSWIfED1Ev,_ZN7hnswlib15HierarchicalNSWIfED2Ev
	.section	.text._ZN7hnswlib15HierarchicalNSWIfED0Ev,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfED0Ev
	.type	_ZN7hnswlib15HierarchicalNSWIfED0Ev, %function
_ZN7hnswlib15HierarchicalNSWIfED0Ev:
.LFB8372:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	bl	_ZN7hnswlib15HierarchicalNSWIfED1Ev
	mov	x0, x19
	mov	x1, 568
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	b	_ZdlPvm
	.cfi_endproc
.LFE8372:
	.size	_ZN7hnswlib15HierarchicalNSWIfED0Ev, .-_ZN7hnswlib15HierarchicalNSWIfED0Ev
	.section	.text._ZNSt12_Vector_baseIjSaIjEED2Ev,"axG",@progbits,_ZNSt12_Vector_baseIjSaIjEED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt12_Vector_baseIjSaIjEED2Ev
	.type	_ZNSt12_Vector_baseIjSaIjEED2Ev, %function
_ZNSt12_Vector_baseIjSaIjEED2Ev:
.LFB6636:
	.cfi_startproc
	mov	x2, x0
	ldr	x0, [x0]
	cbz	x0, .L224
	ldr	x1, [x2, 16]
	sub	x1, x1, x0
	b	_ZdlPvm
	.p2align 2,,3
.L224:
	ret
	.cfi_endproc
.LFE6636:
	.size	_ZNSt12_Vector_baseIjSaIjEED2Ev, .-_ZNSt12_Vector_baseIjSaIjEED2Ev
	.weak	_ZNSt12_Vector_baseIjSaIjEED1Ev
	.set	_ZNSt12_Vector_baseIjSaIjEED1Ev,_ZNSt12_Vector_baseIjSaIjEED2Ev
	.section	.text._ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev,"axG",@progbits,_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	.type	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev, %function
_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev:
.LFB6674:
	.cfi_startproc
	mov	x2, x0
	ldr	x0, [x0]
	cbz	x0, .L226
	ldr	x1, [x2, 16]
	sub	x1, x1, x0
	b	_ZdlPvm
	.p2align 2,,3
.L226:
	ret
	.cfi_endproc
.LFE6674:
	.size	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev, .-_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	.weak	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED1Ev
	.set	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED1Ev,_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	.section	.text._ZNSt12_Vector_baseI12SearchResultSaIS0_EED2Ev,"axG",@progbits,_ZNSt12_Vector_baseI12SearchResultSaIS0_EED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt12_Vector_baseI12SearchResultSaIS0_EED2Ev
	.type	_ZNSt12_Vector_baseI12SearchResultSaIS0_EED2Ev, %function
_ZNSt12_Vector_baseI12SearchResultSaIS0_EED2Ev:
.LFB6737:
	.cfi_startproc
	mov	x2, x0
	ldr	x0, [x0]
	cbz	x0, .L228
	ldr	x1, [x2, 16]
	sub	x1, x1, x0
	b	_ZdlPvm
	.p2align 2,,3
.L228:
	ret
	.cfi_endproc
.LFE6737:
	.size	_ZNSt12_Vector_baseI12SearchResultSaIS0_EED2Ev, .-_ZNSt12_Vector_baseI12SearchResultSaIS0_EED2Ev
	.weak	_ZNSt12_Vector_baseI12SearchResultSaIS0_EED1Ev
	.set	_ZNSt12_Vector_baseI12SearchResultSaIS0_EED1Ev,_ZNSt12_Vector_baseI12SearchResultSaIS0_EED2Ev
	.section	.text._ZNSt11unique_lockISt5mutexE6unlockEv,"axG",@progbits,_ZNSt11unique_lockISt5mutexE6unlockEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt11unique_lockISt5mutexE6unlockEv
	.type	_ZNSt11unique_lockISt5mutexE6unlockEv, %function
_ZNSt11unique_lockISt5mutexE6unlockEv:
.LFB6905:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	ldrb	w0, [x0, 8]
	cbz	w0, .L241
	ldr	x0, [x19]
	cbz	x0, .L230
	adrp	x1, .LC5
	ldr	x1, [x1, #:lo12:.LC5]
	cbz	x1, .L233
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L233:
	strb	wzr, [x19, 8]
.L230:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
.L241:
	.cfi_restore_state
	mov	w0, 1
	bl	_ZSt20__throw_system_errori
	.cfi_endproc
.LFE6905:
	.size	_ZNSt11unique_lockISt5mutexE6unlockEv, .-_ZNSt11unique_lockISt5mutexE6unlockEv
	.section	.text._ZN7hnswlib15VisitedListPool18getFreeVisitedListEv,"axG",@progbits,_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv
	.type	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv, %function
_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv:
.LFB4283:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA4283
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	adrp	x1, .LC5
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	ldr	x21, [x1, #:lo12:.LC5]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x19, x0
	add	x0, x0, 80
	str	x0, [sp, 48]
	strb	wzr, [sp, 56]
	cbz	x21, .L243
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L275
.L243:
	mov	w1, 1
	strb	w1, [sp, 56]
	ldp	x0, x3, [x19, 48]
	add	x22, x19, 16
	ldr	x4, [x22, 24]
	ldr	x1, [x19, 72]
	ldr	x2, [x19, 16]
	sub	x1, x1, x4
	ldr	x4, [x22, 16]
	sub	x0, x0, x3
	asr	x1, x1, 3
	sub	x1, x1, #1
	asr	x0, x0, 3
	sub	x3, x4, x2
	add	x1, x0, x1, lsl 6
	add	x0, x1, x3, asr 3
	cbnz	x0, .L276
	mov	x0, 24
.LEHB4:
	bl	_Znwm
.LEHE4:
	mov	x20, x0
	ldr	w1, [x19, 128]
	mov	w2, -1
	strh	w2, [x0]
	str	w1, [x20, 16]
	ubfiz	x0, x1, 1, 32
.LEHB5:
	bl	_Znam
.LEHE5:
	str	x0, [x20, 8]
.L247:
	ldrb	w0, [sp, 56]
	cbnz	w0, .L246
.L248:
	ldrh	w0, [x20]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x20]
	cbz	w0, .L277
.L242:
	mov	x0, x20
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L276:
	.cfi_restore_state
	sub	x4, x4, #8
	ldr	x20, [x2]
	cmp	x2, x4
	beq	.L245
	add	x2, x2, 8
	str	x2, [x19, 16]
.L246:
	ldr	x0, [sp, 48]
	cbz	x0, .L248
	cbz	x21, .L248
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	ldrh	w0, [x20]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x20]
	cbnz	w0, .L242
.L277:
	ldr	x0, [x20, 8]
	mov	w1, 0
	ldr	w2, [x20, 16]
	lsl	x2, x2, 1
	bl	memset
	ldrh	w0, [x20]
	ldp	x21, x22, [sp, 32]
	add	w0, w0, 1
	strh	w0, [x20]
	mov	x0, x20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L245:
	.cfi_restore_state
	ldr	x0, [x19, 24]
	mov	x1, 512
	bl	_ZdlPvm
	ldr	x0, [x19, 40]
	add	x1, x0, 8
	ldr	x0, [x0, 8]
	str	x0, [x22, 8]
	str	x1, [x22, 24]
	add	x1, x0, 512
	str	x1, [x22, 16]
	str	x0, [x19, 16]
	b	.L247
.L275:
.LEHB6:
	bl	_ZSt20__throw_system_errori
.LEHE6:
.L254:
	mov	x19, x0
	b	.L252
.L255:
	mov	x19, x0
	mov	x1, 24
	mov	x0, x20
	bl	_ZdlPvm
.L252:
	ldrb	w0, [sp, 56]
	cbz	w0, .L253
	add	x0, sp, 48
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L253:
	mov	x0, x19
.LEHB7:
	bl	_Unwind_Resume
.LEHE7:
	.cfi_endproc
.LFE4283:
	.section	.gcc_except_table._ZN7hnswlib15VisitedListPool18getFreeVisitedListEv,"aG",@progbits,_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv,comdat
.LLSDA4283:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE4283-.LLSDACSB4283
.LLSDACSB4283:
	.uleb128 .LEHB4-.LFB4283
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L254-.LFB4283
	.uleb128 0
	.uleb128 .LEHB5-.LFB4283
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L255-.LFB4283
	.uleb128 0
	.uleb128 .LEHB6-.LFB4283
	.uleb128 .LEHE6-.LEHB6
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB7-.LFB4283
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
.LLSDACSE4283:
	.section	.text._ZN7hnswlib15VisitedListPool18getFreeVisitedListEv,"axG",@progbits,_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv,comdat
	.size	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv, .-_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv
	.section	.text._ZNSt12_Vector_baseISt5mutexSaIS0_EED2Ev,"axG",@progbits,_ZNSt12_Vector_baseISt5mutexSaIS0_EED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt12_Vector_baseISt5mutexSaIS0_EED2Ev
	.type	_ZNSt12_Vector_baseISt5mutexSaIS0_EED2Ev, %function
_ZNSt12_Vector_baseISt5mutexSaIS0_EED2Ev:
.LFB7278:
	.cfi_startproc
	mov	x2, x0
	ldr	x0, [x0]
	cbz	x0, .L278
	ldr	x1, [x2, 16]
	sub	x1, x1, x0
	b	_ZdlPvm
	.p2align 2,,3
.L278:
	ret
	.cfi_endproc
.LFE7278:
	.size	_ZNSt12_Vector_baseISt5mutexSaIS0_EED2Ev, .-_ZNSt12_Vector_baseISt5mutexSaIS0_EED2Ev
	.weak	_ZNSt12_Vector_baseISt5mutexSaIS0_EED1Ev
	.set	_ZNSt12_Vector_baseISt5mutexSaIS0_EED1Ev,_ZNSt12_Vector_baseISt5mutexSaIS0_EED2Ev
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE5clearEv,"axG",@progbits,_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE5clearEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE5clearEv
	.type	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE5clearEv, %function
_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE5clearEv:
.LFB7319:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	mov	x20, x0
	ldr	x19, [x0, 16]
	cbz	x19, .L281
	.p2align 3,,7
.L282:
	mov	x0, x19
	mov	x1, 16
	ldr	x19, [x19]
	bl	_ZdlPvm
	cbnz	x19, .L282
.L281:
	ldp	x0, x2, [x20]
	mov	w1, 0
	lsl	x2, x2, 3
	bl	memset
	stp	xzr, xzr, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7319:
	.size	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE5clearEv, .-_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE5clearEv
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE21_M_deallocate_bucketsEv,"axG",@progbits,_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE21_M_deallocate_bucketsEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE21_M_deallocate_bucketsEv
	.type	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE21_M_deallocate_bucketsEv, %function
_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE21_M_deallocate_bucketsEv:
.LFB7320:
	.cfi_startproc
	add	x2, x0, 48
	ldp	x0, x1, [x0]
	cmp	x0, x2
	beq	.L288
	lsl	x1, x1, 3
	b	_ZdlPvm
	.p2align 2,,3
.L288:
	ret
	.cfi_endproc
.LFE7320:
	.size	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE21_M_deallocate_bucketsEv, .-_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE21_M_deallocate_bucketsEv
	.section	.text._ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv,"axG",@progbits,_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	.type	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv, %function
_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv:
.LFB7349:
	.cfi_startproc
	ldp	x1, x2, [x0]
	sub	x3, x2, x1
	sub	x9, x2, #8
	cmp	x3, 8
	bgt	.L312
	str	x9, [x0, 8]
	ret
	.p2align 2,,3
.L312:
	sub	x4, x9, x1
	ldr	s0, [x1]
	ldr	w5, [x1, 4]
	asr	x11, x4, 3
	ldr	w10, [x2, -4]
	sub	x3, x11, #1
	str	w5, [x2, -4]
	ldr	s2, [x2, -8]
	and	x12, x11, 1
	add	x8, x3, x3, lsr 63
	str	s0, [x2, -8]
	asr	x8, x8, 1
	cmp	x4, 16
	ble	.L292
	mov	x4, 0
	.p2align 3,,7
.L296:
	add	x2, x4, 1
	lsl	x3, x2, 1
	lsl	x2, x2, 4
	sub	x6, x3, #1
	add	x7, x1, x2
	lsl	x5, x6, 3
	ldr	s0, [x1, x2]
	add	x2, x1, x5
	ldr	s1, [x1, x5]
	fcmpe	s0, s1
	bmi	.L307
.L293:
	lsl	x2, x4, 3
	ldr	w6, [x7, 4]
	add	x5, x1, x2
	mov	x4, x3
	str	s0, [x1, x2]
	str	w6, [x5, 4]
	cmp	x3, x8
	blt	.L296
	lsl	x6, x3, 3
	cbz	x12, .L313
.L299:
	sub	x3, x3, #1
	asr	x4, x3, 1
	.p2align 3,,7
.L302:
	lsl	x5, x4, 3
	sub	x2, x4, #1
	add	x8, x1, x5
	add	x7, x1, x6
	add	x2, x2, x2, lsr 63
	ldr	s0, [x1, x5]
	asr	x2, x2, 1
	fcmpe	s2, s0
	bgt	.L308
.L297:
	str	w10, [x7, 4]
	str	s2, [x7]
.L315:
	str	x9, [x0, 8]
	ret
	.p2align 2,,3
.L308:
	ldr	w3, [x8, 4]
	str	s0, [x1, x6]
	lsl	x6, x4, 3
	str	w3, [x7, 4]
	cbz	x4, .L314
	mov	x4, x2
	b	.L302
	.p2align 2,,3
.L307:
	fmov	s0, s1
	mov	x7, x2
	mov	x3, x6
	b	.L293
	.p2align 2,,3
.L313:
	sub	x11, x11, #2
	add	x11, x11, x11, lsr 63
	cmp	x3, x11, asr 1
	beq	.L298
	sub	x4, x3, #1
	lsl	x6, x3, 3
	asr	x4, x4, 1
	b	.L302
	.p2align 2,,3
.L314:
	mov	x7, x8
	str	s2, [x7]
	str	w10, [x7, 4]
	b	.L315
	.p2align 2,,3
.L292:
	mov	x7, x1
	cbnz	x12, .L297
	cmp	x3, 2
	bhi	.L297
	mov	x3, 0
	.p2align 3,,7
.L298:
	lsl	x3, x3, 1
	add	x3, x3, 1
	lsl	x6, x3, 3
	add	x2, x1, x6
	ldr	s0, [x1, x6]
	ldr	w2, [x2, 4]
	str	w2, [x7, 4]
	str	s0, [x7]
	b	.L299
	.cfi_endproc
.LFE7349:
	.size	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv, .-_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji
	.type	_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji, %function
_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji:
.LFB7368:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA7368
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	w3, 48
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	mov	x21, x0
	str	x0, [sp, 80]
	uxtw	x0, w1
	str	w1, [sp, 92]
	ldr	x1, [x21, 192]
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	uxtw	x23, w0
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -88
	.cfi_offset 19, -96
	umaddl	x0, w0, w3, x1
	str	x0, [sp, 96]
	strb	wzr, [sp, 104]
	cbz	x0, .L347
	adrp	x1, .LC5
	mov	x20, x8
	mov	w19, w2
	ldr	x22, [x1, #:lo12:.LC5]
	cbz	x22, .L318
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L348
.L318:
	mov	w0, 1
	strb	w0, [sp, 104]
	cbz	w19, .L349
	ldr	x0, [x21, 264]
	sub	w19, w19, #1
	ldr	x1, [x21, 32]
	sxtw	x19, w19
	ldr	x0, [x0, x23, lsl 3]
	madd	x19, x19, x1, x0
	ldrh	w21, [x19]
	stp	xzr, xzr, [x20]
	str	xzr, [x20, 16]
	cbz	w21, .L321
.L351:
	ubfiz	x21, x21, 2, 16
	str	x25, [sp, 64]
	.cfi_offset 25, -48
	mov	x0, x21
.LEHB8:
	bl	_Znwm
.LEHE8:
	add	x24, x0, x21
	str	x0, [x20]
	str	x24, [x20, 16]
	mov	x2, x21
	mov	x23, x0
	mov	w1, 0
	bl	memset
	ldrb	w25, [sp, 104]
	str	x24, [x20, 8]
	mov	x0, x23
	mov	x2, x21
	add	x1, x19, 4
	bl	memcpy
	cbnz	w25, .L350
	ldr	x25, [sp, 64]
	.cfi_restore 25
.L316:
	mov	x0, x20
	ldp	x19, x20, [sp, 16]
	.cfi_remember_state
	.cfi_restore 20
	.cfi_restore 19
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L349:
	.cfi_restore_state
	ldr	x1, [x21, 24]
	ldr	x0, [x21, 240]
	ldr	x19, [x21, 256]
	madd	x23, x23, x1, x0
	add	x19, x19, x23
	ldrh	w21, [x19]
	stp	xzr, xzr, [x20]
	str	xzr, [x20, 16]
	cbnz	w21, .L351
.L321:
	stp	xzr, xzr, [x20]
	str	xzr, [x20, 16]
.L325:
	ldr	x0, [sp, 96]
	cbz	x0, .L316
	cbz	x22, .L316
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	mov	x0, x20
	ldp	x19, x20, [sp, 16]
	.cfi_remember_state
	.cfi_restore 20
	.cfi_restore 19
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_def_cfa_offset 0
	ret
.L347:
	.cfi_restore_state
	mov	w0, 1
	str	x25, [sp, 64]
	.cfi_offset 25, -48
.LEHB9:
	bl	_ZSt20__throw_system_errori
.L350:
	ldr	x25, [sp, 64]
	.cfi_restore 25
	b	.L325
.L348:
	str	x25, [sp, 64]
	.cfi_offset 25, -48
	bl	_ZSt20__throw_system_errori
.LEHE9:
.L326:
	ldrb	w1, [sp, 104]
	mov	x19, x0
	cbz	w1, .L324
	add	x0, sp, 96
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L324:
	mov	x0, x19
.LEHB10:
	bl	_Unwind_Resume
.LEHE10:
	.cfi_endproc
.LFE7368:
	.section	.gcc_except_table._ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji,"aG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji,comdat
.LLSDA7368:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7368-.LLSDACSB7368
.LLSDACSB7368:
	.uleb128 .LEHB8-.LFB7368
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L326-.LFB7368
	.uleb128 0
	.uleb128 .LEHB9-.LFB7368
	.uleb128 .LEHE9-.LEHB9
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB10-.LFB7368
	.uleb128 .LEHE10-.LEHB10
	.uleb128 0
	.uleb128 0
.LLSDACSE7368:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji, .-_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.type	_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE, %function
_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE:
.LFB6727:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6727
	sub	sp, sp, #608
	.cfi_def_cfa_offset 608
	stp	x29, x30, [sp]
	.cfi_offset 29, -608
	.cfi_offset 30, -600
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -592
	.cfi_offset 20, -584
	mov	x19, x1
	mov	x20, x0
	add	x0, sp, 344
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	.cfi_offset 21, -576
	.cfi_offset 22, -568
	.cfi_offset 23, -560
	.cfi_offset 24, -552
	adrp	x23, _ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	add	x23, x23, :lo12:_ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -544
	.cfi_offset 26, -536
	bl	_ZNSt8ios_baseC2Ev
	adrp	x2, _ZTTSt14basic_ofstreamIcSt11char_traitsIcEE
	add	x2, x2, :lo12:_ZTTSt14basic_ofstreamIcSt11char_traitsIcEE
	strh	wzr, [sp, 568]
	add	x4, sp, 576
	add	x0, sp, 88
	mov	x1, 0
	ldp	x22, x26, [x2, 8]
	add	x2, sp, 88
	ldr	x3, [x22, -24]
	stp	xzr, xzr, [x4]
	stp	xzr, xzr, [x4, 16]
	add	x0, x0, x3
	str	x22, [sp, 88]
	str	x23, [sp, 344]
	str	xzr, [sp, 560]
	str	x26, [x2, x3]
.LEHB11:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE11:
	adrp	x25, _ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+24
	adrp	x24, _ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+64
	add	x25, x25, :lo12:_ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+24
	add	x24, x24, :lo12:_ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+64
	add	x0, sp, 96
	str	x25, [sp, 88]
	str	x24, [sp, 344]
.LEHB12:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEEC1Ev
.LEHE12:
	add	x0, sp, 88
	add	x1, sp, 96
	add	x0, x0, 256
.LEHB13:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
	ldr	x1, [x19]
	add	x0, sp, 96
	mov	w2, 20
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE4openEPKcSt13_Ios_Openmode
	mov	x2, x0
	ldr	x0, [sp, 88]
	ldr	x1, [x0, -24]
	add	x0, sp, 88
	add	x0, x0, x1
	cbz	x2, .L379
	mov	w1, 0
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE13:
.L354:
	add	x1, x20, 240
	add	x0, sp, 88
	mov	x2, 8
.LEHB14:
	bl	_ZNSo5writeEPKcl
	mov	x2, 8
	add	x0, sp, 88
	add	x1, x20, x2
	bl	_ZNSo5writeEPKcl
	add	x21, x20, 16
	add	x0, sp, 88
	mov	x1, x21
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 24
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 248
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 232
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 104
	add	x0, sp, 88
	mov	x2, 4
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 216
	add	x0, sp, 88
	mov	x2, 4
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 56
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 64
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 48
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 88
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 72
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	ldr	x1, [x20, 256]
	ldar	x3, [x21]
	ldr	x2, [x20, 24]
	add	x0, sp, 88
	mul	x2, x3, x2
	bl	_ZNSo5writeEPKcl
	mov	x19, 0
	ldar	x0, [x21]
	cmp	x19, x0
	bcs	.L359
	.p2align 3,,7
.L381:
	ldr	x0, [x20, 272]
	mov	w3, 0
	ldr	w0, [x0, x19, lsl 2]
	cmp	w0, 0
	ble	.L360
	ldr	x3, [x20, 32]
	mul	w3, w0, w3
.L360:
	add	x1, sp, 84
	add	x0, sp, 88
	mov	x2, 4
	str	w3, [sp, 84]
	bl	_ZNSo5writeEPKcl
	ldr	w2, [sp, 84]
	cbnz	w2, .L380
	add	x19, x19, 1
.L383:
	ldar	x0, [x21]
	cmp	x19, x0
	bcc	.L381
.L359:
	add	x0, sp, 96
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
.LEHE14:
	cbz	x0, .L382
.L363:
	adrp	x1, _ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x0, sp, 96
	stp	x25, x1, [sp, 88]
	str	x24, [sp, 344]
.LEHB15:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
.LEHE15:
.L365:
	add	x0, sp, 208
	bl	_ZNSt12__basic_fileIcED1Ev
	adrp	x1, _ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x0, sp, 152
	str	x1, [sp, 96]
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x22, -24]
	add	x2, sp, 88
	str	x22, [sp, 88]
	add	x0, sp, 344
	str	x26, [x2, x1]
	str	x23, [sp, 344]
	bl	_ZNSt8ios_baseD2Ev
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	add	sp, sp, 608
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L380:
	.cfi_restore_state
	ldr	x1, [x20, 264]
	uxtw	x2, w2
	add	x0, sp, 88
	ldr	x1, [x1, x19, lsl 3]
.LEHB16:
	bl	_ZNSo5writeEPKcl
.LEHE16:
	add	x19, x19, 1
	b	.L383
	.p2align 2,,3
.L379:
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
.LEHB17:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE17:
	b	.L354
	.p2align 2,,3
.L382:
	ldr	x0, [sp, 88]
	add	x1, sp, 88
	ldr	x0, [x0, -24]
	add	x0, x1, x0
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
.LEHB18:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE18:
	b	.L363
.L372:
	bl	__cxa_begin_catch
	bl	__cxa_end_catch
	b	.L365
.L368:
	mov	x19, x0
	add	x0, sp, 88
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEED1Ev
	mov	x0, x19
.LEHB19:
	bl	_Unwind_Resume
.L371:
	mov	x19, x0
	add	x0, sp, 96
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEED1Ev
.L357:
	ldr	x0, [x22, -24]
	add	x1, sp, 88
	str	x22, [sp, 88]
	str	x26, [x1, x0]
.L358:
	add	x0, sp, 344
	str	x23, [sp, 344]
	bl	_ZNSt8ios_baseD2Ev
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE19:
.L370:
	mov	x19, x0
	b	.L357
.L369:
	mov	x19, x0
	b	.L358
	.cfi_endproc
.LFE6727:
	.section	.gcc_except_table._ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,"aG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,comdat
	.align	2
.LLSDA6727:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT6727-.LLSDATTD6727
.LLSDATTD6727:
	.byte	0x1
	.uleb128 .LLSDACSE6727-.LLSDACSB6727
.LLSDACSB6727:
	.uleb128 .LEHB11-.LFB6727
	.uleb128 .LEHE11-.LEHB11
	.uleb128 .L369-.LFB6727
	.uleb128 0
	.uleb128 .LEHB12-.LFB6727
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L370-.LFB6727
	.uleb128 0
	.uleb128 .LEHB13-.LFB6727
	.uleb128 .LEHE13-.LEHB13
	.uleb128 .L371-.LFB6727
	.uleb128 0
	.uleb128 .LEHB14-.LFB6727
	.uleb128 .LEHE14-.LEHB14
	.uleb128 .L368-.LFB6727
	.uleb128 0
	.uleb128 .LEHB15-.LFB6727
	.uleb128 .LEHE15-.LEHB15
	.uleb128 .L372-.LFB6727
	.uleb128 0x1
	.uleb128 .LEHB16-.LFB6727
	.uleb128 .LEHE16-.LEHB16
	.uleb128 .L368-.LFB6727
	.uleb128 0
	.uleb128 .LEHB17-.LFB6727
	.uleb128 .LEHE17-.LEHB17
	.uleb128 .L371-.LFB6727
	.uleb128 0
	.uleb128 .LEHB18-.LFB6727
	.uleb128 .LEHE18-.LEHB18
	.uleb128 .L368-.LFB6727
	.uleb128 0
	.uleb128 .LEHB19-.LFB6727
	.uleb128 .LEHE19-.LEHB19
	.uleb128 0
	.uleb128 0
.LLSDACSE6727:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT6727:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE, .-_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.section	.rodata._Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_.str1.8,"aMS",@progbits,1
	.align	3
.LC6:
	.string	"load data "
	.align	3
.LC7:
	.string	"\n"
	.align	3
.LC8:
	.string	"dimension: "
	.align	3
.LC9:
	.string	"  number:"
	.align	3
.LC10:
	.string	"  size_per_element:"
	.section	.text._Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,"axG",@progbits,_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,comdat
	.align	2
	.p2align 4,,11
	.weak	_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
	.type	_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_, %function
_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_:
.LFB6728:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6728
	sub	sp, sp, #624
	.cfi_def_cfa_offset 624
	stp	x29, x30, [sp]
	.cfi_offset 29, -624
	.cfi_offset 30, -616
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -608
	.cfi_offset 20, -600
	mov	x20, x1
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -592
	.cfi_offset 22, -584
	mov	x21, x2
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -576
	.cfi_offset 24, -568
	mov	x24, x0
	add	x0, sp, 360
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -560
	.cfi_offset 26, -552
	adrp	x25, _ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	add	x25, x25, :lo12:_ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -544
	.cfi_offset 28, -536
	bl	_ZNSt8ios_baseC2Ev
	adrp	x0, _ZTTSt14basic_ifstreamIcSt11char_traitsIcEE
	add	x0, x0, :lo12:_ZTTSt14basic_ifstreamIcSt11char_traitsIcEE
	strh	wzr, [sp, 584]
	add	x3, sp, 592
	mov	x1, 0
	ldp	x23, x28, [x0, 8]
	add	x0, sp, 96
	ldr	x2, [x23, -24]
	stp	xzr, xzr, [x3]
	stp	xzr, xzr, [x3, 16]
	str	x23, [sp, 96]
	str	x25, [sp, 360]
	str	xzr, [sp, 576]
	str	x28, [x0, x2]
	add	x2, sp, 96
	str	xzr, [sp, 104]
	ldr	x0, [x23, -24]
	add	x0, x2, x0
.LEHB20:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE20:
	adrp	x27, _ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+24
	adrp	x26, _ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+64
	add	x27, x27, :lo12:_ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+24
	add	x26, x26, :lo12:_ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+64
	add	x0, sp, 112
	str	x27, [sp, 96]
	str	x26, [sp, 360]
.LEHB21:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEEC1Ev
.LEHE21:
	add	x0, sp, 96
	add	x1, sp, 112
	add	x0, x0, 264
.LEHB22:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE22:
	ldr	x1, [x24]
	add	x0, sp, 112
	mov	w2, 12
.LEHB23:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE4openEPKcSt13_Ios_Openmode
	mov	x2, x0
	ldr	x0, [sp, 96]
	ldr	x1, [x0, -24]
	add	x0, sp, 96
	add	x0, x0, x1
	cbz	x2, .L411
	mov	w1, 0
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.L390:
	mov	x1, x20
	add	x0, sp, 96
	mov	x2, 4
	bl	_ZNSi4readEPcl
	mov	x1, x21
	add	x0, sp, 96
	mov	x2, 4
	bl	_ZNSi4readEPcl
	ldr	x0, [x20]
	mov	x1, 2305843009213693950
	ldr	x2, [x21]
	mul	x0, x0, x2
	cmp	x0, x1
	bhi	.L391
	lsl	x0, x0, 2
	bl	_Znam
	ldr	x1, [x20]
	mov	x22, x0
	mov	x19, 0
	cbz	x1, .L395
	.p2align 3,,7
.L393:
	ldr	x2, [x21]
	add	x0, sp, 96
	lsl	x2, x2, 2
	madd	x1, x2, x19, x22
	bl	_ZNSi4readEPcl
	ldr	x0, [x20]
	add	x19, x19, 1
	cmp	x0, x19
	bhi	.L393
.L395:
	add	x0, sp, 112
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
	cbz	x0, .L412
.L396:
	adrp	x19, _ZSt4cerr
	add	x19, x19, :lo12:_ZSt4cerr
	adrp	x1, .LC6
	mov	x0, x19
	add	x1, x1, :lo12:.LC6
	mov	x2, 10
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldp	x1, x2, [x24]
	mov	x0, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	adrp	x24, .LC7
	add	x24, x24, :lo12:.LC7
	mov	x1, x24
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	adrp	x1, .LC8
	mov	x0, x19
	add	x1, x1, :lo12:.LC8
	mov	x2, 11
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x1, [x21]
	mov	x0, x19
	bl	_ZNSo9_M_insertImEERSoT_
	adrp	x1, .LC9
	mov	x19, x0
	add	x1, x1, :lo12:.LC9
	mov	x2, 9
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x1, [x20]
	mov	x0, x19
	bl	_ZNSo9_M_insertImEERSoT_
	adrp	x1, .LC10
	mov	x19, x0
	add	x1, x1, :lo12:.LC10
	mov	x2, 19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x0, x19
	mov	x1, 4
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x24
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.LEHE23:
	adrp	x1, _ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x0, sp, 112
	str	x27, [sp, 96]
	str	x1, [sp, 112]
	str	x26, [sp, 360]
.LEHB24:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
.LEHE24:
.L398:
	add	x0, sp, 224
	bl	_ZNSt12__basic_fileIcED1Ev
	adrp	x1, _ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x0, sp, 168
	str	x1, [sp, 112]
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x23, -24]
	add	x2, sp, 96
	str	x23, [sp, 96]
	add	x0, sp, 360
	str	x28, [x2, x1]
	str	xzr, [sp, 104]
	str	x25, [sp, 360]
	bl	_ZNSt8ios_baseD2Ev
	mov	x0, x22
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	add	sp, sp, 624
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L411:
	.cfi_restore_state
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
.LEHB25:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
	b	.L390
	.p2align 2,,3
.L412:
	ldr	x0, [sp, 96]
	add	x1, sp, 96
	ldr	x0, [x0, -24]
	add	x0, x1, x0
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE25:
	b	.L396
.L405:
	bl	__cxa_begin_catch
	bl	__cxa_end_catch
	b	.L398
.L404:
	mov	x19, x0
	add	x0, sp, 112
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEED1Ev
.L387:
	ldr	x0, [x23, -24]
	add	x1, sp, 96
	str	x23, [sp, 96]
	str	x28, [x1, x0]
	str	xzr, [sp, 104]
.L388:
	add	x0, sp, 360
	str	x25, [sp, 360]
	bl	_ZNSt8ios_baseD2Ev
	mov	x0, x19
.LEHB26:
	bl	_Unwind_Resume
.LEHE26:
.L403:
	mov	x19, x0
	b	.L387
.L391:
.LEHB27:
	bl	__cxa_throw_bad_array_new_length
.LEHE27:
.L402:
	mov	x19, x0
	b	.L388
.L401:
	mov	x19, x0
	add	x0, sp, 96
	bl	_ZNSt14basic_ifstreamIcSt11char_traitsIcEED1Ev
	mov	x0, x19
.LEHB28:
	bl	_Unwind_Resume
.LEHE28:
	.cfi_endproc
.LFE6728:
	.section	.gcc_except_table._Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,"aG",@progbits,_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,comdat
	.align	2
.LLSDA6728:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT6728-.LLSDATTD6728
.LLSDATTD6728:
	.byte	0x1
	.uleb128 .LLSDACSE6728-.LLSDACSB6728
.LLSDACSB6728:
	.uleb128 .LEHB20-.LFB6728
	.uleb128 .LEHE20-.LEHB20
	.uleb128 .L402-.LFB6728
	.uleb128 0
	.uleb128 .LEHB21-.LFB6728
	.uleb128 .LEHE21-.LEHB21
	.uleb128 .L403-.LFB6728
	.uleb128 0
	.uleb128 .LEHB22-.LFB6728
	.uleb128 .LEHE22-.LEHB22
	.uleb128 .L404-.LFB6728
	.uleb128 0
	.uleb128 .LEHB23-.LFB6728
	.uleb128 .LEHE23-.LEHB23
	.uleb128 .L401-.LFB6728
	.uleb128 0
	.uleb128 .LEHB24-.LFB6728
	.uleb128 .LEHE24-.LEHB24
	.uleb128 .L405-.LFB6728
	.uleb128 0x1
	.uleb128 .LEHB25-.LFB6728
	.uleb128 .LEHE25-.LEHB25
	.uleb128 .L401-.LFB6728
	.uleb128 0
	.uleb128 .LEHB26-.LFB6728
	.uleb128 .LEHE26-.LEHB26
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB27-.LFB6728
	.uleb128 .LEHE27-.LEHB27
	.uleb128 .L401-.LFB6728
	.uleb128 0
	.uleb128 .LEHB28-.LFB6728
	.uleb128 .LEHE28-.LEHB28
	.uleb128 0
	.uleb128 0
.LLSDACSE6728:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT6728:
	.section	.text._Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,"axG",@progbits,_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,comdat
	.size	_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_, .-_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
	.section	.text._Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,"axG",@progbits,_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,comdat
	.align	2
	.p2align 4,,11
	.weak	_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
	.type	_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_, %function
_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_:
.LFB6729:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6729
	sub	sp, sp, #624
	.cfi_def_cfa_offset 624
	stp	x29, x30, [sp]
	.cfi_offset 29, -624
	.cfi_offset 30, -616
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -608
	.cfi_offset 20, -600
	mov	x20, x1
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -592
	.cfi_offset 22, -584
	mov	x21, x2
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -576
	.cfi_offset 24, -568
	mov	x24, x0
	add	x0, sp, 360
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -560
	.cfi_offset 26, -552
	adrp	x25, _ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	add	x25, x25, :lo12:_ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -544
	.cfi_offset 28, -536
	bl	_ZNSt8ios_baseC2Ev
	adrp	x0, _ZTTSt14basic_ifstreamIcSt11char_traitsIcEE
	add	x0, x0, :lo12:_ZTTSt14basic_ifstreamIcSt11char_traitsIcEE
	strh	wzr, [sp, 584]
	add	x3, sp, 592
	mov	x1, 0
	ldp	x23, x28, [x0, 8]
	add	x0, sp, 96
	ldr	x2, [x23, -24]
	stp	xzr, xzr, [x3]
	stp	xzr, xzr, [x3, 16]
	str	x23, [sp, 96]
	str	x25, [sp, 360]
	str	xzr, [sp, 576]
	str	x28, [x0, x2]
	add	x2, sp, 96
	str	xzr, [sp, 104]
	ldr	x0, [x23, -24]
	add	x0, x2, x0
.LEHB29:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE29:
	adrp	x27, _ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+24
	adrp	x26, _ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+64
	add	x27, x27, :lo12:_ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+24
	add	x26, x26, :lo12:_ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+64
	add	x0, sp, 112
	str	x27, [sp, 96]
	str	x26, [sp, 360]
.LEHB30:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEEC1Ev
.LEHE30:
	add	x0, sp, 96
	add	x1, sp, 112
	add	x0, x0, 264
.LEHB31:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE31:
	ldr	x1, [x24]
	add	x0, sp, 112
	mov	w2, 12
.LEHB32:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE4openEPKcSt13_Ios_Openmode
	mov	x2, x0
	ldr	x0, [sp, 96]
	ldr	x1, [x0, -24]
	add	x0, sp, 96
	add	x0, x0, x1
	cbz	x2, .L440
	mov	w1, 0
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.L419:
	mov	x1, x20
	add	x0, sp, 96
	mov	x2, 4
	bl	_ZNSi4readEPcl
	mov	x1, x21
	add	x0, sp, 96
	mov	x2, 4
	bl	_ZNSi4readEPcl
	ldr	x0, [x20]
	mov	x1, 2305843009213693950
	ldr	x2, [x21]
	mul	x0, x0, x2
	cmp	x0, x1
	bhi	.L420
	lsl	x0, x0, 2
	bl	_Znam
	ldr	x1, [x20]
	mov	x22, x0
	mov	x19, 0
	cbz	x1, .L424
	.p2align 3,,7
.L422:
	ldr	x2, [x21]
	add	x0, sp, 96
	lsl	x2, x2, 2
	madd	x1, x2, x19, x22
	bl	_ZNSi4readEPcl
	ldr	x0, [x20]
	add	x19, x19, 1
	cmp	x0, x19
	bhi	.L422
.L424:
	add	x0, sp, 112
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
	cbz	x0, .L441
.L425:
	adrp	x19, _ZSt4cerr
	add	x19, x19, :lo12:_ZSt4cerr
	adrp	x1, .LC6
	mov	x0, x19
	add	x1, x1, :lo12:.LC6
	mov	x2, 10
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldp	x1, x2, [x24]
	mov	x0, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	adrp	x24, .LC7
	add	x24, x24, :lo12:.LC7
	mov	x1, x24
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	adrp	x1, .LC8
	mov	x0, x19
	add	x1, x1, :lo12:.LC8
	mov	x2, 11
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x1, [x21]
	mov	x0, x19
	bl	_ZNSo9_M_insertImEERSoT_
	adrp	x1, .LC9
	mov	x19, x0
	add	x1, x1, :lo12:.LC9
	mov	x2, 9
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x1, [x20]
	mov	x0, x19
	bl	_ZNSo9_M_insertImEERSoT_
	adrp	x1, .LC10
	mov	x19, x0
	add	x1, x1, :lo12:.LC10
	mov	x2, 19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x0, x19
	mov	x1, 4
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x24
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.LEHE32:
	adrp	x1, _ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x0, sp, 112
	str	x27, [sp, 96]
	str	x1, [sp, 112]
	str	x26, [sp, 360]
.LEHB33:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
.LEHE33:
.L427:
	add	x0, sp, 224
	bl	_ZNSt12__basic_fileIcED1Ev
	adrp	x1, _ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x0, sp, 168
	str	x1, [sp, 112]
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x23, -24]
	add	x2, sp, 96
	str	x23, [sp, 96]
	add	x0, sp, 360
	str	x28, [x2, x1]
	str	xzr, [sp, 104]
	str	x25, [sp, 360]
	bl	_ZNSt8ios_baseD2Ev
	mov	x0, x22
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	add	sp, sp, 624
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L440:
	.cfi_restore_state
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
.LEHB34:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
	b	.L419
	.p2align 2,,3
.L441:
	ldr	x0, [sp, 96]
	add	x1, sp, 96
	ldr	x0, [x0, -24]
	add	x0, x1, x0
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE34:
	b	.L425
.L434:
	bl	__cxa_begin_catch
	bl	__cxa_end_catch
	b	.L427
.L433:
	mov	x19, x0
	add	x0, sp, 112
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEED1Ev
.L416:
	ldr	x0, [x23, -24]
	add	x1, sp, 96
	str	x23, [sp, 96]
	str	x28, [x1, x0]
	str	xzr, [sp, 104]
.L417:
	add	x0, sp, 360
	str	x25, [sp, 360]
	bl	_ZNSt8ios_baseD2Ev
	mov	x0, x19
.LEHB35:
	bl	_Unwind_Resume
.LEHE35:
.L432:
	mov	x19, x0
	b	.L416
.L420:
.LEHB36:
	bl	__cxa_throw_bad_array_new_length
.LEHE36:
.L431:
	mov	x19, x0
	b	.L417
.L430:
	mov	x19, x0
	add	x0, sp, 96
	bl	_ZNSt14basic_ifstreamIcSt11char_traitsIcEED1Ev
	mov	x0, x19
.LEHB37:
	bl	_Unwind_Resume
.LEHE37:
	.cfi_endproc
.LFE6729:
	.section	.gcc_except_table._Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,"aG",@progbits,_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,comdat
	.align	2
.LLSDA6729:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT6729-.LLSDATTD6729
.LLSDATTD6729:
	.byte	0x1
	.uleb128 .LLSDACSE6729-.LLSDACSB6729
.LLSDACSB6729:
	.uleb128 .LEHB29-.LFB6729
	.uleb128 .LEHE29-.LEHB29
	.uleb128 .L431-.LFB6729
	.uleb128 0
	.uleb128 .LEHB30-.LFB6729
	.uleb128 .LEHE30-.LEHB30
	.uleb128 .L432-.LFB6729
	.uleb128 0
	.uleb128 .LEHB31-.LFB6729
	.uleb128 .LEHE31-.LEHB31
	.uleb128 .L433-.LFB6729
	.uleb128 0
	.uleb128 .LEHB32-.LFB6729
	.uleb128 .LEHE32-.LEHB32
	.uleb128 .L430-.LFB6729
	.uleb128 0
	.uleb128 .LEHB33-.LFB6729
	.uleb128 .LEHE33-.LEHB33
	.uleb128 .L434-.LFB6729
	.uleb128 0x1
	.uleb128 .LEHB34-.LFB6729
	.uleb128 .LEHE34-.LEHB34
	.uleb128 .L430-.LFB6729
	.uleb128 0
	.uleb128 .LEHB35-.LFB6729
	.uleb128 .LEHE35-.LEHB35
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB36-.LFB6729
	.uleb128 .LEHE36-.LEHB36
	.uleb128 .L430-.LFB6729
	.uleb128 0
	.uleb128 .LEHB37-.LFB6729
	.uleb128 .LEHE37-.LEHB37
	.uleb128 0
	.uleb128 0
.LLSDACSE6729:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT6729:
	.section	.text._Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,"axG",@progbits,_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,comdat
	.size	_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_, .-_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
	.section	.text._ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb,"axG",@progbits,_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
	.type	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb, %function
_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb:
.LFB7543:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x21, x1
	ldr	x1, [x0, 40]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x20, x0
	ldr	x3, [x0, 72]
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -16
	.cfi_offset 24, -8
	and	w24, w2, 255
	sub	x22, x3, x1
	ldr	x0, [x0, 8]
	asr	x19, x22, 3
	add	x19, x19, 1
	add	x19, x19, x21
	cmp	x0, x19, lsl 1
	bls	.L443
	sub	x0, x0, x19
	cmp	w24, 0
	ldr	x19, [x20]
	lsr	x0, x0, 1
	add	x3, x3, 8
	lsl	x0, x0, 3
	sub	x2, x3, x1
	add	x21, x0, x21, lsl 3
	csel	x0, x21, x0, ne
	add	x19, x19, x0
	cmp	x1, x19
	bls	.L445
	cmp	x1, x3
	beq	.L446
	mov	x0, x19
	bl	memmove
	b	.L446
	.p2align 2,,3
.L443:
	cmp	x0, x21
	add	x23, x0, 2
	csel	x0, x0, x21, cs
	mov	x1, 1152921504606846975
	add	x23, x23, x0
	cmp	x23, x1
	bhi	.L455
	sub	x19, x23, x19
	lsl	x0, x23, 3
	bl	_Znwm
	lsr	x19, x19, 1
	cmp	w24, 0
	ldr	x3, [x20, 72]
	lsl	x19, x19, 3
	ldr	x1, [x20, 40]
	add	x21, x19, x21, lsl 3
	csel	x19, x21, x19, ne
	add	x3, x3, 8
	mov	x24, x0
	add	x19, x0, x19
	cmp	x1, x3
	beq	.L449
	sub	x2, x3, x1
	mov	x0, x19
	bl	memmove
.L449:
	ldp	x0, x1, [x20]
	lsl	x1, x1, 3
	bl	_ZdlPvm
	stp	x24, x23, [x20]
.L446:
	add	x2, x19, x22
	ldr	x0, [x19]
	ldp	x23, x24, [sp, 48]
	str	x0, [x20, 24]
	add	x0, x0, 512
	str	x0, [x20, 32]
	str	x19, [x20, 40]
	ldr	x0, [x19, x22]
	ldp	x21, x22, [sp, 32]
	str	x0, [x20, 56]
	add	x0, x0, 512
	str	x0, [x20, 64]
	str	x2, [x20, 72]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L445:
	.cfi_restore_state
	cmp	x1, x3
	beq	.L446
	add	x0, x22, 8
	sub	x0, x0, x2
	add	x0, x19, x0
	bl	memmove
	b	.L446
.L455:
	bl	_ZSt17__throw_bad_allocv
	.cfi_endproc
.LFE7543:
	.size	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb, .-_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
	.section	.rodata._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_.str1.8,"aMS",@progbits,1
	.align	3
.LC11:
	.string	"vector::_M_realloc_insert"
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB7552:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x23, x24, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	sub	x0, x24, x23
	str	x27, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L474
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x23
	csinc	x1, x0, xzr, ne
	adds	x1, x1, x0
	bcs	.L467
	cbnz	x1, .L461
	mov	x25, 8
	mov	x22, 0
	mov	x21, 0
.L466:
	ldr	x0, [x27]
	str	x0, [x21, x26]
	cmp	x19, x23
	beq	.L462
	mov	x4, x21
	mov	x3, x23
	.p2align 3,,7
.L463:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L463
	add	x26, x26, 8
	add	x25, x21, x26
.L462:
	cmp	x19, x24
	beq	.L464
	sub	x2, x24, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L464:
	cbz	x23, .L465
	ldr	x1, [x20, 16]
	mov	x0, x23
	sub	x1, x1, x23
	bl	_ZdlPvm
.L465:
	ldp	x23, x24, [sp, 48]
	ldr	x27, [sp, 80]
	stp	x21, x25, [x20]
	str	x22, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L467:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L460:
	mov	x0, x22
	bl	_Znwm
	mov	x21, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L466
.L461:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L460
.L474:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE7552:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.text
	.align	2
	.p2align 4,,11
	.global	_Z11flat_searchPfS_mmm
	.type	_Z11flat_searchPfS_mmm, %function
_Z11flat_searchPfS_mmm:
.LFB6223:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6223
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	mov	x22, x8
	stp	xzr, xzr, [x8]
	str	xzr, [x8, 16]
	cbz	x2, .L475
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -88
	.cfi_offset 19, -96
	mov	x21, x1
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -56
	.cfi_offset 23, -64
	lsl	x20, x3, 2
	mov	x24, x2
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -40
	.cfi_offset 25, -48
	mov	x23, 0
	mov	x25, x3
	str	d8, [sp, 80]
	.cfi_offset 72, -32
	mov	x26, x4
	mov	x1, 0
	mov	x0, 0
	fmov	s8, 1.0e+0
	cbz	x25, .L489
	.p2align 3,,7
.L499:
	movi	v0.2s, #0
	mov	x5, 0
	.p2align 3,,7
.L478:
	ldr	s2, [x19, x5]
	ldr	s1, [x21, x5]
	add	x5, x5, 4
	fmadd	s0, s2, s1, s0
	cmp	x20, x5
	bne	.L478
	sub	x2, x1, x0
	fsub	s0, s8, s0
	cmp	x26, x2, asr 3
	bhi	.L498
.L479:
	ldr	s1, [x0]
	fcmpe	s1, s0
	bgt	.L491
.L482:
	add	x23, x23, 1
	add	x19, x19, x20
	cmp	x24, x23
	beq	.L497
.L500:
	ldp	x0, x1, [x22]
	cbnz	x25, .L499
.L489:
	sub	x2, x1, x0
	fmov	s0, 1.0e+0
	cmp	x26, x2, asr 3
	bls	.L479
	.p2align 3,,7
.L498:
	ldr	x2, [x22, 16]
	str	s0, [sp, 104]
	str	w23, [sp, 108]
	cmp	x2, x1
	beq	.L480
	ldr	x2, [sp, 104]
	str	x2, [x1], 8
	str	x1, [x22, 8]
.L481:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	add	x23, x23, 1
	add	x19, x19, x20
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	cmp	x24, x23
	bne	.L500
.L497:
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldr	d8, [sp, 80]
	.cfi_restore 72
.L475:
	mov	x0, x22
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L491:
	.cfi_def_cfa_offset 112
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	.cfi_offset 72, -32
	ldr	x2, [x22, 16]
	str	s0, [sp, 104]
	str	w23, [sp, 108]
	cmp	x2, x1
	beq	.L484
	ldr	x2, [sp, 104]
	str	x2, [x1], 8
	str	x1, [x22, 8]
.L485:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x4, [x22]
	sub	x1, x4, x0
	cmp	x1, 8
	bgt	.L501
.L486:
	sub	x4, x4, #8
	str	x4, [x22, 8]
	b	.L482
.L501:
	ldr	x3, [x4, -8]
	sub	x2, x4, #8
	ldr	w1, [x0, 4]
	sub	x2, x2, x0
	ldr	s0, [x0]
	str	w1, [x4, -4]
	asr	x2, x2, 3
	mov	x1, 0
	str	s0, [x4, -8]
	bl	_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops15_Iter_comp_iterISt4lessIS3_EEEEvT_T0_SF_T1_T2_.isra.0
	ldr	x4, [x22, 8]
	b	.L486
.L480:
	add	x2, sp, 104
	mov	x0, x22
.LEHB38:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldp	x0, x1, [x22]
	b	.L481
.L484:
	add	x2, sp, 104
	mov	x0, x22
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE38:
	ldp	x0, x1, [x22]
	b	.L485
.L490:
	mov	x19, x0
	mov	x0, x22
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	mov	x0, x19
.LEHB39:
	bl	_Unwind_Resume
.LEHE39:
	.cfi_endproc
.LFE6223:
	.section	.gcc_except_table,"a",@progbits
.LLSDA6223:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE6223-.LLSDACSB6223
.LLSDACSB6223:
	.uleb128 .LEHB38-.LFB6223
	.uleb128 .LEHE38-.LEHB38
	.uleb128 .L490-.LFB6223
	.uleb128 0
	.uleb128 .LEHB39-.LFB6223
	.uleb128 .LEHE39-.LEHB39
	.uleb128 0
	.uleb128 0
.LLSDACSE6223:
	.text
	.size	_Z11flat_searchPfS_mmm, .-_Z11flat_searchPfS_mmm
	.section	.rodata.str1.8
	.align	3
.LC12:
	.string	"/anndata/"
	.align	3
.LC13:
	.string	"DEEP100K.query.fbin"
	.align	3
.LC14:
	.string	"DEEP100K.gt.query.100k.top100.bin"
	.align	3
.LC15:
	.string	"DEEP100K.base.100k.fbin"
	.align	3
.LC16:
	.string	"average recall: "
	.align	3
.LC17:
	.string	"average latency (us): "
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB6254:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6254
	stp	x29, x30, [sp, -336]!
	.cfi_def_cfa_offset 336
	.cfi_offset 29, -336
	.cfi_offset 30, -328
	adrp	x2, .LC12+9
	add	x2, x2, :lo12:.LC12+9
	add	x3, sp, 240
	mov	x29, sp
	add	x0, sp, 224
	adrp	x1, .LC12
	add	x1, x1, :lo12:.LC12
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	stp	d8, d9, [sp, 96]
	.cfi_offset 19, -320
	.cfi_offset 20, -312
	.cfi_offset 21, -304
	.cfi_offset 22, -296
	.cfi_offset 23, -288
	.cfi_offset 24, -280
	.cfi_offset 25, -272
	.cfi_offset 26, -264
	.cfi_offset 27, -256
	.cfi_offset 28, -248
	.cfi_offset 72, -240
	.cfi_offset 73, -232
	stp	xzr, xzr, [sp, 136]
	stp	xzr, xzr, [sp, 152]
	str	x3, [sp, 224]
.LEHB40:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag.isra.0
.LEHE40:
	adrp	x1, .LC13
	add	x0, sp, 224
	add	x8, sp, 288
	add	x1, x1, :lo12:.LC13
.LEHB41:
	bl	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
.LEHE41:
	add	x2, sp, 160
	add	x1, sp, 136
	add	x0, sp, 288
.LEHB42:
	bl	_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
.LEHE42:
	mov	x1, x0
	add	x0, sp, 288
	str	x1, [sp, 112]
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_disposeEv
	adrp	x1, .LC14
	add	x8, sp, 288
	add	x0, sp, 224
	add	x1, x1, :lo12:.LC14
.LEHB43:
	bl	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
.LEHE43:
	add	x1, sp, 136
	add	x2, sp, 152
	add	x0, sp, 288
.LEHB44:
	bl	_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
.LEHE44:
	mov	x26, x0
	add	x0, sp, 288
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_disposeEv
	adrp	x1, .LC15
	add	x8, sp, 288
	add	x0, sp, 224
	add	x1, x1, :lo12:.LC15
.LEHB45:
	bl	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
.LEHE45:
	add	x2, sp, 160
	add	x1, sp, 144
	add	x0, sp, 288
.LEHB46:
	bl	_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
.LEHE46:
	mov	x1, x0
	add	x0, sp, 288
	str	x1, [sp, 120]
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_disposeEv
	stp	xzr, xzr, [sp, 200]
	mov	x1, 2000
	mov	x0, 32000
	str	x1, [sp, 136]
	str	xzr, [sp, 216]
.LEHB47:
	bl	_Znwm
	mov	x20, x0
	mov	x0, 32000
	mov	x19, x20
	add	x0, x20, x0
.L504:
	cmp	x0, x19
	beq	.L503
	add	x19, x19, 16
	str	wzr, [x19, -16]
	str	xzr, [x19, -8]
	b	.L504
.L503:
	ldp	x21, x2, [sp, 200]
	ldr	x22, [sp, 216]
	sub	x2, x2, x21
	cmp	x2, 0
	bgt	.L581
	cbnz	x21, .L506
.L507:
	ldr	x0, [sp, 136]
	stp	x20, x19, [sp, 200]
	str	x19, [sp, 216]
	cbz	x0, .L510
	mov	x28, 16960
	mov	x23, 0
	movk	x28, 0xf, lsl 16
	mov	w21, 1
	.p2align 3,,7
.L508:
	mov	x1, 0
	add	x0, sp, 168
	bl	gettimeofday
	ldr	x3, [sp, 160]
	add	x8, sp, 256
	ldp	x5, x0, [sp, 112]
	mov	x4, 10
	ldr	x2, [sp, 144]
	mul	x1, x3, x23
	add	x1, x5, x1, lsl 2
	bl	_Z11flat_searchPfS_mmm
.LEHE47:
	mov	x1, 0
	add	x0, sp, 184
	bl	gettimeofday
	add	x24, sp, 296
	ldp	x27, x1, [sp, 184]
	mov	x22, 0
	ldr	x0, [sp, 168]
	mov	x25, 0
	str	wzr, [sp, 296]
	stp	xzr, x24, [sp, 304]
	msub	x0, x0, x28, x1
	ldr	x1, [sp, 176]
	madd	x27, x27, x28, x0
	stp	x24, xzr, [sp, 320]
	sub	x27, x27, x1
	.p2align 3,,7
.L512:
	ldr	x0, [sp, 152]
	madd	x0, x23, x0, x22
	ldr	w20, [x26, x0, lsl 2]
	cbz	x25, .L545
	mov	x19, x25
	b	.L516
	.p2align 2,,3
.L573:
	mov	x19, x0
.L516:
	ldp	x0, x2, [x19, 16]
	ldr	w1, [x19, 32]
	cmp	w20, w1
	csel	x0, x0, x2, cc
	csel	w2, w21, wzr, cc
	cbnz	x0, .L573
	cbnz	w2, .L515
.L579:
	bls	.L520
.L541:
	mov	w25, 1
	cmp	x19, x24
	bne	.L582
.L521:
	mov	x0, 40
.LEHB48:
	bl	_Znwm
.LEHE48:
	mov	x1, x0
	mov	x2, x19
	mov	w0, w25
	mov	x3, x24
	str	w20, [x1, 32]
	bl	_ZSt29_Rb_tree_insert_and_rebalancebPSt18_Rb_tree_node_baseS0_RS_
	ldr	x0, [sp, 328]
	ldr	x25, [sp, 304]
	add	x0, x0, 1
	str	x0, [sp, 328]
.L520:
	add	x22, x22, 1
	cmp	x22, 10
	bne	.L512
	ldp	x0, x6, [sp, 256]
	movi	v0.2s, #0
	add	x11, sp, 296
	mov	x12, 0
	cmp	x6, x0
	beq	.L514
	.p2align 3,,7
.L513:
	ldr	w5, [x0, 4]
	cbz	x25, .L523
	mov	x1, x25
	mov	x7, x11
	.p2align 3,,7
.L524:
	ldr	w2, [x1, 32]
	ldp	x4, x3, [x1, 16]
	cmp	w5, w2
	bls	.L549
	mov	x1, x3
.L526:
	cbnz	x1, .L524
	cmp	x7, x11
	beq	.L523
	ldr	w1, [x7, 32]
	cmp	w5, w1
	cinc	x12, x12, cs
.L523:
	sub	x1, x6, x0
	cmp	x1, 8
	bgt	.L583
.L528:
	sub	x6, x6, #8
	str	x6, [sp, 264]
	cmp	x0, x6
	bne	.L513
	ucvtf	s0, x12
	fmov	s1, 1.0e+1
	fdiv	s0, s0, s1
.L514:
	ldr	x1, [sp, 200]
	lsl	x0, x23, 4
	add	x2, x1, x0
	str	s0, [x1, x0]
	str	x27, [x2, 8]
	cbz	x25, .L532
.L529:
	ldr	x0, [x25, 24]
	bl	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0
	mov	x0, x25
	mov	x1, 40
	ldr	x25, [x25, 16]
	bl	_ZdlPvm
	cbnz	x25, .L529
.L532:
	ldr	x0, [sp, 256]
	cbz	x0, .L531
	ldr	x1, [sp, 272]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L531:
	ldr	x1, [sp, 136]
	add	x23, x23, 1
	cmp	x1, x23
	bhi	.L508
	cbz	x1, .L510
	movi	v8.2s, #0
	ldr	x0, [sp, 200]
	fmov	s9, s8
	add	x1, x0, x1, lsl 4
	.p2align 3,,7
.L534:
	ldr	x2, [x0, 8]
	add	x0, x0, 16
	ldr	s1, [x0, -16]
	scvtf	s0, x2
	fadd	s9, s9, s1
	fadd	s8, s8, s0
	cmp	x1, x0
	bne	.L534
.L509:
	adrp	x20, _ZSt4cout
	add	x20, x20, :lo12:_ZSt4cout
	adrp	x1, .LC16
	mov	x0, x20
	add	x1, x1, :lo12:.LC16
.LEHB49:
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	ldr	x1, [sp, 136]
	ucvtf	s0, x1
	fdiv	s0, s9, s0
	fcvt	d0, s0
	bl	_ZNSo9_M_insertIdEERSoT_
	adrp	x19, .LC7
	add	x19, x19, :lo12:.LC7
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC17
	mov	x0, x20
	add	x1, x1, :lo12:.LC17
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	ldr	x1, [sp, 136]
	ucvtf	s0, x1
	fdiv	s0, s8, s0
	fcvt	d0, s0
	bl	_ZNSo9_M_insertIdEERSoT_
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.LEHE49:
	add	x0, sp, 200
	bl	_ZNSt12_Vector_baseI12SearchResultSaIS0_EED2Ev
	add	x0, sp, 224
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_disposeEv
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	d8, d9, [sp, 96]
	ldp	x29, x30, [sp], 336
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_restore 73
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L545:
	.cfi_restore_state
	mov	x19, x24
.L515:
	ldr	x0, [sp, 312]
	cmp	x19, x0
	beq	.L541
	mov	x0, x19
	bl	_ZSt18_Rb_tree_decrementPSt18_Rb_tree_node_base
	ldr	w0, [x0, 32]
	cmp	w20, w0
	b	.L579
	.p2align 2,,3
.L549:
	mov	x7, x1
	mov	x1, x4
	b	.L526
	.p2align 2,,3
.L583:
	ldr	x3, [x6, -8]
	sub	x2, x6, #8
	ldr	s0, [x0]
	sub	x2, x2, x0
	str	w5, [x6, -4]
	mov	x1, 0
	asr	x2, x2, 3
	str	s0, [x6, -8]
	bl	_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops15_Iter_comp_iterISt4lessIS3_EEEEvT_T0_SF_T1_T2_.isra.0
	ldp	x0, x6, [sp, 256]
	ldr	x25, [sp, 304]
	b	.L528
	.p2align 2,,3
.L582:
	ldr	w0, [x19, 32]
	cmp	w20, w0
	cset	w25, cc
	b	.L521
.L510:
	movi	v8.2s, #0
	fmov	s9, s8
	b	.L509
.L581:
	mov	x1, x21
	mov	x0, x20
	bl	memmove
.L506:
	sub	x1, x22, x21
	mov	x0, x21
	bl	_ZdlPvm
	b	.L507
.L555:
	mov	x19, x0
	ldr	x0, [sp, 304]
	bl	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0
	add	x0, sp, 256
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
.L540:
	add	x0, sp, 200
	bl	_ZNSt12_Vector_baseI12SearchResultSaIS0_EED2Ev
.L536:
	add	x0, sp, 224
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_disposeEv
	mov	x0, x19
.LEHB50:
	bl	_Unwind_Resume
.LEHE50:
.L554:
	mov	x19, x0
	b	.L540
.L553:
.L580:
	mov	x19, x0
	add	x0, sp, 288
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_disposeEv
	b	.L536
.L552:
	b	.L580
.L551:
	b	.L580
.L550:
	mov	x19, x0
	b	.L536
	.cfi_endproc
.LFE6254:
	.section	.gcc_except_table
.LLSDA6254:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE6254-.LLSDACSB6254
.LLSDACSB6254:
	.uleb128 .LEHB40-.LFB6254
	.uleb128 .LEHE40-.LEHB40
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB41-.LFB6254
	.uleb128 .LEHE41-.LEHB41
	.uleb128 .L550-.LFB6254
	.uleb128 0
	.uleb128 .LEHB42-.LFB6254
	.uleb128 .LEHE42-.LEHB42
	.uleb128 .L551-.LFB6254
	.uleb128 0
	.uleb128 .LEHB43-.LFB6254
	.uleb128 .LEHE43-.LEHB43
	.uleb128 .L550-.LFB6254
	.uleb128 0
	.uleb128 .LEHB44-.LFB6254
	.uleb128 .LEHE44-.LEHB44
	.uleb128 .L552-.LFB6254
	.uleb128 0
	.uleb128 .LEHB45-.LFB6254
	.uleb128 .LEHE45-.LEHB45
	.uleb128 .L550-.LFB6254
	.uleb128 0
	.uleb128 .LEHB46-.LFB6254
	.uleb128 .LEHE46-.LEHB46
	.uleb128 .L553-.LFB6254
	.uleb128 0
	.uleb128 .LEHB47-.LFB6254
	.uleb128 .LEHE47-.LEHB47
	.uleb128 .L554-.LFB6254
	.uleb128 0
	.uleb128 .LEHB48-.LFB6254
	.uleb128 .LEHE48-.LEHB48
	.uleb128 .L555-.LFB6254
	.uleb128 0
	.uleb128 .LEHB49-.LFB6254
	.uleb128 .LEHE49-.LEHB49
	.uleb128 .L554-.LFB6254
	.uleb128 0
	.uleb128 .LEHB50-.LFB6254
	.uleb128 .LEHE50-.LEHB50
	.uleb128 0
	.uleb128 0
.LLSDACSE6254:
	.section	.text.startup
	.size	main, .-main
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj,"axG",@progbits,_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj
	.type	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj, %function
_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj:
.LFB7646:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	ldr	w8, [x2]
	ldr	x1, [x0, 8]
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	uxtw	x0, w8
	udiv	x3, x0, x1
	ldr	x9, [x19]
	msub	x3, x3, x1, x0
	ldr	x6, [x9, x3, lsl 3]
	cbz	x6, .L595
	ldr	x2, [x6]
	mov	x5, x6
	ldr	w0, [x2, 8]
.L587:
	cmp	w8, w0
	beq	.L586
	ldr	x0, [x2]
	mov	x5, x2
	mov	x2, x0
	cbz	x0, .L595
	ldr	w0, [x0, 8]
	uxtw	x7, w0
	udiv	x4, x7, x1
	msub	x4, x4, x1, x7
	cmp	x3, x4
	beq	.L587
.L595:
	mov	x0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L586:
	.cfi_restore_state
	ldr	x0, [x5]
	ldr	x2, [x0]
	cmp	x6, x5
	beq	.L602
	cbz	x2, .L589
	ldr	w6, [x2, 8]
	udiv	x4, x6, x1
	msub	x1, x4, x1, x6
	cmp	x3, x1
	beq	.L589
	str	x5, [x9, x1, lsl 3]
	ldr	x2, [x0]
.L589:
	str	x2, [x5]
	mov	x1, 16
	bl	_ZdlPvm
	ldr	x1, [x19, 24]
	mov	x0, 1
	sub	x1, x1, #1
	str	x1, [x19, 24]
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L602:
	.cfi_restore_state
	cbz	x2, .L596
	ldr	w6, [x2, 8]
	udiv	x4, x6, x1
	msub	x1, x4, x1, x6
	cmp	x3, x1
	beq	.L589
	str	x5, [x9, x1, lsl 3]
	ldr	x1, [x9, x3, lsl 3]
.L588:
	add	x4, x19, 16
	cmp	x1, x4
	beq	.L603
.L590:
	str	xzr, [x9, x3, lsl 3]
	ldr	x2, [x0]
	b	.L589
	.p2align 2,,3
.L596:
	mov	x1, x5
	b	.L588
	.p2align 2,,3
.L603:
	str	x2, [x19, 16]
	b	.L590
	.cfi_endproc
.LFE7646:
	.size	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj, .-_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj
	.section	.text._ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_,"axG",@progbits,_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_
	.type	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_, %function
_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_:
.LFB7647:
	.cfi_startproc
	ldr	x5, [x2]
	ldr	x2, [x0, 8]
	ldr	x8, [x0]
	udiv	x4, x5, x2
	msub	x4, x4, x2, x5
	ldr	x7, [x8, x4, lsl 3]
	cbz	x7, .L613
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x6, x7
	mov	x29, sp
	ldr	x3, [x7]
	ldr	x1, [x3, 8]
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
.L607:
	cmp	x5, x1
	beq	.L606
	ldr	x0, [x3]
	mov	x6, x3
	mov	x3, x0
	cbz	x0, .L615
	ldr	x1, [x0, 8]
	udiv	x0, x1, x2
	msub	x0, x0, x2, x1
	cmp	x4, x0
	beq	.L607
.L615:
	mov	x0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L606:
	.cfi_restore_state
	ldr	x0, [x6]
	ldr	x1, [x0]
	cmp	x7, x6
	beq	.L625
	cbz	x1, .L609
	ldr	x5, [x1, 8]
	udiv	x3, x5, x2
	msub	x2, x3, x2, x5
	cmp	x4, x2
	beq	.L609
	str	x6, [x8, x2, lsl 3]
	ldr	x1, [x0]
.L609:
	str	x1, [x6]
	mov	x1, 24
	bl	_ZdlPvm
	ldr	x1, [x19, 24]
	mov	x0, 1
	sub	x1, x1, #1
	str	x1, [x19, 24]
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L625:
	.cfi_restore_state
	cbz	x1, .L616
	ldr	x5, [x1, 8]
	udiv	x3, x5, x2
	msub	x2, x3, x2, x5
	cmp	x4, x2
	beq	.L609
	str	x6, [x8, x2, lsl 3]
	ldr	x2, [x8, x4, lsl 3]
.L608:
	add	x3, x19, 16
	cmp	x2, x3
	beq	.L626
.L610:
	str	xzr, [x8, x4, lsl 3]
	ldr	x1, [x0]
	b	.L609
	.p2align 2,,3
.L616:
	mov	x2, x6
	b	.L608
	.p2align 2,,3
.L613:
	.cfi_def_cfa_offset 0
	.cfi_restore 19
	.cfi_restore 29
	.cfi_restore 30
	mov	x0, 0
	ret
	.p2align 2,,3
.L626:
	.cfi_def_cfa_offset 32
	.cfi_offset 19, -16
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	str	x1, [x19, 16]
	b	.L610
	.cfi_endproc
.LFE7647:
	.size	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_, .-_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB7839:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x23, x24, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	sub	x0, x24, x23
	stp	x27, x28, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L645
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x23
	csinc	x1, x0, xzr, ne
	mov	x28, x3
	adds	x1, x1, x0
	bcs	.L638
	cbnz	x1, .L632
	mov	x25, 8
	mov	x22, 0
	mov	x21, 0
.L637:
	ldr	s0, [x27]
	add	x0, x21, x26
	ldr	w1, [x28]
	str	s0, [x21, x26]
	str	w1, [x0, 4]
	cmp	x19, x23
	beq	.L633
	mov	x4, x21
	mov	x3, x23
	.p2align 3,,7
.L634:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L634
	add	x26, x26, 8
	add	x25, x21, x26
.L633:
	cmp	x19, x24
	beq	.L635
	sub	x2, x24, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L635:
	cbz	x23, .L636
	ldr	x1, [x20, 16]
	mov	x0, x23
	sub	x1, x1, x23
	bl	_ZdlPvm
.L636:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	stp	x21, x25, [x20]
	str	x22, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L638:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L631:
	mov	x0, x22
	bl	_Znwm
	mov	x21, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L637
.L632:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L631
.L645:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE7839:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.text._ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_,"axG",@progbits,_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_
	.type	_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_, %function
_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_:
.LFB7852:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	ldp	x25, x21, [x0]
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	mov	x24, x1
	mov	x1, 2305843009213693951
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	sub	x3, x21, x25
	asr	x3, x3, 2
	cmp	x3, x1
	beq	.L665
	cmp	x3, 0
	mov	x20, x0
	csinc	x0, x3, xzr, ne
	mov	x27, x2
	sub	x26, x24, x25
	adds	x3, x3, x0
	bcs	.L659
	cbnz	x3, .L651
	mov	x19, 0
	mov	x23, 0
.L657:
	ldr	w0, [x27]
	add	x22, x26, 4
	sub	x21, x21, x24
	add	x22, x23, x22
	str	w0, [x23, x26]
	add	x27, x22, x21
	ldr	x28, [x20, 16]
	cmp	x26, 0
	bgt	.L666
	cmp	x21, 0
	bgt	.L655
	cbnz	x25, .L667
.L656:
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	stp	x23, x27, [x20]
	str	x19, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L667:
	.cfi_restore_state
	sub	x1, x28, x25
.L658:
	mov	x0, x25
	bl	_ZdlPvm
	b	.L656
	.p2align 2,,3
.L666:
	mov	x1, x25
	mov	x2, x26
	mov	x0, x23
	bl	memmove
	sub	x1, x28, x25
	cmp	x21, 0
	ble	.L658
.L655:
	mov	x2, x21
	mov	x1, x24
	mov	x0, x22
	bl	memcpy
	cbz	x25, .L656
	b	.L667
	.p2align 2,,3
.L659:
	mov	x19, 9223372036854775804
.L650:
	mov	x0, x19
	bl	_Znwm
	mov	x23, x0
	add	x19, x0, x19
	b	.L657
	.p2align 2,,3
.L651:
	cmp	x3, x1
	csel	x3, x3, x1, ls
	lsl	x19, x3, 2
	b	.L650
.L665:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE7852:
	.size	_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_, .-_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_
	.section	.text._ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_,"axG",@progbits,_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_
	.type	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_, %function
_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_:
.LFB7878:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA7878
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x1
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -16
	.cfi_offset 22, -8
	mov	x21, x0
	cmp	x1, 1
	beq	.L690
	mov	x20, x2
	mov	x0, 1152921504606846975
	cmp	x1, x0
	bhi	.L691
	lsl	x22, x1, 3
	mov	x0, x22
.LEHB51:
	bl	_Znwm
	mov	x20, x0
	mov	x2, x22
	mov	w1, 0
	bl	memset
	add	x8, x21, 48
.L670:
	ldr	x4, [x21, 16]
	str	xzr, [x21, 16]
	cbz	x4, .L672
	add	x7, x21, 16
	mov	x6, 0
	.p2align 3,,7
.L673:
	ldr	x5, [x4, 8]
	mov	x3, x4
	ldr	x4, [x4]
	udiv	x2, x5, x19
	msub	x2, x2, x19, x5
	ldr	x1, [x20, x2, lsl 3]
	cbz	x1, .L692
	ldr	x0, [x1]
	str	x0, [x3]
	ldr	x0, [x20, x2, lsl 3]
	str	x3, [x0]
	cbnz	x4, .L673
.L672:
	ldp	x0, x1, [x21]
	cmp	x8, x0
	beq	.L676
	lsl	x1, x1, 3
	bl	_ZdlPvm
.L676:
	stp	x20, x19, [x21]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L692:
	.cfi_restore_state
	ldr	x0, [x21, 16]
	str	x0, [x3]
	str	x3, [x21, 16]
	str	x7, [x20, x2, lsl 3]
	ldr	x0, [x3]
	cbz	x0, .L679
	str	x3, [x20, x6, lsl 3]
	mov	x6, x2
	cbnz	x4, .L673
	b	.L672
	.p2align 2,,3
.L679:
	mov	x6, x2
	cbnz	x4, .L673
	b	.L672
	.p2align 2,,3
.L690:
	mov	x20, x0
	str	xzr, [x20, 48]!
	mov	x8, x20
	b	.L670
.L691:
	bl	_ZSt17__throw_bad_allocv
.LEHE51:
.L680:
	bl	__cxa_begin_catch
	ldr	x0, [x20]
	str	x0, [x21, 40]
.LEHB52:
	bl	__cxa_rethrow
.LEHE52:
.L681:
	mov	x19, x0
	bl	__cxa_end_catch
	mov	x0, x19
.LEHB53:
	bl	_Unwind_Resume
.LEHE53:
	.cfi_endproc
.LFE7878:
	.section	.gcc_except_table
	.align	2
.LLSDA7878:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT7878-.LLSDATTD7878
.LLSDATTD7878:
	.byte	0x1
	.uleb128 .LLSDACSE7878-.LLSDACSB7878
.LLSDACSB7878:
	.uleb128 .LEHB51-.LFB7878
	.uleb128 .LEHE51-.LEHB51
	.uleb128 .L680-.LFB7878
	.uleb128 0x1
	.uleb128 .LEHB52-.LFB7878
	.uleb128 .LEHE52-.LEHB52
	.uleb128 .L681-.LFB7878
	.uleb128 0
	.uleb128 .LEHB53-.LFB7878
	.uleb128 .LEHE53-.LEHB53
	.uleb128 0
	.uleb128 0
.LLSDACSE7878:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT7878:
	.section	.text._ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_,"axG",@progbits,_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_,comdat
	.size	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_, .-_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_
	.section	.text._ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_,"axG",@progbits,_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_
	.type	_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_, %function
_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_:
.LFB7356:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA7356
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	ldr	x21, [x1]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	mov	x19, x0
	ldr	x5, [x0, 8]
	ldr	x0, [x0]
	udiv	x2, x21, x5
	msub	x2, x2, x5, x21
	lsl	x22, x2, 3
	ldr	x6, [x0, x2, lsl 3]
	str	x23, [sp, 48]
	.cfi_offset 23, -32
	mov	x23, x1
	cbz	x6, .L694
	ldr	x3, [x6]
	ldr	x0, [x3, 8]
	cmp	x21, x0
	beq	.L695
.L718:
	ldr	x4, [x3]
	cbz	x4, .L694
	ldr	x0, [x4, 8]
	mov	x6, x3
	udiv	x3, x0, x5
	msub	x3, x3, x5, x0
	cmp	x2, x3
	bne	.L694
	mov	x3, x4
	cmp	x21, x0
	bne	.L718
.L695:
	ldr	x1, [x6]
	add	x0, x1, 16
	cbz	x1, .L694
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L694:
	.cfi_restore_state
	mov	x0, 24
.LEHB54:
	bl	_Znwm
.LEHE54:
	ldr	x4, [x23]
	mov	x20, x0
	ldr	x1, [x19, 8]
	add	x0, x19, 32
	ldr	x2, [x19, 24]
	mov	x3, 1
	ldr	x5, [x19, 40]
	stp	xzr, x4, [x20]
	str	wzr, [x20, 16]
	str	x5, [sp, 72]
.LEHB55:
	bl	_ZNKSt8__detail20_Prime_rehash_policy14_M_need_rehashEmmm
	tst	w0, 255
	bne	.L719
	ldr	x0, [x19]
	add	x2, x0, x22
	ldr	x1, [x0, x22]
	cbz	x1, .L699
.L720:
	ldr	x1, [x1]
	str	x1, [x20]
	ldr	x0, [x0, x22]
	str	x20, [x0]
.L700:
	ldr	x1, [x19, 24]
	add	x0, x20, 16
	ldp	x21, x22, [sp, 32]
	add	x1, x1, 1
	str	x1, [x19, 24]
	ldp	x19, x20, [sp, 16]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L719:
	.cfi_restore_state
	add	x2, sp, 72
	mov	x0, x19
	bl	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_
.LEHE55:
	ldr	x0, [x19, 8]
	udiv	x22, x21, x0
	msub	x22, x22, x0, x21
	ldr	x0, [x19]
	lsl	x22, x22, 3
	add	x2, x0, x22
	ldr	x1, [x0, x22]
	cbnz	x1, .L720
.L699:
	ldr	x1, [x19, 16]
	str	x1, [x20]
	str	x20, [x19, 16]
	cbz	x1, .L701
	ldr	x4, [x1, 8]
	ldr	x3, [x19, 8]
	udiv	x1, x4, x3
	msub	x1, x1, x3, x4
	str	x20, [x0, x1, lsl 3]
.L701:
	add	x0, x19, 16
	str	x0, [x2]
	b	.L700
.L704:
	mov	x1, 24
	mov	x19, x0
	mov	x0, x20
	bl	_ZdlPvm
	mov	x0, x19
.LEHB56:
	bl	_Unwind_Resume
.LEHE56:
	.cfi_endproc
.LFE7356:
	.section	.gcc_except_table
.LLSDA7356:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7356-.LLSDACSB7356
.LLSDACSB7356:
	.uleb128 .LEHB54-.LFB7356
	.uleb128 .LEHE54-.LEHB54
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB55-.LFB7356
	.uleb128 .LEHE55-.LEHB55
	.uleb128 .L704-.LFB7356
	.uleb128 0
	.uleb128 .LEHB56-.LFB7356
	.uleb128 .LEHE56-.LEHB56
	.uleb128 0
	.uleb128 0
.LLSDACSE7356:
	.section	.text._ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_,"axG",@progbits,_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_,comdat
	.size	_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_, .-_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB7915:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x23, x24, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	sub	x0, x24, x23
	stp	x27, x28, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L739
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x23
	csinc	x1, x0, xzr, ne
	mov	x28, x3
	adds	x1, x1, x0
	bcs	.L732
	cbnz	x1, .L726
	mov	x25, 8
	mov	x22, 0
	mov	x21, 0
.L731:
	ldr	s0, [x27]
	add	x0, x21, x26
	ldr	w1, [x28]
	str	s0, [x21, x26]
	str	w1, [x0, 4]
	cmp	x19, x23
	beq	.L727
	mov	x4, x21
	mov	x3, x23
	.p2align 3,,7
.L728:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L728
	add	x26, x26, 8
	add	x25, x21, x26
.L727:
	cmp	x19, x24
	beq	.L729
	sub	x2, x24, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L729:
	cbz	x23, .L730
	ldr	x1, [x20, 16]
	mov	x0, x23
	sub	x1, x1, x23
	bl	_ZdlPvm
.L730:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	stp	x21, x25, [x20]
	str	x22, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L732:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L725:
	mov	x0, x22
	bl	_Znwm
	mov	x21, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L731
.L726:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L725
.L739:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE7915:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB7921:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x23, x24, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	sub	x0, x24, x23
	str	x27, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L758
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x23
	csinc	x1, x0, xzr, ne
	adds	x1, x1, x0
	bcs	.L751
	cbnz	x1, .L745
	mov	x25, 8
	mov	x22, 0
	mov	x21, 0
.L750:
	ldr	x0, [x27]
	str	x0, [x21, x26]
	cmp	x19, x23
	beq	.L746
	mov	x4, x21
	mov	x3, x23
	.p2align 3,,7
.L747:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L747
	add	x26, x26, 8
	add	x25, x21, x26
.L746:
	cmp	x19, x24
	beq	.L748
	sub	x2, x24, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L748:
	cbz	x23, .L749
	ldr	x1, [x20, 16]
	mov	x0, x23
	sub	x1, x1, x23
	bl	_ZdlPvm
.L749:
	ldp	x23, x24, [sp, 48]
	ldr	x27, [sp, 80]
	stp	x21, x25, [x20]
	str	x22, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L751:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L744:
	mov	x0, x22
	bl	_Znwm
	mov	x21, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L750
.L745:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L744
.L758:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE7921:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm
	.type	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm, %function
_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm:
.LFB7396:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA7396
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	ldp	x23, x0, [x1]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	mov	x21, x1
	sub	x1, x0, x23
	cmp	x2, x1, asr 3
	bhi	.L759
	stp	xzr, xzr, [sp, 152]
	mov	x24, 0
	mov	x1, 0
	stp	xzr, xzr, [sp, 168]
	mov	x22, 0
	stp	xzr, xzr, [sp, 184]
	cmp	x23, x0
	beq	.L762
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -136
	.cfi_offset 25, -144
	mov	x25, x2
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -120
	.cfi_offset 27, -128
	mov	x27, 1152921504606846975
	mov	x28, 1
	str	d8, [sp, 96]
	.cfi_offset 72, -112
	b	.L761
	.p2align 2,,3
.L825:
	ldr	w0, [x23, 4]
	add	x20, x22, 8
	str	s8, [x22]
	str	w0, [x22, 4]
	str	x20, [sp, 184]
.L766:
	sub	x1, x20, x24
	mov	x2, 0
	ldr	x3, [x20, -8]
	asr	x1, x1, 3
	sub	x1, x1, #1
	mov	x0, x24
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	mov	x0, x21
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x23, x0, [x21]
	cmp	x23, x0
	beq	.L775
	ldp	x24, x22, [sp, 176]
	ldr	x1, [sp, 192]
.L761:
	ldr	s8, [x23]
	fneg	s8, s8
	cmp	x22, x1
	bne	.L825
	sub	x26, x22, x24
	asr	x2, x26, 3
	cmp	x2, x27
	beq	.L826
	cmp	x2, 0
	csel	x0, x2, x28, ne
	adds	x0, x0, x2
	bcs	.L769
	cbnz	x0, .L827
	mov	x20, 8
	mov	x7, 0
	mov	x6, 0
.L771:
	add	x5, x6, x26
	ldr	w0, [x23, 4]
	str	s8, [x6, x26]
	str	w0, [x5, 4]
	cmp	x22, x24
	beq	.L772
	mov	x2, x6
	mov	x3, x24
	.p2align 3,,7
.L773:
	ldr	x4, [x3], 8
	str	x4, [x2], 8
	cmp	x2, x5
	bne	.L773
	add	x20, x2, 8
.L772:
	cbz	x24, .L774
	sub	x1, x1, x24
	mov	x0, x24
	stp	x6, x7, [sp, 112]
	bl	_ZdlPvm
	ldp	x6, x7, [sp, 112]
.L774:
	mov	x24, x6
	stp	x6, x20, [sp, 176]
	str	x7, [sp, 192]
	b	.L766
	.p2align 2,,3
.L775:
	ldp	x0, x4, [sp, 176]
	ldr	x22, [sp, 160]
	cmp	x4, x0
	beq	.L824
	.p2align 3,,7
.L763:
	ldr	x23, [sp, 152]
	sub	x1, x22, x23
	cmp	x25, x1, asr 3
	bls	.L764
	ldr	x1, [x0]
	str	x1, [sp, 144]
	sub	x1, x4, x0
	ldr	s8, [sp, 144]
	fneg	s8, s8
	cmp	x1, 8
	bgt	.L828
.L777:
	sub	x4, x4, #8
	str	x4, [sp, 184]
	cmp	x22, x23
	beq	.L778
	.p2align 3,,7
.L782:
	ldr	w0, [x23, 4]
	add	x20, sp, 152
	ldr	w1, [sp, 148]
	ldr	x5, [x19, 24]
	ldr	x4, [x19, 232]
	ldp	x6, x2, [x19, 304]
	ldr	x3, [x19, 256]
	madd	x1, x1, x5, x4
	madd	x0, x0, x5, x4
	add	x1, x3, x1
	add	x0, x3, x0
.LEHB57:
	blr	x6
	fcmpe	s8, s0
	bgt	.L823
	add	x23, x23, 8
	cmp	x23, x22
	bne	.L782
	ldr	x23, [sp, 160]
.L778:
	ldr	x0, [sp, 168]
	cmp	x0, x23
	beq	.L829
	mov	x22, x23
	ldr	x0, [sp, 144]
	str	x0, [x22], 8
	str	x22, [sp, 160]
.L781:
	ldp	x0, x4, [sp, 176]
	cmp	x4, x0
	bne	.L763
.L824:
	ldr	x23, [sp, 152]
.L764:
	cmp	x22, x23
	beq	.L783
	ldr	x1, [x21, 8]
	.p2align 3,,7
.L790:
	ldr	x0, [x23]
	str	x0, [sp, 144]
	ldr	x0, [x21, 16]
	ldr	s1, [sp, 144]
	fneg	s1, s1
	str	s1, [sp, 140]
	cmp	x0, x1
	beq	.L784
	ldr	w8, [sp, 148]
	add	x1, x1, 8
	str	s1, [x1, -8]
	str	w8, [x1, -4]
	str	x1, [x21, 8]
.L785:
	ldr	x4, [x21]
	sub	x3, x1, x4
	asr	x0, x3, 3
	sub	x2, x0, #2
	sub	x0, x0, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x0, 0
	ble	.L786
	.p2align 3,,7
.L789:
	lsl	x3, x2, 3
	lsl	x0, x0, 3
	add	x6, x4, x3
	add	x5, x4, x0
	ldr	s0, [x4, x3]
	fcmpe	s0, s1
	bmi	.L801
	add	x23, x23, 8
	str	s1, [x5]
	str	w8, [x5, 4]
	cmp	x22, x23
	bne	.L790
.L830:
	ldr	x23, [sp, 152]
.L783:
	cbz	x23, .L822
	ldr	x1, [sp, 168]
	mov	x0, x23
	sub	x1, x1, x23
	bl	_ZdlPvm
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldr	d8, [sp, 96]
	.cfi_restore 72
.L762:
	ldr	x0, [sp, 176]
	cbz	x0, .L759
.L831:
	ldr	x1, [sp, 192]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L759:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 208
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L829:
	.cfi_def_cfa_offset 208
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	.cfi_offset 72, -112
	add	x20, sp, 152
	mov	x1, x23
	add	x2, sp, 144
	mov	x0, x20
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.p2align 3,,7
.L823:
	ldr	x22, [sp, 160]
	b	.L781
	.p2align 2,,3
.L828:
	ldr	x3, [x4, -8]
	sub	x2, x4, #8
	ldr	w1, [x0, 4]
	sub	x2, x2, x0
	ldr	s0, [x0]
	str	w1, [x4, -4]
	asr	x2, x2, 3
	mov	x1, 0
	str	s0, [x4, -8]
	bl	_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops15_Iter_comp_iterISt4lessIS3_EEEEvT_T0_SF_T1_T2_.isra.0
	ldp	x23, x22, [sp, 152]
	ldr	x4, [sp, 184]
	b	.L777
	.p2align 2,,3
.L801:
	sub	x3, x2, #1
	ldr	w7, [x6, 4]
	str	s0, [x4, x0]
	mov	x0, x2
	add	x3, x3, x3, lsr 63
	str	w7, [x5, 4]
	asr	x2, x3, 1
	cmp	x0, 0
	bgt	.L789
	mov	x5, x6
	add	x23, x23, 8
	str	s1, [x5]
	str	w8, [x5, 4]
	cmp	x22, x23
	bne	.L790
	b	.L830
	.p2align 2,,3
.L784:
	add	x20, sp, 152
	add	x3, sp, 148
	add	x2, sp, 140
	mov	x0, x21
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x1, [x21, 8]
	ldr	w8, [x1, -4]
	ldr	s1, [x1, -8]
	b	.L785
.L822:
	ldr	x0, [sp, 176]
	ldp	x25, x26, [sp, 64]
	.cfi_remember_state
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldr	d8, [sp, 96]
	.cfi_restore 72
	cbnz	x0, .L831
	b	.L759
.L786:
	.cfi_restore_state
	sub	x3, x3, #8
	add	x23, x23, 8
	add	x5, x4, x3
	str	s1, [x5]
	str	w8, [x5, 4]
	cmp	x22, x23
	bne	.L790
	b	.L830
.L827:
	cmp	x0, x27
	csel	x0, x0, x27, ls
	lsl	x0, x0, 3
	str	x0, [sp, 112]
.L770:
	ldr	x0, [sp, 112]
	add	x20, sp, 152
	bl	_Znwm
	mov	x6, x0
	add	x20, x0, 8
	ldr	x0, [sp, 112]
	ldr	x1, [sp, 192]
	add	x7, x6, x0
	b	.L771
.L769:
	mov	x0, 9223372036854775800
	str	x0, [sp, 112]
	b	.L770
.L826:
	adrp	x0, .LC11
	add	x20, sp, 152
	add	x0, x0, :lo12:.LC11
	bl	_ZSt20__throw_length_errorPKc
.LEHE57:
.L799:
	mov	x19, x0
	mov	x0, x20
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	add	x0, sp, 176
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	mov	x0, x19
.LEHB58:
	bl	_Unwind_Resume
.LEHE58:
	.cfi_endproc
.LFE7396:
	.section	.gcc_except_table
.LLSDA7396:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7396-.LLSDACSB7396
.LLSDACSB7396:
	.uleb128 .LEHB57-.LFB7396
	.uleb128 .LEHE57-.LEHB57
	.uleb128 .L799-.LFB7396
	.uleb128 0
	.uleb128 .LEHB58-.LFB7396
	.uleb128 .LEHE58-.LEHB58
	.uleb128 0
	.uleb128 0
.LLSDACSE7396:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm, .-_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB8010:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x23, x24, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	sub	x0, x24, x23
	stp	x27, x28, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L850
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x23
	csinc	x1, x0, xzr, ne
	mov	x28, x3
	adds	x1, x1, x0
	bcs	.L843
	cbnz	x1, .L837
	mov	x25, 8
	mov	x22, 0
	mov	x21, 0
.L842:
	ldr	s0, [x27]
	add	x0, x21, x26
	ldr	w1, [x28]
	str	s0, [x21, x26]
	str	w1, [x0, 4]
	cmp	x19, x23
	beq	.L838
	mov	x4, x21
	mov	x3, x23
	.p2align 3,,7
.L839:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L839
	add	x26, x26, 8
	add	x25, x21, x26
.L838:
	cmp	x19, x24
	beq	.L840
	sub	x2, x24, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L840:
	cbz	x23, .L841
	ldr	x1, [x20, 16]
	mov	x0, x23
	sub	x1, x1, x23
	bl	_ZdlPvm
.L841:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	stp	x21, x25, [x20]
	str	x22, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L843:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L836:
	mov	x0, x22
	bl	_Znwm
	mov	x21, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L842
.L837:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L836
.L850:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE8010:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.rodata.str1.8
	.align	3
.LC18:
	.string	"Should be not be more than M_ candidates returned by the heuristic"
	.align	3
.LC19:
	.string	"vector::reserve"
	.align	3
.LC20:
	.string	"The newly inserted element should have blank link list"
	.align	3
.LC21:
	.string	"Possible memory corruption"
	.align	3
.LC22:
	.string	"Trying to make a link on a non-existent level"
	.align	3
.LC23:
	.string	"Bad value of sz_link_list_other"
	.align	3
.LC24:
	.string	"Trying to connect an element to itself"
	.text
	.align	2
	.p2align 4,,11
	.type	_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0, %function
_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0:
.LFB8602:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8602
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	cmp	w3, 0
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	mov	x21, x2
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	mov	w26, w3
	ldp	x2, x3, [x0, 48]
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	and	w28, w4, 255
	ldr	x27, [x0, 64]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	mov	x19, x0
	csel	x27, x27, x3, eq
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	str	w1, [sp, 124]
	mov	x1, x21
.LEHB59:
	bl	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm
.LEHE59:
	ldp	x2, x1, [x21]
	ldr	x0, [x19, 48]
	sub	x3, x1, x2
	cmp	x0, x3, asr 3
	bcc	.L998
	stp	xzr, xzr, [sp, 152]
	mov	x3, 2305843009213693951
	str	xzr, [sp, 168]
	cmp	x0, x3
	bhi	.L999
	cbnz	x0, .L1000
	mov	x20, 0
.L855:
	cmp	x2, x1
	bne	.L863
	b	.L859
	.p2align 2,,3
.L1001:
	ldr	w0, [x2, 4]
	str	w0, [x20], 4
	mov	x0, x21
	str	x20, [sp, 160]
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x2, x0, [x21]
	ldr	x20, [sp, 160]
	cmp	x0, x2
	beq	.L859
.L863:
	ldr	x0, [sp, 168]
	cmp	x0, x20
	bne	.L1001
	mov	x1, x20
	add	x20, sp, 152
	add	x2, x2, 4
	mov	x0, x20
.LEHB60:
	bl	_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_
	mov	x0, x21
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x2, x0, [x21]
	ldr	x20, [sp, 160]
	cmp	x0, x2
	bne	.L863
.L859:
	ldr	w0, [sp, 124]
	mov	w3, 48
	ldr	x2, [x19, 192]
	uxtw	x1, w0
	ldr	w4, [x20, -4]
	str	w4, [sp, 120]
	umaddl	x0, w0, w3, x2
	strb	wzr, [sp, 184]
	str	x0, [sp, 176]
	cbnz	w28, .L1002
	cbnz	w26, .L868
.L1015:
	ldr	x2, [x19, 24]
	ldr	x0, [x19, 240]
	ldr	x3, [x19, 256]
	madd	x1, x1, x2, x0
	add	x3, x3, x1
.L869:
	ldr	w0, [x3]
	cmp	w0, 0
	ccmp	w28, 0, 0, ne
	beq	.L1003
	ldp	x1, x7, [sp, 152]
	mov	x2, 1
	sub	x5, x7, x1
	sub	x6, x1, #4
	asr	x5, x5, 2
	strh	w5, [x3]
	cbnz	x5, .L871
	b	.L876
	.p2align 2,,3
.L926:
	mov	x2, x0
.L871:
	ldr	w0, [x3, x2, lsl 2]
	cmp	w0, 0
	ccmp	w28, 0, 0, ne
	beq	.L1004
	ldr	w0, [x6, x2, lsl 2]
	ldr	x4, [x19, 272]
	ldr	w4, [x4, w0, uxtw 2]
	cmp	w26, w4
	bgt	.L1005
	str	w0, [x3, x2, lsl 2]
	add	x0, x2, 1
	cmp	x5, x2
	bne	.L926
.L876:
	ldrb	w0, [sp, 184]
	cbnz	w0, .L1006
.L873:
	cmp	x1, x7
	beq	.L878
	sub	w0, w26, #1
	add	x2, x19, 192
	mov	x24, 0
	sxtw	x0, w0
	stp	x2, x0, [sp, 104]
	b	.L908
	.p2align 2,,3
.L1012:
	ldr	x1, [x19, 24]
	ldr	x2, [x19, 240]
	ldr	x20, [x19, 256]
	madd	x1, x4, x1, x2
	add	x20, x20, x1
.L882:
	ldrh	w2, [x20]
	and	x22, x2, 65535
	cmp	x27, x2, uxth
	bcc	.L1007
	ldr	w1, [sp, 124]
	cmp	w1, w0
	beq	.L1008
	ldr	x0, [x19, 272]
	ldr	w0, [x0, x4, lsl 2]
	cmp	w26, w0
	bgt	.L1009
	add	x21, x20, 4
	cbnz	w28, .L1010
.L886:
	cmp	x22, x27
	bcs	.L889
	uxtw	x0, w2
	add	w2, w2, 1
	str	w1, [x21, x0, lsl 2]
	strh	w2, [x20]
.L887:
	ldr	x0, [sp, 136]
	cbz	x0, .L907
	ldr	x1, [sp, 96]
	cbz	x1, .L907
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L907:
	ldp	x1, x0, [sp, 152]
	add	x24, x24, 1
	sub	x0, x0, x1
	cmp	x24, x0, asr 2
	bcs	.L878
.L908:
	ldr	x2, [sp, 104]
	mov	w3, 48
	ldr	w0, [x1, x24, lsl 2]
	lsl	x25, x24, 2
	strb	wzr, [sp, 144]
	ldr	x2, [x2]
	umaddl	x0, w0, w3, x2
	str	x0, [sp, 136]
	cbz	x0, .L1011
	adrp	x2, .LC5
	ldr	x2, [x2, #:lo12:.LC5]
	str	x2, [sp, 96]
	cbz	x2, .L880
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L992
	ldr	x1, [sp, 152]
.L880:
	mov	w0, 1
	strb	w0, [sp, 144]
	ldr	w0, [x1, x25]
	uxtw	x4, w0
	cbz	w26, .L1012
	ldr	x1, [x19, 264]
	ldr	x20, [x19, 32]
	ldr	x1, [x1, x4, lsl 3]
	ldr	x2, [sp, 112]
	madd	x20, x2, x20, x1
	b	.L882
.L1000:
	lsl	x22, x0, 2
	add	x20, sp, 152
	mov	x0, x22
	bl	_Znwm
.LEHE60:
	ldp	x23, x2, [sp, 152]
	mov	x20, x0
	ldr	x24, [sp, 168]
	sub	x2, x2, x23
	cmp	x2, 0
	bgt	.L1013
	cbnz	x23, .L857
.L858:
	add	x0, x20, x22
	stp	x20, x20, [sp, 152]
	str	x0, [sp, 168]
	ldp	x2, x1, [x21]
	b	.L855
.L1013:
	mov	x1, x23
	bl	memmove
.L857:
	sub	x1, x24, x23
	mov	x0, x23
	bl	_ZdlPvm
	b	.L858
.L1002:
	cbz	x0, .L1014
	adrp	x2, .LC5
	ldr	x2, [x2, #:lo12:.LC5]
	cbz	x2, .L866
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L867
	ldr	w1, [sp, 124]
.L866:
	mov	w0, 1
	strb	w0, [sp, 184]
	cbz	w26, .L1015
.L868:
	ldr	x0, [x19, 264]
	sub	w3, w26, #1
	ldr	x2, [x19, 32]
	sxtw	x3, w3
	ldr	x0, [x0, x1, lsl 3]
	madd	x3, x3, x2, x0
	b	.L869
	.p2align 2,,3
.L1010:
	cbz	x22, .L886
	mov	x0, 1
	b	.L888
	.p2align 2,,3
.L1016:
	add	x3, x0, 1
	cmp	x22, x0
	beq	.L886
	mov	x0, x3
.L888:
	ldr	w3, [x20, x0, lsl 2]
	cmp	w1, w3
	bne	.L1016
	b	.L887
	.p2align 2,,3
.L889:
	ldr	x3, [x19, 24]
	uxtw	x0, w1
	ldr	x5, [x19, 232]
	ldp	x6, x2, [x19, 304]
	madd	x0, x0, x3, x5
	madd	x3, x3, x4, x5
	ldr	x1, [x19, 256]
	add	x0, x1, x0
	add	x1, x1, x3
.LEHB61:
	blr	x6
.LEHE61:
	add	x0, sp, 176
	add	x3, sp, 124
	add	x2, sp, 128
	mov	x1, 0
	str	s0, [sp, 128]
	stp	xzr, xzr, [sp, 176]
	str	xzr, [sp, 192]
.LEHB62:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldp	x3, x1, [sp, 176]
	sub	x2, x1, x3
	ldr	w7, [x1, -4]
	ldr	s1, [x1, -8]
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L890
	.p2align 3,,7
.L893:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s0, [x3, x2]
	fcmpe	s1, s0
	bgt	.L943
.L891:
	str	w7, [x4, 4]
	mov	x23, 0
	str	s1, [x4]
	cbz	x22, .L902
	.p2align 3,,7
.L903:
	ldr	x1, [sp, 152]
	ldr	w0, [x21]
	ldr	x5, [x19, 24]
	ldr	w1, [x1, x25]
	ldr	x4, [x19, 232]
	ldp	x6, x2, [x19, 304]
	ldr	x3, [x19, 256]
	madd	x0, x0, x5, x4
	madd	x1, x1, x5, x4
	add	x0, x3, x0
	add	x1, x3, x1
	blr	x6
	ldp	x1, x0, [sp, 184]
	str	s0, [sp, 132]
	cmp	x1, x0
	beq	.L896
	ldr	w7, [x21]
	add	x0, x1, 8
	str	s0, [x1]
	str	w7, [x1, 4]
	str	x0, [sp, 184]
.L897:
	ldr	x3, [sp, 176]
	sub	x2, x0, x3
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L898
	.p2align 3,,7
.L901:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s1, [x3, x2]
	fcmpe	s1, s0
	bmi	.L944
	add	x23, x23, 1
	str	s0, [x4]
	str	w7, [x4, 4]
	add	x21, x21, 4
	cmp	x22, x23
	bne	.L903
.L902:
	mov	x2, x27
	add	x1, sp, 176
	mov	x0, x19
	bl	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm
	ldp	x0, x1, [sp, 176]
	cmp	x1, x0
	beq	.L931
	mov	x21, 1
	.p2align 3,,7
.L905:
	ldr	w1, [x0, 4]
	add	x0, sp, 176
	str	w1, [x20, x21, lsl 2]
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x0, x1, [sp, 176]
	mov	x2, x21
	add	x21, x21, 1
	cmp	x1, x0
	bne	.L905
	and	w2, w2, 65535
.L904:
	strh	w2, [x20]
	cbz	x0, .L906
	ldr	x1, [sp, 192]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L906:
	ldrb	w0, [sp, 144]
	cbnz	w0, .L887
	ldp	x1, x0, [sp, 152]
	add	x24, x24, 1
	sub	x0, x0, x1
	cmp	x24, x0, asr 2
	bcc	.L908
.L878:
	cbz	x1, .L851
	ldr	x2, [sp, 168]
	mov	x0, x1
	sub	x1, x2, x1
	bl	_ZdlPvm
.L851:
	ldr	w0, [sp, 120]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L943:
	.cfi_restore_state
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L893
	mov	x4, x5
	b	.L891
	.p2align 2,,3
.L944:
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s1, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L901
	mov	x4, x5
	add	x23, x23, 1
	add	x21, x21, 4
	str	s0, [x4]
	str	w7, [x4, 4]
	cmp	x22, x23
	bne	.L903
	b	.L902
	.p2align 2,,3
.L896:
	mov	x3, x21
	add	x2, sp, 132
	add	x0, sp, 176
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE62:
	ldr	x0, [sp, 184]
	ldr	w7, [x0, -4]
	ldr	s0, [x0, -8]
	b	.L897
.L898:
	sub	x0, x2, #8
	add	x23, x23, 1
	add	x4, x3, x0
	add	x21, x21, 4
	str	s0, [x4]
	str	w7, [x4, 4]
	cmp	x22, x23
	bne	.L903
	b	.L902
.L1006:
	ldr	x0, [sp, 176]
	cbz	x0, .L873
	adrp	x2, .LC5
	ldr	x2, [x2, #:lo12:.LC5]
	cbz	x2, .L873
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	ldp	x1, x7, [sp, 152]
	b	.L873
.L931:
	mov	w2, 0
	b	.L904
.L890:
	sub	x2, x2, #8
	add	x4, x3, x2
	b	.L891
.L867:
.LEHB63:
	bl	_ZSt20__throw_system_errori
.LEHE63:
.L999:
	adrp	x0, .LC19
	add	x20, sp, 152
	add	x0, x0, :lo12:.LC19
.LEHB64:
	bl	_ZSt20__throw_length_errorPKc
.L992:
	add	x20, sp, 152
	bl	_ZSt20__throw_system_errori
.LEHE64:
.L1014:
	mov	w0, 1
.LEHB65:
	bl	_ZSt20__throw_system_errori
.LEHE65:
	.p2align 2,,3
.L1011:
	add	x20, sp, 152
	mov	w0, 1
.LEHB66:
	bl	_ZSt20__throw_system_errori
.LEHE66:
.L938:
	mov	x19, x0
.L912:
	ldrb	w0, [sp, 184]
	cbz	w0, .L922
	add	x0, sp, 176
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L922:
	add	x20, sp, 152
.L916:
	mov	x0, x20
	bl	_ZNSt12_Vector_baseIjSaIjEED2Ev
	mov	x0, x19
.LEHB67:
	bl	_Unwind_Resume
.LEHE67:
.L1007:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC23
	mov	x20, x0
	add	x1, x1, :lo12:.LC23
.LEHB68:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE68:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB69:
	bl	__cxa_throw
.LEHE69:
.L1008:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC24
	mov	x20, x0
	add	x1, x1, :lo12:.LC24
.LEHB70:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE70:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB71:
	bl	__cxa_throw
.LEHE71:
.L937:
.L996:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
.L918:
	ldrb	w0, [sp, 144]
	cbz	w0, .L922
	add	x0, sp, 136
	add	x20, sp, 152
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L916
.L936:
	b	.L996
.L933:
	mov	x19, x0
	b	.L918
.L934:
	mov	x19, x0
	add	x0, sp, 176
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	b	.L918
.L932:
	mov	x19, x0
	b	.L916
.L1003:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC20
	mov	x20, x0
	add	x1, x1, :lo12:.LC20
.LEHB72:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE72:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB73:
	bl	__cxa_throw
.LEHE73:
.L998:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC18
	mov	x19, x0
	add	x1, x1, :lo12:.LC18
.LEHB74:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE74:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x19
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB75:
	bl	__cxa_throw
.LEHE75:
.L1004:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC21
	mov	x20, x0
	add	x1, x1, :lo12:.LC21
.LEHB76:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE76:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB77:
	bl	__cxa_throw
.LEHE77:
.L1009:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC22
	mov	x20, x0
	add	x1, x1, :lo12:.LC22
.LEHB78:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE78:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB79:
	bl	__cxa_throw
.LEHE79:
.L1005:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC22
	mov	x20, x0
	add	x1, x1, :lo12:.LC22
.LEHB80:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE80:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB81:
	bl	__cxa_throw
.LEHE81:
.L941:
.L995:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
	b	.L912
.L942:
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	bl	__cxa_free_exception
	mov	x0, x19
.LEHB82:
	bl	_Unwind_Resume
.LEHE82:
.L940:
	b	.L995
.L939:
	b	.L995
.L935:
	b	.L996
	.cfi_endproc
.LFE8602:
	.section	.gcc_except_table
.LLSDA8602:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8602-.LLSDACSB8602
.LLSDACSB8602:
	.uleb128 .LEHB59-.LFB8602
	.uleb128 .LEHE59-.LEHB59
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB60-.LFB8602
	.uleb128 .LEHE60-.LEHB60
	.uleb128 .L932-.LFB8602
	.uleb128 0
	.uleb128 .LEHB61-.LFB8602
	.uleb128 .LEHE61-.LEHB61
	.uleb128 .L933-.LFB8602
	.uleb128 0
	.uleb128 .LEHB62-.LFB8602
	.uleb128 .LEHE62-.LEHB62
	.uleb128 .L934-.LFB8602
	.uleb128 0
	.uleb128 .LEHB63-.LFB8602
	.uleb128 .LEHE63-.LEHB63
	.uleb128 .L938-.LFB8602
	.uleb128 0
	.uleb128 .LEHB64-.LFB8602
	.uleb128 .LEHE64-.LEHB64
	.uleb128 .L932-.LFB8602
	.uleb128 0
	.uleb128 .LEHB65-.LFB8602
	.uleb128 .LEHE65-.LEHB65
	.uleb128 .L938-.LFB8602
	.uleb128 0
	.uleb128 .LEHB66-.LFB8602
	.uleb128 .LEHE66-.LEHB66
	.uleb128 .L932-.LFB8602
	.uleb128 0
	.uleb128 .LEHB67-.LFB8602
	.uleb128 .LEHE67-.LEHB67
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB68-.LFB8602
	.uleb128 .LEHE68-.LEHB68
	.uleb128 .L937-.LFB8602
	.uleb128 0
	.uleb128 .LEHB69-.LFB8602
	.uleb128 .LEHE69-.LEHB69
	.uleb128 .L933-.LFB8602
	.uleb128 0
	.uleb128 .LEHB70-.LFB8602
	.uleb128 .LEHE70-.LEHB70
	.uleb128 .L936-.LFB8602
	.uleb128 0
	.uleb128 .LEHB71-.LFB8602
	.uleb128 .LEHE71-.LEHB71
	.uleb128 .L933-.LFB8602
	.uleb128 0
	.uleb128 .LEHB72-.LFB8602
	.uleb128 .LEHE72-.LEHB72
	.uleb128 .L941-.LFB8602
	.uleb128 0
	.uleb128 .LEHB73-.LFB8602
	.uleb128 .LEHE73-.LEHB73
	.uleb128 .L938-.LFB8602
	.uleb128 0
	.uleb128 .LEHB74-.LFB8602
	.uleb128 .LEHE74-.LEHB74
	.uleb128 .L942-.LFB8602
	.uleb128 0
	.uleb128 .LEHB75-.LFB8602
	.uleb128 .LEHE75-.LEHB75
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB76-.LFB8602
	.uleb128 .LEHE76-.LEHB76
	.uleb128 .L940-.LFB8602
	.uleb128 0
	.uleb128 .LEHB77-.LFB8602
	.uleb128 .LEHE77-.LEHB77
	.uleb128 .L938-.LFB8602
	.uleb128 0
	.uleb128 .LEHB78-.LFB8602
	.uleb128 .LEHE78-.LEHB78
	.uleb128 .L935-.LFB8602
	.uleb128 0
	.uleb128 .LEHB79-.LFB8602
	.uleb128 .LEHE79-.LEHB79
	.uleb128 .L933-.LFB8602
	.uleb128 0
	.uleb128 .LEHB80-.LFB8602
	.uleb128 .LEHE80-.LEHB80
	.uleb128 .L939-.LFB8602
	.uleb128 0
	.uleb128 .LEHB81-.LFB8602
	.uleb128 .LEHE81-.LEHB81
	.uleb128 .L938-.LFB8602
	.uleb128 0
	.uleb128 .LEHB82-.LFB8602
	.uleb128 .LEHE82-.LEHB82
	.uleb128 0
	.uleb128 0
.LLSDACSE8602:
	.text
	.size	_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0, .-_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0
	.section	.rodata._ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi.str1.8,"aMS",@progbits,1
	.align	3
.LC25:
	.string	"cannot create std::deque larger than max_size()"
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi
	.type	_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi, %function
_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi:
.LFB7344:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA7344
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	mov	x19, x0
	ldr	x0, [x0, 112]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	mov	x21, x8
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	mov	x26, x2
	stp	x27, x28, [sp, 80]
	str	d8, [sp, 96]
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.cfi_offset 72, -112
	stp	w3, w1, [sp, 136]
.LEHB83:
	bl	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv
.LEHE83:
	ldr	w2, [sp, 140]
	ldrh	w23, [x0]
	str	x0, [sp, 128]
	ldr	x22, [x0, 8]
	stp	xzr, xzr, [sp, 176]
	ldr	x0, [x19, 24]
	str	xzr, [sp, 192]
	ldr	x1, [x19, 256]
	mul	x0, x2, x0
	ldr	x3, [x19, 240]
	add	x2, x1, x0
	stp	xzr, xzr, [x21]
	add	x2, x2, x3
	str	xzr, [x21, 16]
	ldrb	w2, [x2, 2]
	tbnz	x2, 0, .L1018
	ldr	x2, [x19, 232]
	add	x28, sp, 176
	ldr	x3, [x19, 304]
	add	x0, x0, x2
	ldr	x2, [x19, 312]
	add	x1, x1, x0
	mov	x0, x26
.LEHB84:
	blr	x3
	ldp	x1, x0, [x21, 8]
	str	s0, [sp, 156]
	fmov	s8, s0
	cmp	x1, x0
	beq	.L1019
	ldr	w7, [sp, 140]
	fmov	s2, s0
	str	s0, [x1]
	add	x0, x1, 8
	str	w7, [x1, 4]
	str	x0, [x21, 8]
.L1020:
	ldr	x3, [x21]
	sub	x2, x0, x3
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L1021
	.p2align 3,,7
.L1024:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s0, [x3, x2]
	fcmpe	s0, s2
	bmi	.L1092
.L1022:
	ldp	x1, x0, [sp, 184]
	fneg	s1, s8
	str	w7, [x4, 4]
	str	s2, [x4]
	str	s1, [sp, 160]
	cmp	x1, x0
	beq	.L1025
.L1138:
	ldr	w9, [sp, 140]
	add	x5, x1, 8
	str	s1, [x1]
	mov	w8, w9
	str	w9, [x1, 4]
	str	x5, [sp, 184]
.L1026:
	ldr	x0, [sp, 176]
	sub	x3, x5, x0
	asr	x1, x3, 3
	sub	x2, x1, #2
	sub	x1, x1, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x1, 0
	ble	.L1027
	.p2align 3,,7
.L1030:
	lsl	x3, x2, 3
	lsl	x1, x1, 3
	add	x6, x0, x3
	add	x4, x0, x1
	ldr	s0, [x0, x3]
	fcmpe	s0, s1
	bmi	.L1093
.L1028:
	str	w9, [x4, 4]
	str	s1, [x4]
.L1031:
	strh	w23, [x22, w8, uxtw 1]
	cmp	x0, x5
	beq	.L1137
	ldr	w1, [sp, 136]
	sub	w1, w1, #1
	sxtw	x1, w1
	str	x1, [sp, 120]
	.p2align 3,,7
.L1069:
	ldr	s0, [x0]
	ldr	w24, [x0, 4]
	fneg	s0, s0
	fcmpe	s0, s8
	bgt	.L1095
	b	.L1037
	.p2align 2,,3
.L1092:
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L1024
	mov	x4, x5
	fneg	s1, s8
	ldp	x1, x0, [sp, 184]
	str	w7, [x4, 4]
	str	s2, [x4]
	str	s1, [sp, 160]
	cmp	x1, x0
	bne	.L1138
.L1025:
	add	x28, sp, 176
	add	x3, sp, 140
	mov	x0, x28
	add	x2, sp, 160
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE84:
	ldr	x5, [sp, 184]
	ldr	w8, [sp, 140]
	ldr	w9, [x5, -4]
	ldr	s1, [x5, -8]
	b	.L1026
	.p2align 2,,3
.L1093:
	sub	x3, x2, #1
	ldr	w7, [x6, 4]
	str	s0, [x0, x1]
	mov	x1, x2
	add	x3, x3, x3, lsr 63
	str	w7, [x4, 4]
	asr	x2, x3, 1
	cmp	x1, 0
	bgt	.L1030
	mov	x4, x6
	b	.L1028
	.p2align 2,,3
.L1095:
	ldp	x2, x0, [x21]
	ldr	x1, [x19, 72]
	sub	x0, x0, x2
	cmp	x1, x0, asr 3
	beq	.L1137
.L1037:
	add	x28, sp, 176
	uxtw	x20, w24
	mov	x0, x28
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldr	x0, [x19, 192]
	mov	w1, 48
	strb	wzr, [sp, 168]
	umaddl	x0, w24, w1, x0
	str	x0, [sp, 160]
	cbz	x0, .L1139
	adrp	x1, .LC5
	ldr	x27, [x1, #:lo12:.LC5]
	cbz	x27, .L1041
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1140
.L1041:
	mov	w0, 1
	strb	w0, [sp, 168]
	ldr	w0, [sp, 136]
	cbnz	w0, .L1042
	ldr	x0, [x19, 24]
	ldr	x1, [x19, 240]
	ldr	x24, [x19, 256]
	madd	x0, x20, x0, x1
	add	x24, x24, x0
	ldrh	w25, [x24]
	cbz	x25, .L1044
.L1144:
	mov	x20, 0
	b	.L1045
	.p2align 2,,3
.L1141:
	fcmpe	s0, s8
	bmi	.L1049
.L1048:
	cmp	x25, x20
	beq	.L1046
.L1045:
	add	x20, x20, 1
	ldr	w0, [x24, x20, lsl 2]
	str	w0, [sp, 148]
	uxtw	x1, w0
	ubfiz	x0, x0, 1, 32
	ldrh	w2, [x22, x0]
	cmp	w2, w23
	beq	.L1048
	ldr	x5, [x19, 24]
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	strh	w23, [x22, x0]
	madd	x1, x1, x5, x4
	mov	x0, x26
	ldr	x4, [x19, 256]
	add	x1, x4, x1
.LEHB85:
	blr	x3
	ldp	x0, x6, [x21]
	str	s0, [sp, 152]
	ldr	x1, [x19, 72]
	sub	x0, x6, x0
	cmp	x1, x0, asr 3
	bls	.L1141
.L1049:
	ldp	x1, x0, [sp, 184]
	fneg	s0, s0
	str	s0, [sp, 156]
	cmp	x1, x0
	beq	.L1052
	ldr	w7, [sp, 148]
	add	x0, x1, 8
	str	s0, [x1]
	mov	w8, w7
	str	w7, [x1, 4]
	str	x0, [sp, 184]
.L1053:
	ldr	x4, [sp, 176]
	sub	x3, x0, x4
	asr	x0, x3, 3
	sub	x2, x0, #2
	sub	x0, x0, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x0, 0
	ble	.L1054
	.p2align 3,,7
.L1057:
	lsl	x3, x2, 3
	lsl	x0, x0, 3
	add	x1, x4, x3
	add	x5, x4, x0
	ldr	s1, [x4, x3]
	fcmpe	s1, s0
	bmi	.L1096
.L1055:
	ldr	x3, [x19, 24]
	uxtw	x0, w7
	ldr	x2, [x19, 256]
	ldr	x1, [x19, 240]
	str	w8, [x5, 4]
	madd	x0, x0, x3, x2
	str	s0, [x5]
	add	x0, x0, x1
	ldrb	w0, [x0, 2]
	tbz	x0, 0, .L1058
	ldr	x2, [x21]
	sub	x9, x6, x2
	asr	x9, x9, 3
.L1059:
	ldr	x0, [x19, 72]
	cmp	x0, x9
	bcc	.L1142
.L1066:
	cmp	x2, x6
	beq	.L1048
	ldr	s8, [x2]
	cmp	x25, x20
	bne	.L1045
.L1046:
	ldrb	w0, [sp, 168]
	cbnz	w0, .L1044
.L1067:
	ldp	x0, x1, [sp, 176]
	cmp	x0, x1
	bne	.L1069
.L1039:
	ldr	x19, [x19, 112]
	strb	wzr, [sp, 168]
	add	x0, x19, 80
	str	x0, [sp, 160]
	cbz	x27, .L1070
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1143
.L1070:
	ldp	x0, x1, [x19, 16]
	mov	w2, 1
	strb	w2, [sp, 168]
	cmp	x0, x1
	beq	.L1071
	ldr	x1, [sp, 128]
	str	x1, [x0, -8]!
	str	x0, [x19, 16]
.L1072:
	ldr	x0, [sp, 160]
	cbz	x0, .L1075
	cbz	x27, .L1075
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L1075:
	ldr	x0, [sp, 176]
	cbz	x0, .L1017
	ldr	x1, [sp, 192]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L1017:
	mov	x0, x21
	ldr	d8, [sp, 96]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1096:
	.cfi_restore_state
	sub	x3, x2, #1
	ldr	w9, [x1, 4]
	str	s1, [x4, x0]
	mov	x0, x2
	add	x3, x3, x3, lsr 63
	str	w9, [x5, 4]
	asr	x2, x3, 1
	cmp	x0, 0
	bgt	.L1057
	mov	x5, x1
	b	.L1055
	.p2align 2,,3
.L1142:
	mov	x0, x21
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x2, x6, [x21]
	b	.L1066
	.p2align 2,,3
.L1058:
	ldr	x0, [x21, 16]
	cmp	x0, x6
	beq	.L1060
	ldr	s1, [sp, 152]
	add	x6, x6, 8
	str	w7, [x6, -4]
	str	s1, [x6, -8]
	str	x6, [x21, 8]
.L1061:
	ldr	x2, [x21]
	sub	x3, x6, x2
	asr	x9, x3, 3
	sub	x0, x9, #2
	sub	x1, x9, #1
	add	x0, x0, x0, lsr 63
	asr	x0, x0, 1
	cmp	x1, 0
	ble	.L1062
	.p2align 3,,7
.L1065:
	lsl	x3, x0, 3
	lsl	x1, x1, 3
	add	x5, x2, x3
	add	x4, x2, x1
	ldr	s0, [x2, x3]
	fcmpe	s0, s1
	bmi	.L1097
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L1059
	.p2align 2,,3
.L1097:
	sub	x3, x0, #1
	ldr	w8, [x5, 4]
	str	s0, [x2, x1]
	mov	x1, x0
	add	x3, x3, x3, lsr 63
	str	w8, [x4, 4]
	asr	x0, x3, 1
	cmp	x1, 0
	bgt	.L1065
	mov	x4, x5
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L1059
	.p2align 2,,3
.L1052:
	add	x3, sp, 148
	add	x2, sp, 156
	add	x0, sp, 176
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x0, [sp, 184]
	ldr	w7, [sp, 148]
	ldr	x6, [x21, 8]
	ldr	w8, [x0, -4]
	ldr	s0, [x0, -8]
	b	.L1053
	.p2align 2,,3
.L1042:
	ldr	x0, [x19, 264]
	ldr	x24, [x19, 32]
	ldr	x0, [x0, x20, lsl 3]
	ldr	x1, [sp, 120]
	madd	x24, x1, x24, x0
	ldrh	w25, [x24]
	cbnz	x25, .L1144
.L1044:
	ldr	x0, [sp, 160]
	cbz	x0, .L1067
	cbz	x27, .L1067
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	b	.L1067
.L1060:
	mov	x1, x6
	add	x3, sp, 148
	add	x2, sp, 152
	mov	x0, x21
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE85:
	ldr	x6, [x21, 8]
	ldr	w7, [x6, -4]
	ldr	s1, [x6, -8]
	b	.L1061
.L1054:
	sub	x0, x3, #8
	add	x5, x4, x0
	b	.L1055
.L1062:
	sub	x3, x3, #8
	add	x4, x2, x3
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L1059
.L1137:
	adrp	x0, .LC5
	ldr	x27, [x0, #:lo12:.LC5]
	b	.L1039
.L1018:
	mvni	v0.2s, 0x80, lsl 16
	add	x28, sp, 176
	mov	x0, x28
	add	x3, sp, 140
	add	x2, sp, 160
	mov	x1, 0
	str	s0, [sp, 160]
.LEHB86:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE86:
	ldp	x0, x5, [sp, 176]
	sub	x3, x5, x0
	ldr	w9, [x5, -4]
	ldr	s1, [x5, -8]
	asr	x1, x3, 3
	sub	x2, x1, #2
	sub	x1, x1, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x1, 0
	ble	.L1032
.L1035:
	lsl	x3, x2, 3
	lsl	x1, x1, 3
	add	x6, x0, x3
	add	x4, x0, x1
	ldr	s0, [x0, x3]
	fcmpe	s1, s0
	bgt	.L1094
.L1033:
	adrp	x1, .LC26
	ldr	w8, [sp, 140]
	str	s1, [x4]
	ldr	s8, [x1, #:lo12:.LC26]
	str	w9, [x4, 4]
	b	.L1031
	.p2align 2,,3
.L1094:
	sub	x3, x2, #1
	ldr	w7, [x6, 4]
	str	s0, [x0, x1]
	mov	x1, x2
	add	x3, x3, x3, lsr 63
	str	w7, [x4, 4]
	asr	x2, x3, 1
	cmp	x1, 0
	bgt	.L1035
	mov	x4, x6
	adrp	x1, .LC26
	ldr	w8, [sp, 140]
	ldr	s8, [x1, #:lo12:.LC26]
	str	s1, [x4]
	str	w9, [x4, 4]
	b	.L1031
.L1071:
	add	x20, x19, 16
	mov	x5, 1152921504606846975
	ldp	x4, x6, [x19, 48]
	ldp	x3, x22, [x20, 16]
	ldr	x1, [x19, 72]
	sub	x4, x4, x6
	sub	x1, x1, x22
	sub	x3, x3, x0
	asr	x0, x4, 3
	asr	x1, x1, 3
	sub	x1, x1, #1
	add	x0, x0, x1, lsl 6
	add	x0, x0, x3, asr 3
	cmp	x0, x5
	beq	.L1145
	ldr	x0, [x19]
	cmp	x22, x0
	beq	.L1146
.L1074:
	mov	x0, 512
.LEHB87:
	bl	_Znwm
.LEHE87:
	ldrb	w1, [sp, 168]
	str	x0, [x22, -8]
	ldr	x0, [x19, 40]
	sub	x2, x0, #8
	ldr	x0, [x0, -8]
	str	x2, [x20, 24]
	str	x0, [x20, 8]
	add	x2, x0, 512
	str	x2, [x20, 16]
	add	x2, x0, 504
	str	x2, [x19, 16]
	ldr	x2, [sp, 128]
	str	x2, [x0, 504]
	cbz	w1, .L1075
	b	.L1072
	.p2align 2,,3
.L1019:
	add	x28, sp, 176
	add	x3, sp, 140
	add	x2, sp, 156
	mov	x0, x21
.LEHB88:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE88:
	ldr	x0, [x21, 8]
	ldr	s8, [sp, 156]
	ldr	w7, [x0, -4]
	ldr	s2, [x0, -8]
	b	.L1020
.L1146:
	mov	x0, x19
	mov	x1, 1
.LEHB89:
	bl	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
.LEHE89:
	ldr	x22, [x19, 40]
	b	.L1074
.L1027:
	sub	x3, x3, #8
	add	x4, x0, x3
	b	.L1028
.L1021:
	sub	x0, x2, #8
	add	x4, x3, x0
	b	.L1022
.L1032:
	sub	x3, x3, #8
	add	x4, x0, x3
	b	.L1033
.L1140:
.LEHB90:
	bl	_ZSt20__throw_system_errori
.L1139:
	mov	w0, 1
	bl	_ZSt20__throw_system_errori
.LEHE90:
.L1145:
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
.LEHB91:
	bl	_ZSt20__throw_length_errorPKc
.LEHE91:
.L1143:
	add	x28, sp, 176
.LEHB92:
	bl	_ZSt20__throw_system_errori
.LEHE92:
.L1090:
	ldrb	w1, [sp, 168]
	mov	x19, x0
	cbz	w1, .L1080
	add	x0, sp, 160
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L1080:
	mov	x0, x28
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	mov	x0, x21
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	mov	x0, x19
.LEHB93:
	bl	_Unwind_Resume
.LEHE93:
.L1091:
	ldrb	w1, [sp, 168]
	mov	x19, x0
	cbz	w1, .L1079
	add	x0, sp, 160
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L1079:
	add	x28, sp, 176
	b	.L1080
.L1089:
	mov	x19, x0
	b	.L1080
	.cfi_endproc
.LFE7344:
	.section	.gcc_except_table
.LLSDA7344:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7344-.LLSDACSB7344
.LLSDACSB7344:
	.uleb128 .LEHB83-.LFB7344
	.uleb128 .LEHE83-.LEHB83
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB84-.LFB7344
	.uleb128 .LEHE84-.LEHB84
	.uleb128 .L1089-.LFB7344
	.uleb128 0
	.uleb128 .LEHB85-.LFB7344
	.uleb128 .LEHE85-.LEHB85
	.uleb128 .L1090-.LFB7344
	.uleb128 0
	.uleb128 .LEHB86-.LFB7344
	.uleb128 .LEHE86-.LEHB86
	.uleb128 .L1089-.LFB7344
	.uleb128 0
	.uleb128 .LEHB87-.LFB7344
	.uleb128 .LEHE87-.LEHB87
	.uleb128 .L1091-.LFB7344
	.uleb128 0
	.uleb128 .LEHB88-.LFB7344
	.uleb128 .LEHE88-.LEHB88
	.uleb128 .L1089-.LFB7344
	.uleb128 0
	.uleb128 .LEHB89-.LFB7344
	.uleb128 .LEHE89-.LEHB89
	.uleb128 .L1091-.LFB7344
	.uleb128 0
	.uleb128 .LEHB90-.LFB7344
	.uleb128 .LEHE90-.LEHB90
	.uleb128 .L1089-.LFB7344
	.uleb128 0
	.uleb128 .LEHB91-.LFB7344
	.uleb128 .LEHE91-.LEHB91
	.uleb128 .L1091-.LFB7344
	.uleb128 0
	.uleb128 .LEHB92-.LFB7344
	.uleb128 .LEHE92-.LEHB92
	.uleb128 .L1089-.LFB7344
	.uleb128 0
	.uleb128 .LEHB93-.LFB7344
	.uleb128 .LEHE93-.LEHB93
	.uleb128 0
	.uleb128 0
.LLSDACSE7344:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi, .-_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi
	.section	.rodata._ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii.str1.8,"aMS",@progbits,1
	.align	3
.LC27:
	.string	"Level of item to be updated cannot be bigger than max level"
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii
	.type	_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii, %function
_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii:
.LFB7399:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA7399
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	mov	x23, x1
	mov	w24, w2
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	mov	w26, w3
	stp	x27, x28, [sp, 80]
	str	d8, [sp, 96]
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.cfi_offset 72, -112
	stp	w5, w4, [sp, 116]
	str	w2, [sp, 124]
	cmp	w4, w5
	bge	.L1148
	mov	x0, x1
	uxtw	x21, w2
	ldr	x1, [x19, 24]
	add	x28, x19, 192
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	madd	x1, x21, x1, x4
	ldr	x4, [x19, 256]
	add	x1, x4, x1
.LEHB94:
	blr	x3
.LEHE94:
	fmov	s8, s0
.L1161:
	ldr	w0, [sp, 116]
	sub	w0, w0, #1
	sxtw	x0, w0
	mov	x27, x0
	.p2align 3,,7
.L1159:
	ldr	x0, [x28]
	mov	w1, 48
	strb	wzr, [sp, 184]
	umaddl	x0, w24, w1, x0
	str	x0, [sp, 176]
	cbz	x0, .L1237
	adrp	x1, .LC5
	add	x1, x1, :lo12:.LC5
	ldr	x1, [x1]
	cbz	x1, .L1150
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1238
.L1150:
	mov	w0, 1
	strb	w0, [sp, 184]
	ldr	w0, [sp, 116]
	cbnz	w0, .L1151
	ldr	x0, [x19, 24]
	ldr	x1, [x19, 240]
	ldr	x20, [x19, 256]
	madd	x0, x21, x0, x1
	add	x20, x20, x0
	ldrh	w22, [x20]
	cbz	w22, .L1153
.L1241:
	sub	w22, w22, #1
	add	x0, x20, 8
	add	x20, x20, 4
	mov	w25, 0
	add	x22, x0, x22, uxtw 2
	.p2align 3,,7
.L1156:
	ldr	w21, [x20]
	mov	x0, x23
	ldr	x5, [x19, 24]
	uxtw	x1, w21
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	madd	x1, x1, x5, x4
	ldr	x4, [x19, 256]
	add	x1, x4, x1
.LEHB95:
	blr	x3
.LEHE95:
	fcmpe	s0, s8
	bmi	.L1199
.L1154:
	add	x20, x20, 4
	cmp	x22, x20
	bne	.L1156
	ldrb	w0, [sp, 184]
	cbnz	w0, .L1239
.L1157:
	cbz	w25, .L1190
.L1240:
	uxtw	x21, w24
	b	.L1159
	.p2align 2,,3
.L1239:
	ldr	x0, [sp, 176]
	cbz	x0, .L1157
.L1191:
	adrp	x1, .LC5
	add	x1, x1, :lo12:.LC5
	ldr	x1, [x1]
	cbz	x1, .L1157
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	cbnz	w25, .L1240
.L1190:
	ldp	w0, w1, [sp, 116]
	sub	w0, w0, #1
	str	w0, [sp, 116]
	cmp	w1, w0
	beq	.L1160
	uxtw	x21, w24
	b	.L1161
	.p2align 2,,3
.L1199:
	fmov	s8, s0
	mov	w24, w21
	mov	w25, 1
	b	.L1154
	.p2align 2,,3
.L1151:
	ldr	x0, [x19, 264]
	ldr	x20, [x19, 32]
	ldr	x0, [x0, x21, lsl 3]
	madd	x20, x27, x20, x0
	ldrh	w22, [x20]
	cbnz	w22, .L1241
.L1153:
	ldr	x0, [sp, 176]
	cbz	x0, .L1190
	mov	w25, 0
	b	.L1191
.L1148:
	bgt	.L1162
.L1160:
	ldr	w0, [sp, 120]
	tbnz	w0, #31, .L1147
	.p2align 3,,7
.L1163:
	ldr	w3, [sp, 120]
	mov	x2, x23
	mov	x0, x19
	add	x8, sp, 144
	mov	w1, w24
.LEHB96:
	bl	_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi
.LEHE96:
	stp	xzr, xzr, [sp, 176]
	ldp	x2, x0, [sp, 144]
	str	xzr, [sp, 192]
	cmp	x2, x0
	beq	.L1164
	.p2align 3,,7
.L1172:
	ldr	w0, [x2, 4]
	cmp	w0, w26
	beq	.L1165
	ldp	x1, x0, [sp, 184]
	cmp	x1, x0
	beq	.L1166
	ldr	x0, [x2]
	str	x0, [x1], 8
	str	x1, [sp, 184]
.L1167:
	ldr	x3, [sp, 176]
	ldr	w7, [x1, -4]
	sub	x2, x1, x3
	ldr	s1, [x1, -8]
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L1168
	.p2align 3,,7
.L1171:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s0, [x3, x2]
	fcmpe	s1, s0
	bgt	.L1200
.L1169:
	str	w7, [x4, 4]
	str	s1, [x4]
.L1165:
	add	x0, sp, 144
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x2, x0, [sp, 144]
	cmp	x0, x2
	bne	.L1172
	ldp	x2, x0, [sp, 176]
	cmp	x0, x2
	beq	.L1235
	ldr	w2, [sp, 124]
	ldr	x0, [x19, 24]
	ldr	x3, [x19, 256]
	mul	x2, x2, x0
	ldr	x1, [x19, 240]
	add	x0, x3, x2
	add	x0, x0, x1
	ldrb	w0, [x0, 2]
	tbz	x0, 0, .L1176
	ldr	x1, [x19, 232]
	mov	x0, x23
	ldr	x4, [x19, 304]
	add	x1, x2, x1
	ldr	x2, [x19, 312]
	add	x1, x3, x1
.LEHB97:
	blr	x4
	ldp	x1, x0, [sp, 184]
	str	s0, [sp, 140]
	cmp	x1, x0
	beq	.L1177
	ldr	w8, [sp, 124]
	add	x0, x1, 8
	str	s0, [x1]
	str	w8, [x1, 4]
	str	x0, [sp, 184]
.L1178:
	ldr	x3, [sp, 176]
	sub	x2, x0, x3
	asr	x7, x2, 3
	sub	x0, x7, #2
	sub	x1, x7, #1
	add	x0, x0, x0, lsr 63
	asr	x0, x0, 1
	cmp	x1, 0
	ble	.L1179
	.p2align 3,,7
.L1182:
	lsl	x2, x0, 3
	lsl	x1, x1, 3
	add	x5, x3, x2
	add	x4, x3, x1
	ldr	s1, [x3, x2]
	fcmpe	s1, s0
	bmi	.L1201
.L1180:
	ldr	x0, [x19, 72]
	str	s0, [x4]
	str	w8, [x4, 4]
	cmp	x0, x7
	bcc	.L1242
.L1176:
	ldr	w3, [sp, 120]
	add	x2, sp, 176
	mov	w1, w26
	mov	x0, x19
	mov	w4, 1
	bl	_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0
	ldr	x2, [sp, 176]
	mov	w24, w0
.L1235:
	ldr	x0, [sp, 192]
	sub	x1, x0, x2
	cbz	x2, .L1164
	mov	x0, x2
	bl	_ZdlPvm
.L1164:
	ldr	x0, [sp, 144]
	cbz	x0, .L1184
	ldr	x1, [sp, 160]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L1184:
	ldr	w0, [sp, 120]
	sub	w0, w0, #1
	str	w0, [sp, 120]
	cmn	w0, #1
	bne	.L1163
.L1147:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldr	d8, [sp, 96]
	ldp	x29, x30, [sp], 208
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1200:
	.cfi_restore_state
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L1171
	mov	x4, x5
	b	.L1169
	.p2align 2,,3
.L1201:
	sub	x2, x0, #1
	ldr	w6, [x5, 4]
	str	s1, [x3, x1]
	mov	x1, x0
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x0, x2, 1
	cmp	x1, 0
	bgt	.L1182
	mov	x4, x5
	ldr	x0, [x19, 72]
	str	s0, [x4]
	str	w8, [x4, 4]
	cmp	x0, x7
	bcs	.L1176
.L1242:
	add	x0, sp, 176
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	b	.L1176
	.p2align 2,,3
.L1166:
	add	x0, sp, 176
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x1, [sp, 184]
	b	.L1167
.L1168:
	sub	x2, x2, #8
	add	x4, x3, x2
	b	.L1169
.L1177:
	add	x3, sp, 124
	add	x2, sp, 140
	add	x0, sp, 176
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE97:
	ldr	x0, [sp, 184]
	ldr	w8, [x0, -4]
	ldr	s0, [x0, -8]
	b	.L1178
.L1179:
	sub	x0, x2, #8
	add	x4, x3, x0
	b	.L1180
.L1238:
.LEHB98:
	bl	_ZSt20__throw_system_errori
.L1237:
	mov	w0, 1
	bl	_ZSt20__throw_system_errori
.LEHE98:
.L1162:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC27
	mov	x19, x0
	add	x1, x1, :lo12:.LC27
.LEHB99:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE99:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x19
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB100:
	bl	__cxa_throw
.L1198:
	mov	x19, x0
	add	x0, sp, 176
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	add	x0, sp, 144
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE100:
.L1196:
	ldrb	w1, [sp, 184]
	mov	x19, x0
	cbz	w1, .L1236
	add	x0, sp, 176
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L1236
.L1197:
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	bl	__cxa_free_exception
.L1236:
	mov	x0, x19
.LEHB101:
	bl	_Unwind_Resume
.LEHE101:
	.cfi_endproc
.LFE7399:
	.section	.gcc_except_table
.LLSDA7399:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7399-.LLSDACSB7399
.LLSDACSB7399:
	.uleb128 .LEHB94-.LFB7399
	.uleb128 .LEHE94-.LEHB94
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB95-.LFB7399
	.uleb128 .LEHE95-.LEHB95
	.uleb128 .L1196-.LFB7399
	.uleb128 0
	.uleb128 .LEHB96-.LFB7399
	.uleb128 .LEHE96-.LEHB96
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB97-.LFB7399
	.uleb128 .LEHE97-.LEHB97
	.uleb128 .L1198-.LFB7399
	.uleb128 0
	.uleb128 .LEHB98-.LFB7399
	.uleb128 .LEHE98-.LEHB98
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB99-.LFB7399
	.uleb128 .LEHE99-.LEHB99
	.uleb128 .L1197-.LFB7399
	.uleb128 0
	.uleb128 .LEHB100-.LFB7399
	.uleb128 .LEHE100-.LEHB100
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB101-.LFB7399
	.uleb128 .LEHE101-.LEHB101
	.uleb128 0
	.uleb128 0
.LLSDACSE7399:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii, .-_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm,"axG",@progbits,_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm
	.type	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm, %function
_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm:
.LFB8194:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8194
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x1
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -16
	.cfi_offset 22, -8
	mov	x21, x0
	cmp	x1, 1
	beq	.L1265
	mov	x20, x2
	mov	x0, 1152921504606846975
	cmp	x1, x0
	bhi	.L1266
	lsl	x22, x1, 3
	mov	x0, x22
.LEHB102:
	bl	_Znwm
	mov	x20, x0
	mov	x2, x22
	mov	w1, 0
	bl	memset
	add	x8, x21, 48
.L1245:
	ldr	x4, [x21, 16]
	str	xzr, [x21, 16]
	cbz	x4, .L1247
	add	x7, x21, 16
	mov	x6, 0
	.p2align 3,,7
.L1248:
	ldr	w5, [x4, 8]
	mov	x3, x4
	ldr	x4, [x4]
	udiv	x2, x5, x19
	msub	x2, x2, x19, x5
	ldr	x1, [x20, x2, lsl 3]
	cbz	x1, .L1267
	ldr	x0, [x1]
	str	x0, [x3]
	ldr	x0, [x20, x2, lsl 3]
	str	x3, [x0]
	cbnz	x4, .L1248
.L1247:
	ldp	x0, x1, [x21]
	cmp	x0, x8
	beq	.L1251
	lsl	x1, x1, 3
	bl	_ZdlPvm
.L1251:
	stp	x20, x19, [x21]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1267:
	.cfi_restore_state
	ldr	x0, [x21, 16]
	str	x0, [x3]
	str	x3, [x21, 16]
	str	x7, [x20, x2, lsl 3]
	ldr	x0, [x3]
	cbz	x0, .L1254
	str	x3, [x20, x6, lsl 3]
	mov	x6, x2
	cbnz	x4, .L1248
	b	.L1247
	.p2align 2,,3
.L1254:
	mov	x6, x2
	cbnz	x4, .L1248
	b	.L1247
	.p2align 2,,3
.L1265:
	mov	x20, x0
	str	xzr, [x20, 48]!
	mov	x8, x20
	b	.L1245
.L1266:
	bl	_ZSt17__throw_bad_allocv
.LEHE102:
.L1255:
	bl	__cxa_begin_catch
	ldr	x0, [x20]
	str	x0, [x21, 40]
.LEHB103:
	bl	__cxa_rethrow
.LEHE103:
.L1256:
	mov	x19, x0
	bl	__cxa_end_catch
	mov	x0, x19
.LEHB104:
	bl	_Unwind_Resume
.LEHE104:
	.cfi_endproc
.LFE8194:
	.section	.gcc_except_table
	.align	2
.LLSDA8194:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT8194-.LLSDATTD8194
.LLSDATTD8194:
	.byte	0x1
	.uleb128 .LLSDACSE8194-.LLSDACSB8194
.LLSDACSB8194:
	.uleb128 .LEHB102-.LFB8194
	.uleb128 .LEHE102-.LEHB102
	.uleb128 .L1255-.LFB8194
	.uleb128 0x1
	.uleb128 .LEHB103-.LFB8194
	.uleb128 .LEHE103-.LEHB103
	.uleb128 .L1256-.LFB8194
	.uleb128 0
	.uleb128 .LEHB104-.LFB8194
	.uleb128 .LEHE104-.LEHB104
	.uleb128 0
	.uleb128 0
.LLSDACSE8194:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT8194:
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm,"axG",@progbits,_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm,comdat
	.size	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm, .-_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,comdat
	.align	2
	.p2align 4,,11
	.type	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0, %function
_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0:
.LFB8620:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8620
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	mov	x24, x1
	ldr	w1, [x1]
	ldr	x7, [x0, 8]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	uxtw	x20, w1
	mov	x19, x0
	str	x25, [sp, 64]
	.cfi_offset 25, -32
	mov	x25, x2
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	ldr	x2, [x0]
	udiv	x0, x20, x7
	msub	x0, x0, x7, x20
	lsl	x22, x0, 3
	ldr	x8, [x2, x0, lsl 3]
	cbz	x8, .L1269
	ldr	x4, [x8]
	ldr	w5, [x4, 8]
	cmp	w1, w5
	beq	.L1270
.L1294:
	ldr	x6, [x4]
	cbz	x6, .L1269
	ldr	w5, [x6, 8]
	mov	x8, x4
	uxtw	x9, w5
	udiv	x4, x9, x7
	msub	x4, x4, x7, x9
	cmp	x0, x4
	bne	.L1269
	mov	x4, x6
	cmp	w1, w5
	bne	.L1294
.L1270:
	ldr	x0, [x8]
	mov	x21, 0
	cbz	x0, .L1269
	mov	x1, x21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1269:
	.cfi_restore_state
	mov	x0, 16
.LEHB105:
	bl	_Znwm
.LEHE105:
	ldr	w4, [x24]
	mov	x23, x0
	ldr	x1, [x19, 8]
	mov	x3, x25
	ldr	x2, [x19, 24]
	add	x0, x19, 32
	ldr	x5, [x19, 40]
	str	xzr, [x23]
	str	w4, [x23, 8]
	str	x5, [sp, 88]
.LEHB106:
	bl	_ZNKSt8__detail20_Prime_rehash_policy14_M_need_rehashEmmm
	tst	w0, 255
	bne	.L1295
	ldr	x0, [x19]
	add	x2, x0, x22
	ldr	x1, [x0, x22]
	cbz	x1, .L1274
.L1296:
	ldr	x1, [x1]
	str	x1, [x23]
	ldr	x0, [x0, x22]
	str	x23, [x0]
.L1275:
	ldr	x1, [x19, 24]
	mov	x2, 1
	bfi	x21, x2, 0, 8
	mov	x0, x23
	add	x1, x1, x2
	str	x1, [x19, 24]
	mov	x1, x21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1295:
	.cfi_restore_state
	add	x2, sp, 88
	mov	x0, x19
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm
.LEHE106:
	ldr	x0, [x19, 8]
	udiv	x22, x20, x0
	msub	x22, x22, x0, x20
	ldr	x0, [x19]
	lsl	x22, x22, 3
	add	x2, x0, x22
	ldr	x1, [x0, x22]
	cbnz	x1, .L1296
.L1274:
	ldr	x1, [x19, 16]
	str	x1, [x23]
	str	x23, [x19, 16]
	cbz	x1, .L1276
	ldr	w4, [x1, 8]
	ldr	x3, [x19, 8]
	udiv	x1, x4, x3
	msub	x1, x1, x3, x4
	str	x23, [x0, x1, lsl 3]
.L1276:
	add	x0, x19, 16
	str	x0, [x2]
	b	.L1275
.L1279:
	mov	x1, 16
	mov	x19, x0
	mov	x0, x23
	bl	_ZdlPvm
	mov	x0, x19
.LEHB107:
	bl	_Unwind_Resume
.LEHE107:
	.cfi_endproc
.LFE8620:
	.section	.gcc_except_table
.LLSDA8620:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8620-.LLSDACSB8620
.LLSDACSB8620:
	.uleb128 .LEHB105-.LFB8620
	.uleb128 .LEHE105-.LEHB105
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB106-.LFB8620
	.uleb128 .LEHE106-.LEHB106
	.uleb128 .L1279-.LFB8620
	.uleb128 0
	.uleb128 .LEHB107-.LFB8620
	.uleb128 .LEHE107-.LEHB107
	.uleb128 0
	.uleb128 0
.LLSDACSE8620:
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,comdat
	.size	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0, .-_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf
	.type	_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf, %function
_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf:
.LFB7068:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA7068
	stp	x29, x30, [sp, -368]!
	.cfi_def_cfa_offset 368
	.cfi_offset 29, -368
	.cfi_offset 30, -360
	uxtw	x3, w2
	mov	x29, sp
	ldr	x5, [x0, 24]
	stp	d8, d9, [sp, 96]
	.cfi_offset 72, -272
	.cfi_offset 73, -264
	fmov	s8, s0
	ldr	x4, [x0, 232]
	str	w2, [sp, 172]
	ldr	x2, [x0, 296]
	stp	x19, x20, [sp, 16]
	madd	x3, x3, x5, x4
	.cfi_offset 19, -352
	.cfi_offset 20, -344
	mov	x19, x0
	str	x1, [sp, 160]
	ldr	x0, [x0, 256]
	add	x0, x0, x3
	bl	memcpy
	ldr	w2, [x19, 104]
	ldr	w0, [x19, 216]
	ldr	w1, [sp, 172]
	str	w2, [sp, 156]
	str	w0, [sp, 168]
	cmp	w1, w0
	beq	.L1475
.L1298:
	ldr	x0, [x19, 272]
	ldr	w0, [x0, w1, uxtw 2]
	str	w0, [sp, 152]
	tbnz	w0, #31, .L1300
	movi	v9.2s, 0x30, lsl 24
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -328
	.cfi_offset 21, -336
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -312
	.cfi_offset 23, -320
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -296
	.cfi_offset 25, -304
	mov	x25, 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -280
	.cfi_offset 27, -288
	str	d10, [sp, 112]
	.cfi_offset 74, -256
.L1312:
	add	x5, sp, 304
	add	x4, sp, 360
	fmov	s0, 1.0e+0
	mov	x3, 1
	add	x8, sp, 200
	mov	w2, w25
	mov	x0, x19
	stp	x5, x3, [sp, 256]
	stp	xzr, xzr, [sp, 272]
	str	s0, [sp, 288]
	stp	xzr, xzr, [sp, 296]
	stp	x4, x3, [sp, 312]
	stp	xzr, xzr, [sp, 328]
	str	s0, [sp, 344]
	stp	xzr, xzr, [sp, 352]
.LEHB108:
	bl	_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji
.LEHE108:
	ldp	x0, x1, [sp, 200]
	cmp	x0, x1
	beq	.L1476
	add	x1, sp, 172
	add	x0, sp, 256
	mov	x2, 1
.LEHB109:
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0
	ldp	x20, x23, [sp, 200]
	cmp	x23, x20
	beq	.L1335
	mov	w0, 1065353215
	mov	x27, 5
	fmov	s10, w0
	movk	x27, 0x2, lsl 32
	sub	x0, x25, #1
	str	x0, [sp, 144]
	.p2align 3,,7
.L1334:
	mov	x1, x20
	add	x0, sp, 256
	mov	x2, 1
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0
	ldr	x1, [x19, 432]
	mov	x0, 16807
	movi	v1.2s, #0
	fmov	s2, 1.0e+0
	mul	x1, x1, x0
	umulh	x2, x1, x27
	sub	x0, x1, x2
	add	x0, x2, x0, lsr 1
	lsr	x0, x0, 30
	lsl	x2, x0, 31
	sub	x0, x2, x0
	sub	x0, x1, x0
	str	x0, [x19, 432]
	sub	x0, x0, #1
	ucvtf	s0, x0
	fadd	s0, s0, s1
	fmul	s0, s0, s9
	fcmpe	s0, s2
	bge	.L1383
	fadd	s0, s0, s1
.L1316:
	fcmpe	s8, s0
	bmi	.L1319
	mov	x1, x20
	add	x0, sp, 312
	mov	x2, 1
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0
.LEHE109:
	ldr	w0, [x20]
	mov	w2, 48
	ldr	x1, [x19, 192]
	uxtw	x21, w0
	strb	wzr, [sp, 192]
	umaddl	x0, w0, w2, x1
	str	x0, [sp, 184]
	cbz	x0, .L1477
	adrp	x1, .LC5
	ldr	x24, [x1, #:lo12:.LC5]
	cbz	x24, .L1321
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1478
.L1321:
	mov	w0, 1
	strb	w0, [sp, 192]
	cbnz	x25, .L1322
	ldr	x1, [x19, 24]
	ldr	x0, [x19, 240]
	ldr	x26, [x19, 256]
	madd	x21, x21, x1, x0
	add	x26, x26, x21
	ldrh	w22, [x26]
	stp	xzr, xzr, [sp, 224]
	str	xzr, [sp, 240]
	cbz	w22, .L1324
.L1483:
	ubfiz	x22, x22, 2, 16
	mov	x0, x22
.LEHB110:
	bl	_Znwm
.LEHE110:
	add	x21, x0, x22
	mov	x2, x22
	mov	w1, 0
	str	x0, [sp, 136]
	str	x0, [sp, 224]
	str	x21, [sp, 240]
	bl	memset
	ldrb	w28, [sp, 192]
	mov	x2, x22
	ldr	x3, [sp, 136]
	add	x1, x26, 4
	str	x21, [sp, 232]
	mov	x0, x3
	bl	memcpy
	cbnz	w28, .L1381
.L1325:
	ldr	x22, [sp, 224]
	cmp	x22, x21
	beq	.L1328
	.p2align 3,,7
.L1332:
	mov	x1, x22
	add	x0, sp, 256
	mov	x2, 1
.LEHB111:
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0
.LEHE111:
	add	x22, x22, 4
	cmp	x21, x22
	bne	.L1332
	ldr	x21, [sp, 224]
.L1328:
	cbz	x21, .L1319
	ldr	x1, [sp, 240]
	mov	x0, x21
	sub	x1, x1, x21
	bl	_ZdlPvm
	.p2align 3,,7
.L1319:
	add	x20, x20, 4
	cmp	x23, x20
	bne	.L1334
.L1335:
	ldr	x21, [sp, 328]
	cbz	x21, .L1315
	sub	x0, x25, #1
	mov	w26, 48
	adrp	x27, .LC5
	str	x0, [sp, 136]
	.p2align 3,,7
.L1314:
	ldp	x2, x4, [sp, 256]
	ldr	w0, [x21, 8]
	uxtw	x1, w0
	udiv	x5, x1, x4
	msub	x5, x5, x4, x1
	ldr	x6, [x2, x5, lsl 3]
	stp	xzr, xzr, [sp, 224]
	str	xzr, [sp, 240]
	cbz	x6, .L1472
	ldr	x1, [x6]
	ldr	w2, [x1, 8]
	cmp	w2, w0
	beq	.L1339
.L1479:
	ldr	x3, [x1]
	cbz	x3, .L1472
	ldr	w2, [x3, 8]
	mov	x6, x1
	uxtw	x7, w2
	udiv	x1, x7, x4
	msub	x1, x1, x4, x7
	cmp	x5, x1
	bne	.L1472
	mov	x1, x3
	cmp	w2, w0
	bne	.L1479
.L1339:
	ldr	x2, [x6]
	ldr	x1, [sp, 280]
	sub	x22, x1, #1
	cbz	x2, .L1338
.L1341:
	ldr	x1, [x19, 72]
	ldr	x20, [sp, 272]
	cmp	x1, x22
	csel	x22, x1, x22, ls
	cbnz	x20, .L1360
	b	.L1342
	.p2align 2,,3
.L1345:
	ldr	s1, [x3]
	fcmpe	s1, s0
	bgt	.L1392
.L1352:
	ldr	x20, [x20]
	cbz	x20, .L1342
.L1344:
	ldr	w0, [x21, 8]
.L1360:
	ldr	w1, [x20, 8]
	add	x23, x20, 8
	cmp	w1, w0
	beq	.L1352
	ldr	x5, [x19, 24]
	uxtw	x1, w1
	ldr	x4, [x19, 232]
	uxtw	x0, w0
	ldp	x6, x2, [x19, 304]
	ldr	x3, [x19, 256]
	madd	x1, x1, x5, x4
	madd	x0, x0, x5, x4
	add	x1, x3, x1
	add	x0, x3, x0
.LEHB112:
	blr	x6
	ldp	x3, x1, [sp, 224]
	str	s0, [sp, 184]
	sub	x0, x1, x3
	cmp	x22, x0, asr 3
	bls	.L1345
	ldr	x0, [sp, 240]
	cmp	x1, x0
	beq	.L1346
	add	x0, x1, 8
	ldr	w7, [x20, 8]
	sub	x2, x0, x3
	str	s0, [x1]
	str	w7, [x1, 4]
	str	x0, [sp, 232]
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L1348
	.p2align 3,,7
.L1351:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s1, [x3, x2]
	fcmpe	s1, s0
	bmi	.L1391
	str	w7, [x4, 4]
	str	s0, [x4]
.L1482:
	ldr	x20, [x20]
	cbnz	x20, .L1344
.L1342:
	ldp	x3, x2, [x19, 56]
	cmp	x25, 0
	add	x1, sp, 224
	mov	x0, x19
	csel	x2, x3, x2, ne
	bl	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm
.LEHE112:
	ldr	w23, [x21, 8]
	ldr	x1, [x19, 192]
	uxtw	x0, w23
	umaddl	x23, w23, w26, x1
	cbz	x23, .L1480
	ldr	x24, [x27, #:lo12:.LC5]
	cbz	x24, .L1363
	mov	x0, x23
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1364
	ldr	w0, [x21, 8]
.L1363:
	cbnz	x25, .L1365
	ldr	x2, [x19, 24]
	ldr	x1, [x19, 240]
	ldr	x22, [x19, 256]
	madd	x0, x0, x2, x1
	add	x22, x22, x0
.L1366:
	ldp	x0, x20, [sp, 224]
	sub	x20, x20, x0
	asr	x20, x20, 3
	strh	w20, [x22]
	cbz	x20, .L1367
	mov	x28, 0
	b	.L1368
	.p2align 2,,3
.L1481:
	ldr	x0, [sp, 224]
.L1368:
	add	x28, x28, 1
	ldr	w2, [x0, 4]
	add	x0, sp, 224
	str	w2, [x22, x28, lsl 2]
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	cmp	x20, x28
	bne	.L1481
.L1367:
	cbz	x24, .L1369
	mov	x0, x23
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L1369:
	ldr	x0, [sp, 224]
	cbz	x0, .L1370
	ldr	x1, [sp, 240]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L1370:
	ldr	x21, [x21]
	cbnz	x21, .L1314
.L1315:
	ldr	x0, [sp, 200]
	cbz	x0, .L1337
	ldr	x1, [sp, 216]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L1337:
	ldr	x20, [sp, 328]
	cbz	x20, .L1374
	.p2align 3,,7
.L1371:
	mov	x0, x20
	mov	x1, 16
	ldr	x20, [x20]
	bl	_ZdlPvm
	cbnz	x20, .L1371
.L1374:
	ldp	x0, x2, [sp, 312]
	mov	w1, 0
	lsl	x2, x2, 3
	bl	memset
	ldp	x0, x1, [sp, 312]
	add	x2, sp, 360
	stp	xzr, xzr, [sp, 328]
	cmp	x0, x2
	beq	.L1372
	lsl	x1, x1, 3
	bl	_ZdlPvm
.L1372:
	ldr	x20, [sp, 272]
	cbz	x20, .L1377
	.p2align 3,,7
.L1375:
	mov	x0, x20
	mov	x1, 16
	ldr	x20, [x20]
	bl	_ZdlPvm
	cbnz	x20, .L1375
.L1377:
	ldp	x0, x2, [sp, 256]
	mov	w1, 0
	lsl	x2, x2, 3
	bl	memset
	ldp	x0, x1, [sp, 256]
	add	x2, sp, 304
	stp	xzr, xzr, [sp, 272]
	cmp	x0, x2
	beq	.L1311
	lsl	x1, x1, 3
	bl	_ZdlPvm
.L1311:
	ldr	w0, [sp, 152]
	add	x25, x25, 1
	ldr	w1, [sp, 172]
	cmp	w0, w25
	bge	.L1312
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldr	d10, [sp, 112]
	.cfi_restore 74
.L1300:
	mov	w3, w1
	ldr	w2, [sp, 168]
	ldp	w4, w5, [sp, 152]
	mov	x0, x19
	ldr	x1, [sp, 160]
.LEHB113:
	bl	_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii
.LEHE113:
.L1297:
	ldp	x19, x20, [sp, 16]
	ldp	d8, d9, [sp, 96]
	ldp	x29, x30, [sp], 368
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_restore 73
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1391:
	.cfi_def_cfa_offset 368
	.cfi_offset 19, -352
	.cfi_offset 20, -344
	.cfi_offset 21, -336
	.cfi_offset 22, -328
	.cfi_offset 23, -320
	.cfi_offset 24, -312
	.cfi_offset 25, -304
	.cfi_offset 26, -296
	.cfi_offset 27, -288
	.cfi_offset 28, -280
	.cfi_offset 29, -368
	.cfi_offset 30, -360
	.cfi_offset 72, -272
	.cfi_offset 73, -264
	.cfi_offset 74, -256
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s1, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L1351
	mov	x4, x5
	str	s0, [x4]
	str	w7, [x4, 4]
	b	.L1482
	.p2align 2,,3
.L1392:
	add	x0, sp, 224
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x1, x0, [sp, 232]
	cmp	x1, x0
	beq	.L1354
	ldr	s1, [sp, 184]
	add	x0, x1, 8
	ldr	w7, [x20, 8]
	str	w7, [x1, 4]
	str	s1, [x1]
	str	x0, [sp, 232]
.L1355:
	ldr	x3, [sp, 224]
	sub	x2, x0, x3
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L1356
	.p2align 3,,7
.L1359:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s0, [x3, x2]
	fcmpe	s0, s1
	bmi	.L1393
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L1352
	.p2align 2,,3
.L1393:
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L1359
	mov	x4, x5
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L1352
	.p2align 2,,3
.L1365:
	ldr	x1, [x19, 264]
	ldr	x22, [x19, 32]
	ldr	x0, [x1, x0, lsl 3]
	ldr	x1, [sp, 136]
	madd	x22, x1, x22, x0
	b	.L1366
.L1472:
	ldr	x1, [sp, 280]
.L1338:
	mov	x22, x1
	b	.L1341
	.p2align 2,,3
.L1346:
	mov	x3, x23
	add	x2, sp, 184
	add	x0, sp, 224
.LEHB114:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldp	x3, x0, [sp, 224]
	sub	x2, x0, x3
	ldr	w7, [x0, -4]
	ldr	s0, [x0, -8]
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	bgt	.L1351
.L1348:
	sub	x0, x2, #8
	add	x4, x3, x0
	str	s0, [x4]
	str	w7, [x4, 4]
	b	.L1482
	.p2align 2,,3
.L1354:
	mov	x3, x23
	add	x2, sp, 184
	add	x0, sp, 224
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE114:
	ldr	x0, [sp, 232]
	ldr	w7, [x0, -4]
	ldr	s1, [x0, -8]
	b	.L1355
.L1322:
	ldr	x0, [x19, 264]
	ldr	x26, [x19, 32]
	ldr	x0, [x0, x21, lsl 3]
	ldr	x1, [sp, 144]
	madd	x26, x1, x26, x0
	ldrh	w22, [x26]
	stp	xzr, xzr, [sp, 224]
	str	xzr, [sp, 240]
	cbnz	w22, .L1483
.L1324:
	mov	x21, 0
	stp	xzr, xzr, [sp, 224]
	str	xzr, [sp, 240]
.L1381:
	ldr	x0, [sp, 184]
	cbz	x0, .L1325
	cbz	x24, .L1325
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	ldr	x21, [sp, 232]
	b	.L1325
.L1383:
	fmov	s0, s10
	b	.L1316
.L1356:
	sub	x0, x2, #8
	add	x4, x3, x0
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L1352
.L1476:
	cbz	x0, .L1302
	ldr	x1, [sp, 216]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L1302:
	ldr	x20, [sp, 328]
	cbz	x20, .L1306
	.p2align 3,,7
.L1303:
	mov	x0, x20
	mov	x1, 16
	ldr	x20, [x20]
	bl	_ZdlPvm
	cbnz	x20, .L1303
.L1306:
	ldp	x0, x2, [sp, 312]
	mov	w1, 0
	lsl	x2, x2, 3
	bl	memset
	ldp	x0, x1, [sp, 312]
	add	x2, sp, 360
	stp	xzr, xzr, [sp, 328]
	cmp	x0, x2
	beq	.L1304
	lsl	x1, x1, 3
	bl	_ZdlPvm
.L1304:
	ldr	x20, [sp, 272]
	cbz	x20, .L1377
	.p2align 3,,7
.L1307:
	mov	x0, x20
	mov	x1, 16
	ldr	x20, [x20]
	bl	_ZdlPvm
	cbnz	x20, .L1307
	b	.L1377
.L1475:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 74
	add	x0, x19, 16
	ldar	x0, [x0]
	cmp	x0, 1
	beq	.L1297
	ldr	w1, [sp, 172]
	b	.L1298
.L1477:
	.cfi_offset 21, -336
	.cfi_offset 22, -328
	.cfi_offset 23, -320
	.cfi_offset 24, -312
	.cfi_offset 25, -304
	.cfi_offset 26, -296
	.cfi_offset 27, -288
	.cfi_offset 28, -280
	.cfi_offset 74, -256
	mov	w0, 1
.LEHB115:
	bl	_ZSt20__throw_system_errori
.LEHE115:
.L1364:
.LEHB116:
	bl	_ZSt20__throw_system_errori
.L1480:
	mov	w0, 1
	bl	_ZSt20__throw_system_errori
.LEHE116:
.L1478:
.LEHB117:
	bl	_ZSt20__throw_system_errori
.LEHE117:
.L1386:
	mov	x19, x0
.L1380:
	add	x0, sp, 312
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE5clearEv
	add	x0, sp, 312
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE21_M_deallocate_bucketsEv
	add	x0, sp, 256
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE5clearEv
	add	x0, sp, 256
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE21_M_deallocate_bucketsEv
	mov	x0, x19
.LEHB118:
	bl	_Unwind_Resume
.LEHE118:
.L1389:
	mov	x19, x0
	add	x0, sp, 224
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	mov	x1, x19
.L1331:
	add	x0, sp, 200
	mov	x19, x1
	bl	_ZNSt12_Vector_baseIjSaIjEED2Ev
	b	.L1380
.L1390:
	ldrb	w1, [sp, 192]
	mov	x19, x0
	cbz	w1, .L1473
	add	x0, sp, 184
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L1473:
	mov	x1, x19
	b	.L1331
.L1388:
	mov	x19, x0
	add	x0, sp, 224
	bl	_ZNSt12_Vector_baseIjSaIjEED2Ev
	mov	x1, x19
	b	.L1331
.L1387:
	mov	x1, x0
	b	.L1331
	.cfi_endproc
.LFE7068:
	.section	.gcc_except_table
.LLSDA7068:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7068-.LLSDACSB7068
.LLSDACSB7068:
	.uleb128 .LEHB108-.LFB7068
	.uleb128 .LEHE108-.LEHB108
	.uleb128 .L1386-.LFB7068
	.uleb128 0
	.uleb128 .LEHB109-.LFB7068
	.uleb128 .LEHE109-.LEHB109
	.uleb128 .L1387-.LFB7068
	.uleb128 0
	.uleb128 .LEHB110-.LFB7068
	.uleb128 .LEHE110-.LEHB110
	.uleb128 .L1390-.LFB7068
	.uleb128 0
	.uleb128 .LEHB111-.LFB7068
	.uleb128 .LEHE111-.LEHB111
	.uleb128 .L1388-.LFB7068
	.uleb128 0
	.uleb128 .LEHB112-.LFB7068
	.uleb128 .LEHE112-.LEHB112
	.uleb128 .L1389-.LFB7068
	.uleb128 0
	.uleb128 .LEHB113-.LFB7068
	.uleb128 .LEHE113-.LEHB113
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB114-.LFB7068
	.uleb128 .LEHE114-.LEHB114
	.uleb128 .L1389-.LFB7068
	.uleb128 0
	.uleb128 .LEHB115-.LFB7068
	.uleb128 .LEHE115-.LEHB115
	.uleb128 .L1387-.LFB7068
	.uleb128 0
	.uleb128 .LEHB116-.LFB7068
	.uleb128 .LEHE116-.LEHB116
	.uleb128 .L1389-.LFB7068
	.uleb128 0
	.uleb128 .LEHB117-.LFB7068
	.uleb128 .LEHE117-.LEHB117
	.uleb128 .L1387-.LFB7068
	.uleb128 0
	.uleb128 .LEHB118-.LFB7068
	.uleb128 .LEHE118-.LEHB118
	.uleb128 0
	.uleb128 0
.LLSDACSE7068:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf, .-_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf
	.section	.rodata._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi.str1.8,"aMS",@progbits,1
	.align	3
.LC28:
	.string	"Can't use addPoint to update deleted elements if replacement of deleted elements is enabled."
	.align	3
.LC29:
	.string	"The requested to undelete element is not deleted"
	.align	3
.LC30:
	.string	"The number of elements exceeds the specified limit"
	.align	3
.LC31:
	.string	"Not enough memory: addPoint failed to allocate linklist"
	.align	3
.LC32:
	.string	"cand error"
	.align	3
.LC33:
	.string	"Level error"
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
	.type	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi, %function
_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi:
.LFB7051:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA7051
	stp	x29, x30, [sp, -240]!
	.cfi_def_cfa_offset 240
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	adrp	x4, .LC5
	mov	x29, sp
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -176
	.cfi_offset 26, -168
	ldr	x26, [x4, #:lo12:.LC5]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	mov	x19, x0
	add	x0, x0, 320
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	mov	x23, x1
	str	w3, [sp, 128]
	str	x2, [sp, 152]
	str	x0, [sp, 208]
	strb	wzr, [sp, 216]
	cbz	x26, .L1485
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1721
.L1485:
	ldr	x6, [sp, 152]
	mov	w1, 1
	ldr	x4, [x19, 376]
	strb	w1, [sp, 216]
	ldr	x1, [x19, 368]
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -152
	.cfi_offset 27, -160
	add	x0, x19, 368
	udiv	x5, x6, x4
	msub	x5, x5, x4, x6
	ldr	x7, [x1, x5, lsl 3]
	cbz	x7, .L1486
	ldr	x2, [x7]
	ldr	x1, [x2, 8]
	cmp	x6, x1
	beq	.L1487
.L1722:
	ldr	x3, [x2]
	cbz	x3, .L1486
	ldr	x1, [x3, 8]
	mov	x7, x2
	udiv	x2, x1, x4
	msub	x2, x2, x4, x1
	cmp	x5, x2
	bne	.L1486
	mov	x2, x3
	cmp	x6, x1
	bne	.L1722
.L1487:
	ldr	x1, [x7]
	cbz	x1, .L1486
	ldrb	w0, [x19, 456]
	ldr	w27, [x1, 16]
	uxtw	x20, w27
	cbz	w0, .L1723
	ldr	x0, [x19, 24]
	ldr	x2, [x19, 256]
	ldr	x1, [x19, 240]
	madd	x0, x20, x0, x2
	add	x0, x0, x1
	ldrb	w0, [x0, 2]
	tbnz	x0, 0, .L1724
	ldr	x0, [sp, 208]
	cbz	x0, .L1502
	cbz	x26, .L1495
.L1738:
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L1495:
	strb	wzr, [sp, 216]
.L1494:
	ldr	x0, [x19, 24]
	ldr	x2, [x19, 256]
	ldr	x1, [x19, 240]
	madd	x0, x20, x0, x2
	add	x0, x0, x1
	ldrb	w0, [x0, 2]
	tbz	x0, 0, .L1502
	str	w27, [sp, 192]
	add	x0, x19, 16
	ldar	x0, [x0]
	cmp	x0, x20
	bls	.L1725
	ldr	w1, [sp, 192]
	ldr	x3, [x19, 24]
	ldr	x2, [x19, 240]
	ldr	x0, [x19, 256]
	madd	x1, x1, x3, x2
	add	x0, x0, x1
	ldrb	w1, [x0, 2]
	tbz	x1, 0, .L1498
	and	w1, w1, -2
	strb	w1, [x0, 2]
	add	x0, x19, 40
.L1745:
	ldaxr	x1, [x0]
	sub	x1, x1, #1
	stlxr	w2, x1, [x0]
	cbnz	w2, .L1745
	ldrb	w0, [x19, 456]
	cbnz	w0, .L1726
.L1502:
	fmov	s0, 1.0e+0
	mov	x1, x23
	mov	x0, x19
	mov	w2, w27
.LEHB119:
	bl	_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf
	ldrb	w0, [sp, 216]
	cbnz	w0, .L1727
.L1484:
	mov	w0, w27
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	.cfi_remember_state
	.cfi_restore 28
	.cfi_restore 27
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1486:
	.cfi_restore_state
	add	x1, x19, 16
	ldar	x2, [x1]
	ldr	x3, [x19, 8]
	cmp	x3, x2
	bls	.L1728
	ldar	x20, [x1]
	str	x20, [sp, 144]
	mov	w27, w20
.L1744:
	ldaxr	x2, [x1]
	add	x2, x2, 1
	stlxr	w3, x2, [x1]
	cbnz	w3, .L1744
	add	x1, sp, 152
	bl	_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_
.LEHE119:
	ldrb	w1, [sp, 216]
	str	w20, [x0]
	cbnz	w1, .L1729
.L1507:
	ldr	x2, [sp, 144]
	strb	wzr, [sp, 184]
	ldr	x1, [x19, 192]
	and	x20, x2, 4294967295
	ubfiz	x0, x2, 1, 32
	add	x0, x0, x2, uxtw
	add	x0, x1, x0, lsl 4
	str	x0, [sp, 176]
	cbz	x0, .L1730
	cbz	x26, .L1509
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1731
.L1509:
	ldr	x1, [x19, 424]
	mov	x4, 16807
	mov	x3, 5
	mov	x0, 281474968322048
	movk	x3, 0x2, lsl 32
	movk	x0, 0x41df, lsl 48
	mul	x1, x1, x4
	fmov	d3, x0
	mov	x0, 281474959933440
	movi	d4, #0
	movk	x0, 0x43cf, lsl 48
	fmov	d2, x0
	mov	w0, 1
	strb	w0, [sp, 184]
	umulh	x2, x1, x3
	str	d8, [sp, 96]
	.cfi_offset 72, -144
	fmov	d5, 1.0e+0
	ldr	d8, [x19, 88]
	sub	x0, x1, x2
	add	x0, x2, x0, lsr 1
	lsr	x0, x0, 30
	lsl	x2, x0, 31
	sub	x0, x2, x0
	sub	x0, x1, x0
	sub	x2, x0, #1
	mul	x1, x0, x4
	ucvtf	d0, x2
	umulh	x2, x1, x3
	fadd	d1, d0, d4
	sub	x0, x1, x2
	add	x0, x2, x0, lsr 1
	lsr	x0, x0, 30
	lsl	x2, x0, 31
	sub	x0, x2, x0
	sub	x0, x1, x0
	str	x0, [x19, 424]
	sub	x0, x0, #1
	ucvtf	d0, x0
	fmadd	d0, d0, d3, d1
	fdiv	d0, d0, d2
	fcmpe	d0, d5
	bge	.L1572
	fadd	d0, d0, d4
.L1510:
	bl	log
	ldr	w0, [sp, 128]
	cmp	w0, 0
	bgt	.L1511
	fnmul	d0, d0, d8
	fcvtzs	w0, d0
	str	w0, [sp, 128]
.L1511:
	ldr	x1, [x19, 272]
	add	x0, x19, 144
	ldr	w2, [sp, 128]
	str	w2, [x1, x20, lsl 2]
	str	x0, [sp, 192]
	strb	wzr, [sp, 200]
	cbz	x26, .L1513
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1732
.L1513:
	ldr	w0, [x19, 104]
	mov	w1, w0
	mov	w0, 1
	str	w1, [sp, 136]
	strb	w0, [sp, 200]
	mov	w0, w1
	ldr	w1, [sp, 128]
	cmp	w0, w1
	blt	.L1514
	ldr	x0, [sp, 192]
	cbz	x0, .L1514
	cbz	x26, .L1515
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L1515:
	strb	wzr, [sp, 200]
.L1514:
	ldr	x2, [x19, 24]
	mov	w1, 0
	ldr	x0, [x19, 240]
	ldr	x3, [x19, 256]
	madd	x0, x2, x20, x0
	ldr	w24, [x19, 216]
	str	w24, [sp, 168]
	add	x0, x3, x0
	bl	memset
	ldp	x2, x3, [x19, 248]
	mov	x1, x23
	ldr	x0, [x19, 24]
	madd	x0, x20, x0, x3
	ldr	x3, [sp, 152]
	str	x3, [x0, x2]
	ldr	x0, [x19, 24]
	ldr	x4, [x19, 232]
	ldr	x3, [x19, 256]
	ldr	x2, [x19, 296]
	madd	x0, x20, x0, x4
	add	x0, x3, x0
	bl	memcpy
	ldr	w0, [sp, 128]
	cbnz	w0, .L1733
.L1516:
	cmn	w24, #1
	beq	.L1518
	ldr	w0, [sp, 128]
	ldr	w20, [sp, 136]
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	ldr	x4, [x19, 24]
	ldr	x3, [x19, 256]
	cmp	w20, w0
	ble	.L1519
	ldr	x6, [x19, 232]
	uxtw	x1, w24
	ldp	x5, x2, [x19, 304]
	mov	x0, x23
	madd	x1, x1, x4, x6
	add	x1, x3, x1
.LEHB120:
	blr	x5
.LEHE120:
	sxtw	x0, w20
	fmov	s8, s0
	sub	x0, x0, #1
	add	x28, x19, 192
	str	x0, [sp, 120]
	sub	w0, w20, #1
	str	w0, [sp, 132]
	.p2align 3,,7
.L1531:
	ldr	w0, [sp, 132]
	str	w0, [sp, 140]
	.p2align 3,,7
.L1529:
	ldr	x0, [x28]
	mov	w1, 48
	strb	wzr, [sp, 216]
	umaddl	x0, w24, w1, x0
	str	x0, [sp, 208]
	cbz	x0, .L1734
	cbz	x26, .L1521
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1735
.L1521:
	mov	w1, 1
	strb	w1, [sp, 216]
	ldr	x0, [x19, 32]
	ldr	x2, [sp, 120]
	ldr	x1, [x19, 264]
	mul	x0, x2, x0
	ldr	x1, [x1, w24, uxtw 3]
	add	x20, x1, x0
	ldrh	w22, [x1, x0]
	cbz	w22, .L1522
	sub	w22, w22, #1
	add	x0, x20, 8
	add	x20, x20, 4
	mov	w25, 0
	add	x22, x0, x22, uxtw 2
	.p2align 3,,7
.L1526:
	ldr	w21, [x20]
	ldr	x0, [x19, 8]
	uxtw	x1, w21
	cmp	x1, x0
	bhi	.L1736
	ldr	x5, [x19, 24]
	mov	x0, x23
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	madd	x1, x1, x5, x4
	ldr	x4, [x19, 256]
	add	x1, x4, x1
.LEHB121:
	blr	x3
.LEHE121:
	fcmpe	s0, s8
	bmi	.L1587
.L1524:
	add	x20, x20, 4
	cmp	x22, x20
	bne	.L1526
	ldrb	w0, [sp, 216]
	cbnz	w0, .L1737
.L1527:
	cbnz	w25, .L1529
.L1569:
	ldr	w0, [sp, 132]
	ldr	w1, [sp, 140]
	sub	w0, w0, #1
	str	w0, [sp, 132]
	ldr	x0, [sp, 120]
	sub	x0, x0, #1
	str	x0, [sp, 120]
	ldr	w0, [sp, 128]
	cmp	w0, w1
	blt	.L1531
	ldr	w0, [sp, 168]
	ldr	x3, [x19, 24]
	ldr	x2, [x19, 256]
	ldr	x1, [x19, 240]
	madd	x0, x0, x3, x2
	add	x0, x0, x1
	ldrb	w21, [x0, 2]
	ldr	w0, [sp, 128]
	and	w21, w21, 1
	tbnz	w0, #31, .L1717
	mov	w20, w0
	b	.L1536
.L1723:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
	ldr	x0, [sp, 208]
	cbz	x0, .L1494
	cbnz	x26, .L1738
	b	.L1495
.L1727:
	ldr	x0, [sp, 208]
	cbz	x0, .L1484
	cbz	x26, .L1484
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	mov	w0, w27
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	.cfi_remember_state
	.cfi_restore 28
	.cfi_restore 27
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1726:
	.cfi_restore_state
	add	x20, x19, 464
	cbz	x26, .L1500
	mov	x0, x20
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1739
.L1500:
	add	x2, sp, 192
	add	x0, x19, 512
	mov	w1, 0
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj
	cbz	x26, .L1502
	mov	x0, x20
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	b	.L1502
.L1729:
	ldr	x0, [sp, 208]
	cbz	x0, .L1507
	cbz	x26, .L1507
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	b	.L1507
	.p2align 2,,3
.L1737:
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 72, -144
	ldr	x0, [sp, 208]
	cbz	x0, .L1527
.L1570:
	cbz	x26, .L1527
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	cbnz	w25, .L1529
	b	.L1569
	.p2align 2,,3
.L1587:
	fmov	s8, s0
	mov	w24, w21
	mov	w25, 1
	b	.L1524
	.p2align 2,,3
.L1522:
	ldr	x0, [sp, 208]
	cbz	x0, .L1569
	mov	w25, 0
	b	.L1570
.L1519:
	ldr	w0, [sp, 168]
	ldr	x1, [x19, 240]
	ldr	w2, [sp, 136]
	madd	x0, x0, x4, x3
	mov	w20, w2
	add	x0, x0, x1
	ldrb	w21, [x0, 2]
	and	w21, w21, 1
	tbnz	w2, #31, .L1718
	.p2align 3,,7
.L1536:
	mov	w1, w24
	add	x8, sp, 208
	mov	w3, w20
	mov	x2, x23
	mov	x0, x19
.LEHB122:
	bl	_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi
.LEHE122:
	cbz	w21, .L1538
	ldr	w1, [sp, 168]
	mov	x0, x23
	ldr	x5, [x19, 24]
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	madd	x1, x1, x5, x4
	ldr	x4, [x19, 256]
	add	x1, x4, x1
.LEHB123:
	blr	x3
	ldp	x1, x0, [sp, 216]
	str	s0, [sp, 172]
	cmp	x1, x0
	beq	.L1539
	ldr	w8, [sp, 168]
	add	x0, x1, 8
	str	s0, [x1]
	str	w8, [x1, 4]
	str	x0, [sp, 216]
.L1540:
	ldr	x3, [sp, 208]
	sub	x2, x0, x3
	asr	x7, x2, 3
	sub	x0, x7, #2
	sub	x1, x7, #1
	add	x0, x0, x0, lsr 63
	asr	x0, x0, 1
	cmp	x1, 0
	ble	.L1541
	.p2align 3,,7
.L1544:
	lsl	x2, x0, 3
	lsl	x1, x1, 3
	add	x5, x3, x2
	add	x4, x3, x1
	ldr	s1, [x3, x2]
	fcmpe	s1, s0
	bmi	.L1588
.L1542:
	ldr	x0, [x19, 72]
	str	s0, [x4]
	str	w8, [x4, 4]
	cmp	x0, x7
	bcc	.L1740
.L1538:
	mov	w3, w20
	add	x2, sp, 208
	mov	w1, w27
	mov	x0, x19
	mov	w4, 0
	bl	_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0
.LEHE123:
	ldr	x1, [sp, 208]
	mov	w24, w0
	cbz	x1, .L1546
	ldr	x2, [sp, 224]
	mov	x0, x1
	sub	x1, x2, x1
	bl	_ZdlPvm
.L1546:
	subs	w20, w20, #1
	bmi	.L1718
	ldr	w0, [sp, 136]
	cmp	w0, w20
	bge	.L1536
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC33
	mov	x20, x0
	add	x1, x1, :lo12:.LC33
.LEHB124:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE124:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB125:
	bl	__cxa_throw
.LEHE125:
	.p2align 2,,3
.L1588:
	sub	x2, x0, #1
	ldr	w6, [x5, 4]
	str	s1, [x3, x1]
	mov	x1, x0
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x0, x2, 1
	cmp	x1, 0
	bgt	.L1544
	mov	x4, x5
	ldr	x0, [x19, 72]
	str	s0, [x4]
	str	w8, [x4, 4]
	cmp	x0, x7
	bcs	.L1538
.L1740:
	add	x0, sp, 208
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	b	.L1538
.L1718:
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
.L1533:
	ldr	w0, [sp, 128]
	ldr	w1, [sp, 136]
	cmp	w1, w0
	bge	.L1550
	str	w0, [x19, 104]
	ldr	w0, [sp, 144]
	str	w0, [x19, 216]
.L1550:
	ldrb	w0, [sp, 200]
	cbnz	w0, .L1741
.L1551:
	ldrb	w0, [sp, 184]
	cbnz	w0, .L1742
.L1716:
	mov	w0, w27
	ldr	d8, [sp, 96]
	.cfi_remember_state
	.cfi_restore 72
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L1742:
	.cfi_restore_state
	ldr	x0, [sp, 176]
	cbz	x0, .L1716
	cbz	x26, .L1716
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	ldr	d8, [sp, 96]
	.cfi_restore 72
	b	.L1484
.L1539:
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 72, -144
	add	x3, sp, 168
	add	x2, sp, 172
	add	x0, sp, 208
.LEHB126:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE126:
	ldr	x0, [sp, 216]
	ldr	w8, [x0, -4]
	ldr	s0, [x0, -8]
	b	.L1540
.L1741:
	.cfi_restore 21
	.cfi_restore 22
	ldr	x0, [sp, 192]
	cbz	x0, .L1551
	cbz	x26, .L1551
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	b	.L1551
.L1518:
	ldr	w0, [sp, 128]
	str	w0, [x19, 104]
	str	wzr, [x19, 216]
	b	.L1533
.L1733:
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	ldrsw	x21, [sp, 128]
	ldr	x0, [x19, 32]
	ldr	x22, [x19, 264]
	mul	x21, x21, x0
	add	x21, x21, 1
	mov	x0, x21
	bl	malloc
	str	x0, [x22, x20, lsl 3]
	cbz	x0, .L1743
	mov	x2, x21
	mov	w1, 0
	bl	memset
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	b	.L1516
.L1717:
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	ldp	x21, x22, [sp, 32]
	.cfi_remember_state
	.cfi_restore 22
	.cfi_restore 21
	b	.L1550
.L1541:
	.cfi_restore_state
	sub	x0, x2, #8
	add	x4, x3, x0
	b	.L1542
.L1572:
	.cfi_restore 21
	.cfi_restore 22
	mov	x0, 4607182418800017407
	fmov	d0, x0
	b	.L1510
.L1732:
.LEHB127:
	bl	_ZSt20__throw_system_errori
.LEHE127:
.L1731:
	.cfi_restore 72
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	str	d8, [sp, 96]
	.cfi_offset 72, -144
.LEHB128:
	bl	_ZSt20__throw_system_errori
.LEHE128:
.L1735:
.LEHB129:
	bl	_ZSt20__throw_system_errori
.L1734:
	mov	w0, 1
	bl	_ZSt20__throw_system_errori
.LEHE129:
.L1721:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 72
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -152
	.cfi_offset 27, -160
	str	d8, [sp, 96]
	.cfi_offset 72, -144
.LEHB130:
	bl	_ZSt20__throw_system_errori
.L1725:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
	stp	x21, x22, [sp, 32]
	.cfi_remember_state
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	str	d8, [sp, 96]
	.cfi_offset 72, -144
	bl	_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj.part.0
.L1730:
	.cfi_restore_state
	mov	w0, 1
	stp	x21, x22, [sp, 32]
	.cfi_remember_state
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	str	d8, [sp, 96]
	.cfi_offset 72, -144
	bl	_ZSt20__throw_system_errori
.LEHE130:
.L1739:
	.cfi_restore_state
.LEHB131:
	bl	_ZSt20__throw_system_errori
.LEHE131:
.L1585:
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 72, -144
	mov	x19, x0
	add	x0, sp, 208
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
.L1556:
	ldrb	w0, [sp, 200]
	cbz	w0, .L1563
	add	x0, sp, 192
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L1563:
	ldrb	w0, [sp, 184]
	cbz	w0, .L1564
	add	x0, sp, 176
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L1564:
	mov	x0, x19
.LEHB132:
	bl	_Unwind_Resume
.LEHE132:
.L1579:
	.cfi_restore 21
	.cfi_restore 22
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	b	.L1563
.L1584:
.L1720:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
	b	.L1556
.L1583:
	mov	x19, x0
.L1558:
	ldrb	w0, [sp, 216]
	cbz	w0, .L1556
	add	x0, sp, 208
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L1556
.L1736:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC32
	mov	x20, x0
	add	x1, x1, :lo12:.LC32
.LEHB133:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE133:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB134:
	bl	__cxa_throw
.LEHE134:
.L1582:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
	b	.L1558
.L1580:
	mov	x19, x0
	b	.L1556
.L1743:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC31
	mov	x20, x0
	add	x1, x1, :lo12:.LC31
.LEHB135:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE135:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB136:
	bl	__cxa_throw
.LEHE136:
.L1728:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC30
	mov	x20, x0
	add	x1, x1, :lo12:.LC30
.LEHB137:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE137:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB138:
	bl	__cxa_throw
.LEHE138:
.L1576:
	mov	x19, x0
	b	.L1504
.L1498:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC29
	mov	x20, x0
	add	x1, x1, :lo12:.LC29
.LEHB139:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE139:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB140:
	bl	__cxa_throw
.LEHE140:
.L1724:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC28
	mov	x20, x0
	add	x1, x1, :lo12:.LC28
.LEHB141:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE141:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB142:
	bl	__cxa_throw
.LEHE142:
.L1581:
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 72, -144
	b	.L1720
.L1578:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
.L1719:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
.L1504:
	ldrb	w0, [sp, 216]
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	str	d8, [sp, 96]
	.cfi_offset 72, -144
	cbz	w0, .L1564
	add	x0, sp, 208
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L1564
.L1586:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
	b	.L1719
.L1577:
	b	.L1719
	.cfi_endproc
.LFE7051:
	.section	.gcc_except_table
.LLSDA7051:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7051-.LLSDACSB7051
.LLSDACSB7051:
	.uleb128 .LEHB119-.LFB7051
	.uleb128 .LEHE119-.LEHB119
	.uleb128 .L1576-.LFB7051
	.uleb128 0
	.uleb128 .LEHB120-.LFB7051
	.uleb128 .LEHE120-.LEHB120
	.uleb128 .L1580-.LFB7051
	.uleb128 0
	.uleb128 .LEHB121-.LFB7051
	.uleb128 .LEHE121-.LEHB121
	.uleb128 .L1583-.LFB7051
	.uleb128 0
	.uleb128 .LEHB122-.LFB7051
	.uleb128 .LEHE122-.LEHB122
	.uleb128 .L1580-.LFB7051
	.uleb128 0
	.uleb128 .LEHB123-.LFB7051
	.uleb128 .LEHE123-.LEHB123
	.uleb128 .L1585-.LFB7051
	.uleb128 0
	.uleb128 .LEHB124-.LFB7051
	.uleb128 .LEHE124-.LEHB124
	.uleb128 .L1584-.LFB7051
	.uleb128 0
	.uleb128 .LEHB125-.LFB7051
	.uleb128 .LEHE125-.LEHB125
	.uleb128 .L1580-.LFB7051
	.uleb128 0
	.uleb128 .LEHB126-.LFB7051
	.uleb128 .LEHE126-.LEHB126
	.uleb128 .L1585-.LFB7051
	.uleb128 0
	.uleb128 .LEHB127-.LFB7051
	.uleb128 .LEHE127-.LEHB127
	.uleb128 .L1579-.LFB7051
	.uleb128 0
	.uleb128 .LEHB128-.LFB7051
	.uleb128 .LEHE128-.LEHB128
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB129-.LFB7051
	.uleb128 .LEHE129-.LEHB129
	.uleb128 .L1580-.LFB7051
	.uleb128 0
	.uleb128 .LEHB130-.LFB7051
	.uleb128 .LEHE130-.LEHB130
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB131-.LFB7051
	.uleb128 .LEHE131-.LEHB131
	.uleb128 .L1576-.LFB7051
	.uleb128 0
	.uleb128 .LEHB132-.LFB7051
	.uleb128 .LEHE132-.LEHB132
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB133-.LFB7051
	.uleb128 .LEHE133-.LEHB133
	.uleb128 .L1582-.LFB7051
	.uleb128 0
	.uleb128 .LEHB134-.LFB7051
	.uleb128 .LEHE134-.LEHB134
	.uleb128 .L1583-.LFB7051
	.uleb128 0
	.uleb128 .LEHB135-.LFB7051
	.uleb128 .LEHE135-.LEHB135
	.uleb128 .L1581-.LFB7051
	.uleb128 0
	.uleb128 .LEHB136-.LFB7051
	.uleb128 .LEHE136-.LEHB136
	.uleb128 .L1580-.LFB7051
	.uleb128 0
	.uleb128 .LEHB137-.LFB7051
	.uleb128 .LEHE137-.LEHB137
	.uleb128 .L1578-.LFB7051
	.uleb128 0
	.uleb128 .LEHB138-.LFB7051
	.uleb128 .LEHE138-.LEHB138
	.uleb128 .L1576-.LFB7051
	.uleb128 0
	.uleb128 .LEHB139-.LFB7051
	.uleb128 .LEHE139-.LEHB139
	.uleb128 .L1586-.LFB7051
	.uleb128 0
	.uleb128 .LEHB140-.LFB7051
	.uleb128 .LEHE140-.LEHB140
	.uleb128 .L1576-.LFB7051
	.uleb128 0
	.uleb128 .LEHB141-.LFB7051
	.uleb128 .LEHE141-.LEHB141
	.uleb128 .L1577-.LFB7051
	.uleb128 0
	.uleb128 .LEHB142-.LFB7051
	.uleb128 .LEHE142-.LEHB142
	.uleb128 .L1576-.LFB7051
	.uleb128 0
.LLSDACSE7051:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi, .-_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
	.section	.rodata.str1.8
	.align	3
.LC34:
	.string	"cannot create std::vector larger than max_size()"
	.align	3
.LC35:
	.string	"Not enough memory"
	.align	3
.LC36:
	.string	"Not enough memory: HierarchicalNSW failed to allocate linklists"
	.text
	.align	2
	.p2align 4,,11
	.global	_Z11build_indexPfmm
	.type	_Z11build_indexPfmm, %function
_Z11build_indexPfmm:
.LFB6253:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6253
	sub	sp, sp, #1232
	.cfi_def_cfa_offset 1232
	adrp	x3, _ZTVN7hnswlib17InnerProductSpaceE+16
	add	x3, x3, :lo12:_ZTVN7hnswlib17InnerProductSpaceE+16
	stp	x29, x30, [sp]
	.cfi_offset 29, -1232
	.cfi_offset 30, -1224
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -1200
	.cfi_offset 22, -1192
	mov	x21, x1
	adrp	x1, _ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_
	add	x1, x1, :lo12:_ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	.cfi_offset 19, -1216
	.cfi_offset 20, -1208
	.cfi_offset 23, -1184
	.cfi_offset 24, -1176
	lsl	x23, x2, 2
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	.cfi_offset 25, -1168
	.cfi_offset 26, -1160
	.cfi_offset 27, -1152
	.cfi_offset 28, -1144
	str	x0, [sp, 96]
	mov	x0, 568
	stp	x3, x1, [sp, 144]
	stp	x23, x2, [sp, 160]
.LEHB143:
	bl	_Znwm
.LEHE143:
	mov	x19, x0
	add	x22, x0, 120
	adrp	x1, _ZTVN7hnswlib15HierarchicalNSWIfEE+16
	add	x1, x1, :lo12:_ZTVN7hnswlib15HierarchicalNSWIfEE+16
	mov	x0, 3145728
	stp	x1, xzr, [x19]
	stp	xzr, xzr, [x19, 16]
	stp	xzr, xzr, [x19, 32]
	stp	xzr, xzr, [x19, 48]
	stp	xzr, xzr, [x19, 64]
	str	xzr, [x19, 80]
	stp	xzr, xzr, [x19, 88]
	str	wzr, [x19, 104]
	stp	xzr, xzr, [x19, 112]
	stp	xzr, xzr, [x22, 8]
.LEHB144:
	bl	_Znwm
.LEHE144:
	str	x0, [x19, 120]
	mov	x2, 3145728
	add	x20, x0, x2
	str	x20, [x22, 16]
	mov	w1, 0
	bl	memset
	str	x20, [x22, 8]
	mov	x1, -6148914691236517206
	stp	xzr, xzr, [x19, 144]
	movk	x1, 0x2aa, lsl 48
	stp	xzr, xzr, [x19, 160]
	stp	xzr, xzr, [x19, 176]
	cmp	x21, x1
	bhi	.L1887
	add	x28, x19, 192
	str	xzr, [x19, 192]
	add	x20, x21, x21, lsl 1
	stp	xzr, xzr, [x28, 8]
	lsl	x20, x20, 4
	cbz	x21, .L1748
	mov	x0, x20
.LEHB145:
	bl	_Znwm
.LEHE145:
	str	x0, [x19, 192]
	mov	x2, x20
	add	x20, x0, x20
	str	x20, [x28, 16]
	add	x25, x19, 272
	mov	w1, 0
	str	x25, [sp, 120]
	bl	memset
	str	x20, [x28, 8]
	lsl	x24, x21, 2
	str	wzr, [x19, 216]
	mov	x0, x24
	stp	xzr, xzr, [x19, 224]
	stp	xzr, xzr, [x19, 240]
	stp	xzr, xzr, [x19, 256]
	str	xzr, [x19, 272]
	stp	xzr, xzr, [x25, 8]
.LEHB146:
	bl	_Znwm
.LEHE146:
	str	x0, [x19, 272]
	add	x20, x0, x24
	str	x20, [x25, 16]
	mov	x2, x24
	mov	w1, 0
	bl	memset
.L1805:
	ldr	x0, [sp, 120]
	add	x27, x19, 512
	fmov	s0, 1.0e+0
	add	x4, x19, 416
	add	x2, x19, 560
	add	x3, x19, 368
	str	x20, [x0, 8]
	mov	x0, 1
	str	xzr, [x19, 296]
	str	xzr, [x19, 312]
	stp	xzr, xzr, [x19, 320]
	stp	xzr, xzr, [x19, 336]
	stp	xzr, xzr, [x19, 352]
	stp	x4, x0, [x19, 368]
	stp	xzr, xzr, [x19, 384]
	str	s0, [x19, 400]
	stp	xzr, xzr, [x19, 408]
	stp	x0, x0, [x19, 424]
	stp	xzr, xzr, [x19, 440]
	strb	wzr, [x19, 456]
	stp	xzr, xzr, [x19, 464]
	stp	xzr, xzr, [x19, 480]
	stp	xzr, xzr, [x19, 496]
	str	x2, [x19, 512]
	str	x0, [x27, 8]
	str	xzr, [x19, 528]
	str	xzr, [x27, 24]
	str	s0, [x27, 32]
	stp	xzr, xzr, [x27, 40]
	str	x21, [x19, 8]
	stp	x3, x4, [sp, 128]
	add	x0, x19, 40
	stlr	xzr, [x0]
	ldp	x6, x1, [sp, 152]
	add	x5, sp, 168
	ldr	x0, [x19, 8]
	mov	x10, 32
	mov	x9, 150
	mov	x8, 10
	mov	x4, 100
	mov	x3, 101
	add	x2, x1, 140
	add	x7, x1, 132
	mov	x20, 16
	str	x2, [x19, 24]
	stp	x20, x20, [x19, 48]
	mul	x0, x2, x0
	mov	x2, 132
	stp	x10, x9, [x19, 64]
	str	x8, [x19, 80]
	stp	x2, x2, [x19, 224]
	stp	xzr, x7, [x19, 240]
	stp	x1, x6, [x19, 296]
	str	x5, [x19, 312]
	stp	x4, x3, [x19, 424]
	bl	malloc
	str	x0, [x19, 256]
	cbz	x0, .L1888
	add	x0, x19, 16
	stlr	xzr, [x0]
	mov	x0, 136
.LEHB147:
	bl	_Znwm
.LEHE147:
	mov	x20, x0
	mov	x1, 8
	mov	x24, x20
	add	x25, x20, 48
	mov	x0, 64
	str	xzr, [x24], 16
	str	xzr, [x20, 16]
	stp	xzr, xzr, [x24, 8]
	str	xzr, [x24, 24]
	str	xzr, [x20, 48]
	stp	xzr, xzr, [x25, 8]
	str	xzr, [x25, 24]
	str	x1, [x20, 8]
.LEHB148:
	bl	_Znwm
.LEHE148:
	ldr	x1, [x20, 8]
	mov	x26, x0
	str	x26, [x20]
	mov	x0, 512
	sub	x1, x1, #1
	lsr	x1, x1, 1
	add	x3, x26, x1, lsl 3
	stp	x3, x1, [sp, 104]
.LEHB149:
	bl	_Znwm
.LEHE149:
	ldp	x4, x2, [sp, 104]
	add	x3, x0, 512
	stp	x0, x3, [x24, 8]
	mov	x1, x0
	str	x4, [x24, 24]
	stp	x1, x3, [x25, 8]
	str	x4, [x25, 24]
	str	x0, [x26, x2, lsl 3]
	mov	x0, 24
	str	x1, [x20, 16]
	str	x1, [x20, 48]
	stp	xzr, xzr, [x20, 80]
	stp	xzr, xzr, [x20, 96]
	stp	xzr, xzr, [x20, 112]
	str	w21, [x20, 128]
.LEHB150:
	bl	_Znwm
.LEHE150:
	mov	x26, x0
	ldr	w1, [x20, 128]
	mov	w2, -1
	strh	w2, [x0]
	str	w1, [x26, 16]
	ubfiz	x0, x1, 1, 32
.LEHB151:
	bl	_Znam
.LEHE151:
	ldp	x1, x2, [x20, 16]
	str	x0, [x26, 8]
	cmp	x2, x1
	beq	.L1889
	mov	x0, x1
	str	x26, [x0, -8]!
	str	x0, [x20, 16]
.L1756:
	ldr	x25, [x19, 112]
	str	x20, [x19, 112]
	cbz	x25, .L1759
	add	x20, x25, 16
	add	x24, x25, 48
	.p2align 3,,7
.L1767:
	ldp	x2, x3, [x24]
	ldr	x1, [x20, 24]
	ldr	x0, [x24, 24]
	sub	x2, x2, x3
	sub	x0, x0, x1
	ldr	x1, [x20]
	asr	x0, x0, 3
	ldr	x3, [x20, 16]
	sub	x0, x0, #1
	asr	x2, x2, 3
	sub	x4, x3, x1
	add	x0, x2, x0, lsl 6
	add	x0, x0, x4, asr 3
	cbz	x0, .L1764
	sub	x3, x3, #8
	ldr	x26, [x1]
	cmp	x1, x3
	beq	.L1765
	add	x1, x1, 8
	str	x1, [x25, 16]
	cbz	x26, .L1767
.L1890:
	ldr	x0, [x26, 8]
	cbz	x0, .L1768
	bl	_ZdaPv
.L1768:
	mov	x0, x26
	mov	x1, 24
	bl	_ZdlPvm
	b	.L1767
	.p2align 2,,3
.L1765:
	ldr	x0, [x25, 24]
	mov	x1, 512
	bl	_ZdlPvm
	ldr	x0, [x25, 40]
	add	x1, x0, 8
	ldr	x0, [x0, 8]
	str	x0, [x20, 8]
	str	x1, [x20, 24]
	add	x1, x0, 512
	str	x1, [x20, 16]
	str	x0, [x25, 16]
	cbz	x26, .L1767
	b	.L1890
	.p2align 2,,3
.L1764:
	mov	x0, x25
	bl	_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev
	mov	x0, x25
	mov	x1, 136
	bl	_ZdlPvm
.L1759:
	ldr	x0, [x19, 8]
	mov	w1, -1
	str	w1, [x19, 104]
	str	w1, [x19, 216]
	lsl	x0, x0, 3
	bl	malloc
	str	x0, [x19, 264]
	cbz	x0, .L1891
	ldr	d0, [x19, 48]
	ldr	x0, [x19, 56]
	ucvtf	d0, d0
	add	x0, x0, 1
	lsl	x0, x0, 2
	str	x0, [x19, 32]
	bl	log
	strb	wzr, [sp, 184]
	fmov	d1, 1.0e+0
	ldr	x0, [x19, 120]
	str	x0, [sp, 176]
	fdiv	d0, d1, d0
	fdiv	d1, d1, d0
	stp	d0, d1, [x19, 88]
	cbz	x0, .L1770
	adrp	x1, .LC5
	ldr	x26, [x1, #:lo12:.LC5]
	cbz	x26, .L1789
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1885
.L1789:
	ldr	x1, [sp, 96]
	mov	w4, 1
	mov	x0, x19
	mov	w3, -1
	mov	x2, 0
	strb	w4, [sp, 184]
.LEHB152:
	bl	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
.LEHE152:
	ldrb	w0, [sp, 184]
	cbnz	w0, .L1892
.L1790:
	cmp	x21, 1
	bls	.L1801
	ldr	x0, [sp, 96]
	mov	x20, 1
	adrp	x25, _ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb
	mov	w28, w20
	add	x25, x25, :lo12:_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb
	add	x24, x0, x23
	mov	w27, 48
	b	.L1802
	.p2align 2,,3
.L1798:
	add	x20, x20, 1
	add	x24, x24, x23
	cmp	x21, x20
	beq	.L1801
.L1802:
	ldr	x0, [x19]
	ldr	x4, [x0]
	cmp	x4, x25
	bne	.L1795
	ldr	x1, [x22]
	and	w0, w20, 65535
	strb	wzr, [sp, 216]
	smaddl	x0, w0, w27, x1
	str	x0, [sp, 208]
	cbz	x0, .L1770
	cbz	x26, .L1796
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1885
.L1796:
	mov	x2, x20
	mov	x1, x24
	mov	x0, x19
	mov	w3, -1
	strb	w28, [sp, 216]
.LEHB153:
	bl	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
.LEHE153:
	ldrb	w0, [sp, 216]
	cbz	w0, .L1798
	ldr	x0, [sp, 208]
	cbz	x0, .L1798
	cbz	x26, .L1798
	add	x20, x20, 1
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	add	x24, x24, x23
	cmp	x21, x20
	bne	.L1802
	.p2align 3,,7
.L1801:
	adrp	x3, .LANCHOR0
	add	x3, x3, :lo12:.LANCHOR0
	mov	x2, 1007
	mov	w1, 0
	add	x0, sp, 225
	ldp	x4, x5, [x3]
	stp	x4, x5, [sp, 208]
	ldrb	w3, [x3, 16]
	strb	w3, [sp, 224]
	bl	memset
	ldr	x4, [x19]
	add	x3, sp, 192
	add	x2, sp, 224
	add	x0, sp, 208
	mov	x1, x0
	add	x0, sp, 176
	ldr	x20, [x4, 24]
	str	x3, [sp, 176]
.LEHB154:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag.isra.0
.LEHE154:
	add	x1, sp, 176
	mov	x0, x19
.LEHB155:
	blr	x20
.LEHE155:
	ldr	x0, [sp, 176]
	add	x1, sp, 192
	cmp	x0, x1
	beq	.L1746
	ldr	x1, [sp, 192]
	add	x1, x1, 1
	bl	_ZdlPvm
.L1746:
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	add	sp, sp, 1232
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1795:
	.cfi_restore_state
	mov	x2, x20
	mov	x1, x24
	mov	x0, x19
	mov	w3, 0
.LEHB156:
	blr	x4
.LEHE156:
	b	.L1798
	.p2align 2,,3
.L1748:
	str	xzr, [x19, 192]
	add	x0, x19, 272
	stp	xzr, xzr, [x28, 8]
	mov	x20, 0
	str	x0, [sp, 120]
	str	wzr, [x19, 216]
	stp	xzr, xzr, [x19, 224]
	stp	xzr, xzr, [x19, 240]
	stp	xzr, xzr, [x19, 256]
	str	xzr, [x19, 272]
	str	xzr, [x19, 288]
	b	.L1805
	.p2align 2,,3
.L1892:
	ldr	x0, [sp, 176]
	cbz	x0, .L1790
	cbz	x26, .L1790
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	b	.L1790
	.p2align 2,,3
.L1889:
	ldp	x1, x6, [x24, 16]
	str	x6, [sp, 104]
	ldr	x0, [x25, 24]
	mov	x4, 1152921504606846975
	ldr	x5, [x25, 8]
	ldr	x3, [x20, 48]
	sub	x0, x0, x6
	sub	x1, x1, x2
	asr	x0, x0, 3
	sub	x3, x3, x5
	sub	x0, x0, #1
	asr	x3, x3, 3
	add	x0, x3, x0, lsl 6
	add	x0, x0, x1, asr 3
	cmp	x0, x4
	beq	.L1754
	ldr	x0, [x20]
	cmp	x6, x0
	beq	.L1755
.L1757:
	mov	x0, 512
.LEHB157:
	bl	_Znwm
	ldr	x1, [sp, 104]
	str	x0, [x1, -8]
	ldr	x0, [x20, 40]
	sub	x1, x0, #8
	ldr	x0, [x0, -8]
	str	x0, [x24, 8]
	str	x1, [x24, 24]
	add	x1, x0, 512
	str	x1, [x24, 16]
	add	x1, x0, 504
	str	x1, [x20, 16]
	str	x26, [x0, 504]
	b	.L1756
.L1755:
	mov	x0, x20
	mov	w2, 1
	mov	x1, 1
	bl	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
.LEHE157:
	ldr	x0, [x20, 40]
	str	x0, [sp, 104]
	b	.L1757
.L1770:
	mov	w0, 1
.LEHB158:
	bl	_ZSt20__throw_system_errori
.L1885:
	bl	_ZSt20__throw_system_errori
.LEHE158:
.L1754:
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
.LEHB159:
	bl	_ZSt20__throw_length_errorPKc
.LEHE159:
.L1887:
	adrp	x0, .LC34
	add	x0, x0, :lo12:.LC34
.LEHB160:
	bl	_ZSt20__throw_length_errorPKc
.LEHE160:
.L1806:
	mov	x19, x0
	add	x0, sp, 176
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_disposeEv
.L1886:
	mov	x0, x19
.LEHB161:
	bl	_Unwind_Resume
.LEHE161:
.L1810:
	mov	x20, x0
.L1773:
	mov	x0, x27
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE5clearEv
	mov	x0, x27
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE21_M_deallocate_bucketsEv
	ldr	x0, [sp, 128]
	ldr	x0, [x0, 16]
	cbnz	x0, .L1893
.L1775:
	ldr	x21, [sp, 128]
	mov	w1, 0
	ldr	x0, [x19, 368]
	ldr	x2, [x21, 8]
	lsl	x2, x2, 3
	bl	memset
	ldr	x2, [sp, 136]
	ldr	x0, [x19, 368]
	stp	xzr, xzr, [x21, 16]
	ldr	x1, [x21, 8]
	cmp	x2, x0
	beq	.L1777
	lsl	x1, x1, 3
	bl	_ZdlPvm
.L1777:
	ldr	x1, [sp, 120]
	ldr	x0, [x19, 272]
	ldr	x1, [x1, 16]
	sub	x1, x1, x0
	cbnz	x0, .L1894
.L1779:
	mov	x0, x28
	bl	_ZNSt12_Vector_baseISt5mutexSaIS0_EED2Ev
.L1780:
	mov	x0, x22
	bl	_ZNSt12_Vector_baseISt5mutexSaIS0_EED2Ev
.L1781:
	ldr	x21, [x19, 112]
	cbz	x21, .L1782
	add	x22, x21, 16
	add	x23, x21, 48
.L1786:
	ldp	x2, x3, [x23]
	ldr	x1, [x22, 24]
	ldr	x0, [x23, 24]
	sub	x2, x2, x3
	sub	x0, x0, x1
	ldr	x1, [x22]
	asr	x0, x0, 3
	ldr	x3, [x22, 16]
	sub	x0, x0, #1
	asr	x2, x2, 3
	sub	x4, x3, x1
	add	x0, x2, x0, lsl 6
	add	x0, x0, x4, asr 3
	cbz	x0, .L1783
	sub	x3, x3, #8
	ldr	x24, [x1]
	cmp	x1, x3
	beq	.L1784
	add	x1, x1, 8
	str	x1, [x21, 16]
	cbz	x24, .L1786
.L1895:
	ldr	x0, [x24, 8]
	cbz	x0, .L1787
	bl	_ZdaPv
.L1787:
	mov	x0, x24
	mov	x1, 24
	bl	_ZdlPvm
	b	.L1786
.L1820:
	ldrb	w1, [sp, 216]
	mov	x19, x0
	cbz	w1, .L1886
	add	x0, sp, 208
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L1886
.L1815:
	mov	x21, x0
	mov	x1, 24
	mov	x0, x26
	bl	_ZdlPvm
.L1763:
	mov	x0, x20
	bl	_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev
.L1761:
	mov	x0, x20
	mov	x1, 136
	mov	x20, x21
	bl	_ZdlPvm
	b	.L1773
.L1814:
	mov	x21, x0
	b	.L1763
.L1893:
	ldr	x21, [x0]
	mov	x1, 24
	bl	_ZdlPvm
	mov	x0, x21
	cbnz	x0, .L1893
	b	.L1775
.L1807:
	mov	x20, x0
	b	.L1781
.L1888:
	mov	x0, x20
	bl	__cxa_allocate_exception
	adrp	x1, .LC35
	mov	x20, x0
	add	x1, x1, :lo12:.LC35
.LEHB162:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE162:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB163:
	bl	__cxa_throw
.LEHE163:
.L1813:
.L1884:
	mov	x1, x0
	mov	x0, x20
	mov	x20, x1
	bl	__cxa_free_exception
	b	.L1773
.L1783:
	mov	x0, x21
	bl	_ZNSt11_Deque_baseIPN7hnswlib11VisitedListESaIS2_EED2Ev
	mov	x0, x21
	mov	x1, 136
	bl	_ZdlPvm
.L1782:
	mov	x1, 568
	mov	x0, x19
	bl	_ZdlPvm
	mov	x0, x20
.LEHB164:
	bl	_Unwind_Resume
.LEHE164:
.L1809:
	mov	x20, x0
	b	.L1779
.L1808:
	mov	x20, x0
	b	.L1780
.L1891:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC36
	mov	x20, x0
	add	x1, x1, :lo12:.LC36
.LEHB165:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE165:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB166:
	bl	__cxa_throw
.LEHE166:
.L1819:
	ldrb	w1, [sp, 184]
	mov	x19, x0
	cbz	w1, .L1886
	add	x0, sp, 176
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L1886
.L1811:
	b	.L1884
.L1817:
	bl	__cxa_begin_catch
.LEHB167:
	bl	__cxa_rethrow
.LEHE167:
.L1812:
	mov	x21, x0
	b	.L1761
.L1894:
	bl	_ZdlPvm
	b	.L1779
.L1818:
	mov	x21, x0
	bl	__cxa_end_catch
	mov	x0, x21
	bl	__cxa_begin_catch
	ldp	x0, x1, [x20]
	lsl	x1, x1, 3
	bl	_ZdlPvm
	stp	xzr, xzr, [x20]
.LEHB168:
	bl	__cxa_rethrow
.LEHE168:
.L1784:
	ldr	x0, [x21, 24]
	mov	x1, 512
	bl	_ZdlPvm
	ldr	x0, [x21, 40]
	add	x1, x0, 8
	ldr	x0, [x0, 8]
	str	x0, [x22, 8]
	str	x1, [x22, 24]
	add	x1, x0, 512
	str	x1, [x22, 16]
	str	x0, [x21, 16]
	cbnz	x24, .L1895
	b	.L1786
.L1816:
	mov	x21, x0
	bl	__cxa_end_catch
	b	.L1761
	.cfi_endproc
.LFE6253:
	.section	.gcc_except_table
	.align	2
.LLSDA6253:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT6253-.LLSDATTD6253
.LLSDATTD6253:
	.byte	0x1
	.uleb128 .LLSDACSE6253-.LLSDACSB6253
.LLSDACSB6253:
	.uleb128 .LEHB143-.LFB6253
	.uleb128 .LEHE143-.LEHB143
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB144-.LFB6253
	.uleb128 .LEHE144-.LEHB144
	.uleb128 .L1807-.LFB6253
	.uleb128 0
	.uleb128 .LEHB145-.LFB6253
	.uleb128 .LEHE145-.LEHB145
	.uleb128 .L1808-.LFB6253
	.uleb128 0
	.uleb128 .LEHB146-.LFB6253
	.uleb128 .LEHE146-.LEHB146
	.uleb128 .L1809-.LFB6253
	.uleb128 0
	.uleb128 .LEHB147-.LFB6253
	.uleb128 .LEHE147-.LEHB147
	.uleb128 .L1810-.LFB6253
	.uleb128 0
	.uleb128 .LEHB148-.LFB6253
	.uleb128 .LEHE148-.LEHB148
	.uleb128 .L1812-.LFB6253
	.uleb128 0
	.uleb128 .LEHB149-.LFB6253
	.uleb128 .LEHE149-.LEHB149
	.uleb128 .L1817-.LFB6253
	.uleb128 0x1
	.uleb128 .LEHB150-.LFB6253
	.uleb128 .LEHE150-.LEHB150
	.uleb128 .L1814-.LFB6253
	.uleb128 0
	.uleb128 .LEHB151-.LFB6253
	.uleb128 .LEHE151-.LEHB151
	.uleb128 .L1815-.LFB6253
	.uleb128 0
	.uleb128 .LEHB152-.LFB6253
	.uleb128 .LEHE152-.LEHB152
	.uleb128 .L1819-.LFB6253
	.uleb128 0
	.uleb128 .LEHB153-.LFB6253
	.uleb128 .LEHE153-.LEHB153
	.uleb128 .L1820-.LFB6253
	.uleb128 0
	.uleb128 .LEHB154-.LFB6253
	.uleb128 .LEHE154-.LEHB154
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB155-.LFB6253
	.uleb128 .LEHE155-.LEHB155
	.uleb128 .L1806-.LFB6253
	.uleb128 0
	.uleb128 .LEHB156-.LFB6253
	.uleb128 .LEHE156-.LEHB156
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB157-.LFB6253
	.uleb128 .LEHE157-.LEHB157
	.uleb128 .L1814-.LFB6253
	.uleb128 0
	.uleb128 .LEHB158-.LFB6253
	.uleb128 .LEHE158-.LEHB158
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB159-.LFB6253
	.uleb128 .LEHE159-.LEHB159
	.uleb128 .L1814-.LFB6253
	.uleb128 0
	.uleb128 .LEHB160-.LFB6253
	.uleb128 .LEHE160-.LEHB160
	.uleb128 .L1808-.LFB6253
	.uleb128 0
	.uleb128 .LEHB161-.LFB6253
	.uleb128 .LEHE161-.LEHB161
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB162-.LFB6253
	.uleb128 .LEHE162-.LEHB162
	.uleb128 .L1813-.LFB6253
	.uleb128 0
	.uleb128 .LEHB163-.LFB6253
	.uleb128 .LEHE163-.LEHB163
	.uleb128 .L1810-.LFB6253
	.uleb128 0
	.uleb128 .LEHB164-.LFB6253
	.uleb128 .LEHE164-.LEHB164
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB165-.LFB6253
	.uleb128 .LEHE165-.LEHB165
	.uleb128 .L1811-.LFB6253
	.uleb128 0
	.uleb128 .LEHB166-.LFB6253
	.uleb128 .LEHE166-.LEHB166
	.uleb128 .L1810-.LFB6253
	.uleb128 0
	.uleb128 .LEHB167-.LFB6253
	.uleb128 .LEHE167-.LEHB167
	.uleb128 .L1818-.LFB6253
	.uleb128 0x1
	.uleb128 .LEHB168-.LFB6253
	.uleb128 .LEHE168-.LEHB168
	.uleb128 .L1816-.LFB6253
	.uleb128 0
.LLSDACSE6253:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT6253:
	.text
	.size	_Z11build_indexPfmm, .-_Z11build_indexPfmm
	.section	.rodata._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb.str1.8,"aMS",@progbits,1
	.align	3
.LC38:
	.string	"Replacement of deleted elements is disabled in constructor"
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb
	.type	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb, %function
_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb:
.LFB6726:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6726
	stp	x29, x30, [sp, -144]!
	.cfi_def_cfa_offset 144
	.cfi_offset 29, -144
	.cfi_offset 30, -136
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -128
	.cfi_offset 20, -120
	mov	x19, x0
	ldrb	w0, [x0, 456]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -112
	.cfi_offset 22, -104
	and	w22, w3, 255
	eor	w0, w0, 1
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -96
	.cfi_offset 24, -88
	str	x2, [sp, 72]
	tst	w22, w0
	bne	.L2034
	mov	x21, x1
	ubfiz	x0, x2, 1, 16
	ldr	x1, [x19, 120]
	add	x0, x0, x2, uxth
	strb	wzr, [sp, 104]
	add	x0, x1, x0, lsl 4
	str	x0, [sp, 96]
	cbz	x0, .L2035
	adrp	x1, .LC5
	ldr	x20, [x1, #:lo12:.LC5]
	cbz	x20, .L1899
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2036
.L1899:
	mov	w0, 1
	strb	w0, [sp, 104]
	cbz	w22, .L2037
	add	x22, x19, 464
	str	x22, [sp, 112]
	strb	wzr, [sp, 120]
	cbz	x20, .L1903
	mov	x0, x22
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2038
.L1903:
	ldr	x24, [x19, 536]
	mov	w0, 1
	strb	w0, [sp, 120]
	add	x23, x19, 512
	cbnz	x24, .L2039
	ldr	x0, [sp, 112]
	cbz	x0, .L2026
	cbz	x20, .L2040
.L1936:
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	strb	wzr, [sp, 120]
	ldr	x2, [sp, 72]
	cbz	x24, .L1931
.L1906:
	ldp	x4, x3, [x19, 248]
	add	x0, x19, 320
	ldr	w1, [sp, 80]
	ldr	x5, [x19, 24]
	madd	x1, x1, x5, x4
	ldr	x4, [x3, x1]
	str	x4, [sp, 88]
	str	x2, [x3, x1]
	str	x0, [sp, 128]
	strb	wzr, [sp, 136]
	cbz	x20, .L1908
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2041
.L1908:
	mov	w3, 1
	add	x2, sp, 88
	add	x24, x19, 368
	mov	w1, 0
	mov	x0, x24
	strb	w3, [sp, 136]
	bl	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_
	mov	x0, x24
	add	x1, sp, 72
.LEHB169:
	bl	_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_
	ldrb	w1, [sp, 136]
	ldr	w2, [sp, 80]
	str	w2, [x0]
	cbz	w1, .L2042
	ldr	x0, [sp, 128]
	cbz	x0, .L1910
	cbz	x20, .L1911
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L1911:
	strb	wzr, [sp, 136]
.L1910:
	ldr	w0, [sp, 80]
	str	w0, [sp, 84]
	add	x1, x19, 16
	ldar	x1, [x1]
	cmp	x1, x0, uxtw
	bls	.L2043
	ldr	w1, [sp, 84]
	ldr	x3, [x19, 24]
	ldr	x2, [x19, 240]
	ldr	x0, [x19, 256]
	madd	x1, x1, x3, x2
	add	x0, x0, x1
	ldrb	w1, [x0, 2]
	tbz	x1, 0, .L1913
	and	w1, w1, -2
	strb	w1, [x0, 2]
	add	x0, x19, 40
.L2050:
	ldaxr	x1, [x0]
	sub	x1, x1, #1
	stlxr	w2, x1, [x0]
	cbnz	w2, .L2050
	ldrb	w0, [x19, 456]
	cbnz	w0, .L2044
.L1914:
	ldr	w2, [sp, 80]
	fmov	s0, 1.0e+0
	mov	x1, x21
	mov	x0, x19
	bl	_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf
.LEHE169:
	ldrb	w0, [sp, 136]
	cbnz	w0, .L2045
.L1907:
	ldrb	w0, [sp, 120]
	cbnz	w0, .L2046
.L1921:
	ldrb	w0, [sp, 104]
	cbnz	w0, .L2047
.L1896:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 144
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2039:
	.cfi_restore_state
	ldr	x3, [x23, 16]
	add	x2, sp, 80
	mov	x0, x23
	mov	w1, 0
	ldr	w3, [x3, 8]
	str	w3, [sp, 80]
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj
	ldrb	w0, [sp, 120]
	cbz	w0, .L2048
	ldr	x0, [sp, 112]
	cbz	x0, .L2027
	cbnz	x20, .L1936
	strb	wzr, [sp, 120]
.L2027:
	ldr	x2, [sp, 72]
	b	.L1906
	.p2align 2,,3
.L2037:
	ldr	x2, [sp, 72]
	mov	x1, x21
	mov	x0, x19
	mov	w3, -1
.LEHB170:
	bl	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
.LEHE170:
	ldrb	w0, [sp, 104]
	cbz	w0, .L1896
.L2047:
	ldr	x0, [sp, 96]
	cbz	x0, .L1896
	cbz	x20, .L1896
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 144
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2040:
	.cfi_restore_state
	strb	wzr, [sp, 120]
.L2026:
	ldr	x2, [sp, 72]
.L1931:
	mov	x1, x21
	mov	x0, x19
	mov	w3, -1
.LEHB171:
	bl	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
.LEHE171:
	ldrb	w0, [sp, 120]
	cbz	w0, .L1921
.L2046:
	ldr	x0, [sp, 112]
	cbz	x0, .L1921
	cbz	x20, .L1921
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	b	.L1921
	.p2align 2,,3
.L2044:
	cbz	x20, .L1915
	mov	x0, x22
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2049
.L1915:
	mov	x0, x23
	add	x2, sp, 84
	mov	w1, 0
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj
	cbz	x20, .L1914
	mov	x0, x22
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	b	.L1914
	.p2align 2,,3
.L2045:
	ldr	x0, [sp, 128]
	cbz	x0, .L1907
	cbz	x20, .L1907
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	b	.L1907
.L2038:
.LEHB172:
	bl	_ZSt20__throw_system_errori
.LEHE172:
.L2035:
	mov	w0, 1
.LEHB173:
	bl	_ZSt20__throw_system_errori
.LEHE173:
.L2048:
	mov	w0, 1
.LEHB174:
	bl	_ZSt20__throw_system_errori
.LEHE174:
.L2036:
.LEHB175:
	bl	_ZSt20__throw_system_errori
.LEHE175:
.L2043:
	bl	_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj.part.0
.L2042:
	mov	w0, 1
.LEHB176:
	bl	_ZSt20__throw_system_errori
.LEHE176:
.L2041:
.LEHB177:
	bl	_ZSt20__throw_system_errori
.LEHE177:
.L2049:
.LEHB178:
	bl	_ZSt20__throw_system_errori
.LEHE178:
.L1940:
	mov	x19, x0
.L1926:
	ldrb	w0, [sp, 104]
	cbz	w0, .L1927
	add	x0, sp, 96
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L1927:
	mov	x0, x19
.LEHB179:
	bl	_Unwind_Resume
.LEHE179:
.L1913:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC29
	mov	x20, x0
	add	x1, x1, :lo12:.LC29
.LEHB180:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE180:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB181:
	bl	__cxa_throw
.LEHE181:
.L2034:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC38
	mov	x19, x0
	add	x1, x1, :lo12:.LC38
.LEHB182:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE182:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x19
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB183:
	bl	__cxa_throw
.LEHE183:
.L1942:
	mov	x19, x0
	b	.L1919
.L1941:
	mov	x19, x0
.L1924:
	ldrb	w0, [sp, 120]
	cbz	w0, .L1926
	add	x0, sp, 112
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L1926
.L1943:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
.L1919:
	ldrb	w0, [sp, 136]
	cbz	w0, .L1924
	add	x0, sp, 128
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L1924
.L1939:
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	bl	__cxa_free_exception
	mov	x0, x19
.LEHB184:
	bl	_Unwind_Resume
.LEHE184:
	.cfi_endproc
.LFE6726:
	.section	.gcc_except_table
.LLSDA6726:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE6726-.LLSDACSB6726
.LLSDACSB6726:
	.uleb128 .LEHB169-.LFB6726
	.uleb128 .LEHE169-.LEHB169
	.uleb128 .L1942-.LFB6726
	.uleb128 0
	.uleb128 .LEHB170-.LFB6726
	.uleb128 .LEHE170-.LEHB170
	.uleb128 .L1940-.LFB6726
	.uleb128 0
	.uleb128 .LEHB171-.LFB6726
	.uleb128 .LEHE171-.LEHB171
	.uleb128 .L1941-.LFB6726
	.uleb128 0
	.uleb128 .LEHB172-.LFB6726
	.uleb128 .LEHE172-.LEHB172
	.uleb128 .L1940-.LFB6726
	.uleb128 0
	.uleb128 .LEHB173-.LFB6726
	.uleb128 .LEHE173-.LEHB173
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB174-.LFB6726
	.uleb128 .LEHE174-.LEHB174
	.uleb128 .L1941-.LFB6726
	.uleb128 0
	.uleb128 .LEHB175-.LFB6726
	.uleb128 .LEHE175-.LEHB175
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB176-.LFB6726
	.uleb128 .LEHE176-.LEHB176
	.uleb128 .L1942-.LFB6726
	.uleb128 0
	.uleb128 .LEHB177-.LFB6726
	.uleb128 .LEHE177-.LEHB177
	.uleb128 .L1941-.LFB6726
	.uleb128 0
	.uleb128 .LEHB178-.LFB6726
	.uleb128 .LEHE178-.LEHB178
	.uleb128 .L1942-.LFB6726
	.uleb128 0
	.uleb128 .LEHB179-.LFB6726
	.uleb128 .LEHE179-.LEHB179
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB180-.LFB6726
	.uleb128 .LEHE180-.LEHB180
	.uleb128 .L1943-.LFB6726
	.uleb128 0
	.uleb128 .LEHB181-.LFB6726
	.uleb128 .LEHE181-.LEHB181
	.uleb128 .L1942-.LFB6726
	.uleb128 0
	.uleb128 .LEHB182-.LFB6726
	.uleb128 .LEHE182-.LEHB182
	.uleb128 .L1939-.LFB6726
	.uleb128 0
	.uleb128 .LEHB183-.LFB6726
	.uleb128 .LEHE183-.LEHB183
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB184-.LFB6726
	.uleb128 .LEHE184-.LEHB184
	.uleb128 0
	.uleb128 0
.LLSDACSE6726:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb, .-_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb
	.section	.text._ZNSt12_Vector_baseISt4pairIfmESaIS1_EED2Ev,"axG",@progbits,_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED2Ev
	.type	_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED2Ev, %function
_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED2Ev:
.LFB8387:
	.cfi_startproc
	mov	x2, x0
	ldr	x0, [x0]
	cbz	x0, .L2051
	ldr	x1, [x2, 16]
	sub	x1, x1, x0
	b	_ZdlPvm
	.p2align 2,,3
.L2051:
	ret
	.cfi_endproc
.LFE8387:
	.size	_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED2Ev, .-_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED2Ev
	.weak	_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED1Ev
	.set	_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED1Ev,_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED2Ev
	.section	.rodata._ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm.str1.8,"aMS",@progbits,1
	.align	3
.LC39:
	.string	"vector::_M_default_append"
	.section	.text._ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm,"axG",@progbits,_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm
	.type	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm, %function
_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm:
.LFB8443:
	.cfi_startproc
	cbz	x1, .L2077
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x3, 576460752303423487
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x22, x0
	ldp	x0, x4, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x20, x1
	ldr	x1, [x22, 16]
	sub	x19, x4, x0
	sub	x2, x1, x4
	asr	x21, x19, 4
	sub	x5, x3, x21
	cmp	x20, x2, asr 4
	bhi	.L2055
	mov	x2, x4
	mov	x3, x20
	.p2align 3,,7
.L2056:
	str	wzr, [x2]
	subs	x3, x3, #1
	str	xzr, [x2, 8]
	add	x2, x2, 16
	bne	.L2056
	add	x4, x4, x20, lsl 4
	str	x4, [x22, 8]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2077:
	ret
	.p2align 2,,3
.L2055:
	.cfi_def_cfa_offset 64
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -8
	.cfi_offset 23, -16
	cmp	x5, x20
	bcc	.L2080
	cmp	x20, x21
	csel	x2, x20, x21, cs
	adds	x2, x21, x2
	bcs	.L2059
	cbnz	x2, .L2081
	mov	x23, 0
	mov	x24, 0
.L2061:
	add	x2, x24, x19
	mov	x3, x20
	.p2align 3,,7
.L2062:
	str	wzr, [x2]
	subs	x3, x3, #1
	str	xzr, [x2, 8]
	add	x2, x2, 16
	bne	.L2062
	cmp	x4, x0
	beq	.L2066
	sub	x4, x4, x0
	mov	x2, x24
	add	x4, x24, x4
	mov	x3, x0
	.p2align 3,,7
.L2067:
	ldp	x6, x7, [x3], 16
	stp	x6, x7, [x2], 16
	cmp	x2, x4
	bne	.L2067
.L2066:
	cbz	x0, .L2065
	sub	x1, x1, x0
	bl	_ZdlPvm
.L2065:
	add	x21, x20, x21
	str	x23, [x22, 16]
	ldp	x19, x20, [sp, 16]
	add	x21, x24, x21, lsl 4
	stp	x24, x21, [x22]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	.cfi_remember_state
	.cfi_restore 24
	.cfi_restore 23
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L2081:
	.cfi_restore_state
	cmp	x2, x3
	csel	x2, x2, x3, ls
	lsl	x23, x2, 4
.L2060:
	mov	x0, x23
	bl	_Znwm
	mov	x24, x0
	add	x23, x0, x23
	ldp	x0, x4, [x22]
	ldr	x1, [x22, 16]
	b	.L2061
.L2059:
	mov	x23, 9223372036854775792
	b	.L2060
.L2080:
	adrp	x0, .LC39
	add	x0, x0, :lo12:.LC39
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE8443:
	.size	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm, .-_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm
	.section	.text._ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE,"axG",@progbits,_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE
	.type	_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE, %function
_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE:
.LFB8361:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8361
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	ldr	x4, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x19, x8
	add	x8, sp, 32
	ldr	x4, [x4, 8]
	stp	xzr, xzr, [x19]
	str	xzr, [x19, 16]
.LEHB185:
	blr	x4
.LEHE185:
	ldp	x0, x2, [sp, 32]
	ldp	x3, x4, [x19]
	sub	x20, x2, x0
	sub	x1, x4, x3
	asr	x5, x20, 4
	cmp	x1, x20
	bcc	.L2115
	bhi	.L2116
.L2084:
	cmp	x0, x2
	beq	.L2085
.L2117:
	sub	x20, x20, #16
	b	.L2093
	.p2align 2,,3
.L2086:
	ldp	x0, x2, [sp, 32]
	sub	x20, x20, #16
	sub	x2, x2, #16
	str	x2, [sp, 40]
	cmp	x0, x2
	beq	.L2113
.L2093:
	ldr	x3, [x19]
	sub	x1, x2, x0
	ldr	s1, [x0]
	add	x4, x3, x20
	ldr	x5, [x0, 8]
	str	s1, [x3, x20]
	str	x5, [x4, 8]
	cmp	x1, 16
	ble	.L2086
	sub	x1, x2, #16
	ldr	s0, [x2, -16]
	sub	x1, x1, x0
	ldr	x4, [x0, 8]
	asr	x9, x1, 4
	sub	x7, x9, #1
	str	s1, [x2, -16]
	ldr	x3, [x2, -8]
	add	x7, x7, x7, lsr 63
	str	x4, [x2, -8]
	asr	x7, x7, 1
	cmp	x1, 32
	ble	.L2099
	mov	x4, 0
	b	.L2091
	.p2align 2,,3
.L2101:
	mov	x5, x2
.L2090:
	lsl	x2, x4, 4
	add	x4, x0, x2
	str	s1, [x0, x2]
	str	x5, [x4, 8]
	cmp	x1, x7
	bge	.L2087
.L2102:
	mov	x4, x1
.L2091:
	add	x2, x4, 1
	lsl	x6, x2, 1
	lsl	x2, x2, 5
	sub	x1, x6, #1
	add	x8, x0, x2
	lsl	x5, x1, 4
	ldr	s2, [x0, x2]
	add	x2, x0, x5
	ldr	s1, [x0, x5]
	fcmpe	s2, s1
	bmi	.L2105
	ldr	x5, [x8, 8]
	bgt	.L2100
	ldr	x2, [x2, 8]
	cmp	x2, x5
	bhi	.L2101
.L2100:
	fmov	s1, s2
	lsl	x2, x4, 4
	add	x4, x0, x2
	mov	x1, x6
	str	s1, [x0, x2]
	str	x5, [x4, 8]
	cmp	x1, x7
	blt	.L2102
.L2087:
	tbnz	x9, 0, .L2092
	sub	x9, x9, #2
	add	x9, x9, x9, lsr 63
	cmp	x1, x9, asr 1
	bne	.L2092
	lsl	x4, x1, 1
	lsl	x2, x1, 4
	add	x1, x4, 1
	add	x5, x0, x2
	lsl	x4, x1, 4
	add	x6, x0, x4
	ldr	s1, [x0, x4]
	ldr	x4, [x6, 8]
	str	s1, [x0, x2]
	str	x4, [x5, 8]
	.p2align 3,,7
.L2092:
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x2, [sp, 32]
	sub	x20, x20, #16
	sub	x2, x2, #16
	str	x2, [sp, 40]
	cmp	x0, x2
	bne	.L2093
.L2113:
	ldr	x1, [sp, 48]
	mov	x0, x2
	sub	x1, x1, x2
	bl	_ZdlPvm
	mov	x0, x19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2105:
	.cfi_restore_state
	ldr	x5, [x2, 8]
	b	.L2090
	.p2align 2,,3
.L2116:
	add	x3, x3, x20
	cmp	x4, x3
	beq	.L2084
	str	x3, [x19, 8]
	cmp	x0, x2
	bne	.L2117
.L2085:
	cbnz	x2, .L2113
	mov	x0, x19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2115:
	.cfi_restore_state
	sub	x1, x5, x1, asr 4
	mov	x0, x19
.LEHB186:
	bl	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm
.LEHE186:
	ldp	x0, x2, [sp, 32]
	b	.L2084
	.p2align 2,,3
.L2099:
	mov	x1, 0
	b	.L2087
.L2104:
	mov	x20, x0
	add	x0, sp, 32
	bl	_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED2Ev
.L2097:
	mov	x0, x19
	bl	_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED2Ev
	mov	x0, x20
.LEHB187:
	bl	_Unwind_Resume
.LEHE187:
.L2103:
	mov	x20, x0
	b	.L2097
	.cfi_endproc
.LFE8361:
	.section	.gcc_except_table
.LLSDA8361:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8361-.LLSDACSB8361
.LLSDACSB8361:
	.uleb128 .LEHB185-.LFB8361
	.uleb128 .LEHE185-.LEHB185
	.uleb128 .L2103-.LFB8361
	.uleb128 0
	.uleb128 .LEHB186-.LFB8361
	.uleb128 .LEHE186-.LEHB186
	.uleb128 .L2104-.LFB8361
	.uleb128 0
	.uleb128 .LEHB187-.LFB8361
	.uleb128 .LEHE187-.LEHB187
	.uleb128 0
	.uleb128 0
.LLSDACSE8361:
	.section	.text._ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE,"axG",@progbits,_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE,comdat
	.size	_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE, .-_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB8503:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x23, x24, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	sub	x0, x24, x23
	stp	x27, x28, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L2136
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x23
	csinc	x1, x0, xzr, ne
	mov	x28, x3
	adds	x1, x1, x0
	bcs	.L2129
	cbnz	x1, .L2123
	mov	x25, 8
	mov	x22, 0
	mov	x21, 0
.L2128:
	ldr	s0, [x27]
	add	x0, x21, x26
	ldr	w1, [x28]
	str	s0, [x21, x26]
	str	w1, [x0, 4]
	cmp	x19, x23
	beq	.L2124
	mov	x4, x21
	mov	x3, x23
	.p2align 3,,7
.L2125:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L2125
	add	x26, x26, 8
	add	x25, x21, x26
.L2124:
	cmp	x19, x24
	beq	.L2126
	sub	x2, x24, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L2126:
	cbz	x23, .L2127
	ldr	x1, [x20, 16]
	mov	x0, x23
	sub	x1, x1, x23
	bl	_ZdlPvm
.L2127:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	stp	x21, x25, [x20]
	str	x22, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2129:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L2122:
	mov	x0, x22
	bl	_Znwm
	mov	x21, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L2128
.L2123:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L2122
.L2136:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE8503:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB8505:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x23, x24, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	sub	x0, x24, x23
	stp	x27, x28, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L2155
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x23
	csinc	x1, x0, xzr, ne
	mov	x28, x3
	adds	x1, x1, x0
	bcs	.L2148
	cbnz	x1, .L2142
	mov	x25, 8
	mov	x22, 0
	mov	x21, 0
.L2147:
	ldr	s0, [x27]
	add	x0, x21, x26
	ldr	w1, [x28]
	str	s0, [x21, x26]
	str	w1, [x0, 4]
	cmp	x19, x23
	beq	.L2143
	mov	x4, x21
	mov	x3, x23
	.p2align 3,,7
.L2144:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L2144
	add	x26, x26, 8
	add	x25, x21, x26
.L2143:
	cmp	x19, x24
	beq	.L2145
	sub	x2, x24, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L2145:
	cbz	x23, .L2146
	ldr	x1, [x20, 16]
	mov	x0, x23
	sub	x1, x1, x23
	bl	_ZdlPvm
.L2146:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	stp	x21, x25, [x20]
	str	x22, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2148:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L2141:
	mov	x0, x22
	bl	_Znwm
	mov	x21, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L2147
.L2142:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L2141
.L2155:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE8505:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.text._ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE,"axG",@progbits,_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE
	.type	_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE, %function
_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE:
.LFB8391:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8391
	stp	x29, x30, [sp, -192]!
	.cfi_def_cfa_offset 192
	.cfi_offset 29, -192
	.cfi_offset 30, -184
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -160
	.cfi_offset 22, -152
	mov	x21, x0
	mov	x22, x3
	ldr	x0, [x0, 112]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -176
	.cfi_offset 20, -168
	mov	x19, x8
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	.cfi_offset 23, -144
	.cfi_offset 24, -136
	.cfi_offset 25, -128
	.cfi_offset 26, -120
	.cfi_offset 27, -112
	.cfi_offset 28, -104
	mov	x27, x2
	add	x28, sp, 160
	str	d8, [sp, 96]
	.cfi_offset 72, -96
	str	w1, [sp, 124]
.LEHB188:
	bl	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv
.LEHE188:
	ldr	w1, [sp, 124]
	mov	x2, x0
	ldr	x5, [x21, 24]
	str	x2, [sp, 112]
	ldr	x4, [x21, 232]
	mov	x0, x27
	ldrh	w24, [x2]
	ldr	x23, [x2, 8]
	madd	x1, x1, x5, x4
	ldr	x4, [x21, 256]
	stp	xzr, xzr, [sp, 160]
	ldr	x3, [x21, 304]
	stp	xzr, xzr, [x19]
	add	x1, x4, x1
	str	xzr, [x19, 16]
	str	xzr, [sp, 176]
	ldr	x2, [x21, 312]
.LEHB189:
	blr	x3
	ldp	x1, x0, [x19, 8]
	str	s0, [sp, 140]
	fmov	s8, s0
	cmp	x1, x0
	beq	.L2157
	ldr	w7, [sp, 124]
	fmov	s2, s0
	fmov	s1, s0
	str	s0, [x1]
	str	w7, [x1, 4]
	add	x0, x1, 8
	str	x0, [x19, 8]
.L2158:
	ldr	x3, [x19]
	sub	x2, x0, x3
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L2159
	.p2align 3,,7
.L2162:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s0, [x3, x2]
	fcmpe	s0, s2
	bmi	.L2210
.L2160:
	ldp	x1, x0, [sp, 168]
	fneg	s1, s1
	str	w7, [x4, 4]
	str	s2, [x4]
	str	s1, [sp, 144]
	cmp	x1, x0
	beq	.L2163
.L2235:
	ldr	w8, [sp, 124]
	add	x7, x1, 8
	str	s1, [x1]
	mov	w9, w8
	str	w8, [x1, 4]
	str	x7, [sp, 168]
.L2164:
	ldr	x0, [sp, 160]
	sub	x3, x7, x0
	asr	x1, x3, 3
	sub	x2, x1, #2
	sub	x1, x1, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x1, 0
	ble	.L2165
	.p2align 3,,7
.L2168:
	lsl	x3, x2, 3
	lsl	x1, x1, 3
	add	x5, x0, x3
	add	x4, x0, x1
	ldr	s0, [x0, x3]
	fcmpe	s0, s1
	bmi	.L2211
.L2166:
	str	s1, [x4]
	str	w9, [x4, 4]
	strh	w24, [x23, w8, uxtw 1]
	cmp	x0, x7
	beq	.L2169
	.p2align 3,,7
.L2171:
	ldr	s0, [x0]
	ldr	w20, [x0, 4]
	fneg	s0, s0
	fcmpe	s0, s8
	bgt	.L2169
	add	x0, sp, 160
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldr	x3, [x21, 24]
	uxtw	x0, w20
	ldr	x2, [x21, 240]
	add	x28, sp, 160
	ldr	x1, [x21, 256]
	mov	x20, 1
	madd	x0, x0, x3, x2
	add	x26, x1, x0
	ldrh	w25, [x1, x0]
	cbnz	x25, .L2170
	b	.L2190
	.p2align 2,,3
.L2233:
	mov	x20, x0
.L2170:
	ldr	w1, [x26, x20, lsl 2]
	sbfiz	x0, x1, 1, 32
	ldrh	w2, [x23, x0]
	str	w1, [sp, 136]
	cmp	w2, w24
	beq	.L2172
	ldr	x5, [x21, 24]
	uxtw	x1, w1
	ldr	x4, [x21, 232]
	ldp	x3, x2, [x21, 304]
	strh	w24, [x23, x0]
	madd	x1, x1, x5, x4
	mov	x0, x27
	ldr	x4, [x21, 256]
	add	x1, x4, x1
	blr	x3
	ldp	x0, x1, [x19]
	str	s0, [sp, 140]
	sub	x0, x1, x0
	cmp	x22, x0, asr 3
	bhi	.L2173
	fcmpe	s0, s8
	bmi	.L2173
.L2172:
	add	x0, x20, 1
	cmp	x25, x20
	bne	.L2233
.L2190:
	ldp	x0, x1, [sp, 160]
	cmp	x1, x0
	bne	.L2171
.L2169:
	adrp	x0, .LC5
	strb	wzr, [sp, 152]
	ldr	x20, [x21, 112]
	ldr	x21, [x0, #:lo12:.LC5]
	add	x0, x20, 80
	str	x0, [sp, 144]
	cbz	x21, .L2191
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2234
.L2191:
	ldp	x0, x1, [x20, 16]
	mov	w2, 1
	strb	w2, [sp, 152]
	cmp	x0, x1
	beq	.L2192
	ldr	x1, [sp, 112]
	str	x1, [x0, -8]!
	str	x0, [x20, 16]
.L2193:
	ldr	x0, [sp, 144]
	cbz	x0, .L2196
	cbz	x21, .L2196
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L2196:
	ldr	x0, [sp, 160]
	cbz	x0, .L2156
	ldr	x1, [sp, 176]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L2156:
	mov	x0, x19
	ldr	d8, [sp, 96]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2210:
	.cfi_restore_state
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L2162
	mov	x4, x5
	fneg	s1, s1
	ldp	x1, x0, [sp, 168]
	str	w7, [x4, 4]
	str	s2, [x4]
	str	s1, [sp, 144]
	cmp	x1, x0
	bne	.L2235
.L2163:
	add	x28, sp, 160
	add	x3, sp, 124
	mov	x0, x28
	add	x2, sp, 144
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x7, [sp, 168]
	ldr	w8, [sp, 124]
	ldr	w9, [x7, -4]
	ldr	s1, [x7, -8]
	b	.L2164
	.p2align 2,,3
.L2211:
	sub	x3, x2, #1
	ldr	w6, [x5, 4]
	str	s0, [x0, x1]
	mov	x1, x2
	add	x3, x3, x3, lsr 63
	str	w6, [x4, 4]
	asr	x2, x3, 1
	cmp	x1, 0
	bgt	.L2168
	mov	x4, x5
	b	.L2166
	.p2align 2,,3
.L2173:
	ldp	x2, x0, [sp, 168]
	fneg	s1, s0
	str	s1, [sp, 144]
	cmp	x2, x0
	beq	.L2176
	ldr	w8, [sp, 136]
	add	x0, x2, 8
	str	s1, [x2]
	str	w8, [x2, 4]
	str	x0, [sp, 168]
.L2177:
	ldr	x4, [sp, 160]
	sub	x3, x0, x4
	asr	x0, x3, 3
	sub	x2, x0, #2
	sub	x0, x0, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x0, 0
	ble	.L2178
	.p2align 3,,7
.L2181:
	lsl	x3, x2, 3
	lsl	x0, x0, 3
	add	x6, x4, x3
	add	x5, x4, x0
	ldr	s2, [x4, x3]
	fcmpe	s2, s1
	bmi	.L2212
.L2179:
	ldr	x0, [x19, 16]
	str	s1, [x5]
	str	w8, [x5, 4]
	cmp	x0, x1
	beq	.L2182
.L2236:
	ldr	s2, [sp, 140]
	add	x5, x1, 8
	ldr	w9, [sp, 136]
	str	w9, [x1, 4]
	str	s2, [x1]
	str	x5, [x19, 8]
.L2183:
	ldr	x1, [x19]
	sub	x3, x5, x1
	asr	x8, x3, 3
	sub	x0, x8, #2
	sub	x2, x8, #1
	add	x0, x0, x0, lsr 63
	asr	x0, x0, 1
	cmp	x2, 0
	ble	.L2184
	.p2align 3,,7
.L2187:
	lsl	x3, x0, 3
	lsl	x2, x2, 3
	add	x6, x1, x3
	add	x4, x1, x2
	ldr	s1, [x1, x3]
	fcmpe	s1, s2
	bmi	.L2213
.L2185:
	str	s2, [x4]
	str	w9, [x4, 4]
	cmp	x22, x8
	bcs	.L2188
	.p2align 3,,7
.L2189:
	mov	x0, x19
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x1, x5, [x19]
	sub	x0, x5, x1
	cmp	x22, x0, asr 3
	bcc	.L2189
.L2188:
	cmp	x1, x5
	beq	.L2172
	ldr	s8, [x1]
	b	.L2172
	.p2align 2,,3
.L2212:
	sub	x3, x2, #1
	ldr	w7, [x6, 4]
	str	s2, [x4, x0]
	mov	x0, x2
	add	x3, x3, x3, lsr 63
	str	w7, [x5, 4]
	asr	x2, x3, 1
	cmp	x0, 0
	bgt	.L2181
	mov	x5, x6
	ldr	x0, [x19, 16]
	str	s1, [x5]
	str	w8, [x5, 4]
	cmp	x0, x1
	bne	.L2236
.L2182:
	add	x3, sp, 136
	add	x2, sp, 140
	mov	x0, x19
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x5, [x19, 8]
	ldr	w9, [x5, -4]
	ldr	s2, [x5, -8]
	b	.L2183
	.p2align 2,,3
.L2213:
	sub	x3, x0, #1
	ldr	w7, [x6, 4]
	str	s1, [x1, x2]
	mov	x2, x0
	add	x3, x3, x3, lsr 63
	str	w7, [x4, 4]
	asr	x0, x3, 1
	cmp	x2, 0
	bgt	.L2187
	mov	x4, x6
	b	.L2185
	.p2align 2,,3
.L2176:
	mov	x1, x2
	add	x3, sp, 136
	add	x2, sp, 144
	add	x0, sp, 160
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x0, [sp, 168]
	ldr	x1, [x19, 8]
	ldr	w8, [x0, -4]
	ldr	s1, [x0, -8]
	b	.L2177
.L2178:
	sub	x0, x3, #8
	add	x5, x4, x0
	b	.L2179
.L2184:
	sub	x3, x3, #8
	add	x4, x1, x3
	b	.L2185
.L2157:
	add	x28, sp, 160
	add	x3, sp, 124
	add	x2, sp, 140
	mov	x0, x19
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE189:
	ldr	x0, [x19, 8]
	ldr	s1, [sp, 140]
	ldr	w7, [x0, -4]
	ldr	s2, [x0, -8]
	b	.L2158
.L2192:
	add	x22, x20, 16
	mov	x5, 1152921504606846975
	ldp	x4, x6, [x20, 48]
	ldp	x3, x23, [x22, 16]
	ldr	x1, [x20, 72]
	sub	x4, x4, x6
	sub	x1, x1, x23
	sub	x3, x3, x0
	asr	x0, x4, 3
	asr	x1, x1, 3
	sub	x1, x1, #1
	add	x0, x0, x1, lsl 6
	add	x0, x0, x3, asr 3
	cmp	x0, x5
	beq	.L2237
	ldr	x0, [x20]
	cmp	x23, x0
	beq	.L2238
.L2195:
	mov	x0, 512
.LEHB190:
	bl	_Znwm
	ldrb	w1, [sp, 152]
	str	x0, [x23, -8]
	ldr	x0, [x20, 40]
	sub	x2, x0, #8
	ldr	x0, [x0, -8]
	str	x2, [x22, 24]
	str	x0, [x22, 8]
	add	x2, x0, 512
	str	x2, [x22, 16]
	add	x2, x0, 504
	str	x2, [x20, 16]
	ldr	x2, [sp, 112]
	str	x2, [x0, 504]
	cbz	w1, .L2196
	b	.L2193
	.p2align 2,,3
.L2238:
	mov	x0, x20
	mov	x1, 1
	bl	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
	ldr	x23, [x20, 40]
	b	.L2195
.L2159:
	sub	x0, x2, #8
	add	x4, x3, x0
	b	.L2160
.L2165:
	sub	x3, x3, #8
	add	x4, x0, x3
	b	.L2166
.L2237:
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
	bl	_ZSt20__throw_length_errorPKc
.LEHE190:
.L2234:
	add	x28, sp, 160
.LEHB191:
	bl	_ZSt20__throw_system_errori
.LEHE191:
.L2208:
	mov	x20, x0
.L2201:
	mov	x0, x28
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	mov	x0, x19
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	mov	x0, x20
.LEHB192:
	bl	_Unwind_Resume
.LEHE192:
.L2209:
	ldrb	w1, [sp, 152]
	mov	x20, x0
	cbz	w1, .L2200
	add	x0, sp, 144
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L2200:
	add	x28, sp, 160
	b	.L2201
	.cfi_endproc
.LFE8391:
	.section	.gcc_except_table
.LLSDA8391:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8391-.LLSDACSB8391
.LLSDACSB8391:
	.uleb128 .LEHB188-.LFB8391
	.uleb128 .LEHE188-.LEHB188
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB189-.LFB8391
	.uleb128 .LEHE189-.LEHB189
	.uleb128 .L2208-.LFB8391
	.uleb128 0
	.uleb128 .LEHB190-.LFB8391
	.uleb128 .LEHE190-.LEHB190
	.uleb128 .L2209-.LFB8391
	.uleb128 0
	.uleb128 .LEHB191-.LFB8391
	.uleb128 .LEHE191-.LEHB191
	.uleb128 .L2208-.LFB8391
	.uleb128 0
	.uleb128 .LEHB192-.LFB8391
	.uleb128 .LEHE192-.LEHB192
	.uleb128 0
	.uleb128 0
.LLSDACSE8391:
	.section	.text._ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE,"axG",@progbits,_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE,comdat
	.size	_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE, .-_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE
	.section	.text._ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB8513:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x23, x24, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	sub	x0, x24, x23
	str	x27, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	mov	x27, x2
	asr	x0, x0, 4
	mov	x2, 576460752303423487
	cmp	x0, x2
	beq	.L2257
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x23
	csinc	x1, x0, xzr, ne
	adds	x1, x1, x0
	bcs	.L2250
	cbnz	x1, .L2244
	mov	x25, 16
	mov	x22, 0
	mov	x21, 0
.L2249:
	add	x2, x21, x26
	ldp	x0, x1, [x27]
	stp	x0, x1, [x2]
	cmp	x19, x23
	beq	.L2245
	mov	x4, x21
	mov	x3, x23
	.p2align 3,,7
.L2246:
	ldp	x6, x7, [x3], 16
	stp	x6, x7, [x4], 16
	cmp	x3, x19
	bne	.L2246
	add	x26, x26, 16
	add	x25, x21, x26
.L2245:
	cmp	x19, x24
	beq	.L2247
	sub	x2, x24, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L2247:
	cbz	x23, .L2248
	ldr	x1, [x20, 16]
	mov	x0, x23
	sub	x1, x1, x23
	bl	_ZdlPvm
.L2248:
	ldp	x23, x24, [sp, 48]
	ldr	x27, [sp, 80]
	stp	x21, x25, [x20]
	str	x22, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2250:
	.cfi_restore_state
	mov	x22, 9223372036854775792
.L2243:
	mov	x0, x22
	bl	_Znwm
	mov	x21, x0
	add	x22, x0, x22
	add	x25, x0, 16
	b	.L2249
.L2244:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 4
	b	.L2243
.L2257:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE8513:
	.size	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.text._ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE,"axG",@progbits,_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE
	.type	_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE, %function
_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE:
.LFB8330:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA8330
	stp	x29, x30, [sp, -288]!
	.cfi_def_cfa_offset 288
	.cfi_offset 29, -288
	.cfi_offset 30, -280
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -272
	.cfi_offset 20, -264
	mov	x19, x0
	stp	xzr, xzr, [x8]
	str	xzr, [x8, 16]
	str	x8, [sp, 128]
	str	x2, [sp, 144]
	add	x0, x0, 16
	ldar	x0, [x0]
	cbz	x0, .L2258
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -216
	.cfi_offset 25, -224
	mov	x0, x1
	ldr	w25, [x19, 216]
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -232
	.cfi_offset 23, -240
	mov	x23, x1
	uxtw	x20, w25
	ldr	x1, [x19, 24]
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -200
	.cfi_offset 27, -208
	mov	x28, x3
	ldr	x4, [x19, 232]
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -248
	.cfi_offset 21, -256
	ldp	x3, x2, [x19, 304]
	madd	x1, x20, x1, x4
	ldr	x4, [x19, 256]
	str	d8, [sp, 96]
	.cfi_offset 72, -192
	add	x1, x4, x1
.LEHB193:
	blr	x3
	ldr	w0, [x19, 104]
	fmov	s8, s0
	cmp	w0, 0
	ble	.L2260
	sxtw	x27, w0
	sub	w0, w0, #1
	sub	x1, x27, #2
	add	x26, x19, 448
	sub	x0, x1, x0
	sub	x27, x27, #1
	str	x0, [sp, 136]
	add	x0, x19, 440
	str	x0, [sp, 120]
	.p2align 3,,7
.L2263:
	ldr	x0, [x19, 32]
	ldr	x1, [x19, 264]
	mul	x0, x27, x0
	ldr	x1, [x1, x20, lsl 3]
	add	x20, x1, x0
	ldrh	w22, [x1, x0]
.L2437:
	ldaxr	x0, [x26]
	add	x0, x0, 1
	stlxr	w1, x0, [x26]
	cbnz	w1, .L2437
	ldr	x1, [sp, 120]
	and	x0, x22, 65535
.L2438:
	ldaxr	x2, [x1]
	add	x2, x2, x0
	stlxr	w3, x2, [x1]
	cbnz	w3, .L2438
	cbz	w22, .L2261
	sub	w22, w22, #1
	add	x0, x20, 8
	add	x20, x20, 4
	mov	w24, 0
	add	x22, x0, x22, uxtw 2
	.p2align 3,,7
.L2268:
	ldr	w21, [x20]
	ldr	x0, [x19, 8]
	uxtw	x1, w21
	cmp	x1, x0
	bhi	.L2425
	ldr	x5, [x19, 24]
	mov	x0, x23
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	madd	x1, x1, x5, x4
	ldr	x4, [x19, 256]
	add	x1, x4, x1
	blr	x3
.LEHE193:
	fcmpe	s0, s8
	bmi	.L2362
.L2265:
	add	x20, x20, 4
	cmp	x20, x22
	bne	.L2268
	uxtw	x20, w25
	cbnz	w24, .L2263
	.p2align 3,,7
.L2261:
	ldr	x0, [sp, 136]
	sub	x27, x27, #1
	cmp	x0, x27
	beq	.L2260
	uxtw	x20, w25
	b	.L2263
.L2260:
	stp	xzr, xzr, [sp, 192]
	str	xzr, [sp, 208]
	add	x0, x19, 40
	ldar	x0, [x0]
	orr	x0, x28, x0
	cbz	x0, .L2426
	ldr	x20, [x19, 80]
	add	x21, sp, 192
	ldr	x1, [sp, 144]
	str	w25, [sp, 164]
	ldr	x0, [x19, 112]
	cmp	x20, x1
	csel	x20, x20, x1, cs
.LEHB194:
	bl	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv
.LEHE194:
	ldr	w2, [sp, 164]
	mov	x4, x0
	ldr	x3, [x19, 24]
	str	x4, [sp, 152]
	ldr	x1, [x19, 256]
	mul	x0, x2, x3
	ldrh	w24, [x4]
	ldr	x2, [x19, 240]
	ldr	x22, [x4, 8]
	add	x4, x1, x0
	add	x2, x4, x2
	stp	xzr, xzr, [sp, 224]
	str	xzr, [sp, 240]
	stp	xzr, xzr, [sp, 256]
	str	xzr, [sp, 272]
	ldrb	w2, [x2, 2]
	tbnz	x2, 0, .L2427
	cbz	x28, .L2277
	ldr	x3, [x28]
	adrp	x2, _ZN7hnswlib17BaseFilterFunctorclEm
	add	x2, x2, :lo12:_ZN7hnswlib17BaseFilterFunctorclEm
	ldr	x3, [x3]
	cmp	x3, x2
	bne	.L2428
.L2277:
	ldr	x2, [x19, 232]
	add	x3, sp, 256
	str	x3, [sp, 136]
	add	x27, sp, 224
	add	x0, x0, x2
	ldr	x3, [x19, 304]
	add	x1, x1, x0
	ldr	x2, [x19, 312]
	mov	x0, x23
.LEHB195:
	blr	x3
	ldp	x1, x0, [sp, 232]
	str	s0, [sp, 172]
	fmov	s8, s0
	cmp	x1, x0
	beq	.L2429
	ldr	w7, [sp, 164]
	fmov	s2, s0
	fmov	s1, s0
	str	s0, [x1]
	str	w7, [x1, 4]
	add	x0, x1, 8
	str	x0, [sp, 232]
.L2289:
	ldr	x4, [sp, 224]
	sub	x2, x0, x4
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L2290
.L2293:
	lsl	x3, x1, 3
	lsl	x0, x0, 3
	add	x5, x4, x3
	add	x2, x4, x0
	ldr	s0, [x4, x3]
	fcmpe	s0, s2
	bmi	.L2364
.L2291:
	ldp	x1, x0, [sp, 264]
	fneg	s1, s1
	str	w7, [x2, 4]
	str	s2, [x2]
	str	s1, [sp, 176]
	cmp	x1, x0
	beq	.L2294
	ldr	w5, [sp, 164]
	add	x4, x1, 8
	str	s1, [x1]
	mov	w9, w5
	str	w5, [x1, 4]
	str	x4, [sp, 264]
.L2295:
	ldr	x0, [sp, 256]
	sub	x3, x4, x0
	asr	x1, x3, 3
	sub	x2, x1, #2
	sub	x1, x1, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x1, 0
	ble	.L2296
.L2299:
	lsl	x3, x2, 3
	lsl	x1, x1, 3
	add	x7, x0, x3
	add	x6, x0, x1
	ldr	s0, [x0, x3]
	fcmpe	s0, s1
	bmi	.L2365
.L2297:
	str	w9, [x6, 4]
	str	s1, [x6]
.L2287:
	strh	w24, [x22, w5, uxtw 1]
	cmp	x4, x0
	beq	.L2300
	.p2align 3,,7
.L2304:
	ldr	s0, [x0]
	ldr	w21, [x0, 4]
	fneg	s0, s0
	fcmpe	s0, s8
	bgt	.L2366
.L2301:
	add	x0, sp, 256
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldr	x3, [x19, 24]
	uxtw	x0, w21
	ldr	x2, [x19, 240]
	add	x1, sp, 256
	str	x1, [sp, 136]
	mov	x21, 1
	ldr	x1, [x19, 256]
	madd	x0, x0, x3, x2
	add	x26, x1, x0
	ldrh	w25, [x1, x0]
	cbz	x25, .L2326
	adrp	x0, _ZN7hnswlib17BaseFilterFunctorclEm
	add	x0, x0, :lo12:_ZN7hnswlib17BaseFilterFunctorclEm
	str	x0, [sp, 120]
	b	.L2303
	.p2align 2,,3
.L2430:
	fcmpe	s8, s0
	bgt	.L2306
.L2305:
	add	x0, x21, 1
	cmp	x25, x21
	beq	.L2326
.L2432:
	mov	x21, x0
.L2303:
	ldr	w1, [x26, x21, lsl 2]
	sbfiz	x0, x1, 1, 32
	ldrh	w2, [x22, x0]
	str	w1, [sp, 168]
	cmp	w2, w24
	beq	.L2305
	ldr	x5, [x19, 24]
	uxtw	x1, w1
	ldr	x4, [x19, 232]
	add	x27, sp, 224
	ldp	x3, x2, [x19, 304]
	strh	w24, [x22, x0]
	madd	x1, x1, x5, x4
	mov	x0, x23
	ldr	x4, [x19, 256]
	add	x1, x4, x1
	blr	x3
.LEHE195:
	ldp	x1, x0, [sp, 224]
	str	s0, [sp, 172]
	sub	x0, x0, x1
	cmp	x20, x0, asr 3
	bls	.L2430
.L2306:
	ldp	x1, x0, [sp, 264]
	fneg	s0, s0
	str	s0, [sp, 176]
	cmp	x1, x0
	beq	.L2309
	ldr	w7, [sp, 168]
	add	x0, x1, 8
	str	s0, [x1]
	mov	w8, w7
	str	w7, [x1, 4]
	str	x0, [sp, 264]
.L2310:
	ldr	x3, [sp, 256]
	sub	x2, x0, x3
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L2311
	.p2align 3,,7
.L2314:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s1, [x3, x2]
	fcmpe	s1, s0
	bmi	.L2367
.L2312:
	ldr	x2, [x19, 24]
	uxtw	x7, w7
	ldr	x1, [x19, 256]
	ldr	x0, [x19, 240]
	str	w8, [x4, 4]
	madd	x7, x7, x2, x1
	str	s0, [x4]
	add	x0, x7, x0
	ldrb	w0, [x0, 2]
	tbnz	x0, 0, .L2421
	cbz	x28, .L2317
	ldr	x0, [x28]
	ldr	x2, [x0]
	ldr	x0, [sp, 120]
	cmp	x2, x0
	bne	.L2431
.L2317:
	ldp	x1, x0, [sp, 232]
	cmp	x1, x0
	beq	.L2318
	ldr	s1, [sp, 172]
	add	x2, x1, 8
	ldr	w9, [sp, 168]
	str	w9, [x1, 4]
	str	s1, [x1]
	str	x2, [sp, 232]
.L2319:
	ldr	x0, [sp, 224]
	sub	x4, x2, x0
	asr	x8, x4, 3
	sub	x1, x8, #2
	sub	x3, x8, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x3, 0
	ble	.L2320
	.p2align 3,,7
.L2323:
	lsl	x4, x1, 3
	lsl	x3, x3, 3
	add	x6, x0, x4
	add	x5, x0, x3
	ldr	s0, [x0, x4]
	fcmpe	s0, s1
	bmi	.L2368
.L2321:
	str	w9, [x5, 4]
	str	s1, [x5]
.L2316:
	cmp	x8, x20
	bls	.L2324
	.p2align 3,,7
.L2325:
	add	x0, sp, 224
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x0, x2, [sp, 224]
	sub	x1, x2, x0
	cmp	x20, x1, asr 3
	bcc	.L2325
.L2324:
	cmp	x0, x2
	beq	.L2305
	ldr	s8, [x0]
	add	x0, x21, 1
	cmp	x25, x21
	bne	.L2432
.L2326:
	ldp	x0, x1, [sp, 256]
	cmp	x0, x1
	bne	.L2304
.L2300:
	adrp	x0, .LC5
	strb	wzr, [sp, 184]
	ldr	x20, [x19, 112]
	ldr	x23, [x0, #:lo12:.LC5]
	add	x0, x20, 80
	str	x0, [sp, 176]
	cbz	x23, .L2327
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2433
.L2327:
	ldp	x1, x0, [x20, 16]
	mov	w2, 1
	strb	w2, [sp, 184]
	cmp	x1, x0
	beq	.L2328
	ldr	x0, [sp, 152]
	str	x0, [x1, -8]!
	str	x1, [x20, 16]
.L2329:
	ldr	x0, [sp, 176]
	cbz	x0, .L2332
	cbz	x23, .L2332
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L2332:
	ldr	x0, [sp, 256]
	cbz	x0, .L2334
	ldr	x1, [sp, 272]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L2334:
	ldr	x0, [sp, 192]
	ldr	x1, [sp, 224]
	str	x1, [sp, 192]
	ldr	x1, [sp, 232]
	str	x1, [sp, 200]
	ldr	x2, [sp, 240]
	str	xzr, [sp, 224]
	str	xzr, [sp, 232]
	str	xzr, [sp, 240]
	ldr	x1, [sp, 208]
	str	x2, [sp, 208]
	cbz	x0, .L2275
	sub	x1, x1, x0
	bl	_ZdlPvm
	ldr	x0, [sp, 224]
	ldr	x1, [sp, 240]
	sub	x1, x1, x0
	cbz	x0, .L2275
	bl	_ZdlPvm
.L2275:
	add	x21, sp, 192
	ldr	x0, [sp, 192]
	b	.L2424
	.p2align 2,,3
.L2341:
	mov	x0, x21
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldr	x0, [sp, 192]
.L2424:
	ldr	x1, [sp, 200]
	ldr	x3, [sp, 144]
	sub	x2, x1, x0
	cmp	x3, x2, asr 3
	bcc	.L2341
	add	x21, sp, 192
	cmp	x1, x0
	bne	.L2347
	b	.L2343
	.p2align 2,,3
.L2434:
	ldp	x2, x3, [sp, 256]
	stp	x2, x3, [x1], 16
	str	x1, [x4, 8]
.L2346:
	ldr	x0, [sp, 128]
	mov	x2, 0
	ldr	s0, [x1, -16]
	ldr	x3, [x1, -8]
	ldr	x0, [x0]
	sub	x4, x1, x0
	asr	x1, x4, 4
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	mov	x0, x21
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x0, x1, [sp, 192]
	cmp	x1, x0
	beq	.L2343
.L2347:
	ldp	x3, x1, [x19, 248]
	ldr	w2, [x0, 4]
	ldr	x4, [x19, 24]
	ldr	s0, [x0]
	madd	x2, x2, x4, x1
	ldr	x4, [sp, 128]
	ldr	x2, [x2, x3]
	str	s0, [sp, 256]
	ldp	x1, x0, [x4, 8]
	str	x2, [sp, 264]
	cmp	x1, x0
	bne	.L2434
	ldr	x20, [sp, 128]
	add	x2, sp, 256
	mov	x0, x20
.LEHB196:
	bl	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x1, [x20, 8]
	b	.L2346
.L2343:
	cbz	x0, .L2420
	ldr	x1, [sp, 208]
	sub	x1, x1, x0
	bl	_ZdlPvm
.L2420:
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldr	d8, [sp, 96]
	.cfi_restore 72
.L2258:
	ldp	x19, x20, [sp, 16]
	ldr	x0, [sp, 128]
	ldp	x29, x30, [sp], 288
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2362:
	.cfi_def_cfa_offset 288
	.cfi_offset 19, -272
	.cfi_offset 20, -264
	.cfi_offset 21, -256
	.cfi_offset 22, -248
	.cfi_offset 23, -240
	.cfi_offset 24, -232
	.cfi_offset 25, -224
	.cfi_offset 26, -216
	.cfi_offset 27, -208
	.cfi_offset 28, -200
	.cfi_offset 29, -288
	.cfi_offset 30, -280
	.cfi_offset 72, -192
	fmov	s8, s0
	mov	w25, w21
	mov	w24, 1
	b	.L2265
.L2364:
	sub	x3, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x4, x0]
	mov	x0, x1
	add	x3, x3, x3, lsr 63
	str	w6, [x2, 4]
	asr	x1, x3, 1
	cmp	x0, 0
	bgt	.L2293
	mov	x2, x5
	b	.L2291
	.p2align 2,,3
.L2365:
	sub	x3, x2, #1
	ldr	w8, [x7, 4]
	str	s0, [x0, x1]
	mov	x1, x2
	add	x3, x3, x3, lsr 63
	str	w8, [x6, 4]
	asr	x2, x3, 1
	cmp	x1, 0
	bgt	.L2299
	mov	x6, x7
	b	.L2297
	.p2align 2,,3
.L2367:
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s1, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L2314
	mov	x4, x5
	b	.L2312
	.p2align 2,,3
.L2368:
	sub	x4, x1, #1
	ldr	w7, [x6, 4]
	str	s0, [x0, x3]
	mov	x3, x1
	add	x4, x4, x4, lsr 63
	str	w7, [x5, 4]
	asr	x1, x4, 1
	cmp	x3, 0
	bgt	.L2323
	mov	x5, x6
	b	.L2321
.L2426:
	ldr	x3, [x19, 80]
	mov	x2, x23
	ldr	x0, [sp, 144]
	mov	w1, w25
	add	x8, sp, 256
	add	x21, sp, 192
	cmp	x3, x0
	mov	x5, 0
	csel	x3, x3, x0, cs
	mov	x4, 0
	mov	x0, x19
	bl	_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE
.LEHE196:
	ldr	x0, [sp, 192]
	ldr	x1, [sp, 256]
	str	x1, [sp, 192]
	ldr	x1, [sp, 264]
	str	x1, [sp, 200]
	ldr	x2, [sp, 272]
	str	xzr, [sp, 256]
	str	xzr, [sp, 264]
	str	xzr, [sp, 272]
	ldr	x1, [sp, 208]
	str	x2, [sp, 208]
	cbz	x0, .L2275
	sub	x1, x1, x0
	bl	_ZdlPvm
	ldr	x0, [sp, 256]
	ldr	x1, [sp, 272]
	sub	x1, x1, x0
	cbz	x0, .L2275
	bl	_ZdlPvm
	b	.L2275
	.p2align 2,,3
.L2431:
	ldr	x1, [x19, 248]
	add	x27, sp, 224
	mov	x0, x28
	ldr	x1, [x7, x1]
.LEHB197:
	blr	x2
	tst	w0, 255
	bne	.L2317
	.p2align 3,,7
.L2421:
	ldp	x0, x2, [sp, 224]
	sub	x8, x2, x0
	asr	x8, x8, 3
	b	.L2316
	.p2align 2,,3
.L2309:
	add	x27, sp, 224
	add	x3, sp, 168
	add	x2, sp, 176
	add	x0, sp, 256
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x0, [sp, 264]
	ldr	w7, [sp, 168]
	ldr	w8, [x0, -4]
	ldr	s0, [x0, -8]
	b	.L2310
	.p2align 2,,3
.L2366:
	ldp	x1, x0, [sp, 224]
	sub	x0, x0, x1
	cmp	x20, x0, asr 3
	bne	.L2301
	b	.L2300
	.p2align 2,,3
.L2311:
	sub	x0, x2, #8
	add	x4, x3, x0
	b	.L2312
.L2318:
	add	x27, sp, 224
	add	x3, sp, 168
	add	x2, sp, 172
	mov	x0, x27
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE197:
	ldr	x2, [sp, 232]
	ldr	w9, [x2, -4]
	ldr	s1, [x2, -8]
	b	.L2319
.L2320:
	sub	x4, x4, #8
	add	x5, x0, x4
	b	.L2321
.L2328:
	add	x21, x20, 16
	mov	x5, 1152921504606846975
	ldp	x4, x6, [x20, 48]
	ldp	x3, x22, [x21, 16]
	ldr	x0, [x20, 72]
	sub	x4, x4, x6
	sub	x0, x0, x22
	sub	x1, x3, x1
	asr	x3, x4, 3
	asr	x0, x0, 3
	sub	x0, x0, #1
	add	x0, x3, x0, lsl 6
	add	x0, x0, x1, asr 3
	cmp	x0, x5
	beq	.L2435
	ldr	x0, [x20]
	cmp	x22, x0
	beq	.L2436
.L2331:
	mov	x0, 512
.LEHB198:
	bl	_Znwm
	ldrb	w1, [sp, 184]
	str	x0, [x22, -8]
	ldr	x0, [x20, 40]
	sub	x2, x0, #8
	ldr	x0, [x0, -8]
	str	x2, [x21, 24]
	str	x0, [x21, 8]
	add	x2, x0, 512
	str	x2, [x21, 16]
	add	x2, x0, 504
	str	x2, [x20, 16]
	ldr	x2, [sp, 152]
	str	x2, [x0, 504]
	cbz	w1, .L2332
	b	.L2329
	.p2align 2,,3
.L2436:
	mov	x0, x20
	mov	x1, 1
	bl	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
.LEHE198:
	ldr	x22, [x20, 40]
	b	.L2331
.L2294:
	add	x0, sp, 256
	add	x27, sp, 224
	add	x3, sp, 164
	add	x2, sp, 176
	str	x0, [sp, 136]
.LEHB199:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x4, [sp, 264]
	ldr	w5, [sp, 164]
	ldr	w9, [x4, -4]
	ldr	s1, [x4, -8]
	b	.L2295
.L2429:
	add	x2, sp, 256
	add	x27, sp, 224
	mov	x0, x27
	add	x3, sp, 164
	str	x2, [sp, 136]
	add	x2, sp, 172
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x0, [sp, 232]
	ldr	s1, [sp, 172]
	ldr	w7, [x0, -4]
	ldr	s2, [x0, -8]
	b	.L2289
.L2428:
	ldr	x1, [x19, 248]
	add	x0, sp, 256
	str	x0, [sp, 136]
	add	x27, sp, 224
	mov	x0, x28
	ldr	x1, [x4, x1]
	blr	x3
	tst	w0, 255
	bne	.L2278
	ldp	x1, x0, [sp, 264]
	mvni	v0.2s, 0x80, lsl 16
	str	s0, [sp, 176]
	cmp	x1, x0
	beq	.L2280
	ldr	w5, [sp, 164]
	fmov	s1, s0
	str	s0, [x1]
	add	x4, x1, 8
	mov	w9, w5
	str	w5, [x1, 4]
	str	x4, [sp, 264]
.L2282:
	ldr	x0, [sp, 256]
	sub	x3, x4, x0
	asr	x1, x3, 3
	sub	x2, x1, #2
	sub	x1, x1, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x1, 0
	ble	.L2283
.L2286:
	lsl	x3, x2, 3
	lsl	x1, x1, 3
	add	x7, x0, x3
	add	x6, x0, x1
	ldr	s0, [x0, x3]
	fcmpe	s0, s1
	bmi	.L2363
.L2284:
	mov	w1, 2139095039
	fmov	s8, w1
	str	s1, [x6]
	str	w9, [x6, 4]
	b	.L2287
.L2363:
	sub	x3, x2, #1
	ldr	w8, [x7, 4]
	str	s0, [x0, x1]
	mov	x1, x2
	add	x3, x3, x3, lsr 63
	str	w8, [x6, 4]
	asr	x2, x3, 1
	cmp	x1, 0
	bgt	.L2286
	mov	x6, x7
	b	.L2284
.L2427:
	mvni	v0.2s, 0x80, lsl 16
	mov	x1, 0
	str	s0, [sp, 176]
.L2280:
	add	x0, sp, 256
	add	x27, sp, 224
	add	x3, sp, 164
	add	x2, sp, 176
	str	x0, [sp, 136]
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE199:
	ldr	x4, [sp, 264]
	ldr	w5, [sp, 164]
	ldr	w9, [x4, -4]
	ldr	s1, [x4, -8]
	b	.L2282
.L2283:
	sub	x3, x3, #8
	add	x6, x0, x3
	b	.L2284
.L2278:
	ldr	w0, [sp, 164]
	ldr	x2, [x19, 24]
	ldr	x1, [x19, 256]
	mul	x0, x0, x2
	b	.L2277
.L2296:
	sub	x3, x3, #8
	add	x6, x0, x3
	b	.L2297
.L2290:
	sub	x2, x2, #8
	add	x2, x4, x2
	b	.L2291
.L2435:
	adrp	x0, .LC25
	add	x0, x0, :lo12:.LC25
.LEHB200:
	bl	_ZSt20__throw_length_errorPKc
.LEHE200:
.L2433:
	add	x1, sp, 256
	add	x27, sp, 224
	str	x1, [sp, 136]
.LEHB201:
	bl	_ZSt20__throw_system_errori
.LEHE201:
.L2361:
	ldrb	w1, [sp, 184]
	mov	x19, x0
	cbz	w1, .L2336
	add	x0, sp, 176
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L2336:
	add	x27, sp, 224
	add	x0, sp, 256
	str	x0, [sp, 136]
.L2337:
	ldr	x0, [sp, 136]
	add	x21, sp, 192
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
	mov	x0, x27
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
.L2340:
	mov	x0, x21
	bl	_ZNSt12_Vector_baseISt4pairIfjESaIS1_EED2Ev
.L2349:
	ldr	x0, [sp, 128]
	bl	_ZNSt12_Vector_baseISt4pairIfmESaIS1_EED2Ev
	mov	x0, x19
.LEHB202:
	bl	_Unwind_Resume
.LEHE202:
.L2359:
	mov	x19, x0
	b	.L2340
.L2357:
	mov	x19, x0
	b	.L2349
.L2360:
	mov	x19, x0
	b	.L2337
.L2425:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC32
	mov	x20, x0
	add	x1, x1, :lo12:.LC32
.LEHB203:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE203:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB204:
	bl	__cxa_throw
.LEHE204:
.L2358:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
	b	.L2349
	.cfi_endproc
.LFE8330:
	.section	.gcc_except_table
.LLSDA8330:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE8330-.LLSDACSB8330
.LLSDACSB8330:
	.uleb128 .LEHB193-.LFB8330
	.uleb128 .LEHE193-.LEHB193
	.uleb128 .L2357-.LFB8330
	.uleb128 0
	.uleb128 .LEHB194-.LFB8330
	.uleb128 .LEHE194-.LEHB194
	.uleb128 .L2359-.LFB8330
	.uleb128 0
	.uleb128 .LEHB195-.LFB8330
	.uleb128 .LEHE195-.LEHB195
	.uleb128 .L2360-.LFB8330
	.uleb128 0
	.uleb128 .LEHB196-.LFB8330
	.uleb128 .LEHE196-.LEHB196
	.uleb128 .L2359-.LFB8330
	.uleb128 0
	.uleb128 .LEHB197-.LFB8330
	.uleb128 .LEHE197-.LEHB197
	.uleb128 .L2360-.LFB8330
	.uleb128 0
	.uleb128 .LEHB198-.LFB8330
	.uleb128 .LEHE198-.LEHB198
	.uleb128 .L2361-.LFB8330
	.uleb128 0
	.uleb128 .LEHB199-.LFB8330
	.uleb128 .LEHE199-.LEHB199
	.uleb128 .L2360-.LFB8330
	.uleb128 0
	.uleb128 .LEHB200-.LFB8330
	.uleb128 .LEHE200-.LEHB200
	.uleb128 .L2361-.LFB8330
	.uleb128 0
	.uleb128 .LEHB201-.LFB8330
	.uleb128 .LEHE201-.LEHB201
	.uleb128 .L2360-.LFB8330
	.uleb128 0
	.uleb128 .LEHB202-.LFB8330
	.uleb128 .LEHE202-.LEHB202
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB203-.LFB8330
	.uleb128 .LEHE203-.LEHB203
	.uleb128 .L2358-.LFB8330
	.uleb128 0
	.uleb128 .LEHB204-.LFB8330
	.uleb128 .LEHE204-.LEHB204
	.uleb128 .L2357-.LFB8330
	.uleb128 0
.LLSDACSE8330:
	.section	.text._ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE,"axG",@progbits,_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE,comdat
	.size	_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE, .-_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE
	.section	.text.startup
	.align	2
	.p2align 4,,11
	.type	_GLOBAL__sub_I__Z11flat_searchPfS_mmm, %function
_GLOBAL__sub_I__Z11flat_searchPfS_mmm:
.LFB8574:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	adrp	x19, .LANCHOR1
	add	x19, x19, :lo12:.LANCHOR1
	mov	x0, x19
	bl	_ZNSt8ios_base4InitC1Ev
	mov	x1, x19
	adrp	x2, __dso_handle
	ldr	x19, [sp, 16]
	add	x2, x2, :lo12:__dso_handle
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	adrp	x0, _ZNSt8ios_base4InitD1Ev
	add	x0, x0, :lo12:_ZNSt8ios_base4InitD1Ev
	b	__cxa_atexit
	.cfi_endproc
.LFE8574:
	.size	_GLOBAL__sub_I__Z11flat_searchPfS_mmm, .-_GLOBAL__sub_I__Z11flat_searchPfS_mmm
	.section	.init_array,"aw"
	.align	3
	.xword	_GLOBAL__sub_I__Z11flat_searchPfS_mmm
	.weak	_ZTSN7hnswlib14SpaceInterfaceIfEE
	.section	.rodata._ZTSN7hnswlib14SpaceInterfaceIfEE,"aG",@progbits,_ZTSN7hnswlib14SpaceInterfaceIfEE,comdat
	.align	3
	.type	_ZTSN7hnswlib14SpaceInterfaceIfEE, %object
	.size	_ZTSN7hnswlib14SpaceInterfaceIfEE, 30
_ZTSN7hnswlib14SpaceInterfaceIfEE:
	.string	"N7hnswlib14SpaceInterfaceIfEE"
	.weak	_ZTIN7hnswlib14SpaceInterfaceIfEE
	.section	.rodata._ZTIN7hnswlib14SpaceInterfaceIfEE,"aG",@progbits,_ZTIN7hnswlib14SpaceInterfaceIfEE,comdat
	.align	3
	.type	_ZTIN7hnswlib14SpaceInterfaceIfEE, %object
	.size	_ZTIN7hnswlib14SpaceInterfaceIfEE, 16
_ZTIN7hnswlib14SpaceInterfaceIfEE:
	.xword	_ZTVN10__cxxabiv117__class_type_infoE+16
	.xword	_ZTSN7hnswlib14SpaceInterfaceIfEE
	.weak	_ZTSN7hnswlib17InnerProductSpaceE
	.section	.rodata._ZTSN7hnswlib17InnerProductSpaceE,"aG",@progbits,_ZTSN7hnswlib17InnerProductSpaceE,comdat
	.align	3
	.type	_ZTSN7hnswlib17InnerProductSpaceE, %object
	.size	_ZTSN7hnswlib17InnerProductSpaceE, 30
_ZTSN7hnswlib17InnerProductSpaceE:
	.string	"N7hnswlib17InnerProductSpaceE"
	.weak	_ZTIN7hnswlib17InnerProductSpaceE
	.section	.rodata._ZTIN7hnswlib17InnerProductSpaceE,"aG",@progbits,_ZTIN7hnswlib17InnerProductSpaceE,comdat
	.align	3
	.type	_ZTIN7hnswlib17InnerProductSpaceE, %object
	.size	_ZTIN7hnswlib17InnerProductSpaceE, 24
_ZTIN7hnswlib17InnerProductSpaceE:
	.xword	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.xword	_ZTSN7hnswlib17InnerProductSpaceE
	.xword	_ZTIN7hnswlib14SpaceInterfaceIfEE
	.weak	_ZTSN7hnswlib18AlgorithmInterfaceIfEE
	.section	.rodata._ZTSN7hnswlib18AlgorithmInterfaceIfEE,"aG",@progbits,_ZTSN7hnswlib18AlgorithmInterfaceIfEE,comdat
	.align	3
	.type	_ZTSN7hnswlib18AlgorithmInterfaceIfEE, %object
	.size	_ZTSN7hnswlib18AlgorithmInterfaceIfEE, 34
_ZTSN7hnswlib18AlgorithmInterfaceIfEE:
	.string	"N7hnswlib18AlgorithmInterfaceIfEE"
	.weak	_ZTIN7hnswlib18AlgorithmInterfaceIfEE
	.section	.rodata._ZTIN7hnswlib18AlgorithmInterfaceIfEE,"aG",@progbits,_ZTIN7hnswlib18AlgorithmInterfaceIfEE,comdat
	.align	3
	.type	_ZTIN7hnswlib18AlgorithmInterfaceIfEE, %object
	.size	_ZTIN7hnswlib18AlgorithmInterfaceIfEE, 16
_ZTIN7hnswlib18AlgorithmInterfaceIfEE:
	.xword	_ZTVN10__cxxabiv117__class_type_infoE+16
	.xword	_ZTSN7hnswlib18AlgorithmInterfaceIfEE
	.weak	_ZTSN7hnswlib15HierarchicalNSWIfEE
	.section	.rodata._ZTSN7hnswlib15HierarchicalNSWIfEE,"aG",@progbits,_ZTSN7hnswlib15HierarchicalNSWIfEE,comdat
	.align	3
	.type	_ZTSN7hnswlib15HierarchicalNSWIfEE, %object
	.size	_ZTSN7hnswlib15HierarchicalNSWIfEE, 31
_ZTSN7hnswlib15HierarchicalNSWIfEE:
	.string	"N7hnswlib15HierarchicalNSWIfEE"
	.weak	_ZTIN7hnswlib15HierarchicalNSWIfEE
	.section	.rodata._ZTIN7hnswlib15HierarchicalNSWIfEE,"aG",@progbits,_ZTIN7hnswlib15HierarchicalNSWIfEE,comdat
	.align	3
	.type	_ZTIN7hnswlib15HierarchicalNSWIfEE, %object
	.size	_ZTIN7hnswlib15HierarchicalNSWIfEE, 24
_ZTIN7hnswlib15HierarchicalNSWIfEE:
	.xword	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.xword	_ZTSN7hnswlib15HierarchicalNSWIfEE
	.xword	_ZTIN7hnswlib18AlgorithmInterfaceIfEE
	.weak	_ZTVN7hnswlib17InnerProductSpaceE
	.section	.rodata._ZTVN7hnswlib17InnerProductSpaceE,"aG",@progbits,_ZTVN7hnswlib17InnerProductSpaceE,comdat
	.align	3
	.type	_ZTVN7hnswlib17InnerProductSpaceE, %object
	.size	_ZTVN7hnswlib17InnerProductSpaceE, 56
_ZTVN7hnswlib17InnerProductSpaceE:
	.xword	0
	.xword	_ZTIN7hnswlib17InnerProductSpaceE
	.xword	_ZN7hnswlib17InnerProductSpace13get_data_sizeEv
	.xword	_ZN7hnswlib17InnerProductSpace13get_dist_funcEv
	.xword	_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv
	.xword	_ZN7hnswlib17InnerProductSpaceD1Ev
	.xword	_ZN7hnswlib17InnerProductSpaceD0Ev
	.weak	_ZTVN7hnswlib15HierarchicalNSWIfEE
	.section	.rodata._ZTVN7hnswlib15HierarchicalNSWIfEE,"aG",@progbits,_ZTVN7hnswlib15HierarchicalNSWIfEE,comdat
	.align	3
	.type	_ZTVN7hnswlib15HierarchicalNSWIfEE, %object
	.size	_ZTVN7hnswlib15HierarchicalNSWIfEE, 64
_ZTVN7hnswlib15HierarchicalNSWIfEE:
	.xword	0
	.xword	_ZTIN7hnswlib15HierarchicalNSWIfEE
	.xword	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb
	.xword	_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE
	.xword	_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE
	.xword	_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.xword	_ZN7hnswlib15HierarchicalNSWIfED1Ev
	.xword	_ZN7hnswlib15HierarchicalNSWIfED0Ev
	.weakref	_ZL28__gthrw___pthread_key_createPjPFvPvE,__pthread_key_create
	.weakref	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t,pthread_mutex_unlock
	.weakref	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t,pthread_mutex_lock
	.section	.rodata.cst8,"aM",@progbits,8
	.align	3
.LC5:
	.xword	_ZL28__gthrw___pthread_key_createPjPFvPvE
	.section	.rodata.cst4,"aM",@progbits,4
	.align	2
.LC26:
	.word	2139095039
	.section	.rodata
	.align	3
	.set	.LANCHOR0,. + 0
.LC37:
	.string	"files/hnsw.index"
	.zero	1007
	.bss
	.align	3
	.set	.LANCHOR1,. + 0
	.type	_ZStL8__ioinit, %object
	.size	_ZStL8__ioinit, 1
_ZStL8__ioinit:
	.zero	1
	.hidden	DW.ref.__gxx_personality_v0
	.weak	DW.ref.__gxx_personality_v0
	.section	.data.DW.ref.__gxx_personality_v0,"awG",@progbits,DW.ref.__gxx_personality_v0,comdat
	.align	3
	.type	DW.ref.__gxx_personality_v0, %object
	.size	DW.ref.__gxx_personality_v0, 8
DW.ref.__gxx_personality_v0:
	.xword	__gxx_personality_v0
	.hidden	__dso_handle
	.ident	"GCC: (GNU) 10.3.1"
	.section	.note.GNU-stack,"",@progbits
