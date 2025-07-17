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
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(100),
          child: Column(
            children: [
              Text("name: ${ccy.name}"),
              Text("symbol: ${ccy.symbol}"),
              Text("amount: 1 $base"),
              Text("price: $rate ${ccy.symbol}")
            ],
          ),
        ),
      ),
    );
  }
}
