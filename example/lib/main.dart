import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:pageupx_printer/exceptions/connection_exception.dart';
import 'package:pageupx_printer/pageupx_printer.dart';
import 'package:pageupx_printer_example/template.dart';

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

  Future<void> _loadTemplate() async {
    try {
      _setLoading(true);
      await _pageupxPrinterPlugin.loadTemplate(_address, Constants.IN);
    } on ConnectionException {
      _showSnackBar("Can't connect to printer : $_address");
    } catch (e) {
      _showSnackBar("An error occurred");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _printTemplate() async {
    try {
      _setLoading(true);
      var values = {
        1: "1234567890",
        2: "1234567890",
        3: "1234567890",
        4: "1234567890",
        5: "1234567890",
      };
      await _pageupxPrinterPlugin.print(_address, "In.ZPL", values);
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
    NfcManager.instance.stopSession();
    _setScanningNfc(false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app 2'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: [
                    OutlinedButton(
                      onPressed:
                          _address.isEmpty || _loading ? null : _loadTemplate,
                      child: const Text("Load template"),
                    ),
                    OutlinedButton(
                      onPressed:
                          _address.isEmpty || _loading ? null : _printTemplate,
                      child: const Text("Print template"),
                    ),
                    OutlinedButton(
                      onPressed: _scanning ? null : _startNfcScan,
                      child: const Text("Start Scan printer with NFC"),
                    ),
                    OutlinedButton(
                      onPressed: !_scanning ? null : _stopNfcScan,
                      child: const Text("Stop NFC"),
                    ),
                  ],
                ),
              ),
              Text("Current printer: $_address"),
            ],
          ),
        ),
      ),
    );
  }
}
