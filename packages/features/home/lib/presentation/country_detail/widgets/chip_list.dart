import 'package:flutter/material.dart';

class ChipList extends StatelessWidget {
  const ChipList({super.key, required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: items.map((item) => Chip(label: Text(item))).toList(),
    );
  }
}
