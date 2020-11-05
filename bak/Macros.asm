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

defm PointToSpriteData
        lda /1
        sta /2
endm