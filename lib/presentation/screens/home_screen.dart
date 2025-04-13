import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kototinder/di.dart';
import 'package:kototinder/domain/repositories/cat_repository.dart';
import 'package:kototinder/models/cat.dart';
import 'package:kototinder/presentation/cubit/home_cubit.dart';
import 'package:kototinder/presentation/screens/detail_screen.dart';
import 'package:kototinder/presentation/screens/history_screen.dart';
import 'package:kototinder/presentation/widgets/like_dislike_button.dart';

import '../../data/services/cat_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isConnected = true;
  bool _isDialogShowing = false;
  late HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = HomeCubit(getIt<CatRepository>(), getIt<CatService>());
    _checkConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final bool isConnected =
          results.any((result) => result != ConnectivityResult.none);
      setState(() {
        _isConnected = isConnected;
      });
      if (isConnected) {
        if (_homeCubit.state.error != null) {
          _homeCubit.fetchCat();
        }
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = results.any((result) => result != ConnectivityResult.none);
    });
  }

  void _showErrorDialog(BuildContext context, String error) {
    if (_isDialogShowing) {
      return;
    }
    _isDialogShowing = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Ошибка сети'),
            content: Text('Не удалось загрузить котика.\nДетали: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  dialogContext.read<HomeCubit>().clearError();
                  _isDialogShowing = false;
                },
                child: const Text('Закрыть'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  dialogContext.read<HomeCubit>().fetchCat();
                  _isDialogShowing = false;
                },
                child: const Text('Повторить'),
              ),
            ],
          ),
        ).then((_) {
          _isDialogShowing = false;
        });
      } else {
        _isDialogShowing = false;
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _homeCubit,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: const Color(0xFF8E24AA),
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TinderCat',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) => Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.history, color: Colors.white),
                          onPressed: () async {
                            final updatedLikedCats =
                                await Navigator.push<List<Cat>>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoryScreen(
                                  likedCats: state.likedCats,
                                  onLikedCatsChanged: () {},
                                ),
                              ),
                            );
                            if (updatedLikedCats != null) {
                              _homeCubit.setLikedCats(updatedLikedCats);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'Likes: ${state.likeCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 24.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state.error != null) {
                            _showErrorDialog(context, state.error!);
                            return const SizedBox();
                          } else if (state.currentCat == null) {
                            return const Center(child: Text('Нет данных'));
                          }
                          return Dismissible(
                            key: ValueKey(state.currentCat!.id),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                _homeCubit.dislikeCat();
                              } else if (direction ==
                                  DismissDirection.startToEnd) {
                                _homeCubit.likeCat();
                              }
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailScreen(cat: state.currentCat!),
                                  ),
                                );
                              },
                              child: Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Image.network(
                                        state.currentCat!.imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.65,
                                        loadingBuilder:
                                            (context, child, progress) {
                                          if (progress == null) return child;
                                          return SizedBox(
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.65,
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Color(0xCC000000),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          state.currentCat!.breedName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Builder(
                      builder: (BuildContext innerContext) {
                        return BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            final isEnabled =
                                _isConnected && state.error == null;
                            return LikeDislikeButton(
                              onLike: () => _homeCubit.likeCat(),
                              onDislike: () => _homeCubit.dislikeCat(),
                              isEnabled: isEnabled,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
