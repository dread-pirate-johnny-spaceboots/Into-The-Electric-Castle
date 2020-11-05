ClearScreen
        lda #147
        jsr CharOut
        rts

#region Read Joystick
ReadJoystick
        ldy #0
        sty JOYSTICK_INPUT
        jsr @CheckRight
        jsr @CheckLeft
        jsr @CheckUp
        jsr @CheckDown
        jsr @CheckBtn
        rts
@CheckRight
        lda JOYSTICK_PORT2
        and #JOYSTICK_MASK_RIGHT
        beq @InputRight
        rts
@InputRight
        lda JOYSTICK_INPUT
        ora #4
        sta JOYSTICK_INPUT
        rts
@CheckLeft
        lda JOYSTICK_PORT2
        and #JOYSTICK_MASK_LEFT
        beq @InputLeft
        rts
@InputLeft
        lda JOYSTICK_INPUT
        ora #16
        sta JOYSTICK_INPUT
        rts
@CheckUp
        lda JOYSTICK_PORT2
        and #JOYSTICK_MASK_UP
        beq @InputUp
        rts
@InputUp
        lda JOYSTICK_INPUT
        ora #2
        sta JOYSTICK_INPUT
        rts
@CheckDown
        lda JOYSTICK_PORT2
        and #JOYSTICK_MASK_DOWN
        beq @InputDown
        rts
@CheckBtn
        lda JOYSTICK_PORT2
        and #JOYSTICK_MASK_BTN
        beq @InputBtn
        rts
@InputDown
        lda JOYSTICK_INPUT
        ora #8
        sta JOYSTICK_INPUT
        rts
@InputBtn
        lda JOYSTICK_INPUT
        ora #1
        sta JOYSTICK_INPUT
        rts
#endregion

#region Move Player
MovePlayer
        jsr @CheckUp
        jsr @CheckDown
        jsr @CheckLeft
        jsr @CheckRight
        rts
@CheckUp
        lda JOYSTICK_INPUT
        and PLAYER_MOVED_UP
        beq @Continue
        ldy PLAYER_Y
        dey
        sty PLAYER_Y
        rts
@CheckRight
        lda JOYSTICK_INPUT
        and PLAYER_MOVED_RIGHT
        beq @Continue
        ldx PLAYER_X
        inx
        stx PLAYER_X
        ;Right side wrap
        lda SPRITE_OVERFLOW
        cmp #%00000001
        beq @CheckWrap 
        ldx PLAYER_X
        cpx #255
        bne @Continue
        lda SPRITE_OVERFLOW
        ora #%00000001
        sta SPRITE_OVERFLOW
        sta PLAYER_X
        rts
@Continue
        rts
@CheckWrap
        ldx PLAYER_X
        cpx #80
        bne @Continue
        ldx #0
        stx PLAYER_X
        stx SPRITE_OVERFLOW
        rts
@CheckDown
        lda JOYSTICK_INPUT
        and PLAYER_MOVED_DOWN
        beq @Continue
        ldy PLAYER_Y
        iny
        sty PLAYER_Y
        rts
@CheckLeft
        lda JOYSTICK_INPUT
        and PLAYER_MOVED_LEFT
        beq @Continue
        ldx PLAYER_X
        dex
        stx PLAYER_X
        ; Left side wrap
        lda SPRITE_OVERFLOW
        cmp #%00000001
        beq @CheckLeftWrap
        lda SPRITE_OVERFLOW
        ldx PLAYER_X
        cpx #0
        bne @Continue
        lda #%00000001
        sta SPRITE_OVERFLOW
        lda #80
        sta PLAYER_X
        rts
@CheckLeftWrap
        ldx PLAYER_X
        cpx #0
        bne @Continue
        ldx #%00000000
        stx SPRITE_OVERFLOW
        ldx #255
        stx PLAYER_X
        rts
#endregion

#region Update Player Animation Frame
UpdatePlayerAnimationFrame
        lda JOYSTICK_INPUT
        and PLAYER_MOVED_RIGHT
        bne @SetRight
        lda JOYSTICK_INPUT        
        and PLAYER_MOVED_LEFT
        bne @SetLeft
        lda JOYSTICK_INPUT        
        and PLAYER_MOVED_UP
        bne @SetUp
        lda JOYSTICK_INPUT        
        and PLAYER_MOVED_DOWN
        bne @SetDown
        ldx PLAYER_IDLE
        stx PLAYER_SPRITE_INDEX
        rts
@SetRight
        ldx PLAYER_SPRITE_INDEX
        cpx PLAYER_RIGHT_ANIM2
        beq @RightFrame1
        ldx PLAYER_RIGHT_ANIM2
        stx PLAYER_SPRITE_INDEX
        rts
@RightFrame1
        ldx PLAYER_RIGHT_ANIM1
        stx PLAYER_SPRITE_INDEX
        rts
@SetLeft
        ldx PLAYER_SPRITE_INDEX
        cpx PLAYER_LEFT_ANIM2
        beq @LeftFrame1
        ldx PLAYER_LEFT_ANIM2
        stx PLAYER_SPRITE_INDEX
        rts
@LeftFrame1
        ldx PLAYER_LEFT_ANIM1
        stx PLAYER_SPRITE_INDEX
        rts
@SetUp
        ldx PLAYER_SPRITE_INDEX
        cpx PLAYER_UP_ANIM2
        beq @UpFrame1
        ldx PLAYER_UP_ANIM2
        stx PLAYER_SPRITE_INDEX
        rts
@UpFrame1
        ldx PLAYER_UP_ANIM1
        stx PLAYER_SPRITE_INDEX
        rts
@SetDown
        ldx PLAYER_SPRITE_INDEX
        cpx PLAYER_DOWN_ANIM2
        beq @DownFrame1
        ldx PLAYER_DOWN_ANIM2
        stx PLAYER_SPRITE_INDEX
        rts
@DownFrame1
        ldx PLAYER_DOWN_ANIM1
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
        ldx #$50
        stx PLAYER_X
        ldy #$64
        sty PLAYER_Y
        jsr UpdatePlayerSpritePosition
        rts

UpdatePlayerSprite
        PointToSpriteData PLAYER_SPRITE_INDEX,SPRITE0_SHAPEDATA
        rts

InitCharacterSet
        lda CHARSET_LOOKUP
        ora #$0e
        sta CHARSET_LOOKUP
        lda SCREEN_CONTROL
        ora #%00010000
        sta SCREEN_CONTROL
        lda COLOUR_LIGHT_BLUE
        sta BG_COLOUR1
        lda COLOUR_WHITE
        sta BG_COLOUR2
        lda COLOUR_RED
        sta BG_COLOUR3
        rts

DrawLevel
        ldx #0
@Block1
        lda LEVEL1_BLOCK1,x
        tay
        sta SCREEN_BLOCK1,x
        inx
        cpx #255
        bne @Block1
        ldx #0
@Block2
        lda LEVEL1_BLOCK2,x
        tay
        sta SCREEN_BLOCK2,x
        inx
        cpx #255
        bne @Block2
        ldx #0
@Block3
        lda LEVEL1_BLOCK3,x
        tay
        sta SCREEN_BLOCK3,x
        inx
        cpx #255
        bne @Block3
        ldx #0
@Block4
        lda LEVEL1_BLOCK4,x
        tay
        sta SCREEN_BLOCK4,x
        inx
        cpx #255
        bne @Block4
        ldx #0
        rts
