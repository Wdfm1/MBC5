on error  PlanB()

if !file("C:\WINDOWS\system32\vfp9r.dll")
copy file m:\UpdateExe\vfp9r.dll TO C:\WINDOWS\system32
endif

if !file("C:\WINDOWS\system32\vfp9rchs.dll")
copy file m:\UpdateExe\vfp9rchs.dll TO C:\WINDOWS\system32
endif

if !file("C:\WINDOWS\system32\vfp9rcht.dll")
copy file m:\UpdateExe\vfp9rcht.dll TO C:\WINDOWS\system32
endif

if !file("C:\WINDOWS\system32\vfp9rcsy.dll")
copy file m:\UpdateExe\vfp9rcsy.dll TO C:\WINDOWS\system32
endif

if !file("C:\WINDOWS\system32\vfp9rdeu.dll")
copy file m:\UpdateExe\vfp9rdeu.dll TO C:\WINDOWS\system32
endif

if !file("C:\WINDOWS\system32\vfp9RENU.dll")
copy file m:\UpdateExe\vfp9RENU.dll TO C:\WINDOWS\system32
endif

if !file("C:\WINDOWS\system32\vfp9resn.dll")
copy file m:\UpdateExe\vfp9resn.dll TO C:\WINDOWS\system32
endif

if !file("C:\WINDOWS\system32\vfp9rfra.dll")
copy file m:\UpdateExe\vfp9rfra.dll TO C:\WINDOWS\system32
endif

if !file("C:\WINDOWS\system32\vfp9rkor.dll")
copy file m:\UpdateExe\vfp9rkor.dll TO C:\WINDOWS\system32
endif

if !file("C:\WINDOWS\system32\vfp9rrus.dll")
copy file m:\UpdateExe\vfp9rrus.dll TO C:\WINDOWS\system32
endif

if !file("C:\WINDOWS\system32\vfp9t.dll")
copy file m:\UpdateExe\vfp9t.dll TO C:\WINDOWS\system32
endif

if !file("C:\WINDOWS\system32\vfpodbc.dll")
copy file m:\UpdateExe\vfpodbc.dll TO C:\WINDOWS\system32
*!*	** assume if got here then all files have been copied log it, if not log will not be create or added to
cstring=chr(13)+chr(10)+sys(0) + " "+ttoc(datetime())
strtofile(cstring,"m:\UpdateExe\copiedruntimes.txt",.t.)
release loWinsock
release caddres

endif

do it




Procedure planB

cstring=chr(13)+chr(10)+sys(0) + " "+ttoc(datetime())
strtofile(cstring,"m:\UpdateExe\Errorcopiedruntimes.txt",.t.)

do it
cancel &&cancels further execution after it is ran if not it is ran a second time

