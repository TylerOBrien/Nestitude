; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

player_state: .res 1
player_on_which_platform: .res 1
player_y_count: .res 1

player_x_hi: .res 1
player_x_lo: .res 1

player_x_dir: .res 1
player_x_vel: .res 1

player_y_hi:    .res 1
player_y_vel:   .res 1

player_ignore_a: .res 1

PLAYER_ON_GROUND = %00000001
PLAYER_JUMPING   = %00000010
PLAYER_FALLING   = %00000000

.importzp controller_state
.importzp obstruct_id
.importzp obstruct_x_min
.importzp obstruct_x_max
.importzp obstruct_y_min
.importzp obstruct_y_max

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import buffer_sprite_push_from_a

.proc player_jump
    ldx player_y_count
    inx
    stx player_y_count
    cpx #4
    bne jump
    ldx #0
    stx player_y_count

    jump:
        lda player_y_hi
        clc
        sbc player_y_vel
        sta player_y_hi

    decrease_vel:
        ldx player_y_vel
        dex
        stx player_y_vel
        beq stop_jump
        jmp exit

    stop_jump:
        lda #0
        sta player_state
        sta player_y_count

    exit:
        rts
.endproc

.proc player_1_hittest_platform
    ldx player_x_hi
    cpx obstruct_x_min
    bcc no_x_collision
    cpx obstruct_x_max
    bcs no_x_collision

    ldy player_y_hi
    cpy obstruct_y_min
    bcc no_y_collision
    cpy obstruct_y_max
    bcs no_y_collision

    lda player_state
    and #PLAYER_JUMPING
    beq handle_fall_hit

    handle_jump_hit:
        lda #0
        sta player_state
        lda obstruct_y_max
        sta player_y_hi
        jmp exit

    handle_fall_hit:
        lda #PLAYER_ON_GROUND
        sta player_state
        lda obstruct_y_min
        sta player_y_hi
        lda obstruct_id
        sta player_on_which_platform
        jmp exit

    no_y_collision:
        rts

    no_x_collision:
        lda player_state
        cmp #PLAYER_JUMPING
        beq exit
        lda player_on_which_platform
        cmp obstruct_id
        beq fall
        jmp exit

    fall:
        lda #0
        sta player_state

    exit:
        rts
.endproc

.proc player_1_hittest_platform_1
    ldx player_x_hi
    cpx #102
    bcc no_x_collision

    ldy player_y_hi
    cpy #159
    beq no_y_collision
    bcc no_y_collision
    cpy #184
    bcs no_y_collision

    lda player_state
    and #PLAYER_JUMPING
    beq handle_fall_hit

    handle_jump_hit:
        lda #0
        sta player_state
        lda #184
        sta player_y_hi
        jmp exit

    handle_fall_hit:
        lda #PLAYER_ON_GROUND
        sta player_state
        lda #159
        sta player_y_hi
        lda #1
        sta player_on_which_platform
        lda #0
        sta player_y_count
        jmp exit

    no_y_collision:
        rts

    no_x_collision:
        lda player_state
        cmp #PLAYER_JUMPING
        beq exit
        lda player_on_which_platform
        cmp #1
        beq fall
        jmp exit

    fall:
        lda #0
        sta player_state

    exit:
        rts
.endproc

.proc player_1_hittest_platform_2
    ldx player_x_hi
    cpx #134
    bcc no_x_collision
    cpx #158
    bcs no_x_collision

    ldy player_y_hi
    cpy #119
    beq no_y_collision
    bcc no_y_collision
    cpy #144
    bcs no_y_collision

    lda player_state
    and #PLAYER_JUMPING
    beq handle_fall_hit

    handle_jump_hit:
        lda #0
        sta player_state
        lda #144
        sta player_y_hi
        jmp exit

    handle_fall_hit:
        lda #PLAYER_ON_GROUND
        sta player_state
        lda #119
        sta player_y_hi
        lda #2
        sta player_on_which_platform
        lda #0
        sta player_y_count
        jmp exit

    no_y_collision:
        rts

    no_x_collision:
        lda player_state
        cmp #PLAYER_JUMPING
        beq exit
        lda player_on_which_platform
        cmp #2
        beq fall
        jmp exit

    fall:
        lda #0
        sta player_state

    exit:
        rts
.endproc

.proc player_1_hittest_platform_3
    lda player_state
    cmp #PLAYER_FALLING
    bne exit

    ldy player_y_hi
    cpy #199
    bcc exit

    handle_fall_hit:
        lda #PLAYER_ON_GROUND
        sta player_state
        lda #199
        sta player_y_hi
        lda #3
        sta player_on_which_platform
        lda #0
        sta player_y_count
        jmp exit

    exit:
        rts
.endproc

.proc player_1_hittest_platform_4
    ldx player_x_hi
    cpx #110
    bcc no_x_collision
    cpx #137
    bcs no_x_collision

    ldy player_y_hi
    cpy #143
    beq no_y_collision
    bcc no_y_collision
    cpy #168
    bcs no_y_collision

    lda player_state
    and #PLAYER_JUMPING
    beq handle_fall_hit

    handle_jump_hit:
        lda #0
        sta player_state
        lda #143
        sta player_y_hi
        jmp exit

    handle_fall_hit:
        lda #PLAYER_ON_GROUND
        sta player_state
        lda #143
        sta player_y_hi
        lda #4
        sta player_on_which_platform
        lda #0
        sta player_y_count
        jmp exit

    no_y_collision:
        rts

    no_x_collision:
        lda player_state
        cmp #PLAYER_JUMPING
        beq exit
        lda player_on_which_platform
        cmp #4
        beq fall
        jmp exit

    fall:
        lda #0
        sta player_state

    exit:
        rts
.endproc

.proc player_1_hittest
    jsr player_1_hittest_platform_1
    jsr player_1_hittest_platform_2
    jsr player_1_hittest_platform_3
    jsr player_1_hittest_platform_4
    rts
.endproc

.proc player_fall
    ldx player_y_count
    inx
    stx player_y_count
    cpx #4
    bne fall
    ldx #0
    stx player_y_count

    increase_vel:
        ldx player_y_vel
        inx
        stx player_y_vel

    fall:
        lda player_y_hi
        clc
        adc player_y_vel
        sta player_y_hi

    exit:
        rts
.endproc

; ------------------
; player_1_handle_dpad_left
; ------------------
.proc player_1_handle_dpad_left
    ldx player_x_hi
    dex
    dex
    stx player_x_hi
    rts
.endproc

; ------------------
; player_1_handle_dpad_right
; ------------------
.proc player_1_handle_dpad_right
    ldx player_x_hi
    inx
    inx
    stx player_x_hi
    rts
.endproc

; ------------------
; player_1_check_controller
; ------------------
.proc player_1_check_controller
    lda controller_state
    and #DPAD_UP
    beq check_down

    ldy player_y_hi
    dey
    sty player_y_hi

    check_down:
        lda controller_state
        and #DPAD_DOWN
        beq check_state

        ldy player_y_hi
        iny
        sty player_y_hi

    check_state:
        lda player_state
        and #PLAYER_ON_GROUND
        beq check_right

    check_a:
        lda controller_state
        and #BUTTON_A
        beq check_if_on_ground
        lda player_ignore_a
        bne check_right

    handle_a:
        lda player_state
        eor #PLAYER_ON_GROUND
        ora #PLAYER_JUMPING
        sta player_state
        lda #10
        sta player_ignore_a
        sta player_y_vel
        jmp check_right

    check_if_on_ground:
        lda player_state
        and #PLAYER_ON_GROUND
        beq check_right
        lda #0
        sta player_ignore_a

    check_right:
        lda controller_state
        and #DPAD_RIGHT
        beq check_left

    handle_right:
        jsr player_1_handle_dpad_right
        jmp exit

    check_left:
        lda controller_state
        and #DPAD_LEFT
        beq exit

    handle_left:
        jsr player_1_handle_dpad_left
        jmp exit

    exit:
        rts
.endproc

; ------------------
; player_update
; ------------------
.export player_update
.proc player_update
    lda player_state
    and #PLAYER_ON_GROUND
    beq in_air
    jmp check_controller

    in_air:
        lda player_state
        and #PLAYER_JUMPING
        beq fall
        jsr player_jump
        jmp check_controller

    fall:
        jsr player_fall
        jmp check_controller

    check_controller:
        jsr player_1_check_controller

    jsr player_1_hittest

    lda player_y_hi
    jsr buffer_sprite_push_from_a
    lda #1
    jsr buffer_sprite_push_from_a
    lda #2
    jsr buffer_sprite_push_from_a
    lda player_x_hi
    jsr buffer_sprite_push_from_a

    rts
.endproc

; ------------------
; player_init
; ------------------
.export player_init
.proc player_init
    lda #132
    sta player_x_hi
    sta player_y_hi
    lda #0
    sta player_on_which_platform
    sta player_ignore_a
    sta player_x_lo
    sta player_x_dir
    sta player_x_vel
    sta player_y_vel
    sta player_y_count
    sta player_state
    rts
.endproc
