import 'package:flutter/material.dart';

class LikeDislikeButton extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const LikeDislikeButton({
    super.key,
    required this.onLike,
    required this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x80808080),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onDislike,
              iconSize: 70,
              icon: const Icon(Icons.thumb_down, color: Colors.red),
              padding: const EdgeInsets.all(16),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x80808080),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onLike,
              iconSize: 70,
              icon: const Icon(Icons.thumb_up, color: Colors.green),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}
