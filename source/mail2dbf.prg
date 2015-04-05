* Run in m:\mbc5 directory
use upslist order tag schcode of upslist in 0 excl
sele upslist

if used('cust')
sele cust
else
use cust in 0 shar
sele cust
endif
set order to
go top
do while !eof()
if cust.contdate>ctod('02/01/99') .or. cust.sourdate>ctod('07/01/99')
sele upslist
appe blank
sele cust
if upper(yb_sth)='Y'
	repl upslist.schcode with cust.schcode+'Y'
	repl upslist.name with "Residence"
	repl upslist.attn with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl upslist.add1 with cust.contaddr
	repl upslist.add2 with cust.contaddr2
	repl upslist.city with cust.contcity
	repl upslist.state with cust.contstate
	repl upslist.zip with substr(cust.contzip,1,5)
	repl upslist.fax with cust.contfax
	repl upslist.email with cust.contemail
	repl upslist.code with cust.svcode
	else
	repl upslist.schcode with cust.schcode+'Y'
	repl upslist.name with cust.schname
	repl upslist.attn with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl upslist.add1 with cust.schaddr
	repl upslist.add2 with cust.schaddr2
	repl upslist.city with cust.schcity
	repl upslist.state with cust.schstate
	repl upslist.zip with substr(cust.schzip,1,5)
	repl upslist.fax with cust.schfax
	repl upslist.email with cust.schemail
	repl upslist.code with cust.svcode
endif
sele upslist
appe blank
sele cust
if upper(shiptocont)='Y'
	repl upslist.schcode with cust.schcode+'K'
	repl upslist.name with "Residence"
	repl upslist.attn with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl upslist.add1 with cust.contaddr
	repl upslist.add2 with cust.contaddr2
	repl upslist.city with cust.contcity
	repl upslist.state with cust.contstate
	repl upslist.zip with substr(cust.contzip,1,5)
	repl upslist.fax with cust.contfax
	repl upslist.email with cust.contemail
	repl upslist.code with cust.svcode
	else
	repl upslist.schcode with cust.schcode+'K'
	repl upslist.name with cust.schname
	repl upslist.attn with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl upslist.add1 with cust.schaddr
	repl upslist.add2 with cust.schaddr2
	repl upslist.city with cust.schcity
	repl upslist.state with cust.schstate
	repl upslist.zip with substr(cust.schzip,1,5)
	repl upslist.fax with cust.schfax
	repl upslist.email with cust.schemail
	repl upslist.code with cust.svcode
endif		
endif
skip
enddo

sele upslist
use
sele cust
use

