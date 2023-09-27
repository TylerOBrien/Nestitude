; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; palette_default_load
; ------------------
.export palette_default_load
.proc palette_default_load
    ldx $2002 ; PPU_STATUS
    ldx #$3f
    stx $2006 ; PPU_ADDR
    ldx #$00
    sta $2006 ; PPU_ADDR
    ldx #0
    loop:
        lda palette_default_ro_data,X
        sta $2007 ; PPU_DATA
        inx
        cpx #32
        bne loop
    rts
.endproc

; ---------------------------------------------------------------
; Read-Only Data
; ---------------------------------------------------------------

.segment "RODATA"
palette_default_ro_data:
    .byte $0f, $12, $23, $27
    .byte $21, $16, $38, $39
    .byte $0f, $0c, $07, $13
    .byte $0f, $19, $09, $37

    .byte $17, $2d, $10, $15
    .byte $1c, $1c, $1c, $1c
    .byte $0f, $19, $09, $27
    .byte $0f, $19, $05, $2c
