; ---------------------------------------------------------------
; ZeroPage
; ---------------------------------------------------------------

.segment "ZEROPAGE"

obstruct_id:    .res 1
obstruct_x_min: .res 1
obstruct_x_max: .res 1
obstruct_y_min: .res 1
obstruct_y_max: .res 1

.exportzp obstruct_id
.exportzp obstruct_x_min
.exportzp obstruct_x_max
.exportzp obstruct_y_min
.exportzp obstruct_y_max
