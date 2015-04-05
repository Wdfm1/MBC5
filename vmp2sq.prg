* This program, originally written by Frank Marafino, updates a Stonefield
* Query data dictionary (REPMETA.PRG) with information from a Visual MaxFrame
* (VMP) application.
*
* Instructions:
* - Open the database containing the application's tables
* - Ensure the Stonefield Query project directory is the current directory or
*	in the VFP path
* - Run this program

close tables all
use REPMETA shared

* Make primary and foreign key fields non-reportable.

update REPMETA ;
	set REPORTABLE = .F., FILTERABLE = .F., SORTABLE = .F., ALLOWVALUE = .F. ;
	where RECTYPE = 'F' and upper(right(alltrim(OBJECTNAME), 3)) = '_PK'
update REPMETA ;
	set REPORTABLE = .F., FILTERABLE = .F., SORTABLE = .F., ALLOWVALUE = .F. ;
	where RECTYPE = 'F' AND upper(right(alltrim(OBJECTNAME), 3)) = '_FK'

* Get table captions from the first line of the database Comment property.

lnTables = adbobjects(laTables, 'TABLE')
for lnCount = 1 to lnTables
	lcComment = dbgetprop(laTables[lnCount], 'Table', 'Comment')
	lcComment = getwordnum(lcComment, 1, chr(13))
	if not empty(left(lcComment, 50))
		update REPMETA ;
			set CAPTION = lcComment ;
			where RECTYPE = 'C' AND ;
			upper(ALIAS) = upper(laTables[lnCount]) AND ;
			(upper(ALIAS) = upper(CAPTION) or empty(CAPTION))
	endif
next

* Add relations from VMPRI to REPMETA.

select 0
use VMPRI shared
scan
	lcParentTable   = upper(alltrim(VMPRI.XRI_PARENT_TABLENAME))
	lcChildTable    = upper(alltrim(VMPRI.XRI_CHILD_TABLENAME))
	lcChildIndexTag = upper(alltrim(VMPRI.XRI_CHILD_INDEX_TAG))
	select REPMETA
	locate for RECTYPE = 'C' and upper(ALIAS) = lcParentTable
	if found()
		locate for RECTYPE = 'R' and ;
			upper(OBJECTNAME) = lcParentTable + ',' + lcChildTable and ;
			upper(ALIAS1) = lcChildTable  and upper(ALIAS2) = lcParentTable
		if not found()
			if not used(lcParentTable)
				use (lcParentTable) in 0 shared
			endif
			lnCount = ataginfo(laParentTags, '', lcParentTable)
			if lnCount > 0
				lnElement = ascan(laParentTags, 'PRIMARY', 1, 0, 2, 1)
				if lnElement > 0
					lcParentField = alltrim(laParentTags[lnElement + 1])
					if not used(lcChildTable)
						use (lcChildTable) in 0 shared
					endif
					lnCount = ataginfo(laChildTags, '', lcChildTable)
					if lnCount > 0
						lnElement = ascan(laChildTags, lcChildIndexTag, 1, 0, 1, 1)
						if lnElement > 0
							lcChildField = alltrim(laChildTags[lnElement + 2])
							insert into REPMETA ;
									RECTYPE, ;
									DATABASE, ;
									OBJECTNAME, ;
									CAPTION, ;
									ALIAS1, ;
									ALIAS2, ;
									EXPR1, ;
									EXPR2, ;
									JOINWEIGHT, ;
									ID) ;
								values ('R', ;
									lower(juststem(dbc())), ;
									lcParentTable + ',' + lcChildTable, ;
									lower(juststem(dbc())), ;
									lcChildTable, ;
									lcParentTable, ;
									lcChildTable + '.' + lcChildField, ;
									lcParentTable + '.' + lcParentField, ;
									1, ;
									sys(2015))
						endif
					endif
				endif
			endif
		endif
	endif
endscan
close tables all
