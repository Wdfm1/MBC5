close all
v1=space(6)
v2=space(6)
open database mbc
use pryrhist excl
set order to schcode
go top
do while .not. eof()
v1=schcode
skip
v2=schcode
if v1=v2
 dele
 ? prodno
 ? schcode
* wait
endif
enddo
*pack
*close all
cancel
 