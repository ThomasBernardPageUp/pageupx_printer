import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pageupx_printer_method_channel.dart';

abstract class PageupxPrinterPlatform extends PlatformInterface {
  /// Constructs a PageupxPrinterPlatform.
  PageupxPrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static PageupxPrinterPlatform _instance = MethodChannelPageupxPrinter();

  /// The default instance of [PageupxPrinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelPageupxPrinter].
  static PageupxPrinterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PageupxPrinterPlatform] when
  /// they register themselves.
  static set instance(PageupxPrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future printConfiguration(String macAddress) async {
    throw UnimplementedError('printConfiguration() has not been implemented.');
  }

  Future loadTemplate(String macAddress, String template) async {
    throw UnimplementedError('loadTemplate() has not been implemented.');
  }

  Future print(
      String macAddress, String templateName, Map<int, String> values) async {
    throw UnimplementedError('print() has not been implemented.');
  }
}
