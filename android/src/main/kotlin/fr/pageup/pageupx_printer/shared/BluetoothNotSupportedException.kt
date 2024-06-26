package fr.pageup.pageupx_printer.shared

data class BluetoothNotSupportedException(override val message: String = "Bluetooth not supported on this device") : Exception(message)
