import 'package:kototinder/data/services/cat_service.dart';
import 'package:kototinder/domain/repositories/cat_repository.dart';
import 'package:kototinder/models/cat.dart';

class CatRepositoryImpl implements CatRepository {
  final CatService _catService;

  CatRepositoryImpl(this._catService);

  @override
  Future<Cat> fetchCat() async {
    final response = await _catService.getRandomCat();
    return Cat.fromJson(response);
  }
}
