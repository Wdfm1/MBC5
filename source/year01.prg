use cust in 0
set order to
go top
use quotes in 0
use covers in 0
use produtn in 0
use wipg in 0
use wip in 0
sele cust
do while !eof()

if upper(cust.rebook)='Y'
repl contryear with '01'
repl rebook with 'N'
repl yb_sth with ''
use invcnum in 0 excl
sele invcnum
repl invcnum.invcno with invcnum.invcno+1
m.invno=invcnum.invcno
sele invcnum
use
sele cust
m.schcode=cust.schcode
m.schname=cust.schname
m.booktype=cust.booktype
m.contryear=cust.contryear
m.schout=cust.schout

insert into quotes.dbf from memvar
sele quotes
repl quotes.qtedate with date()
repl quotes.newprice with .t.

insert into covers from memvar

insert into produtn from memvar

insert into wipg from memvar

insert into wip from memvar
endif
sele cust
skip
enddo

