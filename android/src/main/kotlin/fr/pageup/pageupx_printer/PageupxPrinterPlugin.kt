package fr.pageup.pageupx_printer

import android.bluetooth.BluetoothAdapter
import android.util.Log
import com.zebra.sdk.comm.ConnectionException
import fr.pageup.pageupx_printer.shared.BluetoothDisabledException
import fr.pageup.pageupx_printer.shared.BluetoothNotSupportedException
import fr.pageup.pageupx_printer.shared.PrinterHelper
import fr.pageup.pageupx_printer.zebra.ZebraPrinterHelperImpl
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import io.flutter.plugin.common.MethodChannel.Result

/** PageupxPrinterPlugin */
class PageupxPrinterPlugin: FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel
    private val printerHelper : PrinterHelper = ZebraPrinterHelperImpl()
    private val mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter()

    private val macAddressParameter = "mac_address"
    private val templateParameter = "template"
    private val templateNameParameter = "template_name"
    private val valuesParameter = "values"

    // Ok -> -1
    // UnknownException -> 0
    // ConnectionException -> 1
    // BluetoothDisabledException -> 2
    // BluetoothNotSupported -> 3


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pageupx_printer")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                // Check bluetooth connectivity
                if (mBluetoothAdapter == null)
                    throw BluetoothNotSupportedException()
                else if (!mBluetoothAdapter.isEnabled)
                    throw BluetoothNotSupportedException()

                if (call.method == "get_printers"){
                    val printers = printerHelper.getPrinters()
                    result.success(printers)
                }
                else if (call.method == "print_configuration"){
                    val macAddress = call.argument<String>(macAddressParameter) ?: throw NullPointerException(macAddressParameter)
                    printerHelper.printConfiguration(macAddress)
                    result.success(-1)
                }
                else if (call.method == "load_template"){
                    val macAddress = call.argument<String>(macAddressParameter) ?: throw NullPointerException(macAddressParameter)
                    val template = call.argument<String>(templateParameter) ?: throw NullPointerException(templateParameter)
                    printerHelper.loadTemplate(macAddress, template)
                    result.success(-1)
                }
                else if (call.method == "print"){
                    val macAddress = call.argument<String>(macAddressParameter) ?: throw NullPointerException(macAddressParameter)
                    val templateName = call.argument<String>(templateNameParameter) ?: throw NullPointerException(templateNameParameter)
                    val values = call.argument<Map<Int, String>>(valuesParameter) ?: throw NullPointerException(valuesParameter)
                    printerHelper.print(macAddress, templateName, values)
                    result.success(-1)
                }
            }

            catch (e : ConnectionException){
                Log.e(e.message, e.stackTraceToString())
                result.success(1)
            }
            catch (e : BluetoothDisabledException){
                Log.e(e.message, e.stackTraceToString())
                result.success(2)
            }
            catch (e : BluetoothNotSupportedException){
                Log.e(e.message, e.stackTraceToString())
                result.success(3)
            }
            catch (e : Exception){
                Log.e(e.message, e.stackTraceToString())
                result.success(0)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
