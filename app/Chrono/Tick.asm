; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

tick_ones_count: .res 1
tick_tens_count: .res 1
tick_hundreds_count: .res 1
tick_thousands_count: .res 1

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; tick_update
; ------------------
.export tick_update
.proc tick_update
    increment_ones:
        ldx tick_ones_count
        inx
        stx tick_ones_count
        cmp #10
        bcc exit

    increment_hundreds:
        ldx #0
        stx tick_ones_count
        ldx tick_hundreds_count
        inx
        stx tick_hundreds_count
        cmp #100
        bcc exit

    increment_thousands:
        ldx #0
        stx tick_hundreds_count
        ldx tick_thousands_count
        inx
        stx tick_thousands_count

    exit:
        rts
.endproc

; ------------------
; tick_init
; ------------------
.export tick_init
.proc tick_init
    lda #0
    sta tick_ones_count
    sta tick_tens_count
    sta tick_hundreds_count
    sta tick_thousands_count
    rts
.endproc
