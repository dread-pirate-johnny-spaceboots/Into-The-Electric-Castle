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

*=TITLE_BLOCK1
incbin "Title.bin"

*=LEVEL1_BLOCK1
incbin "Level1.bin"

incasm "Macros.asm"
incasm "Data.asm"

*=$0820
        ldx #00
        stx BORDER_COLOUR
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
        jsr UpdatePlayerAnimationFrame
        jsr UpdatePlayerSprite
        jsr MovePlayer
        jsr UpdatePlayerSpritePosition    
        jsr CheckForWallCollision
        jsr UpdatePlayerBulletPosition
        jsr HandleBulletExplosion
        lda PLAYER_LIVES
        ora #48
        sta PLAYER_LIVES_POSITION
        lda PLAYER_MOVED_THIS_FRAME
        cmp #$1
        bne @HandleAction
        jsr CheckForAction ; Handles moving the bullet in cases where no action was processes. TODO: Rename
        jmp GameLoop
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
@CheckLives
        ldx PLAYER_LIVES
        cpx #0
        beq @GameOver
@Respawn
        ldx #0
        stx SPRITE_OVERFLOW
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
        PrintStr FT_GAMEOVER,#$8B
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
        PrintStr FT_LEVEL1,#$fa
        ldx PLAYER_LIVES
        jmp TitleLoop
@Exit
        rts

incasm "Subroutines.asm"

; Flavour Text
FT_LEVEL1 text 'How insignificant the mere mortal who is dwarfed by the majesty of this electric edifice. As you are now you may meander here forever. Free your mind from anger and aggression. Resist its treacherous allure as you succumb to its antagonistic notions.'
          byte 00
FT_LEVEL2 text 'There is danger ahead, but do not be afraid. For I am with you, as water, as air, as breath itself in this place of no time and no space. Be resolute. There are trials ahead... and rewards for those who strive! The Surreal Search endures...'
          byte 00
FT_LEVEL2P2 text 'You have a task! In order to release yourself from this web of wisdom, this knotted maze of delerium you must enter the nuclear portals of the electric castle!'
          byte 00
FT_LEVEL2P3 text 'Look around, but linger not. Where I lead you will follow. Ignite my anger with your delay and punishment will come your way.'
          byte 00
FT_LEVEL3 text 'It is time to reflect upon your ego self. Nowhere to hide when the walls echo the you that we all see. It is from these wind torn ramparts that we survey a thousand futures. Breath deep this intoxicating aroma of endless entwined emotions.'
          byte 00
FT_LEVEL4 text 'At last you enter the nuclear portals of Psychogenesis. Here in this vast hall where even shadows fear the light you must confront your past. If you have killed beware the gathering of spirits for here the disembodied astral world becomes flesh once more.'
          byte 00
FT_LEVEL5 text 'You craved the answer but can you bear the truth? The futures doored ingress! What lies beyond? Guide your choice with collective wisdom for one gate severs all connections. One step away from the dreamworld of everlasting ebony. You call it oblivion.'
          byte 00
FT_END1 text 'I am of the stars. I am called forever. It is cold beyond your sun where we come from. We peopled your planet. But the final experiment has failed. The earth has died. Your world is at rest. But I offer you this. A final solution. A chance to survive.'
          byte 00
FT_END2 text 'We can save your ill fated race who are lost in the ocean of space. Through their eyes we will see. With their hands we will create. In their world we will be free. With our minds we will shape their fate. Make us whole migrator soul!'
          byte 00
FT_END3 text 'THE FATE OF THE FINAL EXPERIMENT IS NOW IN YOUR HANDS'
        byte 00
FT_GAMEOVER text 'The experiment is over. I grow weary. So tired. Let the dream of confusion lead you into the virgin light. Be all seeing, be brave. Begone!'
            byte 00