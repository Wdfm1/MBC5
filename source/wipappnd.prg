sele wip
appe blank
repl wip.schcode with cust.schcode
repl wip.invno with quotes.invno
use wipsdata in 0
if not file('wipsdata.cdx')
 inde on bktype tag bktype
endif
sele wipsdata
set order to tag Bktype of wipsdata.cdx
sele cust
datasrch=cust.booktype
sele wipsdata
seek datasrch
if found()
sele cust
repl wip.dtoprod with produtn.kitrecvd+wipsdata.l_dtoprod
	if dow(wip.dtoprod)=1
	 repl wip.dtoprod with wip.dtoprod+1
	endif
	if dow(wip.dtoprod)=7
	 repl wip.dtoprod with wip.dtoprod+2
	endif  
if wipsdata.l_dpstup<>0
repl wip.dpstup with produtn.kitrecvd+wipsdata.l_dpstup
	if dow(wip.dpstup)=1
	 repl wip.dpstup with wip.dpstup+1
	endif
	if dow(wip.dpstup)=7
	 repl wip.dpstup with wip.dpstup+2
	endif
endif
if wipsdata.l_dpstup2<>0
repl wip.dpstup2 with produtn.kitrecvd+wipsdata.l_dpstup2
	if dow(wip.dpstup2)=1
	 repl wip.dpstup2 with wip.dpstup2+1
	endif
	if dow(wip.dpstup2)=7
	 repl wip.dpstup2 with wip.dpstup2+2
	endif
endif
if wipsdata.l_dsntprf<>0
repl wip.dsntprf with produtn.kitrecvd+wipsdata.l_dsntprf
	if dow(wip.dsntprf)=1
	 repl wip.dsntprf with wip.dsntprf+1
	endif
	if dow(wip.dsntprf)=7
	 repl wip.dsntprf with wip.dsntprf+2
	endif
endif
if wipsdata.l_dprfback<>0
repl wip.dprfback with produtn.kitrecvd+wipsdata.l_dprfback
	if dow(wip.dprfback)=1
	 repl wip.dprfback with wip.dprfback+1
	endif
	if dow(wip.dprfback)=7
	 repl wip.dprfback with wip.dprfback+2
	endif
endif
repl wip.dcamera with produtn.kitrecvd+wipsdata.l_dcamera
	if dow(wip.dcamera)=1
	 repl wip.dcamera with wip.dcamera+1
	endif
	if dow(wip.dcamera)=7
	 repl wip.dcamera with wip.dcamera+2
	endif  
repl wip.dline with produtn.kitrecvd+wipsdata.l_dline
	if dow(wip.dline)=1
	 repl wip.dline with wip.dline+1
	endif
	if dow(wip.dline)=7
	 repl wip.dline with wip.dline+2
	endif  
repl wip.dstrip with produtn.kitrecvd+wipsdata.l_dstrip
	if dow(wip.dstrip)=1
	 repl wip.dstrip with wip.dstrip+1
	endif
	if dow(wip.dstrip)=7
	 repl wip.dstrip with wip.dstrip+2
	endif  
if wipsdata.l_dckstrip<>0
repl wip.dckstrip with produtn.kitrecvd+wipsdata.l_dckstrip
	if dow(wip.dckstrip)=1
	 repl wip.dckstrip with wip.dckstrip+1
	endif
	if dow(wip.dckstrip)=7
	 repl wip.dckstrip with wip.dckstrip+2
	endif
endif
repl wip.dpress with produtn.kitrecvd+wipsdata.l_dpress
	if dow(wip.dpress)=1
	 repl wip.dpress with wip.dpress+1
	endif
	if dow(wip.dpress)=7
	 repl wip.dpress with wip.dpress+2
	endif  
repl wip.dcheck with produtn.kitrecvd+wipsdata.l_dcheck
	if dow(wip.dcheck)=1
	 repl wip.dcheck with wip.dcheck+1
	endif
	if dow(wip.dcheck)=7
	 repl wip.dcheck with wip.dcheck+2
	endif  
repl wip.dbind with produtn.kitrecvd+wipsdata.l_dbind
	if dow(wip.dbind)=1
	 repl wip.dbind with wip.dbind+1
	endif
	if dow(wip.dbind)=7
	 repl wip.dbind with wip.dbind+2
	endif  
repl wip.dship with produtn.kitrecvd+wipsdata.l_dship
	if dow(wip.dship)=1
	 repl wip.dship with wip.dship+1
	endif
	if dow(wip.dship)=7
	 repl wip.dship with wip.dship+2
	endif  
repl produtn.prshpdte with produtn.kitrecvd+wipsdata.l_dship
	if dow(produtn.prshpdte)=1
	 repl produtn.prshpdte with produtn.prshpdte+1
	endif
	if dow(produtn.prshpdte)=7
	 repl produtn.prshpdte with produtn.prshpdte+2
	endif  
repl produtn.warndate with produtn.kitrecvd+wipsdata.l_dbind
	if dow(produtn.warndate)=1
	 repl produtn.warndate with produtn.warndate+1
	endif
	if dow(produtn.warndate)=7
	 repl produtn.warndate with produtn.warndate+2
	endif 
endif
if ! empty(produtn.tovend)
 if upper(substr(produtn.vendcd,1,2))<>'MB'
vensrch=produtn.vendcd
sele vendor
set order to tag vendcd
seek vensrch
if found()
repl wip.dfrmvend with produtn.tovend+vchrno
endif
*else
* repl wip.dfrmvend with wip.dbind
endif
sele cust

endif
repl wip.aship with produtn.shpdate
sele wipsdata
use

sele produtn
 