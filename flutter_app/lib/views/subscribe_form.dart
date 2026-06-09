import 'package:flutter/material.dart';
import 'package:pricer_app/models/user.dart';
import 'package:pricer_app/services/storage_service.dart';
import 'package:pricer_app/services/user_service.dart';
import 'package:pricer_app/views/home.dart';

class SubscribeFormWidget extends StatefulWidget {
  const SubscribeFormWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return SubscribeFormWidgetState();
  }
}

class SubscribeFormWidgetState extends State<SubscribeFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _pseudoC = TextEditingController();
  final _passwordC = TextEditingController();

  static const apiHOST = String.fromEnvironment('API_HOST', defaultValue: 'localhost');
  static const appHOST = String.fromEnvironment('APP_HOST', defaultValue: 'localhost');
  static const appPORT = String.fromEnvironment('APP_PORT', defaultValue: '80');
  
  final UserService _userService = UserService(baseURL: 'http://$appHOST:$appPORT/$apiHOST/auth');
  // final StorageService _storageService = StorageService.getInstance();
  final StorageService _storageService = StorageService();

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
        final bool isCreated = await _userService.subscribe(user);

        final String token = await _userService.login(user);
        // store token
        // await _storageService.setToken(token);
        _storageService.token = token;

        if (!mounted) return;

        //Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Subscribe successful!')));

        // navigate to Dashboard
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => HomeWidget(title: 'Option Pricer')),
        );

      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Subscribe failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe'),
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
        ],
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
                child: Text('Validate', style: TextStyle(fontSize: 23))),
            ],
          ),
        ),
      ),
    );
  }
}
