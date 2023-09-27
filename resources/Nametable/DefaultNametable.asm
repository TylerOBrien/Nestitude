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
    lda #9
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
    .byte $30
    .byte $08, $04, $15, $04, $00
    .byte $20
    .byte $04, $04
