; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

stage_state: .res 1

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import stage1_init
.import stage2_init

.import stage1_update
.import stage2_update

; ------------------
; stage_update
; ------------------
.export stage_update
.proc stage_update
    lda stage_state
    and #%00001111

    check_stage_1:
        cmp #STAGE_1
        bne check_stage_2
        jsr stage1_update
        jmp exit

    check_stage_2:
        cmp #STAGE_2
        bne exit
        jsr stage2_update

    exit:
        rts
.endproc

; ------------------
; stage_init
; ------------------
.export stage_init
.proc stage_init
    lda #STAGE_1
    sta stage_state
    jsr stage1_init
    rts
.endproc
