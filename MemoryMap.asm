; Screen
TEXT_COLOUR = $0286
BORDER_COLOUR = $D020
BG_COLOUR = $D021
BG_COLOUR1 = $D022
BG_COLOUR2 = $D023
BG_COLOUR3 = $D024
RASTER_LINE = $D012
SCREEN_CONTROL = $D016
SCREEN_BLOCK1 = $0400
SCREEN_BLOCK2 = $04FF
SCREEN_BLOCK3 = $05FE
SCREEN_BLOCK4 = $06FD
PLAYER_LIVES_POSITION = $07c9

; Action selector box corners
; Box 1 - Shoot
ACTION_SELECTOR_POS1 = $0795
ACTION_SELECTOR_POS2 = $0797
ACTION_SELECTOR_POS3 = $07E5
ACTION_SELECTOR_POS4 = $07E7
; Box 2 - Talk
ACTION_SELECTOR_POS5 = $0745
ACTION_SELECTOR_POS6 = $0747
ACTION_SELECTOR_POS7 = $0795
ACTION_SELECTOR_POS8 = $0797
; Box 3 - Use
ACTION_SELECTOR_POS9 = $06F5
ACTION_SELECTOR_POS10 = $06F7
ACTION_SELECTOR_POS11 = $0745
ACTION_SELECTOR_POS12 = $0747

; Builtin Subroutines
CharOut = $FFD2
StrOut = $AB1E

; Joystick
JOYSTICK_PORT1 = $DC01
JOYSTICK_PORT2 = $DC00

; Sprites
SPRITE_ENABLED = $D015;
SPRITE_OVERFLOW = $D010
SPRITE_BG_COLLISION = $D01F

SPRITE0_X = $D000
SPRITE0_Y = $D001
SPRITE0_COLOUR = $D027
SPRITE0_DATA = $2000
SPRITE0_POINTER = $07F8

SPRITE1_X = $D002
SPRITE1_Y = $D003
SPRITE1_COLOUR = $D028
SPRITE1_DATA = $2600
SPRITE1_POINTER = $07F9

; Character set
CHARSET=$3800
CHARSET_LOOKUP = $D018

; Title screen
TITLE_BLOCK1 = $5400
TITLE_BLOCK2 = $54FF
TITLE_BLOCK3 = $55FE
TITLE_BLOCK4 = $56FD

; Levels
LEVEL1_BLOCK1 = $5000
LEVEL1_BLOCK2 = $50FF
LEVEL1_BLOCK3 = $51FE
LEVEL1_BLOCK4 = $52FD

; Player
PLAYER_DYING_COUNTER = $7000
PLAYER_LIVES = $7001
PLAYER_MOVED_THIS_FRAME = $7002
PLAYER_CURRENT_ACTION = $7003

; Sound
SID_VOICE1_LO_FREQ = $D400
SID_VOICE1_HI_FREQ = $D401
SID_VOICE1_CONTROL = $D404
SID_ATTACK_DECAY   = $D405
SID_SUSTAIN        = $D406
SID_PULSE_LO_WIDTH = $D402
SID_PULSE_HI_WIDTH = $D403
SID_VOLUME         = $D418
