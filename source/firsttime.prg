********************************************************************
*** Name.....: FIRSTTIME.PRG
*** Author...: Marcia Akins & Andy Kramek
*** Date.....: 01/11/2004
*** Notice...: Copyright (c) 2004 Tightline Computers, Inc
*** Compiler.: Visual FoxPro 09.00.0000.2124 for Windows 
*** Function.: Determine whether an instance of the application is already running
*** .........: This function uses the creation of a named MUTEX to determine whether
*** .........: or not the application is already running. This function should be called
*** .........: near the top of the application's main program to create a named object 
*** .........: that can be checked every time the application is started.  If the named 
*** .........: object exists, the function will try to activate the FoxPro running application.
*** Returns..: Logical
********************************************************************
LPARAMETERS tcAppName
LOCAL lcMsg, lcAppName, lnMutexHandle, lnhWnd, llRetVal

lcMsg = ''
SET ASSERTS ON
IF EMPTY( NVL( tcAppName, '' ) )
  TEXT TO lcMsg NOSHOW 
    This is another Brain Dead Programmer Error.
    You must pass the name of an application to FirstTime().
    Have a nice day now...
  ENDTEXT
  ASSERT .F. MESSAGE lcMsg
  RETURN 
ENDIF

*** Format the passed in program name
lcAppName = UPPER( ALLTRIM( tcAppName ) ) + CHR( 0 )

*** Declare API functions
DECLARE INTEGER CreateMutex IN WIN32API INTEGER lnAttributes, INTEGER lnOwner, STRING @lcAppName
DECLARE INTEGER GetProp IN WIN32API INTEGER lnhWnd, STRING @lcAppName
DECLARE INTEGER SetProp IN WIN32API INTEGER lnhWnd, STRING @lcAppName, INTEGER lnValue
DECLARE INTEGER CloseHandle IN WIN32API INTEGER lnMutexHandle
DECLARE INTEGER GetLastError IN WIN32API 
DECLARE INTEGER GetWindow IN USER32 INTEGER lnhWnd, INTEGER lnRelationship
DECLARE INTEGER GetDesktopWindow IN WIN32API 
DECLARE BringWindowToTop IN Win32APi INTEGER lnhWnd
DECLARE ShowWindow IN WIN32API INTEGER lnhWnd, INTEGER lnStyle

*** Try and create a new MUTEX with the name of the passed application
lnMutexHandle = CreateMutex( 0, 1, @lcAppName )

*** If the named MUTEX creation fails because it exists already, try to display
*** the existing application 
IF GetLastError() = 183

  *** Get the hWnd of the first top level window on the Windows Desktop.
  lnhWnd = GetWindow( GetDesktopWindow(), 5 )

  *** Loop through the windows. 
  DO WHILE lnhWnd > 0

     *** Is this the one that we are looking for?
     *** Look for the property we added the first time
     *** we launched the application
     IF GetProp( lnhWnd, @lcAppName ) = 1
       *** Activate the app and exit stage left
       BringWindowToTop( lnhWnd )
       ShowWindow( lnhWnd, 3 )
       EXIT
     ENDIF
     lnhWnd = GetWindow( lnhWnd, 2  )
  ENDDO

  *** Close the 'failed to open' MUTEX handle
  CloseHandle( lnMutexHandle )

ELSE

  *** Add a property to the FoxPro App so we can identify it again
  SetProp( _vfp.Hwnd, @lcAppName, 1)
  llRetVal = .T.
ENDIF

RETURN llRetVal
