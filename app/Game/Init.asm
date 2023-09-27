; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

game_state: .res 1

.exportzp game_state

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import controller_init
.import hit_test_init
.import nmi_init
.import nametable_default_init
.import palette_default_init
.import player_init
.import stage_init

; ------------------
; game_init
; ------------------
.export game_init
.proc game_init
    jsr controller_init
    jsr hit_test_init
    jsr nmi_init
    jsr nametable_default_init
    jsr palette_default_init
    jsr player_init
    jsr stage_init

    lda #GAME_STATE_TITLE
    sta game_state

    rts
.endproc
