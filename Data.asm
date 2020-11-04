; Joystick
JOYSTICK_INPUT = $02
JOYSTICK_MASK_RIGHT = %00001000
JOYSTICK_MASK_LEFT  = %00000100 
JOYSTICK_MASK_UP    = %00000001 
JOYSTICK_MASK_DOWN  = %00000010
JOYSTICK_MASK_BTN   = %00010000  

; Player
PLAYER_SPRITE_INDEX byte $80
PLAYER_X byte $15
PLAYER_Y byte $32
PLAYER_ACTION = #1
PLAYER_MOVED_UP = #2
PLAYER_MOVED_RIGHT = #4
PLAYER_MOVED_DOWN = #8
PLAYER_MOVED_LEFT = #16
PLAYER_IDLE byte $80
PLAYER_RIGHT byte $81
PLAYER_LEFT byte $83
PLAYER_UP byte $85
PLAYER_DOWN byte $87

; Colours
COLOUR_BLACK = #0
COLOUR_WHITE = #1
COLOUR_RED = #2
COLOUR_CYAN = #3
COLOUR_LIGHT_BLUE = #14