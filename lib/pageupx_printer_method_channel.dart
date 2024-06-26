import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pageupx_printer_platform_interface.dart';

/// An implementation of [PageupxPrinterPlatform] that uses method channels.
class MethodChannelPageupxPrinter extends PageupxPrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pageupx_printer');

  final _macAddressParameter = "mac_address";
  final _templateParameter = "template";
  final _templateNameParameter = "template_name";
  final _valuesParameter = "values";

  @override
  Future printConfiguration(String macAddress) async {
    await methodChannel.invokeMethod(
        "print_configuration", {_macAddressParameter: macAddress});
  }

  @override
  Future loadTemplate(String macAddress, String template) async {
    await methodChannel.invokeMethod("load_template",
        {_macAddressParameter: macAddress, _templateParameter: template});
  }

  @override
  Future print(
      String macAddress, String templateName, Map<int, String> values) async {
    await methodChannel.invokeMethod("print", {
      _macAddressParameter: macAddress,
      _templateNameParameter: templateName,
      _valuesParameter: values
    });
  }
}
