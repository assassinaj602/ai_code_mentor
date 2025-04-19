import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GameRatingBar extends StatelessWidget {
  final double rating;
  final bool isInteractive;
  final Function(double)? onRatingUpdate;

  const GameRatingBar({
    super.key,
    required this.rating,
    this.isInteractive = false,
    this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 24,
      ignoreGestures: !isInteractive,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: onRatingUpdate ?? (_) {},
    );
  }
}
