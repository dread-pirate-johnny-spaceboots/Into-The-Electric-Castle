defm WaitForRaster
@RasterLoop
        lda /1
        cmp RASTER_LINE
        bne @RasterLoop
endm

defm EnableSprites
        lda /1
        sta SPRITE_ENABLED
        
endm

defm EnableSprite
        lda SPRITE_ENABLED
        ora /1
        sta SPRITE_ENABLED
endm

defm DisableSprite
        lda SPRITE_ENABLED
        and /1
        sta SPRITE_ENABLED
endm

defm PointToSpriteData
        lda /1
        sta /2
endm

defm DrawScreen
        ldx #0
@Block1
        lda /1,x
        tay
        sta SCREEN_BLOCK1,x
        inx
        cpx #255
        bne @Block1
        ldx #0
@Block2
        lda /2,x
        tay
        sta SCREEN_BLOCK2,x
        inx
        cpx #255
        bne @Block2
        ldx #0
@Block3
        lda /3,x
        tay
        sta SCREEN_BLOCK3,x
        inx
        cpx #255
        bne @Block3
        ldx #0
@Block4
        lda /4,x
        tay
        sta SCREEN_BLOCK4,x
        inx
        cpx #255
        bne @Block4
        ldx #0
        rts
endm

defm PrintChar
        lda /1
        jsr CharOut
        rts
endm

defm PrintStr
        ldx #0
        ldy #0
@loop
        lda #255
        cmp RASTER_LINE
        bne @loop
        lda /1,x
        sta $0400,x+/3
        inx
        cpx /2
        bne @loop
endm

defm PlaySound
        lda /1
        sta SID_VOLUME
        lda /2
        sta SID_VOICE1_LO_FREQ
        lda /3
        sta SID_VOICE1_HI_FREQ
        lda /4
        sta SID_ATTACK_DECAY
        lda /5
        sta SID_SUSTAIN
        lda #0
        sta SID_VOICE1_CONTROL
        lda /6
        sta SID_VOICE1_CONTROL
endm

defm StoreLevel1Tiles
        ;sta $0527
        ;sta $04db
        ;sta $052f
        ;sta $05f9
        ;sta $0645
        ;sta $05f1
        ;sta $063d
endm

; Parameter must be xxx00000
defm SetCharacterSet 
        lda CHARSET_LOOKUP
        and #%11111000
        ora /1
        sta CHARSET_LOOKUP    
endm

defm DisableMultiColorMode
        lda SCREEN_CONTROL      
        and #$ef               
        sta SCREEN_CONTROL
endm

defm EnableMultiColorMode
        lda SCREEN_CONTROL
        ora #$10
        sta SCREEN_CONTROL
endm

defm SetTextColor
        lda /1
        sta TEXT_COLOUR
endm

defm SetBackgroundColor
        lda /1
        sta BG_COLOUR
endm

defm SetBackgroundColor1
        lda /1
        sta BG_COLOUR1
endm

defm SetBackgroundColor2
        lda /1
        sta BG_COLOUR2
endm

defm SetBackgroundColor3
        lda /1
        sta BG_COLOUR3
endm

defm SetBackgroundColors
        lda /1
        sta BG_COLOUR
        lda /2
        sta BG_COLOUR1
        lda /3
        sta BG_COLOUR2
        lda /4
        sta BG_COLOUR3
endm

;InitCharacterSet
;        lda CHARSET_LOOKUP
;        ora #$r
;        sta CHARSET_LOOKUP
;        lda SCREEN_CONTROL
;        ora #%00010000
;        sta SCREEN_CONTROL
;        lda COLOUR_LIGHT_BLUE
;        sta BG_COLOUR1
;        lda COLOUR_WHITE
;        sta BG_COLOUR2
;        lda COLOUR_RED
;        sta BG_COLOUR3
;        rts

