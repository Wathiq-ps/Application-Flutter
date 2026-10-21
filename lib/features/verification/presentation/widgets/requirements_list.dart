import 'package:flutter/material.dart';
import 'package:mobile/features/verification/presentation/widgets/requirement_item.dart';
import '../../../../core/extensions/media_query_extensions.dart';

class RequirementsList extends StatelessWidget {
  const RequirementsList({
    super.key,
    required this.items,
    this.circleOpacity = 0.07,
  });

  final List<String> items;
  final double circleOpacity;

  @override
  Widget build(BuildContext context) {
    final widthScale = context.widthScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          RequirementItem(text: items[i], circleOpacity: circleOpacity),
          if (i != items.length - 1) SizedBox(height: 12 * widthScale),
        ],
      ],
    );
  }
}