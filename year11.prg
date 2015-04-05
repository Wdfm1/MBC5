
use quotes in 0
sele quotes
set orde to schcode

repl all quotes.newprice with .f. for quotes.contryear='10'

*If newprice is .t. it means this is a CURRENT year record, .F. makes it a prior year record

*The following copies all current sales records to qtetemp.dbf to use, if needed, to create a new quote at a later date

sele quotes
copy stru to qtetemp.dbf
copy to qtetemp for contryear='10'
use qtetemp in 0 excl
sele qtetemp
index on schcode tag schcode
use

