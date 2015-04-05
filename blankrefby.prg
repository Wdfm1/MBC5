*Blank old values in cust.refby field that are no longer used
a=0
b=0
use cust in 0  

&& set to school name so will be able to have some alphabetical reference incase of an error in mid stream.
set order to schname 
use oldcodes in 0 excl

select oldcodes
scan &&scan each old value
a=a+1
wait nowait window "Scanning for value "+alltrim(str(a))
select cust
scan for upper(alltrim(cust.refby))=upper(alltrim(oldcodes.choice))&&scan cust table for values
	replace cust.refby with ""
b=b+1
endscan
endscan

select oldcodes
use
select cust 
use

wait window "Scanned for "+alltrim(str(a))+" different old values."
wait window "Blanked out "+alltrim(str(b))+" records"