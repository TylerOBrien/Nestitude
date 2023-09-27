; ------------------
; Imports
; ------------------

.import irq_handle
.import nmi_handle
.import reset_handle

; ------------------
; Vectors
; ------------------

.segment "VECTORS"
.addr nmi_handle, reset_handle, irq_handle
