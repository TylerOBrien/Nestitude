; ------------------
; ZeroPage
; ------------------

.segment "ZEROPAGE"

.importzp nametable_rle_count
.importzp nametable_rle_pointer_lo
.importzp nametable_rle_pointer_hi

; ------------------
; Code
; ------------------

.segment "CODE"

.export nametable_default_init
.proc nametable_default_init
    lda #21
    sta nametable_rle_count
    lda #.LOBYTE(nametable_default_rle_bytes)
    sta nametable_rle_pointer_lo
    lda #.HIBYTE(nametable_default_rle_bytes)
    sta nametable_rle_pointer_hi
    rts
.endproc

; ------------------
; Read-Only Data
; ------------------

.segment "RODATA"
nametable_default_rle_bytes:
    .byte $21
        .byte $30, $01, $01
        .byte $31, $03, $02
        .byte $34, $01, $03
        .byte $00
    .byte $21
        .byte $50, $01, $21
        .byte $51, $03, $22
        .byte $54, $01, $23
