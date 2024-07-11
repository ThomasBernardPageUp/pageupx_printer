import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pageupx_printer/exceptions/bluetooth_disabled_exception.dart';
import 'package:pageupx_printer/exceptions/bluetooth_not_supported_exception.dart';
import 'package:pageupx_printer/exceptions/connection_exception.dart';

import 'pageupx_printer_platform_interface.dart';

/// An implementation of [PageupxPrinterPlatform] that uses method channels.
class MethodChannelPageupxPrinter extends PageupxPrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pageupx_printer');

  final _macAddressParameter = "mac_address";
  final _templateParameter = "template";
  final _templatesParameter = "templates";
  final _templateNameParameter = "template_name";
  final _valuesParameter = "values";

  // Throw exception if needed
  parseResult(int result) {
    switch (result) {
      case -1: // OK
        break;
      case 0:
        throw Exception();
      case 1:
        throw ConnectionException();
      case 2:
        throw BluetoothNotSupportedException();
      case 3:
        throw BluetoothDisabledException();
    }
  }

  @override
  Future printConfiguration(String macAddress) async {
    var result = await methodChannel.invokeMethod<int>(
        "print_configuration", {_macAddressParameter: macAddress});

    parseResult(result!);
  }

  @override
  Future loadTemplate(String macAddress, String template) async {
    var result = await methodChannel.invokeMethod<int>("load_template",
        {_macAddressParameter: macAddress, _templateParameter: template});

    parseResult(result!);
  }

  @override
  Future loadTemplates(String macAddress, List<String> templates) async {
    var result = await methodChannel.invokeMethod<int>("load_templates",
        {_macAddressParameter: macAddress, _templatesParameter: templates});

    parseResult(result!);
  }

  @override
  Future print(
      String macAddress, String templateName, Map<int, String> values) async {
    var result = await methodChannel.invokeMethod<int>("print", {
      _macAddressParameter: macAddress,
      _templateNameParameter: templateName,
      _valuesParameter: values
    });

    parseResult(result!);
  }

  @override
  Future multiPrint(String macAddress, String templateName,
      List<Map<int, String>> values) async {
    var result = await methodChannel.invokeMethod<int>("print_multi", {
      _macAddressParameter: macAddress,
      _templateNameParameter: templateName,
      _valuesParameter: values
    });

    parseResult(result!);
  }

  @override
  Future reset(String macAddress) async {
    var result = await methodChannel.invokeMethod<int>("reset", {
      _macAddressParameter: macAddress,
    });

    parseResult(result!);
  }
}
