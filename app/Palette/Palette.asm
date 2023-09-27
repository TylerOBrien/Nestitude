; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

palette_pointer_lo: .res 1
palette_pointer_hi: .res 1

.exportzp palette_pointer_lo
.exportzp palette_pointer_hi

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; palette_load
; ------------------
.export palette_load
.proc palette_load
    ldx $2002 ; PPU_STATUS
    ldx #$3f
    stx $2006 ; PPU_ADDR
    ldx #$00
    sta $2006 ; PPU_ADDR
    ldy #0

    loop:
        lda (palette_pointer_lo), Y
        sta $2007 ; PPU_DATA
        iny
        cpy #32
        bne loop

    rts
.endproc
