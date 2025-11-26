;
; traffic_light.asm
;
; Created : 11/25/2025 10:02:00 AM
; Authors : Kailas Ugenskas, 
; Desc    : Traffic light control project. implementation of Arduino code that fully controls the traffic signals and crosswalk indicators

; declare constants and global variables
; ------------------------------------------------------------
              ;   us  * XTAL / scaler - 1
.equ DELAY_MS = 100000 * (16 / 256.0) - 1

; pins for the north-south traffic lights
.equ NS_GREEN = PB2           ; green led for ns
.equ NS_YELLOW = PB3          ; yellow led for ns
.equ NS_RED = PB4             ; red led for ns
.equ NS_CROSS = PB1           ; white led for ns crosswalk
.equ NS_DONT_CROSS = PB0      ; red led for ns crosswalk

; Pins for the east-west traffic lights
.equ EW_GREEN = PC3           ; green led for ew
.equ EW_YELLOW = PC2          ; yellow led for ew
.equ EW_RED = PC1             ; red led for ew
.equ EW_CROSS = PC4           ; white led for ew crosswalk
.equ EW_DONT_CROSS = PC5      ; red led for ew crosswalk

; Buttons for the crosswalk
.equ EW_BUTTON = PD2
.equ NS_BUTTON = PD3

.def walkRequested_EW = r21
.def walkRequested_NS = r22

.equ timerCounter = 0x0100

; Vector Table
; ------------------------------------------------------------
.org 0x0000                             ; reset
          jmp       main
.org INT0addr                           ; External Interrupt Request 0 (Port-D Pin-2)
          jmp       btn_ew_isr
.org INT1addr                           ; External Interrupt Request 1 (Port-D Pin-3)
          jmp       btn_ns_isr
.org OC1Aaddr                           ; Timer/Counter1 Compare Match A
          jmp       timer1_isr           
.org INT_VECTORS_SIZE                   ; end vector table

; one-time configuration
; ------------------------------------------------------------
main:
          ; initialize GPIO for NS setup
          sbi       DDRB, NS_GREEN                ; LED output(1) mode
          sbi       DDRB, NS_YELLOW               ; LED output(1) mode
          sbi       DDRB, NS_RED                  ; LED output(1) mode
          sbi       DDRB, NS_CROSS                ; LED output(1) mode
          sbi       DDRB, NS_DONT_CROSS           ; LED output(1) mode


          ; initialize GPIO for EW setup
          sbi       DDRC, EW_GREEN                ; LED output(1) mode
          sbi       DDRC, EW_YELLOW               ; LED output(1) mode
          sbi       DDRC, EW_RED                  ; LED output(1) mode
          sbi       DDRC, EW_CROSS                ; LED output(1) mode
          sbi       DDRC, EW_DONT_CROSS           ; LED output(1) mode

          ; setup ew cross request button
          cbi       DDRD, EW_BUTTON               ; input(0) mode
          sbi       PORTD, EW_BUTTON              ; pull-up

          sbi       EIMSK,INT0                    ; Extern Interrupt 0 on pin D2
          ldi       r16,(0b011 << ISC00)
          sts       EICRA, r16                    ; rising edge trigger

          ; setup ns cross request button
          cbi       DDRD, NS_BUTTON               ; input(0) mode
          sbi       PORTD, NS_BUTTON              ; pull-up

          sbi       EIMSK,INT1                    ; Extern Interrupt 1 on pin D3
          ldi       r16,(0b010 << ISC10)
          lds       r4, EICRA                     ; read prior state
          or        r16, r4                       ; update with prior
          sts       EICRA, r16                    ; rising edge trigger

          ; initialize timer counter
          ldi       r16, 0              ; start counter
          sts       timerCounter, r16

          sei                           ; turn global interrupts on

; application main loop
; ------------------------------------------------------------
main_loop:

end_main:
          rjmp main_loop

; Traffic led light control
set_ns_green:
          sbi       PORTB, NS_GREEN               ; sets green led on
          cbi       PORTB, NS_YELLOW              ; sets yellow led off
          cbi       PORTB, NS_RED                 ; sets red led off
set_ns_yellow:
          cbi       PORTB, NS_GREEN               ; sets green led off
          sbi       PORTB, NS_YELLOW              ; sets yellow led on
          cbi       PORTB, NS_RED                 ; sets red led off
set_ns_red:
          cbi       PORTB, NS_GREEN               ; sets green led off
          cbi       PORTB, NS_YELLOW              ; sets yellow led off
          sbi       PORTB, NS_RED                 ; sets red led on
set_ew_green:
          sbi       PORTC, EW_GREEN               ; sets green led on
          cbi       PORTC, EW_YELLOW              ; sets yellow led off
          cbi       PORTC, EW_RED                 ; sets red led off
set_ew_yellow:
          cbi       PORTC, EW_GREEN               ; sets green led off
          sbi       PORTC, EW_YELLOW              ; sets yellow led on
          cbi       PORTC, EW_RED                 ; sets red led off
set_ew_red:
          cbi       PORTC, EW_GREEN               ; sets green led off
          cbi       PORTC, EW_YELLOW              ; sets yellow led off
          sbi       PORTC, EW_RED                 ; sets red led on


; ------------------------------------------------------------
delay:
          ; Load TCNT1H:TCNT1L with initial count
          clr       r20
          sts       TCNT1H, r20
          sts       TCNT1L, r20

          ; Load OCR1AH:OCR1AL with stop count
          ldi       r20, high(DELAY_MS)
          sts       OCR1AH, r20
          ldi       r20, low(DELAY_MS)
          sts       OCR1AL, r20

          ; Load TCCR1A & TCCR1B
          clr       r20
          sts       TCCR1A, r20                   ; CTC mode
          ldi       r20, (1 << WGM12) | (1 << CS12)
          sts       TCCR1B, r20                   ; Clock Prescaler clk/256 – setting the clock starts the timer

          ldi       r20, (1 << OCIE1A)
          sts       TIMSK1, r20

          ret                           ; delay

; hande ew button press
; ------------------------------------------------------------
btn_ew_isr:
          ldi       walkRequested_EW, 1           ; ew crosswalk request = true

          reti                          ; btn_ew_isr

; hande ns button press
; ------------------------------------------------------------
btn_ns_isr:
          ldi       walkRequested_NS, 1 ; ns crosswalk request = true

          reti                          ; btn_ns_isr

timer1_isr:
          ldi       tmFlag, 1           ; 

          ; Load TCNT1H:TCNT1L with initial count
          clr       r20
          sts       TCNT1H, r20
          sts       TCNT1L, r20

          reti