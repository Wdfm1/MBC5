use quotes in 0 orde schcode
sele quotes
set filt to contryear='08'

use qtetemp in 0 orde schcode
sele qtetemp

use produtn in 0 orde invno
sele produtn

sele quotes

set rela to schcode into qtetemp, invno into produtn

repl all produtn.cstat with 'Rebook' for produtn.invno=quotes.invno and quotes.schcode=qtetemp.schcode

