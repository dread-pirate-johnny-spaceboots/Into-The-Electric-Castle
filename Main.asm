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
        stx PLAYER_DYING_COUNTER
        ldx COLOUR_BLACK
        stx BG_COLOUR
        jsr ClearScreen
        jsr DrawTitle
        ;jsr InitSprites
        jsr InitCharacterSet
        jsr InitPlayerState
TitleLoop
        jsr ReadJoystick
        lda JOYSTICK_INPUT
        and PLAYER_ACTION
        bne InitGame
        jmp TitleLoop
InitGame
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
        jmp GameLoop
        rts
@HandleDying
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
        beq @GotoTitle
@Respawn
        ldx #$50
        stx PLAYER_X
        ldx #$64
        stx PLAYER_Y
        ldx #0
        stx PLAYER_DYING_COUNTER
        jmp GameLoop
@GotoTitle
        EnableSprites #%00000000
        jsr ClearScreen
        jsr DrawTitle
        ldx #5
        stx PLAYER_LIVES
        ldx #0
        stx PLAYER_DYING_COUNTER
        jmp TitleLoop
@Exit
        rts
incasm "Subroutines.asm"