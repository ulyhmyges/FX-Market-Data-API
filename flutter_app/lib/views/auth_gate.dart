import 'package:flutter/cupertino.dart';
import 'package:pricer_app/models/Session.dart';
import 'package:pricer_app/services/storage_service.dart';
import 'package:pricer_app/services/user_service.dart';
import 'package:pricer_app/views/dashboard.dart';
import 'package:pricer_app/views/home.dart';
import 'package:pricer_app/views/login_form.dart';
import 'package:pricer_app/views/welcome.dart';

class AuthGateWidget extends StatelessWidget {
  AuthGateWidget({super.key});
  final StorageService _storageService = StorageService.getInstance();
  final UserService _userService = UserService(baseURL: 'http://localhost:8081/auth');

  Future<Session> _me() async {
    final String? token = await _storageService.getToken();
    final Session session = await _userService.me(token!);
    return session;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _me(),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            final Session session = snapshot.data!;
            if (session.token_expired)
              return const Welcome(title: 'Option Pricer');
            return const HomeWidget(title: 'Home');
          }
          return const Welcome(title: 'Option Pricer');
        }
    );
  }

}