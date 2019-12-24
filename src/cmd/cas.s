"** 04-cas.pdf page 1
" cas

	" Usage: cas output input
	" graphics display character assembler

	" The input is on the form:
	" :or
	" x
	" af
	" v
	" nf
	" x
	" mn
	" r

	" : => emit ":x\n0"
	" x => clear vis
	" v => set vis
	" r => emit trailing octal 00, newline, "label=x-b+nins" and 2 newlines
	" aa..qo emit a number of double digit octals with preceeding 0 and
	" trailing newlines

	" This input starts with a ':' followed by label denoting the character
	" whose character description follows. The description consists of a
	" number of commands,one per line. The commands will either cause
	" moveto instructions or lineto instructions to be emitted in the
	" output. If visibility is enabled by a 'v' command then lineto
	" instructions that causes a pen to draw a line, will be emitted for
	" between the current pen position and the next location encountered in
	" the input. If visibility is disabled by a 'x' command then moveto
	" instructions that moves the current pen position to be updated
	" whenever new locations are encountered in the input. The initial pen
	" x/y position is (0,0). Double letter commands denote locations in a
	" ?x? grid. The first letter denotes the x coordinate and the second
	" letter the y coordinate. Before ending the list of commands for a
	" character it is important to disable visiblity, because cas will not
	" reset the visbility information before parsing the next character
	" description. The 'r' command finishes a character description, and
	" causes the program to write a list of a character drawing
	" instructions to the output.

	" The corresponding output is on the form:
	" x:
	" 0010101
	" 0010160
	" 0407474
	" 0741401
	" 0624200
	" or=x-b+0234000

	" This program makes use of addresses 10 and 11 which are
	" auto-indexing indirect registers on PDP-7, see page 40 of
	" https://www.bitsavers.org/pdf/dec/pdp7/F-75_PDP-7userHbk_Jun65.pdf 
	" This means that when they are accessed by lac/dac they are
	" automagically incremented by 1.




   narg = i 017777

   lac 017777	 		" get address of pointer to argument count
   tad d5
   dac name1			" save second argument in @name1
   tad d4
   dac name2			" save first argument in @name2
   sad d4
   jmp 1f			" if narg == 4, jump to default both input and output to tty
   sad d8
   jmp 2f			" if narg == 8: jump to default input to tty and use output
				" file from command line
   jmp 3f			" otherwise, jump to use input/output files from command line
1:
   law ttyout			" store 'ttyin   ' at name1
   dac name1
2:
   law ttyin			" store 'ttyout  ' at name2
   dac name2
3:
   sys open; name2: 0; 0	" open input file name2 for reading
   sma
   jmp 1f			" jump to label 1: below upon success
   lac name2
   dac 2f
   lac d1
   sys write; 2: 0; 4		" print name2 (4 words long) to stdout
   lac d1
   sys write; mes; 2		" print ' ?\n' (2 words long) to stdout
   sys exit			" terminate process
1:
   sys open; name1: 0; 1	" open output file name1 for writing
   sma
   jmp 1f			" jump to label 1: below upon success
   lac name1
   dac 2f
   lac o17			" file mode, rw owner, rw non-owner, non-exec, non-setuid
   sys creat; 2: 0		" create file named name1
   sma
   jmp 1f			" jump to label 1: below upon success
   lac name1
   dac 2f
   lac d1
   sys write; 2: 0; 4		" print name1 (4 words long) to stdout
   lac d1
   sys write; mes; 2		" print ' ?\n' (2 words long) to stdout
   sys exit			" terminate process
mes:
   040077;012
   " ' ?\n'
1:
   dzm nchar			" zero variables
   dzm x			" clear x and y
   dzm y
   dzm parflg
   dzm nins			" clear number of instructions
   dzm nwds
   lac bufp
   dac 10			" *(10) = buf - 1

advanc:
"** 04-cas.pdf page 2

	" One word at a time is read from the input file into the char variable.
	" Each word consists of two 9 bit characters.
	" The least significant character will be processed later.
	" The least significant character is stored in nchar.
	" The char variable is adjusted to contain only the most significant character.
	" The most significant character is then parsed.
	" Once that is done, execution returns here, finding a character in nchar.
	" It is moved to char, and nchar is emptied.
	" Next that save least significant character is parsed.
	" Once that is done, execution returns here, finding no character in nchar.
	" This triggers a new read of a word of characters from the input file.
	" The cycle repeats until no word can be read from the input file.
	" At this point execution jumps to the done label.

   lac nchar			" AC = nchar
   dzm nchar			" nchar = 0
   sza
   jmp adv1			" if nchar != 0 jump
   lac d2
   sys read; char; 1		" read 1 word from input file
   sna
   jmp done			" if no char read jump
   lac char
   and o777
   dac nchar			" store char & 0x1ff in nchar
   lac char
   lrss 9

adv1:
   sna
   jmp advanc			" if char == 0, continue parsing
   dac char			" store char >> 9 in char
   lac labflg
   sna
   jmp 2f			" if labflg cleared jump
   lac char
   sad o12
   skp
   jmp 1f			" if char != '\n' jump
   dzm labflg			" if char == '\n' clear labflg
   dac i 11			" *lbufp = '\n'; lbufp++
   jmp advanc			" continue parsing
1:
   dac i 11			" *lbufp = char; lbufp++
   jmp advanc			" continue parsing
2:
   lac parflg
   sza
   jmp atoz			" if parflg is set jump
   lac char			" load read char
   sad o12
   jmp advanc			" if char == '\n' continue parsing
   sad o72
   skp				" if char == ':' continue
   jmp 1f			" if char != ':' jump
   -4
   dac labflg			" labflg = -4 to indicate that we are now parsing a label!
   dac mod3			" mod3 = -4 to indicate that we are at the beginning of a 18 bit octal instruction output
   jms wbuf "???
   lac lbufp
   dac 11			" *(11) = lbuf - 1
   lac o170072
   dac i 10			" *(bufp++) = 'x:'
   lac o12
   dac i 10			" *(bufp++) = '\n'
   lac o60
   dac i 10			" *(bufp++) = '0'
   isz nwds
   isz nwds
   isz nwds
   jmp advanc			" continue parsing
1:
   sad o170
   skp
   jmp 1f			" if char != 'x' jump
"** 04-cas.pdf page 3
   dzm vis			" if char == 'x' clear vis
   jmp advanc			" continue parsing
1:
   sad o166
   skp
   jmp 1f			" if char != 'v' jump
   lac visbit
   dac vis			" if char == 'v' vis = visbit
   jmp advanc			" continue parsing
1:
   sad o162
   skp
   jmp letr			" if char != 'r' jump
   isz mod3			" mod3 += 1
   skp
   jmp 2f			" if mod3 == 0 jump
   lac o60060			" '00'
1:
   dac i 10			" *(bufp++) = '00'
   isz nwds			" nwds += 1
   isz mod3			" mod3 += 1
   jmp 1b			" if nwds == 0 or mod3 != 0 loop back
2:
   lac o12
   dac i 10			" *(bufp++) = '\n'
   isz nwds			" nwds += 1
   lac lbufp
   dac 11			" *(11) = lbuf - 1
1:
   lac i 11
   sad o12
   jmp 1f			" if *lbufp == '\n' jump
   dac i 10			" *(bufp++) = *lbufp
   isz nwds			" nwds += 1
   jmp 1b
1:
   lac o75170
   dac i 10			" *(bufp++) = '=x'
   isz nwds
   lac ob1
   dac i 10			" *(bufp++) = '-b'
   isz nwds
   lac sp
   dac i 10			" *(bufp++) = '+0'
   isz nwds

   lac nins			" load number of instructions into AC
   dzm nins			" clear number of instructions
   tad o100			" AC = number of instructions + 0100
   lmq				" MQ = AC
   llss 10			" AC <<= 10, MQ <<= 10

				" Maps bits MQ[0..5] to two ASCII characters in
				" the range '0'..'7' and store them at bufp
   cla
   llss 3
   alss 6
   llss 3			" AC = 0b000000xxxllllllyyy
				" where xxx are MQ[0..2] and yyy are MQ[3..5]
				" and lll are the bit stored in the link register
   tad o60060			" '00'
   dac i 10			" *(bufp++) = '00' + ?

				" Maps bits MQ[0..5] to two ASCII characters in
				" the range '0'..'7' and store them at bufp
   cla	
   llss 3
   alss 6
   llss 3			" AC = 0b000000xxxllllllyyy
				" where xxx are MQ[0..2] and yyy are MQ[3..5]
				" and lll are the bit stored in the link register
   tad o60060			" '00' 
"** 04-cas.pdf page 4
   dac i 10			" *(bufp++) = '00' + ?

				" Maps bits MQ[0..5] to two ASCII characters in
				" the range '0'..'7' and store them at bufp
   cla
   llss 3
   alss 6
   llss 3			" AC = 0b000000xxxllllllyyy
				" where xxx are MQ[0..2] and yyy are MQ[3..5]
				" and lll are the bit stored in the link register
   tad o60060			" '00'
   dac i 10			" *(bufp++) = '00' + ?

   lac nwds
   tad d4
   dac nwds			" nwds += 4

   lac o12012			" '\n\n'
   dac i 10			" *(bufp++) = '\n\n'

   dzm x			" clear x and y
   dzm y
   jmp advanc			" continue parsing

letr:
				" This code maps the first letter of a location
				" from 'a'..'p' onto 13..-2 and stores it in ny
   tad om141			" AC = char - 'a'
   spa
   jmp error			" jump and print error if char < 'a'
   tad dm16			" AC = char - 'a' - 16, e.g.
				" 'a' - 'a' - 16 would be -16
				" 'p' - 'a' - 16 would be -1
				" 'q' - 'a' - 16 would be 0
   sma
   jmp error			" jump and print error if char >= 'q'
   cma
   tad dm3			" AC = -(char - 'a' - 16) - 3
   dac ny			" map 'a'..'p' onto 13..-2 and store in ny
   -1
   dac parflg			" set parflg = -1 to indicate that we will
				" parse the second letter of a location
   jmp advanc			" continue parsing

atoz:
				" This code maps the second letter of a location
				" from 'a'..'n' onto 0..13 and stores it in nx
   lac char
   tad om141			" AC = char - 'a'
   spa
   jmp error			" jump and print error if char < 'a'
   tad dm14			" AC = char - 'a' - 14, e.g.
				" 'a' - 'a' - 14 would be -14
				" 'n' - 'a' - 14 would be -1
				" 'o' - 'a' - 14 would be 0
   sma
   jmp error			" jump and print error if char >= 'o'
   tad d14
   dac nx			" map 'a'..'n' onto 0..13 and store in nx

loop:
   -1
   tad x
   cma
   tad nx
   dac delx			" delx = nx - (x - 1)
   -1
   tad y
   cma
   tad ny
   dac dely			" dely = ny - (y - 1)
   " generate direction

   lac delx
   sna
   jmp c1			" if delx == 0 jump
   spa
   jmp c2			" if delx < 0 jump
   lac dely  ;"dx ,gr, 0
   sna
   jmp c3			" if dely == 0 jump
"** 04-cas.pdf page 5
   spa
   jmp c4			" if dely < 0 jump
   lac d1			" set direc = 1 when...
   jmp b			" ...jumping to b
c3:
   lac d2			" set direc = 2 when...
   jmp a			" ...jumping to a
c4:
   lac d3			" set direc = 3 when...
   jmp b			" ...jumping to b

c1:
   lac dely
   sna
   jmp out			" if dely == 0 jump
   spa
   jmp c5			" if dely < 0 jump
   cla				" set direc = 0 when...
   jmp a			" ...jumping to a
c5:
   lac d4			" set direc = 4 when...
   jmp a			" ...jumping to a
c2:
   lac dely
   sna
   jmp c6			" if dely == 0 jump
   spa
   jmp c7			" if dely < 0 jump
   lac d7			" set direc = 7 when...
   jmp b			" ...jumping to b
c6:
   lac d6			" set direc = 6 when...
   jmp a			" ...jumping to a
c7:
   lac d5			" set direc = 5 when...
   jmp b			" ...jumping to b
   "
   "
a:
   dac direc			" direc = 0 or 2 or 4 or 6
   lac delx			" AC = delx
   sma
   jmp 1f			" if delx >= 0 jump
   cma
   tad d1			" AC = -delx + 1
   dac delx			" delx = AC
1:
   lac dely			" AC = dely
   sma
   jmp 1f			" if dely >= 0 jump
   cma
   tad d1			" AC = -dely + 1
1:
   tad delx
   tad dm4			" AC += delx - 4
   sma
   cla				" if AC >= 0 set AC = 0
   tad d3
   dac dist			" dist = AC + 3
   tad incxp
   dac tmp			" tmp = AC + incxp
"** 04-cas.pdf page 6
   lac i tmp			" AC = *tmp
   dac incx			" incx = *tmp
   lac dist
   tad incyp
   dac tmp			" tmp = dist + incyp
   lac i tmp			" AC = *tmp
   dac incy			" incy = *tmp
   jmp com
   "
b:
   dzm dist			" clear dist
   dac direc			" direc = 1 or 3 or 5 or 7
   lac incxt
   dac incx			" incx = *incxt
   lac incyt
   dac incy			" incy = *incyt
   "
com:
   isz nins			" increment number of instructions

   lac dist
   alss 4
   xor vis
   xor direc			" AC = (dist << 4) | vis | direc

   isz mod3			" mod3++
   skp
   jmp 1f			" if mod3 == 0 jump
2:
   lmq				" MQ = AC
   llss 12			" AC &= 0xfff

				" Maps bits MQ[0..5] to two ASCII characters in
				" the range '0'..'7' and store them at bufp
   cla
   llss 3
   alss 6
   llss 3			" AC = 0b000000xxxllllllyyy
				" where xxx are MQ[0..2] and yyy are MQ[3..5]
				" and lll are the bit stored in the link register
   tad o60060			" AC += '00'; this means AC = 0b000110xxxlll110yyy,
				" and that 0b110xxx and 0x110yyy correspond to two
				" ASCII characters '0'..'7'
   dac i 10			" *(bufp++) = '00'..'77'

   isz nwds			" increment number of words
   jmp 3f
1:
   dac tmp

   lac o12060
   dac i 10			" *(bufp++) = '\n0'

   isz nwds			" increment number of words
   -3
   dac mod3			" mod3 = -3

   lac tmp

   jmp 2b
3:
   lac direc
   tad incx
   dac tmp			" tmp = direc + incx
   lac i tmp
   tad x
   dac x			" x = x + *tmp
   lac direc
   tad incy
   dac tmp			" tmp = direc + incy
   lac i tmp
   tad y
   dac y			" y = y = *tmp
   jmp loop
"** 04-cas.pdf page 7
out:
   lac nx
   dac x			" x = nx
   lac ny
   dac y			" y = ny
   dzm parflg			" clear parflg
   jmp advanc			" continue parsing

done:
	" Close the input file.
	" Write pending data to the output file.
	" Close the output file.
	" Cease execution.

   lac d2
   sys close			" close input file
   jms wbuf			" write remaining data
   lac d3
   sys close			" close output file
   sys exit			" terminate process

error:
   lac d1
   sys write; char; 1		" print char (1 word long) to stdout
   lac d1
   sys write; mes; 2		" print ' ?\n' (2 words long) to stdout
   dzm parflg			" clear parflg and labflg
   dzm labflg
   jmp advanc			" continue parsing

wbuf: 0
   lac nwds
   dac 1f
   lac d3
   sys write; buf; 1: 0;	" write nwds words from buf to output file
   dzm nwds			" clear nwds variable
   lac bufp
   dac 10			" *(10) = buf - 1
   jmp i wbuf			" return from subroutine

d1: 1
d2: 2
d3: 3
d4: 4
d5: 5
d6: 6
d7: 7
d8: 8
o12: 012			" '\n'
o75170: 075170
ob1: 055142			" '-b'

sp: 053060			" '+0'
o60: 060
o60060: 060060			" '00'
o73: 073
"d6: 6 "seems like a dupe
d14: 14
dm14: -14
dm16: -16
om141: -0141
dm3: -3
dm4: -4
o162: 0162
o166: 0166
"** 04-cas.pdf page 8
o17: 017
o777: 0777
o72: 072
o170: 0170
o10000: 010000
o20000: 020000
o200000: 0200000
o41: 041
ttyin:
   0164164;0171151;0156040;040040	" 'ttyin   '
ttyout:
   0164164;0171157;0165164;040040	" 'ttyout  '

char: .=.+1
parflg: .=.+1
labflg: .=.+1
obuf: .=.+8
x: .=.+1
y: .=.+1
nx: .=.+1
ny: .=.+1
vis: .=.+1
nchar: .=.+1
   "
incxp:incxt
incyp:incyt
incxt: x1;x2;x3;x4
incyt: y1;y2;y3;y4
   "
x1: 0;1;1;1;0;-1;-1;-1
x2: 0;2;2;2;0;-2;-2;-2
x3: 0;3;3;3;0;-3;-3;-3
x4: 0;4;4;4;0;-4;-4;-4
y1: 1;1;0;-1;-1;-1;0;1
y2: 2;2;0;-2;-2;-2;0;2
y3: 3;3;0;-3;-3;-3;0;3
y4: 4;4;0;-4;-4;-4;0;4
delx: .=.+1
dely: .=.+1
incx: .=.+1
incy: .=.+1
direc: .=.+1
dist: .=.+1
visbit: 010
mod3: .=.+1
tmp: .=.+1
buf: .=.+500
bufp: buf-1
lbuf: .=.+10
lbufp: lbuf-1
nwds: .=.+1
o170072: 0170072		" 'x:'
nins: .=.+1
o100: 0100
o12012: 012012			" '\n\n'
o12060: 012060			" '\n0'
