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

.import clock_init
.import tick_init

.import controller_init
.import nmi_init
.import nametable_default_init
.import palette_default_init
.import player1_init
.import stage_init

.import buffer_sprite_init
.import buffer_background_init

; ------------------
; game_init
; ------------------
.export game_init
.proc game_init
    jsr clock_init
    jsr tick_init
    jsr controller_init
    jsr nmi_init
    jsr nametable_default_init
    jsr palette_default_init
    jsr player1_init
    jsr stage_init

    jsr buffer_sprite_init
    jsr buffer_background_init

    lda #GAME_STATE_TITLE
    sta game_state

    rts
.endproc
