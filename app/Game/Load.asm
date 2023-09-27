; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

.importzp game_state

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import palette_load
.import nametable_load

; ------------------
; game_handle_load_title
; ------------------
.export game_handle_load_title
.proc game_handle_load_title
    jsr palette_load
    jsr nametable_load
    rts
.endproc

; ------------------
; game_handle_load_options
; ------------------
.export game_handle_load_options
.proc game_handle_load_options
    jsr palette_load
    jsr nametable_load
    rts
.endproc

; ------------------
; game_handle_load_play
; ------------------
.export game_handle_load_play
.proc game_handle_load_play
    jsr palette_load
    jsr nametable_load
    rts
.endproc

; ------------------
; game_load
; ------------------
.export game_load
.proc game_load
    jsr palette_load
    jsr nametable_load
    rts
.endproc
