SELECT ffrditmf
a=0
b=0
SCAN
a=a+1
m.caption=ALLTRIM(UPPER(ffrditmf.rdi_name))
m.objectname=ALLTRIM(UPPER(ffrditmf.rdi_rptexp))
SELECT repmeta
LOCATE FOR ALLTRIM(UPPER(repmeta.objectname))=m.objectname
IF FOUND()
b=b+1
	replace repmeta.caption WITH m.caption
GO top
ELSE 
*!*			SET STEP ON 
ENDIF
WAIT NOWAIT WINDOW "Record No. "+STR(a) +" Records found "+ STR(b)
SELECT ffrditmf 
endscan