* Add all records for new book
local nSelect,prody_n,lAddNew
ProdY_N=.f.
lAddNew=7
nSelect=select()
open data mbc
use produtn in 0
sele produtn
set order to invno
use invoice in 0
sele invoice
set order to invno
use quotes in 0
sele quotes
set order to schcode
sele quotes
set rela to invno into produtn, invno into invoice addi
go top
do while .not. eof()
m.schcode=quotes.schcode
m.schname=quotes.schname
m.booktype=quotes.booktype
m.contryear=quotes.contryear
m.invno=quotes.invno
sele produtn
seek m.invno
if .not. found()
insert into produtn from memvar
endif
sele invoice
seek m.invno
if .not. found()
insert into invoice from memvar
endif
sele quotes
skip
enddo
select(nSelect)