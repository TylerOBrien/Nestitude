; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

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
; buffer_sprite_push_a
; ------------------
.export buffer_sprite_push_a
.proc buffer_sprite_push_a
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
    ldx #0
    cpx buffer_sprite_length
    beq exit

    loop:
        lda buffer_sprite, X
        sta OAM, X ; y coord
        inx
        lda buffer_sprite, X
        sta OAM, X ; tile
        inx
        lda buffer_sprite, X
        sta OAM, X ; attr
        inx
        lda buffer_sprite, X
        sta OAM, X ; x coord
        inx
        cpx buffer_sprite_length
        bcc loop

    ldx #0
    stx buffer_sprite_length

    exit:
        rts
.endproc
