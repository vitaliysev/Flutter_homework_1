import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kototinder/models/cat.dart';
import 'package:kototinder/presentation/cubit/history_cubit.dart';
import 'package:kototinder/presentation/screens/detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  final List<Cat> likedCats;
  final VoidCallback onLikedCatsChanged;

  const HistoryScreen({
    super.key,
    required this.likedCats,
    required this.onLikedCatsChanged,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    const purpleColor = Color(0xFF8E24AA);

    return BlocProvider(
      create: (context) => HistoryCubit()..setLikedCats(widget.likedCats),
      child: Builder(
        builder: (BuildContext providerContext) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                return;
              }
              final updatedLikedCats =
                  providerContext.read<HistoryCubit>().state.likedCats;
              Navigator.pop(context, updatedLikedCats);
              widget.onLikedCatsChanged();
            },
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 150.0,
                      pinned: true,
                      backgroundColor: purpleColor,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.only(
                          left: 16.0,
                          bottom: 16.0,
                          right: 16.0,
                        ),
                        title: const Text(
                          'Liked cats',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black45,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        background: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0x4D000000),
                                Color(0xB3000000),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(
                              builder: (BuildContext innerContext) {
                                return TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText: 'Search breed',
                                    labelStyle:
                                        const TextStyle(color: purpleColor),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: purpleColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: purpleColor),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: purpleColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    innerContext
                                        .read<HistoryCubit>()
                                        .searchCats(value);
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<HistoryCubit, HistoryState>(
                              builder: (context, state) {
                                final catsToShow = state.searchQuery.isNotEmpty
                                    ? state.filteredCats
                                    : state.likedCats;
                                if (catsToShow.isEmpty) {
                                  return const Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.0),
                                      child: Text(
                                        'nothing to show',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Column(
                                  children: catsToShow.map((cat) {
                                    return Card(
                                      elevation: 4,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailScreen(cat: cat),
                                            ),
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  cat.imageUrl,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (
                                                    context,
                                                    child,
                                                    progress,
                                                  ) {
                                                    if (progress == null) {
                                                      return child;
                                                    }
                                                    return const SizedBox(
                                                      width: 60,
                                                      height: 60,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) =>
                                                      const Icon(
                                                    Icons.broken_image,
                                                    size: 60,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      cat.breedName,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    if (cat.likedAt !=
                                                        null) ...[
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'Liked on: ${_formatLikedDate(cat.likedAt!)}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  context
                                                      .read<HistoryCubit>()
                                                      .removeCat(cat);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                floatingActionButton: Builder(
                  builder: (BuildContext innerContext) {
                    return FloatingActionButton(
                      onPressed: () {
                        final updatedLikedCats =
                            innerContext.read<HistoryCubit>().state.likedCats;
                        Navigator.pop(context, updatedLikedCats);
                      },
                      backgroundColor: purpleColor,
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatLikedDate(DateTime date) {
    return DateFormat('MMMM dd').format(date.toLocal());
  }
}
