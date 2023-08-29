import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:cybersoruce_plugin/cybersoruce_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _cybersorucePlugin = CybersorucePlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _cybersorucePlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  String _token = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_token\n'),
            ),
            ElevatedButton(
                onPressed: () async {
                  _token = await _cybersorucePlugin.tokenize(
                          cardNumber: "4111111111111111",
                          cardExpMonth: "12",
                          cardExpYear: "2025",
                          cardCVV: "123",
                          environment: Environment.sandbox,
                          merchantId: "codepress_test",
                          merchantKey: "9d81e9d5-5888-449f-971b-a33e0f6e189e",
                          merchantSecret:
                              "8qZrYuXYEjcmPTwVuOMVQvxYEbz7kc1pSm9xwBYy1Ds=") ??
                      "";

                  log((json.decode(_token)).toString());

                  setState(() {});
                },
                child: const Text("Tokenize"))
          ],
        ),
      ),
    );
  }
}
