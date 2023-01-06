// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:costlynew/pages/profile.dart';
import 'package:costlynew/pages/calculatorCPD.dart';
import 'package:costlynew/pages/allTimeExpenses.dart';
import 'package:costlynew/widgets/plannedpurchasesList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:costlynew/widgets/CPDAreaMonthlyMobile.dart';
import 'package:costlynew/widgets/mobile/expensesAreaMobile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:costlynew/pages/newExpenses.dart';

class PlannedPurchases extends StatefulWidget {
  const PlannedPurchases({Key? key}) : super(key: key);

  @override
  State<PlannedPurchases> createState() => _PlannedPurchasesState();
}

class _PlannedPurchasesState extends State<PlannedPurchases> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //Title section
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Profile Page',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          title: Text('My Plans'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.calculate_rounded),
              tooltip: 'Calculator',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CPDCalculator()),
                );
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('There is no new notifications'),
                //   ),
                // );
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month_rounded),
              tooltip: 'All-Time',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TotalExpensesPage()),
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
        body: Column(children: [PlannedPurchasesList()]));
  }
}
