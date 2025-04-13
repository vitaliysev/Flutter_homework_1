import 'package:get_it/get_it.dart';
import 'package:kototinder/data/repositories/cat_repository_impl.dart';
import 'package:kototinder/data/services/cat_service.dart';
import 'package:kototinder/domain/repositories/cat_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<CatService>(CatService.new);
  getIt.registerLazySingleton<CatRepository>(
    () => CatRepositoryImpl(getIt<CatService>()),
  );
}
