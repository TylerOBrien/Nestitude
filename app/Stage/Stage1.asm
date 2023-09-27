; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

.importzp stage_state

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import buffer_sprite_push_a

; ------------------
; stage1_update
; ------------------
.export stage1_update
.proc stage1_update
    lda #150
    jsr buffer_sprite_push_a
    lda #2
    jsr buffer_sprite_push_a
    lda #2
    jsr buffer_sprite_push_a
    lda #50
    jsr buffer_sprite_push_a
    rts
.endproc

; ------------------
; stage1_init
; ------------------
.export stage1_init
.proc stage1_init
    rts
.endproc
