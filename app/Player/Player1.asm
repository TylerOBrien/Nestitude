; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

PLAYER1_ON_GROUND = %00000001

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

player1_pos:   .res 4
player1_state: .res 1

.importzp controller_state
.importzp actor_pointer_lo
.importzp actor_pointer_hi

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import buffer_sprite_push_from_a
.import stage_hittest_x
.import stage_hittest_y

; ------------------
; player1_hittest_x
; ------------------
.proc player1_hittest_x
    lda #.LOBYTE(player1_pos)
    sta actor_pointer_lo
    lda #.HIBYTE(player1_pos)
    sta actor_pointer_hi
    jsr stage_hittest_x
    rts
.endproc

; ------------------
; player1_hittest_y
; ------------------
.proc player1_hittest_y
    lda #.LOBYTE(player1_pos)
    sta actor_pointer_lo
    lda #.HIBYTE(player1_pos)
    sta actor_pointer_hi
    jsr stage_hittest_y
    rts
.endproc

; ------------------
; player1_check_controller_x
; ------------------
.proc player1_check_controller_x
    check_left:
        lda controller_state
        and #DPAD_LEFT
        beq check_right
        ldx player1_pos+2
        dex
        stx player1_pos+2
        jmp exit

    check_right:
        lda controller_state
        and #DPAD_RIGHT
        beq no_press
        ldx player1_pos+2
        inx
        stx player1_pos+2
        jmp exit

    no_press:
        lda #0
        sta player1_pos+2

    exit:
        rts
.endproc

; ------------------
; player1_check_controller_y
; ------------------
.proc player1_check_controller_y
    check_up:
        lda controller_state
        and #DPAD_UP
        beq check_down
        ldx player1_pos+3
        dex
        stx player1_pos+3
        jmp exit

    check_down:
        lda controller_state
        and #DPAD_DOWN
        beq no_press
        ldx player1_pos+3
        inx
        stx player1_pos+3
        jmp exit

    no_press:
        lda #0
        sta player1_pos+3

    exit:
        rts
.endproc

; ------------------
; player1_apply_velocity_x
; ------------------
.proc player1_apply_velocity_x
    lda player1_pos+2 ; vel_x
    cmp #0
    beq exit
    cmp #127
    bcs check_negative

    check_positive:
        cmp #1
        beq apply

    prevent_exceeding_max:
        lda #1
        sta player1_pos+2 ; vel_x

    apply:
        lda player1_pos   ; pos_x
        clc
        adc player1_pos+2 ; vel_x
        sta player1_pos   ; pos_x
        jmp exit

    check_negative:
        cmp #255
        beq apply

    prevent_exceeding_min:
        lda #255
        sta player1_pos+2 ; vel_x
        jmp apply

    exit:
        rts
.endproc

; ------------------
; player1_apply_velocity_y
; ------------------
.proc player1_apply_velocity_y
    lda player1_pos+3 ; vel_y
    cmp #0
    beq exit
    cmp #127
    bcs check_negative

    check_positive:
        cmp #1
        beq apply

    prevent_exceeding_max:
        lda #1
        sta player1_pos+3 ; vel_y

    apply:
        lda player1_pos+1 ; pos_y
        clc
        adc player1_pos+3 ; vel_y
        sta player1_pos+1 ; pos_y
        jmp exit

    check_negative:
        cmp #255
        beq apply

    prevent_exceeding_min:
        lda #255
        sta player1_pos+3 ; vel_y
        jmp apply

    exit:
        rts
.endproc

; ------------------
; player1_buffer_changes
; ------------------
.proc player1_buffer_changes
    lda player1_pos+1
    jsr buffer_sprite_push_from_a
    lda #1
    jsr buffer_sprite_push_from_a
    lda #2
    jsr buffer_sprite_push_from_a
    lda player1_pos
    jsr buffer_sprite_push_from_a
    rts
.endproc

; ------------------
; player1_update
; ------------------
.export player1_update
.proc player1_update
    jsr player1_check_controller_x
    jsr player1_apply_velocity_x
    jsr player1_hittest_x
    jsr player1_check_controller_y
    jsr player1_apply_velocity_y
    jsr player1_hittest_y
    jsr player1_buffer_changes
    rts
.endproc

; ------------------
; player1_init
; ------------------
.export player1_init
.proc player1_init
    lda #0
    sta player1_pos
    sta player1_pos+1
    sta player1_pos+2
    sta player1_pos+3

    lda #64
    sta player1_pos
    sta player1_pos+1

    lda #PLAYER1_ON_GROUND
    sta player1_state

    rts
.endproc
