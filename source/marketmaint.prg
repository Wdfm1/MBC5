SET step on
USE cust excl in 0
USE mktinfo excl in 0
USE lkppromotions excl in 0
SELECT cust

SCAN &&scan cust
	tmpPromcode=alltrim(cust.refby)
	tmpschcode=cust.schcode
	tmpcontdate=cust.contdate
	IF empty(tmpPromcode)
		LOOP
	ELSE
		SELECT lkppromotions
		SCAN for alltrim(lkppromotions.promo)=tmpPromcode &&lkppromotions
			SELECT mktinfo
&&only one record for a school code has been entered to date
&&save old rec for reentry
			mktschcode="" &&blank for new scan then test to see if rec has been entered or found
			SCAN for mktinfo.schcode=tmpschcode
				mktschcode=mktinfo.schcode
				mktddate=mktinfo.ddate
				mktinitial=mktinfo.initial
				mktnote=mktinfo.note
				mktpromo=mktinfo.promo
				mktrefered=mktinfo.refered
				Delete
			ENDSCAN
			APPEND blank  &&enter record that is being imported
			REPLACE mktinfo.refered with "RETURNIG CUSTOMER"
			REPLACE mktinfo.promo with tmpPromcode
			REPLACE mktinfo.schcode with tmpschcode
			REPLACE mktinfo.ddate with tmpcontdate
			REPLACE mktinfo.note with "IMPORTED FROM CUST.REFBY"
			REPLACE mktinfo.initial with "DEV"
		if !empty(mktschcode)
			APPEND blank && this readds the record that was deleted if there is one so recs will be in proper order
			REPLACE mktinfo.refered with mktrefered
			REPLACE mktinfo.schcode with mktschcode
			REPLACE mktinfo.ddate with mktddate
			REPLACE mktinfo.initial with mktinitial
			REPLACE mktinfo.note with mktnote
			REPLACE mktinfo.promo with mktpromo
        endif
		ENDSCAN &&lkppromotions
	ENDIF
ENDSCAN &&cust
close tables all