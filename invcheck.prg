m.invno=invoice.invno
SELECT xtra
Nextratotal=xtra.extrbktot+xtra.prev_othr
sele invdetail
set order to invno
seek m.invno
if found()
sum invdetail.price;
	for invdetail.invno=m.invno .and. !deleted();
	to m.invtot
m.invtot= m.invtot+quotes.book_price
ELSE
RETURN .t. &&invoice has not been created
m.invtot=0
endif
IF m.invtot!=quotes.adjbef+Nextratotal
MESSAGEBOX("Invoice is incorrect. Do invoice overide and check invoice details."+CHR(13)+"Make sure all detail lines are showing."+CHR(13)+"You will not be able to move off current record until error is fixed or sales screen is closed.",16,"Invoice Error")
if (alltrim(oApp.cnauser) =="TAMMY")
RETURN .t.
else
RETURN .f.
endif
ELSE
RETURN .t.
endif