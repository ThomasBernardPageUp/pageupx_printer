package fr.pageup.pageupx_printer.shared

import kotlinx.coroutines.flow.Flow

typealias MacAddress = String

interface PrinterHelper {

    fun getPrinters() : Flow<List<Printer>>

    /**
     * Print the configuration of the printer
     * @param address the mac adress of the printer
     */
    suspend  fun printConfiguration(address : MacAddress)

    /**
     * Load a template in the printer
     * @param address the mac address of the printer
     * @param template Template to use example : [Github](https://github.com/pageupdijon/louvre-panoptes-mobile-android/blob/develop/app/src/main/java/fr/pageup/panoptes/utils/PrinterTemplates.kt)
     */
    suspend fun loadTemplate(address: MacAddress, template : String)

    /**
     * Print a template with the given values
     * @param address the mac address of the printer
     * @param template the template path : We can find it in first lines of the template loaded previously
     * @param values the values to replace in the template, Int is the key of the value to replace, String is the value to replace
     */
    suspend fun print(address: MacAddress, template : String, values : Map<Int, String>)
}