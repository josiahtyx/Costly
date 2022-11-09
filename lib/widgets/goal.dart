import 'package:flutter/material.dart';

class GoalArea extends StatefulWidget {
  const GoalArea({super.key});

  @override
  State<GoalArea> createState() => _GoalAreaState();
}

class _GoalAreaState extends State<GoalArea> {
  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      Text('Goals'),
    ]);
  }
}
