import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kototinder/models/cat.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryState.initial());

  void setLikedCats(List<Cat> likedCats) {
    emit(state.copyWith(likedCats: likedCats));
  }

  void removeCat(Cat cat) {
    final updatedCats = state.likedCats.where((c) => c.id != cat.id).toList();
    emit(state.copyWith(likedCats: updatedCats));
  }

  void searchCats(String query) {
    final filteredCats = state.likedCats
        .where(
          (cat) => cat.breedName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    emit(state.copyWith(filteredCats: filteredCats, searchQuery: query));
  }
}

class HistoryState extends Equatable {
  final List<Cat> likedCats;
  final List<Cat> filteredCats;
  final String searchQuery;

  const HistoryState({
    required this.likedCats,
    required this.filteredCats,
    required this.searchQuery,
  });

  factory HistoryState.initial() => const HistoryState(
        likedCats: [],
        filteredCats: [],
        searchQuery: '', // Изначально запрос пустой
      );

  HistoryState copyWith({
    List<Cat>? likedCats,
    List<Cat>? filteredCats,
    String? searchQuery,
  }) {
    return HistoryState(
      likedCats: likedCats ?? this.likedCats,
      filteredCats: filteredCats ?? this.filteredCats,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [likedCats, filteredCats, searchQuery];
}
