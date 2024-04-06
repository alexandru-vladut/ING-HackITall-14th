// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:ing_mobile/features/activities/recycle/scan_product_result.dart';
import 'package:ing_mobile/features/activities/recycle/scan_returo_result.dart';
import 'package:ing_mobile/utilities/animation/slideright_toleft.dart';

class RecycleActivityPage extends StatefulWidget {
  const RecycleActivityPage({super.key});

  @override
  _RecycleActivityPageState createState() => _RecycleActivityPageState();
}

class _RecycleActivityPageState extends State<RecycleActivityPage> {

  Future<void> scanBarcode({required String scannedObject}) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Line color
      'Cancel', // Cancel button text
      true, // Show flash icon
      ScanMode.BARCODE, // Scan mode
    );

    if (barcodeScanRes != '-1') {
      if (scannedObject == 'product') {
        Navigator.push(context, SlideRightToLeft(page: ScanProductResultPage(barcode: barcodeScanRes)));
      } else if (scannedObject == 'returo') {
        Navigator.push(context, SlideRightToLeft(page: ScanReturoResultPage(barcode: barcodeScanRes)));
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycle'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                scanBarcode(scannedObject: 'product');
              },
              child: Text('Scaneaza un produs'),
            ),
            ElevatedButton(
              onPressed: () {
                scanBarcode(scannedObject: 'returo');
              },
              child: Text('Scaneaza bon RETURO'),
            ),
          ],
        ),
      ),
    );
  }
}
