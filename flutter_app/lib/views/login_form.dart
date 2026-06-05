
import 'package:flutter/material.dart';
import 'package:pricer_app/models/user.dart';
import 'package:pricer_app/services/storage_service.dart';
import 'package:pricer_app/services/user_service.dart';
import 'package:pricer_app/views/home.dart';
import 'package:pricer_app/views/subscribe_form.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginFormWidgetState();
  }
}

class LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _pseudoC = TextEditingController();
  final _passwordC = TextEditingController();

  static const apiHOST = String.fromEnvironment('API_HOST', defaultValue: 'localhost');
  static const appHOST = String.fromEnvironment('APP_HOST', defaultValue: 'localhost');
  static const appPORT = String.fromEnvironment('APP_PORT', defaultValue: '80');

  final _userService = UserService(baseURL: "http://localhost:$appPORT/$apiHOST/auth");
  final _storageService = StorageService.getInstance();

  String? _validateRequiredString(String? value) {
    if (value == null || value.isEmpty) return 'The field is mandatory';
    return null;
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String pseudo = _pseudoC.text;
      final String password = _passwordC.text;
      final User user = User(pseudo: pseudo, password: password);
      try {
        final String token = await _userService.login(user);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login successful!')));

        // store token
        await _storageService.setToken(token);

        // navigate to Dashboard
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => HomeWidget(title: 'Option Pricer')),
        );
        //Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
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
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Row(spacing: 5, children: [Icon(Icons.home), Text('Home')]),
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
                MaterialPageRoute<SubscribeFormWidget>(
                  builder: (context) => SubscribeFormWidget(),
                ),
              );
            },
            child: Row(
              spacing: 5,
              children: [Icon(Icons.add), Text('Subscribe')]
            ),
          ),
        ]
      ),
      body: Padding(
        padding: EdgeInsets.all(100),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 15,
            children: [
              TextFormField(
                controller: _pseudoC,
                validator: _validateRequiredString,
                decoration: InputDecoration(labelText: "Pseudo"),
              ),
              TextFormField(
                controller: _passwordC,
                validator: _validateRequiredString,
                decoration: InputDecoration(labelText: "Password"),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize:  WidgetStateProperty.all(const Size(850, 50)), // width, height,
                  backgroundColor: WidgetStateProperty.resolveWith((states){
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.cyan;
                    }
                    return null;
                  }),
                ),
                onPressed: _submitForm, 
                child: Text('Validate', style: TextStyle(fontSize: 23))
              ),
            ],
          ),
        ),
      ),
    );
  }
}
