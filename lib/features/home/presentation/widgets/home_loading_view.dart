import 'package:flutter/material.dart';
import '../../../../core/widget/skeleton_box.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key, required this.widthScale});
  final double widthScale;

  @override
  Widget build(BuildContext context) {
    final ws = widthScale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(height: 190 * ws, radius: 24 * ws),
        SizedBox(height: 24 * ws),
        SkeletonBox(height: 20 * ws, width: 140 * ws, radius: 6),
        SizedBox(height: 12 * ws),
        for (var i = 0; i < 3; i++) ...[
          SkeletonBox(height: 260 * ws, radius: 20 * ws),
          SizedBox(height: 16 * ws),
        ],
      ],
    );
  }
}