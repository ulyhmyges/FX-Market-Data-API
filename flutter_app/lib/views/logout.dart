import 'package:flutter/material.dart';
import 'package:pricer_app/services/storage_service.dart';

class LogoutWidget extends StatelessWidget {
  // final StorageService _storageService = StorageService.getInstance();
  final StorageService _storageService = StorageService();

  LogoutWidget({super.key});

  Future<void> _logout(BuildContext context) async {
    // await _storageService.removeToken();
    _storageService.delete();
    
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _logout(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) print("has data");
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
