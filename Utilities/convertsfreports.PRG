local lcMetaData, ;
	lcReports, ;
	lcDBC, ;
	lcDatabase, ;
	laFields[1], ;
	lnFields, ;
	lcFields, ;
	lnI

* Get the meta data and reports tables.
	
lcMetaData = getfile('DBF', '', '', 0, 'Locate REPMETA.DBF')
if empty(lcMetaData)
	return
endif empty(lcMetaData)
lcReports = getfile('DBF', '', '', 0, 'Locate REPORTS.DBF')
if empty(lcReports)
	return
endif empty(lcReports)

* Open the meta data table.

close databases all
use (lcMetaData) alias REPMETA exclusive

* Ensure all the fields we need exist. If not, add them and fill in default
* values.

if type('REPMETA.HEADING') = 'U'
	alter table (lcMetaData) add column HEADING C(60)
	replace all HEADING with CAPTION for RECTYPE = 'F'
endif type('REPMETA.HEADING') = 'U'
if type('REPMETA.DATABASE') = 'U'
	alter table (lcMetaData) add column DATABASE C(60)
	lcDBC = getfile('DBC', '', '', 0, 'Locate Database')
	if empty(lcDBC)
		lcDatabase = 'FreeTables'
	else
		lcDatabase = juststem(lcDBC)
	endif empty(lcDBC)
	insert into REPMETA ;
			(RECTYPE, ;
			OBJECTNAME, ;
			ALIASCAP, ;
			CAPTION, ;
			HEADING, ;
			FIELDEXPR, ;
			REPORTABLE) ;
		values ;
			('D', ;
			lcDatabase, ;
			'VFP', ;
			lcDatabase, ;
			lcDatabase, ;
			lcDBC, ;
			.T.)
	replace all DATABASE with lcDatabase for RECTYPE <> 'D'
endif type('REPMETA.DATABASE') = 'U'
if type('REPMETA.ALLOWVALUE') = 'U'
	alter table (lcMetaData) add column ALLOWVALUE L
	replace ALLOWVALUE with not FIELDTYPE $ 'MG' for RECTYPE = 'F'
endif type('REPMETA.ALLOWVALUE') = 'U'
if type('REPMETA.JOINWEIGHT') = 'U'
	alter table (lcMetaData) add column JOINWEIGHT N(1)
	replace JOINWEIGHT with 1 for RECTYPE = 'R'
endif type('REPMETA.JOINWEIGHT') = 'U'
if type('REPMETA.ID') = 'U'
	alter table (lcMetaData) add column ID C(10)
	replace all ID with sys(2015)
endif type('REPMETA.ID') = 'U'
if type('REPMETA.PATH') = 'U'
	alter table (lcMetaData) rename column CURSORPATH to PATH
endif type('REPMETA.PATH') = 'U'

* Set other default values.

locate for REPORTABLE and RECTYPE = 'C'
if not found()
	replace all REPORTABLE with .T. for RECTYPE = 'C'
endif not found()
replace all CAPTION with lcDatabase for RECTYPE = 'R'

* Handle calculated fields.

scan for CALCULATED and empty(CALCFIELDS)
	lnFields = FieldsInExpr(@laFields, FIELDEXPR, trim(ALIAS))
	lcFields = ''
	for lnI = 1 to lnFields
		lcFields = lcFields + iif(empty(lcFields), '', ', ') + laFields[lnI]
	next lnI
	replace CALCFIELDS with lcFields
	if OBJECTNAME <> FIELDEXPR
		replace OUTPUTEXPR with FIELDEXPR, FIELDEXPR with trim(OBJECTNAME)
	endif OBJECTNAME <> FIELDEXPR
endscan for CALCULATED ...

* Create indexes.

index on upper(RECTYPE + OBJECTNAME) tag OBJECT
index on upper(ALIAS1 + ALIAS2)      tag RELATION
index on ALIAS                       tag ALIAS
index on REPORTABLE                  tag REPORTABLE
index on FILTERABLE                  tag FILTERABLE
index on upper(DATABASE)             tag DATABASE
index on deleted()                   tag DELETED
use

* Fix the reports table too.

use (lcReports) alias REPORTS exclusive
replace all DATACLS with 'SFQDataEngine', DATALIB with 'SFQFramework.VCX'
use
messagebox('SFReports files updated.', 0, 'Convert SFReports')

function FieldsInExpr
lparameters taFields, ;
	tcExpression, ;
	tcAlias
local lcExpression, ;
	lnFields, ;
	llAddAlias, ;
	lcWords, ;
	lnWords, ;
	lnI, ;
	lcWord, ;
	lnWord, ;
	lcChar, ;
	lcStart

* Define function and field delimiters in expressions.

#define ccDELIMITERS ' !#%^*()-+/,<>[]{}='

* Set up the variables we need. Because a space before an open paren can fool
* us, let's remove any we find (note that we can't use NORMALIZE() here because
* a field list like COMPANY, CITY is reduced to just COMPANY).

lcExpression = strtran(tcExpression, ' (', '(')
lnFields     = 0
llAddAlias   = vartype(tcAlias) = 'C' and not empty(tcAlias)
lcWords      = ''

* Initialize the array.

dimension taFields[1]
taFields[1] = ''

* Determine how many "words" there are in the expression, and then check each
* one. Count how many times each word occurs.

for lnI = 1 to len(ccDELIMITERS)
	lcDelimiter  = substr(ccDELIMITERS, lnI, 1)
	lcExpression = strtran(lcExpression, lcDelimiter, chr(13))
next lnI
lnWords = alines(laWords, lcExpression)
for lnI = 1 to lnWords
	lcWord  = laWords[lnI]
	lnWord  = occurs(lcWord + ',', lcWords) + 1
	lcWords = lcWords + lcWord + ','

* If this isn't a digit, see if it's a function (it's followed by an open
* paren; we need to check this specific occurrence of the word since it may
* appear more than once) or a keyword.

	if not empty(lcWord) and val(lcWord) = 0 and lcWord <> '0' and ;
		not upper(lcWord) == 'AND' and not upper(lcWord) == 'OR' and ;
		not upper(lcWord) == 'NOT'
		lcChar  = substr(tcExpression, at(lcWord, tcExpression, lnWord) + ;
			len(lcWord), 1)
		lcStart = left(lcWord, 1)
		if lcChar <> '(' and not lcStart $ ['"] and lcStart <> '['
			do case

* If the field starts and ends with ".", we likely have a logical value or
* .NULL., so ignore it.

				case left(lcWord, 1) = '.' and right(lcWord, 1) = '.'
					loop

* If we have a ". in the word, that's likely because we have an alias with a
* space surrounded by quotes (which got split into two words), so combine them
* back together.

				case '".' $ lcWord and lnI > 1
					lcWord = laWords[lnI - 1] + ' ' + lcWord

* If we have a ." in the word, that's likely because we have a field name with
* a space surrounded by quotes (which got split into two words), so combine
* them back together.

				case '."' $ lcWord and lnI < lnWords
					lcWord = lcWord + ' ' + laWords[lnI + 1]
					laWords[lnI + 1] = ''

* If we have "." in the word, that's likely because we have both an alias and
* a field name with a space surrounded by quotes (which got split into three
* words), so combine them back together.

				case '"."' $ lcWord and lnI > 1 and lnI < lnWords
					lcWord = laWords[lnI - 1] + ' ' + lcWord + ' ' + ;
						laWords[lnI + 1]
					laWords[lnI + 1] = ''
			endcase

* Add an alias to the name if necessary. If the word isn't already in the
* array, add it.

			if llAddAlias and not '.' $ lcWord
				lcWord = tcAlias + '.' + lcWord
			endif llAddAlias ...
			if ascan(taFields, lcWord) = 0
				lnFields = lnFields + 1
				dimension taFields[lnFields]
				taFields[lnFields] = lcWord
			endif ascan(taFields, lcWord) = 0
		endif lcChar <> '(' ...
	endif not empty(lcWord) ...
next lnI
return lnFields
