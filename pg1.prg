use xtra in 0
select xtra
a=0
scan
if xtra.extrabooks>0
repl xtra.exonhand with xtra.extrabooks-xtra.extrbkshpd-xtra.exreplshpd
a=a+1
endif
endscan
messagebox(str(a))