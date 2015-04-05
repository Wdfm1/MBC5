

PROCEDURE errHandler

   PARAMETER merror, mess, mess1, mprog, mlineno,selectedtable



aa=ttoc(datetime())
 a='Error number: ' + LTRIM(STR(merror))

b= 'Error message: ' + mess

 c= 'Line of code with error: ' + mess1

d= 'Line number of error: ' + LTRIM(STR(mlineno))

e= 'Program with error: ' + mprog
   
f= 'Table selected:' + selectedtable

mstring=chr(13)+chr(10)+aa+chr(13)+chr(10)+a+chr(13)+chr(10)+b+chr(13)+chr(10)+c+chr(13)+chr(10)+d+chr(13)+chr(10)+e+chr(13)+chr(10)+f+chr(13)+chr(10)
*!*	messagebox(mstring)
strtofile(mstring,"c:\tmp\bidserror.txt",.t.)
Messagebox("There has been an error on this form. Please close this form and then restart it.",0,"Error")

ENDPROC