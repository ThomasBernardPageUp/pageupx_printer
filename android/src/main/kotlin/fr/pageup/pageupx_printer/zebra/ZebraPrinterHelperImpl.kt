package fr.pageup.pageupx_printer.zebra

import android.content.Context
import android.util.Log
import com.zebra.sdk.comm.BluetoothConnection
import com.zebra.sdk.printer.ZebraPrinterFactory
import com.zebra.sdk.printer.discovery.BluetoothDiscoverer
import com.zebra.sdk.printer.discovery.DiscoveredPrinter
import com.zebra.sdk.printer.discovery.DiscoveryHandler
import fr.pageup.pageupx_printer.shared.MacAddress
import fr.pageup.pageupx_printer.shared.Printer
import fr.pageup.pageupx_printer.shared.PrinterHelper
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.withContext

class ZebraPrinterHelperImpl(
//    private val context : Context,
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
) : PrinterHelper {

    private val blackMark = "^XA\n" + "^MNM,24\n"
    private val autoSpacer = "^XA\n" + "^MNW\n"

    override suspend fun printConfiguration(address: MacAddress) {
        val connection = BluetoothConnection(address)
        connection.open()
        val zebraPrinter = ZebraPrinterFactory.getInstance(connection)
        zebraPrinter.printConfigurationLabel()
        connection.close()
    }

    override suspend fun loadTemplate(address: MacAddress, template: String) {
        loadTemplate(address = address, templates = listOf(template))
    }

    override suspend fun loadTemplate(address: MacAddress, templates: List<String>) {
        val connection = BluetoothConnection(address)
        connection.open()
        val zebraPrinter = ZebraPrinterFactory.getInstance(connection)
        templates.forEach {
            zebraPrinter.sendCommand(blackMark + it)
        }
        connection.close()
    }

    override suspend fun print(address: MacAddress, template: String, values: Map<Int, String>) {
        val connection = BluetoothConnection(address)
        connection.open()
        val zebraPrinter = ZebraPrinterFactory.getInstance(connection)
        zebraPrinter.printStoredFormat(template, values)
        connection.close()
    }

    override suspend fun print(
        address: MacAddress,
        template: String,
        values: List<Map<Int, String>>
    ) {
        val connection = BluetoothConnection(address)
        connection.open()
        val zebraPrinter = ZebraPrinterFactory.getInstance(connection)
        values.forEach { value ->
            zebraPrinter.printStoredFormat(template, value)
        }
        connection.close()
    }
}