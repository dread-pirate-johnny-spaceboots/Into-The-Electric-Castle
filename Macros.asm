defm WaitForRaster
RasterLoop
        lda /1
        cmp RASTER_LINE
        bne RasterLoop
endm