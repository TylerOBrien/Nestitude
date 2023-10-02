; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

buffer_sprite_length: .res 1

; ---------------------------------------------------------------
; Memory
; ---------------------------------------------------------------

.segment "OAM"

buffer_sprite: .res 256

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; buffer_sprite_push_from_a
; ------------------
.export buffer_sprite_push_from_a
.proc buffer_sprite_push_from_a
    ldx buffer_sprite_length
    sta buffer_sprite, X
    inx
    stx buffer_sprite_length
    rts
.endproc

; ------------------
; buffer_sprite_draw
; ------------------
.export buffer_sprite_draw
.proc buffer_sprite_draw
    lda #.LOBYTE(buffer_sprite)
    sta $2003 ; OAM_ADDR
    lda #.HIBYTE(buffer_sprite)
    sta $4014 ; OAM_DMA
    lda #0
    sta buffer_sprite_length
    rts
.endproc
