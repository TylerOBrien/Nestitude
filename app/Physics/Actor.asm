; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

actor_pointer_lo: .res 1
actor_pointer_hi: .res 1

.exportzp actor_pointer_lo
.exportzp actor_pointer_hi

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; actor_apply_vel_x
; ------------------
.export actor_apply_vel_x
.proc actor_apply_vel_x
    ldy #2
    lda (actor_pointer_lo), Y ; vel_x
    cmp #0
    beq exit
    cmp #127
    bcs check_negative

    check_positive:
        cmp #1
        beq apply

    prevent_exceeding_max:
        lda #1
        ldy #2
        sta (actor_pointer_lo), Y ; vel_x

    apply:
        ldy #0
        sta (actor_pointer_lo), Y ; pos_x
        clc
        ldy #2
        adc (actor_pointer_lo), Y ; vel_x
        ldy #0
        sta (actor_pointer_lo), Y ; pos_x
        jmp exit

    check_negative:
        cmp #255
        beq apply

    prevent_exceeding_min:
        lda #255
        ldy #2
        sta (actor_pointer_lo), Y ; vel_x
        jmp apply

    exit:
        rts
.endproc

; ------------------
; actor_apply_vel_y
; ------------------
.export actor_apply_vel_y
.proc actor_apply_vel_y
    ldy #3
    lda (actor_pointer_lo), Y ; vel_y
    cmp #0
    beq exit
    cmp #127
    bcs check_negative

    check_positive:
        cmp #1
        beq apply

    prevent_exceeding_max:
        lda #1
        ldy #3
        sta (actor_pointer_lo), Y ; vel_y

    apply:
        ldy #1
        lda (actor_pointer_lo), Y ; pos_y
        clc
        ldy #3
        adc (actor_pointer_lo), Y ; vel_y
        ldy #1
        sta (actor_pointer_lo), Y ; pos_y
        jmp exit

    check_negative:
        cmp #255
        beq apply

    prevent_exceeding_min:
        lda #255
        ldy #3
        sta (actor_pointer_lo), Y ; vel_y
        jmp apply

    exit:
        rts
.endproc
