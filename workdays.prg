**********************************************************************
* Program....: BusinessDays
* Compiler...: Visual FoxPro 06.00.8492.00 for Windows
* Abstract...: Given a start date and a number of days, returns the 
* ...........: date that is that number of days business in the future
**********************************************************************
FUNCTION BusinessDays ( tdStartDate, tnNumberOfDays )
LOCAL lnCnt, ldDate, llOK, llUsed 

*** Make sure we have the Holidays table available
IF !USED( 'Holidays' )	
  USE Holidays In 0
  llUsed = .F.
ELSE
  llUsed = .T.
ENDIF
SELECT Holidays
SET ORDER TO dHoliday

ldDate = tdStartDate			
FOR lnCnt = 1 TO tnNumberOfDays
  ldDate = ldDate + 1
  llOK = .F.
  DO WHILE !llOK
    *** If current date is a Saturday, go to Monday
    IF DOW( ldDate ) = 7
      ldDate = ldDate + 2
    ELSE
      *** If current date is a Sunday, go to Monday
      IF DOW( ldDate ) = 1
        ldDate = ldDate + 1
      ENDIF
    ENDIF
    *** OK, now check for Holidays
    IF !SEEK( ldDate, 'Holidays', 'dHoliday' )
      llOK = .T.
    ELSE
      ldDate = ldDate + 1
    ENDIF
  ENDDO
ENDFOR

IF !llUsed
  USE IN Holidays
ENDIF

RETURN ldDate