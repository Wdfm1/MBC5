SET STEP ON 
set classlib to BASEAPP, BASETBR
info= createobject("AuthReq")
o = CREATEOBJECT("MSSoap.SoapClient30")
info.CardNum=123
? o.MSSoapInit("http://cmain1/AuthNetService.asmx?WSDL")          
a="<cardnum>12345</cardnum>"
b=o.Capture(a)
              
xc=""
