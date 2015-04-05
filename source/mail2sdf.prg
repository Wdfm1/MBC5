use mailsdf in 0 excl
sele mailsdf
dele all
pack

if used('cust')
sele cust
else
use cust in 0
sele cust
endif
set order to
go top
do while !eof()
if cust.contdate>ctod('02/01/99') .or. cust.sourdate>ctod('07/01/99')
sele mailsdf
appe blank
sele cust
if upper(yb_sth)='Y'
	repl mailsdf.schcode with cust.schcode+'Y'
	repl mailsdf.schname with "Residence"
	repl mailsdf.fname with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl mailsdf.addr with cust.contaddr
	repl mailsdf.addr2 with cust.contaddr2
	repl mailsdf.city with cust.contcity
	repl mailsdf.state with cust.contstate
	repl mailsdf.zip with substr(cust.contzip,1,5)
	else
	repl mailsdf.schcode with cust.schcode+'Y'
	repl mailsdf.schname with cust.schname
	repl mailsdf.fname with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl mailsdf.addr with cust.schaddr
	repl mailsdf.addr2 with cust.schaddr2
	repl mailsdf.city with cust.schcity
	repl mailsdf.state with cust.schstate
	repl mailsdf.zip with substr(cust.schzip,1,5)
endif
sele mailsdf
appe blank
sele cust
if upper(shiptocont)='Y'
	repl mailsdf.schcode with cust.schcode+'K'
	repl mailsdf.schname with "Residence"
	repl mailsdf.fname with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl mailsdf.addr with cust.contaddr
	repl mailsdf.addr2 with cust.contaddr2
	repl mailsdf.city with cust.contcity
	repl mailsdf.state with cust.contstate
	repl mailsdf.zip with substr(cust.contzip,1,5)
	else
	repl mailsdf.schcode with cust.schcode+'K'
	repl mailsdf.schname with cust.schname
	repl mailsdf.fname with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl mailsdf.addr with cust.schaddr
	repl mailsdf.addr2 with cust.schaddr2
	repl mailsdf.city with cust.schcity
	repl mailsdf.state with cust.schstate
	repl mailsdf.zip with substr(cust.schzip,1,5)
endif		
endif
skip
enddo

sele mailsdf
copy to maillist.txt type delim
use
sele cust
use

