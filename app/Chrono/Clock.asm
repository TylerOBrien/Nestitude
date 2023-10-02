; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

clock_ms_dec: .res 1
clock_ms_lo: .res 1
clock_ms_hi: .res 1
clock_sec:   .res 1
clock_min:   .res 1

.exportzp clock_ms_lo
.exportzp clock_ms_hi
.exportzp clock_sec
.exportzp clock_min

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; clock_update
; ------------------
.export clock_update
.proc clock_update
    increment_dec:
        lda clock_ms_dec
        clc
        adc #64
        cmp #100
        bcc increment_ms_lo

    reset_dec:
        sbc #100
        sta clock_ms_dec
        sec

    increment_ms_lo:
        lda clock_ms_lo
        adc #16
        sta clock_ms_lo

    lda clock_ms_hi
    adc #0
    sta clock_ms_hi

    cmp #4
    bne exit
    lda clock_ms_lo
    cmp #78
    bcc exit

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
    sta clock_ms_dec
    sta clock_ms_lo
    sta clock_ms_hi
    sta clock_sec
    sta clock_min
    rts
.endproc
