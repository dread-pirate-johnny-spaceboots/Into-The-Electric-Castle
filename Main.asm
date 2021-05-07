; 10 SYS (2080)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $30, $38, $30, $29, $00, $00, $00

incasm "MemoryMap.asm"

*=SPRITE0_DATA
incbin "PlayerSprites.bin" 

*=SPRITE1_DATA
incbin "Bullet.bin"

*=CHARSET
incbin "LevelGeo.bin"

*=FOREVER_CHARSET
incbin "ForeverCharset.bin"

*=TITLE_BLOCK1
incbin "Title.bin"

*=LEVEL1_BLOCK1
incbin "Level1.bin"

*=FOREVER_BLOCK1
incbin "ForeverOfTheStars.bin"

*=DOOR_SPRITE_DATA
incbin "Door.bin"

*=SPRITE4_DATA
incbin "Button.bin"

incasm "Macros.asm"
incasm "Data.asm"

*=$0820
        ldx #00
        stx DOOR1_OPEN_COUNTER
        stx DOOR2_OPEN_COUNTER
        stx BORDER_COLOUR
        stx LEVEL1_TILE_COUNTER
        stx PLAYER_BULLET_EXPLOSION_COUNTER
        ldx #1
        stx PLAYER_DYING_COUNTER
        ldx COLOUR_BLACK
        stx BG_COLOUR
        jsr ClearScreen
        jsr DrawTitle
        jsr InitCharacterSet
        jsr InitPlayerState
TitleLoop
        jsr ReadJoystick
        lda JOYSTICK_INPUT
        and PLAYER_ACTION
        bne InitGame
        jmp TitleLoop
InitGame
        ldx COLOUR_BLACK
        stx BG_COLOUR
        ldx COLOUR_LIGHT_BLUE
        stx TEXT_COLOUR
        jsr ClearScreen
        jsr DrawLevel
        jsr InitSprites
GameLoop
        WaitForRaster #255
        ldx #0
        stx PLAYER_MOVED_THIS_FRAME
        lda PLAYER_DYING_COUNTER
        cmp #0
        bne @HandleDying
        jsr ReadJoystick
        jsr UpdatePlayerAnimationFrame
        jsr UpdatePlayerSprite
        jsr MovePlayer
        jsr UpdatePlayerSpritePosition    
        jsr CheckForWallCollision
        jsr CheckForSpriteCollision
        jsr UpdatePlayerBulletPosition
        jsr HandleBulletExplosion
        lda PLAYER_LIVES
        ora #48
        sta PLAYER_LIVES_POSITION
        
        lda DOOR1_OPEN_COUNTER
        cmp #0
        bne @HandleDoor1Open

        lda DOOR2_OPEN_COUNTER
        cmp #0
        bne @openD2

        jsr ReadJoystick1
        jsr CheckForSelectedActionChange

        lda PLAYER_MOVED_THIS_FRAME
        cmp #$1
        bne @ActionSwitch
        jsr CheckForAction ; Handles moving the bullet in cases where no action was processes. TODO: Rename
        ;jmp ResetLoop
        jmp GameLoop
        rts
@ActionSwitch
        lda PLAYER_CURRENT_ACTION
        cmp PLAYER_ACTION_SHOOT
        beq @HandleAction
        cmp PLAYER_ACTION_TALK
        beq @TriggerTalk
        
        jmp GameLoop
@TriggerTalk
        jmp HandleTalk
@openD2
        jmp HandleDoor2Open
        rts
@HandleAction
        jsr ReadJoystick1
        jsr HandleAction
        jsr UpdatePlayerSprite
        jmp GameLoop
@HandleDying
        jsr PlayZap
        jsr UpdatePlayerSprite
        ldx PLAYER_DYING_COUNTER
        cpx #64
        beq @CheckLives
        inx
        stx PLAYER_DYING_COUNTER
        lda PLAYER_SPRITE_INDEX
        cmp PLAYER_DYING_ANIM2
        beq @DyingFrame1
        ldx PLAYER_DYING_ANIM2
        stx PLAYER_SPRITE_INDEX
        jmp GameLoop
@DyingFrame1
        ldx PLAYER_DYING_ANIM1
        stx PLAYER_SPRITE_INDEX
        jmp GameLoop
        rts
@HandleDoor1Open
        lda DOOR1_OPEN_COUNTER
        tax
        inx
        stx DOOR1_OPEN_COUNTER
        cmp #1
        beq @Door1OpenFrame1
        cmp #2
        beq @Door1OpenFrame2
        cmp #3
        beq @Door1OpenFrame3
        cmp #4
        beq @Door1OpenFrame4
        cmp #5
        beq @DestroyDoor1
        jmp GameLoop
        rts
@Door1OpenFrame1
        lda DOOR_FRAME2
        STA DOOR_SPRITE_INDEX
        jsr UpdateDoorSprite
        jmp GameLoop
@Door1OpenFrame2
        lda DOOR_FRAME3
        STA DOOR_SPRITE_INDEX
        jsr UpdateDoorSprite
        jmp GameLoop
@Door1OpenFrame3
        lda DOOR_FRAME4
        STA DOOR_SPRITE_INDEX
        jsr UpdateDoorSprite
        jmp GameLoop
@Door1OpenFrame4
        lda DOOR_FRAME5
        STA DOOR_SPRITE_INDEX
        jsr UpdateDoorSprite
        jmp GameLoop
@DestroyDoor1
        DisableSprite #%11111011
        ldx #0
        stx DOOR1_OPEN_COUNTER
        jmp GameLoop
@CheckLives
        ldx PLAYER_LIVES
        cpx #0
        beq @GameOver
@Respawn
        lda SPRITE_OVERFLOW
        and #%11111110
        sta SPRITE_OVERFLOW
        ldx #$4a
        stx PLAYER_X
        ldx #$5e
        stx PLAYER_Y
        ldx #0
        stx PLAYER_DYING_COUNTER
        ldx PLAYER_IDLE
        stx PLAYER_SPRITE_INDEX
        jmp GameLoop
@GameOver
        jsr ClearScreen
        EnableSprites #%00000000
        lda COLOUR_BLACK
        sta TEXT_COLOUR
        lda COLOUR_RED
        sta BG_COLOUR
        PrintStr FT_GAMEOVER,#$8B,#0
@GameOverLoop
        jsr ReadJoystick
        lda JOYSTICK_INPUT
        and PLAYER_UP
        bne @GotoTitle
        jmp @GameOverLoop
        rts
@GotoTitle
        ldx COLOUR_BLACK
        stx BG_COLOUR
        ldx COLOUR_LIGHT_BLUE
        stx TEXT_COLOUR
        EnableSprites #%00000000
        jsr ClearScreen
        jsr DrawTitle
        ldx #5
        stx PLAYER_LIVES
        ldx #0
        stx PLAYER_DYING_COUNTER
        jmp TitleLoop
NextLevel
        jsr ClearScreen
        EnableSprites #%00000000
        lda COLOUR_WHITE
        sta TEXT_COLOUR
        DisableMultiColorMode
        SetCharacterSet #%00000101
        jsr DrawForever
        PrintStr FT_LEVEL1,#142,#$50
NextLevelLoop
        WaitForRaster #250
        SetCharacterSet #%000000111    
        
        WaitForRaster #129
        SetCharacterSet #%000000101
        
        ldx PLAYER_LIVES
        jsr ReadJoystick
        lda JOYSTICK_INPUT
        and PLAYER_ACTION
        bne InitNewLevel
        jmp NextLevelLoop
InitNewLevel
        jsr ClearScreen        
        SetCharacterSet #%00000111
        EnableMultiColorMode
        SetTextColor COLOUR_LIGHT_BLUE
        SetBackgroundColors COLOUR_BLACK,COLOUR_LIGHT_BLUE,COLOUR_WHITE,COLOUR_RED
        jsr DrawLevel
        jsr InitSprites
@Exit
        rts
HandleDoor2Open
        lda DOOR2_OPEN_COUNTER
        tax
        inx
        stx DOOR2_OPEN_COUNTER
        cmp #1
        beq @Door2OpenFrame1
        cmp #2
        beq @Door2OpenFrame2
        cmp #3
        beq @Door2OpenFrame3
        cmp #4
        beq @Door2OpenFrame4
        cmp #5
        beq DestroyDoor2
        jmp GameLoop
        rts
@Door2OpenFrame1
        lda HORI_DOOR_FRAME2
        STA HORI_DOOR_SPRITE_INDEX
        jsr UpdateHoriDoorSprite
        jmp GameLoop
@Door2OpenFrame2
        lda HORI_DOOR_FRAME3
        STA HORI_DOOR_SPRITE_INDEX
        jsr UpdateHoriDoorSprite
        jmp GameLoop
@Door2OpenFrame3
        lda HORI_DOOR_FRAME4
        STA HORI_DOOR_SPRITE_INDEX
        jsr UpdateHoriDoorSprite
        jmp GameLoop
@Door2OpenFrame4
        lda DOOR_FRAME5
        STA HORI_DOOR_SPRITE_INDEX
        jsr UpdateDoorSprite
        jmp GameLoop
DestroyDoor2
        DisableSprite #%11110111
        ldx #0
        stx DOOR2_OPEN_COUNTER
        jmp GameLoop



incasm "Subroutines.asm"

; Flavour Text
FT_LEVEL1 text 'Do you wish to lapse in limbo forever?  No! No! Be resolute! Free your mind of  anger and aggression if you ever want toend this future dream.'
          byte 00
FT_LEVEL2 text 'You are three souls of the flesh, chosen from different eras ancient and modern, representatives of your own cherished time. The trivia of your mortal lives is unimportant to me. Indeed, some may die.'
          byte 00
FT_LEVEL2P2 text 'There is danger ahead, but do not be afraid. For I am with you, as water, as air, as breath itself in this place of no time and no space. Be resolute. There are trials ahead... and rewards for those who strive.'
          byte 00
FT_LEVEL2P3 text 'Look around, but linger not. Where I lead you will follow. Mark these words well: Ignite my anger with your delay and punishments will come your way.'
          byte 00
FT_LEVEL2P4 text 'You have a task! To release yourselves from this web of wisdom, this knotted maze of delerium you must enter the nuclear portals of the electric castle!'
          byte 00
FT_LEVEL3 text 'It is time to reflect upon your ego self. Nowhere to hide when the walls echo the you that we all see. From these wind torn ramparts we survey a thousand futures. Breath deep the intoxicating aroma of endless entwined emotions. The surreal search endures.'
          byte 00
FT_LEVEL4 text "Ah my friends! So light of foot! So swift! Youve come this far. And now, here beneath the ancient omniscient boughs of the Decision Tree, one of you must depart this world of flesh. Only two may continue. Only you can decide!"
          byte 00
FT_LEVEL5 text "Step forward! Step forward! Beyond this lies your goal! Behold! The star towers of the electric castle. See how it embraces the sky, how insignificant the mere mortal, dwrfed by the majesty of its electric edifice."
          byte 00
FT_LEVEL6 text 'At last you enter the Electric Castle. Here in this vast hall where even shadows fear the light you must confront your past. If you have killed beware the gathering of spirits for here the disembodied astral world becomes flesh once more.'
          byte 00
FT_LEVEL7 text 'You craved the answer but can you bear the truth? The futures doored ingress! What lies beyond? Guide your choice with collective wisdom for one gate severs all connections. One step away from the dreamworld of everlasting ebony you call oblivion.'
          byte 00
FT_END1 text 'I am of the stars. I am called forever. It is cold beyond your sun where we come from. We peopled your planet. But the final experiment has failed. The earth has died. Your world is at rest. But I offer you this. A final solution. A chance to survive.'
          byte 00
FT_END2 text 'We can save your ill fated race who are lost upon the ocean of space. Through their eyes we will see. With their hands we will create. In their world we will be free. With our minds we will shape their fate. Make us whole migrator soul!'
          byte 00
FT_END3 text 'THE FATE OF THE FINAL EXPERIMENT IS NOW IN YOUR HANDS'
        byte 00
FT_GAMEOVER text 'The experiment is over. I grow weary. So tired. Let the dream of confusion lead you into the virgin light. Be all seeing, be brave. Begone!'
            byte 00