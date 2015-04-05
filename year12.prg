*year 12 aging prg
wait nowait window "Changing year 11 new price to false"
use quotes in 0
sele quotes
set orde to schcode

repl all quotes.newprice with .f. for quotes.contryear='11'
wait window  "Done changing new price"
wait window  "Copying qtetemp table"

*If newprice is .t. it means this is a CURRENT year record, .F. makes it a prior year record

*The following copies all current sales records to qtetemp.dbf to use, if needed, to create a new quote at a later date

sele quotes
copy stru to qtetemp.dbf
copy to qtetemp for contryear='11'
use qtetemp in 0 excl
sele qtetemp
index on schcode tag schcode
use
select quotes 
use
wait  window "Done copying temp table"
*carry covers.specinst year 11 to year12

wait nowait window "Copying year 11 instructions to year 12"
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

use quotes again in 0 alias qyear12
select qyear12
set order to schcode
use covers again in 0 alias cyear12
select cyear12
set order to invno
select qyear12
set relation to invno into cyear12
set skip to cyear12
a=0
select quotes

scan for quotes.contryear="11" 
m.schcode=quotes.schcode
select covers
y11inst=covers.specinst
select qyear12
go top
locate for schcode=m.schcode and contryear="12"
if found()
a=a+1
select cyear12
replace cyear12.specinst with iif(!empty(y11inst),cyear12.specinst +chr(13)+"Year 11 instructions: "+chr(13)+y11inst,"")
endif
select quotes

endscan
close tables all
wait window str(a)+" Record replaced, we are done."
