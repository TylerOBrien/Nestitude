; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

buffer_nametable_length: .res 1

; ---------------------------------------------------------------
; Memory
; ---------------------------------------------------------------

.segment "BSS"

buffer_nametable: .res 256

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; buffer_nametable_flush
; ------------------
.export buffer_nametable_flush
.proc buffer_nametable_flush
    ldx #0
    cpx buffer_nametable_length
    beq exit

    loop:
        lda buffer_nametable, X
        sta PPU_ADDR
        inx
        lda buffer_nametable, X
        sta PPU_ADDR
        inx
        lda buffer_nametable, X
        sta PPU_DATA
        inx
        cpx buffer_nametable_length
        bcc loop

    ldx #0
    stx buffer_nametable_length

    exit:
        rts
.endproc
