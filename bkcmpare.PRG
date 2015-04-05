use bkcmpare excl
sele bkcmpare
IF USED('bkcmpare')
zap
use
endif
use cust in 0
sele cust
set orde to schstate
use quotes in 0
sele quotes
set orde to schcode
use invoice in 0
sele invoice
set orde to invno
sele cust
set rela to schcode into quotes
sele quotes
set rela to invno into invoice
set filter to quotes.contryear='03'
sele cust
set skip to quotes
go top
do while !eof()
if invoice.invtot>0
m.schcode=cust.schcode
m.schname=cust.schname
m.schstate=cust.schstate
m.bookcur=.t.
m.totcur=invoice.invtot
insert into bkcmpare from memvar
endif
skip
enddo
sele cust
use
sele quotes
use
sele invoice
use
sele bkcmpare
use

