import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  const RatingStars({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.round();
        return Icon(filled ? Icons.star_rounded : Icons.star_border_rounded, color: Colors.amber, size: size);
      }),
    );
  }
}

class InteractiveRatingStars extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;
  const InteractiveRatingStars({super.key, required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final filled = i < rating.round();
        return IconButton(
          iconSize: 40,
          onPressed: () => onChanged((i + 1).toDouble()),
          icon: Icon(filled ? Icons.star_rounded : Icons.star_border_rounded, color: Colors.amber),
        );
      }),
    );
  }
}
