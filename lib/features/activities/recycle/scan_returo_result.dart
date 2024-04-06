// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ScanReturoResultPage extends StatefulWidget {
  final String barcode;

  const ScanReturoResultPage({Key? key, required this.barcode}) : super(key: key);

  @override
  _ScanReturoResultPageState createState() => _ScanReturoResultPageState();
}

class _ScanReturoResultPageState extends State<ScanReturoResultPage> {
  // Any additional state variables can be declared here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan RETURO Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Scanned Barcode: ${widget.barcode}',
              style: TextStyle(fontSize: 18),
            ),
            // Additional widgets or UI elements can be added here
          ],
        ),
      ),
    );
  }
}
