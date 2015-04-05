close all
v1=0
v2=0
open database mbc
use wip excl
set order to invno
go top
do while .not. eof()
v1=invno
skip
v2=invno
if v1=v2
 dele
 ? invno
 ? schcode
* wait
endif
enddo
*pack
*close all
cancel
 