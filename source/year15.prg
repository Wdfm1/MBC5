*year 15 aging prg

wait nowait window "Changing year 14 new price to false"
use quotes in 0
sele quotes
set orde to schcode
*If newprice is .t. it means this is a CURRENT year record, .F. makes it a prior year record
repl all quotes.newprice with .f. for quotes.contryear='14'
wait window  "Done changing new price"
wait window  "Copying qtetemp table"



*The following copies all current sales records to qtetemp.dbf to use, if needed, to create a new quote at a later date

sele quotes
*!*	copy stru to qtetemp.dbf
copy to qtetemp for contryear='14'
use qtetemp in 0 excl
sele qtetemp
index on schcode tag schcode
use
select quotes 
use
wait  window "Done copying temp table"
**carry covers.specinst year 14 to year15

wait nowait window "Copying year 14 instructions to year 15"
use quotes in 0
select quotes
set order to schcode
use covers in 0
select covers
set order to invno
select quotes
set relation to invno into covers
set skip to covers
go top

use quotes again in 0 alias qyear14
select qyear14
set order to schcode
use covers again in 0 alias cyear14
select cyear14
set order to invno
select qyear14
set relation to invno into cyear14
set skip to cyear14
a=0
select quotes

scan for quotes.contryear="14" 
m.schcode=quotes.schcode
select covers
y12inst=covers.specinst
select qyear14
go top
locate for schcode=m.schcode and contryear="15"
if found()
a=a+1
select cyear14
replace cyear14.specinst with iif(!empty(y12inst),cyear14.specinst +chr(13)+"Year 14 instructions: "+chr(13)+y12inst,"")
endif
select quotes

endscan
close tables all
wait window str(a)+" Record replaced, we are done."