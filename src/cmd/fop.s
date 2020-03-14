""** 09-1-35.pdf page 1
	"[handwritten in the top center of scan - fop.s ]

jms = 0100000

q: 0
fmp = jms q

   lac i q	" load first arg into ac
   garg
   isz q	" skip over argument to fmp
   -1		" aexp = aexp + hexp - 1
   tad aexp	
   tad hexp
   dac aexp
   lac ans	" ac = ans
   lmq		" mq = ac
   lac ams	" ac = ams
   sna cll	" ac != 0?
   jmp 2f	" no, jump
   lls 1	" yes, ac = (ac << 1) | mq[0]; mq <<= 1
   dac 3f	" *three = ac
   dac 4f	" *four = ac
   lacq		" ac = mq
   dac 1f	" *one = ac
   lac hls	" ac = hls
   lmq		" mq = ac
   lac hms	" ac = hms
   sna cll	" ac != 0?
   jmp 2f	" no, jump
   lls 1	" yes, ac = (ac << 1) | mq[0]; mq <<= 1
   dac hms	" hms = ac
   lacq		" ac = mq
   dac hls	" hsl = ac
   lac hms	" ac = hms
   mul		" ac:mq = ac * *one
1: 0
   dac ans	" ans = ac
   lacq		" ac = mq
   dac ce10	" ce10 = ac
   lac hls	" ac = hls
   mul		" ac:mq = ac * *three
3: 0
   dac ams	" ams = ac
   lacq		" ac = mq
   tad ce10	" ac += ce10
   glk		" ac[17] = l
   dzm ce10	" ce10 = 0
   tad ams	" ac += ams
   szl cll	" l != 0?
   isz ce10	" no, ce10++
   tad ans	" yes, ac += ans
   szl cll	" l != 0?
   isz ce10	" no, ce10++
   dac ans	" yes, ans = ac
   lac hms	" ac = hms
   mul		" ac:mq = ac * *four
4: 0
   dac ams	" ams = ac
   lacq		" ac = mq
   tad ans	" ac += ans
   szl cll	" l != 0?
   isz ce10	" no, ce10++
   lmq		" mq = ac
   lac ce10	" ac = ce10
"** 09-1-35.pdf page 2
   tad ams	" ac += ams
   sma		" ac < 0?
   jmp 5f	" no, jump
   isz aexp	" yes, aexp++
   nop
   lrs 1	" l = ac[0]; ac = (mq[0] << 17) | (ac >> 1); mq >>= 1; mq >>= 1
5: xor rsign	" ac ^= rsign
   dac ams	" ams = ac
   lacq		" ac = mq
   dac ans	" ans = ac
   jmp i q	" return to q
2: dzm aexp	" aexp = 0
   dzm ams	" ams = 0
   dzm ans	" ans = 0
   jmp i q	" return to q

q: 0
fdv = jms q
   lac i q
   garg
   isz q
   lac hms
   sna
   sys save
   ral		"[box drawn around instruction - scan markup]
   dac 2f	"[separate box around the three dac instructions - scan markup]
   dac 3f
   dac 4f
   -1
   tad hexp	"[-\							- scan markup]
   cma		"[  | delta aexp???					- scan markup]
   tad aexp	"[  |							- scan markup]
   dac aexp	"[-/                             / Ams \		- scan markup]
   lac ans	"[hand written to the right: Rem | --- |    Hls???	- scan markup]
   lmq		"[                               \ Hms /   -----	- scan markup]
   lac ams	"[circle around ams            ----------   Hms		- scan markup]
   sna cll	"[                                 Hms			- scan markup]
   jmp 8f
   div
2: 0
   szl
   sys save
   dac ce10	"[arrow pointing from ce10 to "REm"            +-----+-----+	- scan markup]
   lacq          "[                   handwritten to the right: |  A  |+ B  |	- scan markup]
   dac 5f	"[circle around 5f                             +-----+-----+	- scan markup]
   lac ce10	"[                                             |  C  |+ D  |	- scan markup]
   frdiv		"[                                             +-----+-----+	- scan markup]
3: 0		"[line from 3:0 to a circled "Hms"				- scan markup]
   szl
   sys save
   lacq
   dac ce10	"[line from ce10 to text "Q1"	- scan markup]
   lac hls
   and o377777
   frdiv		"[                            X		- scan markup]
4: 0		"[handwritten to the right: -----	- scan markup]
   szl		"[                           A+B	- scan markup]
   sys save
   lacq
   dac 2b	"[circle around 2b with arrow pointing to the right
   spa cla
"** 09-1-35.pdf page 3
   -1		"[vertical line to the right of instructions... - scan markup]
   tad 2b
   cll		"[underlined    ...vertical line ends here - scan markup]
   mul
5: 0		"[line from 5:0 to "Q" - scan markup]
   dzm 2b
   spa
   isz 2b
   lls 1
   dac 3b
   lacq
   spa
   isz 3b
   skp
   isz 2b
   lac ce10	"[lac ce10 circled - scan markup]
   lmq
   lac 3b
   sna
   jmp 6f	"[arrow pointing down starts to the right of 6f - scan markup]
   cma
   tad d1
   stl
   tad ce10
   lmq
   szl
   isz 2b
6: lac 2b	"[arrow above points to between this instruction and the next one - scan markup]
   sma
   tad d1
   tad 5b
   sma cll
   jmp 7f
   lrs 1
   isz aexp
   nop
7: xor rsign
   dac ams
   lacq
   dac ans
   jmp i q
8: dzm aexp
   dzm ams
   jmp i q

q: 0
fad = jms q
   lac i q	" ac = first argument
   garg		" ?
   isz q	" skip over first argument
   lac hms	" ac = hms
   sna		" ac != 0?
   jmp 4f	" no, jump
   lac ams	" yes, ac = ams
   sna		" ac != 0?
   jmp 8f	" no, jump
7: lac aexp	" yes, ac = exp
   cma		" ac = ~ac
   tad hexp	" ac += hexp
   sma		" ac < 0?
   jmp 5f	" no, jump
"** 09-1-35.pdf page 4
   dac ce10	" yes, ac = ce10
   tad d34	" ac += 34
   spa cla	" ac > 0?
   jmp 0f	" no, ac = 0, jump
   lac ce10	" yes, ac = ce10
   cma		" ac = ~ac
   tad d1	" ac += 1
   xor o640500	" ac ^= 0640500
   dac 1f	" *one = ac
   lac hls	" ac = hls
   lmq		" mq = ac
   lac hms	" ac = hms
   cll		" l = 0
1: lrs 0	" repeat l times: mq = (ac[17] << 17) | (mq >> 1); ac = (l << 17) | (ac >> ac)
   dac hms	" hms = ac
   lacq		" ac = mq
   dac hls	" hls = ac
   lac rsign	" ac = rsign
   sma		" ac < 0?
   jmp 2f	" no, jump
   lac hls	" yes, ac = hls
   cll cma	" l = 0, ac = ~a
   tad d1	" ac += 1
   dac hls	" hls = ac
   lac hms	" ac = hms
   szl cma	" 
   tad d1
   dac hms
2: lac ams
   rcr
   dac ams
   lac ans
   rar
   cll
   tad hls
   dac ans
   glk
   tad ams
   tad hms
   dac ams
   sma
   jmp 3f
   lac ans
   cma cll
   tad d1
   dac ans
   lac ams
   szl cma
   tad d1
   dac ams
   lac o400000
3: isz aexp
   nop
0: xor asign
   and o400000
   dac rsign
   fno
4: lac ams
   xor rsign
   dac ams
   jmp i q
"** 09-1-35.pdf page 5
5: jms 6f
   lac rsign
   xor asign
   dac asign
   jmp 7b
8: jms 6f
   jmp 4b
6: 0
   lac ans
   lmq
   lac hls
   dac ans
   lacq
   dac hls
   lac ams
   lmq
   lac hms
   dac ams
   lacq
   dac hms
   lac hexp
   lmq
   lac aexp
   dac hexp
   lacq
   dac aexp
   jmp i 6b

q: 0
fno = jms q
   lac ans	" ac = ans
   sad ams	" ams = ans?
   sza cll	" no, is ans != 0?
   jmp 1f	" yes, either ams != ans or yes, ans != 0, so jump
   dzm aexp	" no, aexp = 0
   dzm rsign	" rsign = 0
   jmp i q	" return to q

1: lmq		" mq = ac
   lac ams	" ac = ams
   and o200000	" ac &= 0200000
   sza		" ac == 0?
   jmp i q	" no, return to q
   lac ams	" yes, ac = ams
   cll		" l = 0
   norm 36	" normalize unsigned
   dac ams	" ams = ac
   lacq		" ac = mq
   dac ans	" ans = ac
   lacs		" ac = sc
   tad o777743	" ac += 0777743
   cma		" ac = ~ac
   tad aexp	" aexp += ac
   dac aexp
   jmp i q	" return to q

q: 0
fcp = jms q
   lac i q	" ac = argument
   garg
   isz q	" skip over argument
"** 09-1-35.pdf page 6
   lac rsign	" ac = rsign
   spa		" ac >= 0?
   jmp 1f	" no, jump
   lac ams	" yes, ac = ams
   dac 5f	" *five = ac
   xor asign	" ac ^= asign
   dac ams	" ams = ac
   sna		" ac < 0?
   jmp 2f	" no, jump
   lac hms	" yes, ac = hms
   sna cma	" ac < 0?
   jmp 3f	" no, jump
   lac hexp	" yes, ac = hexp
   cma		" ac = ~ac
   tad d1	" ac += 1
   tad aexp	" ac += aexp
   sza		" ac != 0?
   jmp 4f	" no, jump
2: lac hms	" yes, ac = hms
   cma		" ac = ~ac
3: tad d1	" ac += 1
   tad 5f	" ac += *five
   sza		" ac != 0?
   jmp 4f	" no, jump
   lac hls	" yes, ac = hls
   cma		" ac = ~ac
   tad d1	" ac += 1
   tad ans	" ac += ans
   sza		" ac != 0?
4: xor asign	" no, ac ^= asign
   jmp i q	" return to q
1: lac ams	" ac = ams ^ 1
   xor d1
   jmp i q	" return to q
5: 0

q: 0
garg = jms q
   tad dm1	" eight = ac - 1
   dac 8
   lac i 8	" hexp = *eight++
   dac hexp
   lac i 8	" mq = *eight++
   lmq
   and o377777	" hms = mq & 0377777
   dac hms
   lac i 8	" hsl = *eight++
   dac hls
   lacq		" rsign = (mq ^ ams) & 0400000
   xor ams
   and o400000
   dac rsign
   lac ams	" asign = ams & 0400000
   and o400000
   dac asign
   lac ams	" ams &= 0377777
   and o377777
   dac ams
   jmp i q	" return

q: 0
"** 09-1-35.pdf page 7
sfmp = jms q
   lac i q	" load first arg into ac
   garg
   isz q	" skip over argument to sfmp
   -1		" aexp = aexp + hexp - 1
   tad aexp	" 
   tad hexp
   dac aexp
   lac ams	" ac = ams
   sna rcl	" ac != 0?
   jmp 2f	" no, jump
   lmq		" yes, mq = ac
   lac hms	" ac = hms
   sna rcl	" ac != 0?
   jmp 2f	" no, jump
   dac .+2	" yes, *(pc + 2) = ac
   0641122; 0	" lacq+extra => ac = mq
   sma		" ac < 0?
   jmp 1f	" no, jump
   rcr		" ac >>= 1
   xor rsign	" ac ^= rsign
   dac ams	" ams = ac
   isz aexp	" ++aexp == 0?
   jmp i q	" no, return to q
   jmp i q	" yes, return to q
1:
   xor rsign	" ac ^= rsign
   dac ams	" ams = ac
   jmp i q	" return to q
2:
   dzm aexp	" aexp = 0
   dzm ams	" ams = 0
   jmp i q	" return to q

q: 0
sfdv = jms q
   lac i q
   garg
   isz q
   lac hexp
   cma
   tad aexp
   tad d1
   dac aexp
   lac hms
   sna ral cll
   sys save
   dac 1f
   lac ams
   frdiv; 1: 0
   szl
   sys save
   lacq
   spa
   jmp 1f
   xor rsign
   dac ams
   jmp i q
1:
   rcr
   xor rsign
"** 09-1-35.pdf page 8
   dac ams
   isz aexp
   jmp i q
   jmp i q

"q: 0
"sfad = jms q
"   -1
"   tad i q
"   isz q
"   dac 8
"   lac i 8
"   dac hexp
"   lac i 8
"   sma
"   jmp 1f
"   xor o377777
"   tad d1
"1:
"   lrss 1
"   dac hms
"   lac ams
"   sma
"   jmp 1f
"   xor o377777
"   tad d1
"1:
"   lrss 1
"   dac ams
"   lac hexp
"   cma
"   tad aexp
"   tad d1
"   sma
"   jmp 1f
"   cma
"   tad d1
"   dac tmp
"   lac ams
"   lmq
"   lac hms
"   dac ams
"   lacq
"   dac hms
"   lac hexp
"   dac aexp
"   lac tmp
"1:
"   tad dm18
"   sma
"   jmp 3f
"   tad o660522
"   dac 1f
"   lac hms
"1:
"   lrss 0
"   dzm rsign
"   tad ams
"   cll sma
"   jmp 1f
"   lmq
"   and o400000
""** 09-1-35.pdf page 9
"   dac rsign
"   lacq
"   cma
"   tad d1
"   cll sma
"   jmp 1f
"   isz aexp
"   nop
"   rar
"1:
"   sna
"   jmp 1f
"   norm 18
"   xor rsign
"   dac ams
"   lacs
"   tad om60
"   cma
"   tad aexp
"   dac aexp
"   jmp i q
"1:
"   dzm aexp
"   dzm ams
"   jmp i q
"3:
"   lac ams
"   rcl
"   sma
"   jmp 1f
"   cma
"   tad d1
"   xor o400000
"1:
"   dac ams
"   jmp i q

" load floating-point argument into aexp/ams/ans
q: 0
fld = jms q
   -1		" ac = *q - 1
   tad i q
   dac 8	" *eight = ac
   lac i 8
   dac aexp	" aexp = *eight++
   lac i 8
   dac ams	" ams = *eight++
   lac i 8
   dac ans	" ans = *eight++
   isz q	" return q + 1
   jmp i q

" store aexp/ams/ans into floating-point argument
q: 0
fst = jms q
   -1		" ac = *q - 1
   tad i q
   dac 8	" *eight = ac
   lac aexp	" *eight++ = aexp
   dac i 8
   lac ams	" *eight++ = ams
   dac i 8
   lac ans	" *eight++ = ans
   dac i 8
"** 09-1-35.pdf page 10
   isz q	" return q + 1
   jmp i q

q: 0
fng = jms q
   lac ams	" ac = ams
   sza		" ac == 0?
   xor o400000	" no, ac ^= 0400000
   dac ams	" yes, ams = *ac
   jmp i q	" return q

q: 0
fix = jms q
   lac aexp	" ac = aexp
   spa sna	" ac >= 0?
   jmp 1f	" no, jump
   tad dm18	" yes, ac += -18
   sma		" ac < 0?
   jmp 3f	" no, jump
   cma		" yes, ac = ~ac
   tad o660500	" ac += 0660500
   dac 2f	" *two = ac, write argument to lrss 0 below!
   lac ams	" ac = ams
   sma		" ac < 0?
   jmp 2f	" no, jump
   xor o377777	" yes, ac ^= 0377777
   tad d1	" ac += 1
2:
   lrss 0	" repeat 0 times: mq = (ac[17] << 17) | (mq >> 1); AC >>= 1
   jmp i q	" return to q
1:
   lac ams	" ac = ams
   lrss 18	" mq = ac; ac = 0
   jmp i q	" return to q
3:
   lac ams	" ac = ams
   and o400001	" ac &= 0400001
   sma		" a < 0?
   lac o377777	" no, ac = 0377777
   jmp i q	" yes, return to q

q: 0
flt = jms q
   dac tmp
   dzm ans
   sma
   jmp 1f
   cma
   tad d1
   spa
   cla
1:
   sza
   jmp 1f
   dzm aexp
   dzm ams
   jmp 2f
1:
   clq
   norm 36
   dac ams
"** 09-1-35.pdf page 11
   lacs
   tad om56
   cma
   dac aexp
2:
   lac tmp
   and o400000
   xor ams
   dac ams
   jmp i q

tmp: 0
stmp: 0
ce10: 0
asign: 0
aexp: 0
ams: 0
ans: 0
hexp: 0
hms: 0
hls: 0

q: 0
sin = jms q
   lac ams	" sign = ams & 0400000
   and o400000
   dac sign
   lac ams	" ams &= 0377777
   and o377777
   dac ams
   fst; ftmp1	" ftmp1 = aexp/ams/ans
   fdv; fpi
   fix
   dac stmp
   and d1
   sna
   jmp 1f
   lac o400000
   xor sign
   dac sign
1:
   lac stmp
   flt
   fmp; fpi
   fng
   fad; ftmp1
   fst; strm
   fst; sres
   fst; ftmp2
   fld; fp1
   fst; sfac
   -6
   dac scnt
1:
bsin:
   fld; sfac
   fad; fp1
   fst; ftmp1
   fad; fp1
   fst; sfac
   fld; strm
"** 09-1-35.pdf page 12
   fmp; ftmp2
   fmp; ftmp2
   fdv; sfac
   fdv; ftmp1
   fng
   fst; strm
   fad; sres
   fst; sres
   isz scnt
   jmp 1b
   lac ams
   xor sign
   dac ams
   jmp i q

q: 0
sqrt = jms q
   lac aexp
   tad d1
   llss 0
   rar
   dac aexp
   lac ans
   lmq
   lac ams
   spa
   sys save
   dac 1f
   snl
   jmp 5f
   lls 1
   dac ams
   lacq
   dac ans
5:
   lac 1f
   sna
   jmp q i
   snl cll
   xor o200000
   xor o400000
   dac 1f
   lac ams	"[a centered dot drawn after ams - scan markup]
   frdiv; 1:..
   szl
   clq
   lacq
   tad 1b
   rar
   cll
   dac 2f
   lac ams
   frdiv; 2:..
   szl
   clq
   lacq
   tad 2b
   rar
   dac 3f
   dac 4f
   lac ans
"** 09-1-35.pdf page 13
   lmq
   lac ams
   cll
   div; 3:..
   szl
   clq ecla
   dac 1b
   lacq
   tad 3b
   clq lrs 1
   cll
   lrs 1
   dac ams
   lacq
   dac 2b
   lac 1b
   frdiv; 4:..
   szl
   sys save
   lacq
   lrs 2
   tad 2b
   dac ans
   jmp q i

sfac: 0;0;0
ftmp1: 0;0;0
ftmp2: 0;0;0
strm: 0;0;0
scnt: 0
sres: 0;0;0
rsign: 0
sign: 0

fp1: 1;0200000;0

o400000: 0400000
o640500: 0640500
o200000: 0200000
d34: 34
o777743: 0777743
"o2: 02
o377777: 0377777
dm18: -18
"o377777: 0377777
"om60: -060
"o660522: 0660522
o660500: 0660500
o400001: 0400001
d1: 1
dm1: -1
om56: -056
fpi: 2;0311037; 0552421
fpid2: 1; 0311037;0552421
"buf:
"cgarg = garg-jms
"cfmp = fmp-jms
"cfdv = fdv-jms
"cfad = fad-jms
"cfno = fno-jms
"cfcp = fcp-jms
"csfmp = sfmp-jms
""** 09-1-35.pdf page 14
"csfdv = sfdv-jms
"csfad = sfad-jms
"cfld = fld-jms
"cfst = fst-jms
"cfng = fng-jms
"cfix = fix-jms
"cflt = flt-jms
"csin = sin-jms
