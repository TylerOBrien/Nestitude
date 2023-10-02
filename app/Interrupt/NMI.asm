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
.import buffer_background_draw
.import random_update

; ------------------
; nmi_handle
; ------------------
.export nmi_handle
.proc nmi_handle
    pha
    txa
    pha
    tya
    pha

    jsr tick_update
    jsr clock_update
    jsr buffer_sprite_draw
    jsr buffer_background_draw
    jsr random_update

    lda #0
    sta $2005
	sta $2005
    sta nmi_wait

    pla
    tay
    pla
    tax
    pla
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
