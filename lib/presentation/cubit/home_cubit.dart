import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kototinder/data/services/cat_service.dart';
import 'package:kototinder/domain/repositories/cat_repository.dart';
import 'package:kototinder/models/cat.dart';

class HomeCubit extends Cubit<HomeState> {
  final CatRepository catRepository;
  final CatService catService;
  bool isFetching = false;

  HomeCubit(this.catRepository, this.catService) : super(HomeState.initial()) {
    _loadState();
    fetchCat();
  }

  Future<void> _loadState() async {
    final stateData = await catService.loadState();
    emit(
      state.copyWith(
        likedCats: stateData['likedCats'],
        likeCount: stateData['likeCount'],
      ),
    );
  }

  Future<void> _saveState() async {
    await catService.saveState(state.likedCats, state.likeCount);
  }

  Future<void> fetchCat() async {
    if (isFetching) return;
    isFetching = true;
    emit(state.copyWith(isLoading: true));
    try {
      final cat = await catRepository.fetchCat();
      emit(state.copyWith(currentCat: cat, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    } finally {
      isFetching = false;
    }
  }

  void likeCat() {
    if (state.error != null) {
      return;
    }
    if (state.currentCat != null) {
      final likedCat = state.currentCat!.copyWith(likedAt: DateTime.now());
      emit(
        state.copyWith(
          likedCats: [...state.likedCats, likedCat],
          likeCount: state.likeCount + 1,
        ),
      );
      _saveState();
    }
    fetchCat();
  }

  void dislikeCat() {
    if (state.error != null) {
      return;
    }
    fetchCat();
  }

  void setLikedCats(List<Cat> likedCats) {
    emit(state.copyWith(likedCats: likedCats, likeCount: likedCats.length));
    _saveState();
  }

  void clearError() {
    emit(state.copyWith());
  }
}

class HomeState extends Equatable {
  final Cat? currentCat;
  final List<Cat> likedCats;
  final int likeCount;
  final bool isLoading;
  final String? error;

  const HomeState({
    required this.currentCat,
    required this.likedCats,
    required this.likeCount,
    required this.isLoading,
    this.error,
  });

  factory HomeState.initial() => const HomeState(
        currentCat: null,
        likedCats: [],
        likeCount: 0,
        isLoading: false,
      );

  HomeState copyWith({
    Cat? currentCat,
    List<Cat>? likedCats,
    int? likeCount,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      currentCat: currentCat ?? this.currentCat,
      likedCats: likedCats ?? this.likedCats,
      likeCount: likeCount ?? this.likeCount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props =>
      [currentCat, likedCats, likeCount, isLoading, error];
}
