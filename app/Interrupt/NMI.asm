; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

nmi_wait: .res 1

.exportzp nmi_wait

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import tick_update
.import clock_tick
.import game_draw

; ------------------
; nmi_handle
; ------------------
.export nmi_handle
.proc nmi_handle
    jsr tick_update
    jsr clock_tick
    jsr game_draw ; Draw the game

    lda #0
    sta $2005
	sta $2005

    sta nmi_wait  ; Store 0 to disable the wait flag

    rti
.endproc

; ------------------
; nmi_init
; ------------------
.export nmi_init
.proc nmi_init
    lda #1
    sta nmi_wait
    rts
.endproc
