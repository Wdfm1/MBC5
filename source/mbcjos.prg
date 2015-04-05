	SET ESCAPE ON 
*!*	&&___________________________________
*!*	*add company value to field company in production
*!*	SET STEP ON 

*!*	USE produtn IN 0
*!*	SELECT produtn
*!*	SET ORDER TO invno
*!*	GO top
*!*	SCAN
*!*	IF produtn.vendcd="MER"
*!*	replace produtn.company WITH "MER"
*!*	ELSE
*!*	replace produtn.company WITH "MBC"
*!*	ENDIF
*!*	endscan
*!*	use

*!*	WAIT WINDOW "DONE"
*!*	&&______________________________________________________________________________________________________________________
*!*	* this is to be done before any Josten or New Meridian Record are added. Gives school name value in new schname field in produtn
*!*	SET STEP ON 
*!*	USE cust IN 0
*!*	SET ORDER TO SCHCODE   && SCHCODE 
*!*	SELECT cust
*!*	GO top
*!*	USE produtn IN 0
*!*	SELECT produtn
*!*	SET ORDER TO SCHCODE   && SCHCODE 
*!*	GO top 
*!*	SCAN
*!*	m.schcode=produtn.schcode
*!*	SELECT cust
*!*	SEEK m.schcode
*!*	IF FOUND()
*!*	m.schname=cust.schname
*!*	SELECT produtn
*!*	replace produtn.schname WITH m.schname
*!*	ENDIF

*!*	ENDSCAN
*!*	SELECT produtn
*!*	USE
*!*	SELECT cust
*!*	USE
*WAIT WINDOW "DONE"

*!*	&&add contryear values to produtn___________________________________________________________________________________________________________________
*!*	&&A lot of meridian records that did not have MER in the vendcd field was found here. Alot of MBC with out contryear.
*!*	SET STEP ON 
*!*	USE quotes IN 0
*!*	SELECT quotes
*!*	SET ORDER TO invno   && SCHCODE 
*!*	go top
*!*	USE produtn IN 0
*!*	SELECT produtn
*!*	SET ORDER TO invno   && SCHCODE 
*!*	GO top
*!*	SCAN
*!*	m.invno=produtn.invno
*!*	SELECT quotes
*!*	SEEK m.invno
*!*	IF FOUND()
*!*	m.contryear=quotes.contryear
*!*	SELECT produtn
*!*	replace produtn.contryear WITH m.contryear
*!*	ENDIF

*!*	ENDSCAN
*!*	SELECT produtn
*!*	USE
*!*	SELECT quotes
*!*	USE
*!*	&&WAIT WINDOW "DONE"

*!*	&& add company values to covers______________________________________________________________
*!*	SET STEP ON 
USE produtn IN 0
SELECT produtn
SET ORDER TO invno   
go top
USE covers IN 0
SELECT covers
SET ORDER TO invno   && SCHCODE 
GO top
SCAN
m.invno=covers.invno
SELECT produtn
SEEK m.invno
IF FOUND()
m.company=produtn.company
SELECT covers
replace covers.company WITH m.company
ENDIF

ENDSCAN
SELECT produtn
USE
SELECT covers
USE
 && WAIT WINDOW "DONE"
*!*	  
&&add MBC value to datecont.company and mktinfo.company all record will be MBC no Jostens yet. Meridian has no logs. (I looked)
USE datecont IN 0
SELECT datecont
GO top
SCAN
replace datecont.company WITH "MBC"
ENDSCAN
USE mktinfo IN 0
SELECT mktinfo
GO top
SCAN
replace mktinfo.company WITH "MBC"
ENDSCAN
USE
SELECT datecont
USE
WAIT WINDOW "DONE datecont"

* this is to be done before any Josten or New Meridian Record are added. Gives school name value in new schname field in recv2 and surv2
*!*	SET STEP ON 
USE cust IN 0
SET ORDER TO SCHCODE   && SCHCODE 
SELECT cust
GO top
USE recv2 IN 0
SELECT recv2
SET ORDER TO SCHCODE   && SCHCODE 
GO top 
SCAN
m.schcode=recv2.schcode
SELECT cust
SEEK m.schcode
IF FOUND()
m.schname=cust.schname
SELECT recv2
replace recv2.schname WITH m.schname
replace recv2.company WITH "MBC"
ENDIF

ENDSCAN
WAIT WINDOW "recv2 is done."
SET STEP ON 
SELECT recv2
USE
SELECT cust &&now do surv2
GO top
USE surv2 IN 0
SELECT surv2
SET ORDER TO schcode
GO top
SCAN
m.schcode=surv2.schcode
SELECT cust
SEEK m.schcode
IF FOUND()
m.schname=cust.schname
SELECT surv2
replace surv2.schname WITH m.schname
replace surv2.company WITH "MBC"
ENDIF
ENDSCAN
SELECT surv2
USE
SELECT cust
USE
WAIT WINDOW "done"


WAIT WINDOW "dddDONE"

