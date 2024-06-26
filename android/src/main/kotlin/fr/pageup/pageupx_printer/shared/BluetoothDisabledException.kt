package fr.pageup.pageupx_printer.shared

data class BluetoothDisabledException(override val message: String = "Bluetooth is not enabled") : Exception(message)