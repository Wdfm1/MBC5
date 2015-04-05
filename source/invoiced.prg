SET PATH TO m:\mbc5
USE quotes IN 0
SELECT quotes
SET ORDER TO schcode
GO top
SCAN FOR quotes.invoiced=.t.
replace quotes.bpovrde with.t.
ENDSCAN
IF USED("quotes")
SELECT quotes
USE
endif
WAIT WINDOW "done"