// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use

import 'package:costlynew/data/passerFunctions.dart';
import 'package:costlynew/widgets/CPDAreaMonthlyMobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:costlynew/widgets/sidebar.dart';

var funcSpent = GetTotalSpent();

class AssetsArea extends StatefulWidget {
  const AssetsArea({super.key});

  @override
  State<AssetsArea> createState() => _AssetsAreaState();
}

class _AssetsAreaState extends State<AssetsArea> {
  late Future<double> totalSpent;
  @override
  void initState() {
    super.initState();

    funcSpent.getTotalSpent();
    totalSpent = funcSpent.getTotalSpent();
    // getCPDtotal();
    // totalCPD = getCPDtotal();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 320,
        child: Column(
          children: [
            Text(
              "Total Spent (" + month + ")",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 28),
            ),
            FutureBuilder(
              future: totalSpent,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}€',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 54,
                      fontWeight: FontWeight.w800,
                    ),
                  );
                } else {
                  return Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
