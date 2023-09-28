; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

hit_test_state: .res 1

.importzp actor_x_min
.importzp actor_x_max
.importzp actor_y_min
.importzp actor_y_max

.importzp obstruct_x_min
.importzp obstruct_x_max
.importzp obstruct_y_min
.importzp obstruct_y_max

.exportzp hit_test_state

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; hit_test
; ------------------
.export hit_test
.proc hit_test
    ;
    ; Check if right-side of actor is to the right of the left-side of obstruction
    ;

    lda actor_x_max
    cmp obstruct_x_min
    bcc failed

    ;
    ; Check if left-side of actor is to the left of the right-side of obstruction
    ;

    lda actor_x_min
    cmp obstruct_x_max
    bcs failed

    ;
    ; Check if bottom-side of actor is below top-side of obstruction
    ;

    lda actor_y_max
    cmp obstruct_y_min
    bcc failed

    ;
    ; Check if bottom-side of actor is above bottom-side of obstruction
    ;

    lda actor_y_min
    cmp obstruct_y_max
    bcs failed

    ;
    ; Results of hit test
    ;

    passed:
        lda #1
        jmp exit

    failed:
        lda #0

    exit:
        sta hit_test_state
        rts
.endproc

; ------------------
; hit_test_init
; ------------------
.export hit_test_init
.proc hit_test_init
    lda #0
    sta hit_test_state
    rts
.endproc
