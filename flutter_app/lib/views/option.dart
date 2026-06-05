import 'package:flutter/material.dart';
import 'package:pricer_app/models/option.dart';
import 'package:pricer_app/models/option_state.dart';
import 'package:pricer_app/services/option_service.dart';

class OptionWidget extends StatelessWidget {
  final Option option;

  static const apiHOST = String.fromEnvironment('API_HOST', defaultValue: 'localhost');
  static const appHOST = String.fromEnvironment('APP_HOST', defaultValue: 'localhost');
  static const appPORT = String.fromEnvironment('APP_PORT', defaultValue: '80');
  static const String optionBaseURL = 'http://$appHOST:$appPORT/$apiHOST/option';

  const OptionWidget({super.key, required this.option});

  Future<OptionState> _saveOption(BuildContext context) async {
    try {
      if (option.client == 'error') {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
      final OptionState state = await OptionService(baseURL: optionBaseURL).updateOrStoreOption(option);
      return state;
    } catch (e) {
      return OptionState.Unstored;
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
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Row(
              spacing: 5, 
              children: [Icon(Icons.home), Text('Home')]
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.orange.shade200;
                }
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
        padding: const EdgeInsets.only(left: 450, right: 450, top: 90),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("id", style: TextStyle(fontSize: 23)),
                Text("${option.id}", style: TextStyle(fontSize: 23)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("type", style: TextStyle(fontSize: 23)),
                Text(
                  option.type.toString(),
                  style: TextStyle(fontSize: 23),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("spot", style: TextStyle(fontSize: 23)),
                Text("${option.spot}", style: TextStyle(fontSize: 23)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("strike", style: TextStyle(fontSize: 23)),
                Text("${option.strike}", style: TextStyle(fontSize: 23)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("risk-free rate domestic", style: TextStyle(fontSize: 23)),
                Text("${option.rateDomestic}", style: TextStyle(fontSize: 23)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("risk-free rate foreign", style: TextStyle(fontSize: 23)),
                Text("${option.rateForeign}", style: TextStyle(fontSize: 23)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("maturity", style: TextStyle(fontSize: 23)),
                Text(option.maturity, style: TextStyle(fontSize: 23)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("day counter", style: TextStyle(fontSize: 23)),
                Text("${option.dayCounter}", style: TextStyle(fontSize: 23)),
              ],
            ),
            FutureBuilder(
              future: OptionService(
                baseURL: optionBaseURL,
              ).getPrice(option),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Some error detected ?? ${snapshot.error}"),
                  );
                }

                final Option computedOption = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("result", style: TextStyle(fontSize: 23)),
                      Text("${computedOption.price}", style: TextStyle(fontSize: 25, backgroundColor: Colors.orange.shade100))
                    ],
                  ),
                );
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize:  WidgetStateProperty.all(const Size(450, 50)), // width, height,
                backgroundColor: WidgetStateProperty.resolveWith((states){
                  if (states.contains(WidgetState.hovered)) {
                    return Colors.cyan;
                  }
                  return null;
                }),
              ),
              onPressed:
              () async {
                final OptionState state = await _saveOption(context);

                if (state == OptionState.Stored){
                  showDialog<void>(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text('Option Pricer'),
                          content: const Text('Option saved'),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {Navigator.pushNamedAndRemoveUntil(
                                    context, '/option/pricer', (route) => false);},
                                child: const Text('OK')
                            )
                          ],
                        );
                      }
                  );
                }

              },
              child: Text('Save', style: TextStyle(fontSize: 23))
            )
          ],
        ),
      ),
    );
  }
}
