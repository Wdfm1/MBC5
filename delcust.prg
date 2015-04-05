close all
v1=space(6)
use custtemp in 0 shar
open database mbc
use cust in 0 shar
sele cust
set order to schcode
sele custtemp
go top
do while .not. eof()
v1=custtemp.schcode
sele cust
seek v1
if found()
delete
endif
sele custtemp
skip
enddo
cancel
 