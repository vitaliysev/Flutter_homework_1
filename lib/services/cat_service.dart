import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kototinder/models/cat.dart';

class CatService {
  static Future<Cat> fetchCat() async {
    final response = await http.get(
      Uri.parse('https://api.thecatapi.com/v1/images/search?has_breeds=1'),
      headers: {
        'x-api-key':
            'live_NVQA0Ot0ajzjPixxQ5RCtxklXmbBIspIg1jeWBCj7yNCMeEpApo2UBQpIRJAmqoY',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Cat.fromJson(data[0]);
    } else {
      throw Exception('Ошибка загрузки данных');
    }
  }
}
