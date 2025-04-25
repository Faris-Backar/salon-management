import 'package:flutter/material.dart';

class ChartLegendWidget extends StatelessWidget {
  final Color color;
  final String label;
  const ChartLegendWidget(
      {super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
