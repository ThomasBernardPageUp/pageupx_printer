import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:pageupx_printer/exceptions/bluetooth_disabled_exception.dart';
import 'package:pageupx_printer/exceptions/bluetooth_not_supported_exception.dart';
import 'package:pageupx_printer/exceptions/connection_exception.dart';
import 'package:pageupx_printer/pageupx_printer.dart';
import 'package:pageupx_printer_example/template.dart';
import 'package:flutter_grid_button/flutter_grid_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _pageupxPrinterPlugin = PageupxPrinter();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _loading = false;
  bool _scanning = false;
  String _address = "";

  void _setLoading(bool loading) {
    setState(() {
      _loading = loading;
    });
  }

  void _setScanningNfc(bool scanning) {
    setState(() {
      _scanning = scanning;
    });
  }

  void _setAddress(String address) {
    setState(() {
      _address = address;
    });
  }

  void _showSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion = "Unknown";
    if (!mounted) return;

    setState(() {});
  }

  Future<void> _loadTemplate(String template) async {
    try {
      _setLoading(true);
      await _pageupxPrinterPlugin.loadTemplate(_address, template);
    } on BluetoothNotSupportedException {
      _showSnackBar("Bluetooth not supported");
    } on BluetoothDisabledException {
      _showSnackBar("Bluetooth disbled");
    } on ConnectionException {
      _showSnackBar("Can't connect to printer : $_address");
    } catch (e) {
      _showSnackBar("An error occurred when loading template $template");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _reset() async {
    try {
      _setLoading(true);
      await _pageupxPrinterPlugin.reset(_address);
    } on BluetoothNotSupportedException {
      _showSnackBar("Bluetooth not supported");
    } on BluetoothDisabledException {
      _showSnackBar("Bluetooth disbled");
    } on ConnectionException {
      _showSnackBar("Can't connect to printer : $_address");
    } catch (e) {
      _showSnackBar("An error occurred when reseting printer $_address");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadTemplates() async {
    try {
      _setLoading(true);
      await _pageupxPrinterPlugin.loadTemplates(_address,
          [Template.IN, Template.OUT, Template.FORWARD, Template.DISPATCH]);
    } on BluetoothNotSupportedException {
      _showSnackBar("Bluetooth not supported");
    } on BluetoothDisabledException {
      _showSnackBar("Bluetooth disbled");
    } on ConnectionException {
      _showSnackBar("Can't connect to printer : $_address");
    } catch (e) {
      _showSnackBar("An error occurred when loading templates");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _printTemplate(String template, Map<int, String> values) async {
    var values = {
      1: "1234567890",
      2: "1234567890",
      3: "1234567890",
      4: "1234567890",
      5: "1234567890",
    };
    _printTemplates(template, [values]);
  }

  Future<void> _printTemplates(
      String template, List<Map<int, String>> values) async {
    try {
      _setLoading(true);
      await _pageupxPrinterPlugin.multiPrint(_address, template, values);
    } on BluetoothNotSupportedException {
      _showSnackBar("Bluetooth not supported");
    } on BluetoothDisabledException {
      _showSnackBar("Bluetooth disbled");
    } on ConnectionException {
      _showSnackBar("Can't connect to printer : $_address");
    } catch (e) {
      _showSnackBar("An error occurred");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _startNfcScan() async {
    _setAddress("");
    _setScanningNfc(true);
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        print(tag.data);

        var ndef = tag.data['ndef'];
        if (ndef == null) {
          _stopNfcScan();
          return;
        }

        var cachedMessage = ndef['cachedMessage'];
        if (cachedMessage == null) {
          _stopNfcScan();
          return;
        }

        var records = cachedMessage['records'];
        if (records == null || records.isEmpty) {
          _stopNfcScan();
          return;
        }

        for (var record in records) {
          var payload = record['payload'];
          if (payload == null || payload.isEmpty) continue;

          String url = String.fromCharCodes(payload.skip(1));
          print("NFC Tag contains URL: $url");

          final regex = RegExp(r"mB=([a-zA-Z0-9]+)");
          final match = regex.firstMatch(url);
          if (match != null) {
            String address = match.group(1) ?? "Not found";
            print("NFC Tag address: $address");
            _setAddress(address);
          } else {
            _showSnackBar("NFC Tag address not found");
          }
        }

        _stopNfcScan();
      },
    );
  }

  void _stopNfcScan() {
    NfcManager.instance.stopSession(
        alertMessage: "Scan stopped", errorMessage: "On coupe tout");
    _setScanningNfc(false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
          body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Column(children: [
              Container(
                  color: const Color.fromARGB(255, 1, 61, 148),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Connected printer : $_address",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const Text(
                          "Click on the button `Start scanning` to find a printer with NFC",
                          style: TextStyle(color: Colors.white),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: _scanning ? null : _startNfcScan,
                              child: Text("Start scanning",
                                  style: _scanning
                                      ? null
                                      : const TextStyle(color: Colors.white)),
                            ),
                            TextButton(
                              onPressed: !_scanning ? null : _stopNfcScan,
                              child: Text(
                                "Stop scanning",
                                style: _scanning
                                    ? const TextStyle(color: Colors.white)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              if (_loading)
                const LinearProgressIndicator(
                  color: Color.fromARGB(255, 54, 138, 206),
                ),
              if (!_loading)
                Container(
                  height: 4,
                  color: Colors.transparent,
                ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _address.isEmpty || _loading
                        ? null
                        : () {
                            _loadTemplate(Template.IN);
                          },
                    child: const Text("Load template IN"),
                  ),
                  OutlinedButton(
                    onPressed: _address.isEmpty || _loading
                        ? null
                        : () {
                            _loadTemplate(Template.OUT);
                          },
                    child: const Text("Load template OUT"),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _address.isEmpty || _loading
                        ? null
                        : () {
                            _loadTemplate(Template.DISPATCH);
                          },
                    child: const Text("Load template DISPATCH"),
                  ),
                  OutlinedButton(
                    onPressed: _address.isEmpty || _loading
                        ? null
                        : () {
                            _loadTemplate(Template.FORWARD);
                          },
                    child: const Text("Load template FORWARD"),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: _address.isEmpty || _loading ? null : _loadTemplates,
                child: const Text("Load all templates"),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _address.isEmpty || _loading
                        ? null
                        : () {
                            var values = {
                              1: "1234567891",
                              2: "1234567892",
                              3: "1234567893",
                              4: "1234567894",
                              5: "1234567895",
                            };
                            _printTemplate("In.ZPL", values);
                          },
                    child: const Text("Print IN"),
                  ),
                  OutlinedButton(
                    onPressed: _address.isEmpty || _loading
                        ? null
                        : () {
                            var values = {
                              1: "1234567891",
                              2: "1234567892",
                              3: "1234567893",
                              4: "1234567894",
                            };
                            _printTemplate("Out.ZPL", values);
                          },
                    child: const Text("Print OUT"),
                  ),
                  OutlinedButton(
                    onPressed: _address.isEmpty || _loading
                        ? null
                        : () {
                            var values = {
                              1: "1234567891",
                              2: "1234567892",
                              3: "1234567893",
                              4: "1234567894",
                              5: "1234567895",
                            };
                            _printTemplate("Forward.ZPL", values);
                          },
                    child: const Text("Print Forward"),
                  ),
                  OutlinedButton(
                    onPressed: _address.isEmpty || _loading
                        ? null
                        : () {
                            var values = {
                              1: "1234567891",
                              2: "1234567892",
                              3: "1234567893",
                              4: "1234567894",
                              5: "1234567895",
                            };
                            _printTemplate("Dispatch.ZPL", values);
                          },
                    child: const Text("Print Dispatch"),
                  )
                ],
              ),
              OutlinedButton(
                onPressed: _address.isEmpty || _loading
                    ? null
                    : () {
                        var values1 = {
                          1: "1234567890",
                          2: "1234567890",
                          3: "1234567890",
                          4: "1234567890",
                          5: "1234567890",
                        };
                        var values2 = {
                          1: "2234567890",
                          2: "2234567890",
                          3: "2234567890",
                          4: "2234567890",
                          5: "2234567890",
                        };

                        var values3 = {
                          1: "3234567890",
                          2: "3234567890",
                          3: "3234567890",
                          4: "3234567890",
                          5: "3234567890",
                        };
                        var values4 = {
                          1: "4234567890",
                          2: "4234567890",
                          3: "4234567890",
                          4: "4234567890",
                          5: "4234567890",
                        };
                        _printTemplates(
                            "In.ZPL", [values1, values2, values3, values4]);
                      },
                child: const Text("Print multi template"),
              ),
              OutlinedButton(
                onPressed: _address.isEmpty || _loading ? null : _reset,
                child: const Text("Reset printer"),
              )
            ])),
          ],
        ),
      )),
    );
  }
}
