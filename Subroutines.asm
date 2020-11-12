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
        jsr ReadJoystick
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
        and #%00000001
        bne @CheckWrap 
        ldx PLAYER_X
        cpx #255
        bne @Continue
        lda SPRITE_OVERFLOW
        ora #%00000001
        sta SPRITE_OVERFLOW
        ldx #0
        stx PLAYER_X
        rts
@Continue
        rts
@CheckWrap
        ldx PLAYER_X
        cpx #48
        bne @Continue
        ldx #0
        stx PLAYER_X
        lda SPRITE_OVERFLOW
        and #%11111110
        sta SPRITE_OVERFLOW
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
        and #%00000001
        bne @CheckLeftWrap
        lda SPRITE_OVERFLOW
        ldx PLAYER_X
        cpx #0
        bne @Continue
        lda SPRITE_OVERFLOW
        ora #%00000001
        sta SPRITE_OVERFLOW
        lda #80
        sta PLAYER_X
        rts
@CheckLeftWrap
        ldx PLAYER_X
        cpx #0
        bne @Continue
        lda SPRITE_OVERFLOW
        and #%11111110
        sta SPRITE_OVERFLOW
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

UpdateDoorPosition
        lda DOOR_X
        sta SPRITE2_X
        lda DOOR_Y
        sta SPRITE2_Y
        rts

UpdateHoriDoorPosition
        lda HORI_DOOR_X
        sta SPRITE3_X
        lda HORI_DOOR_Y
        sta SPRITE3_Y
        rts

UpdateButtonPosition
        lda BUTTON_X
        sta SPRITE4_X
        lda BUTTON_Y
        sta SPRITE4_Y
        rts

UpdateButton2Position
        lda BUTTON2_X
        sta SPRITE5_X
        lda BUTTON2_Y
        sta SPRITE5_Y
        rts

UpdateNPC1Position
        lda NPC1_X
        sta SPRITE6_X
        lda NPC1_Y
        sta SPRITE6_Y
        rts

UpdateNPC2Position
        lda NPC2_X
        sta SPRITE7_X
        lda NPC2_Y
        sta SPRITE7_Y
        rts

InitSprites
        EnableSprites #%11111101
        lda PLAYER_IDLE
        STA PLAYER_SPRITE_INDEX
        STA NPC1_SPRITE_INDEX
        STA NPC2_SPRITE_INDEX
        LDA PLAYER_BULLET_HORI
        STA PLAYER_BULLET_SPRITE_INDEX
        LDA DOOR_FRAME1
        STA DOOR_SPRITE_INDEX
        LDA HORI_DOOR_FRAME1
        STA HORI_DOOR_SPRITE_INDEX
        
        LDA BUTTON_FRAME1
        STA BUTTON_SPRITE_INDEX
        STA BUTTON2_SPRITE_INDEX
        PointToSpriteData PLAYER_SPRITE_INDEX,SPRITE0_POINTER
        PointToSpriteData PLAYER_BULLET_SPRITE_INDEX,SPRITE1_POINTER
        PointToSpriteData DOOR_SPRITE_INDEX,SPRITE2_POINTER
        PointToSpriteData HORI_DOOR_SPRITE_INDEX,SPRITE3_POINTER
        PointToSpriteData BUTTON_SPRITE_INDEX,SPRITE4_POINTER
        PointToSpriteData BUTTON2_SPRITE_INDEX,SPRITE5_POINTER
        PointToSpriteData NPC1_SPRITE_INDEX,SPRITE6_POINTER
        PointToSpriteData NPC2_SPRITE_INDEX,SPRITE7_POINTER
        lda SPRITE_OVERFLOW
        ora #%10101000 
        sta SPRITE_OVERFLOW
        lda COLOUR_LIGHT_BLUE
        sta SPRITE0_COLOUR
        lda COLOUR_RED
        sta SPRITE1_COLOUR
        ldx #$4a
        stx PLAYER_X
        stx PLAYER_BULLET_X
        ldy #$5e
        sty PLAYER_Y
        stx PLAYER_BULLET_Y
        jsr UpdatePlayerSpritePosition
        jsr UpdatePlayerBulletPosition
        jsr UpdateHoriDoorPosition
        jsr UpdateDoorPosition
        jsr UpdateButtonPosition
        jsr UpdateButton2Position
        jsr UpdateNPC1Position
        jsr UpdateNPC2Position
        rts

UpdatePlayerSprite
        PointToSpriteData PLAYER_SPRITE_INDEX,SPRITE0_POINTER
        rts

UpdatePlayerBulletSprite
        PointToSpriteData PLAYER_BULLET_SPRITE_INDEX,SPRITE1_POINTER
        rts

UpdateDoorSprite
        PointToSpriteData DOOR_SPRITE_INDEX,SPRITE2_POINTER
        rts

UpdateHoriDoorSprite
        PointToSpriteData HORI_DOOR_SPRITE_INDEX,SPRITE3_POINTER
        rts

UpdateButtonSprite
        PointToSpriteData BUTTON_SPRITE_INDEX,SPRITE4_POINTER
        rts

UpdateButton2Sprite
        PointToSpriteData BUTTON2_SPRITE_INDEX,SPRITE5_POINTER
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
        tay
        and #%00000010
        bne DestroyBullet
        tya
        and #%00000001
        bne KillPlayer
@Continue
        rts

CheckForSpriteCollision
        lda SPRITE_COLLISIONS
        cmp #%00000101 ; player and door 1
        beq KillPlayer
        cmp #%00000110 ; door1 and bullet
        beq DestroyBullet
        cmp #%00001001 ; door 2 and player
        beq KillPlayer
        cmp #%00001010 ; door 2 and bullet
        beq DestroyBullet
        cmp #%00010010 ; bullet and button 1
        beq OpenDoor1
        cmp #%00100010
        beq OpenDoor2
        cmp #%01000010
        beq KillNPC1
        cmp #%10000010
        beq KillNPC2
        rts
KillNPC1
        jsr DestroyBullet
        DisableSprite #%10111111
        rts
KillNPC2
        jsr DestroyBullet
        DisableSprite #%01111111
        rts
OpenDoor1
        jsr DestroyBullet
        lda BUTTON_FRAME3
        sta BUTTON_SPRITE_INDEX
        jsr UpdateButtonSprite
        LDA #1
        STA DOOR1_OPEN_COUNTER
        rts

OpenDoor2
        jsr DestroyBullet
        lda BUTTON_FRAME3
        sta BUTTON2_SPRITE_INDEX
        jsr UpdateButton2Sprite
        LDA #1
        STA DOOR2_OPEN_COUNTER
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
        jsr DestroyBullet
        rts

DestroyBullet
        ;DisableSprite #%11111101
        lda PLAYER_BULLET_EXPLOSION_COUNTER
        cmp #0
        bne @cont
        lda #1
        sta PLAYER_BULLET_EXPLOSION_COUNTER
@cont
        rts

InitPlayerState
        ldx #9
        stx PLAYER_LIVES
        ldx PLAYER_ACTION_SHOOT
        stx PLAYER_CURRENT_ACTION
        ldx #0
        stx PLAYER_ACTION_SWITCH_COOLDOWN
        rts

#region Sound
PlayFootstep
        PlaySound #4,#0,#128,#128,#1,#65
        rts

PlayZap
        PlaySound #25,#0,#40,#22,#7,#129
        rts

PlayLaser
        PlaySound #25,#20,#44,#88,#3,#33
        rts
#endregion

UpdateLastAimDir
        lda PLAYER_SPRITE_INDEX
        cmp PLAYER_SHOOT_N
        beq @SetAimDir
        cmp PLAYER_SHOOT_E
        beq @SetAimDir
        cmp PLAYER_SHOOT_S
        beq @SetAimDir
        cmp PLAYER_SHOOT_W
        beq @SetAimDir
        cmp PLAYER_SHOOT_NE
        beq @SetAimDir
        cmp PLAYER_SHOOT_NW
        beq @SetAimDir
        cmp PLAYER_SHOOT_SE
        beq @SetAimDir
        cmp PLAYER_SHOOT_SW
        beq @SetAimDir
        rts
@SetAimDir
        lda PLAYER_SPRITE_INDEX
        sta PLAYER_BULLET_DIRECTION
        rts

HandleAction
        jsr @process
        jsr UpdateLastAimDir
        rts
@process
        ;jsr CheckForSelectedActionChange
        jsr CheckForAction
        jsr ReadJoystick1
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
        lda PLAYER_BULLET_VERT
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@ShootUpRight
        lda PLAYER_SHOOT_NE
        sta PLAYER_SPRITE_INDEX
        lda PLAYER_BULLET_SWNE
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@ShootUpLeft
        lda PLAYER_SHOOT_NW
        sta PLAYER_SPRITE_INDEX
        lda PLAYER_BULLET_NWSE
        sta PLAYER_BULLET_SPRITE_INDEX
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
        lda PLAYER_BULLET_VERT
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@ShootDownRight
        lda PLAYER_SHOOT_SE
        sta PLAYER_SPRITE_INDEX
        lda PLAYER_BULLET_NWSE
        sta PLAYER_BULLET_SPRITE_INDEX        
        rts
@ShootDownLeft
        lda PLAYER_SHOOT_SW
        sta PLAYER_SPRITE_INDEX
        lda PLAYER_BULLET_SWNE
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@ShootLeft
        lda PLAYER_SHOOT_W
        sta PLAYER_SPRITE_INDEX
        lda PLAYER_BULLET_HORI
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@ShootRight
        lda PLAYER_SHOOT_E
        sta PLAYER_SPRITE_INDEX
        lda PLAYER_BULLET_HORI
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
CheckForSelectedActionChange
        lda JOYSTICK_INPUT1
        and PLAYER_ACTION
        bne @UpdateAction
        rts
@UpdateAction
        ldx PLAYER_ACTION_SWITCH_COOLDOWN
        inx 
        stx PLAYER_ACTION_SWITCH_COOLDOWN
        cpx #1
        beq @ProcessActionUpdate
        cpx #16
        beq @ProcessActionUpdate
        cpx #32
        beq @ProcessActionUpdate
        cpx #48
        beq @ProcessActionUpdate
        cpx #64
        beq @ProcessActionUpdate
        cpx #80
        beq @ProcessActionUpdate
        cpx #96
        beq @ProcessActionUpdate
        cpx #110
        beq @ProcessActionUpdate
        cpx #128
        beq @ProcessActionUpdate
        cpx #142
        beq @ProcessActionUpdate
        cpx #160
        beq @ProcessActionUpdate
        cpx #176
        beq @ProcessActionUpdate
        cpx #198
        beq @ProcessActionUpdate
        cpx #214
        beq @ProcessActionUpdate
        cpx #230
        beq @ProcessActionUpdate
        rts
@ProcessActionUpdate
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
CheckForAction
        jsr ToggleTiles
        lda SPRITE_ENABLED
        and #%00000010
        beq @ActionCanProceed
        jsr @MoveBullet
        
        rts
@ActionCanProceed
        jsr ReadJoystick
        lda JOYSTICK_INPUT
        and PLAYER_ACTION
        beq @ActCont
        jsr @Shoot
        rts
@ActCont
        rts
@Shoot
        jsr PlayLaser
        ldx PLAYER_X
        stx PLAYER_BULLET_X        
        ldy PLAYER_Y
        sty PLAYER_BULLET_Y
        EnableSprite #%00000010
        jsr UpdatePlayerBulletPosition
        lda SPRITE_OVERFLOW
        and #%00000001
        bne @SetBulletXOverflowOn
        jsr @SetBulletXOverflowOff
        ;jsr UpdatePlayerBulletSprite
        rts
@SetBulletXOverflowOn
        lda SPRITE_OVERFLOW
        ora #%00000010
        sta SPRITE_OVERFLOW
        rts
@SetBulletXOverflowOff
        lda SPRITE_OVERFLOW
        and #%11111101
        sta SPRITE_OVERFLOW
        rts
@MoveBullet
        lda PLAYER_BULLET_X
        cmp #255
        beq @CheckForBulletOverflow
        cmp #0
        beq @CheckForBulletOverflowL
        jsr @process
        jsr UpdatePlayerBulletSprite
        rts
@CheckForBulletOverflow
        lda PLAYER_BULLET_DIRECTION
        cmp PLAYER_SHOOT_E
        beq @BulletOverflowRight
        cmp PLAYER_SHOOT_NE
        beq @BulletOverflowRight
        cmp PLAYER_SHOOT_SE
        beq @BulletOverflowRight
        jsr @process
        jsr UpdatePlayerBulletSprite
        rts
@CheckForBulletOverflowL
        lda PLAYER_BULLET_DIRECTION
        cmp PLAYER_SHOOT_W
        beq @BulletOverflowLeft
        cmp PLAYER_SHOOT_SW
        beq @BulletOverflowLeft
        cmp PLAYER_SHOOT_NW
        beq @BulletOverflowLeft
        jsr @process
        jsr UpdatePlayerBulletSprite
        rts
@BulletOverflowLeft
        lda SPRITE_OVERFLOW
        and #%11111101
        sta SPRITE_OVERFLOW
        lda #255
        sta PLAYER_BULLET_X
        rts
@BulletOverflowRight
        lda SPRITE_OVERFLOW
        ora #%00000010
        sta SPRITE_OVERFLOW
        lda #0
        sta PLAYER_BULLET_X
        rts
@process
        lda PLAYER_BULLET_EXPLOSION_COUNTER
        cmp #0
        beq @continueProcessing
        rts
@continueProcessing
        lda PLAYER_BULLET_DIRECTION
        cmp PLAYER_SHOOT_N
        beq @MoveBulletN
        cmp PLAYER_SHOOT_E
        beq @MoveBulletE
        cmp PLAYER_SHOOT_S
        beq @MoveBulletS
        cmp PLAYER_SHOOT_W
        beq @MoveBulletW
        cmp PLAYER_SHOOT_NE
        beq @MoveBulletNE
        cmp PLAYER_SHOOT_NW
        beq @MoveBulletNW
        cmp PLAYER_SHOOT_SE
        beq @MoveBulletSE
        cmp PLAYER_SHOOT_SW
        beq @MoveBulletSW
        rts
@MoveBulletN
        ldy PLAYER_BULLET_Y
        dey
        sty PLAYER_BULLET_Y
        lda PLAYER_BULLET_VERT
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@MoveBulletE
        ldy PLAYER_BULLET_X
        iny
        sty PLAYER_BULLET_X
        lda PLAYER_BULLET_HORI
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@MoveBulletW
        ldy PLAYER_BULLET_X
        dey
        sty PLAYER_BULLET_X
        lda PLAYER_BULLET_HORI
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@MoveBulletS
        ldy PLAYER_BULLET_Y
        iny
        sty PLAYER_BULLET_Y
        lda PLAYER_BULLET_VERT
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@MoveBulletNW
        ldx PLAYER_BULLET_X
        ldy PLAYER_BULLET_Y
        dex
        dey
        stx PLAYER_BULLET_X
        sty PLAYER_BULLET_Y
        lda PLAYER_BULLET_NWSE
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@MoveBulletNE
        ldx PLAYER_BULLET_X
        ldy PLAYER_BULLET_Y
        inx
        dey
        stx PLAYER_BULLET_X
        sty PLAYER_BULLET_Y
        lda PLAYER_BULLET_SWNE
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@MoveBulletSW
        ldx PLAYER_BULLET_X
        ldy PLAYER_BULLET_Y
        dex
        iny
        stx PLAYER_BULLET_X
        sty PLAYER_BULLET_Y
        lda PLAYER_BULLET_SWNE
        sta PLAYER_BULLET_SPRITE_INDEX
        rts
@MoveBulletSE
        ldx PLAYER_BULLET_X
        ldy PLAYER_BULLET_Y
        inx
        iny
        stx PLAYER_BULLET_X
        sty PLAYER_BULLET_Y
        lda PLAYER_BULLET_NWSE
        sta PLAYER_BULLET_SPRITE_INDEX
        rts

HandleBulletExplosion
        ldx PLAYER_BULLET_EXPLOSION_COUNTER
        cpx #0
        beq @Cont
        lda #%00000010
        sta SPRITE_MULTICOLOUR_ENABLE
        jsr PlayZap
        inx
        stx PLAYER_BULLET_EXPLOSION_COUNTER
        cpx #2
        beq @Frame1
        cpx #6
        beq @Frame2
        cpx #12
        beq @Frame3
        cpx #18
        beq @Frame4
        cpx #24
        beq @Frame5
        cpx #32
        beq @Destroy
        rts
@Frame1
        lda PLAYER_BULLET_EXPLOSION1
        sta PLAYER_BULLET_SPRITE_INDEX
        jsr UpdatePlayerBulletSprite
        rts
@Frame2
        lda PLAYER_BULLET_EXPLOSION2
        sta PLAYER_BULLET_SPRITE_INDEX
        jsr UpdatePlayerBulletSprite
        rts
@Frame3
        lda PLAYER_BULLET_EXPLOSION3
        sta PLAYER_BULLET_SPRITE_INDEX
        jsr UpdatePlayerBulletSprite
        rts
@Frame4
        lda PLAYER_BULLET_EXPLOSION4
        sta PLAYER_BULLET_SPRITE_INDEX
        jsr UpdatePlayerBulletSprite
        rts
@Frame5
        lda PLAYER_BULLET_EXPLOSION5
        sta PLAYER_BULLET_SPRITE_INDEX
        jsr UpdatePlayerBulletSprite
        rts
@Destroy
        lda #%00000000
        sta SPRITE_MULTICOLOUR_ENABLE
        lda #0
        sta PLAYER_BULLET_EXPLOSION_COUNTER
        DisableSprite #%11111101
        lda PLAYER_BULLET_HORI
        sta PLAYER_BULLET_SPRITE_INDEX
@Cont
        rts

HandleTalk
        jsr ReadJoystick
        lda JOYSTICK_INPUT
        cmp PLAYER_ACTION
        beq @processtalk
        jmp GameLoop
@processtalk
        sec
        lda PLAYER_X
        
        sbc NPC1_X
        cmp #16
        bcc @CheckNPC1Y
        cmp #239
        beq @CheckNPC2
        bcs @CheckNPC1Y
@conttalk
        jmp GameLoop
@CheckNPC1Y
        sec
        lda PLAYER_Y
        SBC NPC1_Y
        CMP #16
        BCC @TalkToNPC1
        cmp #239
        beq @CheckNPC2
        bcs @TalkToNPC1
@CheckNPC2
        sec
        lda PLAYER_X
        
        sbc NPC2_X
        cmp #16
        bcc @CheckNPC2Y
        cmp #239
        beq @conttalk
        bcs @CheckNPC2Y
@CheckNPC2Y
        sec
        lda PLAYER_Y
        SBC NPC2_Y
        CMP #16
        BCC @TalkToNPC2
        cmp #239
        bcs @TalkToNPC2
        jmp GameLoop
@TalkToNPC1
        jsr @DrawDialogue
        rts
@TalkToNPC2
        jsr @DrawDialogue
        rts
@DrawDialogue
        
        rts
ToggleTiles
        ;ldx LEVEL1_TILE_COUNTER
        ;inx 
        ;stx LEVEL1_TILE_COUNTER
        ;cpx #128
        ;beq TurnOffTiles
        ;cpx #255
        beq TurnOnTiles
        rts
TurnOffTiles
        lda #32
        StoreLevel1Tiles
        
        rts

TurnOnTiles
        lda #88
        StoreLevel1Tiles
        lda #0
        sta LEVEL1_TILE_COUNTER
        rts

