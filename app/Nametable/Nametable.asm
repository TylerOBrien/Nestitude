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

    read_hibyte:
        lda (nametable_rle_pointer_lo), Y ; hibyte
        tax
        iny

    read_lobyte_count_tile:
        lda (nametable_rle_pointer_lo), Y ; lobyte
        beq reset_hibyte

    write_pos:
        stx $2006 ; PPU_ADDR
        sta $2006 ; PPU_ADDR

    read_count:
        txa
        pha
        iny
        lda (nametable_rle_pointer_lo), Y ; count
        tax

    read_tile:
        iny
        lda (nametable_rle_pointer_lo), Y ; tile
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
        bcs exit
        jmp read_lobyte_count_tile

    reset_hibyte:
        iny
        jmp read_hibyte

    exit:
        rts
.endproc
