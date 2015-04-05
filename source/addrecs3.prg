open data mbc share
use produtn in 0 shar
sele produtn
set order to invno
use pryrhist in 0 shar
sele pryrhist
set order to schcode
sele produtn
go top
do while .not. eof()
m.schcode=produtn.schcode
if produtn.nocopies<1 .or. produtn.nopages<1
sele pryrhist
seek m.schcode
if found()
repl produtn.nocopies with pryrhist.nocopies
repl produtn.nopages with pryrhist.nopages
endif
endif
sele produtn
skip
enddo
close all
