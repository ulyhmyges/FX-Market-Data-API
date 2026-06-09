//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  //static late final StorageService _instance = StorageService._privateConstructor();
  late final SharedPreferences _storageService;
  static final StorageService _instance = StorageService._internal();
  //final FlutterSecureStorage _storage = FlutterSecureStorage();
  
  factory StorageService() => _instance;
  StorageService._internal();

  Future<void> init() async {
    _storageService = await SharedPreferences.getInstance();
  }

  //StorageService() // default constructor
  //StorageService._privateConstructor(); // named and private constructor

  // static getInstance(){
  //   return _instance;
  // }

  String get token => _storageService.getString('jwt') ?? "";

  set token(String value) {
    _storageService.setString('jwt', value);
  }

  void delete(){
    _storageService.remove('jwt');
  }

  // Future<String?> getToken() async {
  //   //return await _storage.read(key: 'jwt');
  // }

  // Future<void> setToken(String token) async {
  //   //await _storage.write(key: 'jwt', value: token);
  // }

  // Future<void> removeToken() async {
  //   //await _storage.delete(key: 'jwt');
  // }
}