import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final String brand = args['brand'] ?? "";
    final String productName = args['productName'] ?? "";
    final String image = args['image'] ?? "";
    final String quantity = args['quantity'] ?? "";
    final List<Map<String, dynamic>> ingredients =
        args['ingredients'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (image.isNotEmpty)
                      SizedBox(
                        width: 100, // Set the width of the image container
                        height: 100, // Set the height of the image container
                        child: Image.network(image),
                      )
                    else
                      const CircularProgressIndicator(),
                    const SizedBox(width: 16), // Add spacing between image and text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          brand,
                          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          productName,
                          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Ingredients:",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                DataTable(
                  columns: const [
                    DataColumn(
                      label: SizedBox(
                        width: 100, // Set the width for the Name column
                        child: Text('Name'),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 50, // Set the width for the Percentage column
                        child: Text('Percentage'),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 50, // Set the width for the Weight column
                        child: Text('Weight'),
                      ),
                    ),
                  ],
                  rows: ingredients.map((ingredient) {
                    final percentEstimate =
                    double.parse(ingredient['percent_estimate']?.toString() ?? '0.0');
                    final percentMax =
                    double.parse(ingredient['percent_max']?.toString() ?? '0.0');
                    final weight = "${(percentEstimate *
                        double.parse(quantity.split(" ")[0].replaceAll(RegExp(r'[^0-9.]'), '')) /
                        100.0)
                        .toStringAsFixed(2)} ${quantity.replaceAll(RegExp(r'[0-9.]'), '')}";

                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            width: 100, // Set the width for the Name cell
                            child: Text(ingredient['text'].toString().replaceAll('_', '') ?? ''),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 50, // Set the width for the Percentage cell
                            child: Text(percentEstimate.toStringAsFixed(2)),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 50, // Set the width for the Weight cell
                            child: Text(weight),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
