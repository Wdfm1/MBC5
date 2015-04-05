* Run in m:\mbc5 directory
use boonlist order tag schcode of boonlist in 0 share
sele boonlist
use produtn order tag invno of produtn in 0 share
use quotes order tag schcode of quotes in 0 shar
use cust order tag schcode of cust in 0 share
sele cust
set dele on
set rela to schcode into quotes
sele quotes
set rela to invno into produtn
sele cust
go top
scan
if substr(produtn.prodno,1,2)='S5'
if upper(cust.yb_sth)='Y'
	m.schcode=cust.schcode+'Y'
	m.name = "Residence"
	m.attn = alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	m.add1 = cust.contaddr
	m.add2 = cust.contaddr2
	m.city = cust.contcity
	m.state = cust.contstate
	m.zip = substr(cust.contzip,1,5)
	m.fax = space(10)
	m.option1 = 'N'
	m.type1 = space(5)
	if !isblank(cust.contemail) .or. !isblank(cust.schemail)
	m.option2 = 'Y'
	m.type2 = 'email'
	if !isblank(cust.contemail)
	m.email = cust.contemail
	else
	m.email = cust.schemail
	endif
	else
	m.email = space(40)
	m.option2 = 'N'
	m.type2 = space(5)
	endif
	
	if isblank(cust.svdesc1)
	m.svdesc = "Ground"
	else
	m.svdesc = cust.svdesc1
	endif
else
	m.schcode=cust.schcode+'Y'
	m.name = cust.schname
	m.attn = alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	m.add1 = cust.schaddr
	m.add2 = cust.schaddr2
	m.city = cust.schcity
	m.state = cust.schstate
	m.zip = substr(cust.schzip,1,5)
	m.fax = space(10)
	m.option1 = 'N'
	m.type1 = space(5)
	if !isblank(cust.contemail) .or. !isblank(cust.schemail)
	m.option2 = 'Y'
	m.type2 = 'email'
	if !isblank(cust.contemail)
	m.email = cust.contemail
	else
	m.email = cust.schemail
	endif
	else
	m.email = space(40)
	m.option2 = 'N'
	m.type2 = space(5)
	endif

	if isblank(cust.svdesc1)
	m.svdesc = "Ground"
	else
	m.svdesc = cust.svdesc1
	endif
	endif
insert into boonlist from memvar
*****************************insert a record here******************************


if upper(cust.shiptocont)='Y'
	m.schcode=cust.schcode+'K' 
	m.name = "Residence"
	m.attn = alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	m.add1 = cust.contaddr
	m.add2 = cust.contaddr2
	m.city = cust.contcity
	m.state = cust.contstate
	m.zip = substr(cust.contzip,1,5)
	m.fax = space(10)
	m.option1 = 'N'
	m.type1 = space(5)
	if !isblank(cust.contemail) .or. !isblank(cust.schemail)
	m.option2 = 'Y'
	m.type2 = 'email'
	if !isblank(cust.contemail)
	m.email = cust.contemail
	else
	m.email = cust.schemail
	endif
	else
	m.email = space(40)
	m.option2 = 'N'
	m.type2 = space(5)
	endif

	if isblank(cust.svdesc2)
	m.svdesc = "Ground"
	else
	m.svdesc = cust.svdesc2
	endif
else
	m.schcode=cust.schcode+'K'
	m.name = cust.schname
	m.attn = alltrim(cust.contfname)+" "+alltrim(cust.contlname)
	m.add1 = cust.schaddr
	m.add2 = cust.schaddr2
	m.city = cust.schcity
	m.state = cust.schstate
	m.zip = substr(cust.schzip,1,5)
	m.fax = space(10)
	m.option1 = 'N'
	m.type1 = space(5)
	if !isblank(cust.contemail) .or. !isblank(cust.schemail)
	m.option2 = 'Y'
	m.type2 = 'email'
	if !isblank(cust.contemail)
	m.email = cust.contemail
	else
	m.email = cust.schemail
	endif
	else
	m.email = space(40)
	m.option2 = 'N'
	m.type2 = space(5)
	endif

	if isblank(cust.svdesc2)
	m.svdesc = "Ground"
	else
	m.svdesc = cust.svdesc2
	endif
endif		
insert into boonlist from memvar
endif
endscan

*******************************insert a record here*************************



