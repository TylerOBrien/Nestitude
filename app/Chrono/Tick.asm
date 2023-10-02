; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

tick_count_lo:    .res 1
tick_count_hi:    .res 1
frame_sec_modulo: .res 1

.exportzp tick_count_lo
.exportzp tick_count_hi

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; tick_update
; ------------------
.export tick_update
.proc tick_update
    check_frame_sec:
        lda frame_sec_modulo
        cmp #60
        beq increment_frame_sec
        lda #0
        sta frame_sec_modulo
        jmp increment_tick_count

    increment_frame_sec:
        clc
        adc #1
        sta frame_sec_modulo

    increment_tick_count:
        lda tick_count_lo
        clc
        adc #1
        sta tick_count_lo
        lda tick_count_hi
        adc #0
        sta tick_count_hi

    exit:
        rts
.endproc

; ------------------
; tick_init
; ------------------
.export tick_init
.proc tick_init
    lda #0
    sta tick_count_lo
    sta tick_count_hi
    rts
.endproc
