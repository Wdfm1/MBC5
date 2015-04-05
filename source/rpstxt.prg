use rpslist in 0 excl
sele rpslist
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
sele rpslist
appe blank
sele cust
if upper(yb_sth)='Y'
	repl rpslist.schcode with cust.schcode+'Y'
*	repl rpslist.schname with cust.schname
	repl rpslist.contname with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl rpslist.addr1 with cust.contaddr
	repl rpslist.addr2 with cust.contaddr2
	repl rpslist.city with cust.contcity
	repl rpslist.state with cust.contstate
	repl rpslist.zipcode with cust.contzip
	repl rpslist.comm_res with 'R'
	else
	repl rpslist.schcode with cust.schcode+'Y'
	repl rpslist.schname with cust.schname
	repl rpslist.contname with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl rpslist.addr1 with cust.schaddr
	repl rpslist.addr2 with cust.schaddr2
	repl rpslist.city with cust.schcity
	repl rpslist.state with cust.schstate
	repl rpslist.zipcode with cust.schzip
	repl rpslist.comm_res with 'C'
endif
sele rpslist
appe blank
sele cust
if upper(shiptocont)='Y'
	repl rpslist.schcode with cust.schcode+'K'
*	repl rpslist.schname with cust.schname
	repl rpslist.contname with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl rpslist.addr1 with cust.contaddr
	repl rpslist.addr2 with cust.contaddr2
	repl rpslist.city with cust.contcity
	repl rpslist.state with cust.contstate
	repl rpslist.zipcode with cust.contzip
	repl rpslist.comm_res with 'R'
	else
	repl rpslist.schcode with cust.schcode+'K'
	repl rpslist.schname with cust.schname
	repl rpslist.contname with alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	repl rpslist.addr1 with cust.schaddr
	repl rpslist.addr2 with cust.schaddr2
	repl rpslist.city with cust.schcity
	repl rpslist.state with cust.schstate
	repl rpslist.zipcode with cust.schzip
	repl rpslist.comm_res with 'C'
endif		

skip
enddo

sele rpslist
copy to rpslist.txt type sdf
use
sele cust
use
