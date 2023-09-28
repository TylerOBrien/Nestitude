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
.import clock_update
.import buffer_sprite_draw

; ------------------
; nmi_handle
; ------------------
.export nmi_handle
.proc nmi_handle
    jsr tick_update
    jsr clock_update
    jsr buffer_sprite_draw

    lda #0
    sta $2005
	sta $2005
    sta nmi_wait

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
