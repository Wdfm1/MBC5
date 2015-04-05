*procedure i_dblclk
*
private all like l_*

if mrow() # m.g_lastrow or ;
   mcol() # m.g_lastcol or ;
   (seco() - g_lastcllk) > _DBLCLICK
	m.g_lastrow = mrow()
	m.g_lastcol = mcol()
	m.g_lastcllk = seco()
else
	**** same row and col within _DBLCLICK seconds!
	keyb chr(23)
endif
