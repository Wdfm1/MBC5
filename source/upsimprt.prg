*use m:\mbc5\upsexp in 0 shar
*use m:\mbc5\shipping in 0 shar
sele shipping 
set order to schcode
sele upsexp
set order to
go top
do while ! eof()
if val(substr(custid,1,6))>0 .and. mbcpost=.f.
m.schcode=substr(custid,1,6)
if substr(shipdte,1,2)='20'
m.via='FEDERAL EXPRESS'
m.day1=substr(shipdte,7,2)
m.mo1=substr(shipdte,5,2)
m.yr1=substr(shipdte,1,4)
m.dteship=ctod(m.day1+"/"+m.mo1+"/"+m.yr1)
else
m.dteship=ctod(shipdte)
m.via='UPS'
endif
m.trackno=trackno
if val(nobooks)>0
m.nobooks=val(nobooks)
else
m.nobooks=0
endif
do case
case itmshp='92530'
	m.itemshpd='Books'
case itmshp='73630'
	m.itemshpd='Inquiries'	
case itmshp='92630'
	m.itemshpd='Kits or Extras'
case itmshp='92730'
	m.itemshpd='Pasteup'
case itmshp='72810'
	m.itemshpd=''	
case itmshp='59830'
	m.itemshpd=''	
endcase
if val(noboxes)>0
m.nobox=val(noboxes)
else
m.nobox=0
endif
if val(totwght)>0
m.weight=val(totwght)
else
m.weight=0
endif
if val(totcost)>0
m.shpcost=val(totcost)
else
m.shpcost=0
endif
if val(substr(howshp,2,2))>0
do case
	case howshp='F14'
	m.shptype='Express Saver'
	case howshp='F01'
	m.shptype='Priority Overnight'	
	case howshp='F03'
	m.shptype='Priority Overnight Pak'
	case howshp='F06'
	m.shptype='Standard Overnight'
	case howshp='F07'
	m.shptype='Standard Overnight Letter'
	case howshp='F08'
	m.shptype='Standard Overnight Pak'
	case howshp='F11'
	m.shptype='2 Day'
	case howshp='F15'
	m.shptype='1Day Freight'
	case howshp='F16'
	m.shptype='2Day Freight'
	case howshp='F17'
	m.shptype='3Day Freight'
	case howshp='F18'
	m.shptype='First Overnight'
	case howshp='F19'
	m.shptype='First Overnight Letter'
	case howshp='F20'
	m.shptype='2Day Letter'
	case howshp='F21'
	m.shptype='2Day Pak'
	case howshp='F02'
	m.shptype='Priority Overnight Letter'
	case howshp='F04'
	m.shptype='Priority Overnight Box'
	case howshp='F09'
	m.shptype='Standard Overnight Box'
endcase
else
m.shptype=howshp
endif
insert into shipping from memvar
repl mbcpost with .t.
endif
skip
enddo
*sele shipping 
*use
*sele upsexp
*use
