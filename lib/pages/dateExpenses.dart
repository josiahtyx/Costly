// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:costlynew/widgets/CPDAreaAllTime.dart';
import 'package:costlynew/widgets/expensesAreaDaily.dart';
import 'package:costlynew/widgets/dayTotal.dart';
import 'package:costlynew/widgets/mobile/expensesAreaAllTimeMobile.dart';
import 'package:costlynew/widgets/expensesTableYearly.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:costlynew/widgets/expensesAreaAllTime.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:costlynew/pages/newExpenses.dart';

class DateExpenses extends StatefulWidget {
  const DateExpenses({Key? key}) : super(key: key);

  @override
  State<DateExpenses> createState() => _DateExpensesState();
}

class _DateExpensesState extends State<DateExpenses> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print(constraints.maxWidth);
        if (constraints.maxWidth > 1480) {
          return desktopAllTime(context);
        } else {
          return mobileAllTime(context);
        }
      },
    );
  }

  Widget desktopAllTime(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //Title section
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            tooltip: 'Back',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          title: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    ),
                child: Text('Costly')),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Monthly',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('There is no new notifications'),
                //   ),
                // );
              },
            ),
          ],
        ),
        body: Column(children: [
          DayTotal(),
          SizedBox(
            height: 10,
          ),
          DayTransactionsArea()
        ]));
  }

  Widget mobileAllTime(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //Title section
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            tooltip: 'Back',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          title: Text('Costly'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Monthly',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('There is no new notifications'),
                //   ),
                // );
              },
            ),
          ],
        ),
        body: Column(children: [
          DayTotal(),
          SizedBox(
            height: 10,
          ),
          DayTransactionsArea()
        ]));
  }
}
