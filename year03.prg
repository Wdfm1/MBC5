use invcnum in 0 excl
use cust in 0
sele cust
set order to
use quotes in 0
sele quotes
set orde to schcode
repl all quotes.newprice with .f. for quotes.contryear='02'

use codecnt in 0
sele codecnt
repl codecnt.precode with '03'
use

use qtetemp in 0 excl
sele qtetemp
dele all
pack
use
sele quotes
copy to qtetemp for contryear='02'


use qprcpryr in 0 excl
sele qprcpryr
dele all
pack
appe from quoteprc
use

use quoteprc in 0 excl
sele quoteprc
dele all
pack
appe from qprnewyr
use

use wtifbok2 excl
sele wtifbok2
dele all
pack
appe from wtifbook
use

use wtifbook excl
sele wtifbook
dele all
pack
appe from wtifnwyr
use

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

m.invno=0
m.schcode=cust.schcode
m.schname=cust.schname
m.booktype=cust.booktype
m.contryear=cust.contryear
m.schout=cust.schout
*m.nopages=quotes.nopages
m.qtedate=ctod('07/01/02')


if upper(cust.rebook)='Y'
repl contryear with '03',rebook with 'N',yb_sth with '',inoffice with '',vcrsent with .f.,sigfopf with '',;
sprngbrk with '',shipmemo with '',schout with ctod('  /  /  ')
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
*m.nopages=quotes.nopages
*if produtn.perfbind='H'
*m.hardbind='H'
*else
*m.hardbind=''
*endif
m.qtedate=ctod('07/01/02')
m.newprice=.t.
insert into quotes from memvar
insert into covers from memvar
insert into produtn from memvar
*repl produtn.perfbind with m.hardbind
insert into wipg from memvar
insert into wip from memvar
insert into recv2 from memvar
insert into surv2 from memvar
insert into xtra from memvar
endif
sele cust
skip
enddo
