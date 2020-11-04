; 10 SYS (2064)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $30, $36, $34, $29, $00, $00, $00

incasm "MemoryMap.asm"

incasm "Macros.asm"
incasm "Data.asm"

*=$0810
        ldx #00
        stx BORDER_COLOUR
        stx BG_COLOUR
        jsr ClearScreen
GameLoop
        WaitForRaster #255
        jsr ReadJoystick
        jmp GameLoop
        rts

incasm "Subroutines.asm"