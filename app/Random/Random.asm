; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

random_seed: .res 2

.importzp controller_state
.importzp clock_ms_hi
.importzp clock_ms_lo
.importzp clock_sec
.importzp tick_count_hi
.importzp tick_count_lo

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.proc random_increment_hi
    lda tick_count_lo
    adc clock_ms_hi
    eor clock_sec

    tax
    and #%01000011
    beq check_other_bits
    inx
    jmp exit

    check_other_bits:
        and #%10010100
        beq handle_no_bits
        inx
        inx
        inx

    handle_no_bits:
        inx
        inx
        inx
        inx
        inx
        inx
        inx

    exit:
        stx random_seed
        rts
.endproc

.proc random_increment_lo
    lda tick_count_hi
    adc clock_ms_lo
    eor clock_sec

    tax
    and #%01000011
    beq check_other_bits
    inx
    inx
    inx
    jmp exit

    check_other_bits:
        and #%10010100
        beq handle_no_bits
        inx

    handle_no_bits:
        inx
        inx
        inx
        inx
        inx

    exit:
        stx random_seed+1
        rts
.endproc

.proc random_handle_ab
    lda controller_state
    and #BUTTON_A
    beq handle_b

    handle_a:
        jsr random_increment_lo
        jmp exit

    handle_b:
        jsr random_increment_hi

    exit:
        rts
.endproc

.proc random_handle_dpad
    check_up:
        lda controller_state
        and #DPAD_UP
        beq check_down
        jsr random_increment_hi

    check_down:
        lda controller_state
        and #DPAD_DOWN
        beq check_left
        jsr random_increment_lo

    check_left:
        lda controller_state
        and #DPAD_LEFT
        beq check_right
        jsr random_increment_hi

    check_right:
        lda controller_state
        and #DPAD_RIGHT
        beq exit
        jsr random_increment_lo

    exit:
        rts
.endproc

.export random_update
.proc random_update
    ;
    ; Controller inputs
    ;

    check_dpad:
        lda controller_state
        and #DPAD_ANY
        beq check_ab
        jsr random_handle_dpad

    check_ab:
        lda controller_state
        and #BUTTON_AORB
        beq exit
        jsr random_handle_ab

    ;
    ; Tick count
    ;

    lda tick_count_lo
    beq no_tick
    cmp #64
    bcs low_tick
    cmp #128
    bcs medium_tick
    cmp #192
    bcs high_tick

    jsr random_handle_ab
    jsr random_handle_dpad
    jmp exit

    high_tick:
        jsr random_handle_ab
        jmp exit

    medium_tick:
        jsr random_handle_dpad
        jmp exit

    low_tick:
        jsr random_handle_ab
        jmp exit

    no_tick:
        jsr random_handle_dpad

    ;
    ; Done
    ;

    exit:
        rts
.endproc

.export random_init
.proc random_init
    lda #0
    sta random_seed
    sta random_seed+1
    rts
.endproc
