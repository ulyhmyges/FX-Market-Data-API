import 'package:flutter/material.dart';
import 'package:pricer_app/models/user.dart';
import 'package:pricer_app/services/user_service.dart';

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
  static const apiPORT = String.fromEnvironment('API_PORT', defaultValue: '8080');

  final _userService = UserService(baseURL: 'http://$apiHOST:$apiPORT/auth');

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Subscribe successful!')));
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Subscribe failed $e')));
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
              }),
              // padding: WidgetStateProperty.all(EdgeInsetsGeometry.all(5)),
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
            spacing: 10,
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
              ElevatedButton(onPressed: _submitForm, child: Text('Validate')),
            ],
          ),
        ),
      ),
    );
  }
}
