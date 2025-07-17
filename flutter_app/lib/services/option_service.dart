import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pricer_app/models/option.dart';
import 'package:pricer_app/models/option_state.dart';

class OptionService {
  final String baseURL;
  OptionService({required this.baseURL});

  Future<Option> getPrice(Option option) async {
    final uri = Uri.parse('$baseURL/price');
    final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(option.toJSON())
    );
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      option.price = (json['price'] as num).toDouble();
      return option;
    } else {
      throw Exception('Failed to fetch price::: ${res.statusCode}');
    }
  }

  // method: POST
  // route: /option
  Future<OptionState> updateOrStoreOption(Option option) async {
    final uri = Uri.parse('$baseURL');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(option.toJSON())
    );
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return OptionState.fromJSON(json);
    } else {
      throw Exception('Failed to store option::: ${res.statusCode}');
    }
  }

  Future<Iterable<Option>> getOptions(int user_id) async {
    final url = Uri.parse('$baseURL/all?user_id=$user_id');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      if (json is List){
        return json.map( (el) => Option.fromJSON(el));
      }
      return [];
    } else {
      throw Exception('Failed to get options by user_id = $user_id');
    }
  }

  // method: DELETE
  // route: /option?id=1
  Future<String> deleteOption(int option_id) async {
    final uri = Uri.parse('$baseURL?id=$option_id');
    final res = await http.delete(
      uri
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return json['message'];
    } else {
      throw Exception('Failed to delete option (id=$option_id)::: ${res.statusCode}');
    }
  }
}