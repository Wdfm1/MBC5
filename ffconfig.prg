
**BEGIN HEADER**tesr
*----------------------------------------------------------------------------
* NAME          FFCONFIG.PRG
*
* SYSTEM        Foxfire! Report Writer v8.0
*
* DESCRIPTION   Framework for user-defined configuration code. To make use
*               of these configurations, a program calls FFCONFIG with a
*               parameter indicating what operation ('PHASE') is under way,
*               and the appropriate code is executed before control is
*               returned to the caller.
*
* CALLED BY     many programs
*
* NOTE          This program is executed by default when Foxfire! runs. If,
*               however, you want to replace it with a customized version
*               (or if you want to maintain multiple configuration programs),
*               you may pass the name of the configuration program as a
*               parameter when calling the Foxfire! engine (see FFOXFIRE.PRG
*               for details on parameters).
*----------------------------------------------------------------------------
* ARGUMENT LIST
*
*     NAME      TYPE/LENGTH                DESCRIPTION
* ------------- ----------- -------------------------------------------
* tcPhase         C variable  name of operation under way (for which
*                             configuration is to be performed.)
*----------------------------------------------------------------------------
* VARIABLE RETURNED
*
*     NAME      TYPE/LENGTH                DESCRIPTION
* ------------- ----------- -------------------------------------------
* none
*----------------------------------------------------------------------------
* WINDOWS USED
*
*     NAME                     DESCRIPTION
* ------------- -------------------------------------------
* none
*----------------------------------------------------------------------------
* REVISION HISTORY
* 12/28/95  ASN  Updated header for V3.0
* 09/20/96  ASN  Reviewed for V3.0+ update release
* 01/22/97  ASN  Updated copyrights, adjusted localization settings
* 05/26/97  BW   Modified to implement pg_look4excel workaround to DDEREG problem -- see ][bw
* 07/05/02  ARM Updated for new features in Foxfire! 6.03
* 12/03/03  HCD Updated for new features in Foxfire! 8.0
*------------------------------------------------------------------------
*
* Foxfire! was designed and built by the Foxfire! Development Team at
* Micromega Systems, Inc.
*
* Architect:            Alan Schwartz
* Project Manager:      Andy Neil
* Primary Developer:    Barry Chertov
* Assisting Developers: Mike Taylor, Dale Kiefling, Tom Schiff, Bill Wood
*
*
* Micromega Systems, Inc. would like to thank the many other people
* who have contributed their time and energy to making Foxfire! a
* world-class information tool.
*
*------------------------------------------------------------------------
**BEGIN COPYRIGHT**
*
* Copyright (c) 1992-97, Micromega Systems, Inc.,
* All Rights Reserved
*
* U.S. GOVERNMENT RESTRICTED RIGHTS.  Foxfire! software and
* reference manuals are provided with RESTRICTED RIGHTS.
* Use, duplication, or disclosure by the U.S.  Government is
* subject to restrictions as set forth in subparagraph
* (c)(1)(ii) of the Rights in Technical Data and Computer
* Software clause at DFARS 252.227-7013 or subparagraphs
* (c)(1) and (2) of the Commercial Computer Software -
* Restricted Rights clause at 48 CFR 52.227-19 or any
* successor clauses thereto or any similar clauses in the NASA
* FAR supplement, as applicable.  Contractor/manufacturer is
* Micromega Systems, Inc., 2 Fifer Ave. Ste. 120, Corte
* Madera  CA  94925
*
* Foxfire! is a registered trademark of Micromega Systems, Inc.
*
**END COPYRIGHT**
*------------------------------------------------------------------------
**END HEADER**

PARAMETER tcPhase           && all phases are upper case

*!*	 WAIT WINDOW tcPhase       && Debugging -- uncomment to see when the phases are called.

DO CASE
Case tcPhase ="STARTUP"

	* This phase is called immediately upon Foxfire! startup.
	*
	* We know we are running in VFP
	ff_userlogo = "BMPS\MMS.BMP"
	
	ff_VisualFoxPro = .T.
	* Should yield 8 for VFP 8.0
	ff_FPVersion    = Int(Version(5)/100)
	ff_libdir    = "6XLIBS"
Case tcPhase ="PREFERENCE FILE SETUP"
	SET NULLDISPLAY TO "N/A"
	* This phase is called if the Preference Set file (alias FFPREFER) is
	* not already open when Foxfire! is executed.  The task is to determine
	* which Preference Set record should be used initially.  Foxfire! will
	* open the file FFPREFER.DBF if it's found in the (FoxPro) default
	* directory (or on the FoxPro search path).
	
	* A "default" Preference Set record name is contained in the variable
	* m.lcWhatPref.  As shipped, Foxfire! will look for the 'Sample Data
	* Set' Preference Set.
	
	* Determination of which Preference Set will be used first follows
	* a fairly complex set of rules, which are documented fully in the
	* comments which appear near the end of this program. Briefly, the order
	* of precedence is:
	*    -- current record in an already-open file (this phase NOT EXECUTED)
	*    -- record named in the first line of ASCII file FOXFIRE.INI
	*    -- record named in DOS environment variable FOXFIRE.INI
	*    -- record named in m.lcWhatPref
	*    -- solitary record in Preference Set file
	*    -- record selected by the user from a picklist
	*       (skipped if m.pf_name is non-empty)
	*
	* If none of these conditions apply, Foxfire! will issue an error
	* message and terminate operations.
	
	* Note: users (those with ff_seclvl = '*') may change the startup
	* Preference Set via the Preference Set Editor utility by pressing the
	* <Startup> button, which writes a FOXFIRE.INI file.
	
	PRIVATE lcPrefFile,lcWhatPref, lcPNameFl, llPrefOK, llFromINI
	&&m drive
	lcPrefFile = "m:\mbc5\ff80\FFPREFER.DBF"       && Preference Set file name
	lcWhatPref = "Memory Book company"    && default Preference (record) name
*!*			lcPNameFl  = "FOXFIRE.INI"        && file to override default pref. name
*!*		llFromINI  = .f.                  && pref name derived from lcPNameFl?
*!*	*!*	             && pref name derived from lcPNameFl?
*!*			llPrefOK   = .f.                  && found the named Preference Set?
*!*		
*!*		*If the override file is present, parse it for a Preference Set name.
*!*		IF FILE(lcPNameFl)
*!*		   llFromINI = .t.
*!*		   lcWhatPref = fnPrefName(lcPNameFl)      && parse text
*!*		ELSE
*!*		   *If the override environment variable is present, grab it.
*!*		   IF !EMPTY(GETENV('FOXFIRE.INI'))
*!*		      lcWhatPref = UPPER(ALLTRIM(GETENV('FOXFIRE.INI')))
*!*		   ENDIF
*!*		ENDIF
	
	*If the Preference Set file isn't already open, open it.
	IF !USED('FFPREFER')
	   SELECT 0
	   DO ("FFNETUSE") WITH lcPrefFile, .F., 1, "FFPREFER"
	   IF USED('FFPREFER')
	      SET ORDER TO PF_NAME
	   ELSE
	      DO ("MSGSVC") with "Can't open Preference Set file"
	      llRetVal = .F.
	      RETURN
	   ENDIF
	ELSE
	   SELECT FFPREFER
	ENDIF
	
	*******************************************************************
	* You may want to filter the Preference Set file to limit what other
	* Preference Sets this user can choose. The pf_misc field (memo) is
	* available to be stuffed with whatever you like and is not used
	* by Foxfire!. To prevent the user from switching Preference Sets you
	* should un-check the "Preference Set Picker" (pf_pkpref) flag
	* in the Preference Set Editor "Privileges" screen.   See the
	* Reference Manual section on "Security and Privileges" for more info.
	*******************************************************************
	
	* If we have a Preference Set name, look for it
	IF !EMPTY(lcWhatPref)
	   llPrefOK = SEEK(UPPER(ALLTRIM(lcWhatPref)))
	ENDIF
	
	* If no initial Preference Set determined yet, let user choose one.
	IF !llPrefOK
	   * If we got a bad Preference Set name out of FOXFIRE.INI, erase
	   * the file.
	   IF llFromINI
	      lcPNameFl = FULLPATH(lcPNameFl)
	      ERASE (lcPNameFl)
	   ENDIF
	   IF EMPTY(m.pf_name)
	      * Prepare for picklist
	      ff_nomsg = .t.       && suppress help/message display temporarily
	      * because this happens early, Foxfire! colors aren't set yet.
	      * call fnForceClr in FFOXFIRE.PRG to make it look better.
	      DO ("FFPKPREF") WITH 'Choose Initial Foxfire! Preference Set', ;
	         .T.,.F.,llPrefOK
	      ff_nomsg = .f.           && re-enable help/message display
	   ELSE
	      llPrefOK = .t.
	   ENDIF
	ENDIF
	
	* If (after all that!) we still have no Preference Set, declare an error
	* and warn the calling program to terminate.
	
	IF !llPrefOK
	   DO ("MSGSVC") WITH "No Preference Set selected. Fo"
	   IF USED("FFPREFER")
	      USE IN FFPREFER
	   ENDIF
	   * Change the m.llRetVal (established by open_pref() in FFOXFIRE.PRG)
	   * to alert caller that no further attempt to open is needed.
	   llRetVal = .F.
	ENDIF
Case tcPhase ="GLOBAL SETUP"
	* This phase is called after all Foxfire! global variables have been
	* set to default values. In addition, the Preference variables have
	* been set to the values stored in your selected Preference record.
	* You may write code here to change any of these values.  If you want
	* to establish additional variables, declare them as PUBLIC here and
	* release them explicitly in the "CLEANUP" phase. See example below.
	
	* If you change any values here, be sure to remove the * marker to make
	* them active.
	
	* An important use of this phase is to change the values of the
	* Preference variables which specify the filter conditions to be
	* imposed when opening the data files for requests (pf_fltreq), data
	* items (pf_fltitm) and joins (pf_fltjoi). In some cases, you may
	* want to change the filter in the REQUEST SETUP phase below, as well.
	* See the user's manual for more details.
	
	* You might also use this phase to open any files you expect to be
	* needed for Filter value validation, UDFs, SQL SELECTs, etc.
	* If you do so, you may close them in the "CLEANUP" phase.

	ON KEY LABEL F7 DO ("FFDEMOER")         && Hot to Sample Data ER diagram
	IF FF_Debug
	   * Adding FFDebug=ON to your config.fp[x] file (?sys(2019)) will make Foxfire! more
	   * "developer friendly".
	   ON KEY LABEL f2 DO ("FFUPDSCX") WITH "\ff\FOXFIRE.PJX","\ff\SCREENS"     && SCREEN UPDATER
	   ON KEY LABEL F3 DO ("FFSUSPND")
	   m.PG_ERHANDL   = .f.         && use Foxfire! default error handler?
	   m.PG_ESCHANDL  = .t.         && use Foxfire! default escape handler?
	   IF ff_bhc
	      tmp_waserr = ON("ERROR")
	      ON ERROR *
	      DO ("Barrycfg")
	      ON ERROR &tmp_waserr
	   ENDIF
	ENDIF
	
	   IF UPPER(m.pf_name) = "SAMPLE"
	      RELEASE ctry1, ctry2
	      PUBLIC  ctry1, ctry2
	      ctry1 = "USA"
	      ctry2 = "Japan"
	   ENDIF
	   &&Makes you select a data group instead of displaying them all. Speeds up loading
	pg_hideallgroups =.T.
	*Global Email Message Server
	PG_MSGSVR                 =""   && Default:""
	*Mail Format (M for Mapi or S for SMTP)
	PG_MAILFMT                =""   && Default:"S"
	*Sender Name
	PG_MSGFM                  =""   && Default:"User"
	*Message From Email Address
	PG_MSGSDR                 =""   && Default:"reports@micromegasystems.com"
Case tcPhase ="REQUEST SETUP"
	* This phase is called on entering the request editor screen for both
	* new and existing requests or when a request is RUN/PREVIEW/COUNT, etc.
	* The request name is stored in m.rq_name
	* (which would be empty for new requests). The description of the
	* request type (detail, summary, or cross-tab) is stored
	* in m.rq_reqtype.  The descriptions of the 4 types of reports are
	* user-customizable and are stored in lb_* variables.  The three
	* variables (and their un-customized values) are:
	* m.lb_summary   = "Summary"
	* m.lb_basic     = "Detail"
	* m.lb_xtab      = "Cross-Tab"
	* m.lb_labels    = "Labels"
	
	* DO NOT CHANGE THESE LB_* VARIABLES HERE! If you wish to change them
	* do it in the GLOBAL SETUP phase above so that any changes persist.
	*
	* As an example of the type of configuration you might want to
	* perform in this phase, consider the possibility of limiting
	* access to data items based on the request type:
	*
	*   IF m.rq_reqtype = m.lb_summary
	*     m.gcUsrItmFilter = '"GROUP" $ UPPER(rdi_misc)'
	*   ENDIF
	*
	* Note: gcUsrItmFilter must be a character string containing an expression
	* which can be evaluated to a logical result.  It will be applied IN
	* ADDITION TO any Data Item filter defined in the active Preference (see
	* pf_fltitm).  FFSETVUE.PRG will impose a filter like this:
	* "SET FILTER TO (&pf_fltitm.) AND (&gcUsrItmFilter.)"
	
	* pg_reloadDataItems = .f.
	* Force Reload of data Items - Don't use cache and don't use currently loaded data items
	* This forces the data items to be reloaded into arrays when the next request is edited or
	* run. **The variable is then reset to false**. If you want the next request to trigger another
	* reload the variable must be reset again to .t. . SO, if you want to force a reload (and recache)
	* of the data items upon entry of FF! and then use them for the duration of the FF! run, set this
	* var to .T. in the global setup phase. If you want each request to reload Data items, set it to
	* .T. in the Request Setup phase.
	
	*  ff_excel = .t.
	* This enables Excel output options (pivot, launch, chart) in the Request
	* output selection screen.  In previous versions an environment check was
	* made in FFOXFIRE.PRG to check the registry for the existence of Excel on the
	* users machine to determine if these Excel options should be made available.
	* In VFP5, this check introduces instability such that users will receive fatal
	* application errors from the OS.  The current workaround, implemented here and
	* in the Global Setup phase (pg_look4execl = .f.), is to simply NOT make the
	* check for Excel, and enable the options regardless as to whether the users
	* machine has Excel installed.  There is sufficient error checking when attempting
	* to run any of the Excel output options such that if a user attempts to do so with
	* Excel not installed they will not crash the program.  Developers can remove these
	* Excel output options by setting FF_EXCEL = .F. if they know that Excel
	* doesn't exist.  ][bw
	
	*!*	   if m.rq_optbtn = 'NEW'
	*!*        * fix for batch cursor error.  This fixes problem of not being able
	*!*        * to print to non-default printer when running using the batch cursor
	*!*	      m.out_wdftpr = .F.
	*!*	      m.out_wpaper = 1
	*!*	      m.out_worien = 1		 && ][BLW  yeah, but it broke regular printing
	*!*	   endif
Case tcPhase ="BEFORE SQL GENERATION"
	* This phase is called just before the SQL is Generated.
Case tcPhase ="BEFORE FRX GENERATION"
	* This phase is called at the beginning of the frx generation.
	* Some variables of interest are:
	* m.frx_format  = "Character" | "GUI"
	*
	* FOR BOTH CHARACTER & GUI REPORTS
	* --------------------------------
	* m.rq_reqtype   = <see m.lb_* above>   && request types
	*
	* FOR GUI REPORTS ONLY
	* --------------------
	* tmp_prtrdef   = "Request" | "Preference" | "Windows"  (printer default -- for _Windows only)
	* tmp_orient    = "Portrait" | "Lanscape" | "n/a"
	* m.Paper_width = Width of paper in 10,000ths of an inch
	*                 ie: 85000 = 8.5 inches **FOR GUI ONLY**
	* tmp_style     = Report style (ie "Executive")
	*
	* The Band Font specifications from FFSTYLEF (Alias Rpt_Style) have been scattered
	* into memvars and will be used only from the memvars so you are free to change them here.
	*
	* FOR CHARACTER REPORT ONLY
	* -------------------------
	* m.out_lndscp = 1-> ON 2->OFF 3->Auto
	* m.fld_totwid = number of character
	*

Case tcPhase ="AFTER FRX GENERATION"
	* This phase is called after the FRX has been generated. You can reset any changes
	* made in the BEFORE FRX GENERATION phase here. Ret_val is .T. or .F. depending on
	* whether the FRX was succesfully generated.
	*
	* Layout name (FRX/LBX) is in Frx_name

Case tcPhase ="BEFORE SELECT"
	* This phase is called just before the SQL SELECT is executed.
	* The select that is issued is
	*    SELECT &q_distinct &q_fields  &q_from   &sql_dest  &out_name;
	*           &q_where    &q_group   &q_union  &q_order
	*
	* Variables:
	* q_distinct = Either "DISTINCT" or "ALL"
	* q_fields   = Field list
	* q_from     = From tables
	* sql_dest   = Output Type ("CURSOR","ARRAY")
	* out_name   = Output name
	* q_where    = Where Clause (Join Conditions) AND (Filter condtions)
	* q_group    = Group clause
	* q_union    = Union clause (whole Select statement)
	* q_order    = Order Clause
	*
	
	* Filter information is also available in the filter arrays:
	*  (the subscript corresponds to the filter line)
	*
	*   flt_key[]  = The selected key field
	*   flt_not[]  = If not is selected (t/f)
	*   flt_opr[]  = The filter operator
	*   flt_val[]  = Filter comparision value  ***(including those supplied at runtime)***
	*   flt_vop[]  = Filter value option: Empty/Data_Item/Expr
	*   flt_ask[]  = .T. if ask-at-Runtime
	*   flt_mod[]  = "Yes" if whole line is editable or "Val" if just the value is editable at runtime
	*
	* If the variable ret_val is set to .F. the select will not be run and
	* the request will terminate processing.
	*
	* If you wish to execute your own SELECT (via ODBC, Oracle, etc) then
	* set m.pg_SQLEXECUTE = .F. to prevent Foxfire! from executing the above
	* select statement.  Foxfire! will still try to run the Output as
	* specified in the Request.
	*
	* If the filter line is to be ignored then the operator is changed to "Ignore"
	*
	* Developer's note: if you make use of the SET ANSI command, Foxfire!
	* will respect its setting as established in your environment.  We
	* have developed this code assuming that SET("ANSI") = "OFF", so
	* exercise caution. If ANSI is ON then Rushmore will be disabled unless
	* EXACT is also ON.
	
	
Case tcPhase ="AFTER SELECT"
	* This phase is called after the SQL SELECT has been executed and
	* before any output processing (ie: reporting) has started.
	* As a result, the current work area contains a cursor (pseudo-DBF)
	* whose alias is the Request name.
	* In this phase, you may use the results of the query for whatever
	* purpose you wish.  Keep in mind that if you change work areas,
	* you must close the cursor explicitly to free up its work area.
	* If you change the work area, further processing of the Request
	* (creating actual output, etc) will operate against the table
	* in the NEW work area, not the cursor.
	*
	* sql_tally will contain the number of records selected by the query
	*
	* EXCEPTION -- if output type is 'Data-Array', the result table is
	* NOT a cursor, but an array. The array has the same name as the
	* Request.
	*
	* Example -- see sample request QUARTILE
	IF UPPER(m.pf_name) = "SAMPLE" AND TYPE("QUARTILE") = "N"
	   * This is an example of a Request that requires a second, custom
	   * pass through the data prior to reporting. The query has a
	   * 'quartile' field in it, and in order to determine what quartile
	   * a particular row falls into, we need to know totalling information
	   * that is not available until the first pass is completed.  This means
	   * we have to store the contents of the cursor as a DBF and make a
	   * second, customized pass through the data, allowing our output to
	   * be created on the basis of the new DBF.  Note: we use a DBF rather
	   * than a second cursor since FoxPro cursors may or may not have a
	   * DBF header on file, which is required to perform a further SELECT.
	
	   WAIT WINDOW "Foxfire! sample query: calculating quartiles "+;
	       "(SEE FFCONFIG.PRG) " NOWAIT
	   PRIVATE lcWasAlias,lcTempName
	   lcWasAlias = ALIAS()
	   lcTempName = sys(3)
	   COPY ALL TO (lcTempName)   && Exchange the cursor for a datafile
	    * Same work area Calculate quartiles based on the current order
	   USE (lcTempName) ALIAS TEMP_QUART EXCL
	   REPLACE ALL quartile WITH CEILING(recno()/reccount()*4)
	   PRIVATE lcNoFilter
	   lcNoFilter = IIF(ff_FPVersion >= 5, "NOFILTER","")
	   SELECT * FROM TEMP_QUART INTO CURSOR &lcWasAlias  &lcNoFilter
	   USE IN TEMP_QUART
	   DELETE FILE (lcTempName + ".dbf")
	 ENDIF
Case tcPhase ="BEFORE REPORT"
	* This phase is called just before the report is run.
	* lcRepoCmd  will contain the report form Command
	* llRepoRun  is a logical, if .f. the report command will not be run by Foxfire!.
	
	IF "*:GENREPOX" $ M.RQ_NOTES
	      DO ("GENREPOX") WITH lcRepoCmd
	      llRepoRun = .f.
	ELSE
	      llRepoRun = .t.
	ENDIF
	RETURN
Case tcPhase ="AFTER OUTPUT"
	* This phase is called when running, previewing, or counting any request.
	* Its called after the ouput has been produced.
	* This phase can be used to cleanup anything from the Before Select phase.
	* sql_tally will contain the number of records selected by the query.
Case tcPhase ="BATCH BUILDER ADD"
	* This phase is called when the Batch Builder is used to add a record to a batch.
	* The new record is added to a cursor with the alias Tmp_Batch (which has the
	* same structure as a batch file) which is SELECTed and all its default fields
	* are filled in. You may change values in Tmp_Batch.
	* To prevent the "add" from taking place, set llBatchAdd to .F. (DO NOT DELETE THE RECORD).
Case tcPhase ="BATCH BUILDER RUN"
	* This phase is called when the Batch Builder is requested to run the currently
	* loaded batch. The current batch cursor is SELECTed. You may change values here.
	* To cancel the run set llBatchRun to .F.
Case tcPhase ="CLEANUP"
	* This phase is called on the way out of Foxfire!.
	* If you used any of the other phases above to execute code, you
	* may need to write additional code here to clean up (release variables,
	* close files, etc.)
	
	* FF_EXIT is a public variable that will say how Foxfire! was terminated
	* The possible values are
	* "EXIT"     = normal exit
	* "SHUTDOWN" = User attempted to shutdown while a host app READ was still pending
	*              Foxfire! terminates and control is passed back to the host app.
	* "QUIT"     = User attempted to Shutdown while no host app read was in affect.
	*              FoxPro for Windows will terminate.
*!*		CLOSE TABLES all
	* Drop variables established for sample code in GLOBAL SETUP phase
	IF UPPER(m.pf_name) = "SAMPLE"
	   RELEASE ctry1, ctry2
	ENDIF
*!*		CLOSE TABLES all
Case tcPhase ="QUEUE JOB"
	* Note: server features are not available in Developer's Edition or
	* standalone versions.  Client/server version is available separately
	
	* This phase is called when a job is placed in the queue for the Server.
	* The request has been copied out to FFJOBREQ (and is the current record)
	* A record has been added to FFJOBQUE and is selected and is the current record.
	* You may abort the Job Queue by setting the variable lcQueError to any string
	* (which will shown to the user), otherwise, the record will be marked as "Pending" .
	*
	* This would be the place to warn or turnback requests if no servers are running
	*             CREATE TABLE (m.pf_SVQueFl) ;
	*                (cJobType   M,;
	*                 cRq_name   C(8),;
	*                 cDescript  M,;
	*                 cRunName   C(8),;
	*                 cAction    C(40),;
	*                 cUser      C(MAX(10,LEN(FFPREFER.pf_user))),;
	*                 cDept      C(LEN(FFPREFER.pf_Dept)),;
	*                 cPrefSet   C(20),;
	*                 cStatus    C(12),;
	*                 nPriority  N(1),;
	*                 cConfig    M,;
	*                 cHeading   M,;
	*                 cFltDisp   M,;
	*                 cFrx       M,;
	*                 cFrt       M,;
	*                 aDataFiles M,;
	*                 dDtSubmit  D,;
	*                 cTmSubmit  C(8),;
	*                 dDtStart   D,;
	*                 cTmStart   C(8),;
	*                 dDtEnd     D,;
	*                 cTmEnd     C(8),;
	*                 cServer    M,;
	*                 nCount     N(9,0),;
	*                 cError     M,;
	*                 cRq_type   C(3),;
	*                 cRq_Reqtyp C(9),;
	*                 cSendto    C(7),;
	*                 cOut_type  M,;
	*                 cPlatform  C(3))
Case tcPhase ="BEFORE EMAIL"
	* If you don't want to use Foxfire! built in Email support, you can set the value of ret_val to .F.
	* and reference the values yourself here. The file is called pcOutFile and the to is PcTo
	* Users may want to change settings like
	
Case tcPhase ="AFTER EMAIL"
	*
Case tcPhase ="PDF OUTPUT"
	* This section is for your OWN PDF Output engine
Case tcPhase ="BEFORE IMPORT"
	*
Case tcPhase ="AFTER IMPORT SUCCESS"
	*
Case tcPhase ="BEFORE EXPORT"
	*
	
Case tcPhase ="AFTER EXPORT SUCCESS"
	*
Case tcPhase ="NEW SERVER RECORD"
	* Note: server features are not available in Developer's Edition or
	* standalone versions.  Client/server version is available separately
	
	* This phase is called after a new server record is added. By default it will be
	* enabled to process all submitted jobs. If you want to restrict it, this it the
	* place to change some of the fields.
	*
	* Structure:     cName      C(25),;
	*                 cStatus    C(7),;
	*                 cPlatform  C(3),;
	*                 dDtStart   D,;
	*                 cTmStart   C(8),;
	*                 dDtStatChg D,;
	*                 cTmStatChg C(8),;
	*                 cQueueFile M,;
	*                 cJobTypes  M,;    && ie: Foxfire! Request
	*                 cPrefSets  M,;    && String of enabled preference sets
	*                 cReqTypes  M,;    && Detail/Summary/Cross-tab/Labels
	*                 nMinPrior  N(1),;
	*                 nMaxPrior  N(1),;
	*                 nSuccess   N(5),;
	*                 nFailed    N(4))
Case tcPhase ="BEFORE CONNECTION"
	* just before sql connect()
Case tcPhase ="AFTER CONNECTION"
	* just after sql connect()
Case tcPhase ="BEFORE DISCONNECT"
	* just before sql disconnect()
Case tcPhase ="AFTER DISCONNECT"
	* just after sql disconnect()
Case tcPhase ="AFTER USER LOGIN"
	* just after user login
ENDCASE

RETURN   && FFCONFIG main procedure

*Detailed specifications -- Initial Preference Set determination
* (when Foxfire! is called with a first parameter of "REQUESTS"):
*
*1. Is there a Preference Set file open (alias FFPREFER)?  If yes, use the
*   current record from that file and do NOT execute the 'Preference File
*   Setup' phase of the configuration program, and return control to the
*   calling program. If no, DO execute that phase, starting at step 2.
*
*2. Attempt to open a Preference Set file (by default, FFPREFER.DBF).  If
*   not successful, warn the user and terminate.  If the file is opened, and
*   only one record is present, use that as the initial Preference Set and
*   return control to the calling program. Otherwise, go to step 3.
*
*3. If a file FOXFIRE.INI exists, open it and grab the first line, using
*   that as the name of a Preference Set to seek (jump to step 6).  If the
*   file is not present or cannot be opened, go to step 4.
*
*4. If a DOS environment variable FOXFIRE.INI exists, use its value as the
*   name of a Preference Set to seek (jump to step 6).  Otherwise, go to
*   step 5.
*
*5. If the variable m.lcWhatPref is not empty, use its value as the name to
*   seek (go to step 6).  Otherwise, jump to step 7.
*
*6. Using the name determined above, search the file for a record with a
*   matching name.  If found, use that as the initial Preference Set and
*   return control to the calling program. If not found, go to step 7.
*
*7. If no value for an initial Preference Set can be determined, Foxfire!
*   will look in the Preference Set file to see if there are one or more
*   records.  If none, an error message will be issued.  If only one record
*   is found, Foxfire! will use that as the initial Preference Set.  If more
*   than one record is found, Foxfire! will display a picklist of
*   Preference Set names and allow the user to select one. If the user
*   cancels without selecting a Preference Set, Foxfire! will terminate.
*   If the user does select an initial Preference Set, return contro