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
; clock_update
; ------------------
.export clock_update
.proc clock_update
    lda clock_ms_lo
    clc
    adc #100
    sta clock_ms_lo

    lda clock_ms_hi
    adc #0
    sta clock_ms_hi

    cmp #20
    bne exit

    lda clock_sec
    clc
    adc #1
    sta clock_sec
    cmp #60
    bne reset_ms_hi
    lda clock_min
    clc
    adc #1
    sta clock_min
    lda #0
    sta clock_sec

    reset_ms_hi:
        lda #0
        sta clock_ms_hi

    exit:
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
