import 'package:flutter/material.dart';
import 'package:pricer_app/models/option.dart';
import 'package:pricer_app/services/option_service.dart';
import 'package:pricer_app/views/dashboard.dart';
import 'package:pricer_app/views/option_pricer_form.dart';

class OptionDetailsWidget extends StatelessWidget {
  final Option option;

  const OptionDetailsWidget({super.key, required this.option});

  Future<String> _deleteOption(int id) async {
    try {
      final String message = await OptionService(
        baseURL: 'http://localhost:8081/option',
      ).deleteOption(id);
      return message;
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Option information'),
        actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 50),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered))
                  return Colors.orange.shade200;
              }),
              // padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(5)),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Row(spacing: 5, children: [Icon(Icons.home), Text('Home')]),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered))
                  return Colors.orange.shade200;
              }),
              // padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(5)),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/logout',
                (route) => false,
              );
            },
            child: Row(
              spacing: 5,
              children: [Icon(Icons.logout), Text('Logout')],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 400, right: 400, top: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("id", style: TextStyle(fontSize: 17)),
                Text("${option.id}", style: TextStyle(fontSize: 17)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("type", style: TextStyle(fontSize: 17)),
                Text(
                  "${option.type.toString()}",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("spot", style: TextStyle(fontSize: 17)),
                Text("${option.spot}", style: TextStyle(fontSize: 17)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("strike", style: TextStyle(fontSize: 17)),
                Text("${option.strike}", style: TextStyle(fontSize: 17)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("risk-free rate domestic", style: TextStyle(fontSize: 17)),
                Text("${option.rateDomestic}", style: TextStyle(fontSize: 17)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("risk-free rate foreign", style: TextStyle(fontSize: 17)),
                Text("${option.rateForeign}", style: TextStyle(fontSize: 17)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("maturity", style: TextStyle(fontSize: 17)),
                Text("${option.maturity}", style: TextStyle(fontSize: 17)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("day counter", style: TextStyle(fontSize: 17)),
                Text("${option.dayCounter}", style: TextStyle(fontSize: 17)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("price", style: TextStyle(fontSize: 17)),
                Text("${option.price}", style: TextStyle(fontSize: 17)),
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OptionPricerForm(option: option),
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),
                SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () async {
                    final String msg = await _deleteOption(option.id ?? 0);
                    if (!msg.isEmpty) {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Option Pricer'),
                            content: const Text('Option deleted'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/',
                                    (route) => false,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DashboardWidget(),
                                    ),
                                  );
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
