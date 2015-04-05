lparameter srinvno
define window jbrowser from 15,5 to 23,75;
	color scheme 10;
	close float grow zoom
*sele cust
*set order to schname	
use quotes again in 0 shar alias qt2
sele qt2
*set order to schcode
*sele cust
*set rela to schcode into quotes
*set skip to quotes
*sele quotes
set order to prodno
_jexitkey=13
_jdblclick=-1

store -1 to m.g_lastrow,m.g_lastcol,m.g_lastcllk

=jkeyinit("A","","Search For: ")
*on key label leftmouse do i_dblclk
brow window jbrowser fiel qt2.prodno,qt2.schname,;
qt2.schcode,qt2.invno,qt2.nopages,qt2.nocopies noedit nodelete

*on key label leftmouse
=jkeycanc()
release wind jbrowser
srinvno=qt2.invno
sele qt2
use
*return srinvno
*set order to schcode
*msrch=quotes.schcode
*sele cust
*set order to schcode
*seek msrch
*sele quotes

	