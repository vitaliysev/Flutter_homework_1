import 'package:flutter/material.dart';

class LikeDislikeButton extends StatelessWidget {
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final bool isEnabled;

  const LikeDislikeButton({
    super.key,
    required this.onLike,
    required this.onDislike,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
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
              onPressed: isEnabled
                  ? onDislike
                  : null,
              iconSize: 70,
              icon: Icon(
                Icons.thumb_down,
                color: isEnabled
                    ? Colors.red
                    : Colors.grey,
              ),
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
              onPressed: isEnabled
                  ? onLike
                  : null,
              iconSize: 70,
              icon: Icon(
                Icons.thumb_up,
                color: isEnabled
                    ? Colors.green
                    : Colors.grey,
              ),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}
