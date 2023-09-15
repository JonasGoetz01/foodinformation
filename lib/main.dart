import 'package:beispielapp/product.dart';
import 'package:beispielapp/scanBarcode.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const ScanBarcodeScreen(),
        '/product': (context) => const ProductScreen(),
      },
    );
  }
}
