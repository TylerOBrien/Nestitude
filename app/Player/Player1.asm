; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

player1_ON_GROUND = %00000001
player1_JUMPING   = %00000010
player1_FALLING   = %00000000

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

player1_state: .res 1

player1_x_pos_lo: .res 1
player1_x_pos_hi: .res 1
player1_x_walk_vel_lo: .res 1
player1_x_walk_vel_hi: .res 1

player1_y_pos_lo: .res 1
player1_y_pos_hi: .res 1
player1_y_walk_vel_lo: .res 1
player1_y_walk_vel_hi: .res 1

.importzp controller_state

.exportzp player1_x_pos_hi
.exportzp player1_y_pos_hi
.exportzp player1_x_walk_vel_hi
.exportzp player1_y_walk_vel_hi

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
    jsr stage_hittest_x
    rts
.endproc

; ------------------
; player1_hittest_y
; ------------------
.proc player1_hittest_y
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
        ldx player1_x_walk_vel_hi
        dex
        stx player1_x_walk_vel_hi
        jmp exit

    check_right:
        lda controller_state
        and #DPAD_RIGHT
        beq no_press
        ldx player1_x_walk_vel_hi
        inx
        stx player1_x_walk_vel_hi
        jmp exit

    no_press:
        lda #0
        sta player1_x_walk_vel_hi

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
        ldx player1_y_walk_vel_hi
        dex
        stx player1_y_walk_vel_hi
        jmp exit

    check_down:
        lda controller_state
        and #DPAD_DOWN
        beq no_press
        ldx player1_y_walk_vel_hi
        inx
        stx player1_y_walk_vel_hi
        jmp exit

    no_press:
        lda #0
        sta player1_y_walk_vel_hi

    exit:
        rts
.endproc

; ------------------
; player1_apply_velocity_x
; ------------------
.proc player1_apply_velocity_x
    lda player1_x_walk_vel_hi
    cmp #0
    beq exit
    cmp #127
    bcs check_negative

    check_positive:
        cmp #1
        beq apply

    prevent_exceeding_max:
        lda #1
        sta player1_x_walk_vel_hi

    apply:
        lda player1_x_pos_hi
        clc
        adc player1_x_walk_vel_hi
        sta player1_x_pos_hi
        jmp exit

    check_negative:
        cmp #255
        beq apply

    prevent_exceeding_min:
        lda #255
        sta player1_x_walk_vel_hi
        jmp apply

    exit:
        rts
.endproc

; ------------------
; player1_apply_velocity_y
; ------------------
.proc player1_apply_velocity_y
    lda player1_y_walk_vel_hi
    cmp #0
    beq exit
    cmp #127
    bcs check_negative

    check_positive:
        cmp #1
        beq apply

    prevent_exceeding_max:
        lda #1
        sta player1_y_walk_vel_hi

    apply:
        lda player1_y_pos_hi
        clc
        adc player1_y_walk_vel_hi
        sta player1_y_pos_hi
        jmp exit

    check_negative:
        cmp #255
        beq apply

    prevent_exceeding_min:
        lda #255
        sta player1_y_walk_vel_hi
        jmp apply

    exit:
        rts
.endproc

; ------------------
; player1_buffer_changes
; ------------------
.proc player1_buffer_changes
    lda player1_y_pos_hi
    jsr buffer_sprite_push_from_a
    lda #1
    jsr buffer_sprite_push_from_a
    lda #2
    jsr buffer_sprite_push_from_a
    lda player1_x_pos_hi
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
    sta player1_x_pos_lo
    sta player1_y_pos_lo
    sta player1_x_walk_vel_lo
    sta player1_y_walk_vel_lo
    sta player1_x_walk_vel_hi
    sta player1_y_walk_vel_hi

    lda #64
    sta player1_x_pos_hi
    sta player1_y_pos_hi

    lda #player1_ON_GROUND
    sta player1_state

    rts
.endproc
