use covers in 0
SELECT Covers.schcode, Covers.invno, Covers.specinst;
 FROM mbc!covers;
 WHERE ATC("Year 11 instructions:",Covers.specinst) > 0;
   AND OCCURS("Year 11 instructions",Covers.specinst) > 2 into cursor "badrecs"
*!*	SELECT Covers.schcode, Covers.invno, Covers.specinst;
*!*	 FROM mbc!covers;
*!*	 WHERE ATC("Previous Year's Instructions:",Covers.specinst) > 0;
*!*	   AND OCCURS("Previous Year's Instructions:",Covers.specinst) > 2 into cursor "badrecs"
*!*	set step on
 a=0
 select badrecs
 go top
 scan
 m.invno=badrecs.invno
 select covers
 locate for covers.invno=m.invno
 if found()

 a=a+1

 numtimes=OCCURS("Year 11 instructions",Covers.specinst)
 firstinstance=at("Year 11 instructions:",covers.specinst,1)
 lastinstance=at("Year 11 instructions:",covers.specinst,numtimes)-1
 replaced=lastinstance-firstinstance
 newinst=stuff(covers.specinst,firstinstance,replaced ," ")
 replace covers.specinst with newinst
 endif
 
 Messagebox(str(a)+" Record corrected")
 select badrecs
 endscan
 select badrecs
 use
 select covers 
 use