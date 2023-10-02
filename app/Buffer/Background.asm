; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

buffer_background_bytes:  .res 24
buffer_background_length: .res 1

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; buffer_background_push_from_a
; ------------------
.export buffer_background_push_from_a
.proc buffer_background_push_from_a
    ldx buffer_background_length
    sta buffer_background_bytes, X
    inx
    stx buffer_background_length
    rts
.endproc

; ------------------
; buffer_background_draw
; ------------------
.export buffer_background_draw
.proc buffer_background_draw
    lda $2002 ; PPU_STATUS
    ldx #0

    loop:
        cpx buffer_background_length
        beq exit

        ldy buffer_background_bytes, X
        sty $2006 ; PPU_ADDR
        inx

        ldy buffer_background_bytes, X
        sty $2006 ; PPU_ADDR
        inx

        ldy buffer_background_bytes, X
        sty $2007 ; PPU_DATA
        inx

        jmp loop

    exit:
        lda #0
        sta buffer_background_length
        rts
.endproc

; ------------------
; buffer_background_init
; ------------------
.export buffer_background_init
.proc buffer_background_init
    lda #0
    ldx #0
    sta buffer_background_length

    loop:
        cpx #24
        beq exit
        sta buffer_background_bytes, X
        inx
        jmp loop

    exit:
        rts
.endproc
