If you have trouble with Mail Manager not running, do the following:


Save all the following files to the root of the c:\mbc5 directory.

msmapi32.ocx
MailManager.vcx
MailManager.vct
 

Then, from the DOS prompt type:  regsvr32 /s c:\mbc5\msmapi32.ocx

Find the test.reg file in the mail manager directory and double click it to register the Mail Manager.

(I keep copies of the msmapi32.ocx and the test.reg files in the root directory of the m:\ drive of the MBC server)