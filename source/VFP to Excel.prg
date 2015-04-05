

LPARAMETERS tc_Table, tc_Spreadsheet, tl_Headers

LOCAL lo_Excel
LOCAL ln_MBox_Return
LOCAL ln_PrevArea
LOCAL ln_TotalRec
LOCAL lc_TotalRec
LOCAL ARRAY la_Fields[1]
LOCAL ln_NumFields
LOCAL ln_CurrentRow
LOCAL ll_Old_DisplayAlerts
LOCAL ln_Loop
LOCAL ln_CurrentRec
LOCAL lc_Field
LOCAL lc_LastCell
LOCAL ln_ColumnWidth


**
** Make sure at least two parameters.
**
IF PCOUNT() < 2
   = MESSAGEBOX( "Must have at least 2 parameters.", 0, PROGRAM() )
   RETURN
ENDIF

**
** Create an Excel object.
**
lo_Excel = .NULL.
lo_Excel = CREATEOBJECT( "Excel.Application" )

**
** Make sure the object was created.
**
IF ISNULL(lo_Excel)
   = MESSAGEBOX( "Excel does not appear to be installed, or is an incompatible version.", 0, PROGRAM() )
   RETURN
ENDIF

**
** Make sure expected version of Excel is installed.
**
IF LEFT( lo_Excel.VERSION, 1 ) <> "8"

   ln_MBox_Return = ;
      MESSAGEBOX( "This program was not designed to run with the version of Excel on your machine." + ;
      CHR(13) + CHR(13) + ;
      "Do you want to continue?", 4, PROGRAM() )

   IF ln_MBox_Return = 7
      RETURN
   ENDIF

ENDIF

**
** Save the current work area.
**
ln_PrevArea = SELECT()
SELECT 0

**
** Open the specified table.
**
USE (tc_Table) ALIAS XL_Table

**
** Get total number of records in the table.
**
ln_TotalRec = RECCOUNT()
lc_TotalRec = ALLTRIM(STR(ln_TotalRec))

**
** Get an array of all the fields in the table.
**
ln_NumFields = AFIELDS(la_Fields)

**
** Initialize a spreadsheet row counter.
**
ln_CurrentRow = 0

**
** Create a spreadsheet, modify it, and save it.
**
WITH lo_Excel

   **
   ** Add a workbook (spreadsheet).
   **
   .Workbooks.ADD()

   **
   ** Remove all sheets except the first.
   ** We're only filling the first sheet.
   **
   ll_Old_DisplayAlerts = .DisplayAlerts
   .DisplayAlerts = .F.
   DO WHILE .Sheets.COUNT > 1
      .Sheets(2).DELETE()
   ENDDO
   .DisplayAlerts = ll_Old_DisplayAlerts

   **
   ** Rename the first sheet to the table's name.
   **
   .Sheets(1).NAME = UPPER( JUSTSTEM(tc_Table) )

   **
   ** Add column headers (field names) if specified.
   **
   IF tl_Headers

      **
      ** Increment the row counter.
      **
      ln_CurrentRow = ln_CurrentRow + 1

      **
      ** Add each field name to its respective column.
      **
      FOR ln_Loop = 1 TO ln_NumFields

         .Cells( ln_CurrentRow, ln_Loop ).VALUE = la_Fields[ ln_Loop, 1 ]

      ENDFOR

   ENDIF

   **
   ** Initialize a record counter.
   **
   ln_CurrentRec = 0

   **
   ** Loop through the table, adding each field's data to the spreadsheet.
   **
   SCAN

      **
      ** Increment the record counter.
      **
      ln_CurrentRec = ln_CurrentRec + 1

      **
      ** Update the WAIT message.
      **
      IF MOD( ln_CurrentRec, 10 ) = 0
         WAIT WINDOW NOWAIT "Processed " + ALLTRIM(STR(ln_CurrentRec)) + " of " + lc_TotalRec + "..."
      ENDIF

      **
      ** Increment the row counter.
      **
      ln_CurrentRow = ln_CurrentRow + 1

      **
      ** Add each field to the appropriate cell.
      **
      FOR ln_Loop = 1 TO ln_NumFields

         lc_Field = "XL_Table." + la_Fields[ ln_Loop, 1 ]

         DO CASE

            CASE la_Fields[ ln_Loop, 2 ] = "G"

               ** General field.

               .Cells( ln_CurrentRow, ln_Loop ).VALUE = "*General*"

            CASE la_Fields[ ln_Loop, 2 ] = "M"

               ** Memo field.

               .Cells( ln_CurrentRow, ln_Loop ).VALUE = STRTRAN( &lc_Field, CHR(13) + CHR(10), CHR(10) )

            CASE INLIST( la_Fields[ ln_Loop, 2 ], "D", "T" ) .AND. EMPTY( &lc_Field )

               ** Empty date, skip since it will error.

            CASE la_Fields[ ln_Loop, 2 ] = "C"

               ** Character field.
               ** Trim off any trailing spaces.

               .Cells( ln_CurrentRow, ln_Loop ).VALUE = RTRIM(&lc_Field)

            OTHERWISE

               ** Any other field.

               .Cells( ln_CurrentRow, ln_Loop ).VALUE = &lc_Field

         ENDCASE

      ENDFOR

   ENDSCAN

   **
   ** Remove the WAIT message.
   **
   WAIT CLEAR

   **
   ** Get a reference to the last cell filled.
   **
   lc_LastCell = .Cells( ln_CurrentRow, ln_NumFields ).Address( .F., .F. )

   **
   ** Set the font for the cells that were just filled.
   **
   WITH .RANGE( "A1:" + lc_LastCell ).FONT
      .NAME = "Courier New"
      .SIZE = 8
   ENDWITH

   **
   ** Make header row bold.
   **
   IF tl_Headers

      lc_LastCell = .Cells( 1, ln_NumFields ).Address( .F., .F. )

      WITH .RANGE( "A1:" + lc_LastCell ).FONT
         .BOLD = .T.
      ENDWITH

   ENDIF

   **
   ** Modify the column widths (of the columns filled) to fit the data.
   **
   FOR ln_Loop = 1 TO ln_NumFields

      **
      ** Determine what data type this field is.
      **
      DO CASE

         CASE la_Fields[ ln_Loop, 2 ] = "C"

            ln_ColumnWidth = la_Fields[ ln_Loop, 3 ]

         CASE la_Fields[ ln_Loop, 2 ] = "D"

            ln_ColumnWidth = 10

            .RANGE( .Cells( IIF( tl_Headers, 2, 1 ), ln_Loop ).Address( .F., .F. ) + ":" + ;
               .Cells( ln_CurrentRow, ln_Loop ).Address( .F., .F. ) ).NumberFormat = "mm/dd/yyyy"

         CASE la_Fields[ ln_Loop, 2 ] = "L"

            ln_ColumnWidth = 5

         CASE la_Fields[ ln_Loop, 2 ] = "M"

            ln_ColumnWidth = 80 && ??

         CASE la_Fields[ ln_Loop, 2 ] = "N"

            ln_ColumnWidth = la_Fields[ ln_Loop, 3 ]

         CASE la_Fields[ ln_Loop, 2 ] = "F"

            ln_ColumnWidth = la_Fields[ ln_Loop, 3 ]

         CASE la_Fields[ ln_Loop, 2 ] = "I"

            ln_ColumnWidth = la_Fields[ ln_Loop, 3 ]

         CASE la_Fields[ ln_Loop, 2 ] = "B"

            ln_ColumnWidth = la_Fields[ ln_Loop, 3 ]

         CASE la_Fields[ ln_Loop, 2 ] = "Y"

            ln_ColumnWidth = la_Fields[ ln_Loop, 3 ]

         CASE la_Fields[ ln_Loop, 2 ] = "T"

            ln_ColumnWidth = 22

            .RANGE( .Cells( IIF( tl_Headers, 2, 1 ), ln_Loop ).Address( .F., .F. ) + ":" + ;
               .Cells( ln_CurrentRow, ln_Loop ).Address( .F., .F. ) ).NumberFormat = "mm/dd/yyyy hh:mm:ss AM/PM"

         CASE la_Fields[ ln_Loop, 2 ] = "G"

            ln_ColumnWidth = 9

         OTHERWISE

            ln_ColumnWidth = la_Fields[ ln_Loop, 3 ]

      ENDCASE

      **
      ** Make sure the column is wide enough to show the header text.
      **
      IF tl_Headers

         ln_ColumnWidth = MAX(  ln_ColumnWidth, LEN( ALLTRIM( la_Fields[ ln_Loop, 1 ] ) )  )

      ENDIF

      **
      ** Set the column width.
      **
      .COLUMNS( ln_Loop ).COLUMNWIDTH = ln_ColumnWidth

   ENDFOR

   **
   ** Delete the file first if it already exists.
   **
   IF FILE(tc_Spreadsheet)
      DELETE FILE (tc_Spreadsheet)
   ENDIF

   **
   ** Save the spreadsheet to the specified file name.
   **
   ll_Old_DisplayAlerts = .DisplayAlerts
   .DisplayAlerts = .F.
   .ActiveWorkbook.SAVEAS(tc_Spreadsheet)
   .DisplayAlerts = ll_Old_DisplayAlerts

   **
   ** Close the spreadsheet.
   **
   .ActiveWorkbook.CLOSE()

ENDWITH

**
** Release the Excel object.
**
lo_Excel.QUIT()
lo_Excel = .NULL.
RELEASE lo_Excel

**
** Close the table and restore the previous work area.
**
USE
SELECT (ln_PrevArea)
