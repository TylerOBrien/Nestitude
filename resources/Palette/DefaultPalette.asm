; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

.importzp palette_pointer_lo
.importzp palette_pointer_hi

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; palette_default_init
; ------------------
.export palette_default_init
.proc palette_default_init
    lda #.LOBYTE(palette_default_bytes)
    sta palette_pointer_lo
    lda #.HIBYTE(palette_default_bytes)
    sta palette_pointer_hi
    rts
.endproc

; ---------------------------------------------------------------
; Read-Only Data
; ---------------------------------------------------------------

.segment "RODATA"
palette_default_bytes:
    .byte $0f, $12, $23, $27
    .byte $21, $16, $38, $39
    .byte $0f, $0c, $07, $13
    .byte $0f, $19, $09, $37

    .byte $17, $2d, $10, $15
    .byte $1c, $1c, $1c, $1c
    .byte $0f, $19, $09, $27
    .byte $0f, $19, $05, $2c
