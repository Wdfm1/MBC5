* Convert the FF XML file to cursors, then use ImportFF to do the conversion.

lparameters tcXMLFile, ;
	tcReportsTable, ;
	tcMetaDataTable, ;
	tcQuery
local lcXMLFile, ;
	lcReportsTable, ;
	lcMetaDataTable, ;
	lcQuery, ;
	lcXML, ;
	lnPos, ;
	lnI, ;
	lcText, ;
	lcTag2, ;
	lcChar, ;
	loDOM as MSXML2.DOMDocument, ;
	loRoot as MSXML2.IXMLDOMNode, ;
	loDataItems, ;
	loDataItem as MSXML2.IXMLDOMElement, ;
	RDI_NAME, ;
	RDI_RPTEXP, ;
	RDI_ALIAS1, ;
	RDI_RPTWID, ;
	RDI_SUBTOT, ;
	RDI_HDR1, ;
	RDI_HDR2, ;
	RDI_OTPICT, ;
	RDI_HDJUST, ;
	RDI_FLDTYP, ;
	loRequests, ;
	loRequest as MSXML2.IXMLDOMElement, ;
	RQ_NAME, ;
	RQ_DESC, ;
	loNode as MSXML2.IXMLDOMElement, ;
	loField as MSXML2.IXMLDOMElement, ;
	FLD_CNT, ;
	FLD_KEY[1], ;
	lnField, ;
	loNodes, ;
	lcField, ;
	FLT_CNT, ;
	FLT_KEY[1], ;
	FLT_OPR[1], ;
	FLT_NOT[1], ;
	FLT_VAL[1], ;
	FLT_VOP[1], ;
	FLT_ASK[1], ;
	SRT_CNT, ;
	SRT_KEY[1], ;
	SRT_ORD[1], ;
	SRT_GRP[1]

* Ensure we have valid parameters.

if vartype(tcXMLFile) <> 'C' or empty(tcXMLFile)
	lcXMLFile = getfile('XML', '', '', 0, 'Select FoxFire Import File')
	if empty(lcXMLFile)
		return
	endif empty(lcXMLFile)
else
	lcXMLFile = tcXMLFile
endif vartype(tcXMLFile) <> 'C' ...
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

* Load the XML and find the starting node. Before we do that, we have to handle
* invalid XML in some TAG2 nodes.
	
wait window 'Reading FoxFire XML...' nowait
lcXML = filetostr(lcXMLFile)
lnPos = 1
for lnI = 1 to occurs('<fldname>TAG2</fldname>', lcXML)
	lnPos  = atc('<fldname>TAG2</fldname>', lcXML, lnI)
	lcText = strextract(lcXML, '<fldname>TAG2</fldname>', '</FIELD>', lnI, 1)
	lcTag2 = strextract(lcText, '<fldvalue><![CDATA[', ']]></fldvalue>', 1, 3)
	if not empty(lcTag2)
		lcChar = left(lcTag2, 1)
		if not between(asc(lcChar), 32, 126)
			lcXML = strtran(lcXML, lcTag2)
		endif not between(asc(lcChar), 32, 126)
	endif not empty(lcTag2)
next lnI

loDOM = createobject('MSXML2.DOMDocument')
loDOM.async = .F.
loDOM.loadXML(lcXML)
if loDOM.parseError.errorCode <> 0
	messagebox('The XML file appears to be invalid. The error message is:' + ;
			chr(13) + chr(13) + ;
		alltrim(loDOM.parseError.reason, 1, chr(13), chr(10)) + chr(13) + ;
			chr(13) + ;
		'Position ' + transform(loDOM.parseError.linepos) + ' of line ' + ;
		transform(loDOM.parseError.line) + chr(13) + chr(13) + ;
		alltrim(loDOM.parseError.srcText, 1, ' ', chr(9)))
	editsource(lcXMLFile, loDOM.parseError.line)
	return
endif loDOM.parseError.errorCode <> 0
loRoot = loDOM.selectSingleNode('//')
loRoot = loRoot.nextSibling

* Create a cursor of preferences.

create cursor FFPREFER (PF_RQSTFL C(60), PF_DITEMFL C(60))
insert into FFPREFER values ('REQUEST', 'RPT_DITEM')

* Get the data items.

create cursor RPT_DITEM (RDI_NAME C(60), RDI_RPTEXP M, RDI_ALIAS1 C(60), ;
	RDI_RPTWID N(3), RDI_SUBTOT C(1), RDI_HDR1 C(50), RDI_HDR2 C(50), ;
	RDI_OTPICT M, RDI_FLDTYP C(1))
loDataItems = loRoot.selectNodes('DataItemRecord')
for each loDataItem in loDataItems
	RDI_NAME   = GetFieldValue(loDataItem, 'rdi_name')
	RDI_RPTEXP = GetFieldValue(loDataItem, 'rdi_rptexp')
	RDI_ALIAS1 = GetFieldValue(loDataItem, 'rdi_alias1')
	RDI_RPTWID = val(GetFieldValue(loDataItem, 'rdi_rptwid'))
	RDI_SUBTOT = GetFieldValue(loDataItem, 'rdi_subtot')
	RDI_HDR1   = GetFieldValue(loDataItem, 'rdi_hdr1')
	RDI_HDR2   = GetFieldValue(loDataItem, 'rdi_hdr2')
	RDI_OTPICT = GetFieldValue(loDataItem, 'rdi_otpict')
	RDI_HDJUST = GetFieldValue(loDataItem, 'rdi_hdjust')
	RDI_FLDTYP = GetFieldValue(loDataItem, 'rdi_fldtyp')
	insert into RPT_DITEM from memvar
next loDataItem

* Get the requests.

create cursor REQUEST (RQ_NAME C(8), RQ_DESC C(75), RQ_FLDVARS M, ;
	RQ_FLTVARS M, RQ_SRTVARS M)
loRequests = loRoot.selectNodes('RequestRecord')
for each loRequest in loRequests

* Get the request name.

	RQ_NAME = GetFieldValue(loRequest, 'rq_name')
	RQ_DESC = GetFieldValue(loRequest, 'rq_desc')

* Get the fields.

	loNode  = loRequest.selectSingleNode('FIELD[fldname="rq_fldvars"]')
	loField = loNode.selectSingleNode('fldvalue')
	loNode  = loField.selectSingleNode('FLD_CNT')
	FLD_CNT = val(loNode.text)
	dimension FLD_KEY[M.FLD_CNT]
	loNode  = loField.selectSingleNode('FLD_KEY')
	lnField = 1
	loNodes = loNode.childNodes
	for each loNode in loNodes
		lcField = alltrim(loNode.text)
		FLD_KEY[lnField] = lcField
		lnField = lnField + 1
	next loNode

* Get the filter.

	loNode  = loRequest.selectSingleNode('FIELD[fldname="rq_fltvars"]')
	loField = loNode.selectSingleNode('fldvalue')
	loNode  = loField.selectSingleNode('flt_cnt')
	FLT_CNT = val(loNode.text)
	if M.FLT_CNT > 0
		dimension FLT_KEY[M.FLT_CNT], FLT_OPR[M.FLT_CNT], FLT_NOT[M.FLT_CNT], ;
			FLT_VAL[M.FLT_CNT], FLT_VOP[M.FLT_CNT], FLT_ASK[M.FLT_CNT]
		loNode  = loField.selectSingleNode('FLT_KEY')
		lnField = 1
		loNodes = loNode.childNodes
		for each loNode in loNodes
			lcField = alltrim(loNode.text)
			FLT_KEY[lnField] = lcField
			lnField = lnField + 1
		next loNode
		loNode  = loField.selectSingleNode('flt_opr')
		lnField = 1
		loNodes = loNode.childNodes
		for each loNode in loNodes
			lcField = alltrim(loNode.text)
			FLT_OPR[lnField] = lcField
			lnField = lnField + 1
		next loNode
		loNode  = loField.selectSingleNode('FLT_NOT')
		lnField = 1
		loNodes = loNode.childNodes
		for each loNode in loNodes
			lcField = alltrim(loNode.text)
			FLT_NOT[lnField] = lcField
			lnField = lnField + 1
		next loNode
		loNode  = loField.selectSingleNode('flt_val')
		lnField = 1
		loNodes = loNode.childNodes
		for each loNode in loNodes
			lcField = alltrim(loNode.text)
			FLT_VAL[lnField] = lcField
			lnField = lnField + 1
		next loNode
		loNode  = loField.selectSingleNode('flt_vop')
		lnField = 1
		loNodes = loNode.childNodes
		for each loNode in loNodes
			lcField = alltrim(loNode.text)
			FLT_VOP[lnField] = lcField
			lnField = lnField + 1
		next loNode
		loNode  = loField.selectSingleNode('flt_ask')
		lnField = 1
		loNodes = loNode.childNodes
		for each loNode in loNodes
			lcField = alltrim(loNode.text)
			FLT_ASK[lnField] = .T.
			lnField = lnField + 1
		next loNode
	else
		dimension FLT_KEY[1], FLT_OPR[1], FLT_NOT[1], FLT_VAL[1], FLT_VOP[1], ;
			FLT_ASK[1]
		store '' to FLT_KEY, FLT_OPR, FLT_NOT, FLT_VAL, FLT_VOP, FLT_ASK
	endif M.FLT_CNT > 0

* Get the sort.

	loNode  = loRequest.selectSingleNode('FIELD[fldname="rq_srtvars"]')
	loField = loNode.selectSingleNode('fldvalue')
	loNode  = loField.selectSingleNode('srt_cnt')
	SRT_CNT = val(loNode.text)
	if M.SRT_CNT > 0
		dimension SRT_KEY[M.SRT_CNT], SRT_ORD[M.SRT_CNT], SRT_GRP[M.SRT_CNT]
		loNode  = loField.selectSingleNode('srt_key')
		lnField = 1
		loNodes = loNode.childNodes
		for each loNode in loNodes
			lcField = alltrim(loNode.text)
			SRT_KEY[lnField] = lcField
			lnField = lnField + 1
		next loNode
		loNode  = loField.selectSingleNode('srt_ord')
		lnField = 1
		loNodes = loNode.childNodes
		for each loNode in loNodes
			lcField = alltrim(loNode.text)
			SRT_ORD[lnField] = lcField
			lnField = lnField + 1
		next loNode
		loNode  = loField.selectSingleNode('srt_grp')
		lnField = 1
		loNodes = loNode.childNodes
		for each loNode in loNodes
			lcField = alltrim(loNode.text)
			SRT_GRP[lnField] = lcField
			lnField = lnField + 1
		next loNode
	else
		dimension SRT_KEY[1], SRT_ORD[1], SRT_GRP[1]
		store '' to SRT_KEY, SRT_ORD, SRT_GRP
	endif M.SRT_CNT > 0

* Save the request record.

	insert into REQUEST from memvar
	save to memo RQ_FLDVARS all like FLD*
	save to memo RQ_FLTVARS all like FLT*
	save to memo RQ_SRTVARS all like SRT*
next loRequest

* Call IMPORTFF to do the hard work.

wait clear
do ImportFF with 'FFPREFER', lcReportsTable, lcMetaDataTable, lcQuery

function GetFieldValue(toNode, tcField)
local loNode, ;
	loField, ;
	lcValue
loNode  = toNode.selectSingleNode('FIELD[fldname="' + tcField + '"]')
loField = loNode.selectSingleNode('fldvalue')
lcValue = loField.text
return lcValue
