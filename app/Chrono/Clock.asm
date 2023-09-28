; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

clock_ms_lo: .res 1
clock_ms_hi: .res 1
clock_sec:   .res 1
clock_min:   .res 1

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; clock_tick
; ------------------
.export clock_tick
.proc clock_tick
    lda clock_ms_lo
    clc
    adc #16
    lda #clock_ms_hi
    adc #0
    rts
.endproc

; ------------------
; clock_init
; ------------------
.export clock_init
.proc clock_init
    lda #0
    sta clock_ms_lo
    sta clock_ms_hi
    sta clock_sec
    sta clock_min
    rts
.endproc
