* Contains last invoice number used
use invcnum in 0 excl
use cust in 0
sele cust
set order to
use quotes in 0
sele quotes
set orde to schcode
* Current year quotes become last year or old price 
repl all quotes.newprice with .f. for quotes.contryear='06'

use codecnt in 0
sele codecnt
* All new schools School Code will now begin with 05
repl codecnt.precode with '07'
use

sele quotes
copy stru to qtetemp.dbf
copy to qtetemp for contryear='06'
use qtetemp in 0 excl
sele qtetemp
index on schcode tag schcode
use

**********************************

* replace old OPTIONS prices with new ones
use qprcpryr in 0 excl
if used('qprcpryr')
sele qprcpryr
dele all
pack
appe from quoteprc
use
else
MessageBox("QPrcPrYr NOT open", 16,;
        "File NOT open") 
endif

* replace current OPTIONS prices with new ones
use quoteprc in 0 excl
if used('quoteprc')
sele quoteprc
dele all
pack
appe from qprnewyr
use
else
MessageBox("QuotePrc NOT open", 16,;
        "File NOT open") 
endif

*replace prior year price table with current one
use wtifbok2 excl
if used('wtifbok2')
sele wtifbok2
dele all
pack
appe from wtifbook
use
else
MessageBox("WtifBok2 NOT open", 16,;
        "File NOT open") 
endif

* replace current year price table with next year one

*NO CHANGE THIS YEAR GOING FROM 2005 TO 2006 (Do not run following wtifbook update
*PRICES CHANGED FROM 2006 TO 2007

use wtifbook excl
if used('wtifbook')
sele wtifbook
dele all
pack
appe from wtifnwyr
use
else
MessageBox("WtifBook NOT open", 16,;
        "File NOT open") 
endif

use covers in 0
sele covers
set orde to invno
use produtn in 0
sele produtn
set orde to invno
use wipg in 0
sele wipg
set orde to invno
use wip in 0
sele wip
set orde to invno
use newadv in 0
sele newadv
set orde to schcode
use recv2 in 0
sele recv2
set orde to invno
use surv2 in 0
sele surv2
set orde to invno
use xtra in 0
sele xtra
set orde to invno
sele cust
set rela to schcode into quotes, schcode into newadv
sele quotes
set rela to invno into covers, invno into produtn, invno into wipg, invno into wip, invno into recv2, invno into surv2, invno into xtra

sele cust
go top
do while !eof()

*m.invno=0
m.schcode=cust.schcode
m.schname=cust.schname
m.booktype=cust.booktype
m.contryear=cust.contryear
m.schout=cust.schout
m.nopages=quotes.nopages
m.qtedate=ctod('07/01/05')
m.rebookdte=cust.rebookdte


if upper(cust.rebook)='Y'
repl contryear with '07',rebook with 'N',yb_sth with '',inoffice with '',vcrsent with .f.,sigfopf with '',;
sprngbrk with '',schout with ctod('  /  /  '),contdate with m.rebookdte
 if !empty(newadv.contlname)
 repl cust.contlname with newadv.contlname,cust.contfname with newadv.contfname,cust.contaddr with newadv.contaddr,;
 cust.contaddr2 with newadv.contaddr2,cust.contcity with newadv.contcity,cust.contstate with newadv.contstate,cust.contzip with newadv.contzip
 repl cust.contphnhom with newadv.contphnhom,cust.contphnwrk with newadv.contphnwrk,cust.contfax with newadv.contfax,;
 cust.contemail with newadv.contemail
  if newadv.yb_sth=.t.
  repl cust.yb_sth with 'Y'
  else
  repl cust.yb_sth with 'N'
  endif
  if newadv.shiptocont=.t.
  repl cust.shiptocont with 'Y'
  else
  repl cust.shiptocont with 'N'
  endif

 endif
sele invcnum
repl invcnum.invcno with invcnum.invcno+1
m.invno=invcnum.invcno

sele cust
m.schcode=cust.schcode
m.schname=cust.schname
m.booktype=cust.booktype
m.contryear=cust.contryear
m.schout=cust.schout

m.nopages=quotes.nopages
m.nocopies=quotes.nocopies
m.hndred=recv2.hndred
if produtn.perfbind='H'
m.hardbind='H'
else
m.hardbind=''
endif
m.qtedate=ctod('07/01/06')
m.newprice=.t.
insert into quotes from memvar
insert into covers from memvar
insert into produtn from memvar
repl produtn.perfbind with m.hardbind
insert into wipg from memvar
insert into wip from memvar
insert into recv2 from memvar
if surv2.tobeapplied='07'
repl recv2.recv2memo with surv2.compmemo
repl cust.inoffice with surv2.compmemo
endif
insert into surv2 from memvar
insert into xtra from memvar
endif
sele cust
skip
enddo
