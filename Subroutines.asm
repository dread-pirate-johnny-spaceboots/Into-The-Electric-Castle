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

ReadJoystick1
        ldy #0
        sty JOYSTICK_INPUT1
        jsr @CheckRight
        jsr @CheckLeft
        jsr @CheckUp
        jsr @CheckDown
        jsr @CheckBtn
        rts
@CheckRight
        lda JOYSTICK_PORT1
        and #JOYSTICK_MASK_RIGHT
        beq @InputRight
        rts
@InputRight
        lda JOYSTICK_INPUT1
        ora #4
        sta JOYSTICK_INPUT1
        rts
@CheckLeft
        lda JOYSTICK_PORT1
        and #JOYSTICK_MASK_LEFT
        beq @InputLeft
        rts
@InputLeft
        lda JOYSTICK_INPUT1
        ora #16
        sta JOYSTICK_INPUT1
        rts
@CheckUp
        lda JOYSTICK_PORT1
        and #JOYSTICK_MASK_UP
        beq @InputUp
        rts
@InputUp
        lda JOYSTICK_INPUT1
        ora #2
        sta JOYSTICK_INPUT1
        rts
@CheckDown
        lda JOYSTICK_PORT1
        and #JOYSTICK_MASK_DOWN
        beq @InputDown
        rts
@CheckBtn
        lda JOYSTICK_PORT1
        and #JOYSTICK_MASK_BTN
        beq @InputBtn
        rts
@InputDown
        lda JOYSTICK_INPUT1
        ora #8
        sta JOYSTICK_INPUT1
        rts
@InputBtn
        lda JOYSTICK_INPUT1
        ora #1
        sta JOYSTICK_INPUT1
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
        ldy #$1
        sty PLAYER_MOVED_THIS_FRAME
        jsr PlayFootstep
        rts
@CheckRight
        lda JOYSTICK_INPUT
        and PLAYER_MOVED_RIGHT
        beq @Continue
        ldx PLAYER_X
        inx
        stx PLAYER_X
        ldy #$1
        sty PLAYER_MOVED_THIS_FRAME
        jsr PlayFootstep
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
        cpx #48
        bne @Continue
        ldx #0
        stx PLAYER_X
        stx SPRITE_OVERFLOW
        jsr NextLevel
        rts
@CheckDown
        lda JOYSTICK_INPUT
        and PLAYER_MOVED_DOWN
        beq @Continue
        ldy PLAYER_Y
        iny
        sty PLAYER_Y
        ldy #$1
        sty PLAYER_MOVED_THIS_FRAME
        jsr PlayFootstep
        rts
@CheckLeft
        lda JOYSTICK_INPUT
        and PLAYER_MOVED_LEFT
        beq @Continue
        ldx PLAYER_X
        dex
        stx PLAYER_X
        ldy #$1
        sty PLAYER_MOVED_THIS_FRAME
        jsr PlayFootstep
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

UpdatePlayerBulletPosition
        lda PLAYER_BULLET_X
        sta SPRITE1_X
        lda PLAYER_BULLET_Y
        sta SPRITE1_Y
        rts

InitSprites
        EnableSprites #%00000001
        PointToSpriteData PLAYER_SPRITE_INDEX,SPRITE0_POINTER
        PointToSpriteData PLAYER_BULLET_SPRITE_INDEX,SPRITE1_POINTER
        lda COLOUR_LIGHT_BLUE
        sta SPRITE0_COLOUR
        lda COLOUR_RED
        sta SPRITE1_COLOUR
        ldx #$4a
        stx PLAYER_X
        ldy #$5e
        sty PLAYER_Y
        jsr UpdatePlayerSpritePosition
        rts

UpdatePlayerSprite
        PointToSpriteData PLAYER_SPRITE_INDEX,SPRITE0_POINTER
        rts

UpdatePlayerBulletSprite
        PointToSpriteData PLAYER_BULLET_SPRITE_INDEX,SPRITE1_POINTER
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
        DrawScreen LEVEL1_BLOCK1,LEVEL1_BLOCK2,LEVEL1_BLOCK3,LEVEL1_BLOCK4
        rts

DrawTitle
        DrawScreen TITLE_BLOCK1,TITLE_BLOCK2,TITLE_BLOCK3,TITLE_BLOCK4
        rts

CheckForWallCollision
        lda SPRITE_BG_COLLISION
        cmp #%00000001
        bne @Continue
        jsr KillPlayer
@Continue
        rts

KillPlayer
        ldx PLAYER_DYING_COUNTER
        inx
        stx PLAYER_DYING_COUNTER
        lda PLAYER_DYING_ANIM1
        sta PLAYER_SPRITE_INDEX 
        ldx PLAYER_LIVES
        dex
        stx PLAYER_LIVES
        rts

InitPlayerState
        ldx #9
        stx PLAYER_LIVES
        ldx PLAYER_ACTION_SHOOT
        stx PLAYER_CURRENT_ACTION
        rts

#region Sound
PlayFootstep
        PlaySound #4,#0,#128,#128,#1
        rts

PlayZap
        PlaySound #25,#0,#40,#22,#7
        rts
#endregion

HandleAction
        jsr CheckForActionChange
        lda JOYSTICK_INPUT1
        and PLAYER_MOVED_UP
        bne @ShootUp
        lda JOYSTICK_INPUT1
        and PLAYER_MOVED_DOWN
        bne @ShootDown
        lda JOYSTICK_INPUT1
        and PLAYER_MOVED_LEFT
        bne @ShootLeft
        lda JOYSTICK_INPUT1
        and PLAYER_MOVED_RIGHT
        bne @ShootRight
        rts
@ShootUp
        lda JOYSTICK_INPUT1
        and PLAYER_MOVED_RIGHT
        bne @ShootUpRight
        lda JOYSTICK_INPUT1
        and PLAYER_MOVED_LEFT
        bne @ShootUpLeft
        lda PLAYER_SHOOT_N
        sta PLAYER_SPRITE_INDEX
        rts
@ShootUpRight
        lda PLAYER_SHOOT_NE
        sta PLAYER_SPRITE_INDEX
        rts
@ShootUpLeft
        lda PLAYER_SHOOT_NW
        sta PLAYER_SPRITE_INDEX
        rts
@ShootDown
        lda JOYSTICK_INPUT1
        and PLAYER_MOVED_RIGHT
        bne @ShootDownRight
        lda JOYSTICK_INPUT1
        and PLAYER_MOVED_LEFT
        bne @ShootDownLeft
        lda PLAYER_SHOOT_S
        sta PLAYER_SPRITE_INDEX
        rts
@ShootDownRight
        lda PLAYER_SHOOT_SE
        sta PLAYER_SPRITE_INDEX
        rts
@ShootDownLeft
        lda PLAYER_SHOOT_SW
        sta PLAYER_SPRITE_INDEX
        rts
@ShootLeft
        lda PLAYER_SHOOT_W
        sta PLAYER_SPRITE_INDEX
        rts
@ShootRight
        lda PLAYER_SHOOT_E
        sta PLAYER_SPRITE_INDEX
        rts

CheckForActionChange
        lda JOYSTICK_INPUT
        and PLAYER_ACTION
        bne @UpdateAction
        rts
@UpdateAction
        jsr ResetActionSelector
        lda PLAYER_CURRENT_ACTION
        cmp PLAYER_ACTION_SHOOT
        beq SetActionTalk
        cmp PLAYER_ACTION_TALK
        beq SetActionUse
        cmp PLAYER_ACTION_USE
        beq SetActionShoot
        rts
SetActionShoot
        ldx PLAYER_ACTION_SHOOT
        stx PLAYER_CURRENT_ACTION
        jsr ResetActionSelector
        ldx BOX_SELECTOR_TL
        stx ACTION_SELECTOR_POS1
        ldx BOX_SELECTOR_TR
        stx ACTION_SELECTOR_POS2
        ldx BOX_SELECTOR_BL
        stx ACTION_SELECTOR_POS3
        ldx BOX_SELECTOR_BR
        stx ACTION_SELECTOR_POS4
        rts
SetActionTalk
        ldx PLAYER_ACTION_TALK
        stx PLAYER_CURRENT_ACTION
        jsr ResetActionSelector
        ldx BOX_SELECTOR_TL
        stx ACTION_SELECTOR_POS5
        ldx BOX_SELECTOR_TR
        stx ACTION_SELECTOR_POS6
        ldx BOX_SELECTOR_BL
        stx ACTION_SELECTOR_POS7
        ldx BOX_SELECTOR_BR
        stx ACTION_SELECTOR_POS8
        rts
SetActionUse
        ldx PLAYER_ACTION_USE
        stx PLAYER_CURRENT_ACTION
        jsr ResetActionSelector
        ldx BOX_SELECTOR_TL
        stx ACTION_SELECTOR_POS9
        ldx BOX_SELECTOR_TR
        stx ACTION_SELECTOR_POS10
        ldx BOX_SELECTOR_BL
        stx ACTION_SELECTOR_POS11
        ldx BOX_SELECTOR_BR
        stx ACTION_SELECTOR_POS12
        rts
ResetActionSelector
        ldx #32
        stx ACTION_SELECTOR_POS1
        stx ACTION_SELECTOR_POS2
        stx ACTION_SELECTOR_POS3
        stx ACTION_SELECTOR_POS4
        stx ACTION_SELECTOR_POS5
        stx ACTION_SELECTOR_POS6
        stx ACTION_SELECTOR_POS7
        stx ACTION_SELECTOR_POS8
        stx ACTION_SELECTOR_POS9
        stx ACTION_SELECTOR_POS10
        stx ACTION_SELECTOR_POS11
        stx ACTION_SELECTOR_POS12
        rts