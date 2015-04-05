tblno="m:\mbc5\atable\allprc12.xlsx"
USE m:\mbc5\atable\goldsc12.dbf IN 0 &&set to correct table
USE bpcol IN 0
SET STEP ON 

oExcel=CreateObject("Excel.Application")
oWorkbook=oExcel.workbooks.Open(tblno)
osheet=oworkbook.activesheet

SELECT goldsc12
GO top
SCAN
ncopies=goldsc12.copies
SELECT bpcol
GO top
	LOCATE FOR bpcol.nocopies=ncopies
	IF FOUND()
thecol=ALLTRIM(bpcol.colno)
rownum=155   && set one row before actual data
FOR pgnum=16 TO 136 STEP 4
rownum=rownum+1
fname="goldsc12.pg"+ALLTRIM(STR(pgnum))

cellno=thecol+ALLTRIM(STR(rownum))

AA=oExcel.activesheet.Range(cellno).value
TRY 

replace &fname WITH oExcel.activesheet.Range(cellno).value
CATCH
replace &fname WITH 0
ENdtry

ENDFOR
endif
endscan



		oExcel.quit
	release all like o*
WAIT WINDOW "done"






