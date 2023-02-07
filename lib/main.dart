import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_passkit/add_button.dart';
import 'package:poc_passkit/pass_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('br.com.kamino/passkit');
  String _canAddPasses = 'Unknown';
  late Uint8List _pass;
  bool loading = true;

  Future<void> _getPassKitAvailability() async {
    String response;
    try {
      final bool canAddPasses = await platform.invokeMethod('canAddPasses');
      response = canAddPasses ? 'Can Add' : 'Cannot Add';
    } on PlatformException catch (e) {
      response = "Failed to verify ${e.toString()}";
    }

    setState(() {
      _canAddPasses = response;
    });
  }

  @override
  void initState() {
    passProvider().then((pass) {
      log('could read');
      setState(() {
        _pass = pass;
        loading = false;
      });
    }).catchError((e) {
      log(e.toString());
    });

    platform.setMethodCallHandler(_didAddToWallet);
    super.initState();
  }

  Future<bool> _didAddToWallet(MethodCall call) async {
    final bool didAdd = call.arguments;
    log('didAdd - $didAdd');
    return didAdd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exemplo Method Channel')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _getPassKitAvailability,
                  child: const Text('Check if pass can be added'),
                ),
                Text(_canAddPasses),
                const SizedBox(height: 50),
                if (!loading) AddButton(pass: _pass),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
