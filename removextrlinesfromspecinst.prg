*	SELECT schcode FROM covers WHERE OCCURS("Year 11 instructions:",covers.specinst)>2 INTO CURSOR "t"
a=0
SET STEP ON 
USE covers IN 0
SELECT covers
SCAN FOR OCCURS("Year 11 instructions:",covers.specinst)>2

cstring=covers.specinst
ntime=OCCURS("Year 11 instructions:",covers.specinst)
nstart=AT("Year 11 instructions:",covers.specinst,ntime)


newstring=SUBSTR(cstring,nstart)
replace covers.specinst WITH newstring
ENDSCAN
