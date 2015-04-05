SET STEP ON 
CREATE CURSOR badinvoice (schname char (34),invno int,schcode char (6),invtot num (2),quotetot num (2))
USE produtn IN 0
SELECT produtn
SET ORDER TO invno
USE invoice IN 0
SELECT invoice
SET ORDER TO invno
USE quotes IN 0
SELECT quotes
SET ORDER TO invno
SELECT produtn
SCAN FOR contryear ="12"
m.invno=produtn.invno
SELECT quotes
SEEK m.invno

IF FOUND()
m.adjbef=quotes.adjbef
m.schname=quotes.schname
m.schcode=quotes.schcode
ELSE
MESSAGEBOX("Quotes.invoice number "+STR(invno)+" not found.")
endif
SELECT invoice
SEEK m.invno
IF FOUND()
IF m.adjbef<>invoice.invtot
MESSAGEBOX("Sales Screen total= "+STR(m.adjbef)+" Invoice total= "+ STR(invoice.invtot)+ STR(invno))
SELECT badinvoice
APPEND blank
replace schname WITH m.schname
replace invno WITH m.invno
replace schcode WITH m.schcode
replace invtot WITH invoice.invtot
replace quotetot WITH m.adjbef

endif
*!*	else
*!*	MESSAGEBOX("INVOICE invoice "+STR(invno)+" not found.")
ENDIF
SELECT produtn
endscan
