import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:kototinder/models/cat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.thecatapi.com/v1/',
      headers: {
        'x-api-key':
            'live_NVQA0Ot0ajzjPixxQ5RCtxklXmbBIspIg1jeWBCj7yNCMeEpApo2UBQpIRJAmqoY',
      },
    ),
  );

  static const String likedCatsKey = 'liked_cats';
  static const String likeCountKey = 'like_count';

  Future<Map<String, dynamic>> getRandomCat() async {
    try {
      final response = await _dio.get('images/search?has_breeds=1');
      return response.data[0];
    } on DioException catch (e) {
      throw Exception('Ошибка API: ${e.message}');
    }
  }

  Future<void> saveState(List<Cat> likedCats, int likeCount) async {
    final prefs = await SharedPreferences.getInstance();
    final likedCatsJson = jsonEncode(likedCats.map(_catToJson).toList());
    await prefs.setString(likedCatsKey, likedCatsJson);
    await prefs.setInt(likeCountKey, likeCount);
  }

  Future<Map<String, dynamic>> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final likedCatsJson = prefs.getString(likedCatsKey);
    List<Cat> likedCats = [];
    if (likedCatsJson != null) {
      final List<dynamic> likedCatsList = jsonDecode(likedCatsJson);
      likedCats = likedCatsList.map((json) => Cat.fromJson(json)).toList();
    }
    final likeCount = prefs.getInt(likeCountKey) ?? 0;
    return {
      'likedCats': likedCats,
      'likeCount': likeCount,
    };
  }

  Map<String, dynamic> _catToJson(Cat cat) {
    return {
      'id': cat.id,
      'imageUrl': cat.imageUrl,
      'breedName': cat.breedName,
      'breedDescription': cat.breedDescription,
      'temperament': cat.temperament,
      'origin': cat.origin,
      'lifeSpan': cat.lifeSpan,
      'likedAt': cat.likedAt?.toIso8601String(),
    };
  }
}
