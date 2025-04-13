import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kototinder/data/services/cat_service.dart';
import 'package:kototinder/di.dart';
import 'package:kototinder/presentation/cubit/home_cubit.dart';
import 'package:kototinder/presentation/screens/home_screen.dart';

import 'domain/repositories/cat_repository.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeCubit(getIt<CatRepository>(), getIt<CatService>()),
      child: MaterialApp(
        title: 'TinderCat',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
