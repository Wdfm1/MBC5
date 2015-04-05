*When I run the code in this message with {^2003/06/06} and {^2003/06/11} I get 4.
*What do you get? I sure hope 4!
ddate1=ctod('06\06\03')
ddate2=ctod('06\11\03')

*LPARAMETERS dDate1, dDate2
LOCAL wks, wkd
hd = MAX(ddate1,ddate2)
ld = Min(ddate1,ddate2)

wks = INT( (hd - ld)/ 7)

* Return Weeks * 5 which is overal workdays
* Adjust for starting day of the first week
* And adjust for the last partial week

RETURN ;
    INT(wks * 5 + ;
    IIF(DOW(ld,2) < 6, 6-DOW(ld,2),0) + ;
    IIF(DOW(hd,2) < 6, DOW(hd,2),0) )

