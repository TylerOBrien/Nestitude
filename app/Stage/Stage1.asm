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

.importzp stage_state
.importzp player_x_pos_hi
.importzp player_y_pos_hi
.importzp player_x_vel_hi
.importzp player_y_vel_hi

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import buffer_sprite_push_from_a

; ------------------
; stage1_platform1_hittest_x
; ------------------
.proc stage1_platform1_hittest_x
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
; stage1_platform1_hittest_y
; ------------------
.proc stage1_platform1_hittest_y
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
; stage1_hittest_x
; ------------------
.export stage1_hittest_x
.proc stage1_hittest_x
    lda player_x_vel_hi
    beq exit
    jsr stage1_platform1_hittest_x
    exit:
        rts
.endproc

; ------------------
; stage1_hittest_y
; ------------------
.export stage1_hittest_y
.proc stage1_hittest_y
    lda player_y_vel_hi
    beq exit
    jsr stage1_platform1_hittest_y
    exit:
        rts
.endproc

; ------------------
; stage1_update
; ------------------
.export stage1_update
.proc stage1_update
    rts
    lda #150
    jsr buffer_sprite_push_from_a
    lda #2
    jsr buffer_sprite_push_from_a
    lda #2
    jsr buffer_sprite_push_from_a
    lda #50
    jsr buffer_sprite_push_from_a
    rts
.endproc

; ------------------
; stage1_init
; ------------------
.export stage1_init
.proc stage1_init
    rts
.endproc
