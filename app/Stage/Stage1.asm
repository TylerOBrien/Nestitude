BOX_XMIN = $78
BOX_XMAX = $a8
BOX_YMIN = $3f
BOX_YMAX = $4f

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

.importzp stage_state
.importzp actor_pointer_lo

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import buffer_sprite_push_from_a

; ------------------
; stage1_platform1_hittest_x
; ------------------
.proc stage1_platform1_hittest_x
    ;
    ; Check if AABB overlaps
    ;

    ldy #0
    lda (actor_pointer_lo), Y ; pos_x
    cmp #BOX_XMIN+1
    bcc exit
    cmp #BOX_XMAX
    bcs exit

    ldy #1
    lda (actor_pointer_lo), Y ; pos_y
    cmp #BOX_YMIN+1
    bcc exit
    cmp #BOX_YMAX
    bcs exit

    ;
    ; There is an overlap so determine which direction actor was moving
    ;

    ldy #2
    lda (actor_pointer_lo), Y ; vel_x
    cmp #127
    bcs hit_right_side

    hit_left_side:
        lda #BOX_XMIN
        ldy #0
        sta (actor_pointer_lo), Y ; pos_x
        jmp exit

    hit_right_side:
        lda #BOX_XMAX
        ldy #0
        sta (actor_pointer_lo), Y ; pos_x

    exit:
        rts
.endproc

; ------------------
; stage1_platform1_hittest_y
; ------------------
.proc stage1_platform1_hittest_y
    ;
    ; Check if AABB overlaps
    ;

    ldy #0
    lda (actor_pointer_lo), Y ; pos_x
    cmp #BOX_XMIN+1
    bcc exit
    cmp #BOX_XMAX
    bcs exit

    ldy #1
    lda (actor_pointer_lo), Y ; pos_y
    cmp #BOX_YMIN+1
    bcc exit
    cmp #BOX_YMAX
    bcs exit

    ;
    ; There is an overlap so determine which direction actor was moving
    ;

    ldy #3
    lda (actor_pointer_lo), Y ; vel_y
    cmp #127
    bcs hit_bottom_side

    hit_top_side:
        lda #BOX_YMIN
        ldy #1
        sta (actor_pointer_lo), Y ; pos_y
        jmp exit

    hit_bottom_side:
        lda #BOX_YMAX
        ldy #1
        sta (actor_pointer_lo), Y ; pos_y

    exit:
        rts
.endproc

; ------------------
; stage1_hittest_x
; ------------------
.export stage1_hittest_x
.proc stage1_hittest_x
    jsr stage1_platform1_hittest_x
    rts
.endproc

; ------------------
; stage1_hittest_y
; ------------------
.export stage1_hittest_y
.proc stage1_hittest_y
    jsr stage1_platform1_hittest_y
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
