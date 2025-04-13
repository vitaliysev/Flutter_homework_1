import 'package:kototinder/models/cat.dart';

abstract class CatRepository {
  Future<Cat> fetchCat();
}
