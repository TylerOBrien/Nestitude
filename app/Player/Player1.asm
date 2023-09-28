; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

PLAYER_ON_GROUND = %00000001
PLAYER_JUMPING   = %00000010
PLAYER_FALLING   = %00000000

BOX_XMIN = $78
BOX_XMAX = $a8
BOX_YMIN = $3f
BOX_YMAX = $4f

BOX_XMIN_INNER = $79
BOX_XMAX_INNER = $a7
BOX_YMIN_INNER = $40
BOX_YMAX_INNER = $4e

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

player_state:    .res 1

player_x_pos_lo: .res 1
player_x_pos_hi: .res 1
player_x_vel_lo: .res 1
player_x_vel_hi: .res 1

player_y_pos_lo: .res 1
player_y_pos_hi: .res 1
player_y_vel_lo: .res 1
player_y_vel_hi: .res 1

.importzp controller_state

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import buffer_sprite_push_from_a

; ------------------
; player_1_hittest_x
; ------------------
.proc player_1_hittest_x
    lda player_x_vel_hi
    beq exit

    lda player_x_pos_hi
    cmp #BOX_XMIN_INNER
    bcc exit
    cmp #BOX_XMAX
    bcs exit

    lda player_y_pos_hi
    cmp #BOX_YMIN_INNER
    bcc exit
    cmp #BOX_YMAX
    bcs exit

    lda player_x_vel_hi
    cmp #127
    bcs hit_right_side

    hit_left_side:
        lda #BOX_XMIN
        sta player_x_pos_hi
        jmp exit

    hit_right_side:
        lda #BOX_XMAX
        sta player_x_pos_hi

    exit:
        rts
.endproc

; ------------------
; player_1_hittest_y
; ------------------
.proc player_1_hittest_y
    lda player_y_vel_hi
    beq exit

    lda player_x_pos_hi
    cmp #BOX_XMIN_INNER
    bcc exit
    cmp #BOX_XMAX
    bcs exit

    lda player_y_pos_hi
    cmp #BOX_YMIN_INNER
    bcc exit
    cmp #BOX_YMAX
    bcs exit

    lda player_y_vel_hi
    cmp #127
    bcs hit_bottom_side

    hit_top_side:
        lda #BOX_YMIN
        sta player_y_pos_hi
        jmp exit

    hit_bottom_side:
        lda #BOX_YMAX
        sta player_y_pos_hi

    exit:
        rts
.endproc

; ------------------
; player_1_check_controller_x
; ------------------
.proc player_1_check_controller_x
    check_left:
        lda controller_state
        and #DPAD_LEFT
        beq check_right
        ldx player_x_vel_hi
        dex
        stx player_x_vel_hi
        jmp exit

    check_right:
        lda controller_state
        and #DPAD_RIGHT
        beq no_press
        ldx player_x_vel_hi
        inx
        stx player_x_vel_hi
        jmp exit

    no_press:
        lda #0
        sta player_x_vel_hi

    exit:
        rts
.endproc

; ------------------
; player_1_check_controller_y
; ------------------
.proc player_1_check_controller_y
    check_up:
        lda controller_state
        and #DPAD_UP
        beq check_down
        ldx player_y_vel_hi
        dex
        stx player_y_vel_hi
        jmp exit

    check_down:
        lda controller_state
        and #DPAD_DOWN
        beq no_press
        ldx player_y_vel_hi
        inx
        stx player_y_vel_hi
        jmp exit

    no_press:
        lda #0
        sta player_y_vel_hi

    exit:
        rts
.endproc

; ------------------
; player_draw
; ------------------
.proc player_draw
    lda player_y_pos_hi
    jsr buffer_sprite_push_from_a
    lda #1
    jsr buffer_sprite_push_from_a
    lda #2
    jsr buffer_sprite_push_from_a
    lda player_x_pos_hi
    jsr buffer_sprite_push_from_a
    rts
.endproc

; ------------------
; player_1_apply_velocity_x
; ------------------
.proc player_1_apply_velocity_x
    lda player_x_vel_hi
    cmp #0
    beq exit
    cmp #127
    bcs check_negative

    check_positive:
        cmp #1
        beq apply

    prevent_exceeding_max:
        lda #1
        sta player_x_vel_hi

    apply:
        lda player_x_pos_hi
        clc
        adc player_x_vel_hi
        sta player_x_pos_hi
        jmp exit

    check_negative:
        cmp #255
        beq apply

    prevent_exceeding_min:
        lda #255
        sta player_x_vel_hi
        jmp apply

    exit:
        rts
.endproc

; ------------------
; player_1_apply_velocity_y
; ------------------
.proc player_1_apply_velocity_y
    lda player_y_vel_hi
    cmp #0
    beq exit
    cmp #127
    bcs check_negative

    check_positive:
        cmp #1
        beq apply

    prevent_exceeding_max:
        lda #1
        sta player_y_vel_hi

    apply:
        lda player_y_pos_hi
        clc
        adc player_y_vel_hi
        sta player_y_pos_hi
        jmp exit

    check_negative:
        cmp #255
        beq apply

    prevent_exceeding_min:
        lda #255
        sta player_y_vel_hi
        jmp apply

    exit:
        rts
.endproc

; ------------------
; player_update
; ------------------
.export player_update
.proc player_update
    jsr player_1_check_controller_x
    jsr player_1_apply_velocity_x
    jsr player_1_hittest_x
    jsr player_1_check_controller_y
    jsr player_1_apply_velocity_y
    jsr player_1_hittest_y
    jsr player_draw
    rts
.endproc

; ------------------
; player_init
; ------------------
.export player_init
.proc player_init
    lda #0
    sta player_x_pos_lo
    sta player_y_pos_lo
    sta player_x_vel_lo
    sta player_y_vel_lo
    sta player_x_vel_hi
    sta player_y_vel_hi

    lda #132
    sta player_x_pos_hi
    sta player_y_pos_hi

    lda #PLAYER_ON_GROUND
    sta player_state

    rts
.endproc
