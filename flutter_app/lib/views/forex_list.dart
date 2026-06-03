import 'package:flutter/material.dart';
import 'package:pricer_app/models/currency.dart';
import 'package:pricer_app/views/currency.dart';

import '../models/forex.dart';
import '../services/forex_service.dart';

class ForexList extends StatefulWidget {
  final String base;

  const ForexList({super.key, required this.base});

  @override
  State<StatefulWidget> createState() {
    return _ForexListState();
  }
}

class _ForexListState extends State<ForexList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Exchange rates data"),
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
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: ForexService(
            baseURL: "https://api.frankfurter.dev/v1/latest",
          ).getForex(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // none, waiting, active, done
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Some error detected ?? ${snapshot.error}"),
              );
            }

            final Forex forex_obj = snapshot.data!;
            final forexes = forex_obj.rates.toMap().map(
              (key, value) => MapEntry("${forex_obj.base}/$key", value),
            );
            final forex_list = forexes.entries.toList();

            return ListView.builder(
              itemCount: forex_list.length,
              itemBuilder: (context, index) {
                final forex = forex_list[index];
                return ListTile(
                  hoverColor: Colors.cyan,
                  leading: Icon(Icons.label_important_outline_rounded),
                  trailing: Icon(Icons.control_point_rounded),
                  title: Text("${forex.key} "),
                  subtitle: Text("price: ${forex.value}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CurrencyWidget(
                          ccy: Currency(symbol: forex.key.split("/")[1]),
                          base: forex_obj.base,
                          rate: forex.value,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
