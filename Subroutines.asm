ClearScreen
        lda #147
        jsr CharOut
        rts

#region Read Joystick
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
#endregion

#region Move Player
MovePlayer
        lda JOYSTICK_INPUT
        cmp PLAYER_MOVED_UP
        bne @CheckRight
        ldy PLAYER_Y
        dey
        sty PLAYER_Y
        ldx PLAYER_UP
        stx PLAYER_SPRITE_INDEX
        rts
@CheckRight
        lda JOYSTICK_INPUT
        cmp PLAYER_MOVED_RIGHT
        bne @CheckDown
        ldx PLAYER_X
        inx
        stx PLAYER_X
        ldx PLAYER_RIGHT
        stx PLAYER_SPRITE_INDEX
        ;Right side wrap
        lda SPRITE_OVERFLOW
        cmp #%00000001
        beq @CheckWrap 
        ldx PLAYER_X
        cpx #255
        bne @ContRight
        lda SPRITE_OVERFLOW
        ora #%00000001
        sta SPRITE_OVERFLOW
        sta PLAYER_X
        rts
@ContRight
        rts
@CheckWrap
        ldx PLAYER_X
        cpx #80
        bne @ContRight
        ldx #0
        stx PLAYER_X
        stx SPRITE_OVERFLOW
        rts
@CheckDown
        lda JOYSTICK_INPUT
        cmp PLAYER_MOVED_DOWN
        bne @CheckLeft
        ldy PLAYER_Y
        iny
        sty PLAYER_Y
        ldx PLAYER_DOWN
        stx PLAYER_SPRITE_INDEX
        rts
@CheckLeft
        lda JOYSTICK_INPUT
        cmp PLAYER_MOVED_LEFT
        bne @CheckButton
        ldx PLAYER_X
        dex
        stx PLAYER_X
        ldx PLAYER_LEFT
        stx PLAYER_SPRITE_INDEX
        ; Left side wrap
        lda SPRITE_OVERFLOW
        cmp #%00000001
        beq @CheckLeftWrap
        lda SPRITE_OVERFLOW
        ldx PLAYER_X
        cpx #0
        bne @ContLeft
        lda #%00000001
        sta SPRITE_OVERFLOW
        lda #80
        sta PLAYER_X
@ContLeft
        rts
@CheckLeftWrap
        ldx PLAYER_X
        cpx #0
        bne @ContLeft
        ldx #%00000000
        stx SPRITE_OVERFLOW
        ldx #255
        stx PLAYER_X
        rts
@CheckButton
        lda JOYSTICK_INPUT
        cmp PLAYER_ACTION
        bne @Idle
        rts
@Idle
        ldx PLAYER_IDLE
        stx PLAYER_SPRITE_INDEX
        rts
#endregion

UpdatePlayerSpritePosition
        lda PLAYER_X
        sta SPRITE0_X
        lda PLAYER_Y
        sta SPRITE0_Y
        rts

InitSprites
        EnableSprites #%00000001
        PointToSpriteData PLAYER_SPRITE_INDEX,SPRITE0_SHAPEDATA
        lda COLOUR_LIGHT_BLUE
        sta SPRITE0_COLOUR
        jsr UpdatePlayerSpritePosition
        rts
