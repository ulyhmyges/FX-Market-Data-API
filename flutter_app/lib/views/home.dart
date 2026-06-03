import 'package:flutter/material.dart';
import 'package:pricer_app/views/dashboard.dart';
import 'package:pricer_app/views/logout.dart';
import 'package:pricer_app/views/option_pricer_form.dart';

import 'forex_list.dart';

class HomeWidget extends StatelessWidget {
  final String title;

  const HomeWidget({super.key, required this.title});

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
                })
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogoutWidget()),
              );
            },
            child: Row(
              spacing: 5,
              children: [
                Icon(Icons.logout),
                Text('Logout')
              ],
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OptionPricerForm()),
                  );
                },
                child: Text('Compute Option Price', style: TextStyle(fontSize: 25)),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardWidget()),
                  );
                },
                child: Text('Dashboard', style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
