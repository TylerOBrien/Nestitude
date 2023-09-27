; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

nmi_wait:  .res 1
nmi_count: .res 1

.exportzp nmi_wait
.exportzp nmi_count

; ---------------------------------------------------------------
; Code
; ---------------------------------------------------------------

.segment "CODE"

.import game_draw

; ------------------
; nmi_handle
; ------------------
.export nmi_handle
.proc nmi_handle
    lda #0
    sta $2003 ; OAM_ADDR
    lda #2
    sta $4014 ; OAM_DMA

    jsr game_draw ; Draw the game

    lda #0
    sta $2005
	sta $2005

    sta nmi_wait  ; Store 0 to disable the wait flag
    inc nmi_count ; Increment the NMI tick count

    rti
.endproc

; ------------------
; nmi_init
; ------------------
.export nmi_init
.proc nmi_init
    lda #0
    sta nmi_count
    lda #1
    sta nmi_wait
    rts
.endproc
