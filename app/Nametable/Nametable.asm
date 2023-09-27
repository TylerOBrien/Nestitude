; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

nametable_rle_count:      .res 1
nametable_rle_pointer_lo: .res 1
nametable_rle_pointer_hi: .res 1

.exportzp nametable_rle_count
.exportzp nametable_rle_pointer_lo
.exportzp nametable_rle_pointer_hi

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import nametable_default_init

; ------------------
; nametable_load
; ------------------
.export nametable_load
.proc nametable_load
    ldy #0
    lda $2002 ; PPU_STATUS

    read_lobyte:
        lda (nametable_rle_pointer_lo), Y
        tax
        iny

    read_hibyte_count_tile:
        lda (nametable_rle_pointer_lo), Y
        beq reset_lobyte

        and #%00000011
        clc
        adc #$20
        sta $2006 ; PPU_ADDR
        stx $2006 ; PPU_ADDR

        txa
        pha
        lda (nametable_rle_pointer_lo), Y
        lsr
        lsr
        tax

        iny
        lda (nametable_rle_pointer_lo), Y
        iny

    copy:
        sta $2007 ; PPU_DATA
        dex
        cpx #0
        bne copy
        pla
        tax

    check_if_done:
        cpy nametable_rle_count
        beq exit
        jmp read_hibyte_count_tile

    reset_lobyte:
        iny
        jmp read_lobyte

    exit:
        rts
.endproc
