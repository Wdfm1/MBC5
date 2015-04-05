use upstmp in 0
use shipping in 0
sele shipping
set orde to trackno
sele upstmp
do while !eof()
sele upstmp
mtrackno=alltrim(upstmp.trackno)
sele shipping
seek mtrackno
if found()
delete
endif
sele upstmp
skip
enddo
