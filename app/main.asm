; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import game_init
.import game_load
.import game_update
.import ppu_enable_nmi_and_render

; ------------------
; main
; ------------------
.export main
.proc main
    jsr game_init
    jsr game_load
    jsr ppu_enable_nmi_and_render

    forever:
        jsr game_update
        jmp forever
.endproc

; ------------------
; CHRs
; ------------------

.segment "TILES"
    .incbin "../resources/Pattern/default1.chr"
    .incbin "../resources/Pattern/background.chr"
