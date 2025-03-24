import 'package:flutter/material.dart';

enum BlaErrorLevel {
  info(Colors.grey),
  warn(Colors.yellow),
  error(Colors.red);

  final Color color;

  const BlaErrorLevel(this.color);
}

class BlaError extends StatelessWidget {
  final String message;
  final BlaErrorLevel level;
  const BlaError(this.message, {super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: level.color),
      ),
    );
  }
}
