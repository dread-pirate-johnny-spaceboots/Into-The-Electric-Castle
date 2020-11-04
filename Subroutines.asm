ClearScreen
        lda #147
        jsr CharOut
        rts

ReadJoystick
        ldy #0
        sty JOYSTICK_INPUT
        lda JOYSTICK_PORT2
        and #JOYSTICK_MASK_RIGHT
        beq @InputRight
        lda JOYSTICK_PORT2
        and #JOYSTICK_MASK_LEFT
        beq @InputLeft
        lda JOYSTICK_PORT2
        and #JOYSTICK_MASK_UP
        beq @InputUp
        lda JOYSTICK_PORT2
        and #JOYSTICK_MASK_DOWN
        beq @InputDown
        lda JOYSTICK_PORT2
        and #JOYSTICK_MASK_BTN
        beq @InputBtn
        rts
@InputRight
        ldy #4
        sty JOYSTICK_INPUT
        rts
@InputLeft
        ldy #16
        sty JOYSTICK_INPUT
        rts
@InputUp
        ldy #2
        sty JOYSTICK_INPUT
        rts
@InputDown
        ldy #8
        sty JOYSTICK_INPUT
        rts
@InputBtn
        ldy #1
        sty JOYSTICK_INPUT
        rts