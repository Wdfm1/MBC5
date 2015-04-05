* IT.PRG

on error &&clear on error from copyruntime prg
_screen.visible = .T.
_screen.windowstate=2
*if .not. firsttime( 'Memory Book Company' )
*return
*endif
LOCAL loSplash
loSplash = CREATEOBJECT("Form")
IF !ISNULL(loSplash)
   WITH loSplash
      .BorderStyle = 0
      .Caption     = SPACE(0)
      .Closable    = .f.
      .ControlBox  = .f.
      .MaxButton   = .f.
      .MinButton   = .f.
      .Movable     = .f.
      .AddObject("imgSplash","image")
      .imgSplash.Picture = "mbc1.bmp"
      .imgSplash.Top     = 0
      .imgSplash.Left    = 0
      .imgSplash.Visible = .t.
      .Height = loSplash.imgSplash.Height
      .Width  = loSplash.imgSplash.Width
      .AutoCenter = .t.
      .Show()
   ENDWITH
ENDIF
sys(3050,1,64000000)
 
*!*	IF !FILE("C:\MBC5\upd.txt")
*!*	TRY&&-----------------------------------------------------------------take out when done

*!*	DELETE FILE C:\MBC5\run.exe
*!*	 copy file m:\UpdateExe\upd.txt TO C:\mbc5\upd.txt
*!*	 copy file m:\UpdateExe\run.exe TO C:\mbc5\run.exe

*!*	CATCH

*!*	endtry
*!*	endif



SET LIBR TO FOXTOOLS.FLL ADDI
*set volu m: to d:
#INCLUDE "C:\MBC5\FOXPRO.H"
*#INCLUDE "KEYS.H"
#INCLUDE "DIBAPI.H"
*
* "talk" status is a special case
*
if set("talk") == "ON"
 set talk off
 m.gcOldTalk = "ON"
else
 m.gcOldTalk = "OFF"
endif

m.gnTimeBegin  = seco()
m.glWeAreDone = .F.


*
* for the purposes of this sample, all COMMON code is 
* in the SOURCE directory (classes, proc files, etc.)
*

*

m.gcDefAtProgStart = sys(5) + sys(2003) && Default at Program Startup

*
* save the FoxPro path that was in effect at the start of this program
* if it exists, it's probably "e:\common30, e:\third30, e:\dev30"
*
m.gcPathAtProgStart = set("path") && FoxPro path at Program Startup 

*
* get the INI file that tells us where everything is
*
* also, set the path (assuming the above dir structure)
*
* create a new path string that consists of:
*  the Default Directory at Prog Start
*  the existing path
*  the location of metdata files
*  the location of application specific files
*
*  this will need to be modified for the location of customer common and thirdparty
*   (developer common and thirdparty will be found in the existing path)
*

*
* m.gcCurPathB is the path before we set the data dir
*

sele 0
if uppe(right(m.gcDefAtProgStart,6)) = "SOURCE"
 * assuming MDFILES is "next door"
 if file(left(m.gcDefAtProgStart, len(m.gcDefAtProgStart) - 6) + "MDFILES\IT.INI")
  m.gcLocIni = left(m.gcDefAtProgStart, len(m.gcDefAtProgStart) - 6) + "MDFILES\IT.INI"
  m.gcPathB4 = gcDefAtProgStart ;
   + iif(!empt(m.gcPathAtProgStart), "; "+m.gcPathAtProgStart, "") ;
   + "; ..\MDFILES" ;
   + "; ..\APPFILES"  
 else
  wait wind left(m.gcDefAtProgStart, len(m.gcDefAtProgStart) - 6) + "MDFILES\IT.INI" + " does not exist"
  m.glWeAreDone = .T.
 endi
else 
 * assuming MDFILES is "down below"
 if file(m.gcDefAtProgStart + "\MDFILES\IT.INI")
  m.gcLocIni = m.gcDefAtProgStart + "\MDFILES\IT.INI"
  m.gcPathB4 = gcDefAtProgStart ;
   + iif(!empt(m.gcPathAtProgStart), "; "+m.gcPathAtProgStart, "") ;
   + "; MDFILES" ;
   + "; APPFILES"  
 else
  wait wind m.gcDefAtProgStart + "\MDFILES\IT.INI" + " does not exist"
  m.glWeAreDone = .T.
 endi
endi
 
*
* now set path to this new string
*
set path to &gcPathB4

*
* find COMMON from our INI file
*
* create a cursor to hold the whole INI file
* and then look for the location of COMMON
*
* note that IT.INI is now in our path
*
create cursor csrFiLoc ;
 (cJunk C(100))
 
append from IT.INI sdf
loca for "cLocCommon" $ cJunk
if !eof()

 m.cPathComm = allt(subs( cJunk, at("=", cJunk) + 1))
 
 m.gcPathB4 = m.cPathComm ;
  + iif(empt(m.gcPathB4), "", ";") ;
  + m.gcPathB4

 *
 * set path again to include COMMON
 *
 set path to &gcPathB4

endif
SYS(2700,0)
SET ENGINEBEHAVIOR 70
m.gcOldClas = set("classlib")
close all
set classlib to BASEAPP, BASETBR
oEnv = createobject("ENV")

*
* clean out everything
*
oEnv.CleanOut()

*
* save current environment
*
oEnv.SaveSets()

*
* do environment and configuration check
*
oEnv.EnvCheck()

oApp = createobject("APP")

*
* initialize various system attributes
*
* readini will get the location of 
* the def data dir and add it to the path
*
oApp.ReadIni()


*
* accepting user logins with the appropriate security
*

oApp.Login()

if !oApp.lWeAreDone
 *
 * define environment - we do this now because
 * the environment may change according to 
 * who the user is!
 *
 oEnv.DoSets()

 *
 * change to the default directory
 *
 oApp.SetFileLocs()
* (created but decided not to use per tammy)oApp.SetNumProd()&&sets the number of production orders that can be assigned in a week. Uses produtn.deadlinein field
 *
 * set up screen, menu, and event handler
 *
 oApp.it()

 *
 * return the environment to the way it was
 *
 oEnv.RestoreSets

endif

*
* clean out rest of app
*
oEnv.ShutDown()

do case
case oEnv.cTypeExit = "VFP"
 rele oEnv
 clea all
 *wait wind nowa "See ya later, Dale!!!"
 return
case oEnv.cTypeExit = "OS"
 rele oEnv
 clea all
 @2,0 say "See you next time"
 quit
endcase


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
FUNCTION firsttime
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





* <EOF>
