; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

palette_state: .res 1

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import palette_default_load

; ------------------
; palette_load
; ------------------
.export palette_load
.proc palette_load
    lda palette_state
    cmp #PALETTE_DEFAULT
    beq load_default
    jmp exit

    load_default:
        jsr palette_default_load

    exit:
        rts
.endproc

; ------------------
; palette_init
; ------------------
.export palette_init
.proc palette_init
    lda #PALETTE_DEFAULT
    sta palette_state
    rts
.endproc
