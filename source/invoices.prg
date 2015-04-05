minv=0
use invoice in 0
sele invoice
set orde to invno
use invdetail in 0
sele invdetail
set orde to invno
sele invoice
set rela to invno into invdetail
set skip to invdetail
*set printer to name getprinter()

use produtn in 0
sele produtn
go top

do while not eof()
if produtn.shpdate=ctod('03/20/09')
minv=produtn.invno
mrec=recno()
sele invoice
seek minv

if found()
repo form invoice2 to prin for invoice.invno=minv noconsole
endif

else
sele produtn
skip
endif
sele produtn
skip
enddo


*m.invno=invoice.invno
*oldsel=select()
*m.rec=recno()
*sele invoice
*set order to invno
*set rela to invno into invdetail
*set skip to invdetail
*set printer to name getprinter()
*repo form invoice2 to prin for invoice.invno=minv noconsole
*set printer to default
*select(oldsel)
*go m.rec
