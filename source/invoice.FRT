   �   !                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        �(�Y����Љ_�lp?      Times New Roman��C�k���      H  (  winspool HP DeskJet 720C Series \\Computut01\hp                                         �HP DeskJet 720C Series           7� ��      d   ,  ,                                                                             HP DeskJet 720C Series                                          \\Computut01\hp                                                                                                                          ��	                                                ,,                 �DRIVER=winspool
DEVICE=HP DeskJet 720C Series
OUTPUT=\\Computut01\hp
ORIENTATION=0
PAPERSIZE=1
COPIES=1
DEFAULTSOURCE=1
PRINTQUALITY=300
COLOR=2
DUPLEX=1
YRESOLUTION=300
TTOPTION=1
COLLATE=0
                         invoice.invno                  invdetail.descr                                               Times New Roman                invdetail.price                                               Times New Roman                invdetail.price>0              "999999.99"                    invoice.invtot                                                Times New Roman                "999999.99"                    invoice.payments                                              Times New Roman                "999999.99"                    invoice.baldue                                                Times New Roman                "999999.99"                    :ALLTRIM(invoice.contfname)+" "+ ALLTRIM(invoice.contlname)                                     Times New Roman                invoice.schname                                               Times New Roman                invoice.schaddr                                               Times New Roman                invoice.schaddr2                                              Times New Roman                VALLTRIM(invoice.schcity)+", "+ ALLTRIM(invoice.schstate)+"  "+ ALLTRIM(invoice.schzip)                                          Times New Roman                DATE()                                                        Times New Roman                invoice.invno                                                 Times New Roman                invoice.ponum                                                 Times New Roman                8ALLTRIM(invoice.contryear)+"-"+ ALLTRIM(invoice.schcode)                                       Times New Roman                Times New Roman                invoice.book_ea>0                                             "Book Base Price"              invoice.book_ea                                               Times New Roman                invoice.book_ea>0              Times New Roman                invoice.nopages>0                                             "Pages"                        invoice.nopages                                               Times New Roman                invoice.nopages>0              Times New Roman                invoice.nocopies>0                                            "Copies"                       invoice.nocopies                                              Times New Roman                invoice.nocopies >0            "invoice.nocopies * invoice.book_ea                                                             Times New Roman                )invoice.nocopies >0 AND invoice.book_ea>0                       "999999.99"                    invdetail.price                                               Times New Roman                invdetail.price<0              "999999.99"                    Times New Roman                dataenvironment                yLeft = 107
Top = 244
Width = 520
Height = 370
AutoOpenTables = .T.
AutoCloseTables = .T.
Name = "Dataenvironment"
         cursor                         �Left = 10
Top = 20
Width = 90
Height = 279
Alias = "invoice"
Database = m:\mbc5\mbc.dbc
CursorSource = "invoice"
Name = "Cursor1"
                         cursor                         �Left = 150
Top = 20
Width = 90
Height = 168
Alias = "invdetail"
Database = m:\mbc5\mbc.dbc
CursorSource = "invdetail"
Name = "Cursor2"
                    relation                       wParentAlias = "invoice"
RelationalExpr = "invno"
ChildAlias = "invdetail"
ChildOrder = "invno"
Name = "Relation1"
            