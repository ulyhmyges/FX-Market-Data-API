import 'package:flutter/material.dart';
import 'package:pricer_app/views/login_form.dart';
import 'package:pricer_app/views/subscribe_form.dart';

import 'forex_list.dart';

class Welcome extends StatelessWidget {
  final String title;

  const Welcome({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actionsPadding: EdgeInsetsGeometry.symmetric(horizontal: 50),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states){
                if (states.contains(WidgetState.hovered)) {
                  return Colors.orange.shade200;
                }
                return null;
              }),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginFormWidget()),
              );
            },
            child: Row(
              spacing: 5,
              children: [Icon(Icons.login), Text('Login')],
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states){
                if (states.contains(WidgetState.hovered)) {
                  return Colors.orange.shade200;
                }
                return null;
              })
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubscribeFormWidget()),
              );
            },
            child: Row(
              spacing: 5,
              children: [Icon(Icons.add), Text('Subscribe')],
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(100),
          child: Column(
            spacing: 30,
            children: [
              Text('Welcome', style: TextStyle(fontSize: 37, color: Colors.cyan)),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize:  WidgetStateProperty.all(const Size(1050, 80)), // width, height,
                  backgroundColor: WidgetStateProperty.resolveWith((states){
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.cyan;
                    }
                    return null;
                  }),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForexList(base: 'EUR'),
                    ),
                  );
                },
                child: Text('Exchange rates data with EUR as the base currency', style: TextStyle(fontSize: 25)),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize:  WidgetStateProperty.all(const Size(1050, 80)), // width, height,
                  backgroundColor: WidgetStateProperty.resolveWith((states){
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.cyan;
                    }
                    return null;
                  }),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Compute Option Price'),
                      content: const Text('You need to be logged in to access this feature.', style: TextStyle(fontSize: 19)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Compute Option Price', style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
