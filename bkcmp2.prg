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
IF !USED('bkcmpare')
use bkcmpare in 0
endif
sele bkcmpare
set orde to schcode
sele cust
set filter to quotes.contryear='02' .and. invoice.invtot>0
set skip to quotes
go top
do while !eof()
*if invoice.invtot>0
m.schcode=cust.schcode
m.schname=cust.schname
m.schstate=cust.schstate
m.booklast=.t.
m.totlast=invoice.invtot
mschcode=cust.schcode
sele bkcmpare
seek m.schcode order schcode
if found()
sele cust
replace bkcmpare.booklast with .t.
replace bkcmpare.totlast with invoice.invtot
else
insert into bkcmpare from memvar
endif
*endif
sele cust
m.schcode=''
m.schname=''
m.schstate=''
m.booklast=.f.
m.totlast=0
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
