; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

actor_pointer_lo: .res 1
actor_pointer_hi: .res 1

.exportzp actor_pointer_lo
.exportzp actor_pointer_hi
