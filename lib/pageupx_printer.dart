import 'pageupx_printer_platform_interface.dart';

class PageupxPrinter {
  Future printConfiguration(String macAddress) async {
    await PageupxPrinterPlatform.instance.printConfiguration(macAddress);
  }

  Future loadTemplate(String macAddress, String template) async {
    await PageupxPrinterPlatform.instance.loadTemplate(macAddress, template);
  }

  Future print(
      String macAddress, String templateName, Map<int, String> values) async {
    await PageupxPrinterPlatform.instance
        .print(macAddress, templateName, values);
  }
}
