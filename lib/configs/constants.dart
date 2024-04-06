// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:ing_mobile/features/activities/recycle/scan_product_result.dart';
import 'package:ing_mobile/utilities/animation/slideright_toleft.dart';
import 'package:logger/logger.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

Future<void> scanBarcode(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Line color
      'Cancel', // Cancel button text
      true, // Show flash icon
      ScanMode.BARCODE, // Scan mode
    );

    if (barcodeScanRes == '59489184' || barcodeScanRes == '5948918') {
      Navigator.push(context, SlideRightToLeft(page: ScanProductResultPage(barcode: barcodeScanRes)));
    } else {
      scanBarcode(context);
    }
    
  }

String appName = 'ing-mobile';
bool emailVerificationEnabled = false;
bool pinEnabled = false;

const Color mainColor = Color(0xFF000089);

var logger = Logger(printer: PrettyPrinter(),);

void loadingDialog(BuildContext context) {
  CoolAlert.show(
    context: context,
    type: CoolAlertType.loading,
    text: 'Loading...',
    barrierDismissible: false,
  );
}

void successDialog(BuildContext context, String message) {
  CoolAlert.show(
    context: context,
    barrierDismissible: false,
    type: CoolAlertType.success,
    backgroundColor: Colors.greenAccent.withOpacity(0.1),
    confirmBtnColor: const Color.fromARGB(255, 73, 186, 143),
    confirmBtnText: 'OK',
    title: message,
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.w600,
    )
  );
}

void errorDialog(BuildContext context, String message) {
  Navigator.pop(context); // close loadingDialog()
  CoolAlert.show(
    context: context,
    barrierDismissible: false,
    type: CoolAlertType.error,
    backgroundColor: Colors.redAccent.withOpacity(0.1),
    confirmBtnColor: Colors.redAccent,
    confirmBtnText: 'OK',
    title: message,
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.w600,
    )
  );
}

const kMainColor = Color(0xFFFCFCFC);
const kSecondaryColor = Color(0xff15c682);
const kBlueColor = Color(0xFF7A60EB);
const kGreyDarkColor = Color(0xFF666666);
const kBlackColor = Color(0xFF1A1B23);
const kBlueDarkColor = Color(0xFF01004A);
const kGreenLightColor = Color(0xFF80D261);
const kGreenColor = Color(0xFF32BA7C);
const kOrangeLightColor = Color(0xFFF9EAB0);
const kGreyBottomColor = Color(0xFF79869F);
const kBlackLightColor = Color(0xFF656565);
const kYellowColor = Color(0xFFFFBE11);
const kOragneColor = Color(0xFFFF633E);
const kRedColor = Color(0xFFF15249);
const kWhiteLightColor = Color(0xFFFCFCFC);
const kGreyLightColor = Color(0xFFD9D9D9);
