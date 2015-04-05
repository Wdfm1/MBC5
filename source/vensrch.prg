define window jbrowser from 15, 5 to 23, 75 ;
	color scheme 10 ;
	close float grow zoom

*select 1
sele vendor
set order to vendcd
_JEXITKEY = 13 && char 13 (enter) ends jKey.
_JDBLCLICK = -1 && Timeout for resetting search

store -1 to m.g_lastrow, m.g_lastcol, m.g_lastcllk

=jKeyInit("U", "", "Search For: ")
on key label leftmouse do i_dblclk
brow window jbrowser fiel vendcd,vname,vcontact,lstprodno,speccvno

on key label leftmouse
=jKeyCanc()
