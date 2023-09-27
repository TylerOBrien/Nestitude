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

.import buffer_sprite_draw

; ------------------
; game_handle_draw_title
; ------------------
.export game_handle_draw_title
.proc game_handle_draw_title
    jsr buffer_sprite_draw
    rts
.endproc

; ------------------
; game_handle_draw_options
; ------------------
.export game_handle_draw_options
.proc game_handle_draw_options
    rts
.endproc

; ------------------
; game_handle_draw_play
; ------------------
.export game_handle_draw_play
.proc game_handle_draw_play
    rts
.endproc

; ------------------
; game_draw
; ------------------
.export game_draw
.proc game_draw
    lda game_state

    check_if_title:
        cmp #GAME_STATE_TITLE
        bne check_if_options
        jsr game_handle_draw_title
        jmp exit

    check_if_options:
        cmp #GAME_STATE_OPTIONS
        bne check_if_play
        jsr game_handle_draw_options
        jmp exit

    check_if_play:
        cmp #GAME_STATE_PLAY
        bne check_if_pause
        jsr game_handle_draw_play
        jmp exit

    check_if_pause:
    exit:
        rts
.endproc
