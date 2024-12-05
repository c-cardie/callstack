;Author: Claire Cardie

;main()
;call 1
;store 0x42AA4000 (85.125) in addresses $0200-0203
LDA #$00
STA $0200
LDA #$40
STA $0201
LDA #$AA
STA $0202
LDA #$42
STA $0203

;Put floating point address onto stack
;02 on $01FF and 00 on $01FE
LDA #$02
PHA
LDA #$00
PHA

;return value placeholder
PHA

;offset for address in zero-page
LDY #$02

JSR getExponent

;did RTS
;store A in address $0210
;A holds 0x06
STA $0210

;clear stack pointer for next call
PLA
PLA
PLA

;call 2
;store 0x41280000 (8.50) in addresses $0204-$0207
LDA #$00
STA $0204
LDA #$00
STA $0205
LDA #$28
STA $0206
LDA #$41
STA $0207

;Put floating point address onto stack
;02 on $01FF and 04 on $01FE
LDA #$02
PHA
LDA #$04
PHA

;return value placeholder
PHA

;offset for address in zero-page
LDY #$02

JSR getExponent

;did RTS
;store A in address $0211
;A holds 0x03
STA $0211

;clear stack pointer for next call
PLA
PLA
PLA

;call 3
;store 0x00000000 (0.0) in addresses $0208-020B
LDA #$00
STA $0208
LDA #$00
STA $0209
LDA #$00
STA $020A
LDA #$00
STA $020B

;Put floating point address onto stack
;02 on $01FF and 08 on $01FE
LDA #$02
PHA
LDA #$08
PHA

;return value placeholder
PHA

;offset for address in zero-page
LDY #$02

JSR getExponent

;did RTS
;store A in address $0212
;A holds 0x00
STA $0212

;clear stack
PLA
PLA
PLA

;getExponent()
getExponent:
	;put address $0200 (1st call), $0204 (2nd call), $0208 (3rd call) into an accessible spot
	TSX
	LDA $0104, X
	STA $00  
	LDA $0105, X
	STA $01
	
	LDA ($00), Y ;load the floating point number's third byte
	ASL ;sets carry bit for next operation
	INY
	LDA ($00), Y ;load the floating point number's fourth byte
	ROL

	;don't subtract 127 from A when A = 00 or A = FF
	CMP #$00
	BEQ return

	CMP #$FF
	BEQ return

	SEC ;set carry bit to 1
	SBC #$7F

return:
		STA $0103, X ;put real return value onto the stack
		LDA $0103, X ;load the A register with that value from the stack

RTS







