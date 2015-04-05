*Meridian records to vfp

SET ESCAPE on
SET NULL Off
USE mcust IN 0 EXCLUSIVE
*!*	use codecnt in 0 
tblno="m:\mbc5\mcust.xls"
oExcel=CreateObject("Excel.Application")
oWorkbook=oExcel.workbooks.Open(tblno)
aa=0
nprecode=77
FOR nrow=2 TO 20113  &&need to get total rows this is test rows

aa=aa+1
WAIT NOWAIT window STR(aa)+" of 20113"
*!*	sele codecnt
*!*	repl codecnt.schcode with codecnt.schcode+1
*!*	IF codecnt.schcode=9998
*!*	nprecode=nprecode+1
*!*	a=ASC(codecnt.precode)
*!*	replace codecnt.precode with ALLTRIM(STR(nprecode))
*!*	replace codecnt.schcode WITH 1000
*!*	aa=1
*!*	endif
*!*	m.schcode=codecnt.precode+str(codecnt.schcode,4)
 
&&client code
	m.clientcode=ALLTRIM(STR(oExcel.ActiveSheet.Range("A"+ALLTRIM(STR(nrow))).value))
*!*	tmpschname=oExcel.ActiveSheet.Range("S"+ALLTRIM(STR(nrow))).value 
*!*	m.schname=IIF(ISNULL(tmpschname),"NA",tmpschname)
*!*	tmpcsrep=ALLTRIM(oExcel.ActiveSheet.Range("AF"+ALLTRIM(STR(nrow))).value)
*!*	npos=AT(" ",tmpcsrep,1)
*!*	IF !ISNULL(tmpcsrep)
*!*	m.csrep=SUBSTR(tmpcsrep,1,1)+SUBSTR(tmpcsrep,npos+1,1)
*!*	ELSE
*!*	m.csrep=""
*!*	ENDIF
*!*	tmpschaddr=oExcel.ActiveSheet.Range("L"+ALLTRIM(STR(nrow))).value 
*!*	m.schaddr=IIF(ISNULL(tmpschaddr),"",tmpschaddr)
*!*	tmpschcity=oExcel.ActiveSheet.Range("M"+ALLTRIM(STR(nrow))).value 
*!*	m.schcity=IIF(ISNULL(tmpschcity),"",tmpschcity)
*!*	m.schstate=oExcel.ActiveSheet.Range("V"+ALLTRIM(STR(nrow))).value 
*!*	m.schzip=oExcel.ActiveSheet.Range("X"+ALLTRIM(STR(nrow))).value 
*!*	tmpschphone=oExcel.ActiveSheet.Range("U"+ALLTRIM(STR(nrow))).value 
*!*	m.schphone=IIF(ISNULL(tmpschphone),"",tmpschphone)
*!*	tmpschfax=oExcel.ActiveSheet.Range("R"+ALLTRIM(STR(nrow))).value
*!*	m.schfax=IIF(ISNULL(tmpschfax),"",tmpschfax) 
*!*	tmpcontemail=oExcel.ActiveSheet.Range("Q"+ALLTRIM(STR(nrow))).value
*!*	m.contemail=iif(isnull(tmpcontemail),"",tmpcontemail)


*!*	tmpwebsite= oExcel.ActiveSheet.Range("AO"+ALLTRIM(STR(nrow))).value
*!*	m.website=IIF(ISNULL(tmpwebsite),"",tmpwebsite) 
*!*	tmpcat=ALLTRIM(oExcel.ActiveSheet.Range("C"+ALLTRIM(STR(nrow))).value)
*!*	IF !ISNULL(tmpcat)
*!*	m.category =SUBSTR(tmpcat,1,2)
*!*	ELSE
*!*	m.category=""
*!*	endif
*!*	tmpleadsource=oExcel.ActiveSheet.Range("I"+ALLTRIM(STR(nrow))).value  
*!*	m.leadsource=IIF(ISNULL(tmpleadsource),"",tmpleadsource)
*!*	tmpdatetime=oExcel.ActiveSheet.Range("H"+ALLTRIM(STR(nrow))).value
*!*	 
*!*	TRY
*!*	a=ttod(tmpdatetime)
*!*	CATCH
*!*	a={//}
*!*	ENDTRY
*!*	m.dteschstart=a

*!*	tmpdatetime1=oExcel.ActiveSheet.Range("G"+ALLTRIM(STR(nrow))).value
*!*	try
*!*	b=ttod(tmpdatetime1)
*!*	CATCH
*!*	b={//}
*!*	endtry
*!*	m.dtenextcon=b
*!*	 
*!*	m.mktsegment=oExcel.ActiveSheet.Range("J"+ALLTRIM(STR(nrow))).value 
*!*	*!*	m.contryear=
*!*	tmpnextcallfr=oExcel.ActiveSheet.Range("AA"+ALLTRIM(STR(nrow))).value
*!*	m.nextcallfr=IIF(ISNULL(tmpnextcallfr),"",tmpnextcallfr)
*!*	tmpcurentprov=oExcel.ActiveSheet.Range("E"+ALLTRIM(STR(nrow))).value
*!*	m.curentprov=IIF(ISNULL(tmpcurentprov),"",tmpcurentprov) 
*!*	tmpaplus=oExcel.ActiveSheet.Range("Z"+ALLTRIM(STR(nrow))).value 
*!*	m.aplus=IIF(EMPTY(tmpaplus),.f.,.t.)
*!*	tmpbussagreee=oExcel.ActiveSheet.Range("B"+ALLTRIM(STR(nrow))).value 
*!*	m.bussagreee=IIF(EMPTY(tmpbussagreee),.f.,.t.)
&&contacts--------------------------------------------------------------------------------------------------
tmpnposition=oExcel.ActiveSheet.Range("O"+ALLTRIM(STR(nrow))).value
m.nposition= IIF(ISNULL(tmpnposition),"",tmpnposition)&&??????????????????????????????????????????????????????????

*!*	m.contfname= oExcel.ActiveSheet.Range("P"+ALLTRIM(STR(nrow))).value
*!*	tmplast=oExcel.ActiveSheet.Range("N"+ALLTRIM(STR(nrow))).value
*!*	noccurs=OCCURS(" ",tmplast)

*!*	IF !isnull(tmplast)
*!*	try
*!*	m.contlname=SUBSTR(tmplast,AT(" ",tmplast,noccurs)+1)
*!*	CATCH
*!*	m.contlname=""
*!*	endtry 
*!*	ELSE
*!*	m.contlname=""
*!*	endif
*!*	*!*	m.contphnwrk=oExcel.ActiveSheet.Range(""+ALLTRIM(STR(nrow))).value 
*!*	m.contphhom=oExcel.ActiveSheet.Range("AH"+ALLTRIM(STR(nrow))).value
*!*	tmpnomktmail= oExcel.ActiveSheet.Range("AB"+ALLTRIM(STR(nrow))).value 
*!*	m.nomktemail=IIF(tmpnomktmail="Y",.t.,.f.)
tmpnodirectmail=oExcel.ActiveSheet.Range("AC"+ALLTRIM(STR(nrow))).value &&??????????????????????????????
m.nodirectma=IIF(tmpnodirectmail="Y",.t.,.f.)
SELECT mcust
LOCATE FOR mcust.clientcode=m.clientcode
IF FOUND()
replace mcust.nodirectma WITH m.nodirectma
replace mcust.nposition WITH m.nposition
ELSE
MESSAGEBOX(m.clientcode +" not found")
endif
*!*	INSERT INTO mcust FROM memvar
ENDFOR&&rows
oExcel.quit
release all like o*
SELECT mcust
USE
SELECT codecnt
USE
WAIT WINDOW "done"



