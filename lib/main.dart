import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Full Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Full Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String url = '';

  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(24.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Enter the URL',
                ),
                keyboardType: TextInputType.url,
                controller: urlController,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MobileScanner(
                    allowDuplicates: false,
                    onDetect: (barcode, args) {
                      setState(() {
                        urlController.text = barcode.rawValue!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
            tooltip: 'Increment',
            child: const Icon(Icons.qr_code),
            heroTag: "qrcode",
          ),
          const SizedBox(
            height: 24,
            width: 0,
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebviewScreen(urlController.text),
                ),
              );
            },
            tooltip: 'Increment',
            child: const Icon(Icons.rocket_launch),
            heroTag: "launch",
          ),
        ],
      ),
    );
  }
}

class WebviewScreen extends StatefulWidget {
  const WebviewScreen(this.url, {Key? key}) : super(key: key);

  final String url;

  @override
  WebviewScreenState createState() => WebviewScreenState();
}

class WebviewScreenState extends State<WebviewScreen> {
  @override
  initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
