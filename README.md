# Vic-20-Mini-Synth
VIC-20 MINI SYNTH V.B.1.0,
BY RYAN LISTON,
INCLUDING VIZNUTS PWP WAVEFORM ROUTINE,
WRITTEN IN BASIC AND ASSEMBLY,
COMPILED WITH MOSPEED,
AUGUST 11, 2021

A simple monophonic synth application for the Commodore Vic-20 with 24k expanion.

Git Contents:
-++mini synth.prg-compiled .prg
-mini synth.prg-uncompiled .prg
-mini synth.txt-read me file
-mini synth.bas-mini synth basic source code
-vizwav.asm-assembly code for Viznuts pwp waveforms
-s1.png & s2.png-screenshots

Features:
-1 octave playable keyboard (compatable with the C=64 overlay)
-adsr amp envelope
-control over all 4 voice channels
-multiple pulse style waveforms
-2 octave selection per voice + 0 for voice off
-12 key transpose range per voice (2 octave + 12 note = total 3 octave range)
-envelope repeat with shift & shift lock
-hold note with C= key
-pitch bend 1/2 step up with ctrl key
-mute note with f7,{clear home} or {minus} keys 
        (any unused key will mute a note durin the relase phase)
-true interval note scale (aprox. 3/7 flat to traditional tuning)

Bugs:
-Values do not alwas print to their proper screen position
        (This may be due to the carry bit. I am using the plot kernal call
         from basic to position the values)
-The compiled file seems to large. The uncompiled file works with 8k but 
        the compiled file requires the full 24k expasion to run. 
                (...will file an issue with mospeed)
-sustain holding when set to 255 not working
-release holding when set to 255 not working

Todo:
-pal and ntsc versions or options
-users manual

