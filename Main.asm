; 10 SYS (2080)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $30, $38, $30, $29, $00, $00, $00

incasm "MemoryMap.asm"

*=SPRITE0_DATA
incbin "PlayerSprites.bin" 

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
        lda PLAYER_DYING_COUNTER
        cmp #0
        bne @HandleDying
        jsr ReadJoystick
        jsr UpdatePlayerAnimationFrame
        jsr MovePlayer
        jsr UpdatePlayerSpritePosition
        jsr UpdatePlayerSprite     
        jsr CheckForWallCollision
        lda PLAYER_LIVES
        ora #48
        sta PLAYER_LIVES_POSITION
        jmp GameLoop
        rts
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
        ldx #$50
        stx PLAYER_X
        ldx #$64
        stx PLAYER_Y
        ldx #0
        stx PLAYER_DYING_COUNTER
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
        PrintStr FT_LEVEL1,#$f2
        jmp TitleLoop
@Exit
        rts

incasm "Subroutines.asm"

; Flavour Text
FT_LEVEL1 text 'How insignificant the mere mortal to be dwarfed by the majesty of this electric edifice. As you are now you may meander here forever. Free your mind from anger and aggression. Resist its treacherous allure and succomb to antagonistic notions.'
          byte 00
FT_LEVEL2 text 'There is danger ahead, but do not be afraid. For I am with you, as water, as air, as breath itself. Be resolute. There are trials ahead... and rewards for those who strive.'
          byte 00
FT_LEVEL9 text 'At last you enter the nuclear portals of psychogenesis. Here in this vast hall where even shadows fear the light you must confront your past. If you have killed beware the gathering of spirits for here the disembodied astral world becomes flesh once more.'
          byte 00
FT_GAMEOVER text 'The experiment is over. I grow weary. So tired. Let the dream of confusion lead you into the virgin light. Be all-seeing, be brave. Begone!'
            byte 00