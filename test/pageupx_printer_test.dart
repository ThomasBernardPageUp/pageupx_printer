import 'package:flutter_test/flutter_test.dart';
import 'package:pageupx_printer/pageupx_printer.dart';
import 'package:pageupx_printer/pageupx_printer_platform_interface.dart';
import 'package:pageupx_printer/pageupx_printer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPageupxPrinterPlatform
    with MockPlatformInterfaceMixin
    implements PageupxPrinterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PageupxPrinterPlatform initialPlatform = PageupxPrinterPlatform.instance;

  test('$MethodChannelPageupxPrinter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPageupxPrinter>());
  });

  test('getPlatformVersion', () async {
    PageupxPrinter pageupxPrinterPlugin = PageupxPrinter();
    MockPageupxPrinterPlatform fakePlatform = MockPageupxPrinterPlatform();
    PageupxPrinterPlatform.instance = fakePlatform;

    expect(await pageupxPrinterPlugin.getPlatformVersion(), '42');
  });
}
