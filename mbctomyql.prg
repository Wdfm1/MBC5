SELECT cust
 
a=RECCOUNT()
b=0
nConnectionHandle = SQLStringConnect( "DRIVER={MySQL ODBC 5.1 Driver};DESC=;DATABASE=mbc;SERVER=databases;UID=root;PASSWORD=3l3phant1;PORT=;OPTION=16;STMT=;" )
SCAN
b=b+1
SCATTER memvar
SQLEXEC(nConnectionHandle,"insert into cust (schname,schaddr,schaddr2,schcity,schstate,schzip,schphone,schfax,schcode) values('"+m.schname+"','"+m.schaddr+"','"+m.schaddr2+"','"+m.schcity+"','"+m.schstate+"','"+m.schzip+"','"+m.schphone+"','"+m.schfax + "','"+m.schcode+"');")

WAIT NOWAIT WINDOW STR(b)+" of " +STR(a)
SELECT cust
ENDSCAN

SQLDISCONNECT(m.lnConn)











