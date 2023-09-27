; ---------------------------------------------------------------
; Includes
; ---------------------------------------------------------------

.include "../constants.inc"

; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

clock_ms: .res 1
clock_sec: .res 1
clock_min: .res 1

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

; ------------------
; clock_tick
; ------------------
.export clock_tick
.proc clock_tick
    ;
.endproc

; ------------------
; clock_init
; ------------------
.export clock_init
.proc clock_init
    lda #0
    sta clock_ms
    sta clock_sec
    sta clock_min
    rts
.endproc
