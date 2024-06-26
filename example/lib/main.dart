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
  bool _loading = false;

  void _setLoading(bool loading) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _loading = loading;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion = "Unknown";
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app 2'),
        ),
        body: Center(
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: () async {
                  _setLoading(true);
                  _pageupxPrinterPlugin.loadTemplate(
                      "48:A4:93:D5:3B:C7", Constants.IN);
                  _setLoading(false);
                },
                child: const Text("Load template"),
              ),
              FloatingActionButton(
                onPressed: () async {
                  try {} on ConnectionException {
                    // Show toast "Can't connect to printer"
                  }
                  _setLoading(true);
                  var values = {
                    1: "1234567890",
                    2: "1234567890",
                    3: "1234567890",
                    4: "1234567890",
                    5: "1234567890",
                  };
                  _pageupxPrinterPlugin.print(
                      "48:A4:93:D5:3B:C7", "In.ZPL", values);
                  _setLoading(false);
                },
                child: const Text("Print template"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
