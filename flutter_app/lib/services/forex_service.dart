import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pricer_app/models/rates.dart';

import '../models/forex.dart';


class ForexService {
  final String baseURL;
  ForexService({required this.baseURL});

  Future<Forex> getForex() async {
    final url = Uri.parse('$baseURL?base=EUR');
    final response = await http.get(url);

    // jsonDecode allows to transform body object into List or Map
    final json = jsonDecode(response.body);
    // if (json is List) {
    //   return json.map( (el) => Forex.fromJSON(el));
    // }
    if (json is Map) {
      return Forex.fromJSON(json);
    }
    return Forex(amount: 0, base: '', date: '', rates: Rates.empty() );
  }
}