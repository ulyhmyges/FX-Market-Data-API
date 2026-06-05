import 'package:flutter/material.dart';
import 'package:pricer_app/models/option.dart';
import 'package:pricer_app/services/option_service.dart';
import 'package:pricer_app/views/dashboard.dart';
import 'package:pricer_app/views/option_pricer_form.dart';

class OptionDetailsWidget extends StatelessWidget {
  final Option option;

  static const apiHOST = String.fromEnvironment('API_HOST', defaultValue: 'localhost');
  static const apiPORT = String.fromEnvironment('API_PORT', defaultValue: '8080');

  const OptionDetailsWidget({super.key, required this.option});

  Future<String> _deleteOption(int id) async {
    try { 
      final String message = await OptionService(
        baseURL: 'http://$apiHOST:$apiPORT/option',
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
        title: Text('Option details'),
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
            child: Row(spacing: 5, children: [Icon(Icons.home), Text('Home')]),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.orange.shade200;
                }
              }),
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
        padding: const EdgeInsets.only(left: 450, right: 450, top: 90),
        child: Column(
          children: [
            Container(
              color: Colors.orange.shade200,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("id", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  Text("${option.id}", style: TextStyle(fontSize: 21)),
                ],
              ),
            ),
            Container(
              color: Colors.orange.shade300,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("type", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  Text(
                    option.type.toString(),
                    style: TextStyle(fontSize: 21),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.orange.shade200,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("spot", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  Text("${option.spot}", style: TextStyle(fontSize: 21)),
                ],
              ),
            ),
            Container(
              color: Colors.orange.shade300,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("strike", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  Text("${option.strike}", style: TextStyle(fontSize: 21)),
                ],
              ),
            ),
            Container(
              color: Colors.orange.shade200,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("risk-free rate domestic", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  Text("${option.rateDomestic}", style: TextStyle(fontSize: 21)),
                ],
              ),
            ),
            Container(
              color: Colors.orange.shade300,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("risk-free rate foreign", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  Text("${option.rateForeign}", style: TextStyle(fontSize: 21)),
                ],
              ),
            ),
            Container(
              color: Colors.orange.shade200,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("maturity", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  Text(option.maturity, style: TextStyle(fontSize: 21)),
                ],
              ),
            ),
            Container(
              color: Colors.orange.shade300,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("day counter", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  Text("${option.dayCounter}", style: TextStyle(fontSize: 21)),
                ],
              ),
            ),
            Container(
              color: Colors.orange.shade200,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("price", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  Text("${option.price}", style: TextStyle(fontSize: 21)),
                ],
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize:  WidgetStateProperty.all(const Size(250, 50)), // width, height,
                    backgroundColor: WidgetStateProperty.resolveWith((states){
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.cyan;
                      }
                      return null;
                    }),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OptionPricerForm(option: option),
                      ),
                    );
                  },
                  child: Text('Edit', style: TextStyle(fontSize: 23)),
                ),
                SizedBox(width: 30),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize:  WidgetStateProperty.all(const Size(250, 50)), // width, height,
                    backgroundColor: WidgetStateProperty.resolveWith((states){
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.cyan;
                      }
                      return null;
                    }),
                  ),
                  onPressed: () async {
                    final String msg = await _deleteOption(option.id ?? 0);
                    if (msg.isNotEmpty) {
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
                  child: Text('Delete', style: TextStyle(fontSize: 23)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
