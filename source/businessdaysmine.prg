**********************************************************************
* Program....: BusinessDays
* Compiler...: Visual FoxPro 06.00.8492.00 for Windows
* Abstract...: checks if date is a business date, if not returns next available date, if is a business date returns date given
* ...........: Modified by RW 6/15/14
**********************************************************************
*FUNCTION BusinessDays ( tdStartDate, tnNumberOfDays )
PROCEDURE BusinessDays ( tdDate)
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

ldDate = tdDate			
llOK=.f.
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


RETURN ldDate