; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

actor_x_min: .res 1
actor_x_max: .res 1
actor_y_min: .res 1
actor_y_max: .res 1

.exportzp actor_x_min
.exportzp actor_x_max
.exportzp actor_y_min
.exportzp actor_y_max
