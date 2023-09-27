; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import main
.import ppu_clear_oam
.import ppu_vblank_wait

; ------------------
; reset_handle
; ------------------
.export reset_handle
.proc reset_handle
    sei
    cld

    ldx #0
    stx PPU_CTRL
    stx PPU_MASK
    stx $4015 ; apu
    stx $4010 ; dmc irq
    ldx #$40
    sta $4017 ; apu irq

    jsr ppu_vblank_wait
    jsr ppu_clear_oam
    jsr ppu_vblank_wait

    jmp main
.endproc
