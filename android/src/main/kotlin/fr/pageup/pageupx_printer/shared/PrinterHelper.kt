package fr.pageup.pageupx_printer.shared

typealias MacAddress = String

interface PrinterHelper {

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
     * Load a template in the printer
     * @param address the mac address of the printer
     * @param templates list of all templates to use example : [Github](https://github.com/pageupdijon/louvre-panoptes-mobile-android/blob/develop/app/src/main/java/fr/pageup/panoptes/utils/PrinterTemplates.kt)
     */
    suspend fun loadTemplate(address : MacAddress, templates : List<String>)


    /**
     * Print a template with the given values
     * @param address the mac address of the printer
     * @param template the template path : We can find it in first lines of the template loaded previously
     * @param values the values to replace in the template, Int is the key of the value to replace, String is the value to replace
     */
    suspend fun print(address: MacAddress, template : String, values : Map<Int, String>)

    /**
     * Print a template with the given values
     * @param address the mac address of the printer
     * @param template the template path : We can find it in first lines of the template loaded previously
     * @param values the values to replace in the template, each occurrence of the list is a new print
     */
    suspend fun print(address: MacAddress, template : String, values : List<Map<Int, String>>)


    /**
     * Reset the current configuration of the printer
     * @param address the mac address of the printer
     */
    suspend fun reset(address: MacAddress)
}