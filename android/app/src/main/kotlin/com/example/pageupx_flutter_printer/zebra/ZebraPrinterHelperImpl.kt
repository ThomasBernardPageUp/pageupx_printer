package com.example.pageupx_flutter_printer.zebra

import android.content.Context
import android.util.Log
import com.example.pageupx_flutter_printer.shared.MacAddress
import com.example.pageupx_flutter_printer.shared.Printer
import com.example.pageupx_flutter_printer.shared.PrinterHelper
import com.zebra.sdk.comm.BluetoothConnection
import com.zebra.sdk.printer.ZebraPrinterFactory
import com.zebra.sdk.printer.discovery.BluetoothDiscoverer
import com.zebra.sdk.printer.discovery.DiscoveredPrinter
import com.zebra.sdk.printer.discovery.DiscoveryHandler
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.withContext

class ZebraPrinterHelperImpl(
    private val context : Context,
    private val ioDispatcher: CoroutineDispatcher = Dispatchers.IO
) : PrinterHelper {

    private val blackMark = "^XA\n" + "^MNM,24\n"
    private val autoSpacer = "^XA\n" + "^MNW\n"

    override fun getPrinters() : Flow<List<Printer>> = callbackFlow {
        BluetoothDiscoverer.findPrinters(context, object : DiscoveryHandler {
            val discoveredPrinters: MutableList<DiscoveredPrinter> = mutableListOf()
            override fun foundPrinter(printer: DiscoveredPrinter) {
                Log.i("ZebraPrinterHelperImpl", "Found printer : $printer")
                discoveredPrinters.add(printer)
            }

            override fun discoveryFinished() {
                for (printer in discoveredPrinters) {
                    Log.i("ZebraPrinterHelperImpl", "Discovered printer : $printer")
                }
                trySend(discoveredPrinters.map { Printer(it.address) })
            }

            override fun discoveryError(message: String) {
                Log.e("ZebraPrinterHelperImpl", "An error occurred during discovery : $message")
            }
        })
        awaitClose()
    }

    override suspend fun printConfiguration(address: MacAddress) = withContext(ioDispatcher) {
        val connection = BluetoothConnection(address)
        connection.open()
        val zebraPrinter = ZebraPrinterFactory.getInstance(connection)
        zebraPrinter.printConfigurationLabel()
        connection.close()
    }

    override suspend fun loadTemplate(address: MacAddress, template: String) = withContext(ioDispatcher) {
        val connection = BluetoothConnection(address)
        connection.open()
        val zebraPrinter = ZebraPrinterFactory.getInstance(connection)
        zebraPrinter.sendCommand(blackMark + template)
        connection.close()
    }

    override suspend fun print(address: MacAddress, template: String, values: Map<Int, String>) = withContext(ioDispatcher) {
        val connection = BluetoothConnection(address)
        connection.open()
        val zebraPrinter = ZebraPrinterFactory.getInstance(connection)
        zebraPrinter.printStoredFormat(template, values)
        connection.close()
    }
}