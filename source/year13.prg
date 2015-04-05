*year 13 aging prg

wait nowait window "Changing year 12 new price to false"
use quotes in 0
sele quotes
set orde to schcode

repl all quotes.newprice with .f. for quotes.contryear='12'
wait window  "Done changing new price"
wait window  "Copying qtetemp table"

*If newprice is .t. it means this is a CURRENT year record, .F. makes it a prior year record

*The following copies all current sales records to qtetemp.dbf to use, if needed, to create a new quote at a later date

sele quotes
copy stru to qtetemp.dbf
copy to qtetemp for contryear='12'
use qtetemp in 0 excl
sele qtetemp
index on schcode tag schcode
use
select quotes 
use
wait  window "Done copying temp table"
*carry covers.specinst year 11 to year12


