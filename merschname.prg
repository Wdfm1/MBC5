**add schname to meridian production Meridian has prodno after name for each year
aa=0
SET STEP ON 
USE produtn IN 0
SELECT produtn
SET ORDER TO invno
USE quotes IN 0
SELECT quotes
SET ORDER TO invno
SELECT produtn
SCAN FOR company="MER"
IF produtn.schcode="052923"
SET STEP ON 
endif
m.invno=produtn.invno
SELECT quotes
SEEK m.invno
IF FOUND()
m.schname=quotes.schname
SELECT produtn
replace produtn.schname WITH m.schname
aa=aa+1
ENDIF
SELECT produtn

ENDSCAN
WAIT WINDOW STR(aa)