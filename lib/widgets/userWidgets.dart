import 'package:costlynew/widgets/amountSpent.dart';
import 'package:costlynew/widgets/goal.dart';
import 'package:flutter/material.dart';

class UserWidgetsArea extends StatefulWidget {
  const UserWidgetsArea({super.key});

  @override
  State<UserWidgetsArea> createState() => _UserWidgetsAreaState();
}

class _UserWidgetsAreaState extends State<UserWidgetsArea> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          AssetsArea(),
          // SizedBox(
          //   height: 20,
          // ),
          // GoalArea(),
        ]),
        //color: Colors.orange[800],
      ),
    );
  }
}
