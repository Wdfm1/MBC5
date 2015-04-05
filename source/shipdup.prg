close all
v1=space(20)
v2=space(20)
open database mbc
use shipping
sele shipping
set order to trackno
go top
do while .not. eof()
v1=trackno
skip
v2=trackno
if v1=v2
 dele
* ? trackno
* ? schcode
* wait
endif
enddo
*pack
*close all
cancel
 