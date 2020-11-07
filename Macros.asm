defm WaitForRaster
RasterLoop
        lda /1
        cmp RASTER_LINE
        bne RasterLoop
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
        eor /1
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
        sta $0400,x
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