import 'dart:convert';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ScanBarcodeScreen extends StatelessWidget {
  const ScanBarcodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Barcode"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                try {
                  final result = await BarcodeScanner.scan();
                  final scannedValue = result.rawContent;
                  //const scannedValue = "4260556630045";

                  // Fetch product details based on the scanned barcode
                  final productDetails = await fetchProductDetails(scannedValue);

                  Navigator.pushNamed(
                    context,
                    '/product',
                    arguments: productDetails,
                  );
                } catch (e) {
                  if (kDebugMode) {
                    print("Error scanning barcode: $e");
                  }
                }
              },
              child: const Text("Scan Barcode"),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchProductDetails(String barcode) async {
    try {
      final response = await http.get(
          Uri.parse("https://world.openfoodfacts.org/api/v0/product/$barcode.json"));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final product = jsonData['product'];

        final quantity = product['quantity'].toString();
        final productName = product['product_name'];
        final image = product['image_url'];
        final brand = product['brands_imported'];
        final ingredients = List<Map<String, dynamic>>.from(
            product['ingredients'].cast<Map<String, dynamic>>());

        return {
          'brand': brand,
          'productName': productName,
          'image': image,
          'quantity': quantity,
          'ingredients': ingredients,
        };
      } else {
        return {
          'brand': "Failed to retrieve product details",
          'productName': "",
          'image': "",
          'quantity': "",
          'ingredients': [],
        };
      }
    } catch (e) {
      return {
        'brand': "Error: $e",
        'productName': "",
        'image': "",
        'quantity': "",
        'ingredients': [],
      };
    }
  }
}
