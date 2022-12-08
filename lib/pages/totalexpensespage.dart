// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:costlynew/pages/homepage.dart';
import 'package:costlynew/widgets/CPDAreaTotal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:costlynew/widgets/totalexpenses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:costlynew/pages/newExpenses.dart';

class TotalExpensesPage extends StatefulWidget {
  const TotalExpensesPage({Key? key}) : super(key: key);

  @override
  State<TotalExpensesPage> createState() => _TotalExpensesPageState();
}

class _TotalExpensesPageState extends State<TotalExpensesPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Column(children: [
            CPDAreaYearly(),
            SizedBox(
              height: 10,
            ),
            TransactionsAreaYearly()
          ]),
        ));
  }
}
