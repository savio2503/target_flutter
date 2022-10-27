import 'dart:convert';
import 'package:http/http.dart' as http;

class DolarRequest {

  static double priceDolar = 0.0;

  static Future<double> requestDolar() async {
    final response = await http
        .get(Uri.parse('https://economia.awesomeapi.com.br/json/last/BRL-USD'));

    if (response.statusCode == 200) {
      return _getFromResponse(jsonDecode(response.body));
    } else {
      return Future.error('Failed to load album');
    }
  }

  static double _getFromResponse(Map<String, dynamic> json) {
    return double.parse(json['BRLUSD']['bid']);
  }
}
