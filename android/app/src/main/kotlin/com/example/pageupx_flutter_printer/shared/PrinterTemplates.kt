package com.example.pageupx_flutter_printer.shared

object PrinterTemplates {

    object Content {

        const val IN =
            "^DFR:In.ZPL^FS\n" +
                    "~TA000\n" +
                    "~JSN\n" +
                    "^LT0\n" +
                    "^MTT\n" +
                    "^PON\n" +
                    "^PMN\n" +
                    "^LH0,0\n" +
                    "^JMA\n" +
                    "^PR8,8\n" +
                    "~SD15\n" +
                    "^JUS\n" +
                    "^LRN\n" +
                    "^CI28\n" +
                    "^PA0,1,1,0\n" +
                    "^MMT\n" +
                    "^PW607\n" +
                    "^LL408\n" +
                    "^LS0\n" +
                    "^FT24,67^A@N,17,18,TT0003M_^FH\\^CI28^FDNuméro de demande : ^FS^CI27\n" +
                    "^FT24,99^A@N,17,18,TT0003M_^FH\\^CI28^FDNom du fournisseur / transporteur :^FS^CI27\n" +
                    "^FT24,132^A@N,17,18,TT0003M_^FH\\^CI28^FDNature de la marchandise :^FS^CI27\n" +
                    "^FT24,167^A@N,17,18,TT0003M_^FH\\^CI28^FDDESTINATION :^FS^CI27\n" +
                    "^FPH,42^FT24,292^AAN,54,30^FH\\^FDE^FS\n" +
                    "^BY3,3,112^FT74,327^BCN,,Y,N,,A\n" +
                    "^FN1\"varbarcode\"^FS\n" +
                    "^FPH,3^FT214,66^A0N,20,20^FH\\^CI28^FN2\"varasknumber\"^FS^CI28\n" +
                    "^FPH,3^FT313,101^A0N,20,20^FH\\^CI28^FN3\"varcarriername\"^FS^CI28\n" +
                    "^FPH,3^FT251,134^A0N,20,20^FH\\^CI28^FN4\"varmerchandisenature\"^FS^CI28\n" +
                    "^FPH,3^FT165,165^A0N,20,20^FH\\^CI28^FN5\"vardestination\"^FS^CI28\n" +
                    "\n" +
                    "^XZ\n"

        const val OUT =
            "^CI28" +
                    "^DFR:Out.ZPL^FS\n" +
                    "~TA000\n" +
                    "~JSN\n" +
                    "^LT0\n" +
                    "^MTT\n" +
                    "^PON\n" +
                    "^PMN\n" +
                    "^LH0,0\n" +
                    "^JMA\n" +
                    "^PR8,8\n" +
                    "~SD15\n" +
                    "^JUS\n" +
                    "^LRN\n" +
                    "^CI28\n" +
                    "^PA0,1,1,0\n" +
                    "^MMT\n" +
                    "^PW607\n" +
                    "^LL408\n" +
                    "^LS0\n" +
                    "^FT24,67^A@N,17,18,TT0003M_^FH\\^CI28^FDNuméro de demande : ^FS^CI27\n" +
                    "^FT24,106^A@N,17,18,TT0003M_^FH\\^CI28^FDNature de la marchandise :^FS^CI27\n" +
                    "^FT24,141^A@N,17,18,TT0003M_^FH\\^CI28^FDLieu d'enlèvement :^FS^CI27\n" +
                    "^FPH,42^FT24,292^AAN,54,30^FH\\^FDS^FS\n" +
                    "^BY3,3,103^FT75,323^BCN,,Y,N,,A\n" +
                    "^FN1\"varbarcode\"^FS\n" +
                    "^FPH,3^FT215,69^A0N,20,20^FH\\^CI28^FN2\"varasknumber\"^FS^CI28\n" +
                    "^FPH,3^FT254,108^A0N,20,20^FH\\^CI28^FN3\"varmerchandisenature\"^FS^CI28\n" +
                    "^FPH,3^FT192,138^A0N,20,20^FH\\^CI28^FN4\"varstartplace\"^FS^CI28\n" +
                    "\n" +
                    "^XZ\n"

        const val FORWARD =
            "^CI28" +
                    "^DFR:Forward.ZPL^FS\n" +
                    "~TA000\n" +
                    "~JSN\n" +
                    "^LT0\n" +
                    "^MTT\n" +
                    "^PON\n" +
                    "^PMN\n" +
                    "^LH0,0\n" +
                    "^JMA\n" +
                    "^PR8,8\n" +
                    "~SD15\n" +
                    "^JUS\n" +
                    "^LRN\n" +
                    "^CI28\n" +
                    "^PA0,1,1,0\n" +
                    "^MMT\n" +
                    "^PW607\n" +
                    "^LL408\n" +
                    "^LS0\n" +
                    "^FT24,67^A@N,17,18,TT0003M_^FH\\^CI28^FDNuméro de demande : ^FS^CI27\n" +
                    "^FT24,97^A@N,17,18,TT0003M_^FH\\^CI28^FDNature de la marchandise :^FS^CI27\n" +
                    "^FT24,129^A@N,17,18,TT0003M_^FH\\^CI28^FDDESTINATION :^FS^CI27\n" +
                    "^FT24,159^A@N,17,18,TT0003M_^FH\\^CI28^FDLIEU D'ENLEVEMENT :^FS^CI27\n" +
                    "^FPH,42^FT24,292^AAN,54,30^FH\\^FDT^FS\n" +
                    "^BY3,3,98^FT79,322^BCN,,Y,N,,A\n" +
                    "^FN1\"varbarcode\"^FS\n" +
                    "^FPH,3^FT218,66^A0N,20,20^FH\\^CI28^FN2\"varasknumber\"^FS^CI28\n" +
                    "^FPH,3^FT252,95^A0N,20,20^FH\\^CI28^FN3\"varmerchandisenature\"^FS^CI28\n" +
                    "^FPH,3^FT165,128^A0N,20,20^FH\\^CI28^FN4\"vardestination\"^FS^CI28\n" +
                    "^FPH,3^FT225,157^A0N,20,20^FH\\^CI28^FN5\"varstartplace\"^FS^CI28\n" +
                    "\n" +
                    "^XZ\n"

        const val DISPATCH =
            "^DFR:Dispatch.ZPL^FS\n" +
                    "~TA000\n" +
                    "~JSN\n" +
                    "^LT0\n" +
                    "^MTT\n" +
                    "^PON\n" +
                    "^PMN\n" +
                    "^LH0,0\n" +
                    "^JMA\n" +
                    "^PR8,8\n" +
                    "~SD15\n" +
                    "^JUS\n" +
                    "^LRN\n" +
                    "^CI28\n" +
                    "^PA0,1,1,0\n" +
                    "^MMT\n" +
                    "^PW607\n" +
                    "^LL408\n" +
                    "^LS0\n" +
                    "^FT24,67^A@N,17,18,TT0003M_^FH\\^CI28^FDNuméro de demande : ^FS^CI28\n" +
                    "^FT24,99^A@N,17,18,TT0003M_^FH\\^CI28^FDNom du fournisseur / transporteur :^FS^CI28\n" +
                    "^FT24,132^A@N,17,18,TT0003M_^FH\\^CI28^FDNature de la marchandise :^FS^CI28\n" +
                    "^FT24,167^A@N,17,18,TT0003M_^FH\\^CI28^FDDESTINATION :^FS^CI28\n" +
                    "^FPH,42^FT24,292^AAN,54,30^FH\\^FDT^FS\n" +
                    "^BY3,3,87^FT76,316^BCN,,Y,N,,A\n" +
                    "^FN1\"varbarcode\"^FS\n" +
                    "^FPH,3^FT214,69^A0N,20,20^FH\\^CI28^FN2\"varasknumber\"^FS^CI28\n" +
                    "^FPH,3^FT316,101^A0N,20,20^FH\\^CI28^FN3\"varcarriername\"^FS^CI28\n" +
                    "^FPH,3^FT251,134^A0N,20,20^FH\\^CI28^FN4\"varmerchandisenature\"^FS^CI28\n" +
                    "^FPH,3^FT165,165^A0N,20,20^FH\\^CI28^FN5\"vardestination\"^FS^CI28\n" +
                    "\n" +
                    "^XZ\n"
    }
}