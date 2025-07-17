import 'package:flutter/cupertino.dart';
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
                if (states.contains(WidgetState.hovered))
                  return Colors.orange.shade200;
              }),
               // padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(5)),

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
                if (states.contains(WidgetState.hovered))
                  return Colors.orange.shade200;
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
            spacing: 100,
            children: [
              Text('Welcome', style: TextStyle(fontSize: 37, color: Colors.cyan)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForexList(base: 'EUR'),
                    ),
                  );
                },
                child: Text('Forex'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
