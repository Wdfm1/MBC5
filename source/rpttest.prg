use m:\mbc5\invoice in 0
sele invoice
set order to invno
use m:\mbc5\invdetail in 0
sele invdetail
set order to invno
sele invoice
set rela to schcode into cust
set rela to invno into quotes
set rela to invno into invdetail
set order to schcode
sele invoice
seek '972172'
do while invoice.schcode='972172' .and. !eof()
m.invno=invoice.invno
m.rec=recno()
set order to invno
set skip to invdetail
*repo form invoice to prin
repo form invoice for invoice.baldue>0 .and. invoice.invno=m.invno
*repo form invoice to prin for invoice.invno=20175
*repo form invoice to prin for invoice.invno=20196
*repo form invoice to prin for invoice.schcode='972172'
sele invoice
set order to schcode
go m.rec
if eof()
close all
exit
endif
skip
enddo
close all
