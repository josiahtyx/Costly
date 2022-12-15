// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use

import 'package:costlynew/data/data.dart';
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
  late bool _isLoading;

  void wait() async {
    _isLoading = true;
    funcSpent.getTotalSpent();
    totalSpent = funcSpent.getTotalSpent();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      }); // Prints after 1 second.
    });
  }

  @override
  void initState() {
    super.initState();
    wait();
    // getCPDtotal();
    // totalCPD = getCPDtotal();
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Flexible(
      child: Container(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Amount Spent \n(" + month + ")",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 28),
              ),
              FutureBuilder(
                future: totalSpent,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _isLoading
                        ? Text(
                            '0,00€',
                            style: GoogleFonts.nunito(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Text(
                            '${snapshot.data}€'.replaceAll(RegExp(r'\.'), ','),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                  } else {
                    return Text(
                      '0,00€',
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
