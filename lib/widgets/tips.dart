import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class userTips extends StatelessWidget {
  const userTips({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> tips = [
      "Did you know owning a 1000€ device \nfor 3 years costs 0,91€ a day?",
      "Finance without strategy is just numbers, \nand strategy without finance is just dreaming. \n~ E. Faber",
      "Money, like emotions, is something \nyou must control to keep \nyour life on the right track. \n~ Natasha Munson",
      "Financial freedom is a mental, \nemotional and educational process. \n~ Robert Kiyosaki",
      "A budget is telling your money \nwhere to go instead of \nwondering where it went. \n~ Dave Ramsey",
      "You must gain control over your money \nor the lack of it will forever control you. \n~ Dave Ramsey"
    ];
    tips.shuffle();
    print(tips);

    final device = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(
            textAlign: TextAlign.end,
            style: GoogleFonts.nunito(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: device.width * 0.015,
                fontWeight: FontWeight.w600,
              ),
            ),
            "${tips[0]}"),
      ),
    );
  }
}
