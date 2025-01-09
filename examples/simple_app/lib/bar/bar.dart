import 'package:flutter/material.dart';

class BarWidget extends StatelessWidget {
  const BarWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.amberAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star),
          const SizedBox(width: 16),
          Text(text, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}
