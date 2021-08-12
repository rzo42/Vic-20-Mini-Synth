;      " VIZNUTS WAVEFORMS "
;       By               :      Ryan Liston
;       Original code by :      "Viznut"
;       Description      :      pulse wave form generator
;       Target           :      Commodore Vic-20
;----------------------------------------------------
;
;-initalize a,x,y befor calling
;-a=wave form
;-x=initial frequency
;-y=channel

;controls
start_address = $298          ;start address
temp_1        = $fe           ;(temp storage for the a registor(shift registor))
temp_2        = $ff           ;(temp storage for the y registor (channel))


;-------------------------------------------------------------------------------

*           = start_address

;-------------------------------------------------------------------------------
pwp         sei
            STX   init_freq   ;3/4    alters the value on the
                              ;init_freq=$87          ;       initial frequency in
                              ;       line  xxxx
            sty   ch_0        ;3/4    alters memory at ch_0
                              ;ch0=$0c
            sty   ch_1        ;3/4    an ch_1 to set voice channel
                              ;ch1=$0c
            ldx   fq_mask-$a,y;3/4    loads frequency mask for voice
                              ;x=$fb(%11111011)
            sta   temp_1      ;2/3    stores the shift register in
                              ;temp_1=$fb(%11111011)  ;       temp_1
            ora   #$7f        ;2/2    ors a with #$7f(%01111111)
                              ;%11111011 or %01111111 = %11111111($ff)
                              ;a=%11111111($ff)
            axs   $900c       ;3/4     ands a with bit mask stores at $900c
ch_0        = *-2             ;%11111111 and %11111011 = %11111011
                              ;$900c=%11111011($fb)
            sty   temp_2      ;2/3    stores y(channel) at temp_2
                              ;temp_2=$0c
            ldy   #$07        ;2/2    loads y with 7
                              ;y = 7
io          LDA   #$7f        ;2/2    loads a with $7f
                              ;a=$7f
            aso   temp_1      ;2/5    a=(temp_1<<1)or $7f
                              ;pass 1: (y=7)  (%11111011<<1) = %11110110
                              ;%11110110 or %01111111 = %11111111($ff)
                              ;a = %11111111($ff)
                              ;pass 2; (y=6)  (%11110110<<1) = %11101100
                              ;%11101100 or %01111111 = %11111111($ff)
                              ;a = %11111111($ff)
                              ;pass 3; (y=5)  (%11101100<<1) = %11011000
                              ;%11011000 or %01111111 = %11111111($ff)
                              ;a = %11111111($ff)
                              ;pass 4; (y=4)  (%11011000<<1) = %10110000
                              ;%10110000 or %01111111 = %11111111($ff)
                              ;a = %11111111($ff)
                              ;pass 5; (y=3)  (%10110000<<1) = %01100000
                              ;%01100000 or %01111111 = %01111111($ff)
                              ;a = %01111111($7f)
                              ;pass 6; (y=2)  (%01100000<<1) = %11000000
                              ;%11000000 or %01111111 = %11111111($ff)
                              ;a = %01111111($ff)
                              ;pass 7; (y=1)  (%11000000<<1) = %10000000
                              ;%10000000 or %01111111 = %11111111($ff)
                              ;a = %11111111($ff)
            axs   $900c       ;3/4    ands a with bit mask stores at $900c
ch_1        = *-2
                              ;pass 1: (y=7)  %11111111 and %11111011 = %11111011
                              ;$900c=%11111011($fb)
                              ;pass 2: (y=6)  %11111111 and %11111011 = %11111011
                              ;$900c=%11111011($fb)
                              ;pass 3: (y=5)  %11111111 and %11111011 = %11111011
                              ;$900c=%11111011($fb)
                              ;pass 4: (y=4)  %11111111 and %11111011 = %11111011
                              ;$900c=%11111011($fb)
                              ;pass 5: (y=3)  %01111111 and %11111h11 = %01111011
                              ;$900c=%01111011($fb)
                              ;pass 6: (y=2)  %11111111 and %11111011 = %11111011
                              ;$900c=%11111011($fb)
                              ;pass 7: (y=1)  %11111111 and %11111011 = %11111011
                              ;$900c=%11111011($fb)
            dey               ;1/2    y=y-1
                              ;pass 1:(y=7)   y=6
                              ;pass 2:(y=6)   y=5
                              ;pass 3:(y=5)   y=4
                              ;pass 4:(y=4)   y=3
                              ;pass 5:(y=3)   y=2
                              ;pass 6:(y=2)   y=1
                              ;pass 7:(y=1)   y=0
            bne   io          ;2/3    if not y=0 then branch to i0
                              ;       else continue
                              ;pass 1;(y=6)   branch to io
                              ;pass 2;(y=5)   branch to io
                              ;pass 3;(y=4)   branch to io
                              ;pass 4;(y=3)   branch to io
                              ;pass 5;(y=2)   branch to io
                              ;pass 6;(y=1)   branch to io
                              ;pass 7;(y=0)   continue
            lda   #128        ;2/2    loads a with the initial frequency
                              ;a=$87
init_freq   = *-1
            nop               ;1/2    burns 2 cycles
                              ; no opperation
            ldy   temp_2      ;2/3    loads y with channel index stored
                              ;y=$0c                          at temp_2
no_set      STA   $9000,y     ;3/5    stores initial freaquency to $9000+y
                              ;$900c=$87
            rts               ; exit routine
fq_mask     = *
v_0a        byte  $fd     ;low voice bit mask %11111101
v_0b        byte  $fe     ;mid voice bit mask %11111110
v_0c        byte  $fb     ;hi voice bit mask %11111011
            


            


