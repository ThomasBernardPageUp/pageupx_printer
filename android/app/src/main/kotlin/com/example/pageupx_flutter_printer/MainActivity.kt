package com.example.pageupx_flutter_printer

import androidx.annotation.NonNull
import com.example.pageupx_flutter_printer.shared.PrinterHelper
import com.example.pageupx_flutter_printer.shared.PrinterTemplates
import com.example.pageupx_flutter_printer.zebra.ZebraPrinterHelperImpl
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

class MainActivity: FlutterActivity() {
    private val CHANNEL = "pageupx_flutter_printer/printer"
    private val printerHelper : PrinterHelper = ZebraPrinterHelperImpl(this)

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "print"){
                // Launch activity scope
                CoroutineScope(Dispatchers.IO).launch {
                    val values = mapOf(
                        2 to "2 Hello World!",
                        3 to "3 Hello World!",
                        4 to "4 Hello World!",
                        5 to "5 Hello World!",
                        1 to "1 Hello World!"
                    )

                    printerHelper.loadTemplate("48:A4:93:D5:3B:C7", PrinterTemplates.Content.IN)
                    delay(1000)
                    printerHelper.print("48:A4:93:D5:3B:C7", "In.ZPL", values)
                    result.success(null)
                }
            }
        }
    }
}