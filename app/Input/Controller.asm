; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

controller_state:   .res 2
controller_enabled: .res 1

.exportzp controller_state

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; controller_read_1
; ------------------
.proc controller_read_1
    lda #1
    sta $4016 ; CONTROLLER_1
    sta controller_state
    lsr a
    sta $4016 ; CONTROLLER_1

    loop:
        lda $4016 ; CONTROLLER_1
        lsr a
        rol controller_state
        bcc loop

    rts
.endproc

; ------------------
; controller_read_2
; ------------------
.proc controller_read_2
    lda #1
    sta $4017 ; CONTROLLER_2
    sta controller_state+1
    lsr a
    sta $4017 ; CONTROLLER_2

    loop:
        lda $4017 ; CONTROLLER_2
        lsr a
        rol controller_state+1
        bcc loop

    rts
.endproc

; ------------------
; controller_update
; ------------------
.export controller_update
.proc controller_update
    check_if_update_controller_1:
        lda controller_enabled
        and #%00000001
        beq check_if_update_controller_2
        jsr controller_read_1

    fix_dpcm_glitch_1:
        lda controller_state
        pha
        jsr controller_read_1
        pla
        cmp controller_state
        bne fix_dpcm_glitch_1

    check_if_update_controller_2:
        lda controller_enabled
        and #%00000010
        beq exit
        jsr controller_read_2

    fix_dpcm_glitch_2:
        lda controller_state+1
        pha
        jsr controller_read_2
        pla
        cmp controller_state+1
        bne fix_dpcm_glitch_2

    exit:
        rts
.endproc

; ------------------
; controller_init
; ------------------
.export controller_init
.proc controller_init
    lda #0
    sta controller_state
    sta controller_state+1
    lda #%00000001
    sta controller_enabled
    rts
.endproc
