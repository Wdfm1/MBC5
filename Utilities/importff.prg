lparameters tcPreferFile, ;
	tcReportsTable, ;
	tcMetaDataTable, ;
	tcQuery
local lcReportsTable, ;
	lcMetaDataTable, ;
	lcQuery, ;
	loUtility, ;
	lcPreferFile, ;
	lcFFDir, ;
	lnFolder, ;
	lnTemplate, ;
	RECTYPE, ;
	REPORTCLS, ;
	REPORTLIB, ;
	FOLDERS, ;
	ALLOWFILT, ;
	ALLOWSORT, ;
	REP_TYPE, ;
	LEFTMARGIN, ;
	ORIENTAT, ;
	SUMMARY, ;
	SHOWFILTER, ;
	CREATEDBY, ;
	CREATEDAT, ;
	TEMPLATE, ;
	lcRequestFile, ;
	lcItemFile, ;
	llReturn, ;
	llHaveHDJust, ;
	NAME, ;
	HEADER, ;
	lnField, ;
	lnI, ;
	lcField, ;
	laFields[1], ;
	lnFields, ;
	lcAlias, ;
	lnWidth, ;
	lcTotal, ;
	lcCaption, ;
	lcPicture, ;
	lnAlign, ;
	lcAliasCaption, ;
	loQuery, ;
	lcConnection, ;
	llNoConnection, ;
	lnCondition, ;
	lcSpace, ;
	lcOperator, ;
	loCondition, ;
	lcValue, ;
	laValues[1], ;
	lnValues, ;
	lnStrict, ;
	lnJ, ;
	luValue, ;
	loOperator, ;
	lcOpClass, ;
	lcValueType, ;
	lcValues, ;
	lnSorts, ;
	laSorts[1]
external array FLD_KEY, ;
	FLT_KEY, ;
	FLT_ASK, ;
	FLT_OPR, ;
	FLT_VAL, ;
	FLT_VOP, ;
	FLT_NOT, ;
	SRT_KEY, ;
	SRT_ORD, ;
    SRT_GRP
private oLocalizer

* Ensure we have valid parameters.
SET STEP ON 
if vartype(tcReportsTable) <> 'C' or empty(tcReportsTable) or ;
	not file(forceext(tcReportsTable, 'DBF'))
	lcReportsTable = 'REPORTS.DBF'
	if not file(lcReportsTable)
		lcReportsTable = getfile('DBF', '', '', 0, 'Locate REPORTS.DBF')
		if empty(lcReportsTable)
			return
		endif empty(lcReportsTable)
	endif not file(lcReportsTable)
else
	lcReportsTable = tcReportsTable
endif vartype(tcReportsTable) <> 'C' ...
if vartype(tcMetaDataTable) <> 'C' or empty(tcMetaDataTable) or ;
	not file(forceext(tcMetaDataTable, 'DBF'))
	lcMetaDataTable = 'REPMETA.DBF'
	if not file(lcMetaDataTable)
		lcMetaDataTable = getfile('DBF', '', '', 0, 'Locate REPMETA.DBF')
		if empty(lcMetaDataTable)
			return
		endif empty(lcMetaDataTable)
	endif not file(lcMetaDataTable)
else
	lcMetaDataTable = tcMetaDataTable
endif vartype(tcMetaDataTable) <> 'C' ...
if vartype(tcQuery) <> 'C' or empty(tcQuery) or ;
	not file(forceext(tcQuery, 'EXE'))
	lcQuery = 'SFQuery.exe'
	if not file(lcQuery)
		lcQuery = getfile('EXE', '', '', 0, 'Locate SFQUERY.EXE')
		if empty(lcQuery)
			return
		endif empty(lcQuery)
	endif not file(lcQuery)
else
	lcQuery = tcQuery
endif vartype(tcQuery) <> 'C' ...

* Open the reports and meta data tables.

use in select('SFREPORTS')
use in select('REPMETA')
use in select('SECURITY')
use (lcReportsTable)  alias SFREPORTS again shared in 0
use (lcMetaDataTable) alias REPMETA   again shared in 0
use (addbs(justpath(lcReportsTable)) + 'SECURITY') again shared in 0

* Create some helper objects.

loUtility  = newobject('SFUtility',  'SFUtility.vcx',  lcQuery)
oLocalizer = newobject('SFLocalize', 'SFLocalize.vcx', lcQuery)
oLocalizer.cLanguage      = 'English'
oLocalizer.cResourceTable = 'SQResource.dbf'

* Create fields, sort, and filter cursors.

create cursor FIELD ;
	(FIELDNAME C(128), ;
	HEADING C(128), ;
	ORDER I, ;
	WIDTH I, ;
	FONTBOLD L, ;
	FONTITALIC L, ;
	FONTUNDERLINE L, ;
	ALIGNMENT N(1), ;
	FORMAT M, ;
	INPUTMASK M, ;
	HPOSITION I, ;
	VPOSITION I, ;
	GROUP N(2), ;
	TOTALTYPE C(1), ;
	FORECOLOR I, ;
	BACKCOLOR I, ;
	SUPPRESS L, ;
	GROUPCOUNT L, ;
	FONTNAME C(40), ;
	FONTSIZE N(3), ;
	AUTOFIT L, ;
	NEWPAGE L, ;
	RESETPAGE L, ;
	DESCENDING L, ;
	INCLUDEALLFIELDS L, ;
	ALIASCAPTION C(128), ;
	BOOKMARK L, ;
	DATATRIM N(1), ;
	MEMBERDATA M, ;
	USEDEFAULTFORMAT L)
create cursor SORTFIELD ;
	(FIELDNAME C(128), ;
	ASCENDING L, ;
	GROUP L, ;
	ORDER N(3))
create cursor CONDITION ;
	(CONNECTION C(10), ;
	FIELDNAME C(128), ;
	OPERCLASS C(40), ;
	VALUES M, ;
	CASE L, ;
	PROMPT L, ;
	VALUETYPE C(10))

* Open FFPREFER.

if vartype(tcPreferFile) <> 'C' or empty(tcPreferFile)
	lcPreferFile = 'FFPREFER.DBF'
	if not file(lcPreferFile)
		lcPreferFile = getfile('DBF', '', '', 0, 'Select FFPREFER File')
		if empty(lcPreferFile)
			return
		endif empty(lcPreferFile)
	endif not file(lcPreferFile)
else
	lcPreferFile = tcPreferFile
endif vartype(tcPreferFile) <> 'C' ...
if used('FFPREFER')
	select FFPREFER
else
	select 0
	use (lcPreferFile) alias FFPREFER
endif used('FFPREFER')
lcFFDir = addbs(justpath(dbf()))
wait window 'Processing reports...' nowait

* Find or create the Imported Reports folder.

if not seek('FIMPORTED REPORTS', 'SFREPORTS', 'NAME')
	insert into SFREPORTS (RECTYPE, NAME) values ('F', 'Imported Reports')
	insert into SECURITY (TYPE, ROLE, ELEMENT, RIGHTS) ;
		values ('F', 1, SFREPORTS.ID, 2)
endif not seek('FIMPORTED REPORTS', 'SFREPORTS', 'NAME')
lnFolder = SFREPORTS.ID

* Find the standard template.

= seek('TSTANDARD', 'SFREPORTS', 'NAME')
lnTemplate = SFREPORTS.ID

* Set the fixed report properties.

RECTYPE    = 'R'
REPORTCLS  = 'SFReportQuick'
REPORTLIB  = 'SFReports.vcx'
FOLDERS    = '#' + transform(lnFolder) + '#'
ALLOWFILT  = .T.
ALLOWSORT  = .T.
REP_TYPE   = 'Q'
LEFTMARGIN = 0
ORIENTAT   = 0
SUMMARY    = .F.
SHOWFILTER = .T.
CREATEDBY  = 'ADMIN'
CREATEDAT  = datetime()
TEMPLATE   = lnTemplate

* Go through the requests.
 
scan
	lcRequestFile = juststem(PF_RQSTFL)
	lcItemFile    = juststem(PF_DITEMFL)
	llReturn      = (file(forceext(lcFFDir + lcItemFile, 'DBF')) or ;
		used('RPT_DITEM')) and ;
		(file(forceext(lcFFDir + lcRequestFile, 'DBF')) or used('REQUEST'))
	if llReturn
		if not used('RPT_DITEM')
			use (lcFFDir + lcItemFile) alias RPT_DITEM in 0
		endif not used('RPT_DITEM')
		llHaveHDJust = type('RPT_DITEM.RDI_HDJUST') = 'C'
		if used('REQUEST')
			select REQUEST
		else
			select 0
			use (lcFFDir + lcRequestFile) alias REQUEST
		endif used('REQUEST')
		scan

* Get the values for a new records in the reports table.

			NAME   = CreateUniqueReportName(alltrim(alltrim(RQ_NAME) + ' ' + ;
				RQ_DESC))
			HEADER = M.NAME
			insert into SFREPORTS from memvar
			insert into SECURITY (TYPE, ROLE, ELEMENT, RIGHTS) ;
				values ('R', 1, SFREPORTS.ID, 2)

* Get the fields to include in the report.

			restore from memo RQ_FLDVARS additive
			zap in FIELD
			select RPT_DITEM
			lnField = 0
			for lnI = 1 to FLD_CNT
				lcField = FLD_KEY[lnI]
				locate for RDI_NAME = padr(lcField, len(RDI_NAME))
				if found()
					lnFields = loUtility.FieldsInExpr(@laFields, RDI_RPTEXP)
					lcField  = upper(laFields[1])
					if seek('F' + padr(lcField, len(REPMETA.OBJECTNAME)), ;
						'REPMETA', 'OBJECT')
						lcAlias   = trim(RDI_ALIAS1)
						lnWidth   = RDI_RPTWID
						lcTotal   = iif(RDI_SUBTOT = 'Y', 'S', 'N')
						lcCaption = alltrim(alltrim(RDI_HDR1) + ' ' + RDI_HDR2)
						lcPicture = alltrim(RDI_OTPICT)
						if empty(strtran(lcPicture, 'X'))
							lcPicture = ''
						endif empty(strtran(lcPicture, 'X'))
						do case
							case llHaveHDJust and RDI_HDJUST = 'R'
								lnAlign = 1
							case llHaveHDJust and RDI_HDJUST = 'C'
								lnAlign = 2
							case RDI_FLDTYP $ 'NFIBY'
								lnAlign = 1
							otherwise
								lnAlign = 0
						endcase
						lcAliasCaption = trim(REPMETA.ALIASCAP)
						lnField        = lnField + 1
						insert into FIELD values ;
							(lcField, ;
							lcCaption, ;
							lnField, ;
							lnWidth, ;
							.F., ;
							.F., ;
							.F., ;
							lnAlign, ;
							'', ;
							lcPicture, ;
							-1, ;
							-1, ;
							0, ;
							lcTotal, ;
							-1, ;
							-1, ;
							.F., ;
							.F., ;
							'', ;
							0, ;
							.T., ;
							.F., ;
							.F., ;
							.F., ;
							.F., ;
							lcAliasCaption, ;
							.F., ;
							1, ;
							'', ;
							.T.)
						blank fields FONTSIZE in FIELD
					endif seek('F' ...
				endif found()
			next lnI

* Get the filter information.

			select REQUEST
			restore from memo RQ_FLTVARS additive
if inlist(REQUEST.RQ_NAME, 'BOOKED', 'COMBLANK')

endif
			if FLT_CNT > 0
				loQuery = newobject('SFQuery', 'SFQuery.vcx', lcQuery)
				zap in CONDITION
				select RPT_DITEM
				lcConnection   = ''
				lnCondition    = 0
				llNoConnection = .F.
				for lnI = 1 to FLT_CNT
					lcField = FLT_KEY[lnI]
					do case
						case empty(lcField) and lnI = 1
							llNoConnection = .T.
							loop
						case empty(lcField)
							lcSpace      = iif(FLT_OPR[lnI] = 'OR', ' ', '')
							lcConnection = lcConnection + lcSpace + ;
								lower(FLT_OPR[lnI]) + lcSpace
							do case
								case trim(lcConnection) = ')'
									lcConnection = ') and '
								case trim(lcConnection) = '('
									lcConnection = ' and ('
							endcase
							loop
					endcase
					locate for RDI_NAME = padr(lcField, len(RDI_NAME))
					if found()
						lnFields = loUtility.FieldsInExpr(@laFields, ;
							RDI_RPTEXP)
						lcField  = upper(laFields[1])
						do case
							case not seek('F' + ;
								padr(lcField, len(REPMETA.OBJECTNAME)), ;
								'REPMETA', 'OBJECT')
								loop
							case upper(REPMETA.CLASS) = 'SFQENUMCOMBOBOX'
								lcOperator = 'sfoperator' + ;
									iif(FLT_NOT[lnI] = 'Is Not', 'not', '') + ;
										'equals'
							case ((FLT_OPR[lnI] = '= or After' or ;
								FLT_OPR[lnI] = 'More or = to' or ;
								FLT_OPR[lnI] = 'On or After') and ;
								FLT_NOT[lnI] = 'Is') or ;
								((FLT_OPR[lnI] = 'Before or =' or ;
								FLT_OPR[lnI] = 'Less or = to' or ;
								FLT_OPR[lnI] = 'On or Before') and ;
								FLT_NOT[lnI] = 'Is Not')
								lcOperator = 'sfoperatorgreaterequal'
							case ((FLT_OPR[lnI] = '= or After' or ;
								FLT_OPR[lnI] = 'More or = to' or ;
								FLT_OPR[lnI] = 'On or After') and ;
								FLT_NOT[lnI] = 'Is Not') or ;
								((FLT_OPR[lnI] = 'Before or =' or ;
								FLT_OPR[lnI] = 'Less or = to' or ;
								FLT_OPR[lnI] = 'On or Before') and ;
								FLT_NOT[lnI] = 'Is')
								lcOperator = 'sfoperatorlessequal'
							case ((FLT_OPR[lnI] = 'After' or ;
								FLT_OPR[lnI] = 'More Than') and ;
								FLT_NOT[lnI] = 'Is') or ;
								((FLT_OPR[lnI] = 'Before' or ;
								FLT_OPR[lnI] = 'Less Than') and ;
								FLT_NOT[lnI] = 'Is Not')
								lcOperator = 'sfoperatorgreater'
							case ((FLT_OPR[lnI] = 'After' or ;
								FLT_OPR[lnI] = 'More Than') and ;
								FLT_NOT[lnI] = 'Is Not') or ;
								((FLT_OPR[lnI] = 'Before' or ;
								FLT_OPR[lnI] = 'Less Than') and ;
								FLT_NOT[lnI] = 'Is')
								lcOperator = 'sfoperatorlessthan'
							case FLT_OPR[lnI] = 'Equal to' or ;
								FLT_OPR[lnI] = 'Exactly Like'
								lcOperator = 'sfoperator' + ;
									iif(FLT_NOT[lnI] = 'Is Not', 'not', '') + ;
										'equals'
							case FLT_OPR[lnI] = 'Between'
								lcOperator = 'sfoperator' + ;
									iif(FLT_NOT[lnI] = 'Is Not', 'not', '') + ;
										'between'
							case FLT_OPR[lnI] = 'In the List:'
								lcOperator = 'sfoperator' + ;
									iif(FLT_NOT[lnI] = 'Is Not', 'not', '') + ;
										'inlist'
							case FLT_OPR[lnI] = 'Contains'
								lcOperator = 'sfoperator' + ;
									iif(FLT_NOT[lnI] = 'Is Not', 'not', '') + ;
										'contains'
							case FLT_OPR[lnI] = 'Like'
								lcOperator = 'sfoperator' + ;
									iif(FLT_NOT[lnI] = 'Is Not', 'not', '') + ;
										'begins'
							case FLT_OPR[lnI] = 'Empty' or ;
								FLT_OPR[lnI] = 'Zero' or FLT_OPR[lnI] = 'Blank'
								lcOperator = 'sfoperator' + ;
									iif(FLT_NOT[lnI] = 'Is Not', 'not', '') + ;
										'blank'
						endcase
						loCondition = newobject('SFCondition', 'SFQuery.vcx', lcQuery)
						lcValue     = FLT_VAL[lnI]
						if lcValue = '(ask'
							lcValue = ''
						endif lcValue = '(ask'
						lnValues = alines(laValues, lcValue, .F., ',')

* If we have a "between" operator but don't have 2 values, ensure we have 2
* values.

						if 'between' $ lcOperator and lnValues < 2
							lnValues = 2
							dimension laValues[2]
							for lnJ = 1 to 2
								if vartype(laValues[lnJ]) <> 'C'
									laValues[lnJ] = ''
								endif vartype(laValues[lnJ]) <> 'C'
							next lnJ
						endif 'between' $ lcOperator ...

* Handle the values.

						dimension loCondition.aValues[lnValues, 2]
						lnStrict = set('STRICTDATE')
						set strictdate to 0
						for lnJ = 1 to lnValues
							lcValue = laValues[lnJ]
							do case
								case FLT_VOP[lnI] = 'Data_Item'
									lnField = ascan(FLD_KEY, lcValue)
									if lnField > 0
										go lnField in FIELD
										luValue = trim(FIELD.FIELDNAME)
										loCondition.cValueType = 'Field'
									endif lnField > 0
								case REPMETA.FIELDTYPE $ 'CM'
									luValue = lcValue
								case REPMETA.FIELDTYPE = 'L'
									luValue = left(upper(lcValue), 1) = 'Y'
								otherwise
									if REPMETA.FIELDTYPE = 'D'
										lcValue = '{' + lcValue + '}'
									endif REPMETA.FIELDTYPE = 'D'
									if empty(lcValue)
										luValue = loUtility.GetBlankValue(REPMETA.FIELDTYPE)
									else
										luValue = evaluate(lcValue)
									endif empty(lcValue)
							endcase
							dimension loCondition.aValues[lnJ, 2]
							loCondition.aValues[lnJ, 1] = luValue
							loCondition.aValues[lnJ, 2] = ''
						next lnJ
						set strictdate to lnStrict
						loOperator = newobject(lcOperator, 'SFQuery.vcx', lcQuery)
						with loCondition
							.cConnection    = iif(empty(lcConnection) and ;
								lnI > 1 and not llNoConnection, ' and ', lcConnection)
							.cDisplayConnection = .cConnection
							.cFieldDesc     = trim(REPMETA.CAPTION)
							.cFieldName     = lcField
							.cFieldType     = REPMETA.FIELDTYPE
							.cFormat        = REPMETA.FORMAT
							.cInputMask     = REPMETA.INPUTMASK
							.cOperator      = loOperator.cOperatorTemplate
							.cOperatorClass = lcOperator
							.cOperatorDesc  = loOperator.cOperator
							.cSQLOperator   = loOperator.cSQLTemplate
							.lAskAtRuntime  = FLT_ASK[lnI]
							.lCase          = .T.
							.lLocalData     = .T.
							.nFieldLen      = REPMETA.FIELDLEN
							.nFieldDec      = REPMETA.FIELDDEC

* If we're comparing one field to another, we'll have to fill in cDisplay
* ourselves so the proper caption is shown.

							if loCondition.cValueType = 'Field'
								.cDisplay = .cFieldDesc + ' ' + .cOperatorDesc
								for lnJ = 1 to lnValues
									= seek('F' + ;
										padr(loCondition.aValues[lnJ, 1], len(REPMETA.OBJECTNAME)), ;
										'REPMETA', 'OBJECT')
									do case
										case lnJ = 1
										case 'BETWEEN' $ upper(.cSQLOperator)
											.cDisplay = .cDisplay + ' and'
										otherwise
											.cDisplay = .cDisplay + ','
									endcase
									.cDisplay = .cDisplay + ' ' + trim(REPMETA.CAPTION)
								next lnJ
							endif loCondition.cValueType = 'Field'
							.CalcCondition()
						endwith
						lnCondition = lnCondition + 1
						loQuery.SaveCondition(loCondition, lnCondition)
						lcConnection   = ''
						llNoConnection = .F.
					endif found()
				next lnI

* Convert the query array to a record in the CONDITION cursor and then into
* XML.

				for lnI = 1 to lnCondition
					lcOpClass   = loQuery.aQuery[lnI, 18]
					lcValueType = loQuery.aQuery[lnI, 20]
					lcValues    = ''
					lnValues    = alines(laValues, ;
						loQuery.aQuery[lnI, 10])
					for lnJ = 1 to lnValues
						lcValue = laValues[lnJ]
						if loQuery.aQuery[lnI, 4] $ 'CVM' and ;
							loQuery.aQuery[lnI, 20] = 'Value'
							lcValue = substr(lcValue, 2, len(lcValue) - 2)
						endif loQuery.aQuery[lnI, 4] $ 'CVM' ...
						lcValues = lcValues + '<value>' + lcValue + '</value>'
					next lnI
					insert into CONDITION values ;
						(loQuery.aQuery[lnI,  1], ;
						loQuery.aQuery[lnI,  3], ;
						lcOpClass, ;
						lcValues, ;
						loQuery.aQuery[lnI, 11], ;
						loQuery.aQuery[lnI, 17], ;
						lcValueType)
				next lnI
				cursortoxml('CONDITION', 'lcXML', 1, 8)
				lcXML = substr(lcXML, atc('<VFPData', lcXML))
				lcXML = strtran(lcXML, 'VFPDATA', 'conditions', -1, -1, 1)
				replace FILTER with lcXML in SFREPORTS
			endif FLT_CNT > 0

* Get the sort information.

			select REQUEST
			restore from memo RQ_SRTVARS additive
			if SRT_CNT > 0
				lnSorts = 0
				zap in SORTFIELD
				select RPT_DITEM
				for lnI = 1 to SRT_CNT
					lcField = SRT_KEY[lnI]
					locate for RDI_NAME = padr(lcField, len(RDI_NAME))
					if found()
						lnFields = loUtility.FieldsInExpr(@laFields, ;
							RDI_RPTEXP)
						lcField = upper(laFields[1])
						if seek('F' + ;
							padr(lcField, len(REPMETA.OBJECTNAME)), ;
							'REPMETA', 'OBJECT')
							lnSorts = lnSorts + 1
							dimension laSorts[lnSorts, 3]
							laSorts[lnSorts, 1] = lcField
							laSorts[lnSorts, 2] = SRT_ORD[lnI] = 'A'
							laSorts[lnSorts, 3] = iif(empty(SRT_GRP[lnI]), ;
								'B', 'A') + transform(lnSorts)
						endif seek('F' ...
					endif found()
				next lnI
				if lnSorts > 0
					asort(laSorts, 3)
					for lnI = 1 to lnSorts
						insert into SORTFIELD values ;
							(laSorts[lnI, 1], ;
							laSorts[lnI, 2], ;
							laSorts[lnI, 3] = 'A', ;
							lnI)
						if laSorts[lnI, 3] = 'A'
							select FIELD
							locate for FIELDNAME = laSorts[lnI, 1]
							replace GROUP with lnI
						endif laSorts[lnI, 3] = 'A'
					next lnI
					cursortoxml('SORTFIELD', 'lcXML')
					lcXML = substr(lcXML, atc('<VFPData', lcXML))
					lcXML = strtran(lcXML, 'VFPDATA', 'sortfields', -1, -1, 1)
					replace SORT with lcXML in SFREPORTS
				endif lnSorts > 0
			endif SRT_CNT > 0

* Now save the fields (we do it now rather than earlier since we may have
* changed it when checking for sorts).

			cursortoxml('FIELD', 'lcXML')
			lcXML = substr(lcXML, atc('<VFPData', lcXML))
			lcXML = strtran(lcXML, 'VFPDATA', 'fields', -1, -1, 1)
			replace FIELDS with lcXML in SFREPORTS
		endscan
		use in REQUEST
		use in RPT_DITEM
	endif llReturn
endscan
use
wait clear
close databases all
return llReturn

function CreateUniqueReportName
lparameters tcReportName
local lnReport, ;
	lnLen, ;
	lcReportName
lnReport     = 0
lnLen        = fsize('NAME', 'SFREPORTS')
lcReportName = padr(tcReportName, lnLen)
do while seek('R' + upper(lcReportName), 'SFREPORTS', 'NAME')
	lnReport     = lnReport + 1
	lcReportName = padr(replicate('Copy of ', lnReport) + trim(tcReportName), ;
		lnLen)
enddo while seek ...
return trim(lcReportName)
