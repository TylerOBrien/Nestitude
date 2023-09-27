; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; ppu_enable_nmi_and_render
; ------------------
.export ppu_enable_nmi_and_render
.proc ppu_enable_nmi_and_render
    vblank_wait:
        bit PPU_STATUS
        bpl vblank_wait
    lda #%10010000 ; Turn on NMIs, sprites use first pattern table
    sta PPU_CTRL
    lda #%00011110 ; Turn on screen
    sta PPU_MASK
    rts
.endproc

; ------------------
; ppu_enable_render
; ------------------
.export ppu_enable_render
.proc ppu_enable_render
    vblank_wait:
        bit PPU_STATUS
        bpl vblank_wait
    lda #%00011110
    sta PPU_MASK
    rts
.endproc

; ------------------
; ppu_disable_render
; ------------------
.export ppu_disable_render
.proc ppu_disable_render
    vblank_wait:
        bit PPU_STATUS
        bpl vblank_wait
    lda #%00000110
    sta PPU_MASK
    rts
.endproc

; ------------------
; ppu_vblank_wait
; ------------------
.export ppu_vblank_wait
.proc ppu_vblank_wait
    vblank_wait:
        bit PPU_STATUS
        bpl vblank_wait
    rts
.endproc

; ------------------
; ppu_clear_oam
; ------------------
.export ppu_clear_oam
.proc ppu_clear_oam
    loop:
        lda #255
        sta $0200, X ; y
        sta $0203, X ; x
        lda #0
        sta $0205, X ; tile
        inx
        inx
        inx
        inx
        bne loop
    rts
.endproc

; ------------------
; ppu_init
; ------------------
.export ppu_init
.proc ppu_init
    lda PPU_STATUS
    lda #$3f
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
    rts
.endproc
