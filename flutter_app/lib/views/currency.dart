import 'package:flutter/material.dart';
import 'package:pricer_app/models/currency.dart';

class CurrencyWidget extends StatelessWidget {
  final Currency ccy;
  final String base;
  final double rate;

  const CurrencyWidget({required this.ccy, required this.base, required this.rate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Information on currency"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 50),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.orange.shade200;
                }
                return null;
              }),
              // padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(5)),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Row(
              spacing: 5,
              children: [Icon(Icons.home), Text('Home')],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 450, right: 450, top: 150),
        child: Column(
          children: [
            Container(
              color: Colors.orange.shade200,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("name", style: TextStyle(fontSize: 21)),
                  Text("${ccy.name}", style: TextStyle(fontSize: 23)),
                ],
              ),
            ),
            Container(
              color: Colors.orange.shade300,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("symbol", style: TextStyle(fontSize: 21)),
                  Text(ccy.symbol, style: TextStyle(fontSize: 23)),
                ],
              ),
            ),
            Container(
              color: Colors.orange.shade200,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("amount", style: TextStyle(fontSize: 21)),
                  Text(base, style: TextStyle(fontSize: 23)),
                ],
              ),
            ),
            Container(
              color: Colors.orange.shade300,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("price", style: TextStyle(fontSize: 21)),
                  Text("$rate ${ccy.symbol}", style: TextStyle(fontSize: 23)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
