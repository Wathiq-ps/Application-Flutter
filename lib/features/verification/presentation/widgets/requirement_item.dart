import 'package:flutter/material.dart';

class RequirementItem extends StatelessWidget {
  final String text;

  const RequirementItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xff173563).withOpacity(0.8),
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
