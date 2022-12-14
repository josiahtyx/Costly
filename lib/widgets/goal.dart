import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalArea extends StatefulWidget {
  const GoalArea({super.key});

  @override
  State<GoalArea> createState() => _GoalAreaState();
}

class _GoalAreaState extends State<GoalArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "I want to save",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 28),
            ),
            //FutureBuilder(),
          ],
        ),
      ),
    );
  }
}
