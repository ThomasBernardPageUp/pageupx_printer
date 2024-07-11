import 'pageupx_printer_platform_interface.dart';

class PageupxPrinter {
  Future printConfiguration(String macAddress) async {
    await PageupxPrinterPlatform.instance.printConfiguration(macAddress);
  }

  Future loadTemplate(String macAddress, String template) async {
    await PageupxPrinterPlatform.instance.loadTemplate(macAddress, template);
  }

  Future loadTemplates(String macAddress, List<String> templates) async {
    await PageupxPrinterPlatform.instance.loadTemplates(macAddress, templates);
  }

  Future print(
      String macAddress, String templateName, Map<int, String> values) async {
    await PageupxPrinterPlatform.instance
        .print(macAddress, templateName, values);
  }

  Future multiPrint(String macAddress, String templateName,
      List<Map<int, String>> values) async {
    await PageupxPrinterPlatform.instance
        .multiPrint(macAddress, templateName, values);
  }

  Future reset(String macAddress) async {
    await PageupxPrinterPlatform.instance.reset(macAddress);
  }
}
