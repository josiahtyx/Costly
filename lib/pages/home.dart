// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:costly/pages/accountpage.dart';
import 'package:costly/pages/homeYearly.dart';
import 'package:costly/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:costly/widgets/cpd_area.dart';
import 'package:costly/widgets/transactions_area.dart';
import 'package:costly/pages/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:costly/pages/addExpenses.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile Page',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
          ),
          title: Text('Costly'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.calendar_month_rounded),
              tooltip: 'All-Time',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePageYearly()),
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
          CPDArea(),
          SizedBox(
            height: 10,
          ),
          MediaQuery.removePadding(
              context: context, removeTop: true, child: TransactionsArea())
        ]));
  }
}
