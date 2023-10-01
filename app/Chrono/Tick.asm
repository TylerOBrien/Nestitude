; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

tick_count_lo: .res 1
tick_count_hi: .res 1

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
    lda tick_count_lo
    clc
    adc #1
    sta tick_count_lo
    lda tick_count_hi
    adc #0
    sta tick_count_hi
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
