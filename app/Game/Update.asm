; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

.importzp nmi_wait
.importzp game_state

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import controller_update
.import player1_update
.import stage_update
.import hud_update

; ------------------
; game_update
; ------------------
.export game_update
.proc game_update
    ;
    ; Always read controller input even if waiting
    ;

    jsr controller_update

    ;
    ; Ensure nmi_wait flag is not enabled
    ;

    lda nmi_wait
    bne exit
    lda #1
    sta nmi_wait

    ;
    ; Determine if game is paused, playing, on title screen, etc
    ;

    jsr game_update_from_state

    ;
    ; Done
    ;

    exit:
        rts
.endproc

; ------------------
; game_update_from_state
; ------------------
.proc game_update_from_state
    ;
    ; Load game state
    ;

    lda game_state

    ;
    ; Check if state is TITLE
    ;

    check_if_title:
        cmp #GAME_STATE_TITLE
        bne check_if_play
        jsr game_update_title
        rts

    ;
    ; Check if state is PLAY
    ;

    check_if_play:
        cmp #GAME_STATE_PLAY
        jsr game_update_play

    ;
    ; Done
    ;

    exit:
        rts
.endproc

; ------------------
; game_update_title
; ------------------
.export game_update_title
.proc game_update_title
    jsr stage_update
    jsr player1_update
    jsr hud_update
    rts
.endproc

; ------------------
; game_update_play
; ------------------
.export game_update_play
.proc game_update_play
    jsr stage_update
    jsr player1_update
    jsr hud_update
    rts
.endproc
