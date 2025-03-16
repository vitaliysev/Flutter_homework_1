import 'package:flutter/material.dart';
import 'package:kototinder/models/cat.dart';
import 'package:kototinder/screens/detail_screen.dart';
import 'package:kototinder/screens/history_screen.dart';
import 'package:kototinder/services/cat_service.dart';
import 'package:kototinder/widgets/like_dislike_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Cat? _currentCat;
  int _likeCount = 0;
  final List<Cat> _likedCats = [];
  bool _isLoading = false;

  Future<void> _fetchCat() async {
    setState(() {
      _isLoading = true;
      _currentCat = null;
    });

    try {
      final cat = await CatService.fetchCat();
      if (mounted) {
        setState(() {
          _currentCat = cat;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onLike() {
    if (_currentCat != null) {
      setState(() {
        _likeCount++;
        _likedCats.add(_currentCat!);
      });
    }
    _fetchCat();
  }

  void _onDislike() {
    _fetchCat();
  }

  @override
  void initState() {
    super.initState();
    _fetchCat();
  }

  @override
  Widget build(BuildContext context) {
    const purpleColor = Color(0xFF8E24AA);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: purpleColor,
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
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.history, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HistoryScreen(likedCats: _likedCats),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Center(
                        child: Text(
                          'Likes: $_likeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
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
                    child: _isLoading || _currentCat == null
                        ? const Center(child: CircularProgressIndicator())
                        : Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                _onDislike();
                              } else if (direction ==
                                  DismissDirection.startToEnd) {
                                _onLike();
                              }
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailScreen(cat: _currentCat!),
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
                                        _currentCat!.imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.65,
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
                                          _currentCat!.breedName,
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
                          ),
                  ),
                  const SizedBox(height: 8),
                  LikeDislikeButton(
                    onLike: _onLike,
                    onDislike: _onDislike,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
