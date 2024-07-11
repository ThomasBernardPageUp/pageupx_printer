package fr.pageup.pageupx_printer.zebra

import android.util.Log
import com.zebra.sdk.comm.BluetoothConnection
import com.zebra.sdk.printer.ZebraPrinter
import com.zebra.sdk.printer.ZebraPrinterFactory
import fr.pageup.pageupx_printer.shared.MacAddress
import fr.pageup.pageupx_printer.shared.PrinterHelper
import kotlinx.coroutines.delay

class ZebraPrinterHelperImpl : PrinterHelper {

    private val blackMark = "^XA\n" + "^MNM,24\n"
    private val autoSpacer = "^XA\n" + "^MNW\n"

    private val logTag = "ZebraPrinterHelperImpl"

    private suspend fun makeOperation(address: MacAddress, block : suspend ZebraPrinter.() -> Unit){
        Log.d(logTag,"Opening connection with printer : $address")
        val connection = BluetoothConnection(address)
        connection.open()
        Log.d(logTag,"Printer $address connected")
        val zebraPrinter = ZebraPrinterFactory.getInstance(connection)
        block(zebraPrinter)
        connection.close()
        Log.d(logTag,"Connection closed with printer $address")
    }

    override suspend fun printConfiguration(address: MacAddress) {
        makeOperation(address){
            Log.d(logTag,"Printing configuration")
            printConfigurationLabel()
        }
    }

    override suspend fun loadTemplate(address: MacAddress, template: String) {
        loadTemplate(address = address, templates = listOf(template))
    }

    override suspend fun loadTemplate(address: MacAddress, templates: List<String>) {
        makeOperation(address){
            Log.d(logTag,"Loading templates \n ${templates.joinToString { "\n" }}")
            templates.forEach {
                sendCommand(blackMark + it)
            }
        }
        // Wait for the printer to be ready
        delay(300)
    }

    override suspend fun print(address: MacAddress, template: String, values: Map<Int, String>) {
        print(address, template, listOf(values))
    }

    override suspend fun print(
        address: MacAddress,
        template: String,
        values: List<Map<Int, String>>
    ) {
        makeOperation(address){
            Log.d(logTag,"Printing with template $template : \n $values")
            values.forEach { value ->
                printStoredFormat(template, value)
            }
        }
    }

    override suspend fun reset(address: MacAddress) {
        makeOperation(address){
            Log.d(logTag,"Reseting configuration")
            reset()
        }
    }
}