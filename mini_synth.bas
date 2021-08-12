!-******************************************************************************
!-*                            COMMODORE  VIC-20                               *
!-*                               MINI SYNTH                                   *
!-*                               RYAN LISTON                                  *
!-*                              August/4/2001                                 *
!-******************************************************************************

!- TITLE SCREEN

!- bg=36879 (bacground color)
!- 649 keyboard buffer size
!- 650 key repeat

!- sets screen color to black, border to green and reverses the screen color
!- sets the keyboard buffer size to 1
!- turns key repeat on for all keys
100 bg=36879:poke649,1:poke650,128:pl=65520


!-------------------------------------------------------------------------------
!-
!- VARIABLES,STRINGS AND ARRAYS
!-

!- GENERAL

!- aa=780 (accumulator)
!- xx=781 (x.registor)
!- yy=782 (y.registor)
!- m = menu variable
!- x = general use
!- vn = "viznut" wave form generator jump point @664
!-              (aa=wave form,xx=initial frequency ,yy=voice)
!- ck = current key @ 197
!- kg = value in ck indexed by ni()
!- sk = shift key pattern @ 653

200 aa=780:xx=781:yy=782:m=0:x=0:vn=664:ck=197:kg=128:sk=653

!- ADSR VARIABLES
!- g = gain     (0 to 15)
!- a = attack  (0 to 255)
!- d = decay   (0 to 255)
!- s = sustain (0 to 255(255 = hold)?)
!- r = release (0-255?)
!- 0.1 is added to a,d,s&r to avoid deviding by 0

300 g=7:a=0.1:d=15.1:s=120.1:r=60.1

!- OSCILATOR VARIABLES
!- v(0-3) = 36874-36877 (channel)
!- v(4) = 36878(volume)
!- w(0) = wave_form (oscillator:0-2=(wave:0-15))
!- p(0) = pitch_offset (oscillator:0-3=(pitch:0-12))
!- o(0) = octave (oscillator:0-3=(octave:0-2(0=off)))
!- wv(0-15) = wave form
!- ni(0-65) = note index
!- n=(ni) (note_table)

!- sets up arrays for voice controls
400fort=.to3:v(t)=36874+t:w(t)=t:p(t)=0:o(t)=2:pokev(t),126:next:v(4)=36878
500o(3)=0

!- sets up array holding wave forms
600 dimwv(16):fort=.to15:readx:wv(t)=x:next

!- sets up array holding the note table
700 dimn(37):fort=.to37:readx:n(t)=x:next

!- sets up array for note index values
800 dimni(64):fort=0to64:readx:ni(t)=x:next:

!- {note poke value}=n(ni(ck))

!------------------------------------------------------------------------------
!-
!- LOAD VIZWAV
!-

!-sets up Viznuts pulse wave code @ 664
900fort=.to45:readx:pokevn+t,x:next

!-------------------------------------------------------------------------------
!-
!- MAIN MENU
!-

!- set screen to black background with a green border
!- 198,0 clears the keyboard bufer
1000pokebg,8:poke 198,0

!- print the main menu screen
1100print"{clear}{reverse off}{green}  vic-20  mini synth"
1300print"{return}{cyan}    1:oscillator 1"
1400print"{return}    2:oscillator 2"
1500print"{return}    3:oscillator 3"
1600print"{return}    4:oscillator 4"
1700print"{return}    5:adsr"
1800print"{return}    0:play"
1900 PRINT "{return}   {reverse on}{green}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}"
2000 PRINT "{reverse off}   {166}{reverse on}{white}{165}{reverse off}{161}{reverse on}{161}{reverse off}{161}{reverse on}{161}{167}{165}{reverse off}{161}{reverse on}{161}{reverse off}{161}{reverse on}{161}{reverse off}{161}{reverse on}{161}{167}{green}{166}"
2100 PRINT "   {reverse on}{166}{white}{165}{reverse off}{161}{reverse on}{161}{reverse off}{161}{reverse on}{161}{167}{165}{reverse off}{161}{reverse on}{161}{reverse off}{161}{reverse on}{161}{reverse off}{161}{reverse on}{161}{167}{reverse off}{green}{166}"
2200 PRINT "{reverse off}   {166}{reverse on}{white}{165}{reverse off}{161}{reverse on}{161}{reverse off}{161}{reverse on}{161}{167}{165}{reverse off}{161}{reverse on}{161}{reverse off}{161}{reverse on}{161}{reverse off}{161}{reverse on}{161}{167}{green}{166}"
2300 PRINT "   {reverse on}{166}{white}{165}{167}{165}{167}{165}{167}{165}{167}{165}{167}{165}{167}{165}{167}{reverse off}{green}{166}"
2400 PRINT "{reverse off}   {166}{reverse on}{white}{165}{167}{165}{167}{165}{167}{165}{167}{165}{167}{165}{167}{165}{167}{green}{166}"
2500 PRINT "   {101}{101}{101}{101}{101}{101}{101}{101}{101}{101}{101}{101}{101}{101}{101}{101}"
2600print"{return}{reverse off}  ryan liston   2021{home}"

!-MAIN MENU CONTROL
!-gets input and extracts numerical value
!-loop if null
2800getx$:m=val(x$):ifx$=""then2800
!-if "0" then goto play mode
2900ifm=0thenfort=0to3:pokev(t),126:next:goto11000
!-if "0"-"4" then goto oscillator settings
3000ifm<5then5800
!-if "5" then goto adsr settings
3100ifm=5then3400
!-loop if not "0"-"5"
3200goto2800

!-------------------------------------------------------------------------------
!-
!-ADSR SETTINGS
!-
!- g = gain    (0 to 15)
!- a = attack  (0 to 255)
!- d = decay   (0 to 255)
!- s = sustain (0 to 255)
!- r = release (0 to 255)


3400poke198,0:print"{clear}{green}{reverse off}    adsr settings"
3600 print "{cyan}{return}    1:gain   {white}"int(g)
3700 print "{cyan}{return}    2:attack {white}"int(a)
3800 print "{cyan}{return}    3:decay  {white}"int(d)
3900 print "{cyan}{return}    4:sustain{white}"int(s)
4000 print "{cyan}{return}    5:release{white}"int(r)
4100 print "{cyan}{return}    0:return{white}"


!- ADSR SCREEN CONTROLS
!- get input loop if null
4500getx$:ifx$=""goto4500
!- gain
4600ifx$="1"then5701
!- attack
4900ifx$="2"then5706
!- decay
5000ifx$="3"then5711
!- sustain
5200ifx$="4"then5716
!- release
5400ifx$="5"then5721
!-return to main menu
5600ifx$="0"then1000
!-loop if not 0-5
5700goto4500

!-set gain
5701 print"{home}{down*14} gain 1-15":inputx$
5702 x=val(x$)
5703 if(x>0)and(x<16)theng=int(x)
5704 pokexx,2:pokeyy,13:sys(pl):printg"{left}  ";
5705 goto5790

!-set attack 
5706 print"{home}{down*14}attack 0-255":inputx$
5707 x=val(x$)
5708 if(x>-1)and(x<256)thena=int(x)+.1
5709 pokexx,4:pokeyy,13:sys(pl):printint(a)"{left}  ";
5710 goto5790

!-set decay
5711 print"{home}{down*14}decay 0-255":inputx$
5712 x=val(x$)
5713 if(x>-1)and(x<256)thend=int(x)+.1
5714 pokexx,6:pokeyy,13:sys(pl):printint(d)"{left}  ";
5715 goto5790

!-set sustain
5716 print"{home}{down*14}sustain 0-255:255=hold":inputx$
5717 x=val(x$)
5718 if(x>-1)and(x<256)thens=int(x)+.1
5719 pokexx,8:pokeyy,13:sys(pl):printint(s)"{left}  ";
5720 goto5790

!-set release
5721 print"{home}{down*14}release 0-255:255=hold":inputx$
5722 x=val(x$)
5723 if(x>-1)and(x<256)thenr=int(x)+.1
5724 pokexx,10:pokeyy,13:sys(pl):printint(r)"{left}  ";
5725 goto5790

!-clear input
5790print"{home}{down*14}{space*44}";
5791print"{space*59}{home}":goto4500

!-------------------------------------------------------------------------------
!-
!-OSCILLATOR SETTINGS
!-

!-subtract 1 from m for array controls (osc 1=o(0),osc 2=o(1)...)
5800m=m-1


5900poke198,0:print"{clear}{green}{reverse off}oscillator"m+1"{left} settings"
6100 print "{return}{cyan}      1:test solo"
6200 print "{return}      2:test all"
6300 print "{return}      3:pitch      {left*5}{white}"p(m)
6400 print "{return}{cyan}      4:octave     {left*5}{white}"o(m)
6500 if m<3 then print "{return}{cyan}      5:wave       {left*5}{white}"w(m)
6600 print "{return}{cyan}      0:return{white}"


!-oscillator settings contols
!-get input if null then loop
7100getx$:ifx$=""then7100
!-test sound of current voice
7200ifx$="1"then8300
!-test sound of all voices togather
7300ifx$="2"then9800

!-pitch 
7400ifx$="3"then8201
!-octave
7600ifx$="4"then8206
!-return to main menu
7800ifx$="0"then1000
!-if voice 4 (noise channel) then loop
7900ifm=3then7100
!-wave form
8000ifx$="5"then8211
!-loop if not 0-5 or shift+(3-5)
8200goto7100

!-set pitch
8201 print"{home}{down*14}pitch 0-12":inputx$
8202 x=val(x$)
8203 if(x>-1)and(x<13)thenp(m)=int(x)
8204 pokexx,6:pokeyy,14:sys(pl):printp(m)"{left}  ";
8205 goto8235

!-set octave
8206 print"{home}{down*14}octave 0-2:0=voice off":inputx$
8207 x=val(x$)
8208 if(x>-1)and(x<3)theno(m)=int(x)
8209 pokexx,8:pokeyy,14:sys(pl):printo(m)"{left}  ";
8210 goto8235

!-set waveform
8211 print"{home}{down*14}wave 0-15":inputx$
8212 x=val(x$)
8213 if(x>-1)and(x<16)thenw(m)=int(x)
8214 pokexx,10:pokeyy,14:sys(pl):printw(m)"{left}  ";
8215 goto8235

!-clear input
8235print"{home}{down*14}{space*44}";
8236print"{space*59}{home}":goto7100

!-------------------------------------------------------------------------------
!-
!-SOLO TEST
!-

!-(aa=wave form,xx=initial frequency ,yy=voice)
!- wv = wave form (864)

!-if octave=0 (o(m)=0) then the oscillator is off
8300fort=.to3:pokev(t),126:next:ifo(m)=0then8800

!-if osscillator 4 (noise channel (m=3) then ignore wave form and test voice
8400ifm=3thenpokev(m),n(p(m)+(o(m)-1)*12):goto8800

!-set the wave form for voice
!-load the accumulator (aa) with wave form (wv(w(m)))
!-load the y registor (yy) with voice channel (m+10)
!-load the x.registor (xx) with with initial tone (n(p(m)+(o(m)-1)*12))
!-...load x.registor with 126 if octave is 0 (o(m)=0)
!-jump to Viznuts code at 664 to initialize wave form
8500pokeaa,wv(w(m)):pokeyy,m+10:pokexx,126
8600ifo(m)>0thenpokexx,n(p(m)+(o(m)-1)*12)
8700sys(vn)

!-print test screen
8800 print "{clear}{green}{reverse off}    testing  voice"
8900 print "{return*4}{cyan}     oscillator{white}"m+1
9000 print "{return*2}{cyan}     pitch     {white}"p(m)
9100 print "{return*2}{cyan}     octave    {white}"o(m)
9200 print "{return*2}{cyan}     wave form {white}"w(m)
9300 print "{return*2}{cyan}     gain      {white}"g
9400 print "{return*3}{green}  any key to return{home}":


!-(v(4)) on at peak gain level
9500pokev(4),g

!-play test until keypress
9600 waitck,64,64

!- turn voice off, set volume to 0and return to oscillator settings
9700 fort=.to3:pokev(t),126:pokev(4),0:goto5900

!-------------------------------------------------------------------------------
!-
!-TEST ALL
!-

!-set wave forrm for each voice.
!-load the accumulator (aa) with wave form (wv(w(t)))
!-load the y registor (yy) with voice channel (t+10)
!-load the x.registor (xx) with with initial tone (n(p(t)+(o(t)-1)*12))
!-...load x.registor with 126 if octave is 0 (o(t)=0)
9800fort=0to2:pokeaa,wv(w(t)):pokeyy,t+10:pokexx,126:pokev(t),126
9900ifo(t)>0thenpokexx,n(p(t)+(o(t)-1)*12)

!-jump to Viznuts code at 664 to initialize wave forms
!-set and initialize noise channel
!-turn volume on to peak gain level
10000sys(vn):next:pokev(3),126:ifo(3)>0thenpokev(3),n(p(3)+(o(3)-1)*12)

!-print test screen
10100 print "{clear}{green}{reverse off}  testing all voices"
10200 fort=0to3:print "{return}{green} osc"t+1"{cyan}pitch{white}    "p(t);
10300 print "{return}{cyan}       octave   {white}"o(t);
10400 print "{return}{cyan}       wave form{white}"w(t)"{return}";:next
10500 print "{return}{cyan}       gain     {white}"g;
10600 print "{return*3}{green}  any key to  return{home}":

!-turn the volume (v(4)) on at peak gain level
10700pOv(4),g

!-play test until keypress
10800waitck,64,64

!-turn voices off, set volume to 0and return to oscillator settings
10900fort=0to3:pokev(t),126:next:pokev(4),0:goto5900

!-------------------------------------------------------------------------------
!-
!-ADSR
!-


!-set wave form for each voice.
!-load the accumulator (aa) with wave form (wv(w(t)))
!-load the x.registor (xx) with with initial tone (n(p(t)+(o(t)-1)*12))
!-load the y registor (yy) with voice channel (t+10)
!-jump to Viznuts code at 664 to initialize wave forms
11000fort=0to2:pokeaa,wv(w(t)):pokeyy,t+10:pokexx,n(p(t)+o(t)*12):sys(vn):next

!-print play mode screen
11100 pokebg,8:PRINT "{clear}{reverse off}{green} {185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}"
11300 PRINT " {reverse on} osc pitch oct wave "
11400 PRINT " {reverse on} {reverse off} {white}1 {reverse on}{green} {reverse off}    {reverse on}  {reverse off}   {reverse on} {reverse off}    {reverse on} "
11500 PRINT " {reverse on} {reverse off} {white}2 {reverse on}{green} {reverse off}    {reverse on}  {reverse off}   {reverse on} {reverse off}    {reverse on} "
11600 PRINT " {reverse on} {reverse off} {white}3 {reverse on}{green} {reverse off}    {reverse on}  {reverse off}   {reverse on} {reverse off}    {reverse on} "
11700 PRINT " {reverse on} {reverse off} {white}4 {reverse on}{green} {reverse off}    {reverse on}  {reverse off}   {reverse on}      "
11800 PRINT " {reverse on}                  {183} "
11900 PRINT " {reverse on} {183} gain     {reverse off}     {reverse on} {183} "
12000 PRINT " {reverse on} {183} attack   {reverse off}     {reverse on} {183} "
12100 PRINT " {reverse on} {183} decay    {reverse off}     {reverse on} {183} "
12200 PRINT " {reverse on} {183} sustain  {reverse off}     {reverse on} {183} "
12300 PRINT " {reverse on} {183} release  {reverse off}     {reverse on} {183} "
12400 PRINT " {reverse on} {183}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185}{185} "
12500 PRINT " {reverse on} {183}{white}{161} {reverse off} {reverse on} {reverse off} {reverse on} B {reverse off} {reverse on} {reverse off} {reverse on} {reverse off} {reverse on} B {reverse off}{161}{reverse on}{green} "
12600 PRINT " {reverse on} {183}{white}{161} {reverse off}2{reverse on} {reverse off}3{reverse on} B {reverse off}5{reverse on} {reverse off}6{reverse on} {reverse off}7{reverse on} B {reverse off}{161}{reverse on}{green} "
12700 PRINT " {reverse on} {183}{white}{161} {reverse off} {reverse on} {reverse off} {reverse on} B {reverse off} {reverse on} {reverse off} {reverse on} {reverse off} {reverse on} B {reverse off}{161}{reverse on}{green} "
12800 PRINT " {reverse on} {183}{white}{161}qBwBeBrBtByBuBi{reverse off}{161}{reverse on}{green} "
12900 PRINT " {reverse on}{185}{reverse off}{184}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{100}{reverse on}{185}"

13000 PRINT "    {cyan}c d e f g a b c"
13200 PRINT "{yellow}{return}shift:{white}repeat   {yellow}c=:{white}hold{return}{yellow}   ctrl:{white}pitch bend{white}{home}";
13300 pokexx,2:pokeyy,6:sys(pl):printp(0):pokexx,3:pokeyy,6:sys(pl):printp(1)
13400 pokexx,4:pokeyy,6:sys(pl):printp(2):pokexx,5:pokeyy,6:sys(pl):printp(3)
13500 pokexx,2:pokeyy,12:sys(pl):printo(0):pokexx,3:pokeyy,12:sys(pl):printo(1)
13600 pokexx,4:pokeyy,12:sys(pl):printo(2):pokexx,5:pokeyy,12:sys(pl):printo(3)
13700 pokexx,2:pokeyy,16:sys(pl):printw(0):pokexx,3:pokeyy,16:sys(pl):printw(1)
13800 pokexx,4:pokeyy,16:sys(pl):printw(2)
13900 pokexx,7:pokeyy,13:sys(pl):printint(g):pokexx,8:pokeyy,13:sys(pl):printint(a)
14000 pokexx,9:pokeyy,13:sys(pl):printint(d):pokexx,10:pokeyy,13:sys(pl):printint(s)
14100 pokexx,11:pokeyy,13:sys(pl):printint(r)


!-pokexx,peek(xx)+1:sys(pl)
!-5425 pokexx,peek(xx)+1:sys(pl):printint(s):pokexx,peek(xx)+1:sys(pl)
!-5426 printint(d):pokexx,peek(xx)+1:sys(pl):printint(r)

!-STATIC ADSR KEY GET
14200x=0:pokev(4),x
14300kg=ni(peek(ck)):ifpeek(ck)=15then20200
14400ifkg=128then14300


!-ATTACK
14500x=g/a
14600ifo(0)>0thenpokev(0),n(kg+p(0)+((o(0)-1)*12)+(4andpeek(sk))/4)
14700ifo(0)=0thenpokev(0),126
14800ifo(1)>0thenpokev(1),n(kg+p(1)+((o(1)-1)*12)+(4andpeek(sk))/4)
14900ifo(1)=0thenpokev(1),126
15000ifo(2)>0thenpokev(2),n(kg+p(2)+((o(2)-1)*12)+(4andpeek(sk))/4)
15100ifo(2)=0thenpokev(2),126
15200ifo(3)>0thenpokev(3),n(kg+p(3)+((o(3)-1)*12)+(4andpeek(sk))/4)
15300ifo(3)=0thenpokev(3),126
15400pokev(4),x:ifpeek(ck)=64then18900
15500ifkg<>ni(peek(ck))thenx=0:goto14200
15600ifx+g/a>gthenpokev(4),g:goto15800
15700ifx<gthenx=x+g/a:goto14600

!-DECAY
15800x=0

15900ifo(0)>0thenpokev(0),n(kg+p(0)+((o(0)-1)*12)+(4andpeek(sk))/4)
16000ifo(0)=0thenpokev(0),126
16100ifo(1)>0thenpokev(1),n(kg+p(1)+((o(1)-1)*12)+(4andpeek(sk))/4)
16200ifo(1)=0thenpokev(1),126
16300ifo(2)>0thenpokev(2),n(kg+p(2)+((o(2)-1)*12)+(4andpeek(sk))/4)
16400ifo(2)=0thenpokev(2),126
16500ifo(3)>0thenpokev(3),n(kg+p(3)+((o(3)-1)*12)+(4andpeek(sk))/4)
16600ifo(3)=0thenpokev(3),126

16700ifpeek(ck)=64then18900
16800ifkg<>ni(peek(ck))thengoto14200
16900ifx+g/d<0then17100
17000ifx<dthenx=x+1:goto15900

!-SUSTAIN
17100x=g
17200ifo(0)>0thenpokev(0),n(kg+p(0)+((o(0)-1)*12)+(4andpeek(sk))/4)
17300ifo(0)=0thenpokev(0),126
17400ifo(1)>0thenpokev(1),n(kg+p(1)+((o(1)-1)*12)+(4andpeek(sk))/4)
17500ifo(1)=0thenpokev(1),126
17600ifo(2)>0thenpokev(2),n(kg+p(2)+((o(2)-1)*12)+(4andpeek(sk))/4)
17700ifo(2)=0thenpokev(2),126
17800ifo(3)>0thenpokev(3),n(kg+p(3)+((o(3)-1)*12)+(4andpeek(sk))/4)
17900ifo(3)=0thenpokev(3),126

18000pokev(4),x:ifpeek(ck)=64then18900
18100ifkg<>ni(peek(ck))then14200
18200if(peek(sk)and2)=2ors=255then17200
18300ifx-g/s<1then18500
18400x=x-g/s:goto17200
18500x=0:pokev(4),x
18600if(peek(sk)and1)=1then14500

!-!!!TESTING!!!
18700if(kg=ni(peek(ck)))then17200
18800goto14200

!-RELEASE
18900x=peek(v(4))
19000ifo(0)>0thenpokev(0),n(kg+p(0)+((o(0)-1)*12)+(4andpeek(sk))/4)
19100ifo(0)=0thenpokev(0),126
19200ifo(1)>0thenpokev(1),n(kg+p(1)+((o(1)-1)*12)+(4andpeek(sk))/4)
19300ifo(1)=0thenpokev(1),126
19400ifo(2)>0thenpokev(2),n(kg+p(2)+((o(2)-1)*12)+(4andpeek(sk))/4)
19500ifo(2)=0thenpokev(2),126
19600ifo(3)>0thenpokev(3),n(kg+p(3)+((o(3)-1)*12)+(4andpeek(sk))/4)
19700ifo(3)=0thenpokev(3),126

19800pokev(4),x:ifpeek(ck)<64orx-g/r<0thengoto14200
19900 if(peek(sk)and2)=2orr=255then19000
20000ifx>0thenx=x-g/r:goto19000
20100goto14200

!-RETURN TO EDITOR
20200poke v(4),0:fort=.to3:pokev{t},126:next:goto1000

!-------------------------------------------------------------------------------
!-
!-DATA TABLES
!-

!-wave table
20300data0,2,4,6,8,10,12,14,18,20,22,24,26,36,42,44


!-note table
!-       c   c#  d   d#  e   f   f#  g   g#  a   a#  b
!-octave 1
20400data255,134,141,147,153,159,164,170,174,179,183,187
!-octave 2
20500data191,195,198,201,204,207,210,212,215,217,219,221
!-octave 3
20600data223,225,226,228,230,231,232,235,236,237,238,239
!-octave 4
20700data240,241

!-KEY INPUT
!- reference table
!- keypressed   note    index   value at 197
!- 'Q'          C       0       48
!- '2'          C#      1       56
!- 'W'          D       2       9
!- '3'          D#      3       1
!- 'E'          E       4       49
!- 'R'          F       5       10
!- '5'          F#      6       2
!- 'T'          G       7       50
!- '6'          G#      8       58
!- 'Y'          A       9       11
!- '7'          A#      10      3
!- 'U'          B       11      51
!- 'I'          C       12      12

!-key index table
20800data128,3,6,10,128,128,128,128
20900data128,2,5,9,12,128,128,128
21000data128,128,128,128,128,128,128,128
21100data128,128,128,128,128,128,128,128
21200data128,128,128,128,128,128,128,128
21300data128,128,128,128,128,128,128,128
21400data0,4,7,11,128,128,128,128
21500data1,128,8,128,128,128,128,128,128

!-------------------------------------------------------------------------------
!-
!-VIZWAV ROUTINE @664
!-

21600data120,142,187,2,140,170,2,140
21700data181,2,190,185,2,133,254,9
21800data127,143,12,144,132,255,160,7
21900data169,127,7,254,143,12,144,136
22000data208,246,169,128,234,164,255,153
22100data0,144,96,253,254,251
23000end