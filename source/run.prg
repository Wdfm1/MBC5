
*set up enviroment

	SET TALK OFF
	_screen.Visible=.f.
	

*determine version Numbers that we are working with
on error do form notification
DIMENSION adesktopversion[1]
AGETFILEVERSION(adesktopversion,"C:\Mbc5\mbc5.EXE")
desktopversion= adesktopversion[4]
on error newversion="0"
DIMENSION aserverversion[1]
AGETFILEVERSION(aserverversion,"M:\UpdateExe\mbc5.EXE")
newversion= aserverversion[4]
*determine if a new file exist, if so copy to users desktop
if newversion>desktopversion




else&&no update go as normal
run /N C:\Mbc5\mbc5.exe
endif
