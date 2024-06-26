import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pageupx_printer/exceptions/connection_exception.dart';
import 'package:pageupx_printer/pageupx_printer.dart';
import 'package:pageupx_printer_example/template.dart';

void main() {
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

  void _setLoading(bool loading) {
    setState(() {
      _loading = loading;
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
              FloatingActionButton(
                onPressed: () async {
                  try {
                    _setLoading(true);
                    await _pageupxPrinterPlugin.loadTemplate(
                        "48:A4:93:D5:3B:C7", Constants.IN);
                  } on ConnectionException {
                    _showSnackBar("Can't connect to printer");
                  } catch (e) {
                    _showSnackBar("An error occurred");
                  } finally {
                    _setLoading(false);
                  }
                },
                child: const Text("Load template"),
              ),
              FloatingActionButton(
                onPressed: () async {
                  try {
                    _setLoading(true);
                    var values = {
                      1: "1234567890",
                      2: "1234567890",
                      3: "1234567890",
                      4: "1234567890",
                      5: "1234567890",
                    };
                    await _pageupxPrinterPlugin.print(
                        "48:A4:93:D5:3B:C7", "In.ZPL", values);
                  } on ConnectionException {
                    _showSnackBar("Can't connect to printer");
                  } catch (e) {
                    _showSnackBar("An error occurred");
                  } finally {
                    _setLoading(false);
                  }
                },
                child: const Text("Print template"),
              ),
              if (_loading) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
