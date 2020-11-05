; 10 SYS (2080)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $30, $38, $30, $29, $00, $00, $00

incasm "MemoryMap.asm"

*=SPRITE0_DATA
incbin "PlayerSprites.bin" 

*=CHARSET
incbin "LevelGeo.bin"

*=LEVEL1_BLOCK1
incbin "Level1.bin"

incasm "Macros.asm"
incasm "Data.asm"

*=$0820
        ldx #00
        stx BORDER_COLOUR
        ldx COLOUR_BLACK
        stx BG_COLOUR
        jsr ClearScreen
        jsr DrawLevel
        jsr InitSprites
        jsr InitCharacterSet
GameLoop
        WaitForRaster #255
        jsr ReadJoystick
        jsr UpdatePlayerAnimationFrame
        jsr MovePlayer
        jsr UpdatePlayerSpritePosition
        jsr UpdatePlayerSprite     
        jsr PerformBackgroundCollisionDetection
        jmp GameLoop
        rts

incasm "Subroutines.asm"