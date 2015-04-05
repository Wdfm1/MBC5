* Add all records for new book
local nSelect,prody_n,lAddNew
ProdY_N=.f.
lAddNew=7
nSelect=select()
open data mbc
use pryrhist in 0
sele pryrhist
set order to schcode
use covers in 0
sele covers
set order to invno
use produtn in 0
sele produtn
set order to invno
use recvng in 0
sele recvng
set order to schcode
use invoice in 0
sele invoice
set order to invno
use cust in 0
sele cust
set order to schcode
use quotes in 0
sele quotes
set order to schcode
sele cust
set rela to schcode into quotes, schcode into pryrhist, schcode into recvng addi
sele quotes
set rela to invno into covers, invno into produtn, invno into invoice addi
sele cust
go top
do while .not. eof()
if cust.contdate>ctod('06/30/99')
m.schcode=cust.schcode
sele quotes
seek m.schcode
if .not. found()
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
insert into produtn from memvar
if pryrhist.schcode=cust.schcode
repl produtn.nocopies with pryrhist.nocopies
repl produtn.nopages with pryrhist.nopages
endif
insert into quotes.dbf from memvar
repl quotes.qtedate with date()
repl quotes.newprice with .t.
insert into recvng from memvar
insert into invoice from memvar
endif
endif
sele cust
skip
enddo
select(nSelect)