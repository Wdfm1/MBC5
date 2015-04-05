*!*	USE BASICYEAR11.dbf IN 0
SELECT acyear10

num=1
FOR i =12 TO 300 STEP 4
num=num+1 
Ccol="column"+ALLTRIM(STR(num))
ncol="pg"+ALLTRIM(STR(i))

ALTER table basicyear10 rename &Ccol to &ncol 
ALTER table acyear10 alter COLUMN &ncol numeric(7,2) 
endfor

