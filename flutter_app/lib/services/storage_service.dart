import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static late final StorageService _instance = StorageService._privateConstructor();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  //StorageService() // default constructor
  StorageService._privateConstructor(); // named and private constructor

  static getInstance(){
    return _instance;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: 'jwt', value: token);
  }

  Future<void> removeToken() async {
    await _storage.delete(key: 'jwt');
  }
}